//
//  FZChattingViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/12/19.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZChattingViewController.h"
#import "ContentManager.h"
#import "Message.h"
#import "FZNavigationController.h"
#import "UIButton+ZCCustomButtons.h"
#import "FZHouseDetailViewController.h"

@interface FZChattingViewController () <UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) SOMessageCell *senderMessageCell;
@property (nonatomic, strong) FZWaitingView *waitingView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic, strong) NSTimer *timer;

- (void)configureUI;

@end

@implementation FZChattingViewController

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.myImage      = [UIImage imageNamed:@"moren_touxiang"];
        self.partnerImage = [UIImage imageNamed:@"moren_touxiang"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    //必须在这里请求，否则拿不到房源数据
    [self loadAllMessages];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(loadNewMessages) userInfo:nil repeats:YES];
    
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"私信"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self.timer invalidate];
}

- (void)configureUI
{
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
    
    NSArray *titles = @[@"房源", @"举报"];
    NSMutableArray *buttonItems = [NSMutableArray array];
    for (NSString *title in titles) {
        UIButton *button = [UIButton buttonWithFrame:CGRectMake(0, 0, 40, 30) title:title fontSize:17 bgImageName:nil];
        button.tag       = buttonItems.count;
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightBarButtonsClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [buttonItems addObject:buttonItem];
    }
    self.navigationItem.rightBarButtonItems = buttonItems;
    
    self.waitingView = [[FZWaitingView alloc] init];
    [self.view addSubview:self.waitingView];
}

- (void)loadAllMessages
{
    [[FZRequestManager manager] receiveMessageWithAction:@"my_all_msg"
                                                receiver:FZUserInfoWithKey(Key_MemberID)
                                                  sender:self.sender_id
                                                 houseID:self.house_id
                                               houseType:self.house_type
                                                complete:^(BOOL success, NSArray *chatArray, id responseObject) {
                                                    [self.waitingView hide];
                                                    
                                                    if (chatArray) {
                                                        [self.dataSource addObjectsFromArray:[[ContentManager sharedManager]
                                                                                              generateConversationWithChatArray:chatArray]];
                                                        [self refreshMessages];
                                                    }
                                                }];
}

- (void)loadNewMessages
{
    [[FZRequestManager manager] receiveMessageWithAction:@"my_msg"
                                                receiver:FZUserInfoWithKey(Key_MemberID)
                                                  sender:self.sender_id
                                                 houseID:self.house_id
                                               houseType:self.house_type
                                                complete:^(BOOL success, NSArray *chatArray, id responseObject) {
                                                    if (chatArray) {
                                                        self.sender_id = [chatArray.lastObject objectForKey:@"sender_id"];
                                                        [self.dataSource addObjectsFromArray:[[ContentManager sharedManager]
                                                                                              generateConversationWithChatArray:chatArray]];
                                                        [self refreshMessages];
                                                    }
                                                }];
}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (self.timer.valid && self.dataSource) {
//        [self.timer setFireDate:[NSDate distantFuture]];
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self.timer setFireDate:[NSDate distantPast]];
//}

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
    
    Message *msg = [[Message alloc] init];
    msg.text = message;
    msg.fromMe = YES;
    msg.thumbnail = self.myImage;
    [self sendMessage:msg];
    
    self.inputView.sendButton.enabled = NO;
    [self.senderMessageCell.loadingView startAnimating];
    self.senderMessageCell.hidden = YES;
    
    [[FZRequestManager manager] sendMessage:message ofHouseID:self.house_id houseType:self.house_type from:FZUserInfoWithKey(Key_MemberID) to:self.sender_id receiverPhone:nil complete:^(BOOL success, id responseObject) {
        [self.senderMessageCell.loadingView stopAnimating];
        self.inputView.sendButton.enabled = YES;
        
        if (success) {
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
    
        [[FZRequestManager manager] appraiseHouseWithHouseID:self.house_id houseType:self.house_type appraiseType:[NSString stringWithFormat:@"%d", (buttonIndex + 1)] complete:^(BOOL success, id responseObject) {
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
        
        [[FZRequestManager manager] sendMessage:self.senderMessageCell.message.text ofHouseID:self.house_id houseType:self.house_type from:FZUserInfoWithKey(Key_MemberID) to:self.sender_id receiverPhone:nil complete:^(BOOL success, id responseObject) {
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
        FZHouseDetailViewController *detailViewController = [[FZHouseDetailViewController alloc] init];
        detailViewController.detailModel.houseType = self.house_type;
        detailViewController.detailModel.houseID = self.house_id;
        detailViewController.houseType = self.house_type;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else {
        [self reportAction];
    }
}


@end
