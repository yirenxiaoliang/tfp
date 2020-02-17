//
//  TFCustomListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/8.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomListController.h"
#import "TFCustomListCell.h"
#import "TFAddCustomController.h"
#import "TFCRMSearchView.h"
#import "TFSearchTableView.h"
#import "TFFilterView.h"
#import "TFRefresh.h"
#import "TFCustomSearchController.h"
#import "TFCustomBL.h"
//#import "TFCustomDetailController.h"
#import "TFCustomListModel.h"
#import "HQTFNoContentView.h"
#import "TFCustomAuthModel.h"
#import "TFNewCustomDetailController.h"
#import "TFWebLinkListController.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFFilterModel.h"
#import "TFContactsDepartmentController.h"
#import "TFDepartmentModel.h"

@interface TFCustomListController ()<UITableViewDelegate,UITableViewDataSource,TFCRMSearchViewDelegate,TFSearchTableViewDelegate,TFFilterViewDelegate,HQBLDelegate,UITextViewDelegate>

/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** TFSearchTableView *view */
@property (nonatomic, strong) TFSearchTableView *searchTableView;
/** TFCRMSearchView *view  */
@property (nonatomic, weak) TFCRMSearchView *searchView;
/** TFFilterView *filterVeiw */
@property (nonatomic, strong) TFFilterView *filterVeiw;
/** whereDict */
@property (nonatomic, strong) NSMutableDictionary *whereDict;
/** pageNo */
@property (nonatomic, strong) NSNumber *pageNo;
/** pageSize */
@property (nonatomic, strong) NSNumber *pageSize;
/** customer */
@property (nonatomic, strong) NSNumber *beanType;
/** seaPoolId */
@property (nonatomic, strong) NSNumber *seaPoolId;
/** lists */
@property (nonatomic, strong) NSMutableArray *lists;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** TFBeanTypeModel */
@property (nonatomic, strong) TFBeanTypeModel *typeModel;

/** 搜索字段 */
@property (nonatomic, strong) TFFieldNameModel *searchField;

/** auths */
@property (nonatomic, strong) NSMutableArray *auths;


@property (nonatomic, strong) TFCustomAuthModel *auth;

@end

@implementation TFCustomListController

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
    self.pageSize = @30;
    
    [self setupTableView];
    [self setupNavi];
    [self setupCRMSearchView];
    [self setupSearchTableView];
    [self setupFilterView];
    
    if (!self.module.submenus) {
        [self.customBL requsetCustomChildMenuListWithModuleId:self.module.id];// 子菜单
    }else{
        for (TFBeanTypeModel *model in self.module.submenus) {
            if ([model.select isEqualToNumber:@1]) {
                self.typeModel = model;
                break;
            }
        }
        [self.searchTableView refreshSearchTableViewWithItems:self.module.submenus];
        [self.searchView refreshSearchViewWithTitle:self.typeModel.name number:self.lists.count];
    }
    [self.customBL requestCustomModuleAuthWithBean:self.module.english_name];// 权限
    [self.customBL requsetCustomFilterFieldsWithBean:self.module.english_name];// 筛选条件
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - navigation
- (void)setupNavi{
    
    self.navigationItem.title = self.module.chinese_name;
    
    UINavigationItem *item1 = [self itemWithTarget:self action:@selector(searchClicked) image:@"搜索project" highlightImage:@"搜索project"];
    UINavigationItem *item2 = [self itemWithTarget:self action:@selector(addClicked) image:@"加号" highlightImage:@"加号"];
    UINavigationItem *item3 = [self itemWithTarget:self action:@selector(linkClicked) image:@"链接" highlightImage:@"链接"];
   
    
    if ([self.typeModel.is_seas_pool isEqualToString:@"1"]) {
        
        if ([self.typeModel.is_seas_admin isEqualToString:@"1"]) {
            self.navigationItem.rightBarButtonItems = @[item2,item1,item3];
        }else{
            self.navigationItem.rightBarButtonItems = @[item1,item3];
        }
        
    }else{
        if (self.auths.count) {
            
            BOOL have = NO;
            for (TFCustomAuthModel *model in self.auths) {
                
                if ([model.auth_code isEqualToNumber:@1]) {
                    have = YES;
                    break;
                }
            }
            if (have) {
                self.navigationItem.rightBarButtonItems = @[item2,item1,item3];
            }else{
                
                self.navigationItem.rightBarButtonItems = @[item1,item3];
            }
        }else{
            self.navigationItem.rightBarButtonItems = @[item1,item3];
        }
    }
    
}


