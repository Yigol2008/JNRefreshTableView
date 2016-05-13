//
//  RefreshViewController.m
//  JNRefreshTableViewDemo
//
//  Created by Yigol on 16/5/12.
//  Copyright © 2016年 Injoinow. All rights reserved.
//

#import "RefreshViewController.h"
#import "JNRefreshTableView.h"
#import "SVProgressHUD.h"


static const CGFloat MJDuration = 1.0;
/** 随机数据 */
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]

#define haveHeaderRefresh 1
#define haveFooterRefresh 1


@interface RefreshViewController ()

/** 用来显示的假数据 */
@property (strong, nonatomic) NSMutableArray *data;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation RefreshViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    __weak typeof(self)weakSelf = self;;
    
    
#if haveHeaderRefresh
    //添加header
    self.tableView.loadNewDataBlock = ^(){
        [weakSelf loadDataIsHeaderRefresh:YES];
    };
#endif
    
#if haveFooterRefresh
    //添加footer
    self.tableView.loadMoreDataBlock = ^(){
        
        [weakSelf loadDataIsHeaderRefresh:NO];
    };
#endif
    
    
    self.tableView.emptyClickBlock = ^(){
        NSLog(@"没有数据重新刷新");
        [weakSelf loadDataIsHeaderRefresh:YES];
    };
    
    [self loadDataIsHeaderRefresh:YES];
}

- (void)loadDataIsHeaderRefresh:(BOOL)isHeader
{
    [self.tableView startLoading];
    
    [SVProgressHUD show];
    
    if (isHeader) {
        self.currentPage = 1;
    } else {
        self.currentPage ++;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //模拟获取网络上的数据
        NSMutableArray *tempArr = [self sourceArrWithPage:self.currentPage isHaveData:_isHaveData];
        
        if (isHeader) {
            [self.data removeAllObjects];
        }
        [self.data addObjectsFromArray:tempArr];
        
        
        if (self.data.count > 0 && tempArr.count == 0) {
            [self.tableView endRefreshWithNoMoreData];
        }
        
        if (self.data.count == 0) {
            [self.tableView showNoData];
        }
        
        [self.tableView endRefreshing];
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    });
}

#pragma mark - Table View
- (NSMutableArray *)data
{
    if (!_data) {
        self.data = [NSMutableArray array];
    }
    return _data;
}
- (NSMutableArray *)sourceArrWithPage:(NSInteger)page isHaveData:(BOOL)isHave;
{
    NSMutableArray *aaa = [NSMutableArray array];
    if (isHave) {
        if (page < 3) {
            for (int i = 0; i<5; i++) {
                [aaa insertObject:MJRandomData atIndex:0];
            }
        }
    }
    return aaa;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", indexPath.row % 2?@"push":@"modal", self.data[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIViewController *vv = [self.storyboard instantiateViewControllerWithIdentifier:@"ccc"];
//    [self.navigationController pushViewController:vv animated:YES];
}


#pragma mark - ************ Action
- (IBAction)noDataAction:(id)sender {
    _isHaveData = NO;
}
- (IBAction)hadDataAction:(id)sender {
    _isHaveData = YES;
}




@end
