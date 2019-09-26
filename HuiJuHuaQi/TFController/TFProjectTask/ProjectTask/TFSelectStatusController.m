//
//  TFSelectStatusController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/29.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectStatusController.h"
#import "TFPriorityStatusCell.h"
#import "HQNotPassSubmitView.h"
#import "TFProjectTaskBL.h"
#import "TFCustomerRowsModel.h"
#import "TFCustomBaseModel.h"
#import "TFCustomBL.h"
#import "TFChangeHelper.h"

@interface TFSelectStatusController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>

@property (nonatomic, weak) UITableView *tableView;

/** 状态值 */
@property (nonatomic, assign) NSInteger initialValue;

@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;
/** 任务角色权限列表 */
@property (nonatomic, strong) NSArray *taskRoleAuths;

/** role */
@property (nonatomic, copy) NSString *role;

@property (nonatomic, assign) NSInteger taskType;
/** 激活是否需要填写激活原因 */
@property (nonatomic, copy) NSString <Optional>*project_complete_status;
/** 修改截止时间是否需要填写修改原因 */
@property (nonatomic, copy) NSString <Optional>*project_time_status;
/** detailDict */
@property (nonatomic, strong) NSMutableDictionary *detailDict;
/** 项目状态 */
@property (nonatomic, copy) NSString *project_status;
/** 标签s */
@property (nonatomic, strong) NSMutableArray *labels;
/** 优先级s */
@property (nonatomic, strong) NSMutableArray *prioritys;
/** 优先级选项s */
@property (nonatomic, strong) NSMutableArray *allPrioritys;
/** 状态s */
@property (nonatomic, strong) NSMutableArray *taskStatues;
/** 状态选项s */
@property (nonatomic, strong) NSMutableArray *allStatues;
/** 任务名称 */
@property (nonatomic, copy) NSString *taskName;
/** 描述文字 */
@property (nonatomic, copy) NSString *descString;
/** 任务状态： 0：未开始 1：进行中 2：暂停 3：已完成 */
@property (nonatomic, assign) NSInteger taskOpen;
/** 任务优先级： 0：普通 1：紧急 2：非常紧急 */
@property (nonatomic, assign) NSInteger taskPriority;
/** 保存未编辑的自定义数据 */
@property (nonatomic, strong) NSDictionary *oldData;
/** 保存编辑的自定义数据 */
@property (nonatomic, strong) NSMutableDictionary *data;
/** 修改截止时间备注 */
@property (nonatomic, copy) NSString *remark;
/** 关联数据 */
@property (nonatomic, strong) NSDictionary *relationDict;
/** 关联名称 */
@property (nonatomic, copy) NSString *relationName;
/** 执行人 */
@property (nonatomic, strong) HQEmployModel *employee;
@property (nonatomic, assign) long long startTime;
@property (nonatomic, assign) long long endTime;
/** 上传文件 */
@property (nonatomic, strong) NSMutableArray *files;
/** 校验人 */
@property (nonatomic, assign) BOOL checkShow;
/** 校验人 */
@property (nonatomic, strong) HQEmployModel *checkPeople;
/** 协作人可见 */
@property (nonatomic, assign) BOOL coopShow;
/** TFCustomBL */
@property (nonatomic, strong) TFCustomBL *customBL;

/** customModel */
@property (nonatomic, strong) TFCustomBaseModel *customModel;

@property (nonatomic, strong) TFCustomerOptionModel *selectOption;

@end

@implementation TFSelectStatusController

