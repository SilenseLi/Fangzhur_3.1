//
//  FZDisplayPhotoView.h
//  Fangzhur
//
//  Created by --超-- on 14/12/3.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZDisplayPhotoView : UIView

@property (nonatomic, readonly) NSInteger maximumNumber;
@property (nonatomic, copy) void (^photoButtonHandler)(UIButton *photoButton);

- (IBAction)photoButtonClicked:(UIButton *)sender;
- (void)resetPhotoButton;

@end
