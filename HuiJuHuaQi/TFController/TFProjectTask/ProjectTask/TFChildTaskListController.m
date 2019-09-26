//
//  TFChildTaskListController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/27.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChildTaskListController.h"
#import "TFNewProjectTaskItemCell.h"
#import "TFProjectTaskDetailController.h"
#import "TFCreateChildTaskController.h"
#import "TFChangeHelper.h"
#import "TFProjectTaskBL.h"
#import "HQTFNoContentView.h"
#import "TFSelectStatusController.h"

@interface TFChildTaskListController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFNewProjectTaskItemCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;
@end

@implementation TFChildTaskListController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    for (TFProjectRowModel *task in self.tasks) {
        task.cellHeight = [NSNumber numberWithFloat:[TFNewProjectTaskItemCell refreshNewProjectTaskItemCellHeightWithModel:task haveClear:NO]];
    }
    [self setupTableView];
    self.navigationItem.title = @"子任务";
    if (self.auth) {
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(add) text:@"新增" textColor:GreenColor];
    }
    if (self.tasks.count == 0) {
        self.tableView.backgroundView = self.noContentView;
    }else{
        self.tableView.backgroundView = nil;
    }
}

-(void)add{
    
    if (self.taskType == 0 || self.taskType == 1) {
        
        if (self.project_status && ![self.project_status isEqualToString:@"0"]) {
            if ([self.project_status isEqualToString:@"1"]) {// 归档
                
                [MBProgressHUD showError:@"项目已归档" toView:self.view];
            }
            if ([self.project_status isEqualToString:@"2"]) {// 暂停
                
                [MBProgressHUD showError:@"项目已暂停" toView:self.view];
            }
            return;
        }
        if ([[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
            [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
            return;
        }
        TFCreateChildTaskController *childTask = [[TFCreateChildTaskController alloc] init];
        childTask.present = YES;
        childTask.taskId = self.dataId;
        childTask.projectId = self.projectId;
        childTask.type = 0;
        if (self.taskType == 0) {
            childTask.parentTaskType = @1;
        }else{
            childTask.parentTaskType = @2;
        }
        NSDictionary *dict = [self.detailDict valueForKey:@"customArr"];
        childTask.taskEndTime = [[dict valueForKey:@"datetime_deadline"] longLongValue];
        NSArray *arr = [dict valueForKey:@"personnel_principal"];
        if ([arr isKindOfClass:[NSArray class]] && arr.count) {
            TFEmployModel *em = [[TFEmployModel alloc] initWithDictionary:arr[0] error:nil];
            childTask.employee = [TFChangeHelper tfEmployeeToHqEmployee:em];
        }
        
        childTask.refreshAction = ^{
            
            [self.projectTaskBL requestGetChildTaskListWithTaskId:self.dataId nodeCode:self.nodeCode];

            if (self.refresh) {
                self.refresh();
            }
        };
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:childTask];
        [self presentViewController:navi animated:YES completion:nil];
    }
    if (self.taskType == 2 || self.taskType == 3) {
        
        if ([[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
            [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
            return;
        }
        TFCreateChildTaskController *childTask = [[TFCreateChildTaskController alloc] init];
        childTask.present = YES;
        childTask.taskId = self.dataId;
        childTask.type = 1;
        childTask.project_custom_id = [self.detailDict valueForKey:@"project_custom_id"];
        childTask.bean_name = [self.detailDict valueForKey:@"bean_name"];
        NSDictionary *dict = [self.detailDict valueForKey:@"customLayout"];
        childTask.taskEndTime = [[dict valueForKey:@"datetime_deadline"] longLongValue];
        NSArray *arr = [dict valueForKey:@"personnel_principal"];
        if ([arr isKindOfClass:[NSArray class]] && arr.count) {
            TFEmployModel *em = [[TFEmployModel alloc] initWithDictionary:arr[0] error:nil];
            childTask.employee = [TFChangeHelper tfEmployeeToHqEmployee:em];
        }
        
        childTask.refreshAction = ^{
            
            [self.projectTaskBL requestGetPersonnelChildTaskListWithTaskId:self.dataId];
            
            if (self.refresh) {
                self.refresh();
            }
        };
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:childTask];
        [self presentViewController:navi animated:YES completion:nil];
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
    if (resp.cmdId == HQCMD_getChildTaskList) {// 项目子任务列表
        
        // 子任务列表
        [self.tasks removeAllObjects];
        NSArray *subTaskArr = resp.body;
        for (NSDictionary *di in subTaskArr) {
            
            TFProjectRowModel *task = [HQHelper projectRowWithTaskDict:di];
            
            NSMutableArray<Optional,TFEmployModel> *personnel_principal = [NSMutableArray<Optional,TFEmployModel> array];
            TFEmployModel *em = [[TFEmployModel alloc] init];
            em.id = [di valueForKey:@"executor_id"];
            em.name = [di valueForKey:@"employee_name"];
            em.employee_name = [di valueForKey:@"employee_name"];
            em.picture = [di valueForKey:@"employee_pic"];
            [personnel_principal addObject:em];
            task.personnel_principal = personnel_principal;
            task.responsibler = em;
            
            task.cellHeight = @([TFNewProjectTaskItemCell refreshNewProjectTaskItemCellHeightWithModel:task haveClear:NO]);
            
            [self.tasks addObject:task];
            
        }
        if (self.tasks.count == 0) {
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = nil;
        }
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_getPersonnelChildTaskList) {// 个人子任务列表
        
        // 子任务列表
        [self.tasks removeAllObjects];
        NSArray *subTaskArr = resp.body;
        for (NSDictionary *di in subTaskArr) {
            
            NSMutableDictionary *dd = [NSMutableDictionary dictionaryWithDictionary:di];
            [dd setObject:@[] forKey:@"row"];
            TFProjectRowModel *task = [HQHelper projectRowWithTaskDict:dd];
            
            NSMutableArray<Optional,TFEmployModel> *personnel_principal = [NSMutableArray<Optional,TFEmployModel> array];
            if ([[di valueForKey:@"executor_id"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *cvv in [di valueForKey:@"executor_id"]) {
                    TFEmployModel *em = [[TFEmployModel alloc] init];
                    em.id = [cvv valueForKey:@"executor_id"];
                    em.name = [cvv valueForKey:@"employee_name"];
                    em.employee_name = [di valueForKey:@"employee_name"];
                    em.picture = [cvv valueForKey:@"picture"];
                }
            }
            task.personnel_principal = personnel_principal;
            task.responsibler = personnel_principal.firstObject;
            
            task.cellHeight = @([TFNewProjectTaskItemCell refreshNewProjectTaskItemCellHeightWithModel:task haveClear:NO]);
            [self.tasks addObject:task];
            
        }
        if (self.tasks.count == 0) {
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = nil;
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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tasks.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    detail.projectId = row.projectId;
    if (self.taskType == 0 || self.taskType == 2) {// 主任务
        detail.taskType = self.taskType+1;
    }else{
        detail.taskType = self.taskType;
    }
    detail.dataId = row.id;
    if (self.taskType == 0 || self.taskType == 1) {
        NSDictionary *dict = [self.detailDict valueForKey:@"customArr"];
        detail.mainTaskEndTime = [dict valueForKey:@"datetime_deadline"];
    }
    if (self.taskType == 2 || self.taskType == 3) {
        NSDictionary *dict = [self.detailDict valueForKey:@"customLayout"];
        detail.mainTaskEndTime = [dict valueForKey:@"datetime_deadline"];
    }
    if (row.task_id) {// 主任务
        detail.parentTaskId = row.task_id;
    }
    detail.action = ^(NSDictionary *parameter) {
        
        row.complete_status = [parameter valueForKey:@"complete_status"];
        row.finishType = [parameter valueForKey:@"complete_status"];
        [self.tableView reloadData];
    };
    detail.deleteAction = ^{
        
        [self.tasks removeObject:row];
        [self.tableView reloadData];
    };
    detail.childAction = ^{
        
//        if (self.taskType == 0) {
//
//            [self.projectTaskBL requestGetChildTaskListWithTaskId:self.dataId nodeCode:self.nodeCode];
//        }
//        if (self.taskType == 2) {
//
//            [self.projectTaskBL requestGetPersonnelChildTaskListWithTaskId:self.dataId];
//        }
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

#pragma mark - TFNewProjectTaskItemCellDelegate
-(void)projectTaskItemCell:(TFNewProjectTaskItemCell *)cell didClickedFinishBtnWithModel:(TFProjectRowModel *)model{
    
    TFSelectStatusController *select = [[TFSelectStatusController alloc] init];
    select.type = 2;
    select.task = model;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:select];
    select.refresh = ^{
        [self.tableView reloadData];
    };
    [self presentViewController:navi animated:YES completion:nil];
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
