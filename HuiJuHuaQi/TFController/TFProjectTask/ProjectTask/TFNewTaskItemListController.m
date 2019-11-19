//
//  TFNewTaskItemListController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/28.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNewTaskItemListController.h"
#import "TFProjectTaskBL.h"
#import "HQTFNoContentView.h"
#import "TFRefresh.h"
#import "TFProjectRowFrameModel.h"
#import "TFProjectTaskItemCell.h"
#import "TFProjectNoteCell.h"
#import "TFTProjectCustomCell.h"
#import "TFProjectApprovalCell.h"
#import "TFCreateNoteController.h"
#import "TFProjectTaskDetailController.h"
#import "TFApprovalDetailController.h"
#import "HQNotPassSubmitView.h"
#import "TFCustomBL.h"
#import "TFProjectFilterView.h"
#import "TFNewProjectTaskItemCell.h"
#import "TFSelectStatusController.h"

@interface TFNewTaskItemListController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFProjectTaskItemCellDelegate,TFProjectFilterViewDelegate,TFNewProjectTaskItemCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** tasks */
@property (nonatomic, strong) NSMutableArray *tasks;
/** tasks */
@property (nonatomic, strong) NSMutableArray *frames;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;
/** pageNum */
@property (nonatomic, assign) NSInteger pageNum;
/** pageSize */
@property (nonatomic, assign) NSInteger pageSize;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** rowModel */
@property (nonatomic, strong) TFProjectRowModel *rowModel;
/** rowFrameModel */
@property (nonatomic, strong) TFProjectRowFrameModel *rowFrameModel;
/** 自定义请求 */
@property (nonatomic, strong) TFCustomBL *customBL;
/** filterView */
@property (nonatomic, strong) TFProjectFilterView *filterView;


@property (nonatomic, strong) NSDictionary *queryWhere;
@property (nonatomic, strong) NSNumber *dateFormat;
@property (nonatomic, copy) NSString *sortField;

@end

@implementation TFNewTaskItemListController

