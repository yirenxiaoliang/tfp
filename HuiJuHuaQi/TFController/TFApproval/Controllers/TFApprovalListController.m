//
//  TFApprovalListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFApprovalListController.h"
#import "TFApprovalListCell.h"
#import "TFApprovalDetailController.h"
#import "TFCustomBL.h"
#import "TFRefresh.h"
#import "TFApprovalListModel.h"
#import "HQTFNoContentView.h"
#import "TFEmailApprovalController.h"
#import "TFApprovalSearchView.h"
#import "TFAddCustomController.h"
#import "TFCRMSearchView.h"
#import "TFSearchTableView.h"
#import "TFFilterView.h"

@interface TFApprovalListController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFApprovalSearchViewDelegate,UITextFieldDelegate,TFCRMSearchViewDelegate,TFSearchTableViewDelegate,TFFilterViewDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;

/** dataList */
@property (nonatomic, strong) NSMutableArray *dataList;

/** pageNo */
@property (nonatomic, strong) NSNumber *pageNo;
/** pageSize */
@property (nonatomic, strong) NSNumber *pageSize;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** querryWhere */
@property (nonatomic, strong) NSDictionary *querryWhere;

/** searchView */
@property (nonatomic, strong) TFApprovalSearchView *searchView;

/** keyword */
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, weak) TFCRMSearchView *downView;
@property (nonatomic, strong) TFSearchTableView *searchTableView;
@property (nonatomic, strong) TFFilterView *filterVeiw;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, strong) NSMutableArray *types;
@property (nonatomic, strong) TFBeanTypeModel *currentType;

@end

@implementation TFApprovalListController

-(NSMutableArray *)allSelects{
    if (!_allSelects) {
        _allSelects = [NSMutableArray array];
    }
    return _allSelects;
}

-(TFApprovalSearchView *)searchView{
    if (!_searchView) {
        
        _searchView = [TFApprovalSearchView approvalSearchView];
        _searchView.frame = (CGRect){0,0,SCREEN_WIDTH,46};
        _searchView.type = 1;
        _searchView.textFiled.returnKeyType = UIReturnKeySearch;
        _searchView.textFiled.delegate = self;
        _searchView.textFiled.placeholder = @"请输入关键字搜索";
        _searchView.delegate = self;
        _searchView.textFiled.backgroundColor = CellSeparatorColor;
        _searchView.searchBtn.hidden = YES;
        _searchView.backgroundColor = WhiteColor;
    }
    return _searchView;
}

#pragma mark - TFApprovalSearchViewDelegate
-(void)approvalSearchViewTextChange:(UITextField *)textField{
    
    self.keyword = textField.text;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.customBL requestGetApprovalWithBean:self.module.english_name keyword:self.keyword pageNum:self.pageNo pageSize:self.pageSize];
    
    return YES;
}


-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}

-(NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![self.type isEqualToNumber:@4]) {
        
        self.pageNo = @1;
        [self.customBL requsetApprovalListWithType:self.type pageNum:self.pageNo pageSize:self.pageSize querryWhere:self.querryWhere];
        [self.customBL requestCustomApprovalSearchMenuWithType:self.type];
    }else{
        
//        [self.customBL requestGetApprovalWithBean:self.module.english_name keyword:self.keyword pageNum:self.pageNo pageSize:self.pageSize];
        [self.customBL requsetApprovalListWithType:@([self.currentType.type integerValue]) pageNum:self.pageNo pageSize:self.pageSize querryWhere:self.querryWhere];
        [self.customBL requestCustomApprovalSearchMenuWithType:@([self.currentType.type integerValue])];
        
        self.navigationItem.title = self.module.chinese_name;
        UIBarButtonItem *item1 = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
        UIBarButtonItem *item2 = [self itemWithTarget:self action:@selector(add) text:@"新增" textColor:GreenColor];
        self.navigationItem.rightBarButtonItems = @[item1,item2];
    }
}

-(void)add{
    
    TFAddCustomController *add = [[TFAddCustomController alloc] init];
    add.bean = self.module.english_name;
    add.moduleId = self.module.id;
    add.tableViewHeight = SCREEN_HEIGHT - NaviHeight;
    add.taskBlock = ^(NSMutableDictionary *data) {
        
        if (self.refreshAction) {
            [self.navigationController popViewControllerAnimated:NO];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            TFApprovalListItemModel *model = [[TFApprovalListItemModel alloc] init];
            model.id = [data valueForKey:@"data"];
            [dict setObject:[data valueForKey:@"data"] forKey:@"data"];
            [dict setObject:@[model] forKey:@"list"];
            
            self.refreshAction(dict);
        }
    };
    [self.navigationController pushViewController:add animated:YES];
}

