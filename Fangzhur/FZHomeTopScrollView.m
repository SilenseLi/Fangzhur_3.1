//
//  FZHomeTopScrollView.m
//  Fangzhur
//
//  Created by --超-- on 14/11/2.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "FZHomeTopScrollView.h"
#import "FZFavouriteHouseView.h"

#define VIEW_WIDTH CGRectGetWidth(self.bounds)
#define VIEW_HEIGHT CGRectGetHeight(self.bounds)

@interface FZHomeTopScrollView ()

@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, strong) NSMutableArray *contentViews;
@property (nonatomic, readonly) NSTimeInterval animationInterval;
@property (nonatomic, strong) UIPageControl *pageControl;

/** 启动定时器调用，开始自动进行轮播 */
- (void)animationTimerDidFire:(NSTimer *)timer;

/** 滚动后，将原来的三个视图移除，添加新的视图组，保证显示出来的视图，永远处于中间的位置 */
- (void)configureContentViews;
/** 设置视图组的数据源 */
- (void)setScrollViewDataSource;
/** 获取指定页标的索引 */
- (NSInteger)validateNextPageIndexWithPageIndex:(NSInteger)pageIndex;

@end

@implementation FZHomeTopScrollView

- (void)awakeFromNib
{
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                           target:self
                                                         selector:@selector(animationTimerDidFire:)
                                                         userInfo:nil
                                                          repeats:YES];
    [self.animationTimer pauseTimer];
    _animationInterval = 4;
    
    self.clipsToBounds = YES;
    if (self.bounds.size.width != SCREEN_WIDTH) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.bounds))];
    }
    else {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    }
    
    _scrollView.scrollsToTop = NO;
    _scrollView.contentMode = UIViewContentModeCenter;
    _scrollView.contentSize = CGSizeMake(3 * VIEW_WIDTH, VIEW_HEIGHT);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentOffset = CGPointMake(VIEW_WIDTH, 0);
    [self addSubview:_scrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT - 30, VIEW_WIDTH, 20)];
    self.pageControl.hidesForSinglePage = YES;
    [self addSubview:self.pageControl];
}

- (instancetype)initWithFrame:(CGRect)frame duration:(NSTimeInterval)interval
{
    self = [super initWithFrame:frame];
    
    if (self) {
        if (interval > 0) {
            self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                                   target:self
                                                                 selector:@selector(animationTimerDidFire:)
                                                                 userInfo:nil
                                                                  repeats:YES];
            [self.animationTimer pauseTimer];
        }
        _animationInterval = interval;
        
        self.clipsToBounds = YES;
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.scrollsToTop = NO;
        _scrollView.contentMode = UIViewContentModeCenter;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.contentOffset = CGPointMake(VIEW_WIDTH, 0);
        _scrollView.contentSize = CGSizeMake(3 * VIEW_WIDTH, VIEW_HEIGHT);
        [self addSubview:_scrollView];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT - 30, VIEW_WIDTH, 20)];
        self.pageControl.hidesForSinglePage = YES;
        [self addSubview:self.pageControl];
    }
    
    return self;
}

- (void)hidePageControl
{
    [self.pageControl removeFromSuperview];
    self.pageControl = nil;
}

// 设置总页数之后，启动动画
- (void)setTotalPageCount:(NSInteger (^)(void))totalPageCount
{
    self.totalPages = totalPageCount();
    self.pageControl.numberOfPages = self.totalPages;
    
    if (self.totalPages == 1) {
        _scrollView.contentSize = CGSizeMake(VIEW_WIDTH, VIEW_HEIGHT);
        [self configureContentViews];
        return;
    }
    if (self.totalPages > 0) {
        [self configureContentViews];
        [self.animationTimer resumeTimerAfterInterval:self.animationInterval];
    }
}

- (void)configureContentViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewDataSource];
    
    for (int i = 0; i < self.contentViews.count; i++) {
        UIView *contentView = nil;
        if (self.totalPages < 3) {
            if ([[self.contentViews objectAtIndex:i] isKindOfClass:[UIImageView class]]) {
                UIImage *image = [[self.contentViews objectAtIndex:i] image];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.image = image;
                contentView = imageView;
            }
            else if ([[self.contentViews objectAtIndex:i] isKindOfClass:[FZFavouriteHouseView class]]) {
                FZFavouriteHouseView *houseView = [self.contentViews objectAtIndex:i];
                FZFavouriteHouseView *newHouseView = [[[NSBundle mainBundle] loadNibNamed:@"FZFavouriteHouseView" owner:self options:nil] lastObject];
                [newHouseView setHouseViewWithModel:houseView.listModel currentLocation:houseView.currentLocation];
                contentView = newHouseView;
            }
            else {
                contentView = [self.contentViews objectAtIndex:i];
            }
        }
        else {
            contentView = [self.contentViews objectAtIndex:i];
        }
        
        contentView.userInteractionEnabled = YES;
        CGRect contentViewFrame = contentView.frame;
        contentViewFrame.origin = CGPointMake(VIEW_WIDTH * i, 0);
        contentView.frame = contentViewFrame;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(contentViewTapped:)];
        [contentView addGestureRecognizer:tapGesture];
        [self.scrollView addSubview:contentView];
    }
    
    if (self.totalPages != 1) {
        self.scrollView.contentOffset = CGPointMake(VIEW_WIDTH, 0);
    }
    else {
        self.scrollView.contentOffset = CGPointMake(VIEW_WIDTH * 2, 0);
    }
}

- (void)setScrollViewDataSource
{
    NSInteger previousIndex = [self validateNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearIndex = [self validateNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    
    if (!self.contentViews) {
        self.contentViews = [[NSMutableArray alloc] init];
    }
    [self.contentViews removeAllObjects];
    
    if (self.contentViewAtIndex) {
        [self.contentViews addObject:self.contentViewAtIndex(previousIndex)];
        [self.contentViews addObject:self.contentViewAtIndex(self.currentPageIndex)];
        [self.contentViews addObject:self.contentViewAtIndex(rearIndex)];
    }
}

- (NSInteger)validateNextPageIndexWithPageIndex:(NSInteger)pageIndex
{
    if (pageIndex < 0) {
        return self.totalPages - 1;
    }
    else if (pageIndex >= self.totalPages) {
        return 0;
    }
    else {
        return pageIndex;
    }
}

- (void)contentViewTapped:(UITapGestureRecognizer *)recognizer
{
    self.tapActionBlock(self.currentPageIndex);
}

#pragma mark - 响应事件 -

- (void)animationTimerDidFire:(NSTimer *)timer
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + VIEW_WIDTH, 0) animated:YES];
}

#pragma mark - Scroll view delegate -

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.animationTimer resumeTimerAfterInterval:self.animationInterval];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >= VIEW_WIDTH * 2) {
        self.currentPageIndex = [self validateNextPageIndexWithPageIndex:++_currentPageIndex];
        [self configureContentViews];
    }
    else if (scrollView.contentOffset.x <= 0) {
        self.currentPageIndex = [self validateNextPageIndexWithPageIndex:--_currentPageIndex];
        [self configureContentViews];
    }

    self.pageControl.currentPage = self.currentPageIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(VIEW_WIDTH, 0) animated:YES];
}


// Duplicate UIView
- (UIView*)duplicate:(UIView*)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

@end