#pragma mark - 初始化filterView
- (void)setupFilterView{
    
    TFProjectFilterView *filterVeiw = [[TFProjectFilterView alloc] initWithFrame:(CGRect){SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
    filterVeiw.tag = 0x1234554321;
    self.filterView = filterVeiw;
    if (!self.projectId) {
        filterVeiw.type = 1;
    }
    filterVeiw.delegate = self;
}
#pragma mark - TFProjectFilterViewDelegate
-(void)filterViewDidSureBtnWithDict:(NSDictionary *)dict{
    [self.filterView hideAnimation];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.queryWhere = [dict valueForKey:@"queryWhere"];
    self.dateFormat = [dict valueForKey:@"dateFormat"];
    self.sortField = [dict valueForKey:@"sortField"];
    if (self.projectId) {
        [self.projectTaskBL requestNewProjectTaskListWithProjectId:self.projectId PageNum:@(self.pageNum) pageSize:@(self.pageSize) queryWhere:self.queryWhere sortField:self.sortField dateFormat:self.dateFormat queryType:@(self.type) bean:[NSString stringWithFormat:@"project_custom_%lld",[self.projectId longLongValue]]];
    }else{
        [self.projectTaskBL requestNewPersonnelTaskListWithPageNum:@(self.pageNum) pageSize:@(self.pageSize) queryWhere:self.queryWhere sortField:self.sortField dateFormat:self.dateFormat queryType:@(self.type)];
    }
    
}


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
-(NSMutableArray *)frames{
    if (!_frames) {
        _frames = [NSMutableArray array];
    }
    return _frames;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    self.pageSize = 10;
    self.pageNum = 1;
    
    [self setupNavi];
    [self setupTableView];
    [self setupFilterView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.projectId) {
        [self.projectTaskBL requestNewProjectTaskListWithProjectId:self.projectId PageNum:@(self.pageNum) pageSize:@(self.pageSize) queryWhere:self.queryWhere sortField:self.sortField dateFormat:self.dateFormat queryType:@(self.type) bean:[NSString stringWithFormat:@"project_custom_%lld",[self.projectId longLongValue]]];
        [self.projectTaskBL requestGetProjectTaskFilterConditionWithProjectId:self.projectId];
    }else{
        [self.projectTaskBL requestNewPersonnelTaskListWithPageNum:@(self.pageNum) pageSize:@(self.pageSize) queryWhere:self.queryWhere sortField:self.sortField dateFormat:self.dateFormat queryType:@(self.type)];
        [self.projectTaskBL requsetGetPersonnelTaskFilterCondition];
    }
}

-(void)setupNavi{
    
    self.navigationItem.title = self.naviTitle;
    UIBarButtonItem *item = [self itemWithTarget:self action:@selector(addClicked) image:@"加号" highlightImage:@"加号"];
    
    UIBarButtonItem *item1 = [self itemWithTarget:self action:@selector(taskSearchClick) image:@"proFilter" highlightImage:@"proFilter"];
    
    if (self.projectId) {
        self.navigationItem.rightBarButtonItems = @[item1];
    }else{
        self.navigationItem.rightBarButtonItems = @[item1,item];
    }
    
}

-(void)addClicked{
    
    [HQNotPassSubmitView submitPlaceholderStr:@"请输入任务名称" title:nil maxCharNum:200 LeftTouched:^{
        
    } onRightTouched:^(NSDictionary *dict) {
        
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        if ([dict valueForKey:@"text"]) {
            [data setObject:[dict valueForKey:@"text"] forKey:@"name"];
            [data setObject:[dict valueForKey:@"text"] forKey:@"text_name"];
        }
        [data setObject:UM.userLoginInfo.employee.id forKey:@"personnel_principal"];

        NSMutableDictionary *total = [NSMutableDictionary dictionary];
        [total setObject:data forKey:@"data"];
        [total setObject:@"project_custom" forKey:@"bean"];
        
        // 新建任务
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestSavePersonnelDataWithData:total];
        
    }];
}

-(void)taskSearchClick{
    
    [self.filterView showAnimation];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_queryProjectTaskCondition) {
        
        self.filterView.conditions = resp.body;
        
    }
    if (resp.cmdId == HQCMD_getPersonnelTaskFilterCondition) {
        
        self.filterView.conditions = [resp.body valueForKey:@"condition"] ;
    }
    if (resp.cmdId == HQCMD_savePersonnelData) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header beginRefreshing];
    }
    if (resp.cmdId == HQCMD_newPersonnelTaskList || resp.cmdId == HQCMD_newProjectTaskList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dict = resp.body;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }else {
            [self.tableView.mj_header endRefreshing];
            [self.tasks removeAllObjects];
//            [self.frames removeAllObjects];
        }
        
        for (NSDictionary *taskDict in [dict valueForKey:@"dataList"]) {
            
            TFProjectRowModel *task = [HQHelper projectRowWithTaskDict:taskDict];
            task.cellHeight = [NSNumber numberWithFloat:[TFNewProjectTaskItemCell refreshNewProjectTaskItemCellHeightWithModel:task haveClear:NO]];
            [self.tasks addObject:task];
            
//            TFProjectRowFrameModel *frame = [[TFProjectRowFrameModel alloc] initBorder];
//            frame.projectRow = task;
//            [self.frames addObject:frame];
        }
        
        NSDictionary *pageInfo = [dict valueForKey:@"pageInfo"];
        if ([[pageInfo valueForKey:@"totalRows"] integerValue] <= self.tasks.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.tasks.count) {
            self.tableView.backgroundView = nil;
        }else{
            self.tableView.backgroundView = self.noContentView;
        }
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
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }else  if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}



