//
//  TFReferenceSearchController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/10/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFReferenceSearchController.h"
#import "HQTFSearchHeader.h"
#import "HQTFNoContentView.h"
#import "HQTFTwoLineCell.h"
#import "HQCustomerModel.h"
#import "TFCustomBL.h"
#import "TFReferenceSearchCell.h"
#import "TFReferenceListModel.h"
#import "TFReferenceSearchAllRowCell.h"
#import "TFCustomPageModel.h"
#import "TFRefresh.h"
#import "HuiJuHuaQi-Swift.h"

@interface TFReferenceSearchController ()<HQTFSearchHeaderDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HQTFTwoLineCellDelegate,HQBLDelegate,TFSearchHistoryViewDelegate>

/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** 搜索结果 */
@property (nonatomic, strong) NSMutableArray *customers;
/** 搜索结果 */
@property (nonatomic, strong) NSMutableArray *totalCustomers;

/** 搜索历史 */
@property (nonatomic, strong) NSMutableArray *records;

/** NO:显示搜索记录模式 ，YES：搜索模式 */
@property (nonatomic, assign) BOOL dataType;


/** UIView *footerView */
@property (nonatomic, strong) UIView *footerView;

/** TFCRMBL */
@property (nonatomic, strong) TFCustomBL *customBL;


/** keyName */
@property (nonatomic, copy) NSString *keyName;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) TFSearchHistoryView *historyView;

@end

@implementation TFReferenceSearchController

-(TFSearchHistoryView *)historyView{
    if (!_historyView) {
        _historyView = [[TFSearchHistoryView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,300}];
        _historyView.delegate = self;
    }
    return _historyView;
}

#pragma mark - TFSearchHistoryViewDelegate
-(void)searchHistoryViewDidClearWithIndex:(NSInteger)index{
    
    [self.records removeObjectAtIndex:index];
    [[NSUserDefaults standardUserDefaults] setObject:self.records forKey:[NSString stringWithFormat:@"%@%@",CustomerSearchRecord,self.bean]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    if (self.records.count == 0) {
        self.tableView.tableFooterView = nil;
        self.tableView.tableHeaderView = nil;
    }
    [self.historyView refreshViewWithItems:self.records];
    [self.tableView reloadData];
}
-(void)searchHistoryViewDidClickedWithIndex:(NSInteger)index{
    
    self.headerSearch.textField.text = self.records[index];
    [self textFieldShouldReturn:self.headerSearch.textField];
}

-(void)searchHistoryViewHeightWithHeight:(double)height{
    
    self.historyView.height = height;
    self.tableView.tableHeaderView = self.historyView;
}
-(NSMutableArray *)records{
    if (!_records) {
        _records = [NSMutableArray array];
        
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@%@",self.bean,self.searchField,CustomerSearchRecord]];
        [_records addObjectsFromArray:arr];
    }
    return _records;
}

-(NSMutableArray *)customers{
    if (!_customers) {
        _customers = [NSMutableArray array];
        
    }
    return _customers;
}

-(NSMutableArray *)totalCustomers{
    if (!_totalCustomers) {
        _totalCustomers = [NSMutableArray array];
        
    }
    return _totalCustomers;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:nil action:nil text:@""];
    [self.navigationController.navigationBar addSubview:self.headerSearch];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.headerSearch removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupFooterView];
    [self setupTableView];
    
    self.pageSize = 20;
    self.pageNum = 1;
    
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    if (self.type == 0) {// 关联关系
        [self.customBL requsetCustomReferenceWithBean:self.bean relationField:self.searchField form:self.from subform:self.subform pageNum:self.pageNum pageSize:self.pageSize reylonForm:self.reylonForm];
    }else{// 子表选项关联
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (self.searchField) {
            NSDictionary *fff = @{@"controlName":self.searchField,@"controlValue":@(self.searchFieldId)};
            [dict setObject:fff forKey:@"controlField"];
        }
        if (self.bean) {
            [dict setObject:self.bean forKey:@"beanName"];
        }
        if (self.subform) {
            [dict setObject:self.subform forKey:@"subformName"];
        }
        [dict setObject:@{@"pageSize":@(self.pageSize),@"pageNum":@(self.pageNum)} forKey:@"pageInfo"];
        [self.customBL requestSubformRalationWithDict:dict];
    }
}


