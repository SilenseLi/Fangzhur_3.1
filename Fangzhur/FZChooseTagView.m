//
//  FZChooseTagView.m
//  Fangzhur
//
//  Created by --超-- on 14/11/17.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZChooseTagView.h"
#import "UIButton+ZCCustomButtons.h"
#import "NZLabel.h"

#define kMargin 20
#define kTagWidth 60
#define kTagHeight 30
#define kSpacing (SCREEN_WIDTH - (kTagWidth * 4) - kMargin * 2) / 3

@interface FZChooseTagView ()

@property (nonatomic, strong) NSArray *tags;

@end

@implementation FZChooseTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self configureControls];
        _selectedTags = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)configureControls
{
    self.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height + 50);
    self.showsVerticalScrollIndicator = NO;
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, SCREEN_WIDTH, 20)];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textColor = kDefaultColor;
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = [UIFont fontWithName:kFontName size:17];
    topLabel.text = @"选择您喜欢的标签";
    [self addSubview:topLabel];
    
    NZLabel *illustrateLabel = nil;
    if (kScreenScale == 3) {
        illustrateLabel =[[NZLabel alloc] initWithFrame:CGRectMake(kMargin, 130 + (kSpacing * 4) + kAdjustScale, SCREEN_WIDTH - (kMargin * 2), 150)];
    }
    else {
        illustrateLabel = [[NZLabel alloc] initWithFrame:CGRectMake(kMargin, 160 + (kTagHeight * 4) + kAdjustScale, SCREEN_WIDTH - (kMargin * 2), 150)];
    }
    [self addSubview:illustrateLabel];
    
    illustrateLabel.text = @"贴标签找房主让家的选择更贴心，优质顾问帮您轻松安全完成交易。";
    illustrateLabel.backgroundColor = [UIColor clearColor];
    illustrateLabel.numberOfLines = 0;
    illustrateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    illustrateLabel.font = [UIFont fontWithName:kFontName size:15];
    
    self.startButton = [UIButton buttonWithFrame:CGRectMake(40, 280 + (kTagHeight * 5) + kAdjustScale, SCREEN_WIDTH - 80, 35) title:@"开   始" fontSize:17 bgImageName:@"kaishi_btn"];
    [self addSubview:self.startButton];
}

- (void)addTags:(NSArray *)tags
{
    self.tags = tags;
    NSMutableDictionary *tagDictionary = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 4; j++) {
            NSDictionary *tagDict = [self.tags objectAtIndex:(i * 4 + j)];
            [tagDictionary setObject:[tagDict objectForKey:@"name"] forKey:[tagDict objectForKey:@"id"]];
            
            if (i == 4 && j == 3) {
                continue;
            }
            UIButton *tagButton = [UIButton buttonWithFrame:CGRectMake(kMargin + (kTagWidth + kSpacing) * j, 75 + (kTagHeight + kSpacing + 5) * i, kTagWidth, kTagHeight) title:[tagDict objectForKey:@"name"] fontSize:13 bgImageName:@"biaoqian_bg"];
            [self addSubview:tagButton];
            
            tagButton.tag = [[tagDict objectForKey:@"id"] integerValue];
            [tagButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [tagButton addTarget:self action:@selector(tagButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:tagDictionary forKey:Key_TagDictionary];
}

- (void)tagButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [_selectedTags addObject:@(sender.tag)];
        [_selectedTags addObject:sender.titleLabel.text];
    }
    else {
        [_selectedTags removeObject:@(sender.tag)];
        [_selectedTags removeObject:sender.titleLabel.text];
    }
}

@end
