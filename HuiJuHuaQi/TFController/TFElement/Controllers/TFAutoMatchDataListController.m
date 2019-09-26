//
//  TFAutoMatchDataListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/9/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAutoMatchDataListController.h"
#import "TFCustomBL.h"
#import "TFRefresh.h"
#import "TFCRMSearchView.h"
#import "HQTFNoContentView.h"
#import "TFCustomListModel.h"
#import "TFSearchTableView.h"
#import "TFAutoMatchRuleModel.h"
#import "TFCustomListCell.h"
#import "TFNewCustomDetailController.h"

@interface TFAutoMatchDataListController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFCRMSearchViewDelegate,TFSearchTableViewDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;

/** pageNum */
@property (nonatomic, strong) NSNumber *pageNum;
/** pageSize */
@property (nonatomic, strong) NSNumber *pageSize;
/** TFCRMSearchView *view  */
@property (nonatomic, weak) TFCRMSearchView *searchView;

/** TFSearchTableView *view */
@property (nonatomic, strong) TFSearchTableView *searchTableView;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** rules */
@property (nonatomic, strong) NSMutableArray *rules;

/** lists */
@property (nonatomic, strong) NSMutableArray *lists;

/** ruleModel */
@property (nonatomic, strong) TFAutoMatchRuleModel *ruleModel;

/** pageInfo */
@property (nonatomic, strong) TFCustomPageModel *pageInfo;


@end

@implementation TFAutoMatchDataListController

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
    self.pageSize = @20;
    self.pageNum = @1;
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.customBL requsetAutoMatchRuleListWithSourceBean:self.relevance.sorce_bean targetBean:self.relevance.target_bean];// 获取规则列表
    
    [self setupTableView];
    [self setupCRMSearchView];
    [self setupSearchTableView];
    self.navigationItem.title = self.relevance.chinese_name;
}

#pragma - mark 初始化SearchTableView
- (void)setupSearchTableView{
    self.searchTableView = [[TFSearchTableView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,SCREEN_HEIGHT-NaviHeight-44}];
    self.searchTableView.delegate = self;
}