- (void)searchClicked{
    
    [self crmSearchViewDidFilterBtn:NO];
    
    TFCustomSearchController  *search = [[TFCustomSearchController alloc] init];
    search.bean = self.module.english_name;
    search.searchMatch = self.searchField.name;
    search.keyLabel = self.searchField.label;
    if ([self.typeModel.is_seas_pool isEqualToString:@"1"]) {
        search.isSeasPool = self.typeModel.is_seas_pool;
        search.seaPoolId = self.typeModel.id;
        search.isSeasAdmin = self.typeModel.is_seas_admin;
    }
    search.beanType = self.beanType;
    search.searchType = 0;
    search.menuType = self.typeModel.type;
    [self.navigationController pushViewController:search animated:YES];
}
- (void)addClicked{
    
    [self crmSearchViewDidFilterBtn:NO];
    TFAddCustomController *add = [[TFAddCustomController alloc] init];
    add.type = 0;
    add.tableViewHeight = SCREEN_HEIGHT - 64;
    add.bean = self.module.english_name;
    add.isSeasPool = self.typeModel.is_seas_pool;
    add.seaPoolId = self.typeModel.id;
    add.moduleId = self.module.id;
    add.refreshAction = ^{
        
        [self.customBL requsetCustomListWithBean:self.module.english_name queryWhere:self.whereDict menuId:self.beanType pageNo:self.pageNo pageSize:self.pageSize seasPoolId:self.seaPoolId fuzzyMatching:nil dataAuth:self.auth.data_auth menuType:self.typeModel.type  menuCondition:self.typeModel.query_condition];
        
    };
    [self.navigationController pushViewController:add animated:YES];
}

-(void)linkClicked{
    
    [self crmSearchViewDidFilterBtn:NO];
    TFWebLinkListController *link = [[TFWebLinkListController alloc] init];
    
    if ([self.typeModel.is_seas_pool isEqualToString:@"1"]) {
        link.source = @3;
        link.seasPoolId = self.typeModel.id;
        link.moduleBean = self.module.english_name;
    }else{
        link.source = @2;
        link.moduleBean = self.module.english_name;
    }

    [self.navigationController pushViewController:link animated:YES];
}

#pragma mark - 初始化filterView
- (void)setupFilterView{
    
    TFFilterView *filterVeiw = [[TFFilterView alloc] initWithFrame:(CGRect){SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_HEIGHT-NaviHeight}];
    filterVeiw.tag = 0x1234554321;
    self.filterVeiw = filterVeiw;
    filterVeiw.delegate = self;
}

#pragma mark - TFFilterViewDelegate
-(void)filterViewDidClicked:(BOOL)show{
    
    self.searchView.show = NO;
}

-(void)filterViewDidSureBtnWithDict:(NSDictionary *)dict{
    self.searchView.show = NO;
    self.pageNo = @1;
    self.whereDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.customBL requsetCustomListWithBean:self.module.english_name queryWhere:self.whereDict menuId:self.beanType pageNo:self.pageNo pageSize:self.pageSize seasPoolId:self.seaPoolId fuzzyMatching:@"" dataAuth:self.auth.data_auth menuType:self.typeModel.type?:@"0"  menuCondition:self.typeModel.query_condition?:@""];
}

