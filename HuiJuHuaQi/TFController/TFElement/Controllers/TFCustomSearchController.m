//
//  TFCustomSearchController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomSearchController.h"
#import "HQTFSearchHeader.h"
#import "HQTFNoContentView.h"
#import "HQTFTwoLineCell.h"
#import "TFCustomBL.h"
#import "TFCustomListCell.h"
//#import "TFCustomDetailController.h"
#import "TFNewCustomDetailController.h"
#import "TFReferenceListModel.h"
#import "TFReferenceSearchCell.h"
#import "TFCustomListModel.h"
#import "TFRefresh.h"
#import "HuiJuHuaQi-Swift.h"

@interface TFCustomSearchController ()<HQTFSearchHeaderDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HQTFTwoLineCellDelegate,HQBLDelegate,TFSearchHistoryViewDelegate>


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

/** pageNo */
@property (nonatomic, strong) NSNumber *pageNo;
/** pageSize */
@property (nonatomic, strong) NSNumber *pageSize;


@property (nonatomic, strong) TFSearchHistoryView *historyView;

@end

@implementation TFCustomSearchController

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
        
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",CustomerSearchRecord,self.bean]];
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
    
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    self.keyName = [NSString stringWithFormat:@"%@",self.searchMatch];
    
    self.pageNo = @1;
    self.pageSize = @10;
    
    
    if (self.keyWord && ![self.keyWord isEqualToString:@""]) {
        self.dataType = YES;
        self.headerSearch.textField.text = self.keyWord;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        if (self.searchType == 0) {
            
            [self.customBL requsetCustomListWithBean:self.bean queryWhere:@{} menuId:self.beanType pageNo:self.pageNo pageSize:self.pageSize seasPoolId:self.seaPoolId fuzzyMatching:self.keyWord dataAuth:self.auth.data_auth menuType:self.menuType  menuCondition:nil];
            
            
        }else{
            [self.customBL requsetCustomRecheckingWithBean:self.bean searchField:self.keyName keyWord:self.keyWord searchLabel:self.keyLabel processId:self.processId dataId:self.dataId];
        }
    }
    if (self.searchType == 0) {
        
        //            MJRefreshGifHeader *header = [TFRefresh headerGifRefreshWithBlock:^{
        //
        //                self.pageNo = @1;
        //
        //                [self.customBL requsetCustomListWithBean:self.bean queryWhere:@{} menuId:self.beanType pageNo:self.pageNo pageSize:self.pageSize seasPoolId:self.seaPoolId fuzzyMatching:self.keyWord];
        //            }];
        
        //            self.tableView.mj_header = header;
        
        
        MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
            
            self.pageNo = @([self.pageNo integerValue]+1);
            [self.customBL requsetCustomListWithBean:self.bean queryWhere:@{} menuId:self.beanType pageNo:self.pageNo pageSize:self.pageSize seasPoolId:self.seaPoolId fuzzyMatching:self.keyWord dataAuth:self.auth.data_auth menuType:self.menuType menuCondition:nil];
        }];
        self.tableView.mj_footer = footer;
    }
    
    [self setupSearchPlacehoder];
    
    if (!self.dataType) {
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",CustomerSearchRecord,self.bean]];
        if (arr.count) {
            self.tableView.backgroundView = nil;
        }else{
            self.tableView.backgroundView = self.noContentView;
        }
    }
}