-(NSMutableArray *)files{
    if (!_files) {
        _files = [NSMutableArray array];
    }
    return _files;
}
-(NSMutableArray *)labels{
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}
-(NSMutableArray *)prioritys{
    if (!_prioritys) {
        _prioritys = [NSMutableArray array];
    }
    return _prioritys;
}
-(NSMutableArray *)allPrioritys{
    if (!_allPrioritys) {
        _allPrioritys = [NSMutableArray array];
    }
    return _allPrioritys;
}
-(NSMutableArray *)taskStatues{
    if (!_taskStatues) {
        _taskStatues = [NSMutableArray array];
    }
    return _taskStatues;
}
-(NSMutableArray *)allStatues{
    if (!_allStatues) {
        _allStatues = [NSMutableArray array];
    }
    return _allStatues;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(cancel) text:@"取消" textColor:GreenColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    if (self.type == 2) {
        
        self.projectTaskBL = [TFProjectTaskBL build];
        self.projectTaskBL.delegate = self;
        self.customBL = [TFCustomBL build];
        self.customBL.delegate = self;
        
        NSArray *status = self.task.picklist_status;
        if (status && status.firstObject) {
            TFCustomerOptionModel *op = status.firstObject;
            self.initialValue = [op.value integerValue];
        }
        
        NSArray *names = @[@"未进行",@"进行中",@"已暂停",@"已完成"];
        NSArray *colors = @[@"E5E5E5",@"#DAEDFF",@"#E5E5E5",@"#EFF8E8"];
        NSMutableArray *prioritys = [NSMutableArray array];
        for (NSInteger i = 0; i < names.count; i++) {
            TFCustomerOptionModel *model = [[TFCustomerOptionModel alloc] init];
            [prioritys addObject:model];
            model.label = names[i];
            model.color = colors[i];
            model.value = [NSString stringWithFormat:@"%ld",i];
            if (i == self.initialValue) {
                model.open = @1;
            }
        }
        self.options = prioritys;
        
        
        if ([self.task.from isEqualToNumber:@1]) {// 个人任务
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if (self.task.task_id) {// 子任务
                self.taskType = 3;
                [self.projectTaskBL requestPersonnelSubTaskDetailWithTaskId:self.task.id];// 个人任务子任务详情
                [self.projectTaskBL requestGetPersonnelTaskRoleWithTaskId:self.task.id typeStatus:@1];// 任务角色
                [self.customBL requestTaskLayoutWithBean:[NSString stringWithFormat:@"project_custom"]];// 个人任务布局

            }else{// 主任务
                self.taskType = 2;
                [self.projectTaskBL requestPersonnelTaskDetailWithTaskId:self.task.id];// 个人任务详情
                [self.projectTaskBL requestGetPersonnelTaskRoleWithTaskId:self.task.id typeStatus:@0];// 任务角色
                [self.customBL requestTaskLayoutWithBean:[NSString stringWithFormat:@"project_custom"]];// 个人任务布局
            }
        }else{// 项目任务

            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if (self.task.task_id) {// 子任务
                self.taskType = 1;
                [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:self.task.projectId taskId:self.task.id taskType:@(self.taskType+1)];
                [self.projectTaskBL requestGetChildTaskDetailWithChildTaskId:self.task.id];// 子任务详情
                [self.projectTaskBL requestGetPersonnelTaskRoleWithTaskId:self.task.id typeStatus:@2];// 任务角色
                [self.projectTaskBL requestGetRoleProjectTaskAuthWithProjectId:self.task.projectId];// 任务角色权限
                [self.customBL requestTaskLayoutWithBean:[NSString stringWithFormat:@"project_custom_%@",[self.task.projectId description]]];// 任务布局

            }else{// 主任务
                self.taskType = 0;
                
                [self.projectTaskBL requestGetTaskDetailWithTaskId:self.task.id];// 任务详情
                [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:self.task.projectId taskId:self.task.id taskType:@(self.taskType+1)];
                [self.projectTaskBL requestGetProjectTaskRoleWithProjectId:self.task.projectId taskId:self.task.id typeStatus:@1];// 项目任务角色
                [self.projectTaskBL requestGetRoleProjectTaskAuthWithProjectId:self.task.projectId];// 任务角色权限
                [self.customBL requestTaskLayoutWithBean:[NSString stringWithFormat:@"project_custom_%@",[self.task.projectId description]]];// 任务布局

            }
        }
        
    }
    if (self.type == 0 || self.type == 2) {
        self.navigationItem.title = @"选择状态";
    }else{
        self.navigationItem.title = @"选择优先级";
    }
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_projectUpdateTask || resp.cmdId == HQCMD_projectUpdateSubTask  || resp.cmdId == HQCMD_personnelTaskEdit  || resp.cmdId == HQCMD_personnelSubTaskEdit) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.selectOption) {
            self.task.picklist_status = [NSArray <TFCustomerOptionModel,Optional>arrayWithObject:self.selectOption];
        }
        if (self.refresh) {
            self.refresh();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (resp.cmdId == HQCMD_getProjectFinishAndActiveAuth) {
        NSDictionary *dict = resp.body;
        self.project_time_status = [[dict valueForKey:@"project_time_status"] description];
        self.project_complete_status = [[dict valueForKey:@"project_complete_status"] description];
    }
   
    if (resp.cmdId == HQCMD_getTaskDetail || resp.cmdId == HQCMD_getChildTaskDetail) {// 任务详情 or 子任务详情
        
        
        NSDictionary *dict = resp.body;
        
        self.detailDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        self.project_status = [[dict valueForKey:@"project_status"] description];
        
        NSDictionary *dd = [self.detailDict valueForKey:@"customArr"];
        // 标签
        id lab = [dd valueForKey:@"picklist_tag"];
        NSMutableArray *labels = [NSMutableArray array];
        if ([lab isKindOfClass:[NSArray class]]) {
            for (NSDictionary *df in lab) {
                TFCustomerOptionModel *op = [[TFCustomerOptionModel alloc] init];
                op.value = [df valueForKey:@"id"];
                op.color = [df valueForKey:@"colour"];
                op.label = [df valueForKey:@"name"];
                [labels addObject:op];
            }
        }
        self.labels = labels;

        // 任务名称
        self.taskName = [self.detailDict valueForKey:@"task_name"]?:[dd valueForKey:@"text_name"];
        // 保存自定义未修改前的数据
        self.oldData = dd;
        //        self.data = [NSMutableDictionary dictionaryWithDictionary:dd];
        // 描述
        self.descString = [dd valueForKey:@"multitext_desc"];
        // 优先级
        NSMutableArray *prioritys = [NSMutableArray array];
        id prio = [dd valueForKey:@"picklist_priority"];
        if ([prio isKindOfClass:[NSArray class]]) {
            for (NSDictionary *df in prio) {
                TFCustomerOptionModel *op = [[TFCustomerOptionModel alloc] initWithDictionary:df error:nil];
                if (op) {
                    [prioritys addObject:op];
                }
            }
        }
        self.prioritys = prioritys;
        // 状态
        NSMutableArray *taskStatues = [NSMutableArray array];
        id sta = [dd valueForKey:@"picklist_status"];
        if ([sta isKindOfClass:[NSArray class]]) {
            for (NSDictionary *df in sta) {
                TFCustomerOptionModel *op = [[TFCustomerOptionModel alloc] initWithDictionary:df error:nil];
                if (op) {
                    [taskStatues addObject:op];
                }
            }
        }
        self.taskStatues = taskStatues;

        // 执行人
        NSArray *arr = [dd valueForKey:@"personnel_principal"];
        if ([arr isKindOfClass:[NSArray class]] && arr.count) {
            self.employee = [[HQEmployModel alloc] initWithDictionary:arr.firstObject error:nil];
            //            self.employee.id = [self.detailDict valueForKey:@"executor_id"];
            //            self.employee.employee_name = [self.detailDict valueForKey:@"employee_name"];
            //            self.employee.picture = [self.detailDict valueForKey:@"employee_pic"];
        }
        // 附件
        NSArray *files = [dd valueForKey:@"attachment_customnumber"];
        NSMutableArray *filemodles = [NSMutableArray array];
        for (NSDictionary *di in files) {
            TFFileModel *m = [[TFFileModel alloc] initWithDictionary:di error:nil];
            if (m) {
                [filemodles addObject:m];
            }
        }
        self.files = filemodles;
        // 截止时间
        self.startTime = [NUMBER([dd valueForKey:@"datetime_starttime"]) longLongValue];
        self.endTime = [NUMBER([dd valueForKey:@"datetime_deadline"]) longLongValue];
        // 校验
        self.checkShow = [[[self.detailDict valueForKey:@"check_status"] description] isEqualToString:@"1"]?YES:NO;
        if ([self.detailDict valueForKey:@"check_member"] && [[self.detailDict valueForKey:@"check_member"] longLongValue] != 0) {
            self.checkPeople = [[HQEmployModel alloc] init];
            self.checkPeople.id = [self.detailDict valueForKey:@"check_member"];
            self.checkPeople.employee_id = [self.detailDict valueForKey:@"check_member"];
            self.checkPeople.employee_name = [self.detailDict valueForKey:@"employee_name"];
            self.checkPeople.picture = [self.detailDict valueForKey:@"employee_pic"];
        }
        // 协作人可见
        if (self.taskType == 0 || self.taskType == 1) {
            self.coopShow = [[[self.detailDict valueForKey:@"associates_status"] description] isEqualToString:@"1"]?YES:NO;
        }else{
            self.coopShow = [[[self.detailDict valueForKey:@"participants_only"] description] isEqualToString:@"1"]?YES:NO;
        }

        
    }
    
    if (resp.cmdId == HQCMD_personnelTaskDetail || resp.cmdId == HQCMD_personnelSubTaskDetail) {// 个人任务详情 or 个人任务子任务详情
        
        
        NSDictionary *dict = resp.body;
        self.detailDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        
        NSDictionary *dd = [self.detailDict valueForKey:@"customLayout"];
        // 标签
        id lab = [dd valueForKey:@"picklist_tag"];
        NSMutableArray *labels = [NSMutableArray array];
        if ([lab isKindOfClass:[NSArray class]]) {
            for (NSDictionary *df in lab) {
                TFCustomerOptionModel *op = [[TFCustomerOptionModel alloc] init];
                op.value = [df valueForKey:@"id"];
                op.color = [df valueForKey:@"colour"];
                op.label = [df valueForKey:@"name"];
                [labels addObject:op];
                
            }
        }
        self.labels = labels;
        // 任务名称
        self.taskName = [self.detailDict valueForKey:@"task_name"]?:[dd valueForKey:@"text_name"];
        // 关联
        if ([self.detailDict valueForKey:@"from_status"]) {
            NSMutableDictionary *relationDict = [NSMutableDictionary dictionary];
            if ([[self.detailDict valueForKey:@"from_status"] integerValue] == 2) {// 引用自定义
                if ([self.detailDict valueForKey:@"relation_data"]) {
                    [relationDict setObject:[self.detailDict valueForKey:@"relation_data"] forKey:@"dataName"];
                    self.relationName = [self.detailDict valueForKey:@"relation_data"];
                }
                if ([self.detailDict valueForKey:@"relation_id"]) {
                    [relationDict setObject:[self.detailDict valueForKey:@"relation_id"] forKey:@"dataId"];
                }
                if ([self.detailDict valueForKey:@"bean_name"]) {
                    [relationDict setObject:[self.detailDict valueForKey:@"bean_name"] forKey:@"beanName"];
                }
                [relationDict setObject:@1 forKey:@"type"];
            }
            if ([[self.detailDict valueForKey:@"from_status"] integerValue] == 1) {// 引用项目
                
                if ([self.detailDict valueForKey:@"relation_data"]) {
                    [relationDict setObject:[self.detailDict valueForKey:@"relation_data"] forKey:@"projectName"];
                    self.relationName = [self.detailDict valueForKey:@"relation_data"];
                }
                if ([self.detailDict valueForKey:@"relation_id"]) {
                    [relationDict setObject:[self.detailDict valueForKey:@"relation_id"] forKey:@"projectId"];
                }
                if ([self.detailDict valueForKey:@"bean_name"]) {
                    [relationDict setObject:[self.detailDict valueForKey:@"bean_name"] forKey:@"beanName"];
                }
                [relationDict setObject:@0 forKey:@"type"];
            }
            self.relationDict = relationDict;
        }
        
        // 保存自定义未修改前的数据
        self.oldData = dd;
        self.data = [NSMutableDictionary dictionaryWithDictionary:dd];
        // 描述
        self.descString = [dd valueForKey:@"multitext_desc"];
        // 优先级
        NSMutableArray *prioritys = [NSMutableArray array];
        id prio = [dd valueForKey:@"picklist_priority"];
        if ([prio isKindOfClass:[NSArray class]]) {
            for (NSDictionary *df in prio) {
                TFCustomerOptionModel *op = [[TFCustomerOptionModel alloc] initWithDictionary:df error:nil];
                if (op) {
                    [prioritys addObject:op];
                }
            }
        }
        self.prioritys = prioritys;
        // 状态
        NSMutableArray *taskStatues = [NSMutableArray array];
        id sta = [dd valueForKey:@"picklist_status"];
        if ([sta isKindOfClass:[NSArray class]]) {
            for (NSDictionary *df in sta) {
                TFCustomerOptionModel *op = [[TFCustomerOptionModel alloc] initWithDictionary:df error:nil];
                if (op) {
                    [taskStatues addObject:op];
                }
            }
        }
        self.taskStatues = taskStatues;
        
        // 执行人
        NSArray *arr = [dd valueForKey:@"personnel_principal"];
        if ([arr isKindOfClass:[NSArray class]] && arr.count) {
            self.employee = [[HQEmployModel alloc] initWithDictionary:arr.firstObject error:nil];
            //            self.employee.id = [self.detailDict valueForKey:@"executor_id"];
            //            self.employee.employee_name = [self.detailDict valueForKey:@"employee_name"];
            //            self.employee.picture = [self.detailDict valueForKey:@"employee_pic"];
        }
        // 附件
        NSArray *files = [dd valueForKey:@"attachment_customnumber"];
        NSMutableArray *filemodles = [NSMutableArray array];
        for (NSDictionary *di in files) {
            TFFileModel *m = [[TFFileModel alloc] initWithDictionary:di error:nil];
            if (m) {
                [filemodles addObject:m];
            }
        }
        self.files = filemodles;
        // 截止时间
        self.startTime = [[dd valueForKey:@"datetime_starttime"] longLongValue];
        self.endTime = [[dd valueForKey:@"datetime_deadline"] longLongValue];
        // 校验
        self.checkShow = [[[self.detailDict valueForKey:@"check_status"] description] isEqualToString:@"1"]?YES:NO;
        if ([self.detailDict valueForKey:@"check_member"] && [[self.detailDict valueForKey:@"check_member"] longLongValue] != 0) {
            self.checkPeople = [[HQEmployModel alloc] init];
            self.checkPeople.id = [self.detailDict valueForKey:@"check_member"];
            self.checkPeople.employee_id = [self.detailDict valueForKey:@"check_member"];
            self.checkPeople.employee_name = [self.detailDict valueForKey:@"employee_name"];
            self.checkPeople.picture = [self.detailDict valueForKey:@"employee_pic"];
        }
        // 协作人可见
        if (self.taskType == 0 || self.taskType == 1) {
            self.coopShow = [[[self.detailDict valueForKey:@"associates_status"] description] isEqualToString:@"1"]?YES:NO;
        }else{
            self.coopShow = [[[self.detailDict valueForKey:@"participants_only"] description] isEqualToString:@"1"]?YES:NO;
        }
        
    }
    if (resp.cmdId == HQCMD_getPersonnelTaskRole) {
        
        self.role = [TEXT([resp.body valueForKey:@"role"]) description];
        
    }
   
    if (resp.cmdId == HQCMD_getProjectTaskRole) {// 项目任务角色
        
        NSString *str = @"";
        for (NSDictionary *dict in resp.body) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[dict valueForKey:@"project_task_role"]]];
        }
        if (str.length) {
            str = [str substringToIndex:str.length-1];
        }
        
        self.role = str;
        
        
    }
    if (resp.cmdId == HQCMD_getProjectTaskRoleAuth) {// 任务角色权限
        self.taskRoleAuths = resp.body;
        
    }
    
    
    if (resp.cmdId == HQCMD_customTaskLayout) {// 任务布局
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        TFCustomBaseModel *model = resp.body;
        self.customModel = model;
        self.customModel.enableLayout.isHideColumnName = @"0";
        self.customModel.enableLayout.title = @"基本信息";
        
        // 优先级
        TFCustomerRowsModel *row = [self findRowWithName:@"picklist_priority"];
        if (row.entrys && [row.entrys isKindOfClass:[NSArray class]]) {
            [self.allPrioritys addObjectsFromArray:row.entrys];
        }
        // 状态
        TFCustomerRowsModel *rowStatus = [self findRowWithName:@"picklist_status"];
        if (rowStatus.entrys && [rowStatus.entrys isKindOfClass:[NSArray class]]) {
            [self.allStatues addObjectsFromArray:rowStatus.entrys];
        }
        
        if (self.detailDict) {
            [self detailHandleWithDict:[self.detailDict valueForKey:@"customArr"]];
        }
        
    }
    
    
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}


