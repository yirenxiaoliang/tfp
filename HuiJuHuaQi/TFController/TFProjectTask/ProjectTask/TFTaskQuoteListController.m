//
//  TFTaskQuoteListController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/27.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskQuoteListController.h"
#import "TFColumnView.h"
#import "TFProjectSectionModel.h"
#import "TFProjectNoteCell.h"
#import "TFProjectTaskItemCell.h"
#import "TFNewProjectCustomCell.h"
#import "TFTProjectCustomCell.h"
#import "TFProjectApprovalCell.h"
#import "TFNewProjectTaskItemCell.h"
#import "TFProjectTaskBL.h"
#import "TFModelEnterController.h"
#import "TFSelectMemoListController.h"
#import "TFNoteDataListModel.h"
#import "TFCreateNoteController.h"
#import "TFAddCustomController.h"
#import "TFApprovalListController.h"
#import "TFSelectCustomListController.h"
#import "TFCustomListItemModel.h"
#import "TFSelectTaskListController.h"
#import "TFQuoteTaskItemModel.h"
#import "TFRequest.h"
#import "TFProjectTaskDetailController.h"
#import "TFNewCustomDetailController.h"
#import "TFApprovalListItemModel.h"
#import "TFApprovalDetailController.h"
#import "HQTFNoContentView.h"
#import "TFChatBL.h"

@interface TFTaskQuoteListController ()<UITableViewDelegate,UITableViewDataSource,TFProjectApprovalCellDelegate,TFProjectNoteCellDelegate,TFNewProjectCustomCellDelegate,TFProjectTaskItemCellDelegate,TFNewProjectTaskItemCellDelegate,HQBLDelegate,TFColumnViewDelegate>
/** longPressModel */
@property (nonatomic, strong) TFProjectSectionModel *longPressModel;
/** longPressTaskIndex */
@property (nonatomic, assign) NSInteger longPressTaskIndex;

@property (nonatomic, weak) UITableView *tableView;
/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

@property (nonatomic, strong) TFChatBL *chatBL;

@property (nonatomic, strong) TFProjectRowModel *selectTask;

@end

@implementation TFTaskQuoteListController

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
    self.chatBL = [TFChatBL build];
    self.chatBL.delegate = self;
    
    if (self.type == 0) {
        self.navigationItem.title = @"引用";
    }else{
        self.navigationItem.title = @"被引用";
    }
    if (self.type == 0) {
        if (self.quoteAuth) {
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(add) text:@"添加" textColor:GreenColor];
        }
    }
    
    for (TFProjectSectionModel *model in self.relations) {
        for (TFProjectRowModel *row in model.tasks) {
            /** (数据类型 1备忘录 2任务 3自定义模块数据 4审批数据) */
            if ([row.dataType isEqualToNumber:@2]) {// 任务
                row.cellHeight = @([TFNewProjectTaskItemCell refreshNewProjectTaskItemCellHeightWithModel:row haveClear:self.cancelAuth]);
            }
        }
    }
    
    [self setupTableView];
    if (self.relations.count == 0) {
        self.tableView.backgroundView = self.noContentView;
    }else{
        self.tableView.backgroundView = nil;
    }
}

