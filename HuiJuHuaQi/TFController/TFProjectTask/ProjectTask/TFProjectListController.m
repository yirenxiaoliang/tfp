
//
//  TFProjectListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectListController.h"
#import "TFProjectListCell.h"
#import "TFProjectDetailTabBarController.h"
#import "TFProjectTaskBL.h"
#import "TFRefresh.h"
#import "TFProjectListModel.h"
#import "TFCustomPageModel.h"
#import "HQTFNoContentView.h"
#import "TFCachePlistManager.h"
#import "TFProjectNewListCell.h"
#import "TFAgainProjectListCell.h"

@interface TFProjectListController ()<UITableViewDelegate,UITableViewDataSource,TFProjectListCellDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** projects */
@property (nonatomic, strong) NSMutableArray *projects;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** pageNum */
@property (nonatomic, assign) NSInteger pageNum;
/** pageSize */
@property (nonatomic, assign) NSInteger pageSize;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** createDataId */
@property (nonatomic, strong) NSNumber *createDataId;


@end

@implementation TFProjectListController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}

-(NSMutableArray *)projects{
    if (!_projects) {
        _projects = [NSMutableArray array];
    }
    return _projects;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    self.pageSize = 10;
    self.pageNum = 1;
    
    [self setupTableView];
    
    
    NSArray *arr = [TFCachePlistManager getProjectListDataWithType:self.type];
    if (!arr || arr.count == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [self handleDataWithDatas:arr];
    
    [self.projectTaskBL requestGetProjectListWithType:self.type PageNo:@(self.pageNum) pageSize:@(self.pageSize) keyword:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchReturn:) name:ProjectSearchReturnNotification object:nil];
}

- (void)handleDataWithDatas:(NSArray *)datas{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dict in datas) {
        TFProjectModel *model = [[TFProjectModel alloc] initWithDictionary:dict error:nil];
        if (model) {
            [arr addObject:model];
        }
    }
    [self.projects removeAllObjects];
    [self.projects addObjectsFromArray:arr];
    [self.tableView reloadData];
}

- (void)searchReturn:(NSNotification *)note{
    NSDictionary *dict = note.object;
    NSNumber *type = [dict valueForKey:@"type"];
    NSString *keyword = [dict valueForKey:@"text"];
    self.createDataId = [dict valueForKey:@"dataId"];
    if (self.type == [type integerValue]) {
        self.pageNum = 1;
        [self.projectTaskBL requestGetProjectListWithType:self.type PageNo:@(self.pageNum) pageSize:@(self.pageSize) keyword:keyword];
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjectList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        TFProjectListModel *model = resp.body;
        
        TFCustomPageModel *listModel = model.pageInfo;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.projects removeAllObjects];
        }
        
        [self.projects addObjectsFromArray:model.dataList];
        
            
        if (self.projects.count < 100) {
            
            NSMutableArray *datas = [NSMutableArray array];
            for (TFProjectModel *model in self.projects) {
                NSString *str = [model toJSONString];
                if (str) {
                    [datas addObject:str];
                }
            }
            [TFCachePlistManager saveProjectListDataWithType:self.type datas:datas];
            
        }
        
        if ([listModel.totalRows integerValue] <= self.projects.count) {
            
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
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
    tableView.backgroundColor = WhiteColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.mj_header = [TFRefresh headerNormalRefreshWithBlock:^{
        
        self.pageNum = 1;
        [self.projectTaskBL requestGetProjectListWithType:self.type PageNo:@(self.pageNum) pageSize:@(self.pageSize) keyword:nil];
        
    }];
    tableView.mj_footer = [TFRefresh footerAutoRefreshWithBlock:^{
        
        self.pageNum ++;
        [self.projectTaskBL requestGetProjectListWithType:self.type PageNo:@(self.pageNum) pageSize:@(self.pageSize) keyword:nil];
        
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.projects.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    TFProjectListCell *cell = [TFProjectListCell projectListCellWithTableView:tableView];
//    cell.delegate = self;
//    TFProjectNewListCell *cell = [TFProjectNewListCell projectNewListCellWithTableView:tableView];
//    [cell refreshProjectListCellWithProjectModel:self.projects[indexPath.row]];
    TFAgainProjectListCell *cell = [TFAgainProjectListCell againProjectListCellWithTableView:tableView];
    [cell refreshAgainProjectListCellWithProjectModel:self.projects[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFProjectDetailTabBarController *detail = [[TFProjectDetailTabBarController alloc] init];
    TFProjectModel *model = self.projects[indexPath.row];
    detail.projectId = model.id;
    detail.projectModel = model;
    detail.refresh = ^{
        [self.tableView reloadData];
    };
    detail.deleteAction = ^{
        [self.projects removeObject:model];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
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

#pragma mark - TFProjectListCellDelegate
- (void)projectListCellDidClickedStarBtn:(UIButton *)starBtn{
    
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ProjectSearchScrollNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