/** 确定 */
- (void)sure{
    
    if (self.allSelects.count == 0) {
        [MBProgressHUD showError:@"请选择审批" toView:self.view];
        return;
    }
    
    if (self.refreshAction) {
        [self.navigationController popViewControllerAnimated:NO];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSString *ids = @"";
        NSMutableArray *arr = [NSMutableArray array];
        for (TFApprovalListItemModel *model in self.allSelects) {
            if ([ids containsString:[NSString stringWithFormat:@"%@,",model.approval_data_id]]) {
                continue;
            }
            ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%@,",[model.approval_data_id description]]];
            [arr addObject:model];
        }
        if (ids.length) {
            ids = [ids substringToIndex:ids.length-1];
        }
        [dict setObject:ids forKey:@"data"];
        [dict setObject:arr forKey:@"list"];
        
        self.refreshAction(dict);
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.masksToBounds = YES;
    [self setupTableView];
    self.pageNo = @1;
    self.pageSize = @10;
    self.keyword = @"";
    
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchList:) name:@"ApprovalSearchList" object:nil];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([self.type isEqualToNumber:@4]) {
        [self setupCRMSearchView];
        [self setupSearchTableView];
        [self setupFilterView];
        NSArray *arr = @[@"我发起的",@"待我审批",@"我已审批",@"抄送到我"];
        self.types = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++) {
            TFBeanTypeModel *model = [[TFBeanTypeModel alloc] init];
            model.name = arr[i];
            model.type = [NSString stringWithFormat:@"%ld",i];
            [self.types addObject:model];
        }
        self.currentType = self.types.firstObject;
        [self.searchTableView refreshSearchTableViewWithItems:self.types];
    }
    
}

- (void)searchList:(NSNotification *)note{
    
    if ([note.object isEqualToNumber:self.type]) {
        
        self.pageNo = @1;
        self.querryWhere = note.userInfo;
        [self.customBL requsetApprovalListWithType:self.type pageNum:self.pageNo pageSize:self.pageSize querryWhere:self.querryWhere];
    }
    
}

#pragma mark - 初始化筛选View
- (void)setupCRMSearchView{
    TFCRMSearchView *view = [TFCRMSearchView CRMSearchView];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    view.delegate = self;
    self.downView = view;
    [self.view addSubview:view];
    [self.downView refreshSearchViewWithTitle:[NSString stringWithFormat:@"我发起的"] number:0];
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
    self.show = show;
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

#pragma - mark 初始化SearchTableView
- (void)setupSearchTableView{
    self.searchTableView = [[TFSearchTableView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,SCREEN_HEIGHT-NaviHeight-44}];
    self.searchTableView.delegate = self;
}

#pragma mark - TFSearchTableViewDelegate
-(void)searchTableViewDidSelectModel:(TFBeanTypeModel *)model{
    
    [self.downView refreshSearchViewWithTitle:model.name number:0];
    self.downView.open = NO;
    self.currentType = model;
    
    self.pageNo = @1;
    [self.customBL requsetApprovalListWithType:@([self.currentType.type integerValue]) pageNum:self.pageNo pageSize:self.pageSize querryWhere:self.querryWhere];
    
}

-(void)searchTableViewDidClickedBackgruod{
    
    self.downView.open = NO;
}

#pragma mark - 初始化filterView
- (void)setupFilterView{
    
    TFFilterView *filterVeiw = [[TFFilterView alloc] initWithFrame:(CGRect){SCREEN_WIDTH,44,SCREEN_WIDTH,SCREEN_HEIGHT-NaviHeight-44}];
    filterVeiw.tag = 0x1234554321;
    self.filterVeiw = filterVeiw;
    filterVeiw.delegate = self;
}

#pragma mark - TFFilterViewDelegate
-(void)filterViewDidClicked:(BOOL)show{
    
    [self filterClick];
    
}

-(void)filterViewDidSureBtnWithDict:(NSDictionary *)dict{
    
    [self filterClick];
    
    self.pageNo = @1;
    self.querryWhere = dict;
    [self.customBL requsetApprovalListWithType:@([self.currentType.type integerValue]) pageNum:self.pageNo pageSize:self.pageSize querryWhere:self.querryWhere];
}

- (void)filterClick{
    
    if (!self.show) {
        self.show = YES;
        [self.view addSubview:self.filterVeiw];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.filterVeiw.backgroundColor = RGBAColor(0, 0, 0, .5);
            self.filterVeiw.left = 0;
        }];
        
    }else{
        self.show = NO;
        [UIView animateWithDuration:0.25 animations:^{
            
            self.filterVeiw.left = SCREEN_WIDTH;
            self.filterVeiw.backgroundColor = RGBAColor(0, 0, 0, 0);
        } completion:^(BOOL finished) {
            
            [self.filterVeiw removeFromSuperview];
        }];
        
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customApprovalList || resp.cmdId == HQCMD_getApprovalListWithBean) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        TFApprovalListModel *model = resp.body;
        
        if (self.tableView.mj_footer.isRefreshing) {
            
            [self.tableView.mj_footer endRefreshing];
            
            [self.dataList addObjectsFromArray:model.dataList];
            
            
        }else{
            
            [self.tableView.mj_header endRefreshing];
            
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:model.dataList];
        }
        if ([model.pageInfo.totalRows integerValue] <= self.dataList.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.dataList.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        for (TFApprovalListItemModel *mo in self.allSelects) {
            
            for (TFApprovalListItemModel *model1 in self.dataList) {
                
                if ([mo.id isEqualToNumber:model1.id]) {
                    
                    model1.select = @1;
                    break;
                }
            }
        }
        
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_customApprovalSearchMenu) {
        
        if (![self.type isEqualToNumber:@4]) {
            if (self.refreshAction) {
                self.refreshAction(resp.body);
            }
        }
        if ([self.type isEqualToNumber:@4]) {
            self.filterVeiw.filters = resp.body;
        }
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    if (self.special) {
        tableView.frame = CGRectMake(-15, 0, SCREEN_WIDTH+30, SCREEN_HEIGHT-NaviHeight);
    }
    if ([self.type isEqualToNumber:@4]) {
        tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    }else{
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 65, 0);
    }
    tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    MJRefreshGifHeader *header = [TFRefresh headerGifRefreshWithBlock:^{
        
        self.pageNo = @1;
        
        if (![self.type isEqualToNumber:@4]) {
            
            [self.customBL requsetApprovalListWithType:self.type pageNum:self.pageNo pageSize:self.pageSize querryWhere:self.querryWhere];
        }else{
            
//            [self.customBL requestGetApprovalWithBean:self.module.english_name keyword:self.keyword pageNum:self.pageNo pageSize:self.pageSize];
            [self.customBL requsetApprovalListWithType:@([self.currentType.type integerValue]) pageNum:self.pageNo pageSize:self.pageSize querryWhere:self.querryWhere];
        }
    }];
    tableView.mj_header = header;
    
    
    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        self.pageNo = @([self.pageNo integerValue]+1);
        
        if (![self.type isEqualToNumber:@4]) {
            
            [self.customBL requsetApprovalListWithType:self.type pageNum:self.pageNo pageSize:self.pageSize querryWhere:self.querryWhere];
        }else{
            
//            [self.customBL requestGetApprovalWithBean:self.module.english_name keyword:self.keyword pageNum:self.pageNo pageSize:self.pageSize];

            [self.customBL requsetApprovalListWithType:@([self.currentType.type integerValue]) pageNum:self.pageNo pageSize:self.pageSize querryWhere:self.querryWhere];
        }
        
    }];
    tableView.mj_footer = footer;
    
