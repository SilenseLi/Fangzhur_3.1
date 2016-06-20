//
//  FZOfficialViewController.m
//  Fangzhur
//
//  Created by --超-- on 14/12/20.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZOfficialViewController.h"
#import "ContentManager.h"
#import "Message.h"
#import "FZNavigationController.h"
#import "UIButton+ZCCustomButtons.h"
#import <SDWebImageManager.h>

@interface FZOfficialViewController () <UIAlertViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) UIImage *partnerImage;
@property (nonatomic, strong) SOMessageCell *senderMessageCell;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic, strong) NSTimer *timer;

- (void)configureUI;

@end

@implementation FZOfficialViewController

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myImage      = [UIImage imageNamed:@"moren_touxiang"];
    self.partnerImage = [UIImage imageNamed:@"officialLogo"];
    self.dataSource = [[NSMutableArray alloc] init];
    
    Message *firstMessage = [[Message alloc] init];
    firstMessage.text = @"您好，很高兴您能使用房主儿网App，有什么问题可以直接在这里进行提问，我们会帮您解决所有问题。";
    [self receiveMessage:firstMessage];
    
    [self loadAllMessages];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)configureUI
{
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"官方"];
    
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
}

- (void)loadAllMessages
{
    [[FZRequestManager manager] receiveMessageWithAction:@"my_all_msg"
                                                receiver:FZUserInfoWithKey(Key_MemberID)
                                                  sender:@"1"
                                                 houseID:@"-1"
                                               houseType:@"-1"
                                                complete:^(BOOL success, NSArray *chatArray, id responseObject) {
                                                    
                                                    if (chatArray) {
                                                        [self.dataSource addObjectsFromArray:[[ContentManager sharedManager]
                                                                                              generateConversationWithChatArray:chatArray]];
                                                        [self refreshMessages];
                                                    }
                                                }];
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
    Message *msg = [[Message alloc] init];
    msg.text = message;
    msg.fromMe = YES;
    [self sendMessage:msg];
    
    self.inputView.sendButton.enabled = NO;
    [self.senderMessageCell.loadingView startAnimating];
    self.senderMessageCell.hidden = YES;

    [[FZRequestManager manager] sendMessage:message ofHouseID:@"0" houseType:@"0" from:FZUserInfoWithKey(Key_MemberID) to:@"1" receiverPhone:nil complete:^(BOOL success, id responseObject) {
        [self.senderMessageCell.loadingView stopAnimating];
        self.inputView.sendButton.enabled = YES;
        
        if (success) {
            Message *replyMessage = [[Message alloc] init];
            replyMessage.text = @"感谢您的提问，我们会尽快给您回复。";
            [self receiveMessage:replyMessage];
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
        
        [[FZRequestManager manager] sendMessage:self.senderMessageCell.message.text ofHouseID:@"-1" houseType:@"-1" from:FZUserInfoWithKey(Key_MemberID) to:@"1" receiverPhone:nil complete:^(BOOL success, id responseObject) {
            [self.senderMessageCell.loadingView stopAnimating];
            self.inputView.sendButton.enabled = YES;
            
            if (success) {
                Message *replyMessage = [[Message alloc] init];
                replyMessage.text = @"小主儿，您的消息已送达，请耐心等待吧！";
                [self receiveMessage:replyMessage];
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

@end
