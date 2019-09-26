
//
//  TFSelectTaskListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectTaskListController.h"
#import "HQTFNoContentView.h"
#import "TFApprovalSearchView.h"
#import "TFRefresh.h"
#import "TFProjectTaskBL.h"
#import "TFSelectTaskCell.h"
#import "TFQuoteTaskListModel.h"
#import "TFProjectModel.h"
#import "TFProjectListView.h"

@interface TFSelectTaskListController ()<UITableViewDelegate,UITableViewDataSource,TFApprovalSearchViewDelegate,UITextFieldDelegate,HQBLDelegate,TFProjectListViewDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** lists */
@property (nonatomic, strong) NSMutableArray *lists;

/** searchView */
@property (nonatomic, strong) TFApprovalSearchView *searchView;

/** pageNo */
@property (nonatomic, strong) NSNumber *pageNo;
/** pageSize */
@property (nonatomic, strong) NSNumber *pageSize;

/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** keyword */
@property (nonatomic, copy) NSString *keyword;

/** allProjects */
@property (nonatomic, strong) NSMutableArray *allProjects;

/** projectName */
@property (nonatomic, copy) NSString *projectName;

/** TFProjectListView */
@property (nonatomic, strong) TFProjectListView *projectListView;


@end

@implementation TFSelectTaskListController

-(TFProjectListView *)projectListView{
    if (!_projectListView) {
        _projectListView = [TFProjectListView projectListView];
        _projectListView.delegate = self;
    }
    return _projectListView;
}

#pragma mark - TFProjectListViewDelegate
-(void)filterViewDidSureBtnWithDict:(NSDictionary *)dict{
    
    [self.projectListView hideAnimation];
    NSNumber *projectId = [dict valueForKey:@"projectId"];
    
    self.projectId = projectId;
    self.keyword = @"";
    self.searchView.textFiled.text = @"";
    
    [self loadData];
}

- (void)loadData{
    
    if ([self.projectId isEqualToNumber:@0]) {// 个人任务
        
        self.pageNo = @1;
        self.projectName = @"个人任务";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [self.projectTaskBL requestGetPersonnelTaskListWithKeyword:self.keyword pageNum:self.pageNo pageSize:self.pageSize];
        
        [self.projectTaskBL requestGetQuoteTaskListWithKeyword:self.keyword pageNum:self.pageNo pageSize:self.pageSize projectId:nil from:@1];
        
    }else{// 项目
        
        for (TFProjectModel *model in self.allProjects) {
            if ([self.projectId isEqualToNumber:model.id]) {
                self.projectName = model.name;
                break;
            }
        }
        [self.tableView reloadData];
        
        // 请求
        self.pageNo = @1;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requestGetQuoteTaskListWithKeyword:self.keyword pageNum:self.pageNo pageSize:self.pageSize projectId:self.projectId from:@0];
        
    }
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
    self.pageNo = @1;
    self.pageSize = @30;
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    self.keyword = @"";
    
//    [self.projectTaskBL requsetAllProjectWithKeyword:@"" type:0];// 所有项目
    
    
    [self.view addSubview:self.searchView];
    [self setupTableView];
    
    self.navigationItem.title = @"任务";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定"];
    if (!self.projectId || [self.projectId isEqualToNumber:@0]) {
//        [self.projectTaskBL requestGetPersonnelTaskListWithKeyword:self.keyword pageNum:self.pageNo pageSize:self.pageSize];
        
        [self.projectTaskBL requestGetQuoteTaskListWithKeyword:self.keyword pageNum:self.pageNo pageSize:self.pageSize projectId:nil from:@1];
    }else{
        [self.projectTaskBL requestGetQuoteTaskListWithKeyword:self.keyword pageNum:self.pageNo pageSize:self.pageSize projectId:self.projectId from:@0];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getAllProject) {
        
        self.allProjects = resp.body;
        
        for (TFProjectModel *model in self.allProjects) {
            if ([self.projectId isEqualToNumber:model.id]) {
                self.projectName = model.name;
                model.selectState = @1;
                break;
            }
        }
        if (!self.projectId || [self.projectId isEqualToNumber:@0]) {
            self.projectName = @"个人任务";
            if (self.allProjects.count) {
                TFProjectModel *model = self.allProjects.firstObject;
                model.selectState = @1;
            }
        }
        self.projectListView.conditions = self.allProjects;
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_quoteTaskList) {
        
        if ([self.pageNo isEqualToNumber:@1]) {
            [self.lists removeAllObjects];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        TFQuoteTaskListModel *listModel = resp.body;
        TFPageInfoModel *pageInfo = listModel.pageInfo;
        
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.lists removeAllObjects];
        }

        [self.lists addObjectsFromArray:listModel.dataList];


        if ([pageInfo.totalRows integerValue] <= self.lists.count) {

            [self.tableView.mj_footer endRefreshingWithNoMoreData];

        }else {

            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.lists.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = nil;
        }
        
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_getPersonnelTaskList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *arr = resp.body;
        
        [self.lists removeAllObjects];
        for (NSDictionary *di in arr) {
            TFQuoteTaskItemModel *model = [[TFQuoteTaskItemModel alloc] init];
            model.task_name = [di valueForKey:@"name"];
            model.id = [di valueForKey:@"id"];
            model.end_time = [di valueForKey:@"datetime_deadline"];
            if ([[di valueForKey:@"personnel_principal"] isKindOfClass:[NSArray class]]) {
                NSArray *pes = [di valueForKey:@"personnel_principal"];
                if (pes.count) {
                    NSDictionary *pedd = pes[0];
                    model.employee_name = [pedd valueForKey:@"name"];
                }
            }
            
            [self.lists addObject:model];
        }
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}