- (void)setupFooterView{
    
    UIView *footerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,46}];
    footerView.backgroundColor = WhiteColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearClicked)];
    [footerView addGestureRecognizer:tap];
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-30,0.5}];
    [footerView addSubview:line];
    line.backgroundColor = CellSeparatorColor;
    
    UIButton *button = [HQHelper buttonWithFrame:(CGRect){0,10,130,26} target:self action:@selector(clearClicked)];
    [button setTitle:@"清除搜索历史" forState:UIControlStateNormal];
    [button setTitleColor:GreenColor forState:UIControlStateNormal];
    button.layer.borderColor = GreenColor.CGColor;
    //    button.layer.borderWidth = 0.5;
    //    button.layer.masksToBounds = YES;
    //    button.layer.cornerRadius = 5;
    button.titleLabel.font = FONT(14);
    
    [button setImage:IMG(@"clearHistory") forState:UIControlStateNormal];
    [button setImage:IMG(@"clearHistory") forState:UIControlStateNormal];
    
    [footerView addSubview:button];
    //    button.center = CGPointMake(SCREEN_WIDTH/2, 100/2);
    self.footerView = footerView;
}

- (void)clearClicked{
    
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:[NSString stringWithFormat:@"%@%@%@",self.bean,self.searchField,CustomerSearchRecord]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.tableView.tableFooterView = nil;
    [self.records removeAllObjects];
    self.tableView.tableHeaderView = nil;
    [self.tableView reloadData];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, -BottomM, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    if (!self.dataType) {
        if (self.records.count) {
//            self.tableView.tableFooterView = self.footerView;
//            tableView.tableHeaderView = self.historyView;
//            [self.historyView refreshViewWithItems:self.records];
        }
    }
    
    tableView.mj_header = [TFRefresh headerNormalRefreshWithBlock:^{
        
        self.pageNum = 1;
        
        if (self.type == 0) {
            [self.customBL requsetCustomReferenceWithBean:self.bean relationField:self.searchField form:self.from subform:self.subform pageNum:self.pageNum pageSize:self.pageSize reylonForm:self.reylonForm];
        }else{// 子表关联
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (self.searchField) {
                NSDictionary *fff = @{@"controlName":self.searchField,@"controlValue":@(self.searchFieldId)};
                [dict setObject:fff forKey:@"controlField"];
            }
            if (self.bean) {
                [dict setObject:self.bean forKey:@"beanName"];
            }
            if (self.subform) {
                [dict setObject:self.subform forKey:@"subformName"];
            }
            if (self.headerSearch.textField.text) {
                [dict setObject:self.headerSearch.textField.text forKey:@"fuzzySearch"];
            }
            [dict setObject:@{@"pageSize":@(self.pageSize),@"pageNum":@(self.pageNum)} forKey:@"pageInfo"];
            [self.customBL requestSubformRalationWithDict:dict];

        }
    }];
    
    
    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        self.pageNum ++;
        
        if (self.type == 0) {
            
            [self.customBL requsetCustomReferenceWithBean:self.bean relationField:self.searchField form:self.from subform:self.subform pageNum:self.pageNum pageSize:self.pageSize reylonForm:self.reylonForm];
        }else{// 子表关联
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (self.searchField) {
                NSDictionary *fff = @{@"controlName":self.searchField,@"controlValue":@(self.searchFieldId)};
                [dict setObject:fff forKey:@"controlField"];
            }
            if (self.bean) {
                [dict setObject:self.bean forKey:@"beanName"];
            }
            if (self.subform) {
                [dict setObject:self.subform forKey:@"subformName"];
            }
            if (self.headerSearch.textField.text) {
                [dict setObject:self.headerSearch.textField.text forKey:@"fuzzySearch"];
            }
            [dict setObject:@{@"pageSize":@(self.pageSize),@"pageNum":@(self.pageNum)} forKey:@"pageInfo"];
            [self.customBL requestSubformRalationWithDict:dict];
        }
        
    }];
    tableView.mj_footer = footer;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataType) {
        return self.customers.count;
    }else{
//        return self.records.count;
        return 0;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.dataType) {
        
        TFReferenceListModel *model = self.customers[indexPath.section];
            
//        TFReferenceSearchCell *cell = [TFReferenceSearchCell referenceSearchCellWithTableView:tableView];
//        [cell refreshCellWithRows:model.row];
//        return cell;
        
        
        TFReferenceSearchAllRowCell *cell = [TFReferenceSearchAllRowCell referenceSearchAllRowCellWithTableView:tableView];
        [cell refreshCellWithRows:model.row];
        if (self.isMulti) {
            cell.selectImage.hidden = NO;
            if ([model.select isEqualToNumber:@1]) {
                cell.selectImage.image = IMG(@"选中");
            }else{
                cell.selectImage.image = IMG(@"没选中");
            }
        }else{
            cell.selectImage.hidden = YES;
        }
        return cell;
        
    }else{
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.topLabel.text = self.records[indexPath.section];
        
        cell.titleImageWidth = 0;
        cell.type = TwoLineCellTypeOne;
        cell.delegate = self;
        cell.enterImgTrailW.constant = 10;
        [cell.enterImage setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [cell.enterImage setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateHighlighted];
        if (self.records.count-1 == indexPath.section) {
            cell.bottomLine.hidden = YES;
        }else{
            cell.bottomLine.hidden = NO;
        }
        cell.enterImage.tag = 0x123 + indexPath.section;
        return cell;
        
    }
    
}


