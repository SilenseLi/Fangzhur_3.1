//
//  FZMessageViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/12/11.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZMessageViewController.h"
#import "ContentManager.h"
#import "Message.h"
#import "FZNavigationController.h"
#import "UIButton+ZCCustomButtons.h"
#import <EGOCache.h>
#import "FZSignHouseViewController.h"

//TODO:从房源详情进行私信的缓存规则：接受者member id，房源id，房源类型
#define CacheKey [NSString stringWithFormat:@"%@-%@-%@",\
FZUserInfoWithKey(Key_MemberID),\
self.detailModel.houseID,\
self.detailModel.houseType]

@interface FZMessageViewController ()
<UIScrollViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) UIImage *partnerImage;
@property (nonatomic, strong) SOMessageCell *senderMessageCell;

@property (nonatomic, copy) NSString *sender_id;// 如果发送者id与房东id相同时，用于存放发送者id
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *cacheArray;
@property (nonatomic, strong) NSTimer *timer;

- (void)configureUI;

@end

@implementation FZMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.myImage      = [UIImage imageNamed:@"moren_touxiang"];
    self.partnerImage = [UIImage imageNamed:@"moren_touxiang"];
    self.dataSource = [[NSMutableArray alloc] init];
    self.cacheArray = [[NSMutableArray alloc] init];
    
    if (![[EGOCache globalCache] plistForKey:CacheKey]) {
        [[EGOCache globalCache] setPlist:[NSArray array] forKey:CacheKey withTimeoutInterval:NSNotFound];
    }
    else {
        NSArray *tempArray = [[EGOCache globalCache] plistForKey:CacheKey];
        [self.cacheArray addObjectsFromArray:tempArray];
        if (self.cacheArray.count > 50) {
            [self.cacheArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 20)]];
        }
        [self.dataSource addObjectsFromArray:[[ContentManager sharedManager]
                                              generateConversationWithChatArray:self.cacheArray]];
        self.sender_id = [self.cacheArray.lastObject objectForKey:@"sender_id"];
    }
    
    [self loadMessages];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(loadMessages) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureUI];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
    //在离开聊天界面的时候再进行缓存，提高效率
    [[EGOCache globalCache] setPlist:self.cacheArray forKey:CacheKey withTimeoutInterval:NSNotFound];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[EGOCache globalCache] setPlist:self.cacheArray forKey:CacheKey withTimeoutInterval:NSNotFound];
    [self.timer invalidate];
}

- (void)loadMessages
{
    [[FZRequestManager manager] receiveMessageWithAction:@"my_msg" receiver:FZUserInfoWithKey(Key_MemberID) sender:nil houseID:self.detailModel.houseID houseType:self.detailModel.houseType complete:^(BOOL success, NSArray *chatArray, id responseObject) {
        if (chatArray) {
            self.sender_id = [chatArray.lastObject objectForKey:@"sender_id"];
            [self.cacheArray addObjectsFromArray:chatArray];
            [self.dataSource addObjectsFromArray:[[ContentManager sharedManager]
                                                  generateConversationWithChatArray:chatArray]];
        }
    }];
}

