//
//  FangZhurXieYiViewController.m
//  base
//
//  Created by isabella tong on 14-2-10.
//  Copyright (c) 2014年 wbw. All rights reserved.
//

#import "FangZhurXieYiViewController.h"

@interface FangZhurXieYiViewController ()

@end

@implementation FangZhurXieYiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"用户协议";
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(backToSubmit) position:POSLeft];
}
- (void)backToSubmit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
