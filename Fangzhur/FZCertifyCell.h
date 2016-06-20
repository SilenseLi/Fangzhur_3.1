//
//  FZCertifyCell.h
//  Fangzhur
//
//  Created by --Chao-- on 14-7-2.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZCertifyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *identityImageView;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIButton *identityButton;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

- (void)addTarget:(id)target action:(SEL)action;
- (IBAction)uploadPicture:(UIButton *)sender;

/**
 *  @param status 1-审核成功  2-待审核   3-未上传
 */
- (void)updateHeadImage:(NSString *)imageURL buttonStatus:(NSString *)status;
/**
 *  @param status 1-审核成功  2-待审核   3-未上传
 */
- (void)updateIdentityImage:(NSString *)imageURL buttonStatus:(NSString *)status;
- (void)fixImageViews;

@end