//    if (self.quote) {
//        tableView.tableHeaderView = self.searchView;
//    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFApprovalListCell *cell = [TFApprovalListCell approvalListCellWithTableView:tableView];
    [cell refreshCellWithModel:self.dataList[indexPath.row]];
    cell.quote = self.quote;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.quote) {
        
        TFApprovalListItemModel *model = self.dataList[indexPath.row];
        
        model.select = [model.select isEqualToNumber:@1] ? @0 : @1;
        
        if ([model.select isEqualToNumber:@1]) {
            
            [self.allSelects addObject:model];
            
        }else{
            
            for (TFApprovalListItemModel *model1 in self.allSelects) {
                
                if ([model.id isEqualToNumber:model1.id]) {
                    
                    [self.allSelects removeObject:model1];
                    break;
                }
            }
        }
        
        [tableView reloadData];
        
    }else{
        
        TFApprovalListItemModel *model = self.dataList[indexPath.row];
        if ([model.module_bean isEqualToString:@"mail_box_scope"]) {
            
            TFEmailApprovalController *email = [[TFEmailApprovalController alloc] init];
            email.listType = [self.type integerValue];
            email.approvalItem = model;
            
            email.deleteAction = ^{
                
                self.pageNo = @1;
                
                [self.customBL requsetApprovalListWithType:self.type pageNum:self.pageNo pageSize:self.pageSize querryWhere:self.querryWhere];
            };
            email.refreshAction = ^{
                
                self.pageNo = @1;
                
                [self.customBL requsetApprovalListWithType:self.type pageNum:self.pageNo pageSize:self.pageSize querryWhere:self.querryWhere];
            };
            [self.navigationController pushViewController:email animated:YES];
            return;
        }
        
        TFApprovalDetailController *detail = [[TFApprovalDetailController alloc] init];
        detail.approvalItem = model;
        detail.listType = [self.type integerValue];
        detail.deleteAction = ^{
            
            self.pageNo = @1;
            
            [self.customBL requsetApprovalListWithType:self.type pageNum:self.pageNo pageSize:self.pageSize querryWhere:self.querryWhere];
        };
        detail.refreshAction = ^{
            
            self.pageNo = @1;
            
            [self.customBL requsetApprovalListWithType:self.type pageNum:self.pageNo pageSize:self.pageSize querryWhere:self.querryWhere];
        };
        [self.navigationController pushViewController:detail animated:YES];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 78;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8;
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