-(void)filterViewDidSelectPeopleWithPeoples:(NSArray *)peoples model:(TFFilterModel *)model{
    
//    [self crmSearchViewDidFilterBtn:NO];
    
    TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
    scheduleVC.selectType = 1;
    scheduleVC.isSingleSelect = NO;
    scheduleVC.defaultPoeples = peoples;
    //            scheduleVC.noSelectPoeples = model.selects;
    scheduleVC.dismiss = @1;
    scheduleVC.actionParameter = ^(NSArray *parameter) {
        
        NSMutableArray *bb = [NSMutableArray array];
        for (HQEmployModel *ee in parameter) {
            BOOL have = NO;
            for (HQEmployModel *dd in  model.entrys) {
                if ([[ee.id description] isEqualToString:[dd.id description]]) {
                    have = YES;
                    break;
                }
            }
            if (!have) {
                [bb addObject:ee];
            }
        }
        
        [model.entrys addObjectsFromArray:bb];
        
        [self.filterVeiw refresh];
        
//        [self crmSearchViewDidFilterBtn:YES];
        
    };
    [self.navigationController pushViewController:scheduleVC animated:YES];
}

-(void)filterViewDidSelectDepartmentWithDepartments:(NSArray *)departments model:(TFFilterModel *)model{
    
//    [self crmSearchViewDidFilterBtn:NO];
    TFContactsDepartmentController *scheduleVC = [[TFContactsDepartmentController alloc] init];
    scheduleVC.isSingleUse = YES;
    scheduleVC.type = 1;
    scheduleVC.isSingleSelect = NO;
    scheduleVC.tableViewHeight = self.tableView.height;
    scheduleVC.defaultDepartments = departments;
    scheduleVC.actionParameter = ^(NSArray *parameter) {
//        TFDepartmentModel
        
        NSMutableArray *bb = [NSMutableArray array];
        for (TFDepartmentModel *ee in parameter) {
            BOOL have = NO;
            for (TFDepartmentModel *dd in  model.entrys) {
                if ([[ee.id description] isEqualToString:[dd.id description]]) {
                    have = YES;
                    break;
                }
            }
            if (!have) {
                [bb addObject:ee];
            }
        }
        
        [model.entrys addObjectsFromArray:bb];
        
        [self.filterVeiw refresh];
        
//        [self crmSearchViewDidFilterBtn:YES];
    };
    [self.navigationController pushViewController:scheduleVC animated:YES];
}


#pragma - mark 初始化SearchTableView
- (void)setupSearchTableView{
    self.searchTableView = [[TFSearchTableView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,SCREEN_HEIGHT-NaviHeight-44}];
    self.searchTableView.delegate = self;
}