- (void)twoLineCell:(HQTFTwoLineCell *)cell didEnterImage:(UIButton *)enterBtn{
    
    if (!self.dataType) {
        
        [self.records removeObjectAtIndex:enterBtn.tag - 0x123];
        [[NSUserDefaults standardUserDefaults] setObject:self.records forKey:[NSString stringWithFormat:@"%@%@%@",self.bean,self.searchField,CustomerSearchRecord]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        if (self.records.count == 0) {
            self.tableView.tableFooterView = nil;
        }
        
        [self.tableView reloadData];
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (!self.dataType) {
        self.headerSearch.textField.text = self.records[indexPath.section];
        [self textFieldShouldReturn:self.headerSearch.textField];
    }else{
        
        if (self.isMulti) {
            TFReferenceListModel *model = self.customers[indexPath.section];
            model.select = [model.select isEqualToNumber:@1] ? @0 :@1;
            [tableView reloadData];
        }else{
            [self.navigationController popViewControllerAnimated:NO];
            if (self.parameterAction) {
                self.parameterAction(self.customers[indexPath.section]);
            }
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataType) {
        TFReferenceListModel *model = self.customers[indexPath.section];
        
//        return [TFReferenceSearchCell refreshCellHeightWithRows:model.row];
        return [TFReferenceSearchAllRowCell refreshCellHeightWithRows:model.row];
    }else{
        return 64;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.dataType) {
        return 8;
    }else{
        return 0;
    }
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


- (void)setupNavi{
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    self.headerSearch = headerSearch;
    headerSearch.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    if (self.isMulti) {
        headerSearch.type = SearchHeaderTypeTwoBtn;
    }else{
        headerSearch.type = SearchHeaderTypeMove;
    }
    headerSearch.textField.returnKeyType = UIReturnKeySearch;
    headerSearch.delegate = self;
    headerSearch.textField.delegate = self;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    textField.text = [self.from valueForKey:self.searchField];
}

- (void)searchHeaderTextChange:(UITextField *)textField{
    
    if (textField.text.length <= 0) {
        
        self.dataType = NO;
        self.tableView.tableFooterView = self.footerView;
        self.tableView.backgroundView = [UIView new];
        self.tableView.tableHeaderView = self.historyView;
        [self.historyView refreshViewWithItems:self.records];
        [self.tableView reloadData];
    }
    self.from[self.searchField] = textField.text;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    self.pageNum = 1;
    if (textField.text.length == 0) {
        if (self.type == 0) {
            
            [self.customBL requsetCustomReferenceWithBean:self.bean relationField:self.searchField form:self.from subform:self.subform pageNum:self.pageNum pageSize:self.pageSize reylonForm:self.reylonForm];
        }else{// 子表关联
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (self.searchField) {
                [dict setObject:self.searchField forKey:@"controlField"];
            }
            if (self.bean) {
                [dict setObject:self.bean forKey:@"beanName"];
            }
            if (self.subform) {
                [dict setObject:self.subform forKey:@"subformName"];
            }
            if (self.headerSearch.textField.text) {
                [dict setObject:self.headerSearch.textField.text forKey:@"fuzzySearch"];
            }
            [dict setObject:@{@"pageSize":@(self.pageSize),@"pageNum":@(self.pageNum)} forKey:@"pageInfo"];
            [self.customBL requestSubformRalationWithDict:dict];
        }
        return YES;
    }
    
    [self.records removeAllObjects];
    self.from[self.searchField] = textField.text;
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@%@",self.bean,self.searchField,CustomerSearchRecord]];
    [self.records addObjectsFromArray:arr];
    
    for (NSString *str in self.records) {
        
        if ([self.from[self.searchField] isEqualToString:str]) {
            
            [self.records removeObject:str];
            break;
        }
        
    }
    
    [self.records insertObject:textField.text atIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.records forKey:[NSString stringWithFormat:@"%@%@%@",self.bean,self.searchField,CustomerSearchRecord]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.type == 0) {
        
        [self.customBL requsetCustomReferenceWithBean:self.bean relationField:self.searchField form:self.from subform:self.subform pageNum:self.pageNum pageSize:self.pageSize reylonForm:self.reylonForm];
    }else{// 子表关联
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (self.searchField) {
            [dict setObject:self.searchField forKey:@"controlField"];
        }
        if (self.bean) {
            [dict setObject:self.bean forKey:@"beanName"];
        }
        if (self.subform) {
            [dict setObject:self.subform forKey:@"subformName"];
        }
        if (self.headerSearch.textField.text) {
            [dict setObject:self.headerSearch.textField.text forKey:@"fuzzySearch"];
        }
        [dict setObject:@{@"pageSize":@(self.pageSize),@"pageNum":@(self.pageNum)} forKey:@"pageInfo"];
        [self.customBL requestSubformRalationWithDict:dict];
    }
    
    return YES;
}


-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"没有找到相关信息~"];
    }
    return _noContentView;
}



#pragma mark - searchHeader Deleaget

- (void)searchHeaderleftBtnClicked{
    
    [self.view endEditing:YES];
    [self.headerSearch removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchHeaderRightBtnClicked{
    
    if (self.isMulti) {
        NSMutableArray *arr = [NSMutableArray array];
        for (TFReferenceListModel *model in self.customers) {
            if ([model.select isEqualToNumber:@1]) {
                [arr addObject:model];
            }
        }
        if (arr.count == 0) {
            [MBProgressHUD showError:@"请选择" toView:self.view];
            return;
        }
        
        // 子表关联
        if (self.type == 1) {
            for (TFReferenceListModel *model in arr) {
                NSMutableDictionary *relationField = [NSMutableDictionary dictionary];
                for (TFFieldNameModel *field in model.row) {
                    if ([HQHelper dictionaryWithJsonString:field.value]) {
                        [relationField setObject:[HQHelper dictionaryWithJsonString:field.value] forKey:field.name];
                    }else{
                        [relationField setObject:[HQHelper stringWithFieldNameModel:field] forKey:field.name];
                    }
                }
                model.relationField = relationField;
            }
        }
        
        if (self.parameterAction) {
            self.parameterAction(arr);
        }
        [self searchHeaderleftBtnClicked];
        
    }else{
        [self searchHeaderleftBtnClicked];
    }
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customRefernceSearch || resp.cmdId == HQCMD_subformRelation) {
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.dataType = YES;
        
        TFCustomPageModel *page = resp.data;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.customers removeAllObjects];
        }
        
        [self.customers addObjectsFromArray:resp.body];
        
        if ([page.totalRows integerValue] <= self.customers.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.customers.count) {
            
            self.tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:[NSString stringWithFormat:@"找到%ld条数据",[page.totalRows integerValue]] textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
            self.tableView.backgroundView = [UIView new];
            self.tableView.tableHeaderView = nil;
        }else{
            
            self.tableView.tableFooterView = nil;
            self.tableView.tableHeaderView = nil;
            self.tableView.backgroundView = self.noContentView;
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
