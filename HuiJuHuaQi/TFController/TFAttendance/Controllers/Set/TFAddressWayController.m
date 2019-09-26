//
//  TFAddressWayController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddressWayController.h"
#import "TFAddressWayCell.h"
#import "TFRefresh.h"
#import "HQTFNoContentView.h"
#import "TFAddPCAddressController.h"

#import "TFAttendanceBL.h"
#import "TFAtdWayListModel.h"
#import "TFAtdWatDataListModel.h"

@interface TFAddressWayController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFAddressWayCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFAttendanceBL *atdBL;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) TFAtdWayListModel *model;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) HQTFNoContentView *noContentView;


@end

@implementation TFAddressWayController

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
    
}

- (TFAtdWayListModel *)model {
    
    if (!_model) {
        
        _model = [[TFAtdWayListModel alloc] init];
    }
    return _model;
    
}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
    }
    return _noContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    self.pageNum = 1;
    self.pageSize = 10;
    
    self.atdBL = [TFAttendanceBL build];
    
    self.atdBL.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestData];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"CreateAddressSuccess" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        [self requestData];
    }];
}

- (void)requestData {
    
    [self.atdBL requestGetAttendanceWayListWithType:@0 pageNum:nil pageSize:nil];
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    MJRefreshNormalHeader *header = [TFRefresh headerNormalRefreshWithBlock:^{
        
        self.pageNum = 1;
        [self requestData];
        
    }];
    tableView.mj_header = header;
    
    
//    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
//
//        self.pageNum ++;
//        [self requestData];
//
//    }];
//    tableView.mj_footer = footer;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFAddressWayCell *cell = [TFAddressWayCell addressWayCellWithTableView:tableView];
    
    TFAtdWatDataListModel *dataListModel = self.dataSource[indexPath.row];
    cell.index = indexPath.row;
    cell.delegate = self;
    [cell configAddressWayCellWithTableView:dataListModel];
    cell.bottomLine.hidden = NO;
    if (indexPath.row == self.dataSource.count-1) {
        cell.bottomLine.hidden = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFAtdWatDataListModel *dataListModel = self.dataSource[indexPath.row];
    TFAddPCAddressController *addVC = [[TFAddPCAddressController alloc] init];
    addVC.type = 1;
    addVC.wayId = dataListModel.id;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 141;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark TFAddressWayCellDelegate(删除)
- (void)deleteClicked:(NSInteger)index {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定删除该考勤地址？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        TFAtdWatDataListModel *dataListModel = self.dataSource[index];
        [self.atdBL requestDelAttendanceWayWithId:dataListModel.id];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_attendanceWayFindList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.model = resp.body;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.dataSource removeAllObjects];
        }
        
        [self.dataSource addObjectsFromArray:self.model.dataList];
        
        if ([self.model.pageInfo.totalRows integerValue] == self.dataSource.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.dataSource.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
            
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_attendanceWayDel) {
        
        [MBProgressHUD showError:@"删除成功" toView:self.view];
        
        [self requestData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
