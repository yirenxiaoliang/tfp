//
//  TFChartListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChartListController.h"
#import "TFStatisticsListCell.h"
#import "TFChartDetailController.h"
#import "TFCustomBL.h"
#import "TFStatisticsListModel.h"
#import "TFRefresh.h"
#import "HQTFNoContentView.h"

@interface TFChartListController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView ;
/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;


/** pageNo */
@property (nonatomic, strong) NSNumber *pageNo;
/** pageSize */
@property (nonatomic, strong) NSNumber *pageSize;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** 报表风格(dashboard仪表盘、report报表) */
@property (nonatomic, copy) NSString *styleType;
/** 报表菜单id（0最近报表、1全部报表、2共享给我的报表、3我创建的报表） */
@property (nonatomic, copy) NSString *menuId;

@end

@implementation TFChartListController

-(NSMutableArray *)lists{
    if (!_lists) {
        _lists = [NSMutableArray array];
    }
    return _lists;
}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = @1;
    self.pageSize = @10;
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    if (self.lists.count == 0) {
        [self.customBL requestChartList];
    }
    [self setupTableView];
    
    self.navigationItem.title = @"选择仪表盘";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightClicked) text:@"确定"];
}

- (void)rightClicked{
    
    if (self.refresh) {
        self.refresh(self.model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getChartList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        TFStatisticsListModel *model = resp.body;
        
//        TFCustomPageModel *listModel = model.pageInfo;
        
//        if ([self.tableView.mj_footer isRefreshing]) {
//            
            [self.tableView.mj_footer endRefreshing];
//
//        }else {
//            
            [self.tableView.mj_header endRefreshing];
        
            [self.lists removeAllObjects];
//        }
    
        [self.lists addObjectsFromArray:model.data];
        
        
//        if ([listModel.totalRows integerValue] <= self.lists.count) {
//            
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            
//        }else {
//            
//            [self.tableView.mj_footer resetNoMoreData];
//        }
//        
//        if (self.lists.count == 0) {
//            
//            self.tableView.backgroundView = self.noContentView;
//        }else{
//            self.tableView.backgroundView = [UIView new];
//        }
        
        
        [self.tableView reloadData];
        
        
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}





#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    MJRefreshNormalHeader *header = [TFRefresh headerNormalRefreshWithBlock:^{
        
        self.pageNo = @1;
        
        [self.customBL requestChartList];
    }];
    tableView.mj_header = header;
    
    
//    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
//        
//        self.pageNo = @([self.pageNo integerValue]+1);
//        [self.customBL requestChartList];
//    }];
//    tableView.mj_footer = footer;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFStatisticsListCell *cell = [TFStatisticsListCell statisticsCellWithTableView:tableView];
    TFStatisticsItemModel *model = self.lists[indexPath.row];
    cell.type = 1;
    [cell refreshStatisticsCellWithModel:model];
    
    if ([model.id isEqualToNumber:self.model.id]) {
        cell.enterImage.image = [UIImage imageNamed:@"完成30"];
        cell.enterImage.hidden = NO;
    }else{
        cell.enterImage.hidden = YES;
    }
    
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }else{
        cell.topLine.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
//    TFChartDetailController *detail = [[TFChartDetailController alloc] init];
//    detail.model = self.lists[indexPath.row];
//    detail.type = 1;
//    [self.navigationController pushViewController:detail animated:YES];
    self.model = self.lists[indexPath.row];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
