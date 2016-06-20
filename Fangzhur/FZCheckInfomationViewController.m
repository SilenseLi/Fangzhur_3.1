//
//  FZCheckInfomationViewController.m
//  Fangzhur
//
//  Created by --Chao-- on 14-7-2.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZCheckInfomationViewController.h"
#import "FZCertifyCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ImageTool.h"
#import "FZMobileLoginViewController.h"

@interface FZCheckInfomationViewController ()
{
    FZCertifyCell *_certifyCell;
    UIImage *_choosedImage;
    NSInteger _selectedButtonIndex;
}

@property (nonatomic, strong) NSDictionary *resultDict;

- (void)UIConfig;

@end

@implementation FZCheckInfomationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self UIConfig];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"资料认证"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(backToUserCenter) position:POSLeft];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)UIConfig
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delaysContentTouches = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"FZCertifyCell" bundle:nil]
         forCellReuseIdentifier:@"FZCertifyCell"];
}

- (void)backToUserCenter
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Alert view delegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    FZLoginViewController *loginController = [[FZLoginViewController alloc] init];
    [self presentViewController:loginController animated:YES completion:nil];
}

#pragma mark - Table view delegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 440;
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZCertifyCell *certifyCell = [tableView dequeueReusableCellWithIdentifier:@"FZCertifyCell"];
    _certifyCell = certifyCell;
    [certifyCell addTarget:self action:@selector(uploadPicture:)];
    
    return certifyCell;
}

#pragma mark - 上传照片 -

- (void)uploadPicture:(FZCertifyCell *)cell
{
    _selectedButtonIndex = cell.selectedIndex;
    _certifyCell = cell;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self
                                                    cancelButtonTitle:@"取消" destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册选择", nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.navigationBar.backgroundColor = [UIColor blackColor];
    if (buttonIndex == 2) {
        return;
    }
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(__bridge NSString *)kUTTypeImage, nil];
            imagePicker.allowsEditing = YES;//允许编辑
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
    else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

//图片选择完成，更新显示，并开始上传
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    _choosedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [[ImageTool shareTool] resizeImage:_choosedImage withSize:CGSizeMake(100, 100)];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [JDStatusBarNotification showWithStatus:@"上传中..."];
        [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        if ([mediaType isEqualToString:(__bridge NSString *)kUTTypeImage])
        {
            NSString *imageType = nil;
            UIImageView *imageView = nil;
            if (_selectedButtonIndex == 1) {
                imageType = @"avatar";
                imageView = _certifyCell.headImageView;
            }
            else {
                imageType = @"identity";
                imageView = _certifyCell.identityImageView;
            }
            
            [[FZRequestManager manager] uploadImage:_choosedImage imageType:imageType complete:^(BOOL success, id responseObject) {
                if (success) {
                    [JDStatusBarNotification showWithStatus:@"上传成功! 审核中..." dismissAfter:2];
                    imageView.image = _choosedImage;
                }
                else {
                    [JDStatusBarNotification showWithStatus:@"上传失败, 请重新上传" dismissAfter:2 styleName:JDStatusBarStyleError];
                }
            }];
        }
    }];
}

@end
