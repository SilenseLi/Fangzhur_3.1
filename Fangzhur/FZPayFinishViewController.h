//
//  FZPayFinishViewController.h
//  Fangzhur
//
//  Created by fq on 15/1/7.
//  Copyright (c) 2015年 Zc. All rights reserved.
//

#import "FZRootTableViewController.h"

@interface FZPayFinishViewController : FZRootTableViewController
{
    UIWebView * webView;
}

@property (nonatomic, copy) NSString *paymentURLString;

@end
