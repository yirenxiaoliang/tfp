//
//  TFReferenceListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFReferenceListController.h"
#import "TFCustomListCell.h"
#import "TFAddCustomController.h"
#import "TFCRMSearchView.h"
#import "TFSearchTableView.h"
#import "TFFilterView.h"
#import "TFRefresh.h"
#import "TFCustomSearchController.h"
#import "TFCustomBL.h"
//#import "TFCustomDetailController.h"
#import "TFNewCustomDetailController.h"
#import "TFCustomListModel.h"
#import "HQTFNoContentView.h"
#import "TFCustomAuthModel.h"


@interface TFReferenceListController ()<UITableViewDelegate,UITableViewDataSource,TFCRMSearchViewDelegate,HQBLDelegate>

/** pageNo */
@property (nonatomic, strong) NSNumber *pageNo;
/** pageSize */
@property (nonatomic, strong) NSNumber *pageSize;
/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** TFCRMSearchView *view  */
@property (nonatomic, weak) TFCRMSearchView *searchView;

/** lists */
@property (nonatomic, strong) NSMutableArray *lists;

/** 查询条件 */
@property (nonatomic, strong) NSMutableDictionary *queryWhere;

/** auths */
@property (nonatomic, strong) NSMutableArray *auths;

/** 权限 */
@property (nonatomic, strong) TFCustomAuthModel *auth;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFReferenceListController

-(NSMutableArray *)auths{
    if (!_auths) {
        _auths = [NSMutableArray array];
    }
    return _auths;
}
-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}

-(NSMutableDictionary *)queryWhere{
    if (!_queryWhere) {
        _queryWhere = [NSMutableDictionary dictionary];
    }
    return _queryWhere;
}

-(NSMutableArray *)lists{
    if (!_lists) {
        _lists = [NSMutableArray array];
    }
    return _lists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    self.pageNo = @1;
    self.pageSize = @10;
    
//    [self.customBL requestTabDataWithSorceBean:self.tradeModel.sorce_bean targetBean:self.tradeModel.target_bean dataId:self.dataId ruleId:@0 dataType:self.tradeModel.condition_type pageNum:self.pageNo pageSize:self.pageSize];
    
    [self.customBL requestCustomModuleAuthWithBean:self.bean];// 权限
    
    [self setupTableView];
    [self setupNavi];
    [self setupCRMSearchView];
    
}

#pragma mark - navigation
- (void)setupNavi{
    self.navigationItem.title = self.naviTitle;
    
    
//    UINavigationItem *item1 = [self itemWithTarget:self action:@selector(searchClicked) image:@"搜索project" highlightImage:@"搜索project"];
    UINavigationItem *item2 = [self itemWithTarget:self action:@selector(addClicked) image:@"加号" highlightImage:@"加号"];
    if (self.auths.count) {
        
        BOOL have = NO;
        for (TFCustomAuthModel *model in self.auths) {
            
            if ([model.auth_code isEqualToNumber:@1]) {
                have = YES;
                break;
            }
        }
        if (have) {
            self.navigationItem.rightBarButtonItems = @[item2];
//            self.navigationItem.rightBarButtonItems = @[item2,item1];
        }else{
            
//            self.navigationItem.rightBarButtonItems = @[item1];
        }
    }else{
//        self.navigationItem.rightBarButtonItems = @[item1];
    }
    
}


- (void)searchClicked{
    TFCustomSearchController  *search = [[TFCustomSearchController alloc] init];
    search.bean = self.bean;
    search.searchMatch = self.fieldName;
    search.searchType = 0;
    [self.navigationController pushViewController:search animated:YES];
}
- (void)addClicked{
    
    TFAddCustomController *add = [[TFAddCustomController alloc] init];
    add.type = 0;
    add.tableViewHeight = SCREEN_HEIGHT - 64;
    add.bean = self.bean;
    add.lastDetailDict = self.lastDetailDict;
    add.relevanceKey = self.fieldName;
    add.dataId = self.dataId;
    add.sorceBean = self.sorceBean;
    add.targetBean = self.targetBean;
    add.refreshAction = ^{
        
        self.pageNo = @1;
        [self.customBL requestTabDataWithTabId:self.tradeModel.id dataAuth:self.auth.data_auth dataId:self.dataId ruleId:@0 moduleId:self.tradeModel.module_id dataType:self.tradeModel.condition_type pageNum:self.pageNo pageSize:self.pageSize];
        
    };
    [self.navigationController pushViewController:add animated:YES];
}

#pragma mark - 初始化筛选View
- (void)setupCRMSearchView{
    TFCRMSearchView *view = [TFCRMSearchView CRMSearchView];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    view.delegate = self;
    self.searchView = view;
    [self.view addSubview:view];
    view.filterBtn.hidden = YES;
    view.arrowImage.hidden = YES;
    
    [self.searchView refreshSearchViewWithTitle:[NSString stringWithFormat:@"全部%@",self.naviTitle] number:0];
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
    
    MJRefreshGifHeader *header = [TFRefresh headerGifRefreshWithBlock:^{
        
        self.pageNo = @1;
        [self.customBL requestTabDataWithTabId:self.tradeModel.id dataAuth:self.auth.data_auth dataId:self.dataId ruleId:@0 moduleId:self.tradeModel.module_id dataType:self.tradeModel.condition_type pageNum:self.pageNo pageSize:self.pageSize];
    }];
    tableView.mj_header = header;
    
    
    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        self.pageNo = @([self.pageNo integerValue] +1);
        [self.customBL requestTabDataWithTabId:self.tradeModel.id dataAuth:self.auth.data_auth dataId:self.dataId ruleId:@0 moduleId:self.tradeModel.module_id dataType:self.tradeModel.condition_type pageNum:self.pageNo pageSize:self.pageSize];
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
    detail.bean = self.bean;
    detail.dataId = [NSNumber numberWithInteger:[model.id.value integerValue]];
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

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customDataList || resp.cmdId == HQCMD_getTabDataList) {
        
//        TFCustomListModel *model = resp.body;
        NSDictionary *dict = resp.body;
        
        TFCustomListModel *model = [[TFCustomListModel alloc] initWithDictionary:dict error:nil];
        
        TFCustomPageModel *listModel = model.pageInfo;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.lists removeAllObjects];
        }
        
        [self.lists addObjectsFromArray:model.dataList];
        
        if ([listModel.totalRows integerValue] == self.lists.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
            self.tableView.mj_footer = nil;
            
            if (self.lists.count < 10) {
                self.tableView.tableFooterView = [UIView new];
            }else{
                self.tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];;
            }
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.lists.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.searchView refreshSearchViewWithTitle:[NSString stringWithFormat:@"全部%@",self.naviTitle] number:self.lists.count];
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_customModuleAuth) {
        
        [self.auths removeAllObjects];
        [self.auths addObjectsFromArray:resp.body];
        self.auth = self.auths.firstObject;
        
        [self.customBL requestTabDataWithTabId:self.tradeModel.id dataAuth:self.auth.data_auth dataId:self.dataId ruleId:@0 moduleId:self.tradeModel.module_id dataType:self.tradeModel.condition_type pageNum:self.pageNo pageSize:self.pageSize];
        
        [self setupNavi];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
