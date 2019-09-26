
//
//  TFSelectCustomListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/31.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectCustomListController.h"
#import "TFCustomListItemModel.h"
#import "TFCustomListCell.h"
#import "TFCustomBL.h"
#import "TFRefresh.h"
#import "TFCustomListModel.h"
#import "HQTFNoContentView.h"
#import "TFApprovalSearchView.h"
#import "TFCustomAuthModel.h"
#import "TFAddCustomController.h"

@interface TFSelectCustomListController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,UITextFieldDelegate,TFApprovalSearchViewDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** lists */
@property (nonatomic, strong) NSMutableArray *lists;

/** alls */
@property (nonatomic, strong) NSMutableArray *alls;

/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;

/** pageNo */
@property (nonatomic, strong) NSNumber *pageNo;
/** pageSize */
@property (nonatomic, strong) NSNumber *pageSize;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** searchView */
@property (nonatomic, strong) TFApprovalSearchView *searchView;


@property (nonatomic, strong) NSMutableArray *auths;
@property (nonatomic, strong) TFCustomAuthModel *auth;

@end

@implementation TFSelectCustomListController
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

-(NSMutableArray *)alls{
    if (!_alls) {
        _alls = [NSMutableArray array];
    }
    return _alls;
}
-(NSMutableArray *)lists{
    if (!_lists) {
        _lists = [NSMutableArray array];
    }
    return _lists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    
    self.pageNo = @1;
    self.pageSize = @30;
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    
    self.navigationItem.title = self.module.chinese_name;
    UIBarButtonItem *item1 = [self itemWithTarget:self action:@selector(selectSure) text:@"确定" textColor:GrayTextColor];
    self.navigationItem.rightBarButtonItems = @[item1];
    
    [self.customBL requestCustomModuleAuthWithBean:self.module.english_name];// 权限
//    [self.customBL requsetCustomListWithBean:self.module.english_name queryWhere:nil menuId:nil pageNo:self.pageNo pageSize:self.pageSize seasPoolId:nil fuzzyMatching:nil dataAuth:@2 menuType:@"0" menuCondition:nil];// 列表数据
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
-(void)approvalSearchViewDidClickedStatusBtn{
    
    
}

-(void)approvalSearchViewTextChange:(UITextField *)textField{
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if (textField.text.length == 0) {
        [self.lists removeAllObjects];
        [self.lists addObjectsFromArray:self.alls];
        [self.tableView reloadData];
        return YES;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (TFCustomListItemModel *model in self.lists) {
        TFCustomRowModel *row = model.row;
        BOOL have = NO;
        for (TFFieldNameModel *field in row.row1) {
            NSString *str = [HQHelper stringWithFieldNameModel:field];
            if ([str containsString:textField.text]) {
                [arr addObject:model];
                have = YES;
                break;
            }
        }
        if (have) continue;
        
        for (TFFieldNameModel *field in row.row2) {
            NSString *str = [HQHelper stringWithFieldNameModel:field];
            if ([str containsString:textField.text]) {
                [arr addObject:model];
                have = YES;
                break;
            }
        }
        if (have) continue;
        
        for (TFFieldNameModel *field in row.row3) {
            NSString *str = [HQHelper stringWithFieldNameModel:field];
            if ([str containsString:textField.text]) {
                [arr addObject:model];
                have = YES;
                break;
            }
        }
        
    }
    self.lists = arr;
    [self.tableView reloadData];
    
    return YES;
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customModuleAuth) {
        
        [self.auths removeAllObjects];
        [self.auths addObjectsFromArray:resp.body];
        
        if (self.auths.count) {
            self.auth = self.auths.firstObject;
            
            BOOL have = NO;
            for (TFCustomAuthModel *model in self.auths) {
                
                if ([model.auth_code isEqualToNumber:@1]) {
                    have = YES;
                    break;
                }
            }
            if (have) {
                UIBarButtonItem *item1 = [self itemWithTarget:self action:@selector(selectSure) text:@"确定" textColor:GrayTextColor];
                UIBarButtonItem *item2 = [self itemWithTarget:self action:@selector(add) text:@"新增" textColor:GrayTextColor];
                self.navigationItem.rightBarButtonItems = @[item1,item2];
            }else{
                
                UIBarButtonItem *item1 = [self itemWithTarget:self action:@selector(selectSure) text:@"确定" textColor:GrayTextColor];
                self.navigationItem.rightBarButtonItems = @[item1];
            }
        
        }else{
            
            UIBarButtonItem *item1 = [self itemWithTarget:self action:@selector(selectSure) text:@"确定" textColor:GrayTextColor];
            self.navigationItem.rightBarButtonItems = @[item1];
        }
        
        [self.customBL requsetCustomListWithBean:self.module.english_name queryWhere:nil menuId:nil pageNo:self.pageNo pageSize:self.pageSize seasPoolId:nil fuzzyMatching:nil dataAuth:self.auth.data_auth menuType:@"0" menuCondition:nil];// 列表数据
        
    }
    
    if (resp.cmdId == HQCMD_customDataList) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        TFCustomListModel *model = resp.body;
        
        TFCustomPageModel *listModel = model.pageInfo;
        
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
        
        [self.alls removeAllObjects];
        [self.alls addObjectsFromArray:self.lists];
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

-(void)add{
    
    TFAddCustomController *add = [[TFAddCustomController alloc] init];
    add.bean = self.module.english_name;
    add.moduleId = self.module.id;
    add.tableViewHeight = SCREEN_HEIGHT - NaviHeight;
    add.taskBlock = ^(NSMutableDictionary *dict) {
        
        TFCustomListItemModel *model = [[TFCustomListItemModel alloc] init];
        TFFieldNameModel *field = [[TFFieldNameModel alloc] init];
        model.id = field;
        field.value = [dict valueForKey:@"data"];
        
        if (self.parameterAction) {
            [self.navigationController popViewControllerAnimated:NO];
            self.parameterAction(@[model]);
        }
    };
    [self.navigationController pushViewController:add animated:YES];
}

- (void)selectSure{
    
    NSMutableArray *selects = [NSMutableArray array];
    
    NSString *str = @"";
    for (TFCustomListItemModel *model in self.lists) {
        if ([model.select isEqualToNumber:@1]) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[model.id value]]];
            [selects addObject:model];
        }
    }
    if (str.length) {
        str = [str substringToIndex:str.length-1];
    }
    if (selects.count <= 0) {
        [MBProgressHUD showError:@"请选择" toView:self.view];
        return;
    }
    
    if (self.parameterAction) {
        [self.navigationController popViewControllerAnimated:NO];
        self.parameterAction(selects);
    }
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
    
    tableView.tableHeaderView = self.searchView;
    
    tableView.mj_header = [TFRefresh headerGifRefreshWithBlock:^{
        
        [self.lists removeAllObjects];
        [self.lists addObjectsFromArray:self.alls];
        self.pageNo = @1;
        
        [self.customBL requsetCustomListWithBean:self.module.english_name queryWhere:nil menuId:nil pageNo:self.pageNo pageSize:self.pageSize seasPoolId:nil fuzzyMatching:nil dataAuth:@2 menuType:@"0" menuCondition:nil];// 列表数据
        
    }];
    
    
    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        [self.lists removeAllObjects];
        [self.lists addObjectsFromArray:self.alls];
        self.pageNo = @([self.pageNo integerValue]+1);
        [self.customBL requsetCustomListWithBean:self.module.english_name queryWhere:nil menuId:nil pageNo:self.pageNo pageSize:self.pageSize seasPoolId:nil fuzzyMatching:nil dataAuth:@2 menuType:@"0" menuCondition:nil];// 列表数据
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
    TFCustomListItemModel *model = self.lists[indexPath.row];
    
    TFCustomListCell *cell = [TFCustomListCell customListCellWithTableView:tableView];
    [cell refreshCustomListCellWithModel:model];
    cell.select = YES;
    
    if (indexPath.row == self.lists.count - 1) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
    if (self.isSingle) {
        
        for (TFCustomListItemModel *model in self.lists) {
            
            model.select = @0;
        }
        
        TFCustomListItemModel *model = self.lists[indexPath.row];
        
        model.select = @1;
        
    }else{
        TFCustomListItemModel *model = self.lists[indexPath.row];
        
        model.select = [model.select isEqualToNumber:@1] ? @0 : @1;
    }
    
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCustomListItemModel *model = self.lists[indexPath.row];
    return [TFCustomListCell refreshCustomListCellHeightWithModel:model];
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
