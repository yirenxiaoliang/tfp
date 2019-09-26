//
//  HQTFRecordController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFRecordController.h"
#import "HQTFSearchHeader.h"
#import "HQTFRecordCell.h"
#import "IQKeyboardManager.h"
#import "TFProjectBL.h"
#import "MJRefresh.h"
#import "TFProjectLogListModel.h"

@interface HQTFRecordController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;
/** header */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** headerView */
@property (nonatomic, strong) UIView *headerView;


/** searchTableView */
@property (nonatomic, strong) UITableView *searchTableView;

/** records */
@property (nonatomic, strong) NSMutableArray *records;


/** searchRecords */
@property (nonatomic, strong) NSMutableArray *searchRecords;

/** projectBL */
@property (nonatomic, strong) TFProjectBL *projectBL;

/** pageNum */
@property (nonatomic, assign) NSInteger pageNum;
/** pageSize */
@property (nonatomic, assign) NSInteger pageSize;
/** orderBy */
@property (nonatomic, assign) NSInteger orderBy;


@end

@implementation HQTFRecordController

-(NSMutableArray *)records{
    
    if (!_records) {
        _records = [NSMutableArray array];
        
//        for (NSInteger i =0 ; i<5; i++) {
//            [_records addObject:@""];
//        }
    }
    return _records;
}
-(NSMutableArray *)searchRecords{
    
    if (!_searchRecords) {
        _searchRecords = [NSMutableArray array];
//        [_searchRecords addObject:@""];
    }
    return _searchRecords;
}

-(UITableView *)searchTableView{
    
    if (!_searchTableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -0.5, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.backgroundColor = HexColor(0x000000, 0.3);
        tableView.tag = 0x1111;
        _searchTableView = tableView;
    }
    return _searchTableView;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) text:@"取消"];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    [self.headerSearch removeFromSuperview];
    [self searchHeaderCancelClicked];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self setupTableView];
    //[self setupHeaderSearch];
    //[self textFieldChange:nil];
    [self setupNavigation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
    
    self.pageSize = 10;
    self.pageNum = 1;
    self.orderBy = 0;
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
    [self.projectBL requestProjectLogWithProjectId:self.project.id pageNo:@(self.pageNum) pageSize:@(self.pageSize) orderBy:@(self.orderBy)];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - navi
- (void)setupNavigation{
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) image:@"倒序" highlightImage:@"倒序"];
    
    self.navigationItem.title = @"活动记录";
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure{
    
    self.orderBy = self.orderBy == 0?1:0;
    self.pageNum = 1;
    
    [self.projectBL requestProjectLogWithProjectId:self.project.id pageNo:@(self.pageNum) pageSize:@(self.pageSize) orderBy:@(self.orderBy)];
    
}

#pragma mark - headerSearch
- (void)setupHeaderSearch{
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    self.header = header;
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    [headerView addSubview:header];
    headerView.backgroundColor = HexColor(0xe7e7e7, 1);
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    header.delegate = self;
    
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    self.headerSearch = headerSearch;
    headerSearch.type = SearchHeaderTypeMove;
    headerSearch.delegate = self;
    
}

-(void)searchHeaderClicked{
    
    self.headerSearch.type = SearchHeaderTypeMove;
    [self.headerSearch.textField becomeFirstResponder];
    self.headerSearch.frame = CGRectMake(0, 24, SCREEN_WIDTH, 64);
    [self.navigationController.navigationBar addSubview:self.headerSearch];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.headerSearch.y = -20;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }completion:^(BOOL finished) {
        
        self.tableView.tableHeaderView = nil;
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        self.tableView.contentOffset = CGPointMake(0, -44);
    }];
    
}


-(void)searchHeaderCancelClicked{
    
    self.header.type = SearchHeaderTypeNormal;
    self.headerSearch.type = SearchHeaderTypeNormal;
    [self.headerSearch.textField resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.headerSearch.y = 24;
        self.tableView.contentInset = UIEdgeInsetsMake(88, 0, 0, 0);
        self.tableView.contentOffset = CGPointMake(0, -88);
    }completion:^(BOOL finished) {
        
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        [self.headerSearch removeFromSuperview];
    }];
    
}

/** 键盘消失 */
- (void)keyboardHide{
    
    
}

-(void)searchHeaderTextChange:(UITextField *)textField{
    
    [self textFieldChange:textField];
}

- (void)textFieldChange:(UITextField *)textField
{
    
    UITextRange *textRange = [textField markedTextRange];// 高亮文字范围
    
    NSString *highStr = [textField textInRange:textRange];
    
    if (highStr.length <= 0) {// 没有高亮时进行搜索
        
        //        for (HQCustomerModel *contact in self.allDatas) {
        //
        //
        //        }
        
        [self.searchTableView reloadData];
    }
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    [self.view endEditing:YES];
//}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -44, SCREEN_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    
    tableView.backgroundColor = BackGroudColor;
    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
//    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
//    view.layer.masksToBounds = YES;
//    [view addSubview:self.headerSearch];
//    self.tableView.tableHeaderView = view;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageNum = 1;
        
        [self.projectBL requestProjectLogWithProjectId:self.project.id pageNo:@(self.pageNum) pageSize:@(self.pageSize) orderBy:@(self.orderBy)];
    }];
    
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        
        [self.projectBL requestProjectLogWithProjectId:self.project.id pageNo:@(self.pageNum) pageSize:@(self.pageSize) orderBy:@(self.orderBy)];
        
    }];

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if (tableView.tag == 0x1111) {
//        return self.searchRecords.count;
//    }else{
    
        return  self.records.count;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFRecordCell *cell = [HQTFRecordCell recordCellWithTableView:tableView];
    [cell refreshRecordCellWithModel:self.records[indexPath.row]];
    if (indexPath.row == 0) {
        cell.topLine.hidden = NO;
    }else{
        cell.topLine.hidden = YES;
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [HQTFRecordCell refreshRecordCellHeightWithModel:self.records[indexPath.row]];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 0x1111) {
        return 0.5;
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag == 0x1111) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    NSString *tip = [NSString stringWithFormat:@" %@",self.project.projectName];
    UILabel *label = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-15,44} text:tip textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"    "];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"项目花"];
    attach.bounds = CGRectMake(0, -1, 13, 13);
    
    [str appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:tip]];
    
    [str addAttribute:NSFontAttributeName value:FONT(14) range:NSMakeRange(5, tip.length)];
    
    label.backgroundColor = WhiteColor;
    label.attributedText = str;
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_projectLog) {
        
        TFProjectLogListModel *modelList = resp.body;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.records removeAllObjects];
        }
        
        [self.records addObjectsFromArray:modelList.list];
        
        if (modelList.totalRows == self.records.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
            self.tableView.mj_footer = nil;
            
            if (self.records.count < 10) {
                self.tableView.tableFooterView = [UIView new];
            }else{
                self.tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];;
            }
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.records.count == 0) {
            
//            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
