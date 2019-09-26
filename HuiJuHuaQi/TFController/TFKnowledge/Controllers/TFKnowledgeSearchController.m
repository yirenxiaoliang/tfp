//
//  TFKnowledgeSearchController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFKnowledgeSearchController.h"
#import "HQTFSearchHeader.h"
#import "TFKnowledgeSearchView.h"
#import "HQTFNoContentView.h"
#import "TFKnowledgeBL.h"
#import "TFKnowledgeListModel.h"
#import "TFRefresh.h"
#import "TFKnowledgeListCell.h"
#import "TFKnowledgeDetailController.h"

@interface TFKnowledgeSearchController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,UITextFieldDelegate,TFKnowledgeSearchViewDelegate,HQBLDelegate>

@property (nonatomic, strong) HQTFSearchHeader *headerSearch;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFKnowledgeSearchView *searchView;

@property (nonatomic, assign) BOOL search;

@property (nonatomic, strong) HQTFNoContentView *noContentView;

@property (nonatomic, copy) NSString *keyword;

@property (nonatomic, strong) TFKnowledgeBL *knowledgeBL;


@property (nonatomic, strong) NSMutableArray *datas;
/** 页数 */
@property (nonatomic, assign) NSInteger pageNum;
/** 每页数量 */
@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation TFKnowledgeSearchController

-(NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无搜索结果"];
    }
    return _noContentView;
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
    self.pageNum = 1;
    self.pageSize = 10;
    self.knowledgeBL = [TFKnowledgeBL build];
    self.knowledgeBL.delegate = self;
    [self setupSearch];
    [self setupTableView];
//    [self setupSearchView];
}
-(void)setupSearchView{
    
    TFKnowledgeSearchView *view = [[TFKnowledgeSearchView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,0}];
    self.searchView = view;
    view.delegate = self;
    
    [self.searchView refreshKnowledgeSearchViewWithCategorys:@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]];
}

#pragma mark - TFKnowledgeSearchViewDelegate
-(void)knowledgeSearchViewWithHeight:(CGFloat)height{
    
    self.tableView.tableHeaderView = self.searchView;
}


- (void)setupSearch{
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    self.headerSearch = headerSearch;
    headerSearch.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    headerSearch.type = SearchHeaderTypeMove;
    headerSearch.textField.returnKeyType = UIReturnKeySearch;
    headerSearch.delegate = self;
    headerSearch.textField.delegate = self;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    textField.text = self.keyword;
}

- (void)searchHeaderTextChange:(UITextField *)textField{
    
    if (textField.text.length <= 0) {
        
        self.search = NO;
        self.tableView.tableHeaderView = self.searchView;
        self.tableView.backgroundView = [UIView new];
        
        [self.tableView reloadData];
    }
    self.keyword = textField.text;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length == 0) {
        
        return YES;
    }
    self.pageNum = 1;
    self.search = YES;
    self.tableView.tableHeaderView = nil;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 此处搜索
    [self.knowledgeBL requestGetKnowledgeListWithCategoryId:nil labelId:nil range:@0 keyWord:self.keyword pageNum:self.pageNum pageSize:self.pageSize];
    
    return YES;
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (resp.cmdId == HQCMD_getKnowledgeList) {
       
        TFKnowledgeListModel *model = resp.body;
        
        TFPageInfoModel *listModel = model.pageInfo;
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
        }else {
            
            [self.tableView.mj_header endRefreshing];
            [self.datas removeAllObjects];
        }
        
        [self.datas addObjectsFromArray:model.dataList];
        
        
        if ([listModel.totalRows integerValue] <= self.datas.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.datas.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}


-(void)searchHeaderCancelClicked{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        self.pageNum ++;
        [self.knowledgeBL requestGetKnowledgeListWithCategoryId:nil labelId:nil range:@0 keyWord:self.keyword pageNum:self.pageNum pageSize:self.pageSize];
    }];
    tableView.mj_footer = footer;
}

#pragma mark - tableView 数据源及代理方法
#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TFKnowledgeListCell *cell = [TFKnowledgeListCell knowledgeListCellWithTableView:tableView];
    [cell refreshKnowledgeListCellWithModel:self.datas[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TFKnowledgeItemModel *model = self.datas[indexPath.section];
    
    TFKnowledgeDetailController *detail = [[TFKnowledgeDetailController alloc] init];
    detail.dataId = model.id;
    detail.deleteAction = ^{
        [self.datas removeObjectAtIndex:indexPath.section];
        [self.tableView reloadData];
    };
    detail.refreshAction = ^(TFKnowledgeItemModel *parameter) {
        [self.datas replaceObjectAtIndex:indexPath.section withObject:parameter];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 154;
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
    if (section == 0) {
        return 0;
    }
    return 10;
    
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
