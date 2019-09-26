//
//  TFEmailItemController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailItemController.h"
#import "TFMailBL.h"
#import "TFRefresh.h"
#import "TFEmailsListModel.h"
#import "HQTFSearchHeader.h"
#import "HQTFNoContentView.h"
#import "TFEmailsListCell.h"

@interface TFEmailItemController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,HQTFSearchHeaderDelegate,UITextFieldDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *emails;
//当前页
@property (nonatomic, assign) NSInteger pageNum;

//每页条数
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) TFMailBL *mailBL;
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;

@property (nonatomic, copy) NSString *word;
@property (nonatomic, strong) NSMutableArray *totalDatas;
@property (nonatomic, strong) HQTFNoContentView *noContentView;


@end

@implementation TFEmailItemController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
    }
    return _noContentView;
}
-(NSMutableArray *)emails{
    if (!_emails) {
        _emails = [NSMutableArray array];
    }
    return _emails;
}
- (NSMutableArray *)totalDatas {
    
    if (!_totalDatas) {
        
        _totalDatas = [NSMutableArray array];
    }
    return _totalDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum = 1;
    self.pageSize = 10;
    self.mailBL = [TFMailBL build];
    self.mailBL.delegate = self;
    [self setupTableView];
    [self.mailBL getMailOperationQueryList:@(self.pageNum) pageSize:@(self.pageSize) accountId:nil boxId:@(self.type + 1) keyWord:nil];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if ([self.tableView.mj_footer isRefreshing]) {
        
        [self.tableView.mj_footer endRefreshing];
        
    }else {
        
        [self.tableView.mj_header endRefreshing];
        
        [self.emails removeAllObjects];
    }
    TFEmailsListModel *model = resp.body;
    
    [self.emails addObjectsFromArray:model.dataList];
    
    if ([model.pageInfo.totalRows integerValue] == self.emails.count) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }else {
        
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    if (self.emails.count == 0) {
        
        self.tableView.backgroundView = self.noContentView;
        
    }else{
        self.tableView.backgroundView = [UIView new];
    }

    [self.totalDatas removeAllObjects];
    [self.totalDatas addObjectsFromArray:self.emails];
    
    for (TFEmailReceiveListModel *mm in self.selects) {
        for (TFEmailReceiveListModel *mmoo in self.emails) {
            if ([mm.id isEqualToNumber:mmoo.id]) {
                mmoo.select = @1;
                break;
            }
        }
    }
    
    [self.tableView reloadData];
    
    if (self.numParameter) {
        self.numParameter(model.pageInfo.totalRows);
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    headerSearch.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    headerSearch.textField.returnKeyType = UIReturnKeySearch;
    headerSearch.delegate = self;
    headerSearch.textField.delegate = self;
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    [view addSubview:headerSearch];
    view.layer.masksToBounds = YES;
    self.headerSearch = headerSearch;
    self.headerSearch.type = SearchHeaderTypeSearch;
    tableView.tableHeaderView = view;
    headerSearch.backgroundColor = WhiteColor;
    headerSearch.textField.backgroundColor = BackGroudColor;
    headerSearch.image.backgroundColor = BackGroudColor;
    
    
    MJRefreshGifHeader *header = [TFRefresh headerGifRefreshWithBlock:^{
        
        self.pageNum = 1;
        
        [self.mailBL getMailOperationQueryList:@(self.pageNum) pageSize:@(self.pageSize) accountId:nil boxId:@(self.type + 1) keyWord:nil];
    }];
    tableView.mj_header = header;
    
    
    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        self.pageNum ++;
        
        [self.mailBL getMailOperationQueryList:@(self.pageNum) pageSize:@(self.pageSize) accountId:nil boxId:@(self.type + 1) keyWord:nil];
        
    }];
    tableView.mj_footer = footer;
}

#pragma mark - HQTFSearchHeaderDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.mailBL getMailOperationQueryList:@(self.pageNum) pageSize:@(self.pageSize) accountId:nil boxId:@(self.type + 1) keyWord:textField.text];
    self.word = textField.text;
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.text = self.word;
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = self.word;
}


#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.emails.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TFEmailReceiveListModel *model = self.emails[indexPath.section];
    
    TFEmailsListCell *cell = [TFEmailsListCell EmailsListCellWithTableView:tableView];
    
    [cell refreshEmailListCellWithModel:model];
    cell.select = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TFEmailReceiveListModel *model = self.emails[indexPath.section];
    model.select = [model.select isEqualToNumber:@1] ? @0 : @1;
    [tableView reloadData];
    
    if ([model.select isEqualToNumber:@1]) {
        [self.selects addObject:model];
    }else{
        for (TFEmailReceiveListModel *mm in self.selects) {
            if ([mm.id isEqualToNumber:model.id]) {
                [self.selects removeObject:mm];
                break;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 86;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
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