/** 取消 */
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/** 确定 */
-(void)sure{
    TFCustomerOptionModel *model = nil;
    for (TFCustomerOptionModel *mo in self.options) {
        if ([mo.open isEqualToNumber:@1]) {
            model = mo;
            self.selectOption = mo;
            break;
        }
    }
    if (model) {
        
        if (self.type == 2) {// 任务状态处理
            
            if (self.taskType == 0 || self.taskType == 1) {
                
                if (self.project_status && ![self.project_status isEqualToString:@"0"]) {
                    if ([self.project_status isEqualToString:@"1"]) {// 归档
                        
                        [MBProgressHUD showError:@"项目已归档" toView:self.view];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }
                    if ([self.project_status isEqualToString:@"2"]) {// 暂停
                        
                        [MBProgressHUD showError:@"项目已暂停" toView:self.view];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }
                    return;
                }
            }
            
            self.taskOpen = [model.value integerValue];
            
            if (self.taskOpen == self.initialValue) {
                [MBProgressHUD showError:@"请修改" toView:self.view];
                return;
            }
            
            // 加入选择的选项
            [self.taskStatues removeAllObjects];
            [self.taskStatues addObject:model];
            
            if (self.taskOpen == 3 || self.initialValue == 3) {// 激活或者完成
                // 任务的完成/激活权限
                
                if ([[[self.detailDict valueForKey:@"complete_status"] description] isEqualToString:@"1"]) {
                    
                    if (self.taskType == 2 || self.taskType == 3) {
                        
                        if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                            
                            
                            if (self.taskOpen == 2) {// 暂停
                                
                                [HQNotPassSubmitView submitPlaceholderStr:@"请输入" title:@"暂停原因" content:@"" maxCharNum:200 LeftTouched:^{
                                    
                                } onRightTouched:^(NSDictionary *dict) {
                                    
                                    self.remark = [dict valueForKey:@"text"];
                                    // 编辑个人任务
                                    if (self.taskType == 2) {
                                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                        [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                                    }else{
                                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                        [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                                    }
                                    
                                }];
                            }else{
                                
                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定激活此任务？" preferredStyle:UIAlertControllerStyleAlert];
                                
                                [alert addAction:[UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    
                                    // 编辑个人任务
                                    if (self.taskType == 2) {
                                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                        [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                                    }else{
                                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                        [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                                    }
                                    
                                }]];
                                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                    
                                }]];
                                
                                [self presentViewController:alert animated:YES completion:nil];
                            }
                            
                            
                        }else{
                            
                            [MBProgressHUD showError:@"无权限" toView:self.view];
                            return;
                        }
                        
                    }
                    else{
                        
                        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_2" role:self.role]) {
                            
                            if (self.taskOpen == 2) {// 暂停
                                
                                [HQNotPassSubmitView submitPlaceholderStr:@"请输入" title:@"暂停原因" content:@"" maxCharNum:200 LeftTouched:^{
                                    
                                } onRightTouched:^(NSDictionary *dict) {
                                    
                                    self.remark = [dict valueForKey:@"text"];
                                    // 编辑项目任务
                                    if (self.taskType == 0) {
                                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                        [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                                    }else{
                                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                        [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
                                    }
                                    
                                }];
                                
                                
                            }else{
                                
                                if ([self.project_complete_status isEqualToString:@"1"]) {// 填写激活原因
                                    
                                    [HQNotPassSubmitView submitPlaceholderStr:@"请输入" title:@"激活原因" content:@"" maxCharNum:200 LeftTouched:^{
                                        
                                    } onRightTouched:^(NSDictionary *dict) {
                                        
                                        self.remark = [dict valueForKey:@"text"];
                                        // 编辑项目任务
                                        if (self.taskType == 0) {
                                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                            [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                                        }else{
                                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                            [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
                                        }
                                        
                                    }];
                                    
                                }else{
                                    
                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定激活此任务？" preferredStyle:UIAlertControllerStyleAlert];
                                    
                                    [alert addAction:[UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        
                                        // 编辑项目任务
                                        if (self.taskType == 0) {
                                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                            [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                                        }else{
                                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                            [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
                                        }
                                        
                                    }]];
                                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                        
                                    }]];
                                    
                                    [self presentViewController:alert animated:YES completion:nil];
                                }
                            }
                            
                        }else{
                            
                            [MBProgressHUD showError:@"无权限激活任务" toView:self.view];
                            return;
                        }
                        
                    }
                }else{// 进行完成操作
                   
                        if (self.taskType == 2 || self.taskType == 3) {
                            
                            if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                                BOOL haveNOFinish = [self.task.childTaskNum integerValue] == [self.task.finishChildTaskNum integerValue];
//                                for (TFProjectRowModel *node in self.childTasks) {
//                                    if ([[node.complete_status description] isEqualToString:@"0"]) {
//                                        haveNOFinish = YES;
//                                        break;
//                                    }
//                                }
                                if (haveNOFinish) {
                                    
                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定完成此任务？" preferredStyle:UIAlertControllerStyleAlert];
                                    
                                    [alert addAction:[UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        
                                        // 编辑个人任务
                                        if (self.taskType == 2) {
                                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                            [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                                        }else{
                                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                            [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                                        }
                                        
                                    }]];
                                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                        
                                    }]];
                                    
                                    [self presentViewController:alert animated:YES completion:nil];
                                }else{
                                    [MBProgressHUD showError:@"子任务尚未全部完成，无法完成该任务" toView:self.view];
                                }
                            }else{
                                
                                [MBProgressHUD showError:@"无权限" toView:self.view];
                                return;
                            }
                        }
                        else{
                            
                            if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_2" role:self.role]) {
                                BOOL haveNOFinish = [self.task.childTaskNum integerValue] == [self.task.finishChildTaskNum integerValue];
//                                for (TFProjectRowModel *node in self.childTasks) {
//                                    if ([[node.complete_status description] isEqualToString:@"0"]) {
//                                        haveNOFinish = YES;
//                                        break;
//                                    }
//                                }
                                if (haveNOFinish) {
                                    
                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定完成此任务？" preferredStyle:UIAlertControllerStyleAlert];
                                    
                                    [alert addAction:[UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        
                                        // 编辑项目任务
                                        if (self.taskType == 0) {
                                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                            [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                                        }else{
                                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                            [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
                                        }
                                        
                                    }]];
                                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                        
                                    }]];
                                    
                                    [self presentViewController:alert animated:YES completion:nil];
                                    
                                }else{
                                    [MBProgressHUD showError:@"子任务尚未全部完成，无法完成该任务" toView:self.view];
                                }
                            }else{
                                
                                [MBProgressHUD showError:@"无权限" toView:self.view];
                                return;
                            }
                        }
                    }
                
            }
            else {
                 // 任务的编辑权限
                
                if (self.taskType == 0) {// 主任务
                    
                    // 判断编辑任务权限
                    if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_1" role:self.role]) {
                        
                        if (![[[self.detailDict valueForKey:@"complete_status"] description] isEqualToString:@"1"]) {
                            if (self.taskOpen == 2) {
                                
                                [HQNotPassSubmitView submitPlaceholderStr:@"请输入" title:@"暂停原因" content:@"" maxCharNum:200 LeftTouched:^{
                                    
                                } onRightTouched:^(NSDictionary *dict) {
                                    
                                    self.remark = [dict valueForKey:@"text"];
                                    // 编辑任务
                                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                    [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                                }];
                            }else{
                                
                                // 编辑任务
                                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                            }
                            
                        }else{
                            [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                        }
                    }else{
                        [MBProgressHUD showError:@"无权限" toView:self.view];
                    }
                }
                else if (self.taskType == 1){// 子任务
                    
                    // 判断编辑子任务权限
                    if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_9" role:self.role]) {
                        
                        if (![[[self.detailDict valueForKey:@"complete_status"] description] isEqualToString:@"1"]) {
                            
                            if (self.taskOpen == 2) {
                                
                                [HQNotPassSubmitView submitPlaceholderStr:@"请输入" title:@"暂停原因" content:@"" maxCharNum:200 LeftTouched:^{
                                    
                                } onRightTouched:^(NSDictionary *dict) {
                                    
                                    self.remark = [dict valueForKey:@"text"];
                                    
                                    // 编辑子任务
                                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                    [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
                                }];
                            }else{
                                
                                // 编辑子任务
                                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
                            }
                            
                        }else{
                            [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                        }
                    }
                }
                else if (self.taskType == 2){// 个人任务
                    
                    if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                        
                        if (![[[self.detailDict valueForKey:@"complete_status"] description] isEqualToString:@"1"]) {
                            
                            if (self.taskOpen == 2) {
                                
                                [HQNotPassSubmitView submitPlaceholderStr:@"请输入" title:@"暂停原因" content:@"" maxCharNum:200 LeftTouched:^{
                                    
                                } onRightTouched:^(NSDictionary *dict) {
                                    
                                    self.remark = [dict valueForKey:@"text"];
                                    // 编辑任务
                                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                    [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                                    
                                }];
                            }else{
                                // 编辑任务
                                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                            }
                        }else{
                            [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                        }
                    }
                }
                else{// 个人子任务
                    if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                        
                        if (![[[self.detailDict valueForKey:@"complete_status"] description] isEqualToString:@"1"]) {
                            
                            if (self.taskOpen == 2) {
                                
                                [HQNotPassSubmitView submitPlaceholderStr:@"请输入" title:@"暂停原因" content:@"" maxCharNum:200 LeftTouched:^{
                                    
                                } onRightTouched:^(NSDictionary *dict) {
                                    
                                    self.remark = [dict valueForKey:@"text"];
                                    // 编辑任务
                                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                    [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
                                    
                                }];
                            }else{
                                // 编辑任务
                                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
                            }
                            
                        }else{
                            [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                        }
                    }
                }
                
            }
        }
        else{
            
            if (self.type == 0 && [model.value integerValue] == 2) {
                
                [HQNotPassSubmitView submitPlaceholderStr:@"请输入" title:@"暂停原因" content:@"" maxCharNum:200 LeftTouched:^{
                    
                } onRightTouched:^(NSDictionary *dict) {
                    
                    if (self.sureHandler) {
                        self.sureHandler(@[model]);
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
            }else{
                if (self.sureHandler) {
                    self.sureHandler(@[model]);
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }
        }
        
    }else{
        [MBProgressHUD showError:@"请选择" toView:self.view];
    }
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
    return self.options.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFPriorityStatusCell *cell = [TFPriorityStatusCell priorityStatusCellWithTableView:tableView];
    TFCustomerOptionModel *model = self.options[indexPath.row];
    if (self.type == 1) {
        [cell refreshStatusCellWithModel:model];
    }else{
        [cell refreshNewStatusCellWithModel:model];
    }
    if ([model.open isEqualToNumber:@1]) {
        cell.selectBtn.selected = YES;
    }else{
        cell.selectBtn.selected = NO;
    }
    if (indexPath.row == self.options.count-1) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    for (TFCustomerOptionModel *model in self.options) {
        model.open = @0;
    }
    TFCustomerOptionModel *model = self.options[indexPath.row];
    model.open = [model.open isEqualToNumber:@1] ? @0 : @1;
    [self.tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
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

#pragma mark - 处理编辑
-(NSMutableDictionary *)taskHandle{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.taskType == 0 || self.taskType == 1) {// 项目任务
        
        if (self.taskType == 0) {// 主任务
            if (self.task.id) {
                [dict setObject:self.task.id forKey:@"taskId"];
            }
        }else{// 子任务
            if (self.task.id) {
                [dict setObject:self.task.id forKey:@"id"];
            }
            if (self.task.task_id) {
                [dict setObject:self.task.task_id forKey:@"taskId"];
            }
        }
        
        [dict setObject:self.task.projectId forKey:@"projectId"];
        [dict setObject:[NSString stringWithFormat:@"project_custom_%@",self.task.projectId] forKey:@"bean"];
        
        if (self.taskType == 0) {
            if (self.checkPeople) {
                [dict setObject:self.checkPeople.id?:self.checkPeople.employee_id forKey:@"checkMember"];
                [dict setObject:@"1" forKey:@"checkStatus"];
            }else{
                [dict setObject:@"0" forKey:@"checkStatus"];
                [dict setObject:@"" forKey:@"checkMember"];
            }
        }
        if (self.coopShow) {
            [dict setObject:@1 forKey:@"associatesStatus"];
        }else{
            [dict setObject:@0 forKey:@"associatesStatus"];
        }
        if (self.startTime != 0) {
            [dict setObject:@(self.startTime) forKey:@"startTime"];
        }
        if (self.endTime != 0) {
            [dict setObject:@(self.endTime) forKey:@"endTime"];
        }
        if (self.employee) {
            [dict setObject:self.employee.id?:self.employee.employee_id forKey:@"executorId"];
        }else{
            [dict setObject:@"" forKey:@"executorId"];
        }
        if (self.taskName) {
            [dict setObject:self.taskName forKey:@"taskName"];
        }
        if ([self.detailDict valueForKey:@"node_id"]) {
            [dict setObject:[self.detailDict valueForKey:@"node_id"] forKey:@"nodeId"];
        }
        // data
        NSDictionary *data = [self customHandle];
        if (data) {
            [dict setObject:data forKey:@"data"];
        }
    } else {// 个人任务
        // data
        NSDictionary *data = [self customHandle];
        [dict setObject:data forKey:@"customLayout"];
        [dict setObject:self.taskName forKey:@"name"];
        [dict setObject:@"project_custom" forKey:@"bean_name"];
        [dict setObject:self.task.id forKey:@"id"];
        
    }
    // oldData
    if (self.oldData) {
        [dict setObject:self.oldData forKey:@"oldData"];
    }
    // remark(激活原因)
    if (self.remark) {
        [dict setObject:self.remark forKey:@"remark"];
    }
    
    return dict;
}

/** 自定义字段 */
-(NSMutableDictionary *)customHandle{
    
    // 收集字段
    self.data = [self dictData];
    // 下面改变修改的值
    // 标签
    NSString *labels = @"";
    for (TFCustomerOptionModel *op in self.labels) {
        labels = [labels stringByAppendingString:[NSString stringWithFormat:@"%@,",op.value]];
    }
    if (labels.length) {
        labels = [labels substringToIndex:labels.length-1];
    }
    //    NSMutableArray *labels = [NSMutableArray array];
    //    for (TFCustomerOptionModel *op in self.labels) {
    //        NSDictionary *opDi = [op toDictionary];
    //        if (opDi) {
    //            [labels addObject:opDi];
    //        }
    //    }
    [self.data setObject:labels forKey:@"picklist_tag"];
    
    // 描述
    if (self.descString) {
        [self.data setObject:self.descString forKey:@"multitext_desc"];
    }else{
        [self.data setObject:@"" forKey:@"multitext_desc"];
    }
    // 执行人
    if (self.employee) {
        [self.data setObject:self.employee.id?:self.employee.employee_id forKey:@"personnel_principal"];
    }else{
        [self.data setObject:@"" forKey:@"personnel_principal"];
    }
    // 优先级
    NSMutableArray *prioritys = [NSMutableArray array];
    for (TFCustomerOptionModel *op in self.prioritys) {
        NSDictionary *opDi = [op toDictionary];
        if (opDi) {
            [prioritys addObject:opDi];
        }
    }
    [self.data setObject:prioritys forKey:@"picklist_priority"];
    // 状态
    NSMutableArray *status = [NSMutableArray array];
    for (TFCustomerOptionModel *op in self.taskStatues) {
        NSDictionary *opDi = [op toDictionary];
        if (opDi) {
            [status addObject:opDi];
        }
    }
    [self.data setObject:status forKey:@"picklist_status"];
    
    // 附件
    NSMutableArray *files = [NSMutableArray array];
    for (TFFileModel *model in self.files) {
        if (model.toDictionary) {
            [files addObject:model.toDictionary];
        }
    }
    [self.data setObject:files forKey:@"attachment_customnumber"];
    // 开始时间
    if (self.startTime != 0) {
        [self.data setObject:@(self.startTime) forKey:@"datetime_starttime"];
    }else if ([[self.data valueForKey:@"datetime_starttime"] longLongValue] == 0){
        [self.data removeObjectForKey:@"datetime_starttime"];
    }
    // 截止时间
    if (self.endTime != 0) {
        [self.data setObject:@(self.endTime) forKey:@"datetime_deadline"];
    }else if ([[self.data valueForKey:@"datetime_deadline"] longLongValue] == 0){
        [self.data removeObjectForKey:@"datetime_deadline"];
    }
    // 任务名称
    if (self.taskName) {
        [self.data setObject:self.taskName forKey:@"text_name"];
    }
    // 个人任务关联
    NSNumber *num = [self.relationDict valueForKey:@"type"];
    if (num) {
        if ([num isEqualToNumber:@0]) {
            
            [self.data setObject:[NSString stringWithFormat:@"%@",[self.relationDict valueForKey:@"projectName"]] forKey:@"relation_data"];
            
            [self.data setObject:@([[self.relationDict valueForKey:@"projectId"] longLongValue]) forKey:@"relation_id"];
            [self.data setObject:[self.relationDict valueForKey:@"beanName"] forKey:@"bean_name"];
            [self.data setObject:@1 forKey:@"from_status"];
            
        }else{
            [self.data setObject:[NSString stringWithFormat:@"%@",[self.relationDict valueForKey:@"dataName"]] forKey:@"relation_data"];
            [self.data setObject:@([[self.relationDict valueForKey:@"dataId"] longLongValue]) forKey:@"relation_id"];
            [self.data setObject:[self.relationDict valueForKey:@"beanName"] forKey:@"bean_name"];
            [self.data setObject:@2 forKey:@"from_status"];
            
        }
    }
    return self.data;
}

/** 布局表单数据 */
- (NSMutableDictionary *)dictData{
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:self.oldData];// 将old数据的id等信息记录下来
    
    for (TFCustomerRowsModel *model in self.customModel.enableLayout.rows) {
        
        [self getDataWithModel:model withDict:dataDict];// 按自定义的方式提交数据
    }
    
    return dataDict;
}

/** 将某组件所需提交的数据放入字典中 */
- (void)getDataWithModel:(TFCustomerRowsModel *)model withDict:(NSMutableDictionary *)dataDict{
    
#pragma mark - 选项控制隐藏的组件不提交
    if ([model.field.isOptionHidden isEqualToString:@"1"]) {
        [dataDict setObject:@"" forKey:model.name];
        return;
    }
    
    if ([model.type isEqualToString:@"identifier"] ||
        [model.type isEqualToString:@"serialnum"]) {// 自动编号不提交，自动生成
        return;
    }
    
    //    if (self.type == 0) {
    //        if ([model.field.addView isEqualToString:@"0"]) {
    //            return;
    //        }
    //    }
    
    if (model.fieldValue) {
        
        [dataDict setObject:model.fieldValue forKey:model.name];
    }else{
        
        [dataDict setObject:@"" forKey:model.name];
    }
    
    if ([model.type isEqualToString:@"location"]) {// 详细地址
        
        if (model.fieldValue && ![model.fieldValue isEqualToString:@""]) {
            
            NSMutableDictionary *loca = [NSMutableDictionary dictionary];
            
            [loca setObject:model.fieldValue forKey:@"value"];
            
            if (model.otherDict) {
                
                if ([model.otherDict valueForKey:@"longitude"]) {
                    
                    [loca setObject:[[model.otherDict valueForKey:@"longitude"] description] forKey:@"lng"];
                }
                if ([model.otherDict valueForKey:@"latitude"]) {
                    
                    [loca setObject:[[model.otherDict valueForKey:@"latitude"] description] forKey:@"lat"];
                }
                
                if ([model.otherDict valueForKey:@"area"]) {
                    [loca setObject:[model.otherDict valueForKey:@"area"] forKey:@"area"];
                }
            }
            
            [dataDict setObject:loca forKey:model.name];
        }else{
            
            [dataDict setObject:@"" forKey:model.name];
        }
        
    }
    
    if ([model.type isEqualToString:@"picklist"] || [model.type isEqualToString:@"multi"] || [model.type isEqualToString:@"mutlipicklist"]) {// 选项时
        
        if (model.selects && model.selects.count) {
            
            NSMutableArray *optArr = [NSMutableArray array];
            for (TFCustomerOptionModel *option in model.selects) {
                TFCustomerOptionModel *opt = [option copy];
                opt.subList = nil;
                [optArr addObject:[opt toDictionary]];
            }
            [dataDict setObject:optArr forKey:model.name];
        }else{
            [dataDict setObject:@"" forKey:model.name];
        }
    }
    
    if ([model.type isEqualToString:@"datetime"]) {// 转成时间戳
        
        if (model.fieldValue) {
            [dataDict setObject:@([HQHelper changeTimeToTimeSp:model.fieldValue formatStr:model.field.formatType]) forKey:model.name];
        }
    }
    
    if ([model.type isEqualToString:@"number"]) {// 数字类型
        
        if (![model.field.numberType isEqualToString:@"1"]) {// 小数
            
            if (model.fieldValue && ![model.fieldValue isEqualToString:@""]) {
                
                NSArray *nums = [model.fieldValue componentsSeparatedByString:@"."];
                if (nums.count == 1) {
                    
                    NSString *sttt = @"";
                    for (NSInteger k = 0; k < [model.field.numberLenth integerValue]; k ++) {
                        
                        sttt = [sttt stringByAppendingString:@"0"];
                    }
                    NSString *nu = [NSString stringWithFormat:@"%@.%@",nums.lastObject,sttt];
                    //                    [dataDict setObject:[NSNumber numberWithFloat:[nu floatValue]] forKey:model.name];
                    // 20180828 数字组件传值由数字类型转为字符串
                    [dataDict setObject:nu forKey:model.name];
                    
                }else if (nums.count == 2) {
                    
                    NSString *last = nums.lastObject;
                    NSInteger numLast = last.length;
                    for (NSInteger k = 0; k < [model.field.numberLenth integerValue]-numLast; k ++) {
                        
                        last = [last stringByAppendingString:@"0"];
                    }
                    NSString *nu = [NSString stringWithFormat:@"%@.%@",nums.firstObject,last];
                    //                    [dataDict setObject:[NSNumber numberWithFloat:[nu floatValue]] forKey:model.name];
                    // 20180828 数字组件传值由数字类型转为字符串
                    [dataDict setObject:nu forKey:model.name];
                    
                }
            }
            
        }
    }
    
    
    if ([model.type isEqualToString:@"attachment"] || [model.type isEqualToString:@"picture"]) {// 附件，图片
        
        if (model.selects.count) {
            
            NSMutableArray *aaa = [NSMutableArray array];
            
            for (TFFileModel *ff in model.selects) {
                
                NSDictionary *dd = [ff toDictionary];
                
                if (dd) {
                    [aaa addObject:dd];
                }
            }
            
            [dataDict setObject:aaa forKey:model.name];
        }
    }
    
    
    if ([model.type isEqualToString:@"reference"]) {// 关联关系
        
        if (model.relevanceField.fieldId) {// 显示名称，传递id
            [dataDict setObject:model.relevanceField.fieldId forKey:model.name];
        }
    }
    
    if ([model.type isEqualToString:@"personnel"]) {// 人员
        
        NSMutableArray *selects = [NSMutableArray array];
        NSString *str = @"";
        if (model.selects.count) {
            
            for (HQEmployModel *emp in model.selects) {
                
                NSDictionary *di = [[TFChangeHelper normalPeopleForEmployee:emp] toDictionary];
                [selects addObject:di];
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[emp.id description]]];
            }
        }
        
        if (str.length) {
            [dataDict setObject:[str substringToIndex:str.length-1] forKey:model.name];
        }else{
            
            [dataDict setObject:str forKey:model.name];
        }
        
    }
    
    if ([model.type isEqualToString:@"department"]) {// 部门
        
        NSString *str = @"";
        if (model.selects.count) {
            
            for (TFDepartmentModel *emp in model.selects) {
                
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[emp.id description]]];
            }
        }
        
        if (str.length) {
            [dataDict setObject:[str substringToIndex:str.length-1] forKey:model.name];
        }else{
            
            [dataDict setObject:str forKey:model.name];
        }
        
    }
    
    if ([model.type isEqualToString:@"subform"]){
        
        // 普通处理
        NSMutableArray *subforms = [NSMutableArray array];
        
        for (NSArray *subs in model.subforms) {
            
            NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
            for (TFCustomerRowsModel *row in subs) {// 子表单进行递归
                
                [self getDataWithModel:row withDict:subDict];
                
            }
            [subforms addObject:subDict];
        }
        
        [dataDict setObject:subforms forKey:model.name];
    }
    
}

/** 找到某个组件 */
- (TFCustomerRowsModel *)findRowWithName:(NSString *)name{
    
    TFCustomerRowsModel *goal = nil;
    
    //    for (TFCustomerLayoutModel *layout in self.customModel.layout) {
    
    //        for (TFCustomerRowsModel *model in layout.rows){
    for (TFCustomerRowsModel *model in self.customModel.enableLayout.rows){
        
        if ([model.name isEqualToString:name]) {
            
            goal = model;
            break;
        }
        
    }
    //    }
    
    return goal;
}
/** 处理详情 */
- (void)detailHandleWithDict:(NSDictionary *)dict{
    
    for (TFCustomerLayoutModel *layout in self.customModel.layout?:(self.customModel.enableLayout?@[self.customModel.enableLayout]:@[])) {
        
        for (TFCustomerRowsModel *model in layout.rows){
            
            [self customerRowsModel:model WithDict:dict];
            
        }
    }
    
}
/** 给某个组件赋值 */
- (void)customerRowsModel:(TFCustomerRowsModel *)model WithDict:(NSDictionary *)dict{
    
    
    if ([model.type isEqualToString:@"picklist"] || [model.type isEqualToString:@"multi"]) {
        
        if ([model.name isEqualToString:@"picklist_tag"]) {
            
            NSMutableArray *selects = [NSMutableArray array];
            NSString *str = @"";
            if ([[dict valueForKey:model.name] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *di in [dict valueForKey:model.name]) {
                    
                    if (![di valueForKey:@"name"] || [[di valueForKey:@"name"] isEqualToString:@""]) {
                        continue;
                    }
                    
                    TFCustomerOptionModel *op = [[TFCustomerOptionModel alloc] init];
                    op.label = [di valueForKey:@"name"];
                    op.color = [di valueForKey:@"colour"];
                    op.value = [di valueForKey:@"id"];
                    
                    [selects addObject:op];
                    
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[di valueForKey:@"name"]]];
                }
                
                if (str.length) {
                    model.fieldValue = [str substringToIndex:str.length-1];
                }
                model.selects = selects;
                
                
            }else{
                model.fieldValue = [[dict valueForKey:model.name] description];
            }
            
        }else{
            
            NSMutableArray *selects = [NSMutableArray array];
            NSString *str = @"";
            if ([[dict valueForKey:model.name] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *di in [dict valueForKey:model.name]) {
                    
                    if ([di valueForKey:@"value"] && ![[di valueForKey:@"value"] isEqualToString:@""]) {
                        
                        for (TFCustomerOptionModel *option in model.entrys) {
                            
                            if ([option.value isEqualToString:[di valueForKey:@"value"]]) {
                                
                                option.open = @1;
                                [selects addObject:option];
                                break;
                            }
                        }
                        
                    }
                    
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[di valueForKey:@"label"]]];
                }
                
                if (str.length) {
                    model.fieldValue = [str substringToIndex:str.length-1];
                }
                model.selects = selects;
                
//                 选项控制
//                if (selects.count) {
//                    TFCustomerOptionModel *option = selects[0];
//                    [self relevanceWithOption:option];
//                }
//
//                // 选项是否隐藏组件
//                [self optionHiddenWithModel:model];
//
                
            }else{
                model.fieldValue = [[dict valueForKey:model.name] description];
            }
        }
        
    }else if ([model.type isEqualToString:@"mutlipicklist"]){// 多级下拉
        
        
        NSMutableArray *selects = [NSMutableArray array];
        NSString *str = @"";
        if ([[dict valueForKey:model.name] isKindOfClass:[NSArray class]]) {
            
            NSInteger i = 0;
            for (NSDictionary *di in [dict valueForKey:model.name]) {
                
                if ([di valueForKey:@"value"] && ![[di valueForKey:@"value"] isEqualToString:@""]) {
                    
                    if (i == 0) {
                        
                        for (TFCustomerOptionModel *option in model.entrys) {
                            
                            if ([option.value isEqualToString:[di valueForKey:@"value"]]) {
                                
                                option.open = @1;
                                [selects addObject:option];
                                break;
                            }
                        }
                    }else{
                        TFCustomerOptionModel *option = selects.lastObject;
                        
                        for (TFCustomerOptionModel *option1 in option.subList) {
                            
                            if ([option1.value isEqualToString:[di valueForKey:@"value"]]) {
                                
                                option1.open = @1;
                                [selects addObject:option1];
                                break;
                            }
                        }
                        
                    }
                    
                }
                
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[di valueForKey:@"label"]]];
                
                i ++;
            }
            
            if (str.length) {
                model.fieldValue = [str substringToIndex:str.length-1];
            }
            
            model.selects = selects;
            
            
        }else{
            model.fieldValue = [[dict valueForKey:model.name] description];
        }
        
        
    } else if ([model.type isEqualToString:@"datetime"]) {
        model.fieldValue = [HQHelper nsdateToTime:[NUMBER([dict valueForKey:model.name]) longLongValue] formatStr:model.field.formatType];
        
    }else if ([model.type isEqualToString:@"reference"]) {
        
        if ([model.name isEqualToString:@"reference_relation"]) {
            
            model.fieldValue = [[self.detailDict valueForKey:@"relation_data"] description];
            model.relevanceField.fieldId = [[self.detailDict valueForKey:@"relation_id"] description];
            
        }else{
            
            NSDictionary *relevanceDict = [dict valueForKey:model.name];
            if ([relevanceDict isKindOfClass:[NSDictionary class]]) {
                
                model.fieldValue = [[relevanceDict valueForKey:@"name"] description];
                model.relevanceField.fieldId = [[relevanceDict valueForKey:@"id"] description];
                
            }else if ([relevanceDict isKindOfClass:[NSArray class]]) {
                
                NSArray *ar = (NSArray *)relevanceDict;
                if (ar.count) {
                    NSDictionary *di = ar[0];
                    model.fieldValue = [[di valueForKey:@"name"] description];
                    model.relevanceField.fieldId = [[di valueForKey:@"id"] description];
                }
            }else{
                
                model.fieldValue = [relevanceDict description];
            }
        }
        
        
    }else if ([model.type isEqualToString:@"identifier"] ||
              [model.type isEqualToString:@"serialnum"]) {// 自动编号不进行操作，都用后台返回默认值
        
        if (self.type != 3) {// 详情的时候为已有的
            model.fieldValue = [[dict valueForKey:model.name] description];
        }
        
    }else if ([model.type isEqualToString:@"subform"]) {// 子表单处理
        
        
        NSArray *arr = [dict valueForKey:model.name];
        
        
        if (arr.count) {
            
            for (NSInteger i = 0 ; i < model.subforms.count; i++) {
                
                NSArray *arrs = model.subforms[i];
                if (i < arr.count) {
                    
                    NSDictionary *dic = arr[i];
                    for (TFCustomerRowsModel *row in arrs) {
                        
                        [self customerRowsModel:row WithDict:dic];
                    }
                }
            }
        }
        
        
        
    } else if ([model.type isEqualToString:@"location"]){
        
        NSDictionary *locaDict = [dict valueForKey:model.name];
        if ([locaDict isKindOfClass:[NSDictionary class]] && locaDict) {
            
            model.fieldValue = [locaDict valueForKey:@"value"];
            
            NSString *str = [NSString stringWithFormat:@"%@",TEXT([[locaDict valueForKey:@"lng"] description])];
            
            if (![str isEqualToString:@""]) {
                //                if ([locaDict valueForKey:@"lng"] && ![[locaDict valueForKey:@"lng"] isEqualToString:@""]) {
                
                NSMutableDictionary *di = [NSMutableDictionary dictionary];
                
                [di setObject:[locaDict valueForKey:@"lng"] forKey:@"longitude"];
                [di setObject:[locaDict valueForKey:@"lat"] forKey:@"latitude"];
                
                model.otherDict = di;
            }
            
            
        }else{
            model.fieldValue = @"";
        }
        
        
    }else if ([model.type isEqualToString:@"personnel"]) {
        
        if ([model.name containsString:@"ccTo"]) {
            
            
        }else{//
            
            NSArray *arr = [dict valueForKey:model.name];
            
            if ([arr isKindOfClass:[NSArray class]]) {
                
                if (arr.count) {
                    
                    NSMutableArray *selects = [NSMutableArray array];
                    for (NSDictionary *di in arr) {
                        
                        HQEmployModel *emp = [[HQEmployModel alloc] init];
                        emp.id = [di valueForKey:@"id"];
                        emp.employeeName = [di valueForKey:@"name"]?[di valueForKey:@"name"]:[di valueForKey:@"employee_name"];
                        emp.picture = [di valueForKey:@"picture"];
                        emp.photograph = [di valueForKey:@"picture"];
                        [selects addObject:emp];
                        
                    }
                    model.selects = selects;
                    
                    NSString *str = @"";
                    for (HQEmployModel *model in selects) {
                        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@、",model.employeeName]];
                    }
                    if (str.length) {
                        model.fieldValue = [str substringToIndex:str.length-1];
                    }
                }
                
            }else{
                
                model.fieldValue = [[dict valueForKey:model.name] description];
            }
        }
        
    }else if ([model.type isEqualToString:@"department"]) {
        
        NSArray *arr = [dict valueForKey:model.name];
        
        if ([arr isKindOfClass:[NSArray class]]) {
            
            if (arr.count) {
                
                NSMutableArray *selects = [NSMutableArray array];
                for (NSDictionary *di in arr) {
                    
                    TFDepartmentModel *emp = [[TFDepartmentModel alloc] init];
                    emp.id = [di valueForKey:@"id"];
                    emp.name = [di valueForKey:@"name"];
                    [selects addObject:emp];
                    
                }
                model.selects = selects;
                
                NSString *str = @"";
                for (TFDepartmentModel *model in selects) {
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@、",model.name]];
                }
                if (str.length) {
                    model.fieldValue = [str substringToIndex:str.length-1];
                }
            }
            
        }else{
            
            model.fieldValue = [[dict valueForKey:model.name] description];
        }
        
    }else if ([model.type isEqualToString:@"attachment"] || [model.type isEqualToString:@"picture"]){// 图片附件
        
        model.fieldValue = @"";
        
        id objj = [dict valueForKey:model.name];
        if ([objj isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *seles = [NSMutableArray array];
            
            for (NSDictionary *dddd in objj) {
                
                TFFileModel *fi = [[TFFileModel alloc] initWithDictionary:dddd error:nil];
                if (fi) {
                    [seles addObject:fi];
                }
            }
            
            model.selects = seles;
        }
        
    }else if ([model.type isEqualToString:@"number"]){// 数字
        
        NSNumber *num = [dict valueForKey:model.name];
        
        if ([num isKindOfClass:[NSString class]]) {
            NSString *numStr = (NSString *)num;
            if ([numStr floatValue] != 0) {
                num = @([numStr floatValue]);
            }
        }
        
        if ([model.field.numberType isEqualToString:@"0"] || [model.field.numberType isEqualToString:@"2"]) {// 数字和百分比
            NSInteger point = [model.field.numberLenth integerValue];
            if (point == 0) {
                model.fieldValue = [NSString stringWithFormat:@"%.0lf",[num floatValue]];
            }else if (point == 1){
                model.fieldValue = [NSString stringWithFormat:@"%.1lf",[num floatValue]];
            }else if (point == 2){
                model.fieldValue = [NSString stringWithFormat:@"%.2lf",[num floatValue]];
            }else if (point == 3){
                model.fieldValue = [NSString stringWithFormat:@"%.3lf",[num floatValue]];
            }else {
                model.fieldValue = [NSString stringWithFormat:@"%.4lf",[num floatValue]];
            }
            if ([model.field.numberType isEqualToString:@"2"]) {
                
                if (model.fieldValue.length) {
                    
                    model.fieldValue = [NSString stringWithFormat:@"%@%@",TEXT(model.fieldValue),@"%"];
                }
            }
        }else{
            
            model.fieldValue = [NSString stringWithFormat:@"%ld",[num integerValue]];
        }
        
    }else if ([model.type isEqualToString:@"formula"] || [model.type isEqualToString:@"seniorformula"] || [model.type isEqualToString:@"functionformula"] || [model.type isEqualToString:@"citeformula"]){// 数字 公式 高级公式 函数
        
        NSNumber *num = [dict valueForKey:model.name];
        
        if ([num isKindOfClass:[NSString class]]) {
            NSString *numStr = (NSString *)num;
            if ([numStr floatValue] != 0) {
                num = @([numStr floatValue]);
            }
        }
        
        if ([model.field.numberType isEqualToString:@"0"] || [model.field.numberType isEqualToString:@"2"]) {// 数字和百分比
            NSInteger point = [model.field.decimalLen integerValue];
            if (point == 0) {
                model.fieldValue = [NSString stringWithFormat:@"%.0lf",[num floatValue]];
            }else if (point == 1){
                model.fieldValue = [NSString stringWithFormat:@"%.1lf",[num floatValue]];
            }else if (point == 2){
                model.fieldValue = [NSString stringWithFormat:@"%.2lf",[num floatValue]];
            }else if (point == 3){
                model.fieldValue = [NSString stringWithFormat:@"%.3lf",[num floatValue]];
            }else {
                model.fieldValue = [NSString stringWithFormat:@"%.4lf",[num floatValue]];
            }
            if ([model.field.numberType isEqualToString:@"2"]) {
                
                if (model.fieldValue.length) {
                    
                    model.fieldValue = [NSString stringWithFormat:@"%@%@",TEXT(model.fieldValue),@"%"];
                }
            }
        }else if ([model.field.numberType isEqualToString:@"4"]){// 日期
            
            model.fieldValue = [HQHelper nsdateToTime:[[dict valueForKey:model.name] longLongValue] formatStr:model.field.chooseType];
        } else{
            
            model.fieldValue = [NSString stringWithFormat:@"%@",[num description]];
        }
        
    }else{
        
        model.fieldValue = [[dict valueForKey:model.name] description];
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