#pragma mark - TFSearchTableViewDelegate
-(void)searchTableViewDidSelectAutoModel:(TFAutoMatchRuleModel *)model{
    
    self.ruleModel = model;
    self.searchView.open = NO;

    [self.searchView refreshSearchViewWithTitle:self.ruleModel.title number:[self.pageInfo.totalRows integerValue]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    [self.customBL requestAutoMatchModuleDataListWithDataId:self.dataId sorceBean:self.relevance.sorce_bean targetBean:self.relevance.target_bean pageSize:self.pageSize pageNum:self.pageNum ruleId:self.ruleModel.id];
    
    
    [self.customBL requestTabDataWithTabId:self.relevance.id dataAuth:self.dataAuth dataId:self.dataId ruleId:self.ruleModel.id moduleId:self.relevance.module_id dataType:self.relevance.condition_type pageNum:self.pageNum pageSize:self.pageSize];
}

-(void)searchTableViewDidClickedBackgruod{
    
    self.searchView.open = NO;
}

#pragma mark - 初始化筛选View
- (void)setupCRMSearchView{
    TFCRMSearchView *view = [TFCRMSearchView CRMSearchView];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    view.delegate = self;
    view.filterBtn.hidden = YES;
    self.searchView = view;
    [self.view addSubview:view];
//    [self.searchView refreshSearchViewWithTitle:[NSString stringWithFormat:@"全部%@",self.module.chinese_name] number:0];
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


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getAutoMatchModuleRuleList) {
        
        self.rules = resp.body;
        if (self.rules.count) {
            self.ruleModel = self.rules.firstObject;
            
            [self.searchView refreshSearchViewWithTitle:self.ruleModel.title number:0];
            
//            [self.customBL requestAutoMatchModuleDataListWithDataId:self.dataId sorceBean:self.relevance.sorce_bean targetBean:self.relevance.target_bean pageSize:self.pageSize pageNum:self.pageNum ruleId:self.ruleModel.id];
            
            [self.customBL requestTabDataWithTabId:self.relevance.id dataAuth:self.dataAuth dataId:self.dataId ruleId:self.ruleModel.id moduleId:self.relevance.module_id dataType:self.relevance.condition_type pageNum:self.pageNum pageSize:self.pageSize];
            
            [self.searchTableView refreshSearchTableViewWithItems:self.rules type:1];
        }
        
        
    }
    
    if (resp.cmdId == HQCMD_getAutoMatchModuleRuleDataList || resp.cmdId == HQCMD_getAutoMatchModuleDataList || resp.cmdId == HQCMD_getTabDataList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
//        TFCustomListModel *model = resp.body;
//
//        TFCustomPageModel *listModel = model.pageInfo;
//        self.pageInfo = listModel;
        
        NSDictionary *dict = resp.body;
        
        TFCustomListModel *model = [[TFCustomListModel alloc] initWithDictionary:dict error:nil];
        
        TFCustomPageModel *listModel = model.pageInfo;
        self.pageInfo = listModel;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.lists removeAllObjects];
        }
        
        [self.lists addObjectsFromArray:model.dataList];
        
        
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
        
        [self.searchView refreshSearchViewWithTitle:self.ruleModel.title number:[listModel.totalRows integerValue] <= 0 ? 0 : [listModel.totalRows integerValue]];
        
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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.mj_header = [TFRefresh headerGifRefreshWithBlock:^{
        
        self.pageNum = @1;
        
//        [self.customBL requestAutoMatchModuleDataListWithDataId:self.dataId sorceBean:self.relevance.sorce_bean targetBean:self.relevance.target_bean pageSize:self.pageSize pageNum:self.pageNum ruleId:self.ruleModel.id];
        
        [self.customBL requestTabDataWithTabId:self.relevance.id dataAuth:self.dataAuth dataId:self.dataId ruleId:self.ruleModel.id moduleId:self.relevance.module_id dataType:self.relevance.condition_type pageNum:self.pageNum pageSize:self.pageSize];
    }];
    
    
    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        self.pageNum = @([self.pageNum integerValue]+1);
//        [self.customBL requestAutoMatchModuleDataListWithDataId:self.dataId sorceBean:self.relevance.sorce_bean targetBean:self.relevance.target_bean pageSize:self.pageSize pageNum:self.pageNum ruleId:self.ruleModel.id];
        
        [self.customBL requestTabDataWithTabId:self.relevance.id dataAuth:self.dataAuth dataId:self.dataId ruleId:self.ruleModel.id moduleId:self.relevance.module_id dataType:self.relevance.condition_type pageNum:self.pageNum pageSize:self.pageSize];
    }];
    tableView.mj_footer = footer;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.lists.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCustomListItemModel *model = self.lists[indexPath.section];
    
    TFCustomListCell *cell = [TFCustomListCell customListCellWithTableView:tableView];
    [cell refreshCustomListCellWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFCustomListItemModel *model = self.lists[indexPath.section];
    //    TFCustomDetailController *detail = [[TFCustomDetailController alloc] init];
    TFNewCustomDetailController *detail = [[TFNewCustomDetailController alloc] init];
    detail.bean = self.relevance.target_bean;
    detail.dataId = [NSNumber numberWithInteger:[model.id.value integerValue]];
    //    detail.moduleId = self.module.id;
    detail.deleteAction = ^{
        
        [self.lists removeObject:model];
        
        if (self.lists.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.searchView refreshSearchViewWithTitle:self.ruleModel.title number:self.lists.count];
        
        [self.tableView reloadData];
    };
    detail.refreshAction = ^{
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TFCustomListItemModel *model = self.lists[indexPath.section];
    return [TFCustomListCell refreshCustomListCellHeightWithModel:model];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 9;
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