- (void)sure{
    
    NSMutableArray *selects = [NSMutableArray array];
    
    NSString *str = @"";
    for (TFQuoteTaskItemModel *model in self.lists) {
        model.project_id = self.projectId;
        if ([model.select isEqualToNumber:@1]) {
            [selects addObject:model];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",model.id]];
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
        [_searchView.statusBtn setImage:IMG(@"proFilter") forState:UIControlStateNormal];
        [_searchView.statusBtn setImage:IMG(@"proFilter") forState:UIControlStateHighlighted];

    }
    return _searchView;
}
#pragma mark - TFApprovalSearchViewDelegate
-(void)approvalSearchViewDidClickedStatusBtn{
    
    [self.projectListView showAnimation];
}

-(void)approvalSearchViewTextChange:(UITextField *)textField{
    
    
    UITextRange *range = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:range.start offset:0];
    
    if (!position) {
        
        self.keyword = textField.text;
        
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    [self loadData];
    
    return YES;
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-46) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    MJRefreshNormalHeader *header = [TFRefresh headerNormalRefreshWithBlock:^{
        
        self.pageNo = @1;
        if (!self.projectId || [self.projectId isEqualToNumber:@0]) {
            //        [self.projectTaskBL requestGetPersonnelTaskListWithKeyword:self.keyword pageNum:self.pageNo pageSize:self.pageSize];
            
            [self.projectTaskBL requestGetQuoteTaskListWithKeyword:self.keyword pageNum:self.pageNo pageSize:self.pageSize projectId:nil from:@1];
        }else{
            [self.projectTaskBL requestGetQuoteTaskListWithKeyword:self.keyword pageNum:self.pageNo pageSize:self.pageSize projectId:self.projectId from:@0];
        }
    }];
    tableView.mj_header = header;
    
    
    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        self.pageNo = @([self.pageNo integerValue]+1);
        if (!self.projectId || [self.projectId isEqualToNumber:@0]) {
            //        [self.projectTaskBL requestGetPersonnelTaskListWithKeyword:self.keyword pageNum:self.pageNo pageSize:self.pageSize];
            
            [self.projectTaskBL requestGetQuoteTaskListWithKeyword:self.keyword pageNum:self.pageNo pageSize:self.pageSize projectId:nil from:@1];
        }else{
            [self.projectTaskBL requestGetQuoteTaskListWithKeyword:self.keyword pageNum:self.pageNo pageSize:self.pageSize projectId:self.projectId from:@0];
        }

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
   
    TFSelectTaskCell *cell = [TFSelectTaskCell selectTaskCellWithTableView:tableView];
    
    [cell refreshSelectTaskCellWithModel:self.lists[indexPath.row]];
    
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }else{
        cell.topLine.hidden = NO;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFQuoteTaskItemModel *model = self.lists[indexPath.row];
    model.select = [model.select isEqualToNumber:@1]?@0:@1;
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
//    return 40;
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
//    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,40}];
//    view.backgroundColor = BackGroudColor;
//    UIImageView *image = [[UIImageView alloc] initWithFrame:(CGRect){12,0,40,40}];
//    [view addSubview:image];
//    image.contentMode = UIViewContentModeCenter;
//    image.image = IMG(@"defPro");
//    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){CGRectGetMaxX(image.frame),0,SCREEN_WIDTH-CGRectGetMaxX(image.frame),40}];
//    [view addSubview:label];
//    label.text = self.projectName;
//    return view;
    
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
