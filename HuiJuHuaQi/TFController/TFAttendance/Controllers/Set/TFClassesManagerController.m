//
//  TFClassesManagerController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFClassesManagerController.h"
#import "TFAddressWayCell.h"
#import "TFAddClassesController.h"
#import "TFRefresh.h"
#import "HQTFNoContentView.h"

#import "TFAttendanceBL.h"
#import "TFAtdClassListModel.h"

@interface TFClassesManagerController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFAddressWayCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFAttendanceBL *atdBL;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) TFAtdClassListModel *mainModel;

@property (nonatomic, strong) HQTFNoContentView *noContentView;


@property (nonatomic, strong) TFAtdClassModel *deleteModel;

@end

@implementation TFClassesManagerController

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
    
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
    
    self.pageNum = 1;
    self.pageSize = 20;
    self.navigationItem.title = @"班次管理";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addClassesManager) text:@"添加" textColor:GreenColor];
    
    [self setupTableView];
    
    self.atdBL = [TFAttendanceBL build];
    self.atdBL.delegate = self;
    
    [self requestData];
}

- (void)requestData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     [self.atdBL requestGetAttendanceClassFindListWithPageNum:@(self.pageNum) pageSize:@(self.pageSize)];
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    MJRefreshGifHeader *header = [TFRefresh headerGifRefreshWithBlock:^{
        
        self.pageNum = 1;
        [self requestData];
        
    }];
    tableView.mj_header = header;
    
    
    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        self.pageNum ++;
        [self requestData];
        
    }];
    tableView.mj_footer = footer;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFAtdClassModel *model = self.dataSource[indexPath.row];
    TFAddressWayCell *cell = [TFAddressWayCell addressWayCellWithTableView:tableView];
    cell.topLine.hidden = NO;
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }
    cell.delegate = self;
    cell.index = indexPath.row;
    [cell configClassesManagerCellWithTableView:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFAtdClassModel *model = self.dataSource[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFAddClassesController *addClassVC = [[TFAddClassesController alloc] init];
    addClassVC.classId = model.id;
    addClassVC.classType = 1;
    addClassVC.refresh = ^{
        [self requestData];
    };
    [self.navigationController pushViewController:addClassVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 92;
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

#pragma mark 添加班次
- (void)addClassesManager {
    
    TFAddClassesController *addClassVC = [[TFAddClassesController alloc] init];
    addClassVC.classType = 0;
    addClassVC.refresh = ^{
      
        [self requestData];
    };
    [self.navigationController pushViewController:addClassVC animated:YES];
    
}

#pragma mark TFAddressWayCellDelegate (删除班次)
- (void)deleteClicked:(NSInteger)index {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定删除该班次？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.deleteModel = self.dataSource[index];
        [self.atdBL requestDelAttendanceClassWithId:self.deleteModel.id];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_attendanceClassFindList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.mainModel = resp.body;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.dataSource removeAllObjects];
        }
        
        [self.dataSource addObjectsFromArray:self.mainModel.dataList];
        
        if ([self.mainModel.pageInfo.totalRows integerValue] == self.dataSource.count) {
            
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
    
    if (resp.cmdId == HQCMD_attendanceClassDel) { //删除
        
        [MBProgressHUD showError:@"删除成功" toView:self.view];
        [self.dataSource removeObject:self.deleteModel];
        [self.tableView reloadData];
//        [self requestData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