#pragma mark - TFSearchTableViewDelegate
-(void)searchTableViewDidSelectModel:(TFBeanTypeModel *)model{
    
    self.typeModel = model;
    self.searchView.open = NO;
    if (self.typeModel.is_seas_pool) {
        self.beanType = nil;
        self.seaPoolId = self.typeModel.id;
    }else{
        self.beanType = self.typeModel.id;
        self.seaPoolId = nil;
    }
    [self setupNavi];// 公海池时新增需要权限
    
    [self.searchView refreshSearchViewWithTitle:self.typeModel.name number:self.lists.count];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.customBL requsetCustomListWithBean:self.module.english_name queryWhere:self.whereDict menuId:self.beanType pageNo:self.pageNo pageSize:self.pageSize seasPoolId:self.seaPoolId fuzzyMatching:nil dataAuth:self.auth.data_auth menuType:self.typeModel.type  menuCondition:self.typeModel.query_condition];
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
    [self.searchView refreshSearchViewWithTitle:[NSString stringWithFormat:@"全部%@",self.module.chinese_name] number:0];
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
    
    if (show) {
        
        [self.view addSubview:self.filterVeiw];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.filterVeiw.backgroundColor = RGBAColor(0, 0, 0, .5);
            self.filterVeiw.left = 0;
        }];
        
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            
            self.filterVeiw.left = SCREEN_WIDTH;
            self.filterVeiw.backgroundColor = RGBAColor(0, 0, 0, 0);
        } completion:^(BOOL finished) {
            
            [self.filterVeiw removeFromSuperview];
        }];
        
    }
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, -BottomM/2-5, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    MJRefreshNormalHeader *header = [TFRefresh headerGifRefreshWithBlock:^{
        
        self.pageNo = @1;
        
        [self.customBL requsetCustomListWithBean:self.module.english_name queryWhere:self.whereDict menuId:self.beanType pageNo:self.pageNo pageSize:self.pageSize seasPoolId:self.seaPoolId fuzzyMatching:nil dataAuth:self.auth.data_auth menuType:self.typeModel.type  menuCondition:self.typeModel.query_condition];
    }];
    tableView.mj_header = header;
    
    
    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        self.pageNo = @([self.pageNo integerValue]+1);
        [self.customBL requsetCustomListWithBean:self.module.english_name queryWhere:self.whereDict menuId:self.beanType pageNo:self.pageNo pageSize:self.pageSize seasPoolId:self.seaPoolId fuzzyMatching:nil dataAuth:self.auth.data_auth menuType:self.typeModel.type  menuCondition:self.typeModel.query_condition];
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
    detail.bean = self.module.english_name;
    detail.dataId = [NSNumber numberWithInteger:[model.id.value integerValue]];
    detail.isSeasAdmin = self.typeModel.is_seas_admin;
    detail.seaPoolId = self.seaPoolId;
    detail.moduleId = self.module.id;
    detail.dataAuth = model.auth;
    detail.deleteAction = ^{
      
        [self.lists removeObject:model];
        
        if (self.lists.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.searchView refreshSearchViewWithTitle:self.typeModel.name?:[NSString stringWithFormat:@"全部%@",self.module.chinese_name] number:self.lists.count];
        
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

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customDataList) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        TFCustomListModel *model = resp.body;
        
        if ([self.typeModel.is_seas_admin isEqualToString:@"1"]) {// 公海池管理员
            for (TFCustomListItemModel *item  in model.dataList) {
                for (TFFieldNameModel *field in item.row.row1) {
                    field.secret = nil;
                }
                for (TFFieldNameModel *field in item.row.row2) {
                    field.secret = nil;
                }
                for (TFFieldNameModel *field in item.row.row3) {
                    field.secret = nil;
                }
            }
        }
        
        TFCustomPageModel *listModel = model.pageInfo;
        
        self.searchField = model.operationInfo;
        
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
        
        [self.searchView refreshSearchViewWithTitle:self.typeModel.name?:[NSString stringWithFormat:@"全部%@",self.module.chinese_name] number:[listModel.totalRows integerValue] <= 0 ? 0 : [listModel.totalRows integerValue]];
        
        [self.tableView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    
    if (resp.cmdId == HQCMD_customChildMenuList) {
        NSArray *arr = resp.body;
        self.typeModel = arr.firstObject;
        self.beanType = self.typeModel.id;
        [self.searchTableView refreshSearchTableViewWithItems:resp.body];
        
    }
    
    if (resp.cmdId == HQCMD_customFilterFields) {
        self.filterVeiw.filters = resp.body;
    }
    
    if (resp.cmdId == HQCMD_customModuleAuth) {
        
        [self.auths removeAllObjects];
        [self.auths addObjectsFromArray:resp.body];
        
        if (self.auths.count) {
            self.auth = self.auths.firstObject;
        }
        
        [self.customBL requsetCustomListWithBean:self.module.english_name queryWhere:self.whereDict menuId:self.beanType pageNo:self.pageNo pageSize:self.pageSize seasPoolId:self.seaPoolId fuzzyMatching:nil dataAuth:self.auth.data_auth menuType:self.typeModel.type  menuCondition:self.typeModel.query_condition];// 列表数据
        [self setupNavi];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_footer endRefreshing]; 
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