/** 设置搜索框提示文字 */
- (void)setupSearchPlacehoder{
    
    self.headerSearch.textField.placeholder = @"请输入一个及以上字符";
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customDataList) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.customers removeAllObjects];
        TFCustomListModel *model = resp.body;
        TFCustomPageModel *pageInfo = model.pageInfo;
        [self.customers addObjectsFromArray:model.dataList];
        
        if (self.searchType == 0) {
            
            if ([pageInfo.totalRows integerValue] <= self.customers.count) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }else {
                
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
        
        if (self.customers.count) {
            
            self.tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:[NSString stringWithFormat:@"找到%ld条数据",[pageInfo.totalRows integerValue]] textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
            self.tableView.backgroundView = [UIView new];
            self.tableView.tableHeaderView = nil;
        }else{
            
            self.tableView.tableFooterView = nil;
            self.tableView.tableHeaderView = nil;
            
            self.tableView.backgroundView = self.noContentView;
        }
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_customChecking) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.customers removeAllObjects];
        
        [self.customers addObjectsFromArray:resp.body];
        
        if (self.customers.count) {
            
            self.tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:[NSString stringWithFormat:@"找到%ld条数据",self.customers.count] textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
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
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
    
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:[NSString stringWithFormat:@"%@%@",CustomerSearchRecord,self.bean]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.tableView.tableFooterView = nil;
    [self.records removeAllObjects];
    self.tableView.tableHeaderView = nil;
    self.tableView.backgroundView = self.noContentView;
    [self.tableView reloadData];
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
    
    if (!self.dataType) {
        if (self.records.count) {
            self.tableView.tableFooterView = self.footerView;
            tableView.tableHeaderView = self.historyView;
            [self.historyView refreshViewWithItems:self.records];
        }
    }
    
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
        
        if (self.searchType == 0) {
            
            TFCustomListItemModel *model = self.customers[indexPath.section];
            
            TFCustomListCell *cell = [TFCustomListCell customListCellWithTableView:tableView];
            [cell refreshCustomListCellWithModel:model];
            return cell;
        }else{
            
            TFReferenceListModel *model = self.customers[indexPath.section];
            
            TFReferenceSearchCell *cell = [TFReferenceSearchCell referenceSearchCellWithTableView:tableView];
            [cell refreshCellWithRows:model.row];
            return cell;
            
        }
        
        
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
        [[NSUserDefaults standardUserDefaults] setObject:self.records forKey:[NSString stringWithFormat:@"%@%@",CustomerSearchRecord,self.bean]];
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
        
        TFCustomListItemModel *model = self.customers[indexPath.section];
        
        if (self.searchType == 0) {
//            TFCustomDetailController *detail = [[TFCustomDetailController alloc] init];
            TFNewCustomDetailController *detail = [[TFNewCustomDetailController alloc] init];
            detail.bean = self.bean;
            detail.dataAuth = model.auth;
            detail.dataId = [NSNumber numberWithInteger:[model.id.value integerValue]];
            detail.isSeasAdmin = self.isSeasAdmin;
            detail.seaPoolId = self.seaPoolId;
            detail.deleteAction = ^{
                
                [self.customers removeObject:model];
                
                if (self.customers.count == 0) {
                    
                    self.tableView.backgroundView = self.noContentView;
                }else{
                    self.tableView.backgroundView = [UIView new];
                }
                
                [self.tableView reloadData];
            };
            detail.refreshAction = ^{
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:detail animated:YES];

        }else{
            
//            if (self.parameterAction) {
//                self.parameterAction(model);
//            }
            
        }

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataType) {
        
        if (self.searchType == 0) {
            
            TFCustomListItemModel *model = self.customers[indexPath.section];
            return [TFCustomListCell refreshCustomListCellHeightWithModel:model];
        }else{
            
            TFReferenceListModel *model = self.customers[indexPath.section];
            
            return [TFReferenceSearchCell refreshCellHeightWithRows:model.row];
        }
        
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
    headerSearch.type = SearchHeaderTypeMove;
    headerSearch.textField.returnKeyType = UIReturnKeySearch;
    headerSearch.delegate = self;
    headerSearch.textField.delegate = self;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    textField.text = self.keyWord;
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
    self.keyWord = textField.text;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length < 1) {
        [MBProgressHUD showError:@"请输入一个及以上字符" toView:self.view];
        return YES;
    }
    
    [self.records removeAllObjects];
    self.keyWord = textField.text;
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",CustomerSearchRecord,self.bean]];
    [self.records addObjectsFromArray:arr];
    
    for (NSString *str in self.records) {
        
        if ([self.keyWord isEqualToString:str]) {
            
            [self.records removeObject:str];
            break;
        }
        
    }
    
    [self.records insertObject:textField.text atIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.records forKey:[NSString stringWithFormat:@"%@%@",CustomerSearchRecord,self.bean]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.dataType = YES;
    
    [self.headerSearch.textField resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.searchType == 0) {
        
        [self.customBL requsetCustomListWithBean:self.bean queryWhere:@{} menuId:self.beanType pageNo:self.pageNo pageSize:self.pageSize seasPoolId:self.seaPoolId fuzzyMatching:self.keyWord dataAuth:self.auth.data_auth menuType:self.menuType  menuCondition:nil];
    }else{
        [self.customBL requsetCustomRecheckingWithBean:self.bean searchField:self.keyName keyWord:self.keyWord searchLabel:self.keyLabel processId:self.processId dataId:self.dataId];
    }
    
    return YES;
}


-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
    }
    return _noContentView;
}



#pragma mark - searchHeader Deleaget

-(void)searchHeaderCancelClicked{
    
    [self.view endEditing:YES];
    [self.headerSearch removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