-(void)add{
    
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
    TFModelEnterController *enter = [[TFModelEnterController alloc] init];
    enter.type = 3;
    enter.projectId = self.projectId;
    enter.parameterAction = ^(NSMutableDictionary *parameter) {

        if ([parameter valueForKey:@"list"]) {
            [parameter removeObjectForKey:@"list"];
        }

        if (self.taskType == 0 || self.taskType == 1) {

            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameter];
            NSString *ids = [parameter valueForKey:@"data"];
            [dict setObject:self.dataId forKey:@"taskId"];
            [dict setObject:ids forKey:@"quoteTaskId"];
            [dict removeObjectForKey:@"data"];
            [dict setObject:self.projectId forKey:@"projectId"];
            NSString *bean_type = [parameter valueForKey:@"beanType"];
            [dict setObject:bean_type forKey:@"bean_type"];
            [dict removeObjectForKey:@"beanType"];
            if (self.taskType == 0) {
                [dict setObject:@1 forKey:@"taskType"];
            }else{
                [dict setObject:@2 forKey:@"taskType"];
            }

            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.projectTaskBL requestQuoteTaskRelationWithDict:dict];
        }else{

            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if ([parameter valueForKey:@"data"]) {
                [dict setObject:[parameter valueForKey:@"data"] forKey:@"relation_id"];
            }
            if ([parameter valueForKey:@"bean"]) {
                [dict setObject:[parameter valueForKey:@"bean"] forKey:@"bean_name"];
            }
            if ([parameter valueForKey:@"beanType"]) {
                [dict setObject:[parameter valueForKey:@"beanType"] forKey:@"beanType"];
            }
            if ([parameter valueForKey:@"projectId"]) {
                [dict setObject:[parameter valueForKey:@"projectId"] forKey:@"projectId"];
            }
            if ([parameter valueForKey:@"moduleId"]) {
                [dict setObject:[parameter valueForKey:@"moduleId"] forKey:@"module_id"];
            }
            if ([parameter valueForKey:@"moduleName"]) {
                [dict setObject:[parameter valueForKey:@"moduleName"] forKey:@"module_name"];
            }
            [dict setObject:self.dataId forKey:@"task_id"];
            if (self.taskType == 2) {
                [dict setObject:@0 forKey:@"from_type"];
            }else{
                [dict setObject:@1 forKey:@"from_type"];
            }
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.projectTaskBL requestPersonnelTaskQuotePersonnelTaskWithDict:dict];

        }
    };
    [self.navigationController pushViewController:enter animated:YES];
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStyleGrouped];
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
    return self.relations.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TFProjectSectionModel *model = self.relations[section];
    if (!model.select || [model.select isEqualToNumber:@0]) {
        return model.tasks.count;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFProjectSectionModel *model = self.relations[indexPath.section];
    TFProjectRowModel *row = model.tasks[indexPath.row];
    
    /** (数据类型 1备忘录 2任务 3自定义模块数据 4审批数据) */
    if ([row.dataType isEqualToNumber:@2]) {// 任务
        
//        TFProjectTaskItemCell *cell = [TFProjectTaskItemCell projectTaskItemCellWithTableView:tableView];
//
//        cell.frameModel = model.frames[indexPath.row];
//        cell.edit = self.quoteAuth;
//        cell.delegate = self;
//        cell.tag = indexPath.row;
//        return cell;
        TFNewProjectTaskItemCell *cell = [TFNewProjectTaskItemCell newProjectTaskItemCellWithTableView:tableView];
        [cell refreshNewProjectTaskItemCellWithModel:row haveClear:self.cancelAuth];
        cell.delegate = self;
        cell.tag = 0x1111 * indexPath.section + indexPath.row;
        cell.contentView.backgroundColor = WhiteColor;
        cell.backgroundColor = WhiteColor;
        return cell;
        
    }else if ([row.dataType isEqualToNumber:@1]){// 备忘录
        
        TFProjectNoteCell *cell = [TFProjectNoteCell projectNoteCellWithTableView:tableView];
        cell.frameModel = model.frames[indexPath.row];
        
        cell.edit = self.quoteAuth;
        cell.delegate = self;
        cell.tag = 0x1111 * indexPath.section + indexPath.row;
        if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        cell.contentView.backgroundColor = WhiteColor;
        cell.backgroundColor = WhiteColor;
        return cell;
        
    }else if ([row.dataType isEqualToNumber:@3]){// 自定义
        
        if (row.rows) {
            
            TFNewProjectCustomCell *cell = [TFNewProjectCustomCell newProjectCustomCellWithTableView:tableView];
            cell.frameModel = model.frames[indexPath.row];
            cell.edit = self.quoteAuth;
            cell.delegate = self;
            cell.tag = 0x1111 * indexPath.section + indexPath.row;
            cell.contentView.backgroundColor = WhiteColor;
            cell.backgroundColor = WhiteColor;
            return cell;
        }
        TFTProjectCustomCell *cell = [TFTProjectCustomCell projectCustomCellWithTableView:tableView];
        cell.frameModel = model.frames[indexPath.row];
//        cell.edit = self.quoteAuth;
        cell.tag = 0x1111 * indexPath.section + indexPath.row;
        cell.contentView.backgroundColor = WhiteColor;
        cell.backgroundColor = WhiteColor;
        return cell;
        
    }else{// 审批
        TFProjectApprovalCell *cell = [TFProjectApprovalCell  projectApprovalCellWithTableView:tableView];
        cell.frameModel = model.frames[indexPath.row];
        cell.edit = self.quoteAuth;
        cell.delegate = self;
        cell.tag = 0x1111 * indexPath.section + indexPath.row;
        cell.contentView.backgroundColor = WhiteColor;
        cell.backgroundColor = WhiteColor;
        return cell;
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFProjectSectionModel *frame = self.relations[indexPath.section];
    TFProjectRowModel *model = frame.tasks[indexPath.row];
    self.selectTask = model;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // 1备忘录 2任务 3自定义模块数据 4审批数据
    if ([model.dataType isEqualToNumber:@1]) {
        
//        [self.chatBL requestGetFuncAuthWithCommunalWithData:model.beanName moduleId:nil style:nil dataId:model.id reqmap:nil];
        [self.chatBL requestGetFuncAuthWithCommunalWithData:model.bean_name moduleId:nil style:nil dataId:model.bean_id reqmap:nil];
    }else if ([model.dataType isEqualToNumber:@2]){
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:model.dataType forKey:@"data_Type"];
//        if (model.quoteTaskId) {
//            [dict setObject:model.quoteTaskId forKey:@"taskInfoId"];
//            [dict setObject:model.quoteTaskId forKey:@"id"];
//        }
        if (model.task_id) {
            [dict setObject:model.task_id forKey:@"task_id"];
        }
        if (model.bean_id) {
            [dict setObject:model.bean_id forKey:@"taskInfoId"];
            [dict setObject:model.bean_id forKey:@"id"];
        }
        if (model.bean_name) {
            [dict setObject:model.bean_name forKey:@"beanName"];
        }
        if (model.taskName) {
            [dict setObject:model.taskName forKey:@"taskName"];
        }
        if (model.projectId) {
            [dict setObject:model.projectId forKey:@"projectId"];
        }
        if (model.from) {
            [dict setObject:model.from forKey:@"from"];
            [dict setObject:@0 forKey:@"fromType"];
        }
        
//        [self.chatBL requestGetFuncAuthWithCommunalWithData:model.beanName moduleId:nil style:nil dataId:model.taskInfoId reqmap:[HQHelper dictionaryToJson:dict]];
        [self.chatBL requestGetFuncAuthWithCommunalWithData:model.bean_name moduleId:nil style:nil dataId:model.bean_id reqmap:[HQHelper dictionaryToJson:dict]];
        
    }else if ([model.dataType isEqualToNumber:@3]){
//        [self.chatBL requestGetFuncAuthWithCommunalWithData:model.beanName moduleId:nil style:nil dataId:model.beanId reqmap:nil];
        [self.chatBL requestGetFuncAuthWithCommunalWithData:model.bean_name moduleId:nil style:nil dataId:model.bean_id reqmap:nil];
        
    }else if ([model.dataType isEqualToNumber:@4]){
        
        [self.chatBL requestGetFuncAuthWithCommunalWithData:model.bean_name moduleId:model.module_id style:nil dataId:model.bean_id reqmap:nil];
    }
    
//    [self taskRelationListDidClickedModel:model];
}

