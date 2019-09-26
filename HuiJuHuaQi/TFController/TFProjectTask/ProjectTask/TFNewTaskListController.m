//
//  TFNewTaskListController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/28.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNewTaskListController.h"
#import "TFCachePlistManager.h"
#import "HQTFNoContentView.h"
#import "TFRefresh.h"
#import "TFTaskListModel.h"
#import "TFProjectTaskBL.h"
#import "TFNewTaskItemListController.h"

@interface TFNewTaskListController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** tasks */
@property (nonatomic, strong) NSMutableArray *tasks;
/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFNewTaskListController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}

-(NSMutableArray *)tasks{
    if (!_tasks) {
        _tasks = [NSMutableArray array];
    }
    return _tasks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [self setupTableView];
    NSArray *arr = [TFCachePlistManager getTaskListDataWithType:self.type];
    if (!arr || arr.count == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [self handleDataWithDatas:arr];
    
    [self.projectTaskBL requestPersonnelTaskFilterWithQueryType:self.type queryWhere:nil sortField:nil dateFormat:nil];
}

- (void)handleDataWithDatas:(NSArray *)datas{
    
    [self.tasks removeAllObjects];
    
    for (NSDictionary *dict in datas) {
        TFTaskListModel *model = [[TFTaskListModel alloc] init];
        model.title = [dict valueForKey:@"title"];
        model.projectId = [dict valueForKey:@"projectId"];
        [self.tasks addObject:model];
        
//        NSMutableArray *tasks = [NSMutableArray array];
//        NSMutableArray *frames = [NSMutableArray array];
//
//        for (NSDictionary *taskDict in [dict valueForKey:@"tasks"]) {
//
//            TFProjectRowModel *task = [HQHelper projectRowWithTaskDict:taskDict];
//            task.projectId = @([model.projectId longLongValue]);
//            [tasks addObject:task];
//
//            TFProjectRowFrameModel *frame = [[TFProjectRowFrameModel alloc] initBorder];
//            frame.projectRow = task;
//            [frames addObject:frame];
//        }
//        model.tasks = tasks;
//        model.frames = frames;
    }
    
    [self.tableView reloadData];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_personnelTaskFilter) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //        TFProjectListModel *model = resp.body;
        //
        //        TFCustomPageModel *listModel = model.pageInfo;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }else {
            [self.tableView.mj_header endRefreshing];
            [self.tasks removeAllObjects];
        }
        
        //        [self.tasks addObjectsFromArray:model.dataList];
        //        if ([listModel.totalRows integerValue] <= self.tasks.count) {
        //            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        //        }else {
        //            [self.tableView.mj_footer resetNoMoreData];
        //        }
        
        NSArray *datas = resp.body;
        
            
        NSMutableArray *ccdatas = [NSMutableArray array];
        for (NSDictionary *dd in datas) {
            NSString *str = [HQHelper dictionaryToJson:dd];
            if (str) {
                [ccdatas addObject:str];
            }
        }
        [TFCachePlistManager saveTaskListDataWithType:self.type datas:ccdatas];
        
        
        for (NSDictionary *dict in datas) {
            TFTaskListModel *model = [[TFTaskListModel alloc] init];
            model.title = [dict valueForKey:@"title"];
            model.projectId = [dict valueForKey:@"projectId"];
            [self.tasks addObject:model];
            
        }
        
        
        
        if (self.tasks.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        
        [self.tableView reloadData];
        
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
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
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.mj_header = [TFRefresh headerNormalRefreshWithBlock:^{
        
        [self.projectTaskBL requestPersonnelTaskFilterWithQueryType:self.type queryWhere:nil sortField:nil dateFormat:nil];
        
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tasks.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    cell.textLabel.text = @"";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = WhiteColor;
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-30,43.5}];
    TFTaskListModel *model = self.tasks[section];
    label.text = model.title;
    [view addSubview:label];
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){0,43.5,SCREEN_WIDTH,.5}];
    line.backgroundColor = CellSeparatorColor;
    [view addSubview:line];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_WIDTH-44, 0, 44, 44);
    btn.tag = section;
//    [btn addTarget:self action:@selector(showClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.userInteractionEnabled = NO;
    [view addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"下一级浅灰"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"下一级浅灰"] forState:UIControlStateNormal];
    btn.selected = [model.select isEqualToNumber:@1]?YES:NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
    [view addGestureRecognizer:tap];
    view.tag = section;
    return view;
}
- (void)tapClicked:(UITapGestureRecognizer *)greture{
    UIView *view = greture.view;
    NSInteger tag = view.tag;
    TFTaskListModel *model = self.tasks[tag];
    TFNewTaskItemListController *task = [[TFNewTaskItemListController alloc] init];
    task.type = self.type;
    task.naviTitle = model.title;
    if (model.projectId) {
        task.projectId = @([model.projectId longLongValue]);
    }
    [self.navigationController pushViewController:task animated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
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
