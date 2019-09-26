//
//  TFProShareSearchController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProShareSearchController.h"
#import "HQTFSearchHeader.h"
#import "HQTFNoContentView.h"
#import "HQTFLabelCell.h"

#import "TFProjectTaskBL.h"
#import "TFProjectShareListCell.h"
#import "TFProjectShareMainModel.h"
#import "TFProjectAddShareController.h"

@interface TFProShareSearchController ()<HQTFSearchHeaderDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HQBLDelegate>


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


/** UIView *footerView */
@property (nonatomic, strong) UIView *footerView;


/** keyName */
@property (nonatomic, copy) NSString *keyName;

/** pageNo */
@property (nonatomic, strong) NSNumber *pageNo;
/** pageSize */
@property (nonatomic, strong) NSNumber *pageSize;

@property (nonatomic, strong) NSMutableArray *allRecords;

@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;
@property (nonatomic, strong) TFProjectShareMainModel *mainModel;

@end

@implementation TFProShareSearchController


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
    [self setupTableView];
    
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    
    
    _allRecords = [NSMutableArray array];
    
    self.keyName = [NSString stringWithFormat:@"%@",self.searchMatch];
    
    [self.headerSearch.textField becomeFirstResponder];
    
    if (self.keyWord && ![self.keyWord isEqualToString:@""]) {
        self.headerSearch.textField.text = self.keyWord;
    }
    
    
    [self setupSearchPlacehoder];
}

/** 设置搜索框提示文字 */
- (void)setupSearchPlacehoder{
    
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.mainModel.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TFProjectShareListCell *cell = [TFProjectShareListCell projectShareListCellWithTableView:tableView];
    
    [cell refreshProjectShareListCellWithData:self.mainModel.dataList[indexPath.row]];
    
    
    cell.bottomLine.hidden = NO;
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFProjectShareInfoModel *model = self.mainModel.dataList[indexPath.row];
    
    TFProjectAddShareController *detail = [[TFProjectAddShareController alloc] init];
    
    detail.type = 1;
    detail.shareId = model.id;
    
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
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
        
        self.tableView.tableFooterView = self.footerView;
        self.tableView.backgroundView = [UIView new];
        
        [self.tableView reloadData];
    }
    self.keyWord = textField.text;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length == 0) {
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
    
    [self.projectTaskBL requestProjectShareControllerQueryListWithData:@(1) pageSize:@(20) keyword:self.keyWord type:@0 projectId:self.projectId];
    
    
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

-(void)searchHeaderCancelClicked{
    
    [self.view endEditing:YES];
    [self.headerSearch removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_projectShareControllerQueryList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.mainModel = resp.body;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.tableView reloadData];
        
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
