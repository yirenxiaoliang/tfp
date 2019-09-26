//
//  TFEmailModuleContactsController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailModuleContactsController.h"
#import "TFCustomListCell.h"
#import "TFAddCustomController.h"
#import "TFCRMSearchView.h"
#import "TFSearchTableView.h"
#import "TFFilterView.h"
#import "TFRefresh.h"
#import "TFCustomBL.h"
#import "TFCustomListModel.h"
#import "HQTFNoContentView.h"
#import "TFCustomAuthModel.h"
#import "TFMailBL.h"
#import "TFEmailAddessBookItemModel.h"
//#import "TFEmailRecentContactsModel.h"
#import "TFEmailModuleAccountModel.h"
#import "TFEmailsNewController.h"

@interface TFEmailModuleContactsController ()<UITableViewDelegate,UITableViewDataSource,TFCRMSearchViewDelegate,TFSearchTableViewDelegate,TFFilterViewDelegate,HQBLDelegate,UITextViewDelegate>

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

@property (nonatomic, strong) NSMutableArray *emails;

@property (nonatomic, strong) TFMailBL *mailBL;

@end

@implementation TFEmailModuleContactsController

-(NSMutableArray *)auths{
    if (!_auths) {
        _auths = [NSMutableArray array];
    }
    return _auths;
}

-(NSMutableArray *)emails{
    if (!_emails) {
        _emails = [NSMutableArray array];
    }
    return _emails;
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
    
    [self.customBL requsetCustomListWithBean:self.moduleBean queryWhere:self.whereDict menuId:self.beanType pageNo:self.pageNo pageSize:self.pageSize seasPoolId:self.seaPoolId fuzzyMatching:nil dataAuth:@2 menuType:@"0" menuCondition:nil];// 列表数据
//    [self.customBL requsetCustomChildMenuListWithModuleId:self.moduleId];// 子菜单
    
    [self setupTableView];
    [self setupNavi];
    [self setupCRMSearchView];
    [self setupSearchTableView];
//    [self setupFilterView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - navigation
- (void)setupNavi{
    self.navigationItem.title = self.naviTitle;
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sureAction) text:@"确定" textColor:GreenColor];
}



#pragma mark - 初始化filterView
- (void)setupFilterView{
    
    TFFilterView *filterVeiw = [[TFFilterView alloc] initWithFrame:(CGRect){SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
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
    [self.customBL requsetCustomListWithBean:self.moduleBean queryWhere:self.whereDict menuId:self.beanType pageNo:self.pageNo pageSize:self.pageSize seasPoolId:self.seaPoolId fuzzyMatching:nil dataAuth:@2 menuType:@"0"  menuCondition:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    [self.searchView refreshSearchViewWithTitle:self.typeModel.name number:self.lists.count];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.customBL requsetCustomListWithBean:self.moduleBean queryWhere:self.whereDict menuId:self.beanType pageNo:self.pageNo pageSize:self.pageSize seasPoolId:self.seaPoolId fuzzyMatching:nil dataAuth:@2 menuType:model.type  menuCondition:model.query_condition];
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
    [self.searchView refreshSearchViewWithTitle:[NSString stringWithFormat:@"全部%@",self.naviTitle] number:0];
}

#pragma mark 确定
- (void)sureAction {

    self.mailBL = [TFMailBL build];
    self.mailBL.delegate = self;
    
    NSString *string = @"";
    for (TFCustomListItemModel *model in self.lists) {
        
        if ([model.select isEqualToNumber:@1]) {
            
//            [self.emails addObject:model];
            string = [string stringByAppendingString:[NSString stringWithFormat:@",%@",model.id.value]];
        }
    }
    
    string = [string substringFromIndex:1];
    
    [self.mailBL getModuleEmailGetEmailFromModuleDetailDataWithBean:self.moduleBean ids:string];
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
        
        [KeyWindow addSubview:self.filterVeiw];
        
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
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    MJRefreshNormalHeader *header = [TFRefresh headerNormalRefreshWithBlock:^{
        
        self.pageNo = @1;
        
        [self.customBL requsetCustomListWithBean:self.moduleBean queryWhere:self.whereDict menuId:self.beanType pageNo:self.pageNo pageSize:self.pageSize seasPoolId:self.seaPoolId fuzzyMatching:nil dataAuth:@2 menuType:@"0"  menuCondition:nil];
    }];
    tableView.mj_header = header;
    
    
    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        self.pageNo = @([self.pageNo integerValue]+1);
        [self.customBL requsetCustomListWithBean:self.moduleBean queryWhere:self.whereDict menuId:self.beanType pageNo:self.pageNo pageSize:self.pageSize seasPoolId:self.seaPoolId fuzzyMatching:nil dataAuth:@2 menuType:@"0" menuCondition:nil];
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
    cell.select = YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFCustomListItemModel *model = self.lists[indexPath.section];
    
    model.select = [model.select isEqualToNumber:@1]?@0:@1;
    
    [self.tableView reloadData];
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
        
        [self.searchView refreshSearchViewWithTitle:self.typeModel.name?:[NSString stringWithFormat:@"全部%@",self.naviTitle] number:[listModel.totalRows integerValue]];
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_customChildMenuList) {
        
        [self.searchTableView refreshSearchTableViewWithItems:resp.body];
        
    }
    
    if (resp.cmdId == HQCMD_customFilterFields) {
        self.filterVeiw.filters = resp.body;
    }
    
    if (resp.cmdId == HQCMD_customModuleAuth) {
        
        [self.auths removeAllObjects];
        [self.auths addObjectsFromArray:resp.body];
        
        [self setupNavi];
    }
    if (resp.cmdId == HQCMD_moduleEmailGetEmailFromModuleDetail) {
        
        NSMutableArray *arr = resp.body;
        
        NSMutableArray *contacts = [NSMutableArray array];
        for (TFEmailModuleAccountModel *model in arr) {
            
            TFEmailAddessBookItemModel *contactsModel = [[TFEmailAddessBookItemModel alloc] init];
            
            
            NSString *emailStr = @"";
            for (TFEmailModuleItemModel *itemModel in model.email_fields) { //遍历出所有邮件组件
                
                
                emailStr = [emailStr stringByAppendingString:[NSString stringWithFormat:@",%@",itemModel.value]];
            }
            
            if (![emailStr isEqualToString:@""]) {
                
                emailStr = [emailStr substringFromIndex:1];
            }
            
            
            contactsModel.mail_account = emailStr;
            
            contactsModel.employee_name = model.first_field.value;
            
            contactsModel.index = @(self.index);
            
            [contacts addObject:contactsModel];
        }
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[TFEmailsNewController class]]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"selectEmialModuleAccountNotification" object:contacts];
                
                [self.navigationController popToViewController:controller animated:YES];
                
                
            }
            
        }
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}


@end