-(void)taskRelationListDidClickedModel:(TFProjectRowModel *)model{
    
    
    // 1备忘录 2任务 3自定义模块数据 4审批数据
    if ([model.dataType isEqualToNumber:@1]) {
        
        TFCreateNoteController *note = [[TFCreateNoteController alloc] init];
        note.type = 1;
//        note.noteId = model.id;
        note.noteId = model.bean_id;
        [self.navigationController pushViewController:note animated:YES];
        
    }else if ([model.dataType isEqualToNumber:@2]){
        
        
        TFProjectTaskDetailController *detail = [[TFProjectTaskDetailController alloc] init];
        detail.projectId = model.projectId;
        if ([model.from isEqualToNumber:@1]) {// 个人任务
            if (model.task_id) {// 子任务
                detail.taskType = 3;
                detail.parentTaskId = model.task_id;
            }else{// 主任务
                detail.taskType = 2;
            }
        }else{// 项目任务
//            if (model.task_id && [model.task_type isEqualToString:@"0"]) {// 子任务
            if (model.task_id) {// 子任务
                detail.taskType = 1;
                detail.parentTaskId = model.task_id;
            }else{// 主任务
                detail.taskType = 0;
            }
        }
        // 关联时用quoteTaskId，不用taskInfoId
//        detail.dataId = model.taskInfoId;
//        detail.dataId = model.quoteTaskId;
        detail.dataId = model.bean_id;
        detail.action = ^(id parameter) {
            
        };
        detail.deleteAction = ^{
        };
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if ([model.dataType isEqualToNumber:@3]){
        
        //        TFCustomDetailController *detail = [[TFCustomDetailController alloc] init];
        TFNewCustomDetailController *detail = [[TFNewCustomDetailController alloc] init];
        detail.bean = model.bean_name;
        detail.dataId = model.bean_id;
        [self.navigationController pushViewController:detail animated:YES];
        
    }else{
        TFApprovalListItemModel *approval = [[TFApprovalListItemModel alloc] init];
        approval.id = model.id;
        approval.task_id = [model.task_id description];
        approval.task_key = model.task_key;
        approval.task_name = model.task_name;
//        approval.approval_data_id = model.approval_data_id;
        approval.approval_data_id = [model.bean_id description];
        approval.module_bean = model.module_bean;
        approval.begin_user_name = model.begin_user_name;
        approval.begin_user_id = model.begin_user_id;
        approval.process_definition_id = model.process_definition_id;
        approval.process_key = model.process_key;
        approval.process_name = model.process_name;
        approval.process_status = model.process_status;
        approval.status = model.status;
        approval.process_field_v = model.process_field_v;
        
        TFApprovalDetailController *detail = [[TFApprovalDetailController alloc] init];
        detail.approvalItem = approval;
        detail.listType = 1;
        [self.navigationController pushViewController:detail animated:YES];
        
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFProjectSectionModel *model = self.relations[indexPath.section];
    TFProjectRowModel *row = model.tasks[indexPath.row];
    
    /** (数据类型 1备忘录 2任务 3自定义模块数据 4审批数据) */
    if ([row.dataType isEqualToNumber:@2]) {// 任务
        return [row.cellHeight floatValue];
    }else{
        TFProjectRowFrameModel *frame = model.frames[indexPath.row];
        return frame.cellHeight;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    TFProjectSectionModel *model = self.relations[section];
    if (self.quoteAuth) {
        if ([model.select isEqualToNumber:@1]) {
            return 48;
        }else{
            return 48 + 36;
        }
    }else{
        return 48;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TFProjectSectionModel *model = self.relations[section];
    
    if (self.quoteAuth) {
        UIView *view1 = [[UIView alloc] init];
        view1.backgroundColor = WhiteColor;
        
        TFColumnView *view = [TFColumnView columnView];
        view.tag = section;
        view.titleLebel.text = model.name;
        view.isSpread = [model.select isEqualToNumber:@1] ? @"1" : @"0";
        view.delegate = self;
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 48);
        [view1 addSubview:view];
        
        if (![model.select isEqualToNumber:@1]) {
            UIView *view2 = [[UIView alloc] init];
            view2.backgroundColor = WhiteColor;
            view2.frame = CGRectMake(0, 48, SCREEN_WIDTH, 36);
            [view1 addSubview:view2];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            [btn setTitle:@" 引用" forState:UIControlStateNormal];
            [btn setImage:IMG(@"task引用") forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, 80, 36);
            btn.tag = 0x1111 * section;
            [btn addTarget:self action:@selector(quoteClicked:) forControlEvents:UIControlEventTouchUpInside];
            [view2 addSubview:btn];
            
            /** (数据类型 1备忘录 2任务 3自定义模块数据 4审批数据 5邮件) */
            if ([model.dataType integerValue] != 2) {
                UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
                [btn1 setTitle:@" 新建" forState:UIControlStateNormal];
                [btn1 setImage:IMG(@"task新增") forState:UIControlStateNormal];
                btn1.frame = CGRectMake(80, 0, 80, 36);
                btn1.tag = 0x1111 * section;
                [btn1 addTarget:self action:@selector(addClicked:) forControlEvents:UIControlEventTouchUpInside];
                [view2 addSubview:btn1];
            }
        }
        
        return view1;
    }else{
        TFColumnView *view = [TFColumnView columnView];
        view.tag = section;
        view.titleLebel.text = model.name;
        view.isSpread = [model.select isEqualToNumber:@1] ? @"1" : @"0";
        view.delegate = self;
        return view;
    }
    
}
-(void)quoteClicked:(UIButton *)btn{
    
    
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
    
    NSInteger section = btn.tag / 0x1111;
    TFProjectSectionModel *model = self.relations[section];
    
    /** (数据类型 1备忘录 2任务 3自定义模块数据 4审批数据 5邮件) */
    if ([model.dataType integerValue] == 4) {// 审批
        
        // 判断是否有权限
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[TFRequest sharedManager] requestGET:[self.projectTaskBL urlFromCmd:HQCMD_customModuleAuth] parameters:@{@"bean":model.module_bean} progress:nil success:^(NSDictionary *response) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSArray *arr = [response valueForKey:kData];
            if (arr.count) {
                
                TFApprovalListController *vc = [[TFApprovalListController alloc] init];
                vc.quote = YES;
                vc.type = @4;
                TFModuleModel *module = [[TFModuleModel alloc] init];
                module.id = model.module_id;
                module.application_id = model.application_id;
                module.english_name = model.module_bean;
                module.chinese_name = model.name;
                vc.module = module;
                vc.refreshAction = ^(NSMutableDictionary *data) {
                    
                    NSString *str = [data valueForKey:@"data"];
                    
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    
                    [dict setObject:@4 forKey:@"bean_type"];
                    [dict setObject:module.english_name forKey:@"bean"];
                    [dict setObject:module.chinese_name forKey:@"moduleName"];
                    [dict setObject:module.id forKey:@"moduleId"];
                    [dict setObject:@"approval" forKey:@"approval"];
                    
                    if (self.taskType == 0 || self.taskType == 1) {
                        
                        [dict setObject:self.dataId forKey:@"taskId"];
                        [dict setObject:str forKey:@"quoteTaskId"];
                        [dict setObject:self.projectId forKey:@"projectId"];
                        if (self.taskType == 0) {
                            [dict setObject:@1 forKey:@"taskType"];
                        }else{
                            [dict setObject:@2 forKey:@"taskType"];
                        }
                        
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [self.projectTaskBL requestQuoteTaskRelationWithDict:dict];
                        
                    }else{
                        
                        [dict setObject:str forKey:@"relation_id"];
                        
                        [dict setObject:module.english_name forKey:@"bean_name"];
                        
                        [dict setObject:module.id forKey:@"module_id"];
                        
                        [dict setObject:module.chinese_name forKey:@"module_name"];
                        
                        [dict setObject:self.dataId forKey:@"task_id"];
                        if (self.taskType == 2) {
                            [dict setObject:@0 forKey:@"from_type"];
                        }else{
                            [dict setObject:@1 forKey:@"from_type"];
                        }
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [self.projectTaskBL requestPersonnelTaskQuotePersonnelTaskWithDict:dict];
                        
                    }
                };
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [MBProgressHUD showError:@"无权限" toView:self.view];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }
    else if ([model.dataType integerValue] == 1){// 备忘录
        
        TFSelectMemoListController *memo = [[TFSelectMemoListController alloc] init];
        memo.parameterAction = ^(NSArray *parameter) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"memo" forKey:@"bean"];
            NSString *ids = @"";
            for (TFNoteDataListModel *mo in parameter) {
                ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%@,",[mo.id description]]];
            }
            if (ids.length) {
                ids = [ids substringToIndex:ids.length-1];
            }
            
            [dict setObject:@1 forKey:@"bean_type"];
            
            if (self.taskType == 0 || self.taskType == 1) {
                
                [dict setObject:self.dataId forKey:@"taskId"];
                [dict setObject:ids forKey:@"quoteTaskId"];
                [dict setObject:self.projectId forKey:@"projectId"];
                if (self.taskType == 0) {
                    [dict setObject:@1 forKey:@"taskType"];
                }else{
                    [dict setObject:@2 forKey:@"taskType"];
                }
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestQuoteTaskRelationWithDict:dict];
                
            }else{
                
                [dict setObject:ids forKey:@"relation_id"];
                
                [dict setObject:self.dataId forKey:@"task_id"];
                if (self.taskType == 2) {
                    [dict setObject:@0 forKey:@"from_type"];
                }else{
                    [dict setObject:@1 forKey:@"from_type"];
                }
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestPersonnelTaskQuotePersonnelTaskWithDict:dict];
                
            }
        };
        [self.navigationController pushViewController:memo animated:YES];
    }
    else if ([model.dataType integerValue] == 3){// 自定义
        
        
        // 判断是否有权限
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[TFRequest sharedManager] requestGET:[self.projectTaskBL urlFromCmd:HQCMD_customModuleAuth] parameters:@{@"bean":model.module_bean} progress:nil success:^(NSDictionary *response) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSArray *arr = [response valueForKey:kData];
            if (arr.count) {
                
                TFSelectCustomListController *custom = [[TFSelectCustomListController alloc] init];
                TFModuleModel *module = [[TFModuleModel alloc] init];
                module.id = model.module_id;
                module.application_id = model.application_id;
                module.english_name = model.module_bean;
                module.chinese_name = model.name;
                custom.module = module;
                custom.parameterAction = ^(id parameter) {
                    
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:@3 forKey:@"bean_type"];
                    [dict setObject:module.english_name forKey:@"bean"];
                    [dict setObject:module.id forKey:@"moduleId"];
                    [dict setObject:module.chinese_name forKey:@"moduleName"];
                    
                    NSString *str = @"";
                    for (TFCustomListItemModel *item in parameter) {
                        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[item.id value]]];
                    }
                    if (str.length) {
                        str = [str substringToIndex:str.length-1];
                    }
                    
                    if (self.taskType == 0 || self.taskType == 1) {
                        
                        [dict setObject:self.dataId forKey:@"taskId"];
                        [dict setObject:str forKey:@"quoteTaskId"];
                        [dict setObject:self.projectId forKey:@"projectId"];
                        if (self.taskType == 0) {
                            [dict setObject:@1 forKey:@"taskType"];
                        }else{
                            [dict setObject:@2 forKey:@"taskType"];
                        }
                        
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [self.projectTaskBL requestQuoteTaskRelationWithDict:dict];
                        
                    }else{
                        
                        [dict setObject:str forKey:@"relation_id"];
                        
                        [dict setObject:module.english_name forKey:@"bean_name"];
                        
                        [dict setObject:module.id forKey:@"module_id"];
                        
                        [dict setObject:module.chinese_name forKey:@"module_name"];
                        
                        [dict setObject:self.dataId forKey:@"task_id"];
                        if (self.taskType == 2) {
                            [dict setObject:@0 forKey:@"from_type"];
                        }else{
                            [dict setObject:@1 forKey:@"from_type"];
                        }
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [self.projectTaskBL requestPersonnelTaskQuotePersonnelTaskWithDict:dict];
                        
                    }
                };
                [self.navigationController pushViewController:custom animated:YES];
            }else{
                [MBProgressHUD showError:@"无权限" toView:self.view];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }
    else if ([model.dataType integerValue] == 2){// 任务
        
        
        TFSelectTaskListController *task = [[TFSelectTaskListController alloc] init];
        task.projectId = self.projectId;
        task.parameterAction = ^(NSArray *parameter) {
            
            NSString *str = @"";
            for (TFQuoteTaskItemModel *model in parameter) {
                
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",model.id]];
                
            }
            
            if (str.length) {
                str = [str substringToIndex:str.length-1];
            }
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            TFQuoteTaskItemModel *first = parameter.firstObject;
            
            //                    if (first.project_id && ![first.project_id isEqualToNumber:@0]) {
            if ([first.bean_name containsString:@"project_custom_"]) {// 项目任务
                [dict setObject:@2 forKey:@"beanType"];
                [dict setObject:[first.bean_name stringByReplacingOccurrencesOfString:@"project_custom_" withString:@""] forKey:@"projectId"];
            }else{
                [dict setObject:@5 forKey:@"bean_type"];
            }
            if ([self.projectId isEqualToNumber:@0] || !self.projectId) {
                [dict setObject: [NSString stringWithFormat:@"project_custom"] forKey:@"bean"];
            }else{
                [dict setObject:first.bean_name forKey:@"bean"];
            }
            
            if (self.taskType == 0 || self.taskType == 1) {
                
                [dict setObject:self.dataId forKey:@"taskId"];
                [dict setObject:str forKey:@"quoteTaskId"];
                [dict setObject:self.projectId forKey:@"projectId"];
                if (self.taskType == 0) {
                    [dict setObject:@1 forKey:@"taskType"];
                }else{
                    [dict setObject:@2 forKey:@"taskType"];
                }
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestQuoteTaskRelationWithDict:dict];
                
            }else{
                
                [dict setObject:str forKey:@"relation_id"];
                
                [dict setObject: [NSString stringWithFormat:@"project_custom"] forKey:@"bean"];
                
                [dict setObject:self.dataId forKey:@"task_id"];
                if (self.taskType == 2) {
                    [dict setObject:@0 forKey:@"from_type"];
                }else{
                    [dict setObject:@1 forKey:@"from_type"];
                }
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestPersonnelTaskQuotePersonnelTaskWithDict:dict];
                
            }
        };
        [self.navigationController pushViewController:task animated:YES];
        
    }
    
}
-(void)addClicked:(UIButton *)btn{
    
    
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
    
    NSInteger section = btn.tag / 0x1111;
    TFProjectSectionModel *model = self.relations[section];
    
    /** (数据类型 1备忘录 2任务 3自定义模块数据 4审批数据 5邮件) */
    if ([model.dataType integerValue] == 4) {// 审批
        
        // 判断是否有权限
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[TFRequest sharedManager] requestGET:[self.projectTaskBL urlFromCmd:HQCMD_customModuleAuth] parameters:@{@"bean":model.module_bean} progress:nil success:^(NSDictionary *response) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSArray *arr = [response valueForKey:kData];
            
            if (arr.count) {
                
                BOOL have = NO;
                for (NSDictionary *dict in arr) {
                    if ([[dict valueForKey:@"auth_code"] integerValue] == 1) {
                        have = YES;
                        break;
                    }
                }
                if (have) {
                    
                    TFAddCustomController *add = [[TFAddCustomController alloc] init];
                    add.bean = model.module_bean;
                    add.moduleId = model.module_id;
                    add.tableViewHeight = SCREEN_HEIGHT - NaviHeight;
                    add.taskBlock = ^(NSMutableDictionary *dict) {
                        
                        [dict setObject:@4 forKey:@"bean_type"];
                        [dict setObject:model.module_bean forKey:@"bean"];
                        [dict setObject:model.name forKey:@"moduleName"];
                        [dict setObject:model.module_id forKey:@"moduleId"];
                        [dict setObject:@"approval" forKey:@"approval"];
                        
                        NSString *str = [dict valueForKey:@"data"];
                        
                        if (self.taskType == 0 || self.taskType == 1) {
                            
                            [dict setObject:self.dataId forKey:@"taskId"];
                            [dict setObject:str forKey:@"quoteTaskId"];
                            [dict setObject:self.projectId forKey:@"projectId"];
                            if (self.taskType == 0) {
                                [dict setObject:@1 forKey:@"taskType"];
                            }else{
                                [dict setObject:@2 forKey:@"taskType"];
                            }
                            
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestQuoteTaskRelationWithDict:dict];
                            
                        }else{
                            
                            [dict setObject:str forKey:@"relation_id"];
                            
                            [dict setObject:model.module_bean forKey:@"bean_name"];
                            
                            [dict setObject:model.module_id forKey:@"module_id"];
                            
                            [dict setObject:model.name forKey:@"module_name"];
                            
                            [dict setObject:self.dataId forKey:@"task_id"];
                            if (self.taskType == 2) {
                                [dict setObject:@0 forKey:@"from_type"];
                            }else{
                                [dict setObject:@1 forKey:@"from_type"];
                            }
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestPersonnelTaskQuotePersonnelTaskWithDict:dict];
                            
                        }
                    };
                    [self.navigationController pushViewController:add animated:YES];
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
                
            }else{
                [MBProgressHUD showError:@"无权限" toView:self.view];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
        
    }
    else if ([model.dataType integerValue] == 1){// 备忘录
        
        TFCreateNoteController *create = [[TFCreateNoteController alloc] init];
        create.type = 0;
        create.dataAction = ^(NSDictionary *parameter) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"memo" forKey:@"bean"];
            NSString *ids = [[parameter valueForKey:@"dataId"] description];
            
            [dict setObject:@1 forKey:@"bean_type"];
            
            if (self.taskType == 0 || self.taskType == 1) {
                
                [dict setObject:self.dataId forKey:@"taskId"];
                [dict setObject:ids forKey:@"quoteTaskId"];
                [dict setObject:self.projectId forKey:@"projectId"];
                if (self.taskType == 0) {
                    [dict setObject:@1 forKey:@"taskType"];
                }else{
                    [dict setObject:@2 forKey:@"taskType"];
                }
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestQuoteTaskRelationWithDict:dict];
                
            }else{
                
                [dict setObject:ids forKey:@"relation_id"];
                
                [dict setObject:self.dataId forKey:@"task_id"];
                if (self.taskType == 2) {
                    [dict setObject:@0 forKey:@"from_type"];
                }else{
                    [dict setObject:@1 forKey:@"from_type"];
                }
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestPersonnelTaskQuotePersonnelTaskWithDict:dict];
                
            }
            
        };
        [self.navigationController pushViewController:create animated:YES];
        
    }
    else if ([model.dataType integerValue] == 3){// 自定义
        
        // 判断是否有权限
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[TFRequest sharedManager] requestGET:[self.projectTaskBL urlFromCmd:HQCMD_customModuleAuth] parameters:@{@"bean":model.module_bean} progress:nil success:^(NSDictionary *response) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSArray *arr = [response valueForKey:kData];
            if (arr.count) {
                
                BOOL have = NO;
                for (NSDictionary *dict in arr) {
                    if ([[dict valueForKey:@"auth_code"] integerValue] == 1) {
                        have = YES;
                        break;
                    }
                }
                if (have) {
                    
                    TFAddCustomController *add = [[TFAddCustomController alloc] init];
                    add.bean = model.module_bean;
                    add.moduleId = model.module_id;
                    add.tableViewHeight = SCREEN_HEIGHT - 64;
                    add.customBlock = ^(NSMutableDictionary *data) {
                        
                        
                        NSString *str = [data valueForKey:@"data"];
                        
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:@3 forKey:@"bean_type"];
                        [dict setObject:model.module_bean forKey:@"bean"];
                        [dict setObject:model.module_id forKey:@"moduleId"];
                        [dict setObject:model.name forKey:@"moduleName"];
                        
                        if (self.taskType == 0 || self.taskType == 1) {
                            
                            [dict setObject:self.dataId forKey:@"taskId"];
                            [dict setObject:str forKey:@"quoteTaskId"];
                            [dict setObject:self.projectId forKey:@"projectId"];
                            if (self.taskType == 0) {
                                [dict setObject:@1 forKey:@"taskType"];
                            }else{
                                [dict setObject:@2 forKey:@"taskType"];
                            }
                            
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestQuoteTaskRelationWithDict:dict];
                            
                        }else{
                            
                            [dict setObject:str forKey:@"relation_id"];
                            
                            [dict setObject:model.module_bean forKey:@"bean_name"];
                            
                            [dict setObject:model.module_id forKey:@"module_id"];
                            
                            [dict setObject:model.name forKey:@"module_name"];
                            
                            [dict setObject:self.dataId forKey:@"task_id"];
                            if (self.taskType == 2) {
                                [dict setObject:@0 forKey:@"from_type"];
                            }else{
                                [dict setObject:@1 forKey:@"from_type"];
                            }
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestPersonnelTaskQuotePersonnelTaskWithDict:dict];
                            
                        }
                        
                    };
                    [self.navigationController pushViewController:add animated:YES];
                }else{
                    
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
                
            }else{
                [MBProgressHUD showError:@"无权限" toView:self.view];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
        
    }
    
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


