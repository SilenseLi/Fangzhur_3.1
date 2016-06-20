//
//  FZCompleteViewController.h
//  Fangzhur
//
//  Created by --超-- on 14-7-18.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZRootTableViewController.h"
#import "FZServingOrderCell.h"
#import "TPFloatRatingView.h"

@interface FZCompleteViewController : FZRootTableViewController
<TPFloatRatingViewDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) FZServingOrderCell *orderCell;
@property (nonatomic, copy) NSString *orderID;

@end
