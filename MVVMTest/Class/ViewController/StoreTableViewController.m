//
//  StoreTableViewController.m
//  MVVMTest
//
//  Created by ios on 2017/1/5.
//  Copyright © 2017年 c. All rights reserved.
//

#import "StoreTableViewController.h"
#import "StoreViewModel.h"
#import "StoreCell.h"
#import "StoreModel.h"
#import "SecondViewController.h"
#import "MyNormalHeader.h"
#import "MyRefreshHeader.h"
#import "WaveHeader.h"

@interface StoreTableViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) StoreViewModel *viewModel;

@end

@implementation StoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showRefreshSelectMenu:)];
    self.navigationItem.rightBarButtonItem = item;
    
    @weakify(self);
    //接受通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"title" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"x----%@",x);//传过来的是通知本身
        NSNotification *noti = (NSNotification *)x;
        self.title           = noti.userInfo[@"title"];
    }];

    //添加RAC中的KVO
    [[RACObserve(self, title) filter:^BOOL(id value) {
        return value?value:nil;
    }] subscribeNext:^(id x) {
        NSLog(@"x---%@",x);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MyRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf reloadDatas];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreDatas];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - fetchData
-(void) reloadDatas{
    [self.dataArray removeAllObjects];
    [self fetchData];
}

-(void) loadMoreDatas{
    [self fetchData];
}

-(void) fetchData{
    @weakify(self);
    //执行命令,此处传了接口到ViewModel中
    [[self.viewModel.fetchStoreModelCommand execute:shopListUrl] subscribeNext:^(id x) {
        @strongify(self);
        NSArray *array = (NSArray *)x;
        [self.dataArray addObjectsFromArray:array];
        
        if([self.tableView.mj_header isRefreshing]){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.tableView.mj_header endRefreshing];
            });
        }
        
        if([self.tableView.mj_footer isRefreshing]){
            @strongify(self);
            array.count?[self.tableView.mj_footer endRefreshing]:[self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    } error:^(NSError *error) {
        NSLog(@"error----%@",error);
    }];
    
    //在视图控制器中也可以不传值过去,而在ViewModel中直接调用接口,switchToLatest表示获取最新的信号
//    [self.viewModel.fetchStoreModelCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
//        
//    } error:^(NSError *error) {
//        
//    }];
    
}

#pragma mark 改变刷新方式
-(void)showRefreshSelectMenu:(UIBarButtonItem *)item{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"下拉刷新样式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weaKSelf = self;
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"canle" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"动画" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        weaKSelf.tableView.mj_header = nil;
        weaKSelf.tableView.mj_header = [MyNormalHeader headerWithRefreshingBlock:^{
            [weaKSelf reloadDatas];
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"gif" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        weaKSelf.tableView.mj_header = nil;
        weaKSelf.tableView.mj_header = [MyRefreshHeader headerWithRefreshingBlock:^{
            [weaKSelf reloadDatas];
        }];

    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"波浪" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        weaKSelf.tableView.mj_header = nil;
        weaKSelf.tableView.mj_header = [WaveHeader headerWithRefreshingBlock:^{
            [weaKSelf reloadDatas];
        }];

    }];
    
    [alert addAction:cancle];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyLoad
-(NSMutableArray *) dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

-(StoreViewModel *) viewModel{
    if(!_viewModel){
        _viewModel = [[StoreViewModel alloc]init];
    }
    return _viewModel;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[StoreCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    StoreModel *model = self.dataArray[indexPath.row];
    [cell setModel:model];
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SecondViewController *vc = [[SecondViewController alloc]init];
    [vc.delegateSubject subscribeNext:^(id x) {
        NSLog(@"点击了%@的按钮",(NSString *)x);
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