#pragma mark - TFColumnViewDelegate
-(void)columnView:(TFColumnView *)columnView isSpread:(NSString *)isSpread{

    TFProjectSectionModel *model = self.relations[columnView.tag];
    model.select = [isSpread isEqualToString:@"1"] ? @1 : @0;
    [self.tableView reloadData];
    
}

#pragma mark - TFNewProjectTaskItemCellDelegate
-(void)projectTaskItemCellDidClickedClearBtn:(TFNewProjectTaskItemCell *)cell{
    [self clearItem:cell];
}
#pragma mark - TFProjectNoteCellDelegate
-(void)projectNoteCellDidClickedClearBtn:(TFProjectNoteCell *)cell{
    [self clearItem:cell];
}
#pragma mark - TFNewProjectCustomCellDelegate
-(void)newProjectCustomCellDidClickedClearBtn:(TFNewProjectCustomCell *)cell{
    [self clearItem:cell];
}
#pragma mark - TFProjectApprovalCellDelegate
-(void)projectApprovalCellDidClickedClearBtn:(TFProjectApprovalCell *)cell{
    [self clearItem:cell];
}

-(void)clearItem:(UITableViewCell *)cell{
    
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
    NSInteger section = cell.tag / 0x1111;
    TFProjectSectionModel *model = self.relations[section];
    self.longPressModel = model;
    self.longPressTaskIndex = cell.tag % 0x1111;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认取消该关联吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    alert.tag = 0x99;
    [alert show];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0x99) {
        
        if (buttonIndex == 1) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            TFProjectRowModel *rowModel = self.longPressModel.tasks[self.longPressTaskIndex];
            if (self.taskType == 0 || self.taskType == 1) {// 个人任务与项目任务取值字段不一样
//                [self.projectTaskBL requestCancelTaskRelationWithDataId:rowModel.taskInfoId];
                [self.projectTaskBL requestCancelTaskRelationWithDataId:rowModel.quote_id];
            }else{
//                [self.projectTaskBL requestCancelPersonnelTaskRelationWithDataId:rowModel.associatesTaskInfoId fromType:self.taskType == 2 ? @0 : @1 taskId:rowModel.id];
                [self.projectTaskBL requestCancelPersonnelTaskRelationWithDataId:rowModel.quote_id fromType:self.taskType == 2 ? @0 : @1 taskId:rowModel.bean_id];
            }
            
        }
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getFuncAuthWithCommunal) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dict = resp.body;
        
        NSNumber *authStr = [dict valueForKey:@"readAuth"];
        if ([authStr isEqualToNumber:@0]) {
            
            [MBProgressHUD showError:@"无权查看或数据已删除！" toView:self.view];
            return;
        }
        else if ([authStr isEqualToNumber:@1]) {
            
            [self taskRelationListDidClickedModel:self.selectTask];
        }
        else if ([authStr isEqualToNumber:@2]) {
            
            [MBProgressHUD showError:@"无权查看或数据已删除！" toView:self.view];
            return;
        }
        else if ([authStr isEqualToNumber:@3]) {
            
            [MBProgressHUD showError:@"无权查看或数据已删除！" toView:self.view];
            return;
        }
        
    }
    
    if (resp.cmdId == HQCMD_cancelTaskRelation || resp.cmdId == HQCMD_cancelPersonnelTaskRelation) {// 取消任务关联
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.longPressModel.frames removeObjectAtIndex:self.longPressTaskIndex];
        [self.longPressModel.tasks removeObjectAtIndex:self.longPressTaskIndex];
        
        [self.tableView reloadData];
        if (self.refresh) {
            self.refresh();
        }
    }
    // 引用成功
    if (resp.cmdId == HQCMD_quoteTaskRelation || resp.cmdId == HQCMD_personnelTaskQuotePersonnelTask) {
        
        if (self.taskType == 0) {
            [self.projectTaskBL requestGetTaskRelationListWithTaskId:self.dataId taskType:@1];// 获取任务关联列表
        }else if (self.taskType == 1){
            [self.projectTaskBL requestGetTaskRelationListWithTaskId:self.dataId taskType:@2];// 获取子任务关联列表
        }else if (self.taskType == 2){
            [self.projectTaskBL requestPersonnelTaskRelationListWithTaskId:self.dataId fromType:@0];// 关联列表
        }else{
            [self.projectTaskBL requestPersonnelTaskRelationListWithTaskId:self.dataId fromType:@1];// 关联列表
        }
        
    }
    
    if (resp.cmdId == HQCMD_getTaskRelation || resp.cmdId == HQCMD_personnelTaskRelationList) {// 项目任务 or 个人任务  关联
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        // 关联数组
        [self.relations removeAllObjects];
        NSArray *relationArr = resp.body;
        
        for (NSDictionary *secDict in relationArr) {
            
            TFProjectSectionModel *sec = [[TFProjectSectionModel alloc] init];
            sec.name = [secDict valueForKey:@"module_name"];
            sec.module_bean = [secDict valueForKey:@"beanName"];
            sec.module_id = [secDict valueForKey:@"module_id"];
            sec.application_id = [secDict valueForKey:@"application_id"];
            sec.dataType = [secDict valueForKey:@"dataType"];
            NSMutableArray<TFProjectRowModel,Optional>*tasks = [NSMutableArray<TFProjectRowModel,Optional> array];
            NSMutableArray *frames = [NSMutableArray array];
            for (NSDictionary *taskDict in [secDict valueForKey:@"moduleDataList"]) {
                
                /** (数据类型 1备忘录 2任务 3自定义模块数据 4审批数据 5邮件) */
                TFProjectRowModel *task = [HQHelper projectRowWithTaskDict:taskDict];
                
                [tasks addObject:task];
                if ([task.dataType isEqualToNumber:@2]) {// 任务
                    task.cellHeight = @([TFNewProjectTaskItemCell refreshNewProjectTaskItemCellHeightWithModel:task haveClear:self.cancelAuth]);
                }
                
                TFProjectRowFrameModel *frame = nil;
                if (self.quoteAuth) {
                    frame = [[TFProjectRowFrameModel alloc] init];
                }else{
                    frame = [[TFProjectRowFrameModel alloc] initBorder];;
                }
                frame.projectRow = task;
                [frames addObject:frame];
                
            }
            sec.tasks = tasks;
            sec.frames = frames;
            [self.relations addObject:sec];
            if (self.refresh) {
                self.refresh();
            }
        }
        if (self.relations.count == 0) {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
