//
//  TFTaskListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskListController.h"
#import "TFTaskListCell.h"
#import "TFProjectTaskBL.h"
#import "HQTFNoContentView.h"
#import "TFRefresh.h"
#import "TFTaskListModel.h"
#import "TFProjectRowFrameModel.h"
#import "TFProjectTaskItemCell.h"
#import "TFProjectNoteCell.h"
#import "TFTProjectCustomCell.h"
#import "TFProjectApprovalCell.h"
#import "TFCreateNoteController.h"
#import "TFProjectTaskDetailController.h"
#import "TFApprovalDetailController.h"
#import "TFCachePlistManager.h"

@interface TFTaskListController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFProjectTaskItemCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** tasks */
@property (nonatomic, strong) NSMutableArray *tasks;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** pageNum */
@property (nonatomic, assign) NSInteger pageNum;
/** pageSize */
@property (nonatomic, assign) NSInteger pageSize;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** selectModel */
@property (nonatomic, strong) TFTaskListModel *selectModel;

/** rowModel */
@property (nonatomic, strong) TFProjectRowModel *rowModel;
/** rowFrameModel */
@property (nonatomic, strong) TFProjectRowFrameModel *rowFrameModel;

/** 记录是否为筛选 */
@property (nonatomic, assign) BOOL isFilter;


@end

@implementation TFTaskListController

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
    
    self.pageSize = 10;
    self.pageNum = 1;
    
    [self setupTableView];
    
    NSArray *arr = [TFCachePlistManager getTaskListDataWithType:self.type];
    if (!arr || arr.count == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [self handleDataWithDatas:arr];
    
    [self.projectTaskBL requestPersonnelTaskFilterWithQueryType:self.type queryWhere:nil sortField:nil dateFormat:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskReturn:) name:TaskSearchReturnNotification object:nil];
    
}

- (void)handleDataWithDatas:(NSArray *)datas{
    
    [self.tasks removeAllObjects];
    
    for (NSDictionary *dict in datas) {
        TFTaskListModel *model = [[TFTaskListModel alloc] init];
        model.title = [dict valueForKey:@"title"];
        model.projectId = [dict valueForKey:@"projectId"];
        [self.tasks addObject:model];
        
        NSMutableArray *tasks = [NSMutableArray array];
        NSMutableArray *frames = [NSMutableArray array];
        
        for (NSDictionary *taskDict in [dict valueForKey:@"tasks"]) {
            
            TFProjectRowModel *task = [HQHelper projectRowWithTaskDict:taskDict];
            task.projectId = @([model.projectId longLongValue]);
            [tasks addObject:task];
            
            TFProjectRowFrameModel *frame = [[TFProjectRowFrameModel alloc] initBorder];
            frame.projectRow = task;
            [frames addObject:frame];
        }
        model.tasks = tasks;
        model.frames = frames;
    }
    
    [self.tableView reloadData];
}

