//
//  FZCompleteViewController.m
//  Fangzhur
//
//  Created by --超-- on 14-7-18.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZCompleteViewController.h"
#import "FZOrdersViewController.h"
#import "FZHTTPRequest.h"

@interface FZCompleteViewController ()
{
    NSMutableArray *_starsArray;
    UITextView *_textView;
    UILabel *_placeholder;
    FZHTTPRequest *_request;
}

- (void)UIConfig;

@end

@implementation FZCompleteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self UIConfig];
    _starsArray = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"确认并评价"];
    [self addButtonWithImage:[UIImage imageNamed:@"fanhui"] target:self action:@selector(backToOrderList) position:POSLeft];
    
    self.orderCell.commentButton.hidden = YES;
    self.orderCell.informButton.hidden  = YES;
    self.orderCell.seperatedLine.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.orderCell.commentButton.hidden = NO;
    self.orderCell.informButton.hidden  = NO;
    self.orderCell.seperatedLine.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)UIConfig
{
    UIView *view =
    [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.orderCell.bounds) - 60)];
    view.clipsToBounds = YES;
    [view addSubview:self.orderCell];
    self.tableView.tableHeaderView = view;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addRatingView];
}

- (FZServingOrderCell *)orderCell
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:_orderCell]];
}

- (void)backToOrderList
{
    [_textView resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addRatingView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 500)];
    
    NSArray *titles = @[@"专业知识", @"服务态度", @"工作效率", @"沟通能力"];
    for (int i = 0; i < titles.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + (40 * i), 60, 21)];
        titleLabel.text     = [titles objectAtIndex:i];
        titleLabel.font     = [UIFont systemFontOfSize:15];
        [view addSubview:titleLabel];
        
        TPFloatRatingView *ratingView = [[TPFloatRatingView alloc] initWithFrame:CGRectMake(95, 10 + (40 * i), 200, 21)];
        ratingView.delegate = self;
        ratingView.tag = i;
        ratingView.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
        ratingView.fullSelectedImage = [UIImage imageNamed:@"StarFull"];
        ratingView.contentMode = UIViewContentModeScaleAspectFill;
        ratingView.maxRating = 5;
        ratingView.minRating = 1;
        ratingView.rating = 0;
        ratingView.editable = YES;
        ratingView.halfRatings = NO;
        ratingView.floatRatings = NO;

        [view addSubview:ratingView];
    }
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 170, SCREEN_WIDTH - 40, 100)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.delegate = self;
    _textView.text = @"";
    
    _placeholder           = [[UILabel alloc] initWithFrame:_textView.frame];
    _placeholder.text      = @"您的评价对交易顾问在房主儿平台上的发展非常重要，也对其他用户选择顾问时产生重要影响，请您给予客观而真实的评价。请输入10字以上的评价!\n\n";
    _placeholder.font      = [UIFont systemFontOfSize:13];
    _placeholder.textColor = [UIColor lightGrayColor];
    _placeholder.backgroundColor = [UIColor clearColor];
    _placeholder.numberOfLines   = 0;
    _placeholder.lineBreakMode   = NSLineBreakByWordWrapping;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:_textView.frame];
    bgImageView.image        = [UIImage imageNamed:@"pic_shur"];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(20, 300, SCREEN_WIDTH - 40, 35);
    [submitButton setBackgroundImage:[UIImage imageNamed:@"AnNiu3"] forState:UIControlStateNormal];
    [submitButton setTitle:@"确认完成服务" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(completeOrder) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:submitButton];
    
    [view addSubview:bgImageView];
    [view addSubview:_placeholder];
    [view addSubview:_textView];
    
    self.tableView.tableFooterView = view;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_placeholder removeFromSuperview];
    [self.tableView setContentOffset:CGPointMake(0, 420) animated:YES];
}

#pragma mark - TPFloatRatingViewDelegate

- (void)floatRatingView:(TPFloatRatingView *)ratingView ratingDidChange:(CGFloat)rating
{
    [_starsArray setObject:[NSString stringWithFormat:@"%d", (int)rating] atIndexedSubscript:ratingView.tag];
}

- (void)floatRatingView:(TPFloatRatingView *)ratingView continuousRating:(CGFloat)rating
{
    [_starsArray setObject:[NSString stringWithFormat:@"%d", (int)rating] atIndexedSubscript:ratingView.tag];
}

#pragma mark - 网络请求 -


- (void)completeOrder
{
    if (_textView.text.length < 10) {
        [JDStatusBarNotification showWithStatus:@"请输入10字以上的评论" dismissAfter:2 styleName:JDStatusBarStyleError];
        [_textView becomeFirstResponder];
        return;
    }
    
    [JDStatusBarNotification showWithStatus:@"提交中，请稍后..."];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    
    _request = [[FZHTTPRequest alloc] initWithURLString:URLStringByAppending(kCompleteService) cacheInterval:0];
    [_request addTarget:self action:@selector(requestFinished:)];
    [_request startPostWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                       _textView.text, @"pl_content",
                                       [_starsArray objectAtIndex:0], @"pl_zy",
                                       [_starsArray objectAtIndex:1], @"pl_fw",
                                       [_starsArray objectAtIndex:2], @"pl_xl",
                                       [_starsArray objectAtIndex:3], @"pl_gt",
                                       _orderID, @"id",
                                       FZUserInfoWithKey(Key_LoginToken), @"token",
                                       FZUserInfoWithKey(Key_MemberID), @"member_id",
                                       FZUserInfoWithKey(Key_UserName), @"username", nil]];
}

- (void)requestFinished:(FZHTTPRequest *)request
{
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    
    if (request.error) {
        [JDStatusBarNotification showWithStatus:@"提交失败，请稍后重试!" dismissAfter:2 styleName:JDStatusBarStyleError];
        return;
    }
    
    if (request.downloadedData) {
        [JDStatusBarNotification showWithStatus:@"提交成功" dismissAfter:2];
        
        id resultData = [NSJSONSerialization JSONObjectWithData:request.downloadedData options:NSJSONReadingMutableContainers error:nil];
        if ([resultData isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDict = (NSDictionary *)resultData;
            if ([[resultDict objectForKey:@"fanhui"] intValue] == 1) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"您已完成订单%@的确认和评价，请在完成的订单中查看", _orderCell.orderNumLabel.text] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                alertView.delegate = self;
                [alertView show];
            }
            else {
                [JDStatusBarNotification showWithStatus:@"提交失败，请等待顾问进行确认" dismissAfter:2 styleName:JDStatusBarStyleError];
            }
        }
        else {
            NSLog(@"%@", [[NSString alloc] initWithData:request.downloadedData encoding:NSUTF8StringEncoding]);
        }
    }
    else {
        [JDStatusBarNotification showWithStatus:@"服务器繁忙，请稍后重试!" dismissAfter:2 styleName:JDStatusBarStyleError];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self backToOrderList];
}

@end
