//
//  UITableView+JNRefresh.m
//  JNRefreshTableViewDemo
//  https://github.com/Yigol2008/JNRefreshTableView
//
//  Created by Yigol on 16/5/12.
//  Copyright © 2016年 Injoinow. All rights reserved.
//

#import "UITableView+JNRefresh.h"
#import <objc/runtime.h>
#import "MJRefresh.h"


@implementation UITableView (JNRefresh)

#pragma mark - ************ Setter && Getter
static const char RefreshTableViewLoadNewDataKey = '\0';
- (void)setLoadNewDataBlock:(JNRefreshTableViewLoadNewData)loadNewDataBlock
{
    [self willChangeValueForKey:@"loadNewDataBlock"];
    objc_setAssociatedObject(self, &RefreshTableViewLoadNewDataKey, loadNewDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"loadNewDataBlock"];
    
    if (!self.mj_header) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.automaticallyChangeAlpha = YES;
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = NO;
        // 设置文字
        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"正在刷新中 ..." forState:MJRefreshStateRefreshing];
        // 设置字体
        header.stateLabel.font = [UIFont systemFontOfSize:14];
        header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
        // 设置颜色
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        // 设置header
        self.mj_header = header;
    }
}

- (JNRefreshTableViewLoadNewData)loadNewDataBlock
{
    return objc_getAssociatedObject(self, &RefreshTableViewLoadNewDataKey);
}

static const char RefreshTableViewLoadMoreDataKey = '\0';
- (void)setLoadMoreDataBlock:(JNRefreshTableViewLoadMoreData)loadMoreDataBlock
{
    [self willChangeValueForKey:@"loadMoreDataBlock"];
    objc_setAssociatedObject(self, &RefreshTableViewLoadMoreDataKey, loadMoreDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"loadMoreDataBlock"];
    
    if (!self.mj_footer) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.automaticallyHidden = YES;
        // 设置文字
        [footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"加载中，请稍后..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
        // 设置字体
        footer.stateLabel.font = [UIFont systemFontOfSize:14];
        // 设置颜色
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        
        self.mj_footer = footer;
    }
}

- (JNRefreshTableViewLoadMoreData)loadMoreDataBlock
{
    return objc_getAssociatedObject(self, &RefreshTableViewLoadMoreDataKey);
}

#pragma mark - ************ Selector
//下拉重新加载
- (void)loadNewData
{
    if (self.mj_footer) {
        [self.mj_footer resetNoMoreData];
    }
    if (self.loadNewDataBlock) {
        self.loadNewDataBlock();
    }
}
//上拉加载更多
- (void)loadMoreData
{
    if (self.loadMoreDataBlock) {
        self.loadMoreDataBlock();
    }
}

#pragma mark - ************ Custom Method
//结束刷新
- (void)endRefreshing
{
    if (self.mj_header.isRefreshing) {
        [self.mj_header endRefreshing];
    }
    if (self.mj_footer.isRefreshing) {
        [self.mj_footer endRefreshing];
    }
}

- (void)beginRefreshingHeader
{
    if (self.mj_header) {
        [self.mj_header beginRefreshing];
    }
}

- (void)endRefreshWithNoMoreData
{
    if (self.mj_footer) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)startLoading
{
    self.loading = YES;
}

- (void)showNoData
{
    self.loading = NO;
}

@end


@implementation UITableView (JNEmptyData)

#pragma mark - ************ Setter && Getter
static const BOOL loadingKey;
- (void)setLoading:(BOOL)loading
{
    if (self.loading == loading) {
        return;
    }
    
    [self willChangeValueForKey:@"loading"];
    objc_setAssociatedObject(self, &loadingKey, @(loading), OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"loading"];
    
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    [self reloadEmptyDataSet];
}

- (BOOL)isLoading
{
    id tmp = objc_getAssociatedObject(self, &loadingKey);
    NSNumber *number = tmp;
    return number.unsignedIntegerValue;
}

static const char emptyClickBlockKey = '\0';
- (void)setEmptyClickBlock:(EmptyDataClick)emptyClickBlock
{
    [self willChangeValueForKey:@"emptyClickBlock"];
    objc_setAssociatedObject(self, &emptyClickBlockKey, emptyClickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"emptyClickBlock"];
}

- (EmptyDataClick)emptyClickBlock
{
    return objc_getAssociatedObject(self, &emptyClickBlockKey);
}

#pragma mark - ************ DZNEmptyDataSetSource
// 返回一张空状态的图片在文字上面的
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imgName = @"JNRefresh.bundle/empty_placeholder";
    return [UIImage imageNamed:imgName];
}
// 空状态下的文字详情
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有数据！您可以尝试重新获取";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
// 返回最下面按钮上的文字
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    UIColor *textColor = nil;
    // 某种状态下的颜色
    UIColor *colorOne = [UIColor blueColor];
    UIColor *colorTow = [UIColor lightGrayColor];
    // 判断外部是否有设置
    textColor = state == UIControlStateNormal ? colorOne : colorTow;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: textColor};
    
    return [[NSAttributedString alloc] initWithString:@"再次刷新" attributes:attributes];
}
// 按钮背景图片
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return [[[UIImage imageNamed:@"JNRefresh.bundle/button_background_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0) resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:UIEdgeInsetsMake(-19.0, -61.0, -19.0, -61.0)];
}
// 返回试图的垂直位置（调整整个试图的垂直位置）
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0.0f;
}

#pragma mark - ************ DZNEmptyDataSetDelegate
// 返回是否显示空状态的所有组件，默认:YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}
// 返回是否允许交互，默认:YES，只有非加载状态能交互
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return !self.isLoading;
}
// 返回是否允许滚动，默认:YES
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}
// 点击空状态下的按钮会调用
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    if (self.emptyClickBlock) {
        self.emptyClickBlock();
    }
}
//  点击空状态下的view会调用
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    // 暂时不响应
}

@end
