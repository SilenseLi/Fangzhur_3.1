//
//  FZPhotoViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/12/2.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZPhotoViewController.h"
#import "AccelerometerManager.h"
#import "UzysAssetsPickerController.h"
#import "FZDisplayPhotoView.h"
#import "FZSubmitHouseViewController.h"
#import "ImageTool.h"

@interface FZPhotoViewController () <UzysAssetsPickerControllerDelegate>

@property (nonatomic, strong) UzysAssetsPickerController *photoPicker;
@property (nonatomic, strong) FZDisplayPhotoView *photoView;
@property (nonatomic, strong) UIButton *bottomButton;

//记录照片个数
@property (nonatomic, assign) NSInteger counter;
//存放要上传的照片
@property (nonatomic, strong) NSMutableArray *photoArray;
//记录照片地址，以逗号分开
@property (nonatomic, strong) NSMutableString *photoURLString;

- (void)configureUI;

@end

@implementation FZPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photoArray = [[NSMutableArray alloc] init];
    self.photoURLString = [[NSMutableString alloc] init];
    
    [self configureUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [JDStatusBarNotification dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI
{
    self.title = @"拍照";
    
    UIButton *backButton = [self addButtonWithImageName:@"fanhui_brn" target:self action:@selector(popViewController) position:POSLeft];
    backButton.contentMode = UIViewContentModeLeft;
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 350 - 64)];
    tipLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG"]];
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = kDefaultColor;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont fontWithName:kFontName size:16];
    tipLabel.text = @"晒出您的房子靓照，\n相信很多人会对它一见钟情!\n(请至少拍摄一张房屋照片)";
    [self.view addSubview:tipLabel];
    
    self.photoView = [[[NSBundle mainBundle] loadNibNamed:@"FZDisplayPhotoView" owner:self options:nil] lastObject];
    self.photoView.frame = CGRectMake(0, SCREEN_HEIGHT - 350, SCREEN_WIDTH, 350);
    [self.view addSubview:self.photoView];
    
    __weak typeof(self) weakSelf = self;
    [self.photoView setPhotoButtonHandler:^(UIButton *button) {
        //如果是0，代表点击进行图片选取；否则，代表点击进行图片浏览
        if ([button.titleLabel.text isEqualToString:@"0"]) {
            weakSelf.photoPicker.maximumNumberOfSelectionVideo = 0;
            weakSelf.photoPicker.maximumNumberOfSelectionPhoto = weakSelf.photoView.maximumNumber;
            [weakSelf presentViewController:weakSelf.photoPicker animated:YES completion:nil];
        }
        else {
            
        }
    }];
    
    self.bottomButton = kBottomButtonWithName(@"下一步");
    [self.bottomButton setTitle:@"上传中" forState:UIControlStateDisabled];
    [self.bottomButton addTarget:self action:@selector(gotoNextStep) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomButton];
    
    self.photoPicker = [[UzysAssetsPickerController alloc] init];
    self.photoPicker.delegate = self;
}

#pragma mark - UzysAssetsPickerControllerDelegate methods -

- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    DLog(@"assets %@", assets);
    
    if (assets.count != 0 && self.counter != 0) {
        [self.photoView resetPhotoButton];
        self.counter = 0;
    }
    
    __weak typeof(self) weakSelf = self;
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        ALAsset *representation = obj;
        UIImage *image = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                             scale:representation.defaultRepresentation.scale
                                       orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
        
#warning 如果打开缩放，会导致图片旋转，后期进行完善
//        image = [[ImageTool shareTool] resizeImage:image withSize:CGSizeMake(500, 500)];
        UIButton *button = (UIButton *)[weakSelf.photoView viewWithTag:weakSelf.counter + index + 1];
        //选择好图片后，设置button title = @“1” 以便区分点击状态
        [button setTitle:@"1" forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateNormal];
        
        if (index != weakSelf.photoView.maximumNumber - 1) {
            UIButton *nextButton = (UIButton *)[weakSelf.photoView viewWithTag:index + 2];
            nextButton.hidden = NO;
        }
        
        if (index == assets.count - 1) {
            weakSelf.counter = index + 1;
        }

        [self.photoArray addObject:image];
    }];
}

- (void)UzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"最多只能选择6张照片"
                                                   delegate:nil
                                          cancelButtonTitle:@"确认"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Reponse events -

static NSInteger photoNumber = 0;
- (void)gotoNextStep
{
    if (self.photoArray.count == 0) {
        [JDStatusBarNotification showWithStatus:@"请至少上传一张照片" dismissAfter:2 styleName:JDStatusBarStyleError];
        return;
    }
    
    photoNumber = 0;
    [self.photoURLString setString:@""];
    [JDStatusBarNotification showWithStatus:@"上传中，请稍等..."];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.bottomButton setEnabled:NO];
    
    [[FZRequestManager manager] uploadPhotosWithImages:self.photoArray complete:^(NSString *resultString) {
        if (!resultString) {
            [self.bottomButton setEnabled:NO];
            return;
        }
        
        photoNumber++;
        [self.photoURLString appendFormat:@"%@,", resultString];
        
        if (photoNumber == self.counter) {
            [JDStatusBarNotification dismiss];
            [self.bottomButton setEnabled:YES];
            
            if (self.photoURLString.length != 0) {
                [self.paramDict setObject:[self.photoURLString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]] forKey:@"house_picture_url"];
            }
            
            
            FZSubmitHouseViewController *submitViewController = [[FZSubmitHouseViewController alloc] init];
            submitViewController.paramDict = self.paramDict;
            submitViewController.releaseModel = self.releaseModel;
            [self.navigationController pushViewController:submitViewController animated:YES];
        }
    }];
    
    
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
