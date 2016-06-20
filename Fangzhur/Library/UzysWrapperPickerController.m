//
//  UzysWrapperPickerController.m
//  IdolChat
//
//  Created by Uzysjung on 2014. 1. 28..
//  Copyright (c) 2014년 SKPlanet. All rights reserved.
//

#import "UzysWrapperPickerController.h"

@interface UzysWrapperPickerController ()

@end

@implementation UzysWrapperPickerController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -  View Controller Setting /Rotation
-(BOOL)shouldAutorotate
{
    return YES;
}
- (UIViewController *)childViewControllerForStatusBarHidden
{
    return nil;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}



//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscapeLeft;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeLeft;
//}
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

@end
