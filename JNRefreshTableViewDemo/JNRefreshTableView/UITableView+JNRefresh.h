//
//  UITableView+JNRefresh.h
//  JNRefreshTableViewDemo
//  https://github.com/Yigol2008/JNRefreshTableView
//
//  Created by Yigol on 16/5/12.
//  Copyright © 2016年 Injoinow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"
//#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

typedef void(^JNRefreshTableViewLoadNewData) ();
typedef void(^JNRefreshTableViewLoadMoreData) ();

@interface UITableView (JNRefresh)

/** 下拉重新加载*/
@property (copy, nonatomic) JNRefreshTableViewLoadNewData loadNewDataBlock;

/** 上拉加载更多*/
@property (copy, nonatomic) JNRefreshTableViewLoadMoreData loadMoreDataBlock;

/** 开始header刷新 , Optional*/
- (void)beginRefreshingHeader;

/** 结束刷新*/
- (void)endRefreshing;

/** 上拉加载更多。。。显示没有更多数据了 */
- (void)endRefreshWithNoMoreData;

/** 开始刷新状态 */
- (void)startLoading;

/** 显示没有数据的默认页面 */
- (void)showNoData;

@end


typedef void (^EmptyDataClick)();

@interface UITableView (JNEmptyData)<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/** 在加载数据前设置为YES(必需)，随后根据数据调整为NO(可选) */
@property (assign, nonatomic, getter=isLoading) BOOL loading;

/** 点击回调block的属性 */
@property (copy, nonatomic) EmptyDataClick emptyClickBlock;


@end