- (void)taskReturn:(NSNotification *)note{
    
    NSDictionary *dict = note.object;
    
    NSNumber *type = [dict valueForKey:@"type"];
    if (self.type == [type integerValue]) {
        
        NSDictionary *dd = [dict valueForKey:@"condition"];
        if (dd) {
            self.isFilter = YES;
        }else{
            self.isFilter = NO;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requestPersonnelTaskFilterWithQueryType:self.type queryWhere:[dd valueForKey:@"queryWhere"] sortField:[dd valueForKey:@"sortField"] dateFormat:[dd valueForKey:@"dateFormat"]];
    }
    
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
            
            NSMutableArray *tasks = [NSMutableArray array];
            NSMutableArray *frames = [NSMutableArray array];
            
            for (NSDictionary *taskDict in [dict valueForKey:@"tasks"]) {
                
                TFProjectRowModel *task = [HQHelper projectRowWithTaskDict:taskDict];
                task.projectId = @([model.projectId longLongValue]);
                [tasks addObject:task];
                
                TFProjectRowFrameModel *frame = [[TFProjectRowFrameModel alloc] initBorder];
                frame.projectRow = task;
                [frames addObject:frame];
            }
            model.tasks = tasks;
            model.frames = frames;
        }
        
        
        
        if (self.tasks.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_taskInProject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableArray *tasks = [NSMutableArray array];
        NSMutableArray *frames = [NSMutableArray array];
        
        for (NSDictionary *taskDict in resp.body) {
            TFProjectRowModel *task = [HQHelper projectRowWithTaskDict:taskDict];
            task.projectId = @([self.selectModel.projectId longLongValue]);
            [tasks addObject:task];
            
            TFProjectRowFrameModel *frame = [[TFProjectRowFrameModel alloc] initBorder];
            frame.projectRow = task;
            [frames addObject:frame];
        }
        
        self.selectModel.tasks = tasks;
        self.selectModel.frames = frames;
        self.selectModel.select = @0;
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_finishOrActiveTask || resp.cmdId == HQCMD_finishOrActivePersonnelTask) {// 任务激活
        
        if ([self.rowModel.finishType isEqualToNumber:@1]) {
            self.rowModel.complete_status = @0;
            self.rowModel.finishType = @0;
            self.rowModel.activeNum = @([self.rowModel.activeNum integerValue] + 1);
            self.rowFrameModel.projectRow = self.rowModel;
            
        }else{
            self.rowModel.complete_status = @1;
            self.rowModel.finishType = @1;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_getPersonnelTaskRole) {
        
        
        NSString *role = [TEXT([resp.body valueForKey:@"role"]) description];
        
        if ([role containsString:@"0"] || [role containsString:@"1"]) {
            
            if ([self.rowModel.finishType isEqualToNumber:@1]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定激活此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.delegate = self;
                alert.tag = 0x222;
                [alert show];
                
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定完成此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.delegate = self;
                alert.tag = 0x111;
                [alert show];
                
            }
        }else{
            [MBProgressHUD showError:@"无权限修改" toView:self.view];
        }
        
    }
    if (resp.cmdId == HQCMD_getProjectFinishAndActiveAuth) {
        
        NSDictionary *dict = resp.body;
        NSString *auth = [[dict valueForKey:@"finish_task_role"] description];
        NSString *active = [[dict valueForKey:@"project_complete_status"] description];
        
        if ([auth isEqualToString:@"1"]) {
            
            if ([self.rowModel.finishType isEqualToNumber:@1]) {
                
                if ([active isEqualToString:@"1"]) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"激活原因" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.delegate = self;
                    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                    alert.tag = 0x222;
                    [alert show];
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定激活此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.delegate = self;
                    alert.tag = 0x222;
                    [alert show];
                }
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定完成此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.delegate = self;
                alert.tag = 0x111;
                [alert show];
            }
        }else{
            [MBProgressHUD showError:@"无权限修改" toView:self.view];
        }
        
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
        self.isFilter = NO;
        [self.projectTaskBL requestPersonnelTaskFilterWithQueryType:self.type queryWhere:nil sortField:nil dateFormat:nil];
        
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tasks.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    TFTaskListModel *model = self.tasks[section];
    if ([model.select isEqualToNumber:@1]) {
        return 0;
    }else{
        return model.tasks.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    TFTaskListModel *model = self.tasks[indexPath.section];
    TFProjectTaskItemCell *cell = [TFProjectTaskItemCell projectTaskItemCellWithTableView:tableView];
    cell.frameModel = model.frames[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFTaskListModel *model = self.tasks[indexPath.section];
    TFProjectRowModel *row = model.tasks[indexPath.row];
    TFProjectRowFrameModel *frame = model.frames[indexPath.row];
    
    TFProjectTaskDetailController *detail = [[TFProjectTaskDetailController alloc] init];
    if ([row.from isEqualToNumber:@1]) {// 个人任务
        detail.taskType = 2;
        detail.dataId = row.id;
    }else{
        detail.projectId = row.projectId;
//        detail.dataId = row.taskInfoId;
        detail.dataId = row.bean_id;
    }
    detail.action = ^(NSDictionary *parameter) {
        
        row.complete_status = @([[parameter valueForKey:@"complete_status"] integerValue]);
        row.finishType = @([[parameter valueForKey:@"complete_status"] integerValue]);
        if ([[row.complete_status description] isEqualToString:@"0"]) {
            row.activeNum = @([row.activeNum integerValue] + 1);
        }
        frame.projectRow = row;
        
        [self.tableView reloadData];
    };
    detail.deleteAction = ^{
        
        [model.tasks removeObjectAtIndex:indexPath.row];
        [model.frames removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFTaskListModel *model = self.tasks[indexPath.section];
    TFProjectRowFrameModel *frame = model.frames[indexPath.row];
    return frame.cellHeight;
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
    [btn addTarget:self action:@selector(showClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"展开"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
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
    
    [self didClickedSectionWithModel:model];
}

- (void)showClicked:(UIButton *)button{
    
    NSInteger tag = button.tag;
    TFTaskListModel *model = self.tasks[tag];
    
    [self didClickedSectionWithModel:model];
}

- (void)didClickedSectionWithModel:(TFTaskListModel *)model{
    
    if (model.select == nil) {
        if (model.projectId) {
            
            self.selectModel = model;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.projectTaskBL requestTaskInProjectWithProjectId:@([model.projectId longLongValue]) queryType:@(self.type)];
            
        }else{
            model.select = [model.select isEqualToNumber:@1]?@0:@1;
            [self.tableView reloadData];
        }
    }else{
        
        model.select = [model.select isEqualToNumber:@1]?@0:@1;
        [self.tableView reloadData];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - TFProjectTaskItemCellDelegate
-(void)projectTaskItemCell:(TFProjectTaskItemCell *)cell didClickedFinishBtnWithModel:(TFProjectRowModel *)model{
    
    self.rowModel = model;
    self.rowFrameModel = cell.frameModel;
    
    if ([model.finishType isEqualToNumber:@1]) {
        
        if ([model.from isEqualToNumber:@1]) {// 个人任务
            
            [self.projectTaskBL requestGetPersonnelTaskRoleWithTaskId:model.id typeStatus:@0];
            
        }else{// 项目任务
            
//            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:model.projectId taskId:model.taskInfoId taskType:@1];
            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:model.projectId taskId:model.bean_id taskType:@1];
            
        }
        
    }else{
        
        if ([model.from isEqualToNumber:@1]) {// 个人任务
            [self.projectTaskBL requestGetPersonnelTaskRoleWithTaskId:model.id typeStatus:@0];
            
        }else{// 项目任务
//            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:model.projectId taskId:model.taskInfoId taskType:@1];
            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:model.projectId taskId:model.bean_id taskType:@1];
            
        }
    }
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 0x111) {// 完成任务

        if (buttonIndex == 1) {

            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if ([self.rowModel.from isEqualToNumber:@1]) {// 个人任务

//                [self.projectTaskBL requestPersonnelTaskFinishOrActiveWithTaskId:self.rowModel.id];
                [self.projectTaskBL requestPersonnelTaskFinishOrActiveWithTaskId:self.rowModel.bean_id];

            }else{// 任务

//                [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.rowModel.taskInfoId completeStatus:@1 remark:nil];
                [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.rowModel.bean_id completeStatus:@1 remark:nil];
            }
             
        }
    }

    if (alertView.tag == 0x222) {// 激活任务

        if (buttonIndex == 1) {

            if ([self.rowModel.from isEqualToNumber:@1]) {// 个人任务

//                [self.projectTaskBL requestPersonnelTaskFinishOrActiveWithTaskId:self.rowModel.id];
                [self.projectTaskBL requestPersonnelTaskFinishOrActiveWithTaskId:self.rowModel.bean_id];
            }else{

                if ([alertView textFieldAtIndex:0]) {
                    
                    if ([alertView textFieldAtIndex:0].text.length) {
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        
//                        [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.rowModel.taskInfoId completeStatus:@0 remark:[alertView textFieldAtIndex:0].text];
                        [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.rowModel.bean_id completeStatus:@0 remark:[alertView textFieldAtIndex:0].text];
                    }else{
                        
                        [MBProgressHUD showError:@"请填写激活原因" toView:self.view];
                    }
                }else{
                    
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    
//                    [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.rowModel.taskInfoId completeStatus:@0 remark:nil];
                    [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.rowModel.bean_id completeStatus:@0 remark:nil];
                }
            }
        }

    }


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
