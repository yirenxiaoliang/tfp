//
//  TFProjectSearchController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/7/5.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectSearchController.h"
#import "HQTFSearchHeader.h"
#import "HQTFNoContentView.h"
#import "HQTFProjectProcessCell.h"
#import "HQTFProjectSeeBoardController.h"
#import "TFProjectBL.h"
#import "MJRefresh.h"
#import "TFProjectListModel.h"

@interface TFProjectSearchController ()<HQTFSearchHeaderDelegate,UITableViewDelegate,UITableViewDataSource,HQBLDelegate,UITextFieldDelegate>

/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** projects */
@property (nonatomic, strong) NSMutableArray *projects;
/** 请求 */
@property (nonatomic, strong) TFProjectBL *projectBL;

/** pageNum */
@property (nonatomic, assign) NSInteger pageNum;
/** pageSize */
@property (nonatomic, assign) NSInteger pageSize;

/** projectName */
@property (nonatomic, copy) NSString *projectName;

@end

@implementation TFProjectSearchController

-(NSMutableArray *)projects{
    if (!_projects) {
        _projects = [NSMutableArray array];
    }
    return _projects;
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
    [self.headerSearch.textField becomeFirstResponder];
    self.pageNum = 1;
    self.pageSize = 10;
    // 请求
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
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
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        
        [self.projectBL requestSearchProjectPageNum:1 pageSize:10 projectName:self.projectName];
        
    }];
    
    self.tableView.backgroundView = self.noContentView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HQTFProjectProcessCell *cell = [HQTFProjectProcessCell projectProcessCellWithTableView:tableView];
    cell.groundImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.section%5 + 1]];
    [cell refreshProjectProcessCellWithModel:self.projects[indexPath.section] type:3];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    HQTFProjectSeeBoardController *seeBoard = [[HQTFProjectSeeBoardController alloc] init];
    seeBoard.projectItem = self.projects[indexPath.section];
    [self.navigationController pushViewController:seeBoard animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
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


- (void)setupNavi{
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    self.headerSearch = headerSearch;
    headerSearch.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    headerSearch.type = SearchHeaderTypeMove;
    headerSearch.delegate = self;
    headerSearch.textField.delegate = self;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    textField.text = self.projectName;
}

- (void)searchHeaderTextChange:(UITextField *)textField{
    
    UITextRange *textRange = [textField markedTextRange];// 高亮文字范围
    
    NSString *highStr = [textField textInRange:textRange];
    if (highStr.length <= 0) {// 没有高亮时进行搜索
        if (textField.text.length > 0) {
            
            self.projectName = textField.text;
            [self.projectBL requestSearchProjectPageNum:1 pageSize:10 projectName:self.projectName];
        }else{
            self.projectName = @"";
            [self.projects removeAllObjects];
            self.tableView.backgroundView = self.noContentView;
            [self.tableView reloadData];
        }
    }
}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无项目"];
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
    if (resp.cmdId == HQCMD_getProjList) {
        
        TFProjectListModel *listModel = resp.body;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.projects removeAllObjects];
        }
        
        [self.projects addObjectsFromArray:listModel.list];
        
        if (listModel.totalRows == self.projects.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.projects.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    [self.tableView.mj_footer endRefreshing];
//    [self.tableView.mj_header endRefreshing];
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
