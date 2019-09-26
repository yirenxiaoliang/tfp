//
//  TFStatisticsListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFStatisticsListController.h"
#import "HQTFNoContentView.h"
#import "TFSearchTableView.h"
#import "TFCRMSearchView.h"
#import "TFStatisticsListCell.h"
#import "TFCustomBL.h"
#import "TFChartDetailController.h"
#import "TFRefresh.h"
#import "TFStatisticsListModel.h"
#import "TFCustomPageModel.h"
#import "TFStatisticsTitleController.h"

@interface TFStatisticsListController ()<UITableViewDelegate,UITableViewDataSource,TFCRMSearchViewDelegate,TFSearchTableViewDelegate,HQBLDelegate>
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** TFSearchTableView *view */
@property (nonatomic, strong) TFSearchTableView *searchTableView;
/** TFCRMSearchView *view  */
@property (nonatomic, weak) TFCRMSearchView *searchView;

/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;

/** lists */
@property (nonatomic, strong) NSMutableArray *lists;

/** pageNo */
@property (nonatomic, strong) NSNumber *pageNo;
/** pageSize */
@property (nonatomic, strong) NSNumber *pageSize;

/** 报表风格(dashboard仪表盘、report报表) */
@property (nonatomic, copy) NSString *styleType;
/** 报表菜单id（0最近报表、1全部报表、2共享给我的报表、3我创建的报表） */
@property (nonatomic, copy) NSString *menuId;

/** titleLabel */
@property (nonatomic, weak) UILabel *titleLabel;
/** enterView */
@property (nonatomic, weak) UIView *enterView;

/** beanType */
@property (nonatomic, strong) TFBeanTypeModel *beanType;


@end

@implementation TFStatisticsListController

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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)activeGood{
    
    [self.customBL requestStatisticsListWithMenuId:self.menuId styleType:self.styleType reportLabel:nil dataSourceName:nil createBy:nil createTime:nil modifyBy:nil modifyTime:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = @1;
    self.pageSize = @10;
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    // 报表菜单
    self.beanType = [[TFBeanTypeModel alloc] init];
    self.beanType.menu_code = @1;
    self.beanType.name = @"全部报表";
    self.menuId = @"1";
    // 风格
    self.styleType = @"report";
    [self activeGood];
    
    [self setupTableView];
    [self setupNavi];
//    [self setupCRMSearchView];
//    [self setupSearchTableView];
    [self setupEnterView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:ChangeCompanySocketConnect object:nil];
}

- (void)applicationDidBecomeActive{
    [self activeGood];
}

- (void)setupEnterView{
    
    [self.enterView removeFromSuperview];
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    self.enterView = view;
    view.backgroundColor = WhiteColor;
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-60,44}];
    [view addSubview:label];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){SCREEN_WIDTH-44,0,44,44}];
    [view addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"下一级浅灰"];
    [self.view addSubview:view];
    imageView.contentMode = UIViewContentModeCenter;
    self.titleLabel = label;
    label.text = self.beanType.name;
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){0,43,SCREEN_WIDTH,1}];
    [view addSubview:line];
    line.backgroundColor = BackGroudColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterViewClicked)];
    [view addGestureRecognizer:tap];
}

- (void)enterViewClicked{
    TFStatisticsTitleController *list = [[TFStatisticsTitleController alloc] init];
    list.model = self.beanType;
    list.refresh = ^(TFBeanTypeModel *model) {
        self.beanType = model;
        self.titleLabel.text = self.beanType.menu_label?:self.beanType.name;
        // 详情
        self.menuId = [model.menu_code description];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestStatisticsListWithMenuId:self.menuId styleType:self.styleType reportLabel:nil dataSourceName:nil createBy:nil createTime:nil modifyBy:nil modifyTime:nil];
    };
    [self.navigationController pushViewController:list animated:YES];
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getReportList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        TFStatisticsListModel *model = resp.body;
        
        TFCustomPageModel *listModel = model.pageInfo;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.lists removeAllObjects];
        }
        
        [self.lists addObjectsFromArray:model.list];
        
        
        if ([listModel.totalRows integerValue] <= self.lists.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.lists.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        
        [self.tableView reloadData];
        
        
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}



- (void)setupNavi{
    self.navigationItem.title = @"报表";
}

#pragma - mark 初始化SearchTableView
- (void)setupSearchTableView{
    self.searchTableView = [[TFSearchTableView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,SCREEN_HEIGHT-NaviHeight-44}];
    self.searchTableView.delegate = self;
    
    
    NSMutableArray<TFBeanTypeModel> *arr = [NSMutableArray<TFBeanTypeModel> array];
    NSArray *titles = @[@"最近报表",@"全部报表",@"共享给我的报表",@"我创建的报表"];
    for (NSInteger i = 0; i < titles.count; i ++) {
        TFBeanTypeModel *model = [[TFBeanTypeModel alloc] init];
        model.name = [NSString stringWithFormat:@"%@",titles[i]];
        model.menu_code = @(i);
        [arr addObject:model];
    }
    [self.searchTableView refreshSearchTableViewWithItems:arr];
}

#pragma mark - TFSearchTableViewDelegate
-(void)searchTableViewDidSelectModel:(TFBeanTypeModel *)model{
    
    self.searchView.open = NO;
    self.menuId = [model.menu_code description];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.customBL requestStatisticsListWithMenuId:self.menuId styleType:self.styleType reportLabel:nil dataSourceName:nil createBy:nil createTime:nil modifyBy:nil modifyTime:nil];
    
    
}

-(void)searchTableViewDidClickedBackgruod{
    
    self.searchView.open = NO;
}

#pragma mark - 初始化筛选View
- (void)setupCRMSearchView{
    TFCRMSearchView *view = [TFCRMSearchView CRMSearchView];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    view.delegate = self;
    self.searchView = view;
    [self.view addSubview:view];
    view.filterBtn.hidden = YES;
    [self.searchView refreshSearchViewWithTitle:[NSString stringWithFormat:@"全部报表"] number:0];
}

#pragma mark - TFCRMSearchViewDelegate
-(void)crmSearchViewDidClicked:(BOOL)open{
    
    if (open) {
        
        [self.view insertSubview:self.searchTableView aboveSubview:self.tableView];
        [self.searchTableView showAnimation];
        
    }else{
        
        [self.searchTableView hideAnimationWithCompletion:^(BOOL finish) {
            
            [self.searchTableView removeFromSuperview];
        }];
    }
}

-(void)crmSearchViewDidFilterBtn:(BOOL)show{
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = WhiteColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    tableView.mj_header = [TFRefresh headerNormalRefreshWithBlock:^{
        
        self.pageNo = @1;
        
        [self.customBL requestStatisticsListWithMenuId:self.menuId styleType:self.styleType reportLabel:nil dataSourceName:nil createBy:nil createTime:nil modifyBy:nil modifyTime:nil];
    }];
    
    
    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        self.pageNo = @([self.pageNo integerValue]+1);
        [self.customBL requestStatisticsListWithMenuId:self.menuId styleType:self.styleType reportLabel:nil dataSourceName:nil createBy:nil createTime:nil modifyBy:nil modifyTime:nil];
    }];
    tableView.mj_footer = footer;
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
    [cell refreshStatisticsCellWithModel:model];
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }else{
        cell.topLine.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFChartDetailController *detail = [[TFChartDetailController alloc] init];
    detail.model = self.lists[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
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
