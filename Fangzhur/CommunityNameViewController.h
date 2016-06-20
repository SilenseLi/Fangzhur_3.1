//
//  SearchResultViewController.h
//  base
//
//  Created by isabella tong on 14-2-10.
//  Copyright (c) 2014年 wbw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZRootTableViewController.h"

@protocol ChooseCommunityDelegate <NSObject>

- (void)selectCommunityName:(NSString *)name communityID:(NSString *)communityID address:(NSString *)address;

@end

@interface CommunityNameViewController : FZRootTableViewController
<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property(nonatomic,assign) id<ChooseCommunityDelegate> nameDelegate;

@end