#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.mj_header = [TFRefresh headerNormalRefreshWithBlock:^{
        self.pageNum = 1;
       
        if (self.projectId) {
            [self.projectTaskBL requestNewProjectTaskListWithProjectId:self.projectId PageNum:@(self.pageNum) pageSize:@(self.pageSize) queryWhere:self.queryWhere sortField:self.sortField dateFormat:self.dateFormat queryType:@(self.type) bean:[NSString stringWithFormat:@"project_custom_%lld",[self.projectId longLongValue]]];
        }else{
            [self.projectTaskBL requestNewPersonnelTaskListWithPageNum:@(self.pageNum) pageSize:@(self.pageSize) queryWhere:self.queryWhere sortField:self.sortField dateFormat:self.dateFormat queryType:@(self.type)];
        }
        
    }];
    tableView.mj_footer = [TFRefresh footerAutoRefreshWithBlock:^{
        self.pageNum ++;
        
        if (self.projectId) {
            [self.projectTaskBL requestNewProjectTaskListWithProjectId:self.projectId PageNum:@(self.pageNum) pageSize:@(self.pageSize) queryWhere:self.queryWhere sortField:self.sortField dateFormat:self.dateFormat queryType:@(self.type) bean:[NSString stringWithFormat:@"project_custom_%lld",[self.projectId longLongValue]]];
        }else{
            [self.projectTaskBL requestNewPersonnelTaskListWithPageNum:@(self.pageNum) pageSize:@(self.pageSize) queryWhere:self.queryWhere sortField:self.sortField dateFormat:self.dateFormat queryType:@(self.type)];
        }
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tasks.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    TFProjectTaskItemCell *cell = [TFProjectTaskItemCell projectTaskItemCellWithTableView:tableView];
//    cell.frameModel = self.frames[indexPath.row];
//    cell.delegate = self;
//    return cell;
    TFNewProjectTaskItemCell *cell = [TFNewProjectTaskItemCell newProjectTaskItemCellWithTableView:tableView];
    [cell refreshNewProjectTaskItemCellWithModel:self.tasks[indexPath.row] haveClear:NO];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFProjectRowModel *row = self.tasks[indexPath.row];
//    TFProjectRowFrameModel *frame = self.frames[indexPath.row];
    
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
//        frame.projectRow = row;
        
        [self.tableView reloadData];
    };
    detail.deleteAction = ^{
        
        [self.tasks removeObjectAtIndex:indexPath.row];
//        [self.frames removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFProjectRowModel *model = self.tasks[indexPath.row];
    return [model.cellHeight floatValue];
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

#pragma mark - TFProjectTaskItemCellDelegate
-(void)projectTaskItemCell:(TFNewProjectTaskItemCell *)cell didClickedFinishBtnWithModel:(TFProjectRowModel *)model{
    
    self.rowModel = model;
//    self.rowFrameModel = cell.frameModel;
    
//    if ([model.finishType isEqualToNumber:@1]) {
//
//        if ([model.from isEqualToNumber:@1]) {// 个人任务
//
//            [self.projectTaskBL requestGetPersonnelTaskRoleWithTaskId:model.id typeStatus:@0];
//
//        }else{// 项目任务
//
//            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:model.projectId taskId:model.taskInfoId taskType:@1];
//
//        }
//
//    }else{
//
//        if ([model.from isEqualToNumber:@1]) {// 个人任务
//            [self.projectTaskBL requestGetPersonnelTaskRoleWithTaskId:model.id typeStatus:@0];
//
//        }else{// 项目任务
//            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:model.projectId taskId:model.taskInfoId taskType:@1];
//
//        }
//    }
    
    TFSelectStatusController *select = [[TFSelectStatusController alloc] init];
    select.type = 2;
    select.task = model;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:select];
    select.refresh = ^{
        [self.tableView reloadData];
    };
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 0x111) {// 完成任务
        
        if (buttonIndex == 1) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if ([self.rowModel.from isEqualToNumber:@1]) {// 个人任务
                
                [self.projectTaskBL requestPersonnelTaskFinishOrActiveWithTaskId:self.rowModel.id];
                
            }else{// 任务
                
//                [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.rowModel.taskInfoId completeStatus:@1 remark:nil];
                [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.rowModel.bean_id completeStatus:@1 remark:nil];
            }
            
        }
    }
    
    if (alertView.tag == 0x222) {// 激活任务
        
        if (buttonIndex == 1) {
            
            if ([self.rowModel.from isEqualToNumber:@1]) {// 个人任务
                
                [self.projectTaskBL requestPersonnelTaskFinishOrActiveWithTaskId:self.rowModel.id];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