- (void)configureUI
{
    if ([self.detailModel.owner_name isEqualToString:@"房主爱称：保密"]) {
        [self.navigationController performSelector:@selector(addTitle:) withObject:@"私信"];
    }
    else {
        [self.navigationController performSelector:@selector(addTitle:)
                                        withObject:[self.detailModel.owner_name stringByTrimmingCharactersInSet:
                                                    [NSCharacterSet characterSetWithCharactersInString:@"房主爱称："]]];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame     = CGRectMake(0, 0, 44, 44);
    [button setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"fanhui_h"]
            forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    button.contentMode = UIViewContentModeCenter;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = buttonItem;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    
    NSArray *titles = @[@"签约", @"举报"];
    NSMutableArray *buttonItems = [NSMutableArray array];
    for (NSString *title in titles) {
        UIButton *button = [UIButton buttonWithFrame:CGRectMake(0, 0, 40, 30) title:title fontSize:17 bgImageName:nil];
        button.tag       = buttonItems.count;
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
        [button setTitleColor:kDefaultColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightBarButtonsClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [buttonItems addObject:buttonItem];
    }
    self.navigationItem.rightBarButtonItems = buttonItems;
}

#pragma mark - SOMessaging data source

- (NSMutableArray *)messages
{
    return self.dataSource;
}

- (NSTimeInterval)intervalForMessagesGrouping
{
    // Return 0 for disableing grouping
    // 每五分钟显示一次时间
    return 2 * 60;
}

- (void)configureMessageCell:(SOMessageCell *)cell forMessageAtIndex:(NSInteger)index
{
    Message *message = self.dataSource[index];
    cell.tag = index;
    
    // Adjusting content for 3pt. (In this demo the width of bubble's tail is 3pt)
    if (!message.fromMe) {
        cell.contentInsets = UIEdgeInsetsMake(0, 3.0f, 0, 0); //Move content for 3 pt. to right
        cell.textView.textColor = [UIColor blackColor];
    }
    else {
        cell.contentInsets = UIEdgeInsetsMake(0, 0, 0, 3.0f); //Move content for 3 pt. to left
        cell.textView.textColor = [UIColor whiteColor];
        
        // 防止对前面的cell进行误操作
        if (self.senderMessageCell.tag < cell.tag) {
            self.senderMessageCell = cell;
            [cell.resendButton addTarget:self action:@selector(resendMessage:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    cell.userImageView.layer.cornerRadius = self.userImageSize.width / 2;
    cell.userImageView.backgroundColor = [UIColor blackColor];
    // Fix user image position on top or bottom.
    cell.userImageView.autoresizingMask = message.fromMe ? UIViewAutoresizingFlexibleTopMargin : UIViewAutoresizingFlexibleBottomMargin;
    // Setting user images
    cell.userImage = message.fromMe ? self.myImage : self.partnerImage;
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (CGFloat)messageMaxWidth
{
    return 150;
}

- (CGSize)userImageSize
{
    return CGSizeMake(50, 50);
}

- (CGFloat)messageMinHeight
{
    return 0;
}

- (CGFloat)balloonMinHeight
{
    return 21;
}

#pragma mark - SOMessaging delegate

- (void)didSelectMedia:(NSData *)media inMessageCell:(SOMessageCell *)cell
{
    // Show selected media in fullscreen
//    [super didSelectMedia:media inMessageCell:cell];
}

- (void)messageInputView:(SOMessageInputView *)inputView didSendMessage:(NSString *)message
{
    if (![[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return;
    }
    
    if ([self.detailModel.broker_id isEqualToString:FZUserInfoWithKey(Key_MemberID)] && !self.sender_id) {
        [JDStatusBarNotification showWithStatus:@"请不要自言自语" dismissAfter:2 styleName:JDStatusBarStyleError];
        
        return;
    }
    
    Message *msg = [[Message alloc] init];
    msg.text = message;
    msg.fromMe = YES;
    [self sendMessage:msg];
    
    self.inputView.sendButton.enabled = NO;
    [self.senderMessageCell.loadingView startAnimating];
    self.senderMessageCell.hidden = YES;

    [[FZRequestManager manager] sendMessage:message ofHouseID:self.detailModel.houseID houseType:self.detailModel.houseType from:FZUserInfoWithKey(Key_MemberID) to:self.sender_id receiverPhone:self.detailModel.owner_phone complete:^(BOOL success, id responseObject) {
        [self.senderMessageCell.loadingView stopAnimating];
        self.inputView.sendButton.enabled = YES;
        
        if (success) {
            NSString *dateString = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
            NSDictionary *chatDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @(YES), @"fromMe",
                                      message, @"message",
                                      @"SOMessageTypeText", @"type",
                                      dateString, @"date",
                                      FZUserInfoWithKey(Key_UserName), @"username",
                                      self.sender_id, @"sender_id", nil];
            [self.cacheArray addObject:chatDict];
        }
        else {
            self.senderMessageCell.resendButton.hidden = NO;
        }
    }];
}

- (void)messageInputViewDidSelectMediaButton:(SOMessageInputView *)inputView
{
    // Take a photo/video or choose from gallery
}

#pragma mark - 举报 -

- (void)reportAction
{
    UIActionSheet *appraiseSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"是房主", @"未接通", @"已成交", @"错误房源", @"中介冒充房东", nil];
    appraiseSheet.tintColor = kDefaultColor;
    [appraiseSheet showInView:self.view];
    
    //一定要在评价窗口弹出后，取消观察者，防止其他通知，激活观察者执行错误的方法
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 5) {
        return;
    }
    
    [[FZRequestManager manager] appraiseHouseWithHouseID:self.detailModel.houseID houseType:self.detailModel.houseType appraiseType:[NSString stringWithFormat:@"%d", (buttonIndex + 1)] complete:^(BOOL success, id responseObject) {
        if (success) {
            [JDStatusBarNotification showWithStatus:@"提交成功" dismissAfter:2];
        }
    }];
}

#pragma mark - Responds events -

- (void)resendMessage:(UIButton *)sender
{
    self.senderMessageCell = (SOMessageCell *)sender.superview.superview;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"发送失败, 重新发送?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alertView.delegate = self;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.senderMessageCell.resendButton.hidden = YES;
        [self.senderMessageCell.loadingView startAnimating];
        self.inputView.sendButton.enabled = NO;
        
        [[FZRequestManager manager] sendMessage:self.senderMessageCell.message.text ofHouseID:self.detailModel.houseID houseType:self.detailModel.houseType from:FZUserInfoWithKey(Key_MemberID) to:self.detailModel.broker_id receiverPhone:self.detailModel.owner_phone complete:^(BOOL success, id responseObject) {
            [self.senderMessageCell.loadingView stopAnimating];
            self.inputView.sendButton.enabled = YES;
            
            if (success) {
            }
            else {
                self.senderMessageCell.resendButton.hidden = NO;
            }
        }];
    }
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonsClicked:(UIButton *)sender
{
    if (sender.tag == 0) {
        FZSignHouseViewController *signViewController = [[FZSignHouseViewController alloc] init];
        signViewController.houseType = self.detailModel.houseType;
        signViewController.houseNumber = self.detailModel.house_no;
        signViewController.detailModel = self.detailModel;
        [self.navigationController pushViewController:signViewController animated:YES];
    }
    else {
        [self reportAction];
    }
}

@end
