//
//  TFProjectTaskDetailController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectTaskDetailController.h"
#import "TFRemainTimeController.h"
#import "TFTaskRepeatController.h"
#import "TFMoveTaskController.h"
#import "TFTImageLabelImageCell.h"
#import "HQTFTaskDetailTitleCell.h"
#import "TFImgDoubleLalImgCell.h"
#import "TFTwoBtnsView.h"
#import "TFCustomerCommentController.h"
#import "TFCustomerDynamicController.h"
#import "TFHeartPeopleListController.h"
#import "TFSelectPeopleCell.h"
#import "HQSwitchCell.h"
#import "TFChildTaskListCell.h"
#import "TFTaskRelationListCell.h"
#import "TFProjectRowModel.h"
#import "TFProjectSectionModel.h"
#import "TFProjectRowFrameModel.h"
#import "TFCustomerLayoutModel.h"
#import "HQTFInputCell.h"
#import "HQSelectTimeCell.h"
#import "HQAreaManager.h"
#import "TFSingleTextCell.h"
#import "TFManyLableCell.h"
#import "TFFileElementCell.h"
#import "TFCustomOptionCell.h"
#import "TFSubformHeadCell.h"
#import "TFCreateChildTaskController.h"
#import "TFProjectTaskBL.h"
#import "TFChangeHelper.h"
#import "TFCustomBL.h"
#import "TFCustomBaseModel.h"
#import "TFMapController.h"
#import "HQTFThreeLabelCell.h"
#import "TFModelEnterController.h"
#import "TFFourBtnCell.h"
#import "TFAttributeTextCell.h"
#import "TFCooperationPeopleController.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFProjectPeopleModel.h"
#import "TFAddTaskController.h"
#import "TFDynamicsTableView.h"
#import "TFCommentTableView.h"
#import "IQKeyboardManager.h"
#import "TFPlayVoiceController.h"
#import "KSPhotoBrowser.h"
#import "JCHATToolBar.h"
#import "JCHATMoreView.h"
#import "XHVoiceRecordHUD.h"
#import "XHVoiceRecordHelper.h"
#import "ZYQAssetPickerController.h"
#import "TFFileMenuController.h"
#import "TFFolderListModel.h"
#import "TFCustomerCommentModel.h"
#import "TFStatusTableView.h"
#import "FileManager.h"
#import "MWPhotoBrowser.h"
#import "TFGeneralSingleCell.h"
#import "TFCustomSelectOptionCell.h"
#import "TFScanCodeController.h"
#import "StyleDIY.h"
#import "TFCustomAttachmentsCell.h"
#import "TFCustomMultiSelectCell.h"
#import "TFCustomAlertView.h"
#import "TFTCustomSubformHeaderCell.h"
#import "TFCustomImageCell.h"
#import "TFCustomAttributeTextCell.h"
#import "TFColumnView.h"
#import "TFSubformSectionView.h"
#import "TFSubformAddView.h"
#import "TFProjectModel.h"
#import "TFNewMoveTaskController.h"
#import "TFCreateNoteController.h"
#import "TFNewCustomDetailController.h"
#import "TFNewCustomDetailController.h"
#import "TFApprovalDetailController.h"
#import "TFProjectDetailTabBarController.h"
#import "TFCustomSearchController.h"
#import "TFEmailsNewController.h"
#import "TFChangeHelper.h"
#import "TFTaskDetailHandleCell.h"
#import "TFTaskDetailCheckCell.h"
#import "TFTaskDetailCheckPeopleCell.h"
#import "TFTaskDetailCooperationCell.h"
#import "TFTaskDetailCooperationPeopleCell.h"
#import "TFTaskDetailLabelCell.h"
#import "TFTaskDetailDescCell.h"
#import "TFProjectMenberManageController.h"
#import "TFSelectDateView.h"
#import "TFTaskDetailStatusCell.h"
#import "TFSelectOptionController.h"
#import "HQTFProjectDescController.h"
#import "TFTaskPriorityView.h"
#import "TFTaskDetailFileCell.h"
#import "TFAllDynamicView.h"
#import "PopoverView.h"
#import "HQNotPassSubmitView.h"
#import "TFAttributeTextController.h"
#import "TFAllDataView.h"
#import "TFCustomerDynamicModel.h"
#import "TFTaskHybirdDynamicModel.h"
#import "TFAgainMoveTaskController.h"
#import "TFTaskDetailRelationCell.h"
#import "TFPersonnelTaskRelationController.h"
#import "TFTaskQuoteListController.h"
#import "TFChildTaskListController.h"
#import "TFSelectStatusController.h"

@interface TFProjectTaskDetailController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate,TFTwoBtnsViewDelegate,HQSwitchCellDelegate,TFTaskRelationListCellDelegate,TFChildTaskListCellDelegate,HQBLDelegate,HQTFTaskDetailTitleCellDelegate,TFImgDoubleLalImgCellDelegate,TFAttributeTextCellDelegate,TFDynamicsTableViewDelegate,TFCommentTableViewDelegate,LiuqsEmotionKeyBoardDelegate,KSPhotoBrowserDelegate,ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TFStatusTableViewDelegate,TFFileElementCellDelegate,MWPhotoBrowserDelegate,UIDocumentInteractionControllerDelegate,TFGeneralSingleCellDelegate,TFCustomSelectOptionCellDelegate,TFCustomAttachmentsCellDelegate,TFCustomAlertViewDelegate,TFCustomImageCellDelegate,TFCustomAttributeTextCellDelegate,TFColumnViewDelegate,TFSubformSectionViewDelegate,TFSubformAddViewDelegate,TFTImageLabelImageCellDelegate,TFTaskDetailHandleCellDelegate,TFTaskDetailCheckCellDelegate,TFTaskDetailDescCellDelegate,TFTaskDetailFileCellDelegate,TFAllDynamicViewDelegate,TFTaskDetailCooperationCellDelegate,TFAllDataViewDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** layouts */
@property (nonatomic, strong) NSMutableArray *layouts;

/** associates 协作人 */
@property (nonatomic, strong) NSMutableArray *associates;

/** 点赞人s */
@property (nonatomic, strong) NSMutableArray *peoples;

/** 子任务s */
@property (nonatomic, strong) NSMutableArray *childTasks;
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

/** 关联s */
@property (nonatomic, strong) NSMutableArray *relations;
/** 被关联s */
@property (nonatomic, strong) NSMutableArray *byRelations;

/** HQAreaManager */
@property (nonatomic, strong) HQAreaManager *areaManager;

/** longPressModel */
@property (nonatomic, strong) TFProjectSectionModel *longPressModel;
/** longPressTaskIndex */
@property (nonatomic, assign) NSInteger longPressTaskIndex;

/** relevances */
@property (nonatomic, strong) NSMutableArray *relevances;

/** HQEmployModel *emp */
@property (nonatomic, strong) HQEmployModel *employ;

/** 校验人 */
@property (nonatomic, assign) BOOL checkShow;
/** 协作人可见 */
@property (nonatomic, assign) BOOL coopShow;
/** childShow */
@property (nonatomic, assign) BOOL childShow;
/** relationShow */
@property (nonatomic, assign) BOOL relationShow;
/** beRelatedShow */
@property (nonatomic, assign) BOOL beRelatedShow;
/** type  */
@property (nonatomic, assign) NSInteger type;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;
/** TFCustomBL */
@property (nonatomic, strong) TFCustomBL *customBL;

/** customModel */
@property (nonatomic, strong) TFCustomBaseModel *customModel;

/** detailDict */
@property (nonatomic, strong) NSMutableDictionary *detailDict;
/** 项目状态 */
@property (nonatomic, copy) NSString *project_status;

/** 任务层级名称 */
@property (nonatomic, copy) NSString *taskHierarchy;
/** 任务名称 */
@property (nonatomic, copy) NSString *taskName;

/** 执行人 */
@property (nonatomic, strong) HQEmployModel *employee;
@property (nonatomic, assign) long long startTime;
@property (nonatomic, assign) long long endTime;
/** 校验人 */
@property (nonatomic, strong) HQEmployModel *checkPeople;
/** 描述文字 */
@property (nonatomic, copy) NSString *descString;
/** 描述文件高度 */
@property (nonatomic, assign) CGFloat descHeight;
/** 任务状态： 0：未开始 1：进行中 2：暂停 3：已完成 */
@property (nonatomic, assign) NSInteger taskOpen;
/** 任务优先级： 0：普通 1：紧急 2：非常紧急 */
@property (nonatomic, assign) NSInteger taskPriority;
/** 标记上传附件还是评论中操作 */
@property (nonatomic, assign) BOOL isFile;

/** time */
@property (nonatomic, copy) NSString *time;

/** childTaskModel */
@property (nonatomic, strong) TFProjectRowModel *childTaskModel;

/** privilege */
@property (nonatomic, copy) NSString *privilege;

/** 任务角色权限列表 */
@property (nonatomic, strong) NSArray *taskRoleAuths;

/** role */
@property (nonatomic, copy) NSString *role;

/** 菜单数组 */
@property (nonatomic, strong) NSMutableArray *menus;

/** 动态 */
@property (nonatomic, strong) TFDynamicsTableView *dynamicsTable;

/** 评论 */
@property (nonatomic, strong) TFCommentTableView *commentTable;
/** 所有数据 */
@property (nonatomic, strong) TFAllDataView *allDataView;

/** 查看 */
@property (nonatomic, strong) TFStatusTableView *statusTable;

/** bottomBtns */
@property (nonatomic, strong) NSArray *bottomBtns;
/** buttons */
@property (nonatomic, strong) NSMutableArray *buttons;

@property(nonatomic, strong) LiuqsEmoticonKeyBoard *keyboard;

/** commentTabBar */
@property (nonatomic, strong) TFAllDynamicView *commentTabBar;
/** selectIndex */
@property (nonatomic, assign) NSInteger selectIndex;

/** model */
@property (nonatomic, strong) TFCustomerCommentModel *commentModel;

/** jump */
@property (nonatomic, assign) NSInteger jump;

/** 评论及动态的bean */
@property (nonatomic, copy) NSString *bean;

/** 评论数组 */
@property (nonatomic, strong) NSMutableArray *comments;
/** 动态数组 */
@property (nonatomic, strong) NSMutableArray *dynamics;
/** 查看数组 */
@property (nonatomic, strong) NSMutableArray *statuses;

/** checkIndex */
@property (nonatomic, assign) NSInteger checkIndex;

/** images 自定义图片 */
@property (nonatomic, strong) NSMutableArray *images;
/** 上传文件 */
@property (nonatomic, strong) NSMutableArray *files;

/** 添加附件及图片时对应的Model ,也用于记录子表单下拉对应的Model */
@property (nonatomic, strong) TFCustomerRowsModel *attachmentModel;

/** 激活是否需要填写激活原因 */
@property (nonatomic, copy) NSString <Optional>*project_complete_status;
/** 修改截止时间是否需要填写修改原因 */
@property (nonatomic, copy) NSString <Optional>*project_time_status;
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
@property (nonatomic, strong) TFCustomerRowsModel *fileRow;
@property (nonatomic, strong) TFCustomerRowsModel *tagRow;
@property (nonatomic, strong) TFCustomerRowsModel *priorityRow;
@property (nonatomic, strong) TFCustomerRowsModel *referenceRow;
@end

@implementation TFProjectTaskDetailController

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


-(NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}
-(NSMutableArray *)comments{
    if (!_comments) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}
-(NSMutableArray *)statuses{
    if (!_statuses) {
        _statuses = [NSMutableArray array];
    }
    return _statuses;
}

-(NSMutableArray *)dynamics{
    if (!_dynamics) {
        _dynamics = [NSMutableArray array];
    }
    return _dynamics;
}
-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
-(NSMutableArray *)menus{
    if (!_menus) {
        _menus = [NSMutableArray array];
    }
    return _menus;
}

-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}

-(NSMutableArray *)byRelations{
    if (!_byRelations) {
        _byRelations = [NSMutableArray array];
    }
    return _byRelations;
}

-(NSMutableArray *)associates{
    if (!_associates) {
        _associates = [NSMutableArray array];
    }
    return _associates;
}

-(NSMutableArray *)relations{
    if (!_relations) {
        _relations = [NSMutableArray array];
        
    }
    return _relations;
}

-(NSMutableArray *)childTasks{
    
    if (!_childTasks) {
        _childTasks = [NSMutableArray array];
        
    }
    return _childTasks;
}

-(HQAreaManager *)areaManager{
    if (!_areaManager) {
        _areaManager = [HQAreaManager defaultAreaManager];
    }
    return _areaManager;
}

-(NSMutableArray *)layouts{
    if (!_layouts) {
        _layouts = [NSMutableArray array];
    }
    return _layouts;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    IQKeyboardManager *keyBoard = [IQKeyboardManager sharedManager];
    keyBoard.enable = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    IQKeyboardManager *keyBoard = [IQKeyboardManager sharedManager];
    keyBoard.enable = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.childShow = YES;
    self.relationShow = YES;
    self.beRelatedShow = YES;
    
    if (self.taskType == 0) {
        self.bean = @"project_task_dynamic";
    }else if (self.taskType == 1){
        self.bean = @"project_sub_task_dynamic";
    }else if (self.taskType == 2){
        self.bean = @"personel_task";
    }else{
        self.bean = @"personel_sub_task";
    }
    
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    if (self.taskType == 0) {// 任务
        
        [self.projectTaskBL requestGetTaskDetailWithTaskId:self.dataId];// 任务详情
        if (self.nodeCode) {
            [self.projectTaskBL requestGetChildTaskListWithTaskId:self.dataId nodeCode:self.nodeCode];// 获取子任务列表
        }
        [self.projectTaskBL requestGetTaskRelationListWithTaskId:self.dataId taskType:@1];// 获取任务关联列表
        [self.projectTaskBL requestGetTaskRelatedListWithTaskId:self.dataId];// 获取任务被关联列表
        [self.customBL requestTaskLayoutWithBean:[NSString stringWithFormat:@"project_custom_%@",[self.projectId description]]];// 任务布局
        [self.projectTaskBL requsetTaskHierarchyWithTaskId:self.dataId];// 任务层级
        [self.projectTaskBL requestGetProjectTaskCooperationPeopleListWithProjectId:self.projectId taskId:self.dataId typeStatus:@1];// 协作人
        [self.projectTaskBL requestTaskHeartPeopleWithTaskId:self.dataId typeStatus:@1];// 点赞人员
        [self.projectTaskBL requestGetProjectRoleAndAuthWithProjectId:self.projectId employeeId:UM.userLoginInfo.employee.id];// 项目后台权限
        [self.projectTaskBL requestGetProjectTaskRoleWithProjectId:self.projectId taskId:self.dataId typeStatus:@1];// 项目任务角色
        [self.projectTaskBL requestGetRoleProjectTaskAuthWithProjectId:self.projectId];// 任务角色权限
        [self.projectTaskBL requestTaskHybirdDynamicWithTaskId:self.dataId taskType:@(self.taskType + 1) dynamicType:@0 pageSize:@10000];// 获取混合动态
        
    }else if (self.taskType == 1){// 子任务
        
        [self.projectTaskBL requestGetChildTaskDetailWithChildTaskId:self.dataId];// 子任务详情
        [self.projectTaskBL requestGetTaskRelationListWithTaskId:self.dataId taskType:@2];// 获取子任务关联列表
        if (self.nodeCode) {
            [self.projectTaskBL requestGetChildTaskListWithTaskId:self.dataId nodeCode:self.nodeCode];// 获取子任务列表
        }
        [self.projectTaskBL requestGetProjectTaskCooperationPeopleListWithProjectId:self.projectId taskId:self.dataId typeStatus:@2];// 协作人
        [self.customBL requestTaskLayoutWithBean:[NSString stringWithFormat:@"project_custom_%@",[self.projectId description]]];// 任务布局
        [self.projectTaskBL requestTaskHeartPeopleWithTaskId:self.dataId typeStatus:@2];// 点赞人员
        [self.projectTaskBL requestGetProjectRoleAndAuthWithProjectId:self.projectId employeeId:UM.userLoginInfo.employee.id];// 项目后台权限
        [self.projectTaskBL requestGetProjectTaskRoleWithProjectId:self.projectId taskId:self.dataId typeStatus:@2];// 项目任务角色
        [self.projectTaskBL requestGetRoleProjectTaskAuthWithProjectId:self.projectId];// 任务角色权限
        [self.projectTaskBL requestTaskHybirdDynamicWithTaskId:self.dataId taskType:@(self.taskType + 1) dynamicType:@0 pageSize:@10000];// 获取混合动态
    }else if (self.taskType == 2) {// 个人任务
        
        [self.projectTaskBL requestPersonnelTaskDetailWithTaskId:self.dataId];// 个人任务详情
        [self.customBL requestTaskLayoutWithBean:[NSString stringWithFormat:@"project_custom"]];// 个人任务布局
        [self.projectTaskBL requestGetPersonnelChildTaskListWithTaskId:self.dataId];// 个人任务子任务列表
        [self.projectTaskBL requestGetPersonnelTaskCooperationPeopleListWithTaskId:self.dataId typeStatus:@0];// 协作人
        [self.projectTaskBL requestPersonnelTaskRelationListWithTaskId:self.dataId fromType:@0];// 关联列表
        [self.projectTaskBL requestPersonnelTaskByRelatedListWithTaskId:self.dataId];// 被关联列表
        [self.projectTaskBL requestPersonnelTaskHeartPeopleWithTaskId:self.dataId fromType:@0];// 点赞人员
        [self.projectTaskBL requestGetPersonnelTaskRoleWithTaskId:self.dataId typeStatus:@0];// 任务角色
        [self.projectTaskBL requestTaskHybirdDynamicWithTaskId:self.dataId taskType:@(self.taskType + 1) dynamicType:@0 pageSize:@10000];// 获取混合动态
        
    }else{// 个人任务子任务
        
        [self.projectTaskBL requestPersonnelSubTaskDetailWithTaskId:self.dataId];// 个人任务子任务详情
        [self.projectTaskBL requestGetPersonnelChildTaskListWithTaskId:self.dataId];// 个人任务子任务列表
        [self.customBL requestTaskLayoutWithBean:[NSString stringWithFormat:@"project_custom"]];// 个人任务布局
        [self.projectTaskBL requestGetPersonnelTaskCooperationPeopleListWithTaskId:self.dataId typeStatus:@1];// 协作人
        [self.projectTaskBL requestPersonnelTaskRelationListWithTaskId:self.dataId fromType:@1];// 关联列表
        [self.projectTaskBL requestPersonnelTaskHeartPeopleWithTaskId:self.dataId fromType:@1];// 点赞人员
        [self.projectTaskBL requestGetPersonnelTaskRoleWithTaskId:self.dataId typeStatus:@1];// 任务角色
        [self.projectTaskBL requestTaskHybirdDynamicWithTaskId:self.dataId taskType:@(self.taskType + 1) dynamicType:@0 pageSize:@10000];// 获取混合动态
        
    }
    
    self.type = 1;
    [self setupTableView];
    [self setupNavi];
//    [self setupBottom];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.tag = 0x5678;
    
}
#pragma mark - 处理自定义固定字段隐藏
-(void)handleLayoutFieldHidden{
    NSArray *names = @[@"text_name",@"picklist_tag",@"multitext_desc",@"personnel_principal",@"picklist_priority",@"attachment_customnumber",@"datetime_starttime",@"datetime_deadline",@"picklist_status",@"reference_relation"];
    NSMutableArray *layouts = [NSMutableArray array];
    for (TFCustomerLayoutModel *layout in self.layouts) {
        BOOL all = YES;
        NSMutableArray<TFCustomerRowsModel,Optional>  *rows = [NSMutableArray<TFCustomerRowsModel,Optional>  array];
        for (TFCustomerRowsModel *row in layout.rows) {
            if ([names containsObject:row.name]) {
                row.field.editView = @"1";
            }else{
                [rows addObject:row];
                all = NO;
            }
        }
        layout.rows = rows;
        if (all == NO) {
            [layouts addObject:layout];
        }
    }
    self.layouts = layouts;
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
   
    if (resp.cmdId == HQCMD_taskHybirdDynamic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.comments removeAllObjects];
        [self.comments addObjectsFromArray:resp.body];
        
        [self.commentTable refreshHybirdTableViewWithDatas:self.comments];
        
    }
    if (resp.cmdId == HQCMD_projectUpdateTask || resp.cmdId == HQCMD_projectUpdateSubTask || resp.cmdId == HQCMD_personnelTaskEdit || resp.cmdId == HQCMD_personnelSubTaskEdit || resp.cmdId == HQCMD_taskMoveToOther || resp.cmdId == HQCMD_taskCopyToOther) {// 编辑任务
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (resp.cmdId == HQCMD_taskMoveToOther) {
            if (self.taskType == 0) {
                [self.projectTaskBL requsetTaskHierarchyWithTaskId:self.dataId];// 任务层级
            }
        }
        // 刷新任务
        if (self.taskType == 0) {
            [self.projectTaskBL requestGetTaskDetailWithTaskId:self.dataId];// 任务详情
        }else if (self.taskType == 1){
            [self.projectTaskBL requestGetChildTaskDetailWithChildTaskId:self.dataId];// 子任务详情
        }else if (self.taskType == 2){
            [self.projectTaskBL requestPersonnelTaskDetailWithTaskId:self.dataId];// 个人任务详情
        }else{
            [self.projectTaskBL requestPersonnelSubTaskDetailWithTaskId:self.dataId];// 个人任务子任务详情
        }
        // 刷新动态
        [self.projectTaskBL requestTaskHybirdDynamicWithTaskId:self.dataId taskType:@(self.taskType + 1) dynamicType:@(self.selectIndex) pageSize:@10000];
        
        if (self.refresh) {
            self.refresh();
        }
    }
    if (resp.cmdId == HQCMD_getTaskDetail || resp.cmdId == HQCMD_getChildTaskDetail) {// 任务详情 or 子任务详情
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dict = resp.body;
        
        self.detailDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        self.project_status = [[dict valueForKey:@"project_status"] description];
        
        if (self.project_status && ![self.project_status isEqualToString:@"0"]) {
            if ([self.project_status isEqualToString:@"1"] || [self.project_status isEqualToString:@"2"]) {// 归档
                self.keyboard.hidden = YES;
            }
        }
        NSNumber *projectId = [self.detailDict valueForKey:@"project_id"];
        [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:projectId taskId:self.dataId taskType:@(self.taskType+1)];
        if (!self.nodeCode) {
            self.nodeCode = [self.detailDict valueForKey:@"node_code"];
            [self.projectTaskBL requestGetChildTaskListWithTaskId:self.dataId nodeCode:self.nodeCode];// 获取子任务列表
        }
        
        // 自定义数据
        if (self.customModel) {
            self.layouts = [self recombinationLayout:self.customModel];
            [self detailHandleWithDict:[self.detailDict valueForKey:@"customArr"]];
            // 自定义固定字段隐藏
            [self handleLayoutFieldHidden];
        }
        if (self.taskRoleAuths && self.role && self.privilege) {
            [self handleMenu];
        }
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
        
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_personnelTaskDetail || resp.cmdId == HQCMD_personnelSubTaskDetail) {// 个人任务详情 or 个人任务子任务详情
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dict = resp.body;
        self.detailDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        // 自定义数据
        if (self.customModel) {
            self.layouts = [self recombinationLayout:self.customModel];
            [self detailHandleWithDict:[self.detailDict valueForKey:@"customLayout"]];
            // 自定义固定字段隐藏
            [self handleLayoutFieldHidden];
        }
        
        if (self.role) {
            [self handlePersonnelMenu];
        }
        
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
            self.coopShow = [[[self.detailDict valueForKey:@"associates_status"] description] isEqualToString:@"1"]?YES:NO;
        }
        
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_getChildTaskList) {// 项目子任务列表
        
        // 子任务列表
        [self.childTasks removeAllObjects];
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
            
            [self.childTasks addObject:task];
            
        }
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_getPersonnelChildTaskList) {// 个人子任务列表
        
        // 子任务列表
        [self.childTasks removeAllObjects];
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
            
            [self.childTasks addObject:task];
            
        }
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_getTaskRelation || resp.cmdId == HQCMD_personnelTaskRelationList) {// 项目任务 or 个人任务  关联
        
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
                
                BOOL quoteAuth = NO;
                BOOL cancelAuth = NO;
                if (self.taskType == 0 || self.taskType == 1) {// 项目任务
                    
                    if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_12" role:self.role]) {
                        quoteAuth = YES;
                    }else{
                        quoteAuth = NO;
                    }
                    if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_13" role:self.role]) {
                        cancelAuth = YES;
                    }else{
                        cancelAuth = NO;
                    }
                }else{// 个人任务
                    if ([self.role isEqualToString:@"0"] || [self.role isEqualToString:@"1"]) {
                        quoteAuth = YES;
                        cancelAuth = YES;
                    }else{
                        quoteAuth = NO;
                        cancelAuth = NO;
                    }
                }
                TFProjectRowFrameModel *frame = nil;
                if (quoteAuth) {
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
        }
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_getTaskRelated || resp.cmdId == HQCMD_personnelTaskByRelated) {// 项目任务 or 个人任务 被关联
        
        // 被关联数组
        [self.byRelations removeAllObjects];
        NSArray *relationArr2 = resp.body;
        
        for (NSDictionary *secDict in relationArr2) {
            
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
                
                TFProjectRowFrameModel *frame = [[TFProjectRowFrameModel alloc] initBorder];
                frame.projectRow = task;
                [frames addObject:frame];
            }
            
            sec.tasks = tasks;
            sec.frames = frames;
            [self.byRelations addObject:sec];
        }
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_customTaskLayout) {// 任务布局
        
        if (self.type != 1) {
            NSArray *arr = [MBProgressHUD allHUDsForView:self.view];
            for (NSInteger i = 0; i < arr.count; i ++) {
                MBProgressHUD *hud = arr[i];
                if (hud.tag != 0x5678) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            }
        }
        
        TFCustomBaseModel *model = resp.body;
        self.customModel = model;
        self.customModel.enableLayout.isHideColumnName = @"0";
        self.customModel.enableLayout.title = @"基本信息";
        // 附件
        self.fileRow = [self findRowWithName:@"attachment_customnumber"];
        // 标签
        self.tagRow = [self findRowWithName:@"picklist_tag"];
        // 关联
        self.referenceRow = [self findRowWithName:@"reference_relation"];
        // 优先级
        TFCustomerRowsModel *row = [self findRowWithName:@"picklist_priority"];
        self.priorityRow = row;
        if (row.entrys && [row.entrys isKindOfClass:[NSArray class]]) {
            [self.allPrioritys addObjectsFromArray:row.entrys];
        }
        // 状态
        TFCustomerRowsModel *rowStatus = [self findRowWithName:@"picklist_status"];
        if (rowStatus.entrys && [rowStatus.entrys isKindOfClass:[NSArray class]]) {
            [self.allStatues addObjectsFromArray:rowStatus.entrys];
        }
        

        self.layouts = [self recombinationLayout:model];

        if (self.detailDict) {
            [self detailHandleWithDict:[self.detailDict valueForKey:@"customArr"]];
        }
        // 自定义固定字段隐藏
        [self handleLayoutFieldHidden];
  
        [self.tableView reloadData];
    }
    
    
    if (resp.cmdId == HQCMD_taskHierarchy) {// 任务层级
        
        NSDictionary *dict = resp.body;
        
        self.projectId = [dict valueForKey:@"projectid"];
        self.sectionId = [dict valueForKey:@"parentnodeid"];
        self.rowId = [dict valueForKey:@"parentnodeid"];
        self.childRowId = [dict valueForKey:@"subnodeid2"];
        
        if (self.childRowId) {
            self.taskHierarchy = [NSString stringWithFormat:@"%@ > %@ > %@ > %@",[dict valueForKey:@"projectname"],[dict valueForKey:@"nodename"],[dict valueForKey:@"subnodename"],[dict valueForKey:@"subnodename2"]];
        }else{
            self.taskHierarchy = [NSString stringWithFormat:@"%@ > %@ > %@",[dict valueForKey:@"projectname"],@"...",[dict valueForKey:@"parentnodename"]];
        }
        
        // 获取项目设置详情
//        [self.projectTaskBL requestGetProjectDetailWithProjectId:self.projectId];
        
        [self.tableView reloadData];
    }
    
//    if (resp.cmdId == HQCMD_getProjecDetail) {
//
//        TFProjectModel *model = resp.body;
//        self.project_time_status = model.project_time_status;
//        self.project_complete_status = model.project_complete_status;
//
//    }
    if (resp.cmdId == HQCMD_getProjectFinishAndActiveAuth) {
        NSDictionary *dict = resp.body;
        self.project_time_status = [[dict valueForKey:@"project_time_status"] description];
        self.project_complete_status = [[dict valueForKey:@"project_complete_status"] description];
    }
    
    
    if (resp.cmdId == HQCMD_finishOrActiveTask || resp.cmdId == HQCMD_finishOrActiveChildTask || resp.cmdId == HQCMD_finishOrActivePersonnelTask) {// 任务激活或完成
        
        if (self.childTaskModel) {// 子任务列表
            
            if ([self.childTaskModel.finishType isEqualToNumber:@1]) {
                self.childTaskModel.finishType = @0;
                self.childTaskModel.complete_status = @0;
            }else{
                self.childTaskModel.finishType = @1;
                self.childTaskModel.complete_status = @1;
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
            
            self.childTaskModel = nil;
        }else{// 详情
            
            if ([[[self.detailDict valueForKey:@"complete_status"] description] isEqualToString:@"1"]) {
                [self.detailDict setObject:@"0" forKey:@"complete_status"];
                [self.detailDict setObject:@"0" forKey:@"passed_status"];
            }else{
                [self.detailDict setObject:@"1" forKey:@"complete_status"];
                [self.detailDict setObject:@"0" forKey:@"passed_status"];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
            
            if (self.action) {
                self.action(@{@"complete_status":[[self.detailDict valueForKey:@"complete_status"] description],@"passed_status":[[self.detailDict valueForKey:@"passed_status"] description]});
            }
            
        }
        
    }
    
    if (resp.cmdId == HQCMD_taskVisible) {// 项目任务协作人可见
        
        if ([[[self.detailDict valueForKey:@"associates_status"] description] isEqualToString:@"1"]) {
            [self.detailDict setObject:@"0" forKey:@"associates_status"];
        }else{
            [self.detailDict setObject:@"1" forKey:@"associates_status"];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [self.tableView reloadData];
        
        // 协作人可见
        if (self.taskType == 0 || self.taskType == 1) {
            self.coopShow = [[[self.detailDict valueForKey:@"associates_status"] description] isEqualToString:@"1"]?YES:NO;
        }else{
            self.coopShow = [[[self.detailDict valueForKey:@"associates_status"] description] isEqualToString:@"1"]?YES:NO;
        }
    }
    if (resp.cmdId == HQCMD_personnelTaskVisible) {// 个人任务协作人可见
        
        if ([[[self.detailDict valueForKey:@"participants_only"] description] isEqualToString:@"1"]) {
            [self.detailDict setObject:@"0" forKey:@"participants_only"];
        }else{
            [self.detailDict setObject:@"1" forKey:@"participants_only"];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [self.tableView reloadData];
        
        // 协作人可见
        if (self.taskType == 0 || self.taskType == 1) {
            self.coopShow = [[[self.detailDict valueForKey:@"associates_status"] description] isEqualToString:@"1"]?YES:NO;
        }else{
            self.coopShow = [[[self.detailDict valueForKey:@"associates_status"] description] isEqualToString:@"1"]?YES:NO;
        }
        
    }
    
    if (resp.cmdId == HQCMD_taskHeart || resp.cmdId == HQCMD_personnelTaskHeart) {// 点赞
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        BOOL contain = NO;
        
        for (HQEmployModel *model in self.peoples) {
            if ([model.id isEqualToNumber:UM.userLoginInfo.employee.id]) {
                [self.peoples removeObject:model];
                contain = YES;
                break;
            }
        }
        
        if (!contain) {
            HQEmployModel *model = [[HQEmployModel alloc] init];
            model.id = UM.userLoginInfo.employee.id;
            model.employeeName = UM.userLoginInfo.employee.employee_name;
            model.employee_name = UM.userLoginInfo.employee.employee_name;
            model.picture = UM.userLoginInfo.employee.picture;
            [self.peoples addObject:model];
        }
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_taskCheck || resp.cmdId == HQCMD_childTaskCheck) {// 任务检验
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.detailDict setObject:[NSString stringWithFormat:@"%ld",self.checkIndex] forKey:@"passed_status"];
        if (self.checkIndex == 2) {
            [self.detailDict setObject:[NSString stringWithFormat:@"0"] forKey:@"complete_status"];
        }
        [self.tableView reloadData];
        
        if (self.action) {
            self.action(@{@"passed_status":[NSString stringWithFormat:@"%ld",self.checkIndex],@"complete_status":[self.detailDict valueForKey:@"complete_status"]});
        }
    }
    
    if (resp.cmdId == HQCMD_cancelTaskRelation) {// 取消任务关联
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.longPressModel.tasks removeObjectAtIndex:self.longPressTaskIndex];
        [self.longPressModel.frames removeObjectAtIndex:self.longPressTaskIndex];
        
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_deleteChildTask || resp.cmdId == HQCMD_deleteTask || resp.cmdId == HQCMD_personnelTaskDelete || resp.cmdId == HQCMD_personnelSubTaskDelete) {// 删除任务
        
        if (self.deleteAction) {
            self.deleteAction();
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_getProjectTaskCooperationPeopleList ) {// 协作人
        
        NSArray *arr = [MBProgressHUD allHUDsForView:self.view];
        for (NSInteger i = 0; i < arr.count; i ++) {
            MBProgressHUD *hud = arr[i];
            if (hud.tag != 0x5678) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }
        
        [self.associates removeAllObjects];
        
        for (TFProjectPeopleModel *model in resp.body) {
            
            HQEmployModel *em = [[HQEmployModel alloc] init];
            em.id = model.employee_id;
            em.employee_name = model.employee_name;
            em.picture = model.employee_pic;
            em.position = model.post_name;
            
            [self.associates addObject:em];
        }
        
        [self.tableView reloadData];
        
    }
    if (resp.cmdId == HQCMD_getPersonnelTaskCooperationPeopleList) {// 协作人
        
        NSArray *arr = [MBProgressHUD allHUDsForView:self.view];
        for (NSInteger i = 0; i < arr.count; i ++) {
            MBProgressHUD *hud = arr[i];
            if (hud.tag != 0x5678) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }
        
        self.associates = resp.body;
        
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_personnelTaskQuotePersonnelTask) {// 个人任务引用个人任务
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"关联成功" toView:self.view];
        [self.projectTaskBL requestPersonnelTaskRelationListWithTaskId:self.dataId fromType:self.taskType == 2 ?@0 : @1];
    }
    
    if (resp.cmdId == HQCMD_personnelTaskHeartPeople || resp.cmdId == HQCMD_taskHeartPeople) {// 点赞人
        
        self.peoples = resp.body;
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_getProjectRoleAndAuth) {// 项目后台权限
        
        NSDictionary *dict = [resp.body valueForKey:@"priviledge"];
        self.privilege = [dict valueForKey:@"priviledge_ids"];
        
        [self setupCommentTabBar];// 初始化底部
        
        if (self.taskRoleAuths && self.role && self.detailDict) {
            
            [self handleMenu];
        }
        
        [self.tableView reloadData];
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
        
        if (self.taskRoleAuths && self.privilege && self.detailDict) {
            
            [self handleMenu];
        }
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_getProjectTaskRoleAuth) {// 任务角色权限
        self.taskRoleAuths = resp.body;
        
        if (self.role && self.privilege && self.detailDict) {
            [self handleMenu];
        }
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_getPersonnelTaskRole) {// 个人任务角色
        
        self.role = [TEXT([resp.body valueForKey:@"role"]) description];
        
        if (self.detailDict) {
            [self handlePersonnelMenu];
        }
        
        [self setupCommentTabBar];// 初始化底部
        
        [self.tableView reloadData];
    }
    
    
    if (resp.cmdId == HQCMD_customCommentList) {// 评论列表
        
        [self.comments removeAllObjects];
        [self.comments addObjectsFromArray:resp.body];
        
        [self.commentTable refreshCommentTableViewWithDatas:self.comments];
        
    }
    
    if (resp.cmdId == HQCMD_customCommentSave) {// 保存
        
        if (self.commentModel) {
            TFTaskHybirdDynamicModel *model = [[TFTaskHybirdDynamicModel alloc] init];
            model.content = self.commentModel.content;
            model.create_time = self.commentModel.datetime_time;
            model.dynamic_type = @1;
            model.employee_id = self.commentModel.employee_id;
            model.employee_name = self.commentModel.employee_name;
            model.picture = self.commentModel.picture;
            model.relation_id = self.commentModel.relation_id;
            NSArray *arr = [HQHelper dictionaryWithJsonString:self.commentModel.information];
            if (arr.count) {
                TFFileModel *file = [[TFFileModel alloc] initWithDictionary:arr.firstObject error:nil];
                if (file) {
                    model.information = [NSArray<Optional,TFFileModel> arrayWithObject:file];
                }else{
                    model.information = [NSArray<Optional,TFFileModel> array];
                }
            }else{
                model.information = [NSArray<Optional,TFFileModel> array];
            }
            [self.comments addObject:model];
        }
        
        [self.commentTable refreshHybirdTableViewWithDatas:self.comments];
        
        [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.keyboard hideKeyBoard];
        });
    }
    
    if (resp.cmdId == HQCMD_uploadFile || resp.cmdId == HQCMD_ChatFile) {
        
        NSArray *arr = resp.body;
        
        if (self.isFile) {// 上传附件
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.files addObjectsFromArray:arr];
            [self.tableView reloadData];
            
            // 编辑任务
            if (self.taskType == 0) {// 主任务
                [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
            }else  if (self.taskType == 1){// 子任务
                [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
            }else  if (self.taskType == 2){
                [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
            }else{
                [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
            }
            
            return;
        }
        
        
        NSMutableArray *files = [NSMutableArray array];
        for (TFFileModel *ff in arr) {
            
            NSMutableDictionary *dd = [NSMutableDictionary dictionaryWithDictionary:[ff toDictionary]];
            
            if (dd) {
                
                if ([[ff.file_type lowercaseString] isEqualToString:@"mp3"] || [[ff.file_type lowercaseString] isEqualToString:@"amr"]) {
                    
                    CGFloat timeSp = [self.commentModel.voiceTime floatValue]*1000;
                    
                    NSString *str = [NSString stringWithFormat:@"%.0f",timeSp];
                    
                    [dd setObject:@([str integerValue]) forKey:@"voiceTime"];
                }
                
                
                [files addObject:dd];
            }
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.bean forKey:@"bean"];
        [dict setObject:self.dataId forKey:@"relation_id"];
        [dict setObject:files forKey:@"information"];
        [dict setObject:@"" forKey:@"content"];
        
        
        if (arr.count) {
            
            TFFileModel *file = arr[0];
            self.commentModel.fileUrl = file.file_url;
        }
        
        [self.customBL requestCustomModuleCommentWithDict:dict];
    }
    
    if (resp.cmdId == HQCMD_customDynamicList) {// 动态列表
        [self.dynamics removeAllObjects];
        [self.dynamics addObjectsFromArray:resp.body];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (TFCustomerDynamicModel *mo in resp.body) {
            for (TFCustomerCommentModel *comm in mo.timeList) {
                [arr addObject:comm];
            }
        }
        [self.allDataView refreshAllDataViewWithDatas:arr];
        [self.dynamicsTable refreshDynamicsTableViewWithDatas:self.dynamics];
    }
    if (resp.cmdId == HQCMD_getProjectTaskSeeStatus) {// 查看状态
        [self.statuses removeAllObjects];
        [self.statuses addObjectsFromArray:resp.body];
        [self.statusTable refreshStatusTableViewWithDatas:self.statuses];
    }
    if (resp.cmdId == HQCMD_getPersonnelTaskSeeStatus) {// 查看状态
        [self.statuses removeAllObjects];
        [self.statuses addObjectsFromArray:resp.body];
        [self.statusTable refreshStatusTableViewWithDatas:self.statuses];
    }
    
    if (resp.cmdId == HQCMD_addTaskRelation || resp.cmdId == HQCMD_quoteTaskRelation) {// 任务添加关联
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.projectTaskBL requestGetTaskRelationListWithTaskId:self.dataId taskType:@(self.taskType + 1)];// 获取任务关联列表
    }
    
    if (resp.cmdId == HQCMD_barcodePicture) {// 条形码图片
        
        NSDictionary *dict = resp.body;
        NSString *picStr = [dict valueForKey:@"barcodePic"];
        // 预览图片
        //        TFFileModel *model = [[TFFileModel alloc] init];
        //        model.file_url = picStr;
        //        [self.images removeAllObjects];
        //        [self.images addObject:model];
        //        [self didLookAtPhotoActionWithIndex:0];
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
        view.backgroundColor = WhiteColor;
        view.tag = 0x2222;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){30,0,SCREEN_WIDTH-60,SCREEN_HEIGHT}];
        [view addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = WhiteColor;
        [imageView sd_setImageWithURL:[HQHelper URLWithString:picStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (image) {
                [KeyWindow addSubview:view];
            }else{
                [MBProgressHUD showError:@"未获取到图片" toView:self.view];
            }
            
        }];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barcodeClicked:)];
        [imageView addGestureRecognizer:tap];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barcodeClicked:)];
        [view addGestureRecognizer:tap1];
    }
    if (resp.cmdId == HQCMD_createBarcode) {// 生成条形码
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dict = resp.body;
        self.attachmentModel.fieldValue = [dict valueForKey:@"barcodeValue"];
        [self.tableView reloadData];
        
        // 联动
        [self generalSingleCellWithModel:self.attachmentModel];
    }
    if (resp.cmdId == HQCMD_moduleHaveReadAuth) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dict = resp.body;
        
        if ([[dict valueForKey:@"readAuth"] isEqualToNumber:@0] || [[dict valueForKey:@"readAuth"] isEqualToNumber:@2]) {
            [MBProgressHUD showError:@"暂无数据权限" toView:self.view];
            return;
        }
        
        //        TFCustomDetailController *detail = [[TFCustomDetailController alloc] init];
        TFNewCustomDetailController *detail = [[TFNewCustomDetailController alloc] init];
        detail.bean = self.attachmentModel.relevanceModule.moduleName;
        detail.dataId = [NSNumber numberWithLongLong:[self.attachmentModel.relevanceField.fieldId longLongValue]];
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}

- (void)barcodeClicked:(UITapGestureRecognizer *)tap{
    
    [[KeyWindow viewWithTag:0x2222] removeFromSuperview];
}
/** 个人任务菜单 */
- (void)handlePersonnelMenu{
    
    [self.menus removeAllObjects];
    
    if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
        
        if (![[[self.detailDict valueForKey:@"complete_status"] description] isEqualToString:@"1"]) {
            NSArray *arr = @[@"设置任务提醒", @"设置重复任务",@"删除任务"];
            [self.menus addObjectsFromArray:arr];
        }else{
            NSArray *arr = @[@"设置任务提醒", @"设置重复任务"];
            [self.menus addObjectsFromArray:arr];
        }
    }else{
        NSArray *arr = @[@"设置任务提醒"];
        [self.menus addObjectsFromArray:arr];
    }
    
    if (self.menus.count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}

/** 项目任务菜单 */
- (void)handleMenu{
    
    [self.menus removeAllObjects];
    
    if (self.taskType == 0) {
        
//        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_1" role:self.role]) {
//            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
//                [self.menus addObject:@"编辑任务"];
//            }
//        }
        if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"26"]) {
            [self.menus addObject:@"设置任务提醒"];
        }
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_5" role:self.role]) {
            [self.menus addObject:@"设置重复任务"];
        }
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_4" role:self.role]) {
            [self.menus addObject:@"移动任务"];
        }
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_14" role:self.role]) {
            [self.menus addObject:@"复制任务"];
        }
        
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_3" role:self.role]) {
            if (![[[self.detailDict valueForKey:@"complete_status"] description] isEqualToString:@"1"]) {
                [self.menus addObject:@"删除任务"];
            }
        }
    }else if (self.taskType == 1){// 子任务
        
//        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_9" role:self.role]) {
//            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
//                [self.menus addObject:@"编辑任务"];
//            }
//        }
        if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"26"]) {
            [self.menus addObject:@"设置任务提醒"];
        }
        
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_10" role:self.role]) {
            if (![[[self.detailDict valueForKey:@"complete_status"] description] isEqualToString:@"1"]) {
                [self.menus addObject:@"删除任务"];
            }
        }
        
    }
    
    if (self.menus.count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
                
                // 选项控制
                if (selects.count) {
                    TFCustomerOptionModel *option = selects[0];
                    [self relevanceWithOption:option];
                }
                
                // 选项是否隐藏组件
                [self optionHiddenWithModel:model];
                
                
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
        
    }else if ([model.type isEqualToString:@"attachment"] || [model.type isEqualToString:@"resumeanalysis"] || [model.type isEqualToString:@"picture"]){// 图片附件
        
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
/** 选项控制 */
- (void)relevanceWithOption:(TFCustomerOptionModel *)option{
    
    if (option.controlField && ![option.controlField isEqualToString:@""]) {
        
        TFCustomerRowsModel *rrow = [self findRowWithName:option.controlField];
        
        // 依赖数组
        NSMutableArray<TFCustomerOptionModel> *contrs = [NSMutableArray<TFCustomerOptionModel> array];
        // 找到所控制的选项，而不是用option.relyonList , 因为relyonList丢失了hidenFields
        for (TFCustomerOptionModel *reOp in option.relyonList) {
            for (TFCustomerOptionModel *rrowOp in rrow.entrys) {
                
                if ([rrowOp.value isEqualToString:reOp.value]) {
                    [contrs addObject:rrowOp];
                    break;
                }
            }
        }
        rrow.controlEntrys = contrs;
        
        // 将该控制的字段还原
        BOOL restore = YES;
        if (rrow.selects.count) {// 该选项在控制范围里面，无需将其还原
            for (TFCustomerOptionModel *selOp in rrow.selects) {
                for (TFCustomerOptionModel *conOp in contrs) {
                    if ([selOp.value isEqualToString:conOp.value]) {
                        restore = NO;
                        break;
                    }
                }
            }
        }
        if (restore) {
            
            [self restoreHiddenWithModel:rrow];
            // 选项还原
            [self restoreOptionWithModel:rrow];
            rrow.fieldValue = nil;
            rrow.selects = nil;
        }
        
        // 将该选项的默认值展示出来
        if (rrow.field.defaultEntrys.count && rrow.selects.count == 0) {
            
            NSMutableArray *rrowArrs = [NSMutableArray array];
            for (TFCustomerOptionModel *rrowOp in rrow.controlEntrys) {
                for (TFCustomerOptionModel *derrowOp in rrow.field.defaultEntrys) {
                    
                    if ([rrowOp.value isEqualToString:derrowOp.value]) {
                        derrowOp.open = @1;
                        rrowOp.open = @1;
                        [rrowArrs addObject:derrowOp];
                    }
                }
            }
            rrow.selects = rrowArrs;
        }
    }
    
}


/** 还原选项选中状态 */
- (void)restoreOptionWithModel:(TFCustomerRowsModel *)model{
    
    for (TFCustomerOptionModel *op in model.controlEntrys) {
        op.open = @0;
    }
    
    for (TFCustomerOptionModel *op in model.entrys) {
        op.open = @0;
    }
}


/** 还原某个隐藏的组件 */
- (void)restoreHiddenWithModel:(TFCustomerRowsModel *)model{
    
    if (model.selects.count) {
        
        TFCustomerOptionModel *option = model.selects[0];
        
        if (option.hidenFields.count) {// 隐藏
            
            // 恢复该选项控制的
            for (TFCustomerLayoutModel *layout in self.layouts) {
                
                // 子表单的一组（隐藏子表单）
                if ([layout.optionHiddenName isEqualToString:model.name]) {
                    
                    layout.isOptionHidden = nil;
                    for (TFCustomerRowsModel *mo in layout.rows){
                        
                        mo.field.isOptionHidden = nil;
                        mo.field.optionHiddenName = nil;
                    }
                    
                }else{
                    
                    for (TFCustomerRowsModel *mo in layout.rows){
                        
                        if ([mo.field.optionHiddenName isEqualToString:model.name]) {// 控制相应的字段显示
                            
                            mo.field.isOptionHidden = nil;
                            mo.field.optionHiddenName = nil;
                        }
                        
                    }
                }
            }
        }
    }
}

/** 选项隐藏某个组件 */
- (void)optionHiddenWithModel:(TFCustomerRowsModel *)model{
    
    if (model.selects.count) {
        
        TFCustomerOptionModel *option = model.selects[0];
        
        if (option.hidenFields.count) {
            // 隐藏
            for (TFFieldNameModel *hideName in option.hidenFields) {
                
                for (TFCustomerLayoutModel *layout in self.layouts) {
                    
                    if ([layout.name isEqualToString:@"subform"] && [hideName.name isEqualToString:layout.fieldName]) {// 存放子表单的一组数据
                        
                        layout.isOptionHidden = @"1";
                        layout.optionHiddenName = model.name;
                        
                        for (TFCustomerRowsModel *mo in layout.rows){// 当前这一组全部隐藏
                            
                            mo.field.isOptionHidden = @"1";
                            mo.field.optionHiddenName = model.name;
                        }
                        
                    }else{// 非子表单的组
                        
                        for (TFCustomerRowsModel *mo in layout.rows){
                            
                            if ([hideName.name isEqualToString:mo.name]) {// 控制相应的字段隐藏
                                
                                mo.field.isOptionHidden = @"1";
                                mo.field.optionHiddenName = model.name;
                                
                            }
                        }
                    }
                }
            }
        }
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
#pragma mark - 重组布局
/** 重组布局 */
- (NSMutableArray *)recombinationLayout:(TFCustomBaseModel *)baseModel{
    
    NSMutableArray *layouts = [NSMutableArray array];
    NSInteger index = 0;
    NSInteger level = 0;
    
    NSArray *lu = @[];
    if (baseModel.layout) {
        lu = baseModel.layout;
    }else if (baseModel.enableLayout){
        lu = @[baseModel.enableLayout];
    }
    
    for (TFCustomerLayoutModel *layout in lu) {
        
        level ++;
        
        // 真实布局
        TFCustomerLayoutModel *lay = [[TFCustomerLayoutModel alloc] init];
        lay.level = [NSString stringWithFormat:@"%ld",(long)level];
        lay.title = layout.title;
        lay.name = layout.name;
        lay.terminalApp = layout.terminalApp;
        lay.isHideInCreate = layout.isHideInCreate;
        lay.isHideInDetail = layout.isHideInDetail;
        lay.isHideColumnName = layout.isHideColumnName;
        lay.virValue = @"0";
        lay.isSpread = layout.isSpread?:@"0";
        if (!layout.isHideColumnName || [layout.isHideColumnName isEqualToString:@"1"]) {
            lay.isSpread = @"0";
        }
        lay.show = @"1";
        NSMutableArray<TFCustomerRowsModel,Optional> *rows = [NSMutableArray<TFCustomerRowsModel,Optional> array];
        lay.rows = rows;
        [layouts addObject:lay];
        
        for (TFCustomerRowsModel *row in layout.rows) {
            
            // 将子表单加入
            TFCustomerLayoutModel *laymo = layouts[index];
            [laymo.rows addObject:row];
            
            if ([row.type isEqualToString:@"subform"]) {
                
                laymo.fieldName = row.name;
                if (self.type == 0) {
                    
                    // 将子表单中组件定义为一个布局
                    
                    TFCustomerLayoutModel *sublay = [[TFCustomerLayoutModel alloc] init];
                    sublay.level = [NSString stringWithFormat:@"%ld",(long)level];
                    sublay.virValue = @"1";
                    sublay.name = row.type;
                    sublay.fieldName = row.name;
                    // 该分栏不显示大于组件不显示
                    if ([layout.terminalApp isEqualToString:@"0"]) {
                        sublay.terminalApp = layout.terminalApp;
                    }else{
                        sublay.terminalApp = row.field.terminalApp;
                    }
                    sublay.isHideInCreate = layout.isHideInCreate;
                    sublay.isHideInDetail = layout.isHideInDetail;
                    sublay.isHideColumnName = @"0";
                    sublay.position = @(1);
                    sublay.isSpread = layout.isSpread?:@"0";
                    if (!layout.isHideColumnName || [layout.isHideColumnName isEqualToString:@"1"]) {
                        sublay.isSpread = @"0";
                    }
                    
//                    NSMutableArray<TFCustomerRowsModel,Optional> *subforms = [NSMutableArray<TFCustomerRowsModel,Optional> array];
//                    for (TFCustomerRowsModel *sub in row.componentList) {
//                        TFCustomerRowsModel *copSub = [sub copy];
//                        copSub.subformName = row.name;
//                        [subforms addObject:copSub];
//                    }
//
//                    row.subforms = [NSMutableArray arrayWithObject:subforms];
//
//                    sublay.rows = subforms;
                    
                    [layouts addObject:sublay];
                    index += 1;
                    
                }else{
                    
                    NSArray *arr = nil;
                    
                    if (self.taskType == 0 || self.taskType == 1) {
                        arr = [[self.detailDict valueForKey:@"customArr"] valueForKey:row.name];
                    }else{
                        arr = [[self.detailDict valueForKey:@"customLayout"] valueForKey:row.name];
                    }
                    
                    if (!arr) continue;
                    
                    if (arr.count) {
                        
                        row.subforms = nil;
                        for (NSInteger i = 0 ; i < arr.count; i ++) {
                            
                            // 将子表单中组件定义为一个布局
                            TFCustomerLayoutModel *sublay = [[TFCustomerLayoutModel alloc] init];
                            sublay.level = [NSString stringWithFormat:@"%ld",(long)level];
                            sublay.virValue = @"1";
                            sublay.name = row.type;
                            sublay.fieldName = row.name;
                            // 该分栏不显示大于组件不显示
                            if ([layout.terminalApp isEqualToString:@"0"]) {
                                sublay.terminalApp = layout.terminalApp;
                            }else{
                                sublay.terminalApp = row.field.terminalApp;
                            }
                            sublay.isHideInCreate = layout.isHideInCreate;
                            sublay.isHideInDetail = layout.isHideInDetail;
                            sublay.isHideColumnName = @"0";
                            sublay.position = @(i+1);
                            sublay.isSpread = layout.isSpread?:@"0";
                            if (!layout.isHideColumnName || [layout.isHideColumnName isEqualToString:@"1"]) {
                                sublay.isSpread = @"0";
                            }
                            
                            NSMutableArray<TFCustomerRowsModel,Optional> *subforms = [NSMutableArray<TFCustomerRowsModel,Optional> array];
                            for (TFCustomerRowsModel *sub in row.componentList) {
//                                [subforms addObject:[sub copy]];
                                
                                TFCustomerRowsModel *copSub = [sub copy];
                                copSub.subformName = row.name;
                                copSub.position = sublay.position;
                                [subforms addObject:copSub];
                            }
                            if (!row.subforms) {
                                row.subforms = [NSMutableArray arrayWithObject:subforms];
                            }else{
#pragma mark - 2018.05.07 在编辑后,因存在subforms，不能总增加，因为可能是前面一样的
                                if (i <= row.subforms.count-1) {
                                    [row.subforms replaceObjectAtIndex:i withObject:subforms];
                                }else{
                                    [row.subforms addObject:subforms];
                                }
                            }
                            
                            sublay.rows = subforms;
                            
                            [layouts addObject:sublay];
                            index += 1;
                        }
                        
                    }
//                    else{
//                        
//                        // 将子表单中组件定义为一个布局
//                        TFCustomerLayoutModel *sublay = [[TFCustomerLayoutModel alloc] init];
//                        sublay.level = [NSString stringWithFormat:@"%ld",(long)level];
//                        sublay.virValue = @"1";
//                        sublay.fieldName = row.name;
//                        sublay.name = row.type;
//                        // 该分栏不显示大于组件不显示
//                        if ([layout.terminalApp isEqualToString:@"0"]) {
//                            sublay.terminalApp = layout.terminalApp;
//                        }else{
//                            sublay.terminalApp = row.field.terminalApp;
//                        }
//                        sublay.isHideInCreate = layout.isHideInCreate;
//                        sublay.isHideInDetail = layout.isHideInDetail;
//                        sublay.isHideColumnName = @"0";
//                        sublay.position = @(1);
//                        sublay.isSpread = layout.isSpread?:@"0";
//                        if (!layout.isHideColumnName || [layout.isHideColumnName isEqualToString:@"1"]) {
//                            sublay.isSpread = @"0";
//                        }
//                        
//                        NSMutableArray<TFCustomerRowsModel,Optional> *subforms = [NSMutableArray<TFCustomerRowsModel,Optional> array];
//                        for (TFCustomerRowsModel *sub in row.componentList) {
////                            [subforms addObject:[sub copy]];
//                            
//                            TFCustomerRowsModel *copSub = [sub copy];
//                            copSub.subformName = row.name;
//                            copSub.position = sublay.position;
//                            [subforms addObject:copSub];
//                        }
//                        row.subforms = [NSMutableArray arrayWithObject:subforms];
//                        
//                        sublay.rows = subforms;
//                        
//                        [layouts addObject:sublay];
//                        index += 1;
//                    }
                    
                }
                
                // 以子表单为分割创建另一个布局
                TFCustomerLayoutModel *model = [[TFCustomerLayoutModel alloc] init];
                model.level = [NSString stringWithFormat:@"%ld",(long)level];
                model.virValue = @"2";
                //                model.fieldName = row.name;
                model.terminalApp = layout.terminalApp;
                model.isHideInCreate = layout.isHideInCreate;
                model.isHideInDetail = layout.isHideInDetail;
                model.isHideColumnName = @"0";
                model.isSpread = layout.isSpread?:@"0";
                if (!layout.isHideColumnName || [layout.isHideColumnName isEqualToString:@"1"]) {
                    model.isSpread = @"0";
                }
                NSMutableArray<TFCustomerRowsModel,Optional> *mos = [NSMutableArray<TFCustomerRowsModel,Optional> array];
                model.rows = mos;
                
                [layouts addObject:model];
                index += 1;
                
            }
            
        }
        index += 1;
    }
    
    return layouts;
}


- (void)setupNavi{
    self.navigationItem.title = @"详情";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(menu) image:@"projectMenu" highlightImage:@"projectMenu"];
}

- (void)menu{
    
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
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (NSString *str in self.menus) {
            [sheet addButtonWithTitle:str];
        }
        
        sheet.tag = 0x333;
        [sheet showInView:self.view];
    }else{
        
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (NSString *str in self.menus) {
            [sheet addButtonWithTitle:str];
        }
        
        sheet.tag = 0x333;
        [sheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 0x444) {
        if (buttonIndex == 0) {// 新建
            
                if (self.taskType == 0 || self.taskType == 1) {// 项目任务引用新建
                    
                    TFModelEnterController *enter = [[TFModelEnterController alloc] init];
                    enter.type = 5;
                    enter.projectId = self.projectId;
                    enter.rowId = self.rowId;
                    enter.taskId = self.dataId;
                    enter.parameterAction = ^(NSMutableDictionary *parameter) {// 刷新关联新建
                        
                        [parameter setObject:self.dataId forKey:@"taskId"];
                        if (self.taskType == 0) {
                            [parameter setObject:@1 forKey:@"taskType"];
                        }else{
                            [parameter setObject:@2 forKey:@"taskType"];
                        }
                         [self.projectTaskBL requestAddTaskRelationWithDict:parameter];
                        
                    };
                    enter.memoAction = ^(NSMutableDictionary *parameter) {
                        
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
                        
                    };
                    [self.navigationController pushViewController:enter animated:YES];
                    
                }else{// 个人任务引用新建
                    
                    TFModelEnterController *enter = [[TFModelEnterController alloc] init];
                    enter.type = 5;
                    enter.taskId = self.dataId;
                    enter.parameterAction = ^(NSDictionary *parameter) {// 刷新关联新建
                        
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        if ([parameter valueForKey:@"dataId"]) {
                            [dict setObject:[parameter valueForKey:@"dataId"] forKey:@"relation_id"];
                        }
                        [dict setObject:@"project_custom" forKey:@"bean_name"];
                        [dict setObject:self.dataId forKey:@"task_id"];
                        if (self.taskType == 2) {
                            [dict setObject:@0 forKey:@"from_type"];
                        }else{
                            [dict setObject:@1 forKey:@"from_type"];
                        }
                        [self.projectTaskBL requestPersonnelTaskQuotePersonnelTaskWithDict:dict];
                    };
                    [self.navigationController pushViewController:enter animated:YES];
                    
                }
                
            
        }
        else if (buttonIndex == 1) {// 引用
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
        
    }else if (actionSheet.tag == 0x333){
        
        if (buttonIndex == 0) {
            return;
        }
        NSString *str = self.menus[buttonIndex - 1];
        
        if ([str isEqualToString:@"编辑任务"]) {// 编辑
            
            TFAddTaskController *add = [[TFAddTaskController alloc] init];
            if (self.taskType == 0 || self.taskType == 1) {
                add.bean = [NSString stringWithFormat:@"project_custom_%@",[self.projectId description]];
                add.type = 8;
                add.dataId = [[self.detailDict valueForKey:@"customArr"] valueForKey:@"id"];// 不是任务id，布局中的id
                add.project_time_status = self.project_time_status;
                add.mainTaskEndTime = self.mainTaskEndTime;
            }else{
                add.bean = [NSString stringWithFormat:@"project_custom"];
                add.type = 9;
                add.dataId = [[self.detailDict valueForKey:@"customLayout"] valueForKey:@"id"];// 不是任务id，布局中的id
                add.mainTaskEndTime = self.mainTaskEndTime;
            }
            add.taskId = self.dataId;
            add.parentTaskId = self.parentTaskId;
            add.edit = self.taskType + 1;
            add.tableViewHeight = SCREEN_HEIGHT-NaviHeight;
            add.projectId = self.projectId;
            add.rowId = self.rowId;
            add.fatherRefresh = ^{
                // 刷新详情
                if (self.taskType == 0) {// 项目任务
                    
                    [self.projectTaskBL requestGetTaskDetailWithTaskId:self.dataId];// 任务详情
                    [self.projectTaskBL requestGetChildTaskListWithTaskId:self.dataId nodeCode:self.nodeCode];// 子任务
                }
                if (self.taskType == 1) {// 项目任务子任务
                    
                    [self.projectTaskBL requestGetChildTaskDetailWithChildTaskId:self.dataId];// 子任务详情
                    if (self.childAction) {
                        self.childAction();
                    }
                }
                if (self.taskType == 2) {// 个人任务
                    [self.projectTaskBL requestPersonnelTaskDetailWithTaskId:self.dataId];// 个人任务详情
                    [self.projectTaskBL requestGetPersonnelChildTaskListWithTaskId:self.dataId];// 子任务
                }
                if (self.taskType == 3) {// 个人任务子任务
                    [self.projectTaskBL requestPersonnelSubTaskDetailWithTaskId:self.dataId];// 个人任务子任务详情
                    if (self.childAction) {
                        self.childAction();
                    }
                }
            };
            [self.navigationController pushViewController:add animated:YES];
            
        }else if ([str isEqualToString:@"设置任务提醒"]){// 提醒
            
            TFRemainTimeController *remain = [[TFRemainTimeController alloc] init];
            remain.taskType = self.taskType;
            remain.taskId = self.dataId;
            remain.projectId = self.projectId;
            [self.navigationController pushViewController:remain animated:YES];
        }else if ([str isEqualToString:@"设置重复任务"]){// 重复设置
            
            TFTaskRepeatController *repeat = [[TFTaskRepeatController alloc] init];
            repeat.taskType = self.taskType;
            repeat.taskId = self.dataId;
            [self.navigationController pushViewController:repeat animated:YES];
            
        }else if ([str isEqualToString:@"移动任务"]){// 移动任务
            
            if (self.taskType == 0) {// 移动任务
                
//                TFMoveTaskController *move = [[TFMoveTaskController alloc] init];
//                move.projectId = self.projectId;
//                move.sectionId = self.sectionId;
//                move.startSectionId = self.sectionId;
//                move.rowId = self.rowId;
//                move.taskId = self.dataId;
//                move.refreshAction = ^{
//
//                    [self.projectTaskBL requsetTaskHierarchyWithTaskId:self.dataId];// 任务层级
//                };
//                [self.navigationController pushViewController:move animated:YES];
                
//                TFNewMoveTaskController *move = [[TFNewMoveTaskController alloc] init];
//                move.type = 0;
//                move.projectId = self.projectId;
//                move.sectionId = self.sectionId;
//                move.startSectionId = self.sectionId;
//                move.rowId = self.rowId;
//                move.taskId = self.dataId;
//                move.childRowId = self.childRowId;
//                move.refreshAction = ^{
//
//                    [self.projectTaskBL requsetTaskHierarchyWithTaskId:self.dataId];// 任务层级
//                };
//                [self.navigationController pushViewController:move animated:YES];
                
                TFAgainMoveTaskController *move = [[TFAgainMoveTaskController alloc] init];
                move.projectId = self.projectId;
                move.refreshAction = ^(TFProjectNodeModel *parameter) {
                    // 移动
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.projectTaskBL requestMoveTaskToNewNodeCode:parameter.node_code nodeCode:self.nodeCode taskId:self.dataId];
                    
                };
                [self.navigationController pushViewController:move animated:YES];
            }
            
        }else if ([str isEqualToString:@"复制任务"]){// 复制任务
            
//            TFMoveTaskController *move = [[TFMoveTaskController alloc] init];
//            move.isCopy = 1;
//            move.projectId = self.projectId;
//            move.sectionId = self.sectionId;
//            move.startSectionId = self.sectionId;
//            move.rowId = self.rowId;
//            move.taskId = self.dataId;
//            move.refreshAction = ^{
//
//                [self.projectTaskBL requsetTaskHierarchyWithTaskId:self.dataId];// 任务层级
//            };
//            [self.navigationController pushViewController:move animated:YES];
            
//            TFNewMoveTaskController *move = [[TFNewMoveTaskController alloc] init];
//            move.type = 1;
//            move.projectId = self.projectId;
//            move.sectionId = self.sectionId;
//            move.startSectionId = self.sectionId;
//            move.rowId = self.rowId;
//            move.taskId = self.dataId;
//            move.childRowId = self.childRowId;
//            [self.navigationController pushViewController:move animated:YES];
            
            TFAgainMoveTaskController *move = [[TFAgainMoveTaskController alloc] init];
            move.projectId = self.projectId;
            move.refreshAction = ^(TFProjectNodeModel *parameter) {
                // 复制
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestCopyTaskToNewNodeCode:parameter.node_code nodeCode:self.nodeCode taskId:self.dataId];
            };
            [self.navigationController pushViewController:move animated:YES];
            
        }else if ([str isEqualToString:@"删除任务"]){// 删除
            
            
            if (self.taskType == 0  || self.taskType == 2) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"删除任务后，所有子任务也将同时被删除。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.delegate = self;
                alert.tag = 0x88;
                [alert show];
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否确认删除此子任务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.delegate = self;
                alert.tag = 0x88;
                [alert show];
            }
            
            
        }
        
    }
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 0x333) {
        
        
        if (buttonIndex == 1) {// 校验任务，驳回
            
            if ([alertView textFieldAtIndex:0].text.length) {
                self.checkIndex = 2;
                if (self.taskType == 0) {// 任务
                    
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.projectTaskBL requestTaskCheckWithTaskId:self.dataId status:@2 content:[alertView textFieldAtIndex:0].text];
                }else{// 子任务
                    
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.projectTaskBL requestChildTaskCheckWithTaskId:self.dataId status:@2 content:[alertView textFieldAtIndex:0].text];
                }
            }else{
                [MBProgressHUD showError:@"校验意见必填" toView:self.view];
            }
        }
        
        if (buttonIndex == 2) {// 校验任务，通过
            
            if ([alertView textFieldAtIndex:0].text.length) {
                self.checkIndex = 1;
                if (self.taskType == 0) {// 任务
                    
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.projectTaskBL requestTaskCheckWithTaskId:self.dataId status:@1 content:[alertView textFieldAtIndex:0].text];
                }else{// 子任务
                    
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.projectTaskBL requestChildTaskCheckWithTaskId:self.dataId status:@1 content:[alertView textFieldAtIndex:0].text];
                }
            }else{
                [MBProgressHUD showError:@"校验意见必填" toView:self.view];
            }
        }
    }
    
    
        
    if (alertView.tag == 0x88) {// 删除
        
        if (buttonIndex == 1) {
            if (self.taskType == 0) {// 项目任务
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestDeleteTaskWithTaskId:self.dataId];
            }else if (self.taskType == 1){// 项目子任务
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestDeleteChildTaskWithTaskChildId:self.dataId];
            }else if (self.taskType == 2){// 个人任务
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requsetPersonnelTaskDeleteWithTaskIds:[self.dataId description]];
            }else{// 个人任务子任务
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requsetPersonnelSubTaskDeleteWithTaskIds:[self.dataId description]];
                
            }
        }
    }
    
    if (alertView.tag == 0x99) {// 长按
        
        if (buttonIndex == 1) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            TFProjectRowModel *rowModel = self.longPressModel.tasks[self.longPressTaskIndex];
//            [self.projectTaskBL requestCancelTaskRelationWithDataId:rowModel.taskInfoId];
            [self.projectTaskBL requestCancelTaskRelationWithDataId:rowModel.quote_id];
            
        }
    }
    
    if (alertView.tag == 0x111) {// 完成任务
        
        if (buttonIndex == 1) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if (self.taskType == 2 || self.taskType == 3) {// 个人任务
                
                [self.projectTaskBL requestPersonnelTaskFinishOrActiveWithTaskId:self.dataId];
                
            }else if (self.taskType == 0) {// 任务
                
                [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.dataId completeStatus:@1 remark:nil];
            }else{// 子任务
                [self.projectTaskBL requestChildTaskFinishOrActiveWithTaskId:self.dataId completeStatus:@1 remark:nil];
            }
        }
    }
    
    if (alertView.tag == 0x222) {// 激活任务
        
        if (buttonIndex == 1) {
            
            if (self.taskType == 2 || self.taskType == 3) {
                
                [self.projectTaskBL requestPersonnelTaskFinishOrActiveWithTaskId:self.dataId];
            }
            else{
                
                if ([self.project_complete_status isEqualToString:@"1"]) {
                    
                    if ([alertView textFieldAtIndex:0].text.length) {
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        if (self.taskType == 0) {// 任务
                            
                            [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.dataId completeStatus:@0 remark:[alertView textFieldAtIndex:0].text];
                        }else{// 子任务
                            
                            [self.projectTaskBL requestChildTaskFinishOrActiveWithTaskId:self.dataId completeStatus:@0 remark:[alertView textFieldAtIndex:0].text];
                        }
                    }
                    else{
                        
                        [MBProgressHUD showError:@"请填写激活原因" toView:self.view];
                    }
                }
                else{
                    
                    if (self.taskType == 0) {// 任务
                        
                        [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.dataId completeStatus:@0 remark:nil];
                    }else{// 子任务
                        
                        [self.projectTaskBL requestChildTaskFinishOrActiveWithTaskId:self.dataId completeStatus:@0 remark:nil];
                    }
                }
            }
        }
        
    }
    
    if (alertView.tag == 0x4477) {// 修改截止时间
        
        if (buttonIndex == 1) {
            
            if ([alertView textFieldAtIndex:0].text.length) {// 输入了文字
                
                self.remark = [alertView textFieldAtIndex:0].text;
                
                [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDayHourMinute timeSp:self.endTime<=0?[HQHelper getNowTimeSp]:self.endTime onRightTouched:^(NSString *time) {
                    
                    if ([HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"] < [HQHelper getNowTimeSp]) {
                        [MBProgressHUD showError:@"截止时间不可小于当前时间" toView:self.view];
                        return ;
                    }
                    
                    self.endTime = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"];
                    [self.tableView reloadData];
                    // 编辑任务
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    if (self.taskType == 0) {// 主任务
                        [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                    }else  if (self.taskType == 1){// 子任务
                        [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
                    }else  if (self.taskType == 2){
                        [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                    }else{
                        [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
                    }
                    
                }];
            }
            
        }
    }
    
    if (alertView.tag == 0x8888) {// 子任务任务完成
        
        if (buttonIndex == 1) {
            
            if (self.taskType == 0 || self.taskType == 1) {// 项目任务子任务列表
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                if ([self.childTaskModel.finishType isEqualToNumber:@1]) {
                    [self.projectTaskBL requestChildTaskFinishOrActiveWithTaskId:self.childTaskModel.id completeStatus:@0 remark:nil];
                }else{
                    [self.projectTaskBL requestChildTaskFinishOrActiveWithTaskId:self.childTaskModel.id completeStatus:@1 remark:nil];
                }
            }
            if (self.taskType == 2 || self.taskType == 3) {// 个人任务子任务列表
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestPersonnelTaskFinishOrActiveWithTaskId:self.childTaskModel.id];
                
            }
        }
        
    }
    
    if (alertView.tag == 0x7777) {// 子任务任务激活
        
        if (buttonIndex == 1) {
            
            if (self.taskType == 0 || self.taskType == 1) {// 项目任务子任务列表
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestChildTaskFinishOrActiveWithTaskId:self.childTaskModel.id completeStatus:@0 remark:nil];
                
            }
            if (self.taskType == 2 || self.taskType == 3) {// 个人任务子任务列表
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestPersonnelTaskFinishOrActiveWithTaskId:self.childTaskModel.id];
            }
        }
        
    }
    if (alertView.tag == 0x9876) {
        if (buttonIndex == 1) {
            
            TFEmailsNewController *newEmail = [[TFEmailsNewController alloc] init];
            TFEmailReceiveListModel *ee = [[TFEmailReceiveListModel alloc] init];
            ee.from_recipient = UM.userLoginInfo.employee.email;
            TFEmailPersonModel *em = [[TFEmailPersonModel alloc] init];
            em.mail_account = self.attachmentModel.fieldValue;
            ee.to_recipients = [NSMutableArray <TFEmailPersonModel,Optional>arrayWithObject:em];
            newEmail.detailModel = ee;
            [self.navigationController pushViewController:newEmail animated:YES];
        }
    }
}

- (void)setupBottom{
    
    NSMutableArray<TFTwoBtnsModel> *arr = [NSMutableArray<TFTwoBtnsModel> array];
    for (NSInteger i = 0; i < 3; i ++) {
        
        TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
        model.font = FONT(14);
        
        if (0 == i){
            model.title = @"评论";
            model.color = ExtraLightBlackTextColor;
        }else if (1 == i){
            model.title = @"动态";
            model.color = ExtraLightBlackTextColor;
        }else if (2 == i){
            model.title = @"查看状态";
            model.color = ExtraLightBlackTextColor;
        }
        
        [arr addObject:model];
    }
    
    TFTwoBtnsView *bottomView = [[TFTwoBtnsView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-NaviHeight-BottomHeight,SCREEN_WIDTH,TabBarHeight} withTitles:arr];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
}

#pragma mark - TFTwoBtnsViewDelegate
-(void)twoBtnsView:(TFTwoBtnsView *)twoBtnsView didSelectIndex:(NSInteger)index{
    
    if (index == 0) {
        
        TFCustomerCommentController *comment = [[TFCustomerCommentController alloc] init];
        
        comment.bean = @"task";
        comment.id = nil;
        [self.navigationController pushViewController:comment animated:YES];
        
    }else if (index == 1){
        
        TFCustomerDynamicController *dynamic = [[TFCustomerDynamicController alloc] init];
        dynamic.bean = @"task";
        dynamic.id = nil;
        [self.navigationController pushViewController:dynamic animated:YES];
    }else{
        
    }
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomM) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    tableView.tag = 0x222;
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 11 + self.layouts.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {// 层级
        return 1;
    }else if (section == 1) {// 任务名称,状态，执行人,截止时间,关联
        if (self.taskType == 0 || self.taskType == 1) {
            return 4;
        }else{
            return 5;
        }
    }else if (section == 2) {// 校验及校验人
        if (self.taskType == 0) {// 项目主任务才有检验人
            return 2;
        }else{
            return 0;
        }
    }else if (section == 3) {// 描述，附件，标签，优先级
        return 4;
    }else if (section == 4) {// 协作人
        return 2;
    }else if (5 + self.layouts.count == section){// 协作人
        return 0;
    }else if (6 + self.layouts.count == section){// 子任务
//        return 2;
        return 1;
    }else if (7 + self.layouts.count == section){// 关联
        //        return 2;
        return 1;
    }else if (8 + self.layouts.count == section){// 被关联
        if (self.taskType == 0 || self.taskType == 2) {
            //        return 2;
            return 1;
        }else{
            return 0;
        }
    }else if (9 + self.layouts.count == section) {// 点赞
        return 1;
    }else if (10 + self.layouts.count == section) {// 检验
        return 0;
    }else{// 自定义
        
        TFCustomerLayoutModel *model = self.layouts[section-5];
        
        if ([model.isSpread isEqualToString:@"0"]) {
            
            return model.rows.count;
        }else{
            
            return 0;
        }
    }
}

/** 详情隐藏必填 */
- (NSString *)detailHiddenRequireWithField:(TFCustomerFieldModel *)field{
    
    NSString *control = field.fieldControl;
    if (self.type == 1) {// 详情
        if ([field.fieldControl isEqualToString:@"2"]) {
            control = @"0";
        }
    }
    return control;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (self.taskType == 1 || self.taskType == 3) {// 子任务
            
            static NSString *ID = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            if (self.taskType == 1) {
                cell.textLabel.text = [NSString stringWithFormat:@"属于任务：%@",TEXT([self.detailDict valueForKey:@"parent_task_name"])];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"属于任务：%@",TEXT([self.detailDict valueForKey:@"task_name"])];
            }
            return cell;
            
        }else{
            
            TFTImageLabelImageCell *cell = [TFTImageLabelImageCell imageLabelImageCellWithTableView:tableView];
            cell.titleImageName = @"taskMain";
            cell.name = self.taskHierarchy;
            cell.enterImageHidden = YES;
            cell.delegate = self;
            cell.isTap = YES;
            cell.desc = @"";
            cell.bottomLine.hidden = YES;
            return cell;
        }
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            HQTFTaskDetailTitleCell *cell = [HQTFTaskDetailTitleCell taskDetailTitleCellWithTableView:tableView];
            cell.finishBtnT.constant = 0;
            cell.finishBtnW.constant = 0;
            cell.finishBtn.hidden = YES;
            cell.contentView.backgroundColor = BackGroudColor;
            if (self.taskType == 0) {
                [cell refreshTaskDetailTitleCellWithTitle:[self.detailDict valueForKey:@"task_name"] finishi:[self.detailDict valueForKey:@"complete_status"] check:[self.detailDict valueForKey:@"check_status"] pass:[self.detailDict valueForKey:@"passed_status"]];
            }else if (self.taskType == 2) {
                NSDictionary *dict = [self.detailDict valueForKey:@"customLayout"];
                [cell refreshTaskDetailTitleCellWithTitle:[dict valueForKey:@"text_name"] finishi:[self.detailDict valueForKey:@"complete_status"] check:[self.detailDict valueForKey:@"check_status"] pass:[self.detailDict valueForKey:@"passed_status"]];
            }else{
                [cell refreshTaskDetailTitleCellWithTitle:[self.detailDict valueForKey:@"name"] finishi:[self.detailDict valueForKey:@"complete_status"] check:[self.detailDict valueForKey:@"check_status"] pass:[self.detailDict valueForKey:@"passed_status"]];
            }
            if (self.taskType == 0) {
                if ([[[self.detailDict valueForKey:@"complete_status"] description] isEqualToString:@"1"] && [[[self.detailDict valueForKey:@"check_status"] description] isEqualToString:@"1"]  && [[[self.detailDict valueForKey:@"passed_status"] description] isEqualToString:@"0"] && [[[self.detailDict valueForKey:@"check_member"] description] isEqualToString:[UM.userLoginInfo.employee.id description]]) {
                    cell.isCheck = YES;
                }else{
                    cell.isCheck = NO;
                }
            }else{
                cell.isCheck = NO;
                cell.approveStateBtn.hidden = YES;
            }
            cell.delegate = self;
            return cell;
            
        }else  if (indexPath.row == 1){
            TFTaskDetailStatusCell *cell = [TFTaskDetailStatusCell taskDetailStatusCellWithTableView:tableView];
            cell.titleLabel.text = @"状态";
            cell.headImage.image = IMG(@"statusPro");
            TFCustomerOptionModel *option = self.taskStatues.firstObject;
            [cell refreshTaskDetailStatusCellWithModel:option type:0];
            
            if ([option.value integerValue] == 0) {
                if (self.startTime != 0) {
                    if (self.startTime < [HQHelper getNowTimeSp]) {
                        [cell.statusBtn setImage:IMG(@"task超期未开始") forState:UIControlStateNormal];
                        [cell.statusBtn setTitleColor:RedColor forState:UIControlStateNormal];
                        cell.statusBtn.backgroundColor = HexAColor(0xFFE3E2, 1);
                    }
                }
                if (self.endTime != 0) {
                    if (self.endTime < [HQHelper getNowTimeSp]) {
                        [cell.statusBtn setImage:IMG(@"task超期未开始") forState:UIControlStateNormal];
                        [cell.statusBtn setTitleColor:RedColor forState:UIControlStateNormal];
                        cell.statusBtn.backgroundColor = HexAColor(0xFFE3E2, 1);
                    }
                }
            }
//            if (self.taskType == 0) {
//
//                if ([[[self.detailDict valueForKey:@"complete_status"] description] isEqualToString:@"1"] && [[[self.detailDict valueForKey:@"check_status"] description] isEqualToString:@"1"]){
//                    if (![self.detailDict valueForKey:@"passed_status"] || [[[self.detailDict valueForKey:@"passed_status"] description] isEqualToString:@"0"]) {// 当需要校验的时候
//                        [cell.statusBtn setTitle:[NSString stringWithFormat:@" %@",@"待检验"] forState:UIControlStateNormal];
//                        cell.statusBtn.backgroundColor =HexColor(0xFFEDD0);
//                        [cell.statusBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
//                        cell.statusBtn.layer.borderColor = ClearColor.CGColor;
//                        [cell.statusBtn setImage:IMG(@"task待校验") forState:UIControlStateNormal];
//                    }
//                }
//            }
            return cell;
        }else  if (indexPath.row == 2){
            TFTaskDetailCheckPeopleCell *cell = [TFTaskDetailCheckPeopleCell taskDetailCheckPeopleCellWithTableView:tableView];
            cell.checkPeople.text = @"执行人";
            cell.headImage.image = IMG(@"excuPro");
            [cell refreshCheckPeopleWithEmployee:self.employee];
            return cell;
            
        }else  if (indexPath.row == 3){
            TFTaskDetailHandleCell *cell = [TFTaskDetailHandleCell taskDetailHandleCellWithTableView:tableView];
            cell.delegate = self;
            [cell refreshTaskDetailHandleCellWithStartTime:self.startTime endTime:self.endTime];
            return cell;
        }else{
            
            TFTaskDetailRelationCell *cell = [TFTaskDetailRelationCell taskDetailRelationCellWithTableView:tableView];
            cell.contentLabel.text = self.relationName;
            return cell;
        }
        
    }
    else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            TFTaskDetailCheckCell *cell = [TFTaskDetailCheckCell taskDetailCheckCellWithTableView:tableView];
            cell.delegate = self;
            cell.check = self.checkShow;
            return cell;
        }else{
            TFTaskDetailCheckPeopleCell *cell = [TFTaskDetailCheckPeopleCell taskDetailCheckPeopleCellWithTableView:tableView];
            cell.checkPeople.text = @"校验人";
            cell.headImage.image = nil;
            [cell refreshCheckPeopleWithEmployee:self.checkPeople];
            return cell;
        }
        
    }
    else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            TFTaskDetailStatusCell *cell = [TFTaskDetailStatusCell taskDetailStatusCellWithTableView:tableView];
            cell.titleLabel.text = @"优先级";
            cell.headImage.image = IMG(@"priorityPro");
            [cell refreshTaskDetailStatusCellWithModel:self.prioritys.firstObject type:1];
            return cell;
        }else if (indexPath.row == 1) {
            TFTaskDetailLabelCell *cell = [TFTaskDetailLabelCell taskDetailLabelCellWithTableView:tableView];
            cell.titleLabel.text = @"标签";
            cell.descLabel.text = @"添加标签";
            [cell refreshTaskDetailLabelCellWithOptions:self.labels];
            return cell;
        } else if (indexPath.row == 2){// 描述
            TFTaskDetailDescCell *cell = [TFTaskDetailDescCell taskDetailDescCellWithTableView:tableView];
//            cell.textView.text = self.descString;
            [cell reloadDetailContentWithContent:self.descString];
            cell.delegate = self;
            return cell;
        }else if (indexPath.row == 3) {
            TFTaskDetailFileCell *cell = [TFTaskDetailFileCell taskDetailFileCellWithTableView:tableView];
            cell.titleLabel.text = @"附件";
            cell.headImage.image = IMG(@"filePro");
            cell.delegate = self;
            [cell refreshTaskDetailCellWithFiles:self.files];
            return cell;
        }
        
        static NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.layer.masksToBounds = YES;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld组，第%ld行",indexPath.section,indexPath.row];
        return cell;
    }
    else if (indexPath.section == 4){// 协作人可见
        
        if (indexPath.row == 0) {
            TFTaskDetailCooperationCell *cell = [TFTaskDetailCooperationCell taskDetailCooperationCellWithTableView:tableView];
            cell.delegate = self;
            cell.switchBtn.on = self.coopShow;
            return cell;
        }else{
            TFTaskDetailCooperationPeopleCell *cell = [TFTaskDetailCooperationPeopleCell taskDetailCooperationPeopleCellWithTableView:tableView];
            [cell refreshTaskDetailCooperationPeopleCellWithPeoples:self.associates];
            return cell;
        }
        
    }
    else if (5 + self.layouts.count == indexPath.section){
        if (indexPath.row == 0) {
            TFTImageLabelImageCell *cell = [TFTImageLabelImageCell imageLabelImageCellWithTableView:tableView];
            cell.titleImageName = @"taskPeople";
            cell.name = @"协作人";
            cell.enterImageHidden = NO;
            cell.isTap = NO;
            cell.desc = @"";
            cell.bottomLine.hidden = YES;
            return cell;
        }else if (indexPath.row == 1){
            
            TFSelectPeopleCell *cell = [TFSelectPeopleCell selectPeopleCellWithTableView:tableView];
            cell.titleLabel.text = @"  协作人";
            [cell refreshSelectPeopleCellWithPeoples:self.associates structure:@"1" chooseType:@"1" showAdd:NO clear:NO];
            cell.requireLabel.hidden = YES;
            cell.isHiddenName = YES;
            cell.titleLabel.textColor = BlackTextColor;
            cell.titleLabel.font = FONT(14);
            cell.topLine.hidden = NO;
            return cell;
            
        }else{
            
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.title.textColor = BlackTextColor;
            cell.title.text = @"  仅协作人可见";
            cell.title.font = FONT(14);
            if (self.taskType == 0 || self.taskType == 1) {
                cell.switchBtn.on = [[[self.detailDict valueForKey:@"associates_status"] description] isEqualToString:@"1"]?YES:NO;
            }else{
                cell.switchBtn.on = [[[self.detailDict valueForKey:@"participants_only"] description] isEqualToString:@"1"]?YES:NO;
            }
            cell.delegate = self;
            cell.topLine.hidden = NO;
            return cell;
        }
        
    }else if (6 + self.layouts.count == indexPath.section){
        
        if (indexPath.row == 0) {
            
            TFTImageLabelImageCell *cell = [TFTImageLabelImageCell imageLabelImageCellWithTableView:tableView];
            cell.titleImageName = @"childTask";
            cell.name = @"子任务";
            cell.isTap = NO;
            cell.enterImageHidden = NO;
            cell.bottomLine.hidden = NO;
            NSInteger finish = 0;
            for (TFProjectRowModel *mo in self.childTasks) {
                if ([[mo.finishType description] isEqualToString:@"1"]) {
                    finish ++;
                }
            }
            cell.desc = [NSString stringWithFormat:@"%ld/%ld",finish,self.childTasks.count];
            return cell;
            
        }else{
            TFChildTaskListCell *cell  = [TFChildTaskListCell childTaskListCellWithTableView:tableView];
            
            BOOL addChildTaskAuth = NO;
            if (self.taskType == 0 || self.taskType == 1) {
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_8" role:self.role]) {// 新增子任务
                    addChildTaskAuth = YES;
                }
                
            }else if (self.taskType == 2 || self.taskType == 3){
                addChildTaskAuth = [self.role containsString:@"0"] || [self.role containsString:@"1"];
            }
            
            [cell refreshChildTaskListCellWithModels:self.childTasks add:addChildTaskAuth];
            cell.delegate = self;
            cell.topLine.hidden = YES;
            return cell;
        }
        
    }else if (7 + self.layouts.count == indexPath.section){// 关联
        
        if (indexPath.row == 0) {
            
            TFTImageLabelImageCell *cell = [TFTImageLabelImageCell imageLabelImageCellWithTableView:tableView];
            cell.titleImageName = @"taskRelation";
            cell.name = @"引用";
            cell.enterImageHidden = NO;
            cell.isTap = NO;
            cell.bottomLine.hidden = NO;
            NSInteger finish = 0;
            for (TFProjectSectionModel *mo in self.relations) {
                finish += mo.tasks.count;
            }
            cell.desc = [NSString stringWithFormat:@"%ld",finish];
            return cell;
        }else{
            TFTaskRelationListCell *cell = [TFTaskRelationListCell taskRelationListCellWithTableView:tableView];
            
            if (self.taskType == 0 || self.taskType == 1) {// 项目任务
                
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_12" role:self.role]) {
                    [cell refreshTaskRelationListCellWithModels:self.relations type:0 auth:[HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_13" role:self.role]];
                }else{
                    [cell refreshTaskRelationListCellWithModels:self.relations type:1 auth:[HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_13" role:self.role]];
                }
            }else{// 个人任务
                if ([self.role isEqualToString:@"0"] || [self.role isEqualToString:@"1"]) {
                    [cell refreshTaskRelationListCellWithModels:self.relations type:0 auth:YES];
                }else{
                    [cell refreshTaskRelationListCellWithModels:self.relations type:1 auth:NO];
                }
            }
            cell.delegate = self;
            cell.topLine.hidden = YES;
            return cell;
        }
        
        
    }else if (8 + self.layouts.count == indexPath.section){// 被关联
        
        if (indexPath.row == 0) {
            
            TFTImageLabelImageCell *cell = [TFTImageLabelImageCell imageLabelImageCellWithTableView:tableView];
            cell.titleImageName = @"taskRelation";
            cell.name = @"被引用";
            cell.enterImageHidden = NO;
            cell.isTap = NO;
            cell.bottomLine.hidden = YES;
            NSInteger finish = 0;
            for (TFProjectSectionModel *mo in self.byRelations) {
                finish += mo.tasks.count;
            }
            cell.desc = [NSString stringWithFormat:@"%ld",finish];
            return cell;
            
        }else{
            TFTaskRelationListCell *cell = [TFTaskRelationListCell taskRelationListCellWithTableView:tableView];
            [cell refreshTaskRelationListCellWithModels:self.byRelations type:1 auth:NO];
            cell.delegate = self;
            return cell;
        }
        
    }else if (9 + self.layouts.count == indexPath.section){
        TFImgDoubleLalImgCell *cell = [TFImgDoubleLalImgCell imgDoubleLalImgCellWithTableView:tableView];
        [cell refreshCellWithPeoples:self.peoples];
        cell.delegate = self;
        cell.backgroundView.backgroundColor = BackGroudColor;
        cell.backgroundColor = BackGroudColor;
        return cell;
    }else if (10 + self.layouts.count == indexPath.section){
        HQTFThreeLabelCell *cell = [HQTFThreeLabelCell threeLabelCellWithTableView:tableView];
        cell.middleLabel.text = @"校验";
        return cell;
    }else{
        
//        if (self.taskType == 1) {
//            if (indexPath.row == 0) {
//                
//                TFFourBtnCell *cell = [TFFourBtnCell fourBtnCellWithTableView:tableView];
//                [cell refreshFourBtnCellWithEmployee:self.employee];
//                return cell;
//            }else{
//                TFFourBtnCell *cell = [TFFourBtnCell fourBtnCellWithTableView:tableView];
//                [cell refreshFourBtnCellWithTime:self.time];
//                return cell;
//            }
//        }
        
        
        TFCustomerLayoutModel *layout = self.layouts[indexPath.section-5];
        TFCustomerRowsModel *model = layout.rows[indexPath.row];
        TFCustomerFieldModel *field = model.field;
        
        if ([model.type isEqualToString:@"text"]) {// 单行文本
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeDefault;
            cell.leftImage = nil;
            cell.tipImage = nil;
            if (self.type != 1) {// 非详情
                if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                    cell.edit = NO;
                    cell.rightImage = nil;
                }else{
                    cell.edit = YES;
                    if (field.repeatCheck && ![field.repeatCheck isEqualToString:@"0"]) {
                        cell.rightImage = @"custom查重";
                    }else{
                        cell.rightImage = nil;
                    }
                }
                cell.showEdit = YES;
            }else{// 详情
                cell.edit = NO;
                cell.placeholder = @"";
                cell.rightImage = nil;
                cell.showEdit = NO;
            }
            return cell;
            
            
        }else if ([model.type isEqualToString:@"area"]){// area
            
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = [self.areaManager regionWithRegionData:TEXT(model.fieldValue)];
            cell.placeholder = field.pointOut;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.leftImage = nil;
            cell.tipImage = nil;
            cell.edit = NO;
            if (self.type != 1) {// 非详情
                if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                    cell.rightImage = nil;
                }else{
                    if (model.fieldValue.length) {
                        cell.rightImage = @"清除";
                    }else{
                        cell.rightImage = @"下一级浅灰";
                    }
                }
                cell.showEdit = YES;
            }else{// 详情
                cell.placeholder = @"";
                cell.rightImage = nil;
                cell.showEdit = NO;
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"location"]) {// 定位
            
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeDefault;
            cell.leftImage = nil;
            cell.tipImage = nil;
            if (self.type != 1) {// 非详情
                if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                    cell.edit = NO;
                    cell.rightImage = nil;
                }else{
                    cell.edit = YES;
                    cell.rightImage = @"custom定位";
                }
                cell.showEdit = YES;
            }else{// 详情
                cell.edit = NO;
                cell.placeholder = @"";
                if (model.otherDict && [model.otherDict valueForKey:@"latitude"] && [model.otherDict valueForKey:@"longitude"]) {
                    cell.rightImage = @"custom定位";
                }else{
                    cell.rightImage = nil;
                }
                cell.showEdit = NO;
            }
            return cell;
            
            
        }else if ([model.type isEqualToString:@"textarea"]){// 多行文本
            
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeDefault;
            cell.leftImage = nil;
            cell.tipImage = nil;
            cell.rightImage = nil;
            if (self.type != 1) {// 非详情
                if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                    cell.edit = NO;
                }else{
                    cell.edit = YES;
                }
                cell.showEdit = YES;
            }else{// 详情
                cell.edit = NO;
                cell.placeholder = @"";
                cell.showEdit = NO;
            }
            return cell;
            
            
        }else if ([model.type isEqualToString:@"multitext"]){// 富文本组件
            
            TFCustomAttributeTextCell *cell = [TFCustomAttributeTextCell customAttributeTextCellWithTableView:tableView type:1 index:indexPath.section * 0x11 + indexPath.row];
            cell.model = model;
            cell.delegate = self;
            cell.tag = 0x777 *indexPath.section + indexPath.row;
            cell.title = model.label;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            [cell reloadDetailContentWithContent:model.fieldValue];
            if (self.type != 1) {
                cell.showEdit = YES;
            }else{
                cell.showEdit = NO;
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"number"]){// 数字
            
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.leftImage = nil;
            cell.tipImage = nil;
            cell.rightImage = nil;
            if ([model.field.numberType isEqualToString:@"1"]) {// 整数
                cell.textView.keyboardType = UIKeyboardTypeNumberPad;
            }else{
                cell.textView.keyboardType = UIKeyboardTypeDecimalPad;
            }
            if (self.type != 1) {// 非详情
                if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                    cell.edit = NO;
                }else{
                    cell.edit = YES;
                }
                cell.showEdit = YES;
            }else{// 详情
                cell.edit = NO;
                cell.placeholder = @"";
                cell.showEdit = NO;
            }
            if ([model.field.numberType isEqualToString:@"2"]) {// 百分比
                if (self.type != 1) {// 防止复用，用一张图片代替
                    cell.rightImage = @"custom百分号";
                }
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"phone"]){// 电话
            
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeNumberPad;
            cell.leftImage = nil;
            cell.tipImage = nil;
            if (self.type != 1) {// 非详情
                if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                    cell.edit = NO;
                    cell.rightImage = nil;
                }else{
                    cell.edit = YES;
                    if (field.repeatCheck && ![field.repeatCheck isEqualToString:@"0"]) {
                        cell.rightImage = @"custom查重";
                    }else{
                        cell.rightImage = nil;
                    }
                }
                cell.showEdit = YES;
            }else{// 详情
                cell.edit = NO;
                cell.placeholder = @"";
                cell.rightImage = nil;
                cell.showEdit = NO;
            }
            return cell;
            
            
        }else if ([model.type isEqualToString:@"email"]){// 邮箱
            
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
            cell.leftImage = nil;
            cell.tipImage = nil;
            if (self.type != 1) {// 非详情
                if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                    cell.edit = NO;
                    cell.rightImage = nil;
                }else{
                    cell.edit = YES;
                    if (field.repeatCheck && ![field.repeatCheck isEqualToString:@"0"]) {
                        cell.rightImage = @"custom查重";
                    }else{
                        cell.rightImage = nil;
                    }
                }
                cell.showEdit = YES;
            }else{// 详情
                cell.edit = NO;
                cell.placeholder = @"";
                cell.rightImage = nil;
                cell.showEdit = NO;
            }
            return cell;
            
            
        }else if ([model.type isEqualToString:@"attachment"]){// 附件
            
            TFCustomAttachmentsCell *cell = [TFCustomAttachmentsCell CustomAttachmentsCellWithTableView:tableView];
            cell.tag = 0x777 *indexPath.section + indexPath.row;
            cell.model = model;
            cell.delegate = self;
            cell.title = model.label;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            if (self.type != 1) {
                cell.type = AttachmentsCellEdit;
                cell.showEdit = YES;
            }else{
                cell.type = AttachmentsCellDetail;
                cell.showEdit = NO;
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"resumeanalysis"]){// 简历解析
            
            TFCustomAttachmentsCell *cell = [TFCustomAttachmentsCell CustomAttachmentsCellWithTableView:tableView];
            cell.tag = 0x777 *indexPath.section + indexPath.row;
            cell.model = model;
            cell.delegate = self;
            cell.title = model.label;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            if (self.type != 1) {
                cell.type = AttachmentsCellEdit;
                cell.showEdit = YES;
            }else{
                cell.type = AttachmentsCellDetail;
                cell.showEdit = NO;
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"picture"]){// 图片
            
            TFCustomImageCell *cell = [TFCustomImageCell CustomImageCellWithTableView:tableView];
            cell.delegate = self;
            cell.title = model.label;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            [cell refreshCustomImageCellWithModel:model withType:self.type==1?0:1 withColumn:6];
            if (self.type != 1) {
                cell.showEdit = YES;
            }else{
                cell.showEdit = NO;
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"datetime"]){// 时间/日期
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
            cell.leftImage = nil;
            cell.tipImage = nil;
            cell.rightImage = nil;
            cell.edit = NO;
            if (self.type != 1) {// 非详情
                if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                    cell.rightImage = nil;
                }else{
                    if (model.fieldValue.length) {
                        cell.rightImage = @"清除";
                    }else{
                        cell.rightImage = @"custom日期";
                    }
                }
                cell.showEdit = YES;
            }else{// 详情
                cell.placeholder = @"";
                cell.rightImage = nil;
                cell.showEdit = NO;
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"identifier"]){// 自动编号
            
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
            cell.leftImage = nil;
            cell.tipImage = nil;
            cell.rightImage = nil;
            cell.edit = NO;
            cell.placeholder = @"";
            if (self.type != 1) {
                cell.showEdit = YES;
            }else{
                cell.showEdit = NO;
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"serialnum"]){// 流水号
            
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
            cell.leftImage = nil;
            cell.tipImage = nil;
            cell.rightImage = nil;
            cell.edit = NO;
            cell.placeholder = @"";
            if (self.type != 1) {
                cell.showEdit = YES;
            }else{
                cell.showEdit = NO;
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"url"]){// 超链接
            
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeURL;
            cell.leftImage = nil;
            cell.tipImage = nil;
            cell.rightImage = nil;
            if (self.type != 1) {// 非详情
                if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                    cell.edit = NO;
                }else{
                    cell.edit = YES;
                }
                cell.showEdit = YES;
            }else{// 详情
                cell.edit = NO;
                cell.placeholder = @"";
                cell.textView.textColor = GreenColor;
                cell.showEdit = NO;
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"reference"]){// 关联关系
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
            cell.leftImage = nil;
            cell.tipImage = nil;
            cell.rightImage = nil;
            cell.edit = NO;
            if (self.type != 1) {// 非详情
                if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                    cell.rightImage = nil;
                }else{
                    if (model.fieldValue.length) {
                        cell.rightImage = @"清除";
                    }else{
                        cell.rightImage = @"custom关联";
                    }
                }
                cell.showEdit = YES;
            }else{// 详情
                cell.placeholder = @"";
                cell.rightImage = nil;
                cell.textView.textColor = GreenColor;
                cell.showEdit = NO;
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"functionformula"]){// 公式
            
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
            cell.leftImage = nil;
            cell.tipImage = nil;
            cell.rightImage = nil;
            cell.edit = NO;
            cell.placeholder = @"";
            if (self.type != 1) {
                cell.showEdit = YES;
            }else{
                cell.showEdit = NO;
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"citeformula"]){// 引用公式
            
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
            cell.leftImage = nil;
            cell.tipImage = nil;
            cell.rightImage = nil;
            cell.edit = NO;
            cell.placeholder = @"";
            if (self.type != 1) {
                cell.showEdit = YES;
            }else{
                cell.showEdit = NO;
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"formula"]){// 公式
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
            cell.leftImage = nil;
            cell.tipImage = nil;
            cell.rightImage = nil;
            cell.edit = NO;
            cell.placeholder = @"";
            if (self.type != 1) {
                cell.showEdit = YES;
            }else{
                cell.showEdit = NO;
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"seniorformula"]){// 公式
            
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
            cell.leftImage = nil;
            cell.tipImage = nil;
            cell.rightImage = nil;
            cell.edit = NO;
            cell.placeholder = @"";
            if (self.type != 1) {
                cell.showEdit = YES;
            }else{
                cell.showEdit = NO;
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"picklist"]){// 下拉列表
            
            TFCustomSelectOptionCell *cell = [TFCustomSelectOptionCell customSelectOptionCellWithTableView:tableView];
            cell.delegate = self;
            cell.title = model.label;
            cell.fieldControl = field.fieldControl;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            if (self.type != 1) {
                cell.edit = YES;
                cell.showEdit = YES;
            }else{
                cell.edit = NO;
                cell.showEdit = NO;
            }
            cell.model = model;
            return cell;
            
        }else if ([model.type isEqualToString:@"multi"]){// 复选框
            
            
//            TFCustomMultiSelectCell *cell = [TFCustomMultiSelectCell CustomMultiSelectCellWithTableView:tableView];
//            cell.model = model;
//            cell.title = model.label;
//            if (self.type != 1) {
//                cell.edit = YES;
//            }else{
//                cell.edit = NO;
//            }
//            return cell;
            TFCustomSelectOptionCell *cell = [TFCustomSelectOptionCell customSelectOptionCellWithTableView:tableView];
            cell.delegate = self;
            cell.title = model.label;
            cell.fieldControl = field.fieldControl;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            if (self.type != 1) {
                cell.edit = YES;
                cell.showEdit = YES;
            }else{
                cell.edit = NO;
                cell.showEdit = NO;
            }
            cell.model = model;
            return cell;
            
        }else if ([model.type isEqualToString:@"personnel"]){// 人员
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeDefault;
            cell.leftImage = nil;
            cell.tipImage = nil;
            cell.edit = NO;
            if (self.type != 1) {// 非详情
                if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                    cell.rightImage = nil;
                }else{
                    cell.rightImage = @"custom人员";
                }
                cell.showEdit = YES;
            }else{// 详情
                cell.placeholder = @"";
                cell.rightImage = nil;
                cell.showEdit = NO;
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"department"]){// 部门
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeDefault;
            cell.leftImage = nil;
            cell.tipImage = nil;
            cell.edit = NO;
            if (self.type != 1) {// 非详情
                if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                    cell.rightImage = nil;
                }else{
                    cell.rightImage = @"custom部门";
                }
                cell.showEdit = YES;
            }else{// 详情
                cell.placeholder = @"";
                cell.rightImage = nil;
                cell.showEdit = NO;
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"subform"]){
            
            
            TFTCustomSubformHeaderCell *cell = [TFTCustomSubformHeaderCell customSubformHeaderCellWithTableView:tableView];
            cell.title = model.label;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            return cell;
            
        }else if ([model.type isEqualToString:@"mutlipicklist"]){// 多级下拉选项
            
            
            TFCustomSelectOptionCell *cell = [TFCustomSelectOptionCell customSelectOptionCellWithTableView:tableView];
            cell.delegate = self;
            cell.title = model.label;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            if (self.type != 1) {
                cell.edit = YES;
                cell.showEdit = YES;
            }else{
                cell.edit = NO;
                cell.showEdit = NO;
            }
            cell.model = model;
            return cell;
            
        }else if ([model.type isEqualToString:@"barcode"]){
            
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.leftBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
            cell.tipImage = nil;
            if (self.type != 1) {// 非详情
                cell.leftImage = @"获取条码";
                cell.rightImage = @"启用扫一扫";
                cell.edit = YES;
                cell.showEdit = YES;
            }else{// 详情
                cell.placeholder = @"";
                cell.rightImage = @"查看条码";
                cell.leftImage = nil;
                cell.edit = NO;
                cell.showEdit = NO;
            }
            return cell;
            
        }else if ([model.type isEqualToString:@"checkbox"]){
            
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.title.text = model.label;
            cell.title.font = BFONT(12);
            cell.title.textColor = BlackTextColor;
            cell.switchBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.delegate = self;
            cell.switchBtn.on = [model.fieldValue isEqualToString:@"1"]?YES:NO;
            cell.topLine.hidden = YES;
            cell.bottomLine.hidden = NO;
            return cell;
            
        }
        
        static NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.layer.masksToBounds = YES;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld组，第%ld行",indexPath.section,indexPath.row];
        return cell;
        
    }
    
}

- (void)hiddenToplineForCell:(HQBaseCell *)cell indexPath:(NSIndexPath *)indexPath layout:(TFCustomerLayoutModel *)layout{
    
    if (indexPath.row  == 0) {
        if ([layout.virValue isEqualToString:@"2"]) {
            cell.topLine.hidden = NO;
        }else{
            cell.topLine.hidden = YES;
        }
    }else{
        cell.topLine.hidden = NO;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
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
    }
    // 协作人
    if ((5 + self.layouts.count) == indexPath.section) {// 协作人
        
        if (indexPath.row == 0) {
            self.coopShow = !self.coopShow;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//            [self.tableView beginUpdates];
//            [self.tableView endUpdates];
        }else if (indexPath.row == 1){
            
            // 判断添加协作人权限
            if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_11" role:self.role]) {
                TFCooperationPeopleController *people = [[TFCooperationPeopleController alloc] init];
                people.taskType = self.taskType;
                people.projectId = self.projectId;
                people.taskId = self.dataId;
                people.parentTaskId = self.parentTaskId;
                people.taskRoleAuths = self.taskRoleAuths;
                people.role = self.role;
                people.project_status = self.project_status;
                people.complete_status = [self.detailDict valueForKey:@"complete_status"];
                people.action = ^(NSMutableArray *parameter) {
                    
                    if (self.taskType == 0 || self.taskType == 1) {
                        
                        [self.associates removeAllObjects];
                        
                        [self.associates addObjectsFromArray:parameter];
                        
                    }else{
                        self.associates = parameter;
                    }
                    
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:people animated:YES];
                
            }else{
                [MBProgressHUD showError:@"无权限" toView:self.view];
            }
            
        }
    }
    // 子任务
    else if ((6 + self.layouts.count) == indexPath.section) {// 子任务
        
        if (indexPath.row == 0) {
//            self.childShow = !self.childShow;
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//            [self.tableView beginUpdates];
//            [self.tableView endUpdates];
            BOOL addChildTaskAuth = NO;
            if (self.taskType == 0 || self.taskType == 1) {
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_8" role:self.role]) {// 新增子任务
                    addChildTaskAuth = YES;
                }
                
            }else if (self.taskType == 2 || self.taskType == 3){
                addChildTaskAuth = [self.role containsString:@"0"] || [self.role containsString:@"1"];
            }
            TFChildTaskListController *taskList = [[TFChildTaskListController alloc] init];
            taskList.auth = addChildTaskAuth;
            taskList.tasks = self.childTasks;
            taskList.taskType = self.taskType;
            taskList.detailDict = self.detailDict;
            taskList.project_status = self.project_status;
            taskList.dataId = self.dataId;
            taskList.projectId = self.projectId;
            taskList.nodeCode = self.nodeCode;
            taskList.refresh = ^{
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:taskList animated:YES];
        }
    }
    // 关联
    else if ((7 + self.layouts.count) == indexPath.section) {// 关联
        
        if (indexPath.row == 0) {
//            self.relationShow = !self.relationShow;
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//            [self.tableView beginUpdates];
//            [self.tableView endUpdates];
            BOOL quoteAuth = NO;
            BOOL cancelAuth = NO;
            if (self.taskType == 0 || self.taskType == 1) {// 项目任务
                
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_12" role:self.role]) {
                    quoteAuth = YES;
                }else{
                    quoteAuth = NO;
                }
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_13" role:self.role]) {
                    cancelAuth = YES;
                }else{
                    cancelAuth = NO;
                }
            }else{// 个人任务
                if ([self.role isEqualToString:@"0"] || [self.role isEqualToString:@"1"]) {
                    quoteAuth = YES;
                    cancelAuth = YES;
                }else{
                    quoteAuth = NO;
                    cancelAuth = NO;
                }
            }
            TFTaskQuoteListController *quoteList = [[TFTaskQuoteListController alloc] init];
            quoteList.relations = self.relations;
            quoteList.type = 0;
            quoteList.quoteAuth = quoteAuth;
            quoteList.cancelAuth = cancelAuth;
            quoteList.taskType = self.taskType;
            quoteList.detailDict = self.detailDict;
            quoteList.project_status = self.project_status;
            quoteList.dataId = self.dataId;
            quoteList.projectId = self.projectId;
            quoteList.refresh = ^{
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:quoteList animated:YES];
        }
    }
    // 被关联
    else if ((8 + self.layouts.count) == indexPath.section) {// 被关联
        
        if (indexPath.row == 0) {
//            self.beRelatedShow = !self.beRelatedShow;
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//            [self.tableView beginUpdates];
//            [self.tableView endUpdates];
            TFTaskQuoteListController *quoteList = [[TFTaskQuoteListController alloc] init];
            quoteList.relations = self.byRelations;
            quoteList.type = 1;
            quoteList.taskType = self.taskType;
            quoteList.detailDict = self.detailDict;
            quoteList.project_status = self.project_status;
            quoteList.dataId = self.dataId;
            quoteList.projectId = self.projectId;
            [self.navigationController pushViewController:quoteList animated:YES];
        }
    }
    // 点赞人列表
    else if ((9 + self.layouts.count) == indexPath.section){// 点赞人列表
        
        TFHeartPeopleListController *heart = [[TFHeartPeopleListController alloc] init];
        heart.taskId = self.dataId;
        heart.taskType = self.taskType;
        [self.navigationController pushViewController:heart animated:YES];
        
    }
    // 检验
    else if ((10 + self.layouts.count) == indexPath.section){// 检验
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"校验意见" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"驳回",@"通过", nil];
        alert.delegate = self;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *filed = [alert textFieldAtIndex:0];
        filed.placeholder = @"请输入校验意见（必填）";
        alert.tag = 0x333;
        [alert show];
        
    }
    //
    else if (0 == indexPath.section){//
        
        
    }
    // 任务名称，执行人
    else if (1 == indexPath.section){// 任务名称, 状态,执行人
        // 名称
        if (indexPath.row == 0) {// 名称
            
            if (self.taskType == 0) {// 主任务
                
                // 判断编辑任务权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_1" role:self.role]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        [HQNotPassSubmitView submitPlaceholderStr:@"请输入任务名称" title:nil content:self.taskName maxCharNum:200 LeftTouched:^{
                            
                        } onRightTouched:^(NSDictionary *dict) {
                            
                            if ([dict valueForKey:@"text"]) {
                                self.taskName = [dict valueForKey:@"text"];
                            }
                            [self.tableView reloadData];
                            // 编辑任务
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                            
                        }];
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
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        [HQNotPassSubmitView submitPlaceholderStr:@"请输入任务名称" title:nil content:self.taskName maxCharNum:200 LeftTouched:^{
                            
                        } onRightTouched:^(NSDictionary *dict) {
                            
                            if ([dict valueForKey:@"text"]) {
                                self.taskName = [dict valueForKey:@"text"];
                            }
                            [self.tableView reloadData];
                            // 编辑任务
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
                            
                        }];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }
            }
            else if (self.taskType == 2){// 个人任务
                
                if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        [HQNotPassSubmitView submitPlaceholderStr:@"请输入任务名称" title:nil content:self.taskName maxCharNum:200 LeftTouched:^{
                            
                        } onRightTouched:^(NSDictionary *dict) {
                            
                            if ([dict valueForKey:@"text"]) {
                                self.taskName = [dict valueForKey:@"text"];
                            }
                            [self.tableView reloadData];
                            // 编辑任务
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                            
                        }];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }
            }
            else{// 个人子任务
                if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        [HQNotPassSubmitView submitPlaceholderStr:@"请输入任务名称" title:nil content:self.taskName maxCharNum:200 LeftTouched:^{
                            
                        } onRightTouched:^(NSDictionary *dict) {
                            
                            if ([dict valueForKey:@"text"]) {
                                self.taskName = [dict valueForKey:@"text"];
                            }
                            [self.tableView reloadData];
                            // 编辑任务
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
                            
                        }];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }
            }
           
        }
        // 状态
        if (indexPath.row == 1) {
            TFProjectRowModel *model = [HQHelper projectRowWithTaskDict:self.detailDict];
            if (self.taskType > 1) {// 详情中没有from,需手动加上
                model.from = @1;
            }
            model.id = self.dataId;
            model.projectId = self.projectId;
            model.task_id = self.parentTaskId;
            model.picklist_status = [NSArray<TFCustomerOptionModel,Optional> arrayWithArray:self.taskStatues];
            TFSelectStatusController *select = [[TFSelectStatusController alloc] init];
            select.type = 2;
            select.task = model;
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:select];
            select.refresh = ^{
                
                // 刷新任务
                if (self.taskType == 0) {
                    [self.projectTaskBL requestGetTaskDetailWithTaskId:self.dataId];// 任务详情
                }else if (self.taskType == 1){
                    [self.projectTaskBL requestGetChildTaskDetailWithChildTaskId:self.dataId];// 子任务详情
                }else if (self.taskType == 2){
                    [self.projectTaskBL requestPersonnelTaskDetailWithTaskId:self.dataId];// 个人任务详情
                }else{
                    [self.projectTaskBL requestPersonnelSubTaskDetailWithTaskId:self.dataId];// 个人任务子任务详情
                }
                
            };
            navi.modalPresentationStyle = UIModalPresentationFullScreen;

            [self presentViewController:navi animated:YES completion:nil];
        }
//        if (indexPath.row == 1) {// 状态
//
//            if (self.taskType == 0) {// 主
//                // 判断编辑任务权限
//                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_1" role:self.role]) {
//
//                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
//
////                        [TFTaskPriorityView taskPriorityViewWithPrioritys:self.allStatues type:0  sure:^(NSArray * parameter) {
////
////                            [self.taskStatues removeAllObjects];
////                            [self.taskStatues addObjectsFromArray:parameter];
////                            [self.tableView reloadData];
////
////                            // 编辑任务
////                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
////                            [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
////                        }];
//
//                        TFSelectStatusController *select = [[TFSelectStatusController alloc] init];
//                        select.type = 0;
//                        select.options = self.allStatues;
//                        select.sureHandler = ^(NSArray * parameter) {
//
//                            [self.taskStatues removeAllObjects];
//                            [self.taskStatues addObjectsFromArray:parameter];
//                            [self.tableView reloadData];
//
//                            // 编辑任务
//                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                            [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
//                        };
//                        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:select];
//                        [self presentViewController:navi animated:YES completion:nil];
//                    }else{
//                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
//                    }
//                }else{
//                    [MBProgressHUD showError:@"无权限" toView:self.view];
//                }
//
//            }
//            else if (self.taskType == 1){// 子
//
//                // 判断编辑子任务权限
//                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_9" role:self.role]) {
//
//                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
//
////                        [TFTaskPriorityView taskPriorityViewWithPrioritys:self.allStatues type:0  sure:^(NSArray * parameter) {
////
////                            [self.taskStatues removeAllObjects];
////                            [self.taskStatues addObjectsFromArray:parameter];
////                            [self.tableView reloadData];
////
////                            // 编辑任务
////                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
////                            [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
////                        }];
//
//                        TFSelectStatusController *select = [[TFSelectStatusController alloc] init];
//                        select.type = 0;
//                        select.options = self.allStatues;
//                        select.sureHandler = ^(NSArray * parameter) {
//
//                            [self.taskStatues removeAllObjects];
//                            [self.taskStatues addObjectsFromArray:parameter];
//                            [self.tableView reloadData];
//
//                            // 编辑任务
//                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                            [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
//                        };
//                        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:select];
//                        [self presentViewController:navi animated:YES completion:nil];
//                    }else{
//                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
//                    }
//                }else{
//                    [MBProgressHUD showError:@"无权限" toView:self.view];
//                }
//            }
//            else if (self.taskType == 2){// 个人任务
//
//                // 判断编辑任务权限
//                if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
//
//                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
////                        [TFTaskPriorityView taskPriorityViewWithPrioritys:self.allStatues type:0  sure:^(NSArray * parameter) {
////
////                            [self.taskStatues removeAllObjects];
////                            [self.taskStatues addObjectsFromArray:parameter];
////                            [self.tableView reloadData];
////
////                            // 编辑任务
////                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
////                            [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
////                        }];
//                        TFSelectStatusController *select = [[TFSelectStatusController alloc] init];
//                        select.type = 0;
//                        select.options = self.allStatues;
//                        select.sureHandler = ^(NSArray * parameter) {
//
//                            [self.taskStatues removeAllObjects];
//                            [self.taskStatues addObjectsFromArray:parameter];
//                            [self.tableView reloadData];
//
//                            // 编辑任务
//                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                            [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
//                        };
//                        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:select];
//                        [self presentViewController:navi animated:YES completion:nil];
//                    }else{
//                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
//                    }
//                }else{
//                    [MBProgressHUD showError:@"无权限" toView:self.view];
//                }
//            }else{// 个人子任务
//
//                // 判断编辑任务权限
//                if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
//
//                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
////                        [TFTaskPriorityView taskPriorityViewWithPrioritys:self.allStatues type:0  sure:^(NSArray * parameter) {
////
////                            [self.taskStatues removeAllObjects];
////                            [self.taskStatues addObjectsFromArray:parameter];
////                            [self.tableView reloadData];
////
////                            // 编辑任务
////                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
////                            [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
////                        }];
//                        TFSelectStatusController *select = [[TFSelectStatusController alloc] init];
//                        select.type = 0;
//                        select.options = self.allStatues;
//                        select.sureHandler = ^(NSArray * parameter) {
//
//                            [self.taskStatues removeAllObjects];
//                            [self.taskStatues addObjectsFromArray:parameter];
//                            [self.tableView reloadData];
//
//                            // 编辑任务
//                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                            [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
//                        };
//                        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:select];
//                        [self presentViewController:navi animated:YES completion:nil];
//                    }else{
//                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
//                    }
//                }else{
//                    [MBProgressHUD showError:@"无权限" toView:self.view];
//                }
//            }
//        }
//
        // 执行人
        if (indexPath.row == 2) {// 执行人
            
            if (self.taskType == 0) {// 主任务
                
                // 判断编辑任务权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_1" role:self.role]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                       
                        TFProjectMenberManageController *member = [[TFProjectMenberManageController alloc] init];
                        member.type = 1;
                        member.projectId = self.projectId;
                        member.parameterAction = ^(NSArray *parameter) {
                            
                            if (parameter.count) {
                                self.employee = parameter.firstObject;
                                [self.tableView reloadData];
                                // 编辑任务
                                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                                
                            }
                        };
                        [self.navigationController pushViewController:member animated:YES];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
            }
            else if (self.taskType == 1){// 子任务
                
                // 判断编辑任务权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_1" role:self.role]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        TFProjectMenberManageController *member = [[TFProjectMenberManageController alloc] init];
                        member.type = 1;
                        member.projectId = self.projectId;
                        member.parameterAction = ^(NSArray *parameter) {
                            
                            if (parameter.count) {
                                self.employee = parameter.firstObject;
                                [self.tableView reloadData];
                                // 编辑任务
                                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
                                
                            }
                        };
                        [self.navigationController pushViewController:member animated:YES];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
            }
            else if (self.taskType == 2){// 个人任务
                
                // 判断编辑任务权限
                if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
                        scheduleVC.selectType = 1;
                        scheduleVC.isSingleSelect = YES;
                        if (self.employee) {
                            scheduleVC.defaultPoeples = @[self.employee];
                        }
                        //            scheduleVC.noSelectPoeples = model.selects;
                        scheduleVC.actionParameter = ^(NSArray *parameter) {
                            
                            if (parameter.count) {
                                self.employee = parameter.firstObject;
                                [self.tableView reloadData];
                                // 编辑任务
                                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                                
                            }
                        };
                        [self.navigationController pushViewController:scheduleVC animated:YES];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
            }
            else {// 个人子任务
                
                // 判断编辑任务权限
                if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
                        scheduleVC.selectType = 1;
                        scheduleVC.isSingleSelect = YES;
                        if (self.employee) {
                            scheduleVC.defaultPoeples = @[self.employee];
                        }
                        //            scheduleVC.noSelectPoeples = model.selects;
                        scheduleVC.actionParameter = ^(NSArray *parameter) {
                            
                            if (parameter.count) {
                                self.employee = parameter.firstObject;
                                [self.tableView reloadData];
                                // 编辑任务
                                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
                                
                            }
                        };
                        [self.navigationController pushViewController:scheduleVC animated:YES];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
            }
            
        }
        
        if (indexPath.row == 4) {// 关联
            
            TFPersonnelTaskRelationController *pro = [[TFPersonnelTaskRelationController alloc] init];
            
            pro.parameterAction = ^(NSDictionary *parameter) {
                self.relationDict = parameter;
                NSNumber *num = [parameter valueForKey:@"type"];
                if ([num isEqualToNumber:@0]) {// 项目名称
                    
                    self.relationName = [NSString stringWithFormat:@"%@",[parameter valueForKey:@"projectName"]];
                    
                }else{// 关联自定义模块
                    
                    self.relationName = [NSString stringWithFormat:@"%@",[parameter valueForKey:@"dataName"]];
                    
                }
                [self.tableView reloadData];
                if (self.taskType == 2) {
                    
                    // 编辑任务
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                    
                }else if (self.taskType == 3) {
                    
                    // 编辑任务
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
                }
            };
            
            [self.navigationController pushViewController:pro animated:YES];
        }
        
    }
    // 检验人
    else if (2 == indexPath.section){
        
        if (indexPath.row == 1) {// 检验人
            
            if (self.taskType == 0) {// 主任务
                
                // 判断编辑任务权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_1" role:self.role]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        TFProjectMenberManageController *member = [[TFProjectMenberManageController alloc] init];
                        member.type = 1;
                        member.projectId = self.projectId;
                        if (self.checkPeople) {
                            member.selectPeoples = @[self.checkPeople];
                        }

                        NSDictionary *dict = [self.detailDict valueForKey:@"customArr"];
                        if (dict) {
                            member.noselectPeoples = [dict valueForKey:@"personnel_principal"];
                        }
                        member.parameterAction = ^(NSArray *parameter) {
                            
                            if (parameter.count) {
                                self.checkPeople = parameter.firstObject;
                                [self.tableView reloadData];
                                
                                // 编辑任务
                                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                                
                            }
                        };
                        [self.navigationController pushViewController:member animated:YES];
                    }
                    else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
            }
            else if (self.taskType == 1){// 子任务
                
                // 判断编辑任务权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_9" role:self.role]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        TFProjectMenberManageController *member = [[TFProjectMenberManageController alloc] init];
                        member.type = 1;
                        member.projectId = self.projectId;
                        if (self.checkPeople) {
                            member.selectPeoples = @[self.checkPeople];
                        }
                        member.parameterAction = ^(NSArray *parameter) {
                            
                            if (parameter.count) {
                                self.checkPeople = parameter.firstObject;
                                [self.tableView reloadData];
                                
                                // 编辑任务
                                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
                                
                            }
                        };
                        [self.navigationController pushViewController:member animated:YES];
                    }
                    else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
            }
            else if (self.taskType == 2){
                // 判断编辑任务权限
                if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
                        scheduleVC.selectType = 1;
                        scheduleVC.isSingleSelect = YES;
                        if (self.checkPeople) {
                            scheduleVC.defaultPoeples = @[self.checkPeople];
                        }
                        //            scheduleVC.noSelectPoeples = model.selects;
                        scheduleVC.actionParameter = ^(NSArray *parameter) {
                            
                            if (parameter.count) {
                                self.checkPeople = parameter.firstObject;
                                [self.tableView reloadData];
                                
                                // 编辑任务
                                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                                
                            }
                        };
                        [self.navigationController pushViewController:scheduleVC animated:YES];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
            }else{
                // 判断编辑任务权限
                if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
                        scheduleVC.selectType = 1;
                        scheduleVC.isSingleSelect = YES;
                        if (self.checkPeople) {
                            scheduleVC.defaultPoeples = @[self.checkPeople];
                        }
                        //            scheduleVC.noSelectPoeples = model.selects;
                        scheduleVC.actionParameter = ^(NSArray *parameter) {
                            
                            if (parameter.count) {
                                self.checkPeople = parameter.firstObject;
                                [self.tableView reloadData];
                                
                                // 编辑任务
                                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
                                
                            }
                        };
                        [self.navigationController pushViewController:scheduleVC animated:YES];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
            }
        }
        
    }
    // 优先级,标签，描述，附件
    else if (3 == indexPath.section){// 优先级,标签，描述，附件
        // 优先级
        if (indexPath.row == 0) {// 优先级
            
            if (self.taskType == 0) {// 主
                // 判断编辑任务权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_1" role:self.role]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
//                        [TFTaskPriorityView taskPriorityViewWithPrioritys:self.allPrioritys type:1  sure:^(NSArray * parameter) {
//
//                            [self.prioritys removeAllObjects];
//                            [self.prioritys addObjectsFromArray:parameter];
//                            [self.tableView reloadData];
//
//                            // 编辑任务
//                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                            [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
//                        }];
                        TFSelectStatusController *select = [[TFSelectStatusController alloc] init];
                        select.type = 1;
                        select.options = self.allPrioritys;
                        select.sureHandler = ^(NSArray * parameter) {
                            
                            [self.prioritys removeAllObjects];
                            [self.prioritys addObjectsFromArray:parameter];
                            [self.tableView reloadData];

                            // 编辑任务
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                        };
                        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:select];
                        navi.modalPresentationStyle = UIModalPresentationFullScreen;

                        [self presentViewController:navi animated:YES completion:nil];
                        
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
                
            }
            else if (self.taskType == 1){// 子
                
                // 判断编辑子任务权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_9" role:self.role]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
//                        [TFTaskPriorityView taskPriorityViewWithPrioritys:self.allPrioritys type:1  sure:^(NSArray * parameter) {
//
//                            [self.prioritys removeAllObjects];
//                            [self.prioritys addObjectsFromArray:parameter];
//                            [self.tableView reloadData];
//
//                            // 编辑任务
//                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                            [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
//                        }];
                        TFSelectStatusController *select = [[TFSelectStatusController alloc] init];
                        select.type = 1;
                        select.options = self.allPrioritys;
                        select.sureHandler = ^(NSArray * parameter) {
                            
                            [self.prioritys removeAllObjects];
                            [self.prioritys addObjectsFromArray:parameter];
                            [self.tableView reloadData];
                            
                            // 编辑任务
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
                        };
                        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:select];
                        navi.modalPresentationStyle = UIModalPresentationFullScreen;

                        [self presentViewController:navi animated:YES completion:nil];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
            }
            else if (self.taskType == 2){// 个人任务
                // 判断编辑任务权限
                if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
//                        [TFTaskPriorityView taskPriorityViewWithPrioritys:self.allPrioritys type:1  sure:^(NSArray * parameter) {
//
//                            [self.prioritys removeAllObjects];
//                            [self.prioritys addObjectsFromArray:parameter];
//                            [self.tableView reloadData];
//
//                            // 编辑任务
//                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                            [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
//                        }];
                        TFSelectStatusController *select = [[TFSelectStatusController alloc] init];
                        select.type = 1;
                        select.options = self.allPrioritys;
                        select.sureHandler = ^(NSArray * parameter) {
                            
                            [self.prioritys removeAllObjects];
                            [self.prioritys addObjectsFromArray:parameter];
                            [self.tableView reloadData];
                            
                            // 编辑任务
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                        };
                        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:select];
                        navi.modalPresentationStyle = UIModalPresentationFullScreen;

                        [self presentViewController:navi animated:YES completion:nil];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
            }else{// 个人子任务
                // 判断编辑任务权限
                if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
//                        [TFTaskPriorityView taskPriorityViewWithPrioritys:self.allPrioritys type:1  sure:^(NSArray * parameter) {
//
//                            [self.prioritys removeAllObjects];
//                            [self.prioritys addObjectsFromArray:parameter];
//                            [self.tableView reloadData];
//
//                            // 编辑任务
//                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                            [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
//                        }];
                        TFSelectStatusController *select = [[TFSelectStatusController alloc] init];
                        select.type = 1;
                        select.options = self.allPrioritys;
                        select.sureHandler = ^(NSArray * parameter) {
                            [self.prioritys removeAllObjects];
                            [self.prioritys addObjectsFromArray:parameter];
                            [self.tableView reloadData];
                            
                            // 编辑任务
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
                        };
                        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:select];
                        navi.modalPresentationStyle = UIModalPresentationFullScreen;

                        [self presentViewController:navi animated:YES completion:nil];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
            }
            
        }
        // 标签
        if (indexPath.row == 1) {// 标签
            
            if (self.taskType == 0) {// 主
                // 判断编辑任务权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_1" role:self.role]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        TFSelectOptionController *select = [[TFSelectOptionController alloc] init];
                        
                        select.isTaskTag = YES;
                        select.projectId = self.projectId;
                        select.isSingleSelect = NO;
                        select.backVc = self;
                        select.selectEntrys = self.labels;
                        select.selectAction = ^(NSMutableArray * parameter) {
                            
                            [self.labels removeAllObjects];
                            [self.labels addObjectsFromArray:parameter];
                            [self.tableView reloadData];
                            
                            // 编辑任务
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                            
                        };
                        [self.navigationController pushViewController:select animated:YES];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
                
            }
            else if (self.taskType == 1){// 子
                
                // 判断编辑子任务权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_9" role:self.role]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        TFSelectOptionController *select = [[TFSelectOptionController alloc] init];
                        
                        select.isTaskTag = YES;
                        select.projectId = self.projectId;
                        select.isSingleSelect = NO;
                        select.backVc = self;
                        select.selectEntrys = self.labels;
                        select.selectAction = ^(NSMutableArray * parameter) {
                            
                            [self.labels removeAllObjects];
                            [self.labels addObjectsFromArray:parameter];
                            [self.tableView reloadData];
                            
                            // 编辑任务
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
                            
                        };
                        [self.navigationController pushViewController:select animated:YES];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
            }
            else if (self.taskType == 2){
                
                // 判断编辑任务权限
                if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        TFSelectOptionController *select = [[TFSelectOptionController alloc] init];
                        
                        select.isTaskTag = YES;
                        select.projectId = self.projectId;
                        select.isSingleSelect = NO;
                        select.backVc = self;
                        select.selectEntrys = self.labels;
                        select.selectAction = ^(NSMutableArray * parameter) {
                            
                            [self.labels removeAllObjects];
                            [self.labels addObjectsFromArray:parameter];
                            [self.tableView reloadData];
                            
                            // 编辑任务
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                            
                        };
                        [self.navigationController pushViewController:select animated:YES];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
            }else{
                
                // 判断编辑任务权限
                if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        TFSelectOptionController *select = [[TFSelectOptionController alloc] init];
                        
                        select.isTaskTag = YES;
                        select.projectId = self.projectId;
                        select.isSingleSelect = NO;
                        select.backVc = self;
                        select.selectEntrys = self.labels;
                        select.selectAction = ^(NSMutableArray * parameter) {
                            
                            [self.labels removeAllObjects];
                            [self.labels addObjectsFromArray:parameter];
                            [self.tableView reloadData];
                            
                            // 编辑任务
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
                            
                        };
                        [self.navigationController pushViewController:select animated:YES];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
            }
        }
        // 描述
        if (indexPath.row == 2) {
            
            if (self.taskType == 0) {// 主
                // 判断编辑任务权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_1" role:self.role]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        TFAttributeTextController *att = [[TFAttributeTextController alloc] init];
                        att.fieldLabel = @"描述";
                        att.content = self.descString;
                        att.contentAction = ^(NSString *parameter) {
                            
                            self.descString = parameter;
                            TFTaskDetailDescCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                            [cell reloadDetailContentWithContent:parameter];
                            [self.tableView reloadData];
                            
                            // 编辑任务
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                        };
                        [self.navigationController pushViewController:att animated:YES];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
                
            }
            else if (self.taskType == 1){// 子
                
                // 判断编辑子任务权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_9" role:self.role]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        TFAttributeTextController *att = [[TFAttributeTextController alloc] init];
                        att.fieldLabel = @"描述";
                        att.content = self.descString;
                        att.contentAction = ^(NSString *parameter) {
                            
                            self.descString = parameter;
                            TFTaskDetailDescCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                            [cell reloadDetailContentWithContent:parameter];
                            [self.tableView reloadData];
                            
                            // 编辑任务
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
                            
                        };
                        [self.navigationController pushViewController:att animated:YES];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
            }
            else if (self.taskType == 2){// 个人任务
                
                // 判断编辑任务权限
                if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        TFAttributeTextController *att = [[TFAttributeTextController alloc] init];
                        att.fieldLabel = @"描述";
                        att.content = self.descString;
                        att.contentAction = ^(NSString *parameter) {
                            
                            self.descString = parameter;
                            TFTaskDetailDescCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                            [cell reloadDetailContentWithContent:parameter];
                            [self.tableView reloadData];
                            
                            // 编辑任务
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                            
                        };
                        [self.navigationController pushViewController:att animated:YES];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
            }
            else{
                
                // 判断编辑任务权限
                if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        
                        TFAttributeTextController *att = [[TFAttributeTextController alloc] init];
                        att.fieldLabel = @"描述";
                        att.content = self.descString;
                        att.contentAction = ^(NSString *parameter) {
                            
                            self.descString = parameter;
                            TFTaskDetailDescCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                            [cell reloadDetailContentWithContent:parameter];
                            [self.tableView reloadData];
                            
                            // 编辑任务
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
                            
                        };
                        [self.navigationController pushViewController:att animated:YES];
                    }else{
                        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                    }
                }else{
                    [MBProgressHUD showError:@"无权限" toView:self.view];
                }
            }
            
        }
        
    }
    // 协作人
    else if (4 == indexPath.section){// 协作人
        
        if (indexPath.row == 1) {
            TFCooperationPeopleController *people = [[TFCooperationPeopleController alloc] init];
            people.taskType = self.taskType;
            people.projectId = self.projectId;
            people.taskId = self.dataId;
            people.parentTaskId = self.parentTaskId;
            people.taskRoleAuths = self.taskRoleAuths;
            people.role = self.role;
            people.project_status = self.project_status;
            people.complete_status = [self.detailDict valueForKey:@"complete_status"];
            people.action = ^(NSMutableArray *parameter) {
                
                if (self.taskType == 0 || self.taskType == 1) {
                    
                    [self.associates removeAllObjects];
                    
                    [self.associates addObjectsFromArray:parameter];
                    
                }else{
                    self.associates = parameter;
                }
                
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:people animated:YES];
            
        }
    }
    else{
        
        TFCustomerLayoutModel *layout = self.layouts[indexPath.section-5];
        TFCustomerRowsModel *model = layout.rows[indexPath.row];
        
        // 关联跳转
        if ([model.type isEqualToString:@"reference"]) {
            
            if ([model.name isEqualToString:@"reference_relation"]) {// 任务的关联,特殊处理
                
                NSNumber *dataId = [self.detailDict valueForKey:@"relation_id"];
                NSString *data = [self.detailDict valueForKey:@"relation_data"];
                NSString *bean = [self.detailDict valueForKey:@"bean_name"];
                if ([[[self.detailDict valueForKey:@"from_status"] description] isEqualToString:@"1"]) {// 项目
                    
                    TFProjectDetailTabBarController *detail = [[TFProjectDetailTabBarController alloc] init];
                    TFProjectModel *model = [[TFProjectModel alloc] init];
                    model.id = dataId;
                    model.name = data;
                    detail.projectId = dataId;
                    detail.projectModel = model;
                    
                    [self.navigationController pushViewController:detail animated:YES];
                    
                }else if ([[[self.detailDict valueForKey:@"from_status"] description] isEqualToString:@"2"]){// 自定义
                    
//                    TFNewCustomDetailController *detail = [[TFNewCustomDetailController alloc] init];
//                    detail.bean = bean;
//                    detail.dataId = dataId;
//                    [self.navigationController pushViewController:detail animated:YES];
                    
                    self.attachmentModel = model;
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.customBL requestHaveReadAuthWithModuleBean:bean withDataId:dataId];
                }
                
            }else{
                
                if (!model.relevanceField.fieldId || [model.relevanceField.fieldId isEqualToString:@""]) {
                    return;
                }
                self.attachmentModel = model;
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.customBL requestHaveReadAuthWithModuleBean:model.relevanceModule.moduleName withDataId:@([model.relevanceField.fieldId longLongValue])];
                
            }
        }
        // 超链接跳转
        if ([model.type isEqualToString:@"url"]) {
            
            if ([HQHelper checkUrl:TEXT(model.fieldValue)]) {
                
                if (!([model.fieldValue containsString:@"http"] || [model.fieldValue containsString:@"https"] || [model.fieldValue containsString:@"ftp"])) {
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString stringWithFormat:@"https://%@",model.fieldValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[model.fieldValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                }
                
            }else{
                [MBProgressHUD showError:@"链接格式有误" toView:KeyWindow];
            }
        }
        
        
        if ([model.type isEqualToString:@"location"]) {
            
            if (model.otherDict && [model.otherDict valueForKey:@"latitude"] && [model.otherDict valueForKey:@"longitude"]) {
                
                TFMapController *locationVc = [[TFMapController alloc] init];
                locationVc.type = LocationTypeLookLocation;
                locationVc.location = CLLocationCoordinate2DMake([[model.otherDict valueForKey:@"latitude"] doubleValue], [[model.otherDict valueForKey:@"longitude"] doubleValue]);
                
                [self.navigationController pushViewController:locationVc animated:YES];
            }else if (!IsStrEmpty(model.fieldValue)){
                [MBProgressHUD showError:@"没有经纬度无法查看位置" toView:KeyWindow];
            }
        }
    }
    
}

#pragma mark - 处理编辑
-(NSMutableDictionary *)taskHandle{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.taskType == 0 || self.taskType == 1) {// 项目任务
        
        if (self.taskType == 0) {// 主任务
            if (self.dataId) {
                [dict setObject:self.dataId forKey:@"taskId"];
            }
        }else{// 子任务
            if (self.dataId) {
                [dict setObject:self.dataId forKey:@"id"];
            }
            if (self.parentTaskId) {
                [dict setObject:self.parentTaskId forKey:@"taskId"];
            }
        }
        
        [dict setObject:self.projectId forKey:@"projectId"];
        [dict setObject:[NSString stringWithFormat:@"project_custom_%@",self.projectId] forKey:@"bean"];
        
        if (self.taskType == 0) {
            
            if (self.checkPeople) {
                [dict setObject:self.checkPeople.id?:self.checkPeople.employee_id forKey:@"checkMember"];
                if (self.checkShow) {
                    [dict setObject:@"1" forKey:@"checkStatus"];
                }else{
                    [dict setObject:@"0" forKey:@"checkStatus"];
                }
            }else{
                [dict setObject:@"" forKey:@"checkMember"];
                [dict setObject:@"0" forKey:@"checkStatus"];
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
        [dict setObject:self.dataId forKey:@"id"];
        
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
    
    
    if ([model.type isEqualToString:@"attachment"]  || [model.type isEqualToString:@"resumeanalysis"] || [model.type isEqualToString:@"picture"]) {// 附件，图片
        
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

// 13008811115 *Phd*2011
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {// 层级
        if (self.taskType == 2) {
            return 0;
        }
        return 44;
    }
    else if (indexPath.section == 1){// 任务名称
        if (indexPath.row == 0) {
            NSString *title = [self.detailDict valueForKey:@"task_name"];
            if (title == nil) {
                title = [self.detailDict valueForKey:@"text_name"];
            }
            if (title == nil) {
                title = [self.detailDict valueForKey:@"name"];
            }
            return [HQTFTaskDetailTitleCell refreshTaskDetailTitleCellHeightWithTitle:title];
        }else if (indexPath.row == 4){
            if ([self.referenceRow.field.detailView isEqualToString:@"0"]) {
                return 0;
            }
            return 44;
        }else{
            return 44;
        }
    }
    else if (indexPath.section == 2){// 校验及校验人
        if (self.checkShow) {
            return 44;
        }else{
            if (indexPath.row == 1) {
                return 0;
            }else{
                return 44;
            }
        }
    }
    else if (indexPath.section == 3){// 描述，附件，标签
        if (indexPath.row == 2) {// 描述
            if (IsStrEmpty(self.descString)) {
                return 44;
            }
            return self.descHeight;
        }
        if (indexPath.row == 3) {// 附件
            if ([self.fileRow.field.detailView isEqualToString:@"0"]) {
                return 0;
            }
           return      [TFTaskDetailFileCell refreshTaskDetailCellHeightWithFiles:self.files];
        }
        if (indexPath.row == 1) {// 标签
            if ([self.tagRow.field.detailView isEqualToString:@"0"]) {
                return 0;
            }
            return [TFTaskDetailLabelCell refreshTaskDetailLabelCellHeightWithOptions:self.labels];
        }
        if (indexPath.row == 0) {// 优先级
            if ([self.priorityRow.field.detailView isEqualToString:@"0"]) {
                return 0;
            }
            return 44;
        }
        return 44;
    }
    else if (indexPath.section == 4){//
        if (indexPath.row == 1) {// 协作人
            return [TFTaskDetailCooperationPeopleCell refreshTaskDetailCooperationPeopleCellHeightWithPeoples:self.associates];
        }
        return 44;
    }
    else if (indexPath.section == 5 + self.layouts.count){// 协作人
        if (indexPath.row == 0) {
            return 50;
        }else if (indexPath.row == 1) {
            if (self.coopShow) {
                return 60;
            }else{
                return 0;
            }
        }else{
            
            if (self.coopShow) {
                if (self.taskType == 0 || self.taskType == 1) {// 项目任务
                    
                    if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_11" role:self.role]) {
                        return 60;
                    }else{
                        return 0;
                    }
                }else{// 个人任务
                    
                    if ([self.role isEqualToString:@"0"] || [self.role isEqualToString:@"1"]) {// 创建人，执行人
                        return 60;
                    }else{
                        return 0;
                    }
                }
            }else{
                return 0;
            }
        }
        
    }
    else if (indexPath.section == 6 + self.layouts.count){// 子任务列表
        
        if (self.taskType == 0 || self.taskType == 1 || self.taskType == 2) {// 任务或个人任务
            
            if (indexPath.row == 0) {
                return 50;
            }else{
                
                if (self.childShow) {
                    
                    BOOL addChildTaskAuth = NO;
                    if (self.taskType == 0 || self.taskType == 1) {
                        
                        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_8" role:self.role]) {// 新增子任务
                            addChildTaskAuth = YES;
                        }
                        
                    }else if (self.taskType == 2){
                        addChildTaskAuth = [self.role containsString:@"0"] || [self.role containsString:@"1"];
                    }
                    CGFloat height =  [TFChildTaskListCell refreshChildTaskListCellHeightWithModels:self.childTasks add:addChildTaskAuth];
                    return height;
                }else{
                    return 0;
                }
            }
        }else{// 子任务
            return 0;
        }
        
        
    }
    else if (indexPath.section == 7 + self.layouts.count){// 关联
        if (indexPath.row == 0) {
            return 50;
        }else{
            
            if (self.relationShow) {
                if (self.taskType == 0 || self.taskType == 1) {// 项目任务
                    if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_12" role:self.role]) {
                        return [TFTaskRelationListCell refreshTaskRelationListCellHeightWithModels:self.relations type:0];
                    }else{
                        return [TFTaskRelationListCell refreshTaskRelationListCellHeightWithModels:self.relations type:1];
                    }
                }else{// 个人任务
                    
                    if ([self.role isEqualToString:@"0"] || [self.role isEqualToString:@"1"]) {
                        return [TFTaskRelationListCell refreshTaskRelationListCellHeightWithModels:self.relations type:0];
                    }else{
                        return [TFTaskRelationListCell refreshTaskRelationListCellHeightWithModels:self.relations type:1];
                    }
                }
            }else{
                return 0;
            }
        }
        
    }
    else if (indexPath.section == 8 + self.layouts.count){// 被关联
        
        if (self.taskType == 0 || self.taskType == 2) {// 任务
            
            if (indexPath.row == 0) {
                return 50;
            }else{
                if (self.beRelatedShow) {
                    
                    CGFloat height =  [TFTaskRelationListCell refreshTaskRelationListCellHeightWithModels:self.byRelations type:1];
                    return height;
                }else{
                    return 0;
                }
            }
        }else{// 子任务
            return 0;
        }
        
    }
    else if (indexPath.section == 9 + self.layouts.count){// 点赞
        return 50;
        
    }
    else if (indexPath.section == 10 + self.layouts.count){// 检验
        
        if ([[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"] && [[self.detailDict valueForKey:@"check_status"] isEqualToString:@"1"]  && [[self.detailDict valueForKey:@"passed_status"] isEqualToString:@"0"] && [[[self.detailDict valueForKey:@"check_member"] description] isEqualToString:[UM.userLoginInfo.employee.id description]]) {
            
            return 50;
        }else{
            return 0;
        }
        
    }
    else{// 任务自定义
        
        
        TFCustomerLayoutModel *layout = self.layouts[indexPath.section-5];
        TFCustomerRowsModel *model = layout.rows[indexPath.row];
        TFCustomerFieldModel *field = model.field;
        
        // 1. 不显示某组
        if ([layout.terminalApp isEqualToString:@"0"]) {
            
            return 0;
        }
        
        // 新建or编辑不显示系统信息
        if (self.type != 1) {
            if ([layout.name isEqualToString:@"systemInfo"]) {
                return 0;
            }
        }
        
        if (self.type == 1) {// 详情时显示
            if ([layout.isHideInDetail isEqualToString:@"1"]) {
                return 0;
            }
        }else{// 新建or编辑
            if ([layout.isHideInCreate isEqualToString:@"1"]) {
                return 0;
            }
        }
        
        if ([field.terminalApp isEqualToString:@"0"]) {
            
            return 0;
        }
        
        // 3. 属性决定的不显示
        if (self.type == 0 || self.type == 3) {// 新增
            
            if ([field.addView isEqualToString:@"0"]) {
                
                return 0;
            }
            
        }
        
        if (self.type == 1) {// 详情
            
            if ([field.detailView isEqualToString:@"0"]) {
                
                return 0;
            }
            
        }
        if (self.type == 2 || self.type == 7) {// 编辑
            
            if ([field.editView isEqualToString:@"0"]) {
                
                return 0;
            }
        }
        
#pragma mark - 选项字段控制隐藏
        if ([field.isOptionHidden isEqualToString:@"1"]) {
            
            return 0;
        }
        
//        if ([model.type isEqualToString:@"formula"] || [model.type isEqualToString:@"functionformula"] || [model.type isEqualToString:@"citeformula"] || [model.type isEqualToString:@"seniorformula"]) {
//            if (self.type != 1) {
//                return 0;
//            }
//        }
        
        // 4.显示多高
        if ([model.type isEqualToString:@"text"] ||
            [model.type isEqualToString:@"textarea"] ||
            [model.type isEqualToString:@"area"] ||
            [model.type isEqualToString:@"location"] ||
            [model.type isEqualToString:@"phone"] ||
            [model.type isEqualToString:@"number"] ||
            [model.type isEqualToString:@"email"] ||
            [model.type isEqualToString:@"datetime"] ||
            [model.type isEqualToString:@"url"] ||
            [model.type isEqualToString:@"reference"] ||
            [model.type isEqualToString:@"identifier"] ||
            [model.type isEqualToString:@"serialnum"] ||
            [model.type isEqualToString:@"formula"] ||
            [model.type isEqualToString:@"functionformula"] ||
            [model.type isEqualToString:@"citeformula"] ||
            [model.type isEqualToString:@"seniorformula"] ||
            [model.type isEqualToString:@"personnel"] ||
            [model.type isEqualToString:@"department"] ||
            [model.type isEqualToString:@"barcode"]) {
            
            return [TFGeneralSingleCell refreshGeneralSingleCellHeightWithModel:model];
        }
        
        if ([model.type isEqualToString:@"picklist"]){
            return [TFCustomSelectOptionCell refreshCustomSelectOptionCellHeightWithModel:model showEdit:NO]<=0?75:[TFCustomSelectOptionCell refreshCustomSelectOptionCellHeightWithModel:model showEdit:NO];
        }
        if ([model.type isEqualToString:@"mutlipicklist"]) {
//            if ([model.field.selectType isEqualToString:@"1"]) {
//                return [TFCustomSelectOptionCell refreshCustomSelectOptionCellHeightWithModel:model showEdit:NO]<=0?174:[TFCustomSelectOptionCell refreshCustomSelectOptionCellHeightWithModel:model showEdit:NO];
//            }else{
//                return [TFCustomSelectOptionCell refreshCustomSelectOptionCellHeightWithModel:model showEdit:NO]<=0?130:[TFCustomSelectOptionCell refreshCustomSelectOptionCellHeightWithModel:model showEdit:NO];
//            }
            return [TFCustomSelectOptionCell refreshCustomSelectOptionCellHeightWithModel:model showEdit:NO]<=0?75:[TFCustomSelectOptionCell refreshCustomSelectOptionCellHeightWithModel:model showEdit:NO];
        }
        
        if ([model.type isEqualToString:@"attachment"] || [model.type isEqualToString:@"resumeanalysis"]) {
            return [TFCustomAttachmentsCell refreshCustomAttachmentsCellHeightWithModel:model type:self.type == 1?AttachmentsCellDetail:AttachmentsCellEdit]<75?75:[TFCustomAttachmentsCell refreshCustomAttachmentsCellHeightWithModel:model type:self.type == 1?AttachmentsCellDetail:AttachmentsCellEdit];
        }
        if ([model.type isEqualToString:@"multi"]) {
//            return [TFCustomMultiSelectCell refreshCustomMultiSelectCellHeightWithModel:model];
            
            return [TFCustomSelectOptionCell refreshCustomSelectOptionCellHeightWithModel:model showEdit:NO]<=0?75:[TFCustomSelectOptionCell refreshCustomSelectOptionCellHeightWithModel:model showEdit:NO];
        }
        if ([model.type isEqualToString:@"subform"]) {
            return [TFTCustomSubformHeaderCell refreshCustomSubformHeaderCellHeightWithModel:model];
        }
        if ([model.type isEqualToString:@"picture"]) {
            return [TFCustomImageCell refreshCustomImageHeightWithModel:model withType:self.type != 1 ? 1 :0 withColumn:6];
        }
        if ([model.type isEqualToString:@"multitext"]) {
            return [model.height floatValue]<150?150:[model.height floatValue];
        }
        if ([model.type isEqualToString:@"checkbox"]) {
            return 44;
        }
        
        // 剩余组件
        return 75;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    if (section == 0) {
        if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
            return 0.5;
        }
        return 0;
    }else if (section == 1) {
        if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
            return 0.5;
        }
        return 0;
    }else if (section == 2) {
        if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
            return 0.5;
        }
        return 0;
    }else if (section == 3) {
        if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
            return 0.5;
        }
        return 0;
    }else if (section == 4) {
        if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
            return 0.5;
        }
        return 0;
    }else if (5 + self.layouts.count == section){// 协作人
        if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
            return 0.5;
        }
        return 0;
    }else if (6 + self.layouts.count == section){// 子任务
//        if (self.taskType == 0 || self.taskType == 2) {// 任务或个人任务
//            return 8;
//        }else{// 子任务
//            if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
//                return 0.5;
//            }
//            return 0;
//        }
        return 48;
    }else if (7 + self.layouts.count == section){// 关联
        if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
            return 0.5;
        }
        return 0;
    }else if (8 + self.layouts.count == section){// 被关联
        if (self.taskType == 0 || self.taskType == 2) {// 任务
            if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                return 0.5;
            }
            return 0;
        }else{// 子任务
            if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                return 0.5;
            }
            return 0;
        }
    }else if (9 + self.layouts.count == section){// 点赞
        if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
            return 0.5;
        }
        return 0;
    }else if (section == 10 + self.layouts.count){// 检验
        if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
            return 0.5;
        }
        return 0;
    }else{// 自定义
        
        TFCustomerLayoutModel *layout = self.layouts[section-5];
        // app权限
        if ([layout.terminalApp isEqualToString:@"0"]) {
            
            if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                return 0.5;
            }
            return 0;
        }
        
        if (!layout.isHideColumnName || [layout.isHideColumnName isEqualToString:@"1"]) {
            
            if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                return 0.5;
            }
            return 0;
        }
        
        if ([layout.isSpread isEqualToString:@"1"]) {
            
            if ([layout.show isEqualToString:@"1"]) {
                return 48;
            }
            if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                return 0.5;
            }
            return 0;
        }
        
        // 新建or编辑不显示系统信息
        if (self.type != 1) {
            if ([layout.name isEqualToString:@"systemInfo"]) {
                if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                    return 0.5;
                }
                return 0;
            }
        }
        if (self.type == 1) {// 详情时显示
            if ([layout.isHideInDetail isEqualToString:@"1"]) {
                if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                    return 0.5;
                }
                return 0;
            }
        }else{// 新建or编辑
            if ([layout.isHideInCreate isEqualToString:@"1"]) {
                if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                    return 0.5;
                }
                return 0;
            }
        }
#pragma mark - 选项字段控制头部是否隐藏
        if ([layout.isOptionHidden isEqualToString:@"1"]) {
            if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                return 0.5;
            }
            return 0;
        }
        
        
        // 增加栏目
        if ([layout.virValue isEqualToString:@"2"]) {
            if (self.type != 1) {
                return 40;
            }else{
                if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                    return 0.5;
                }
                return 0;
            }
        }
       
        // 分栏
        if ([layout.virValue isEqualToString:@"0"]) {
            return 48;
        }
        // 栏目几
        if ([layout.virValue isEqualToString:@"1"] && layout.rows != nil) {
            return 40;
        }
        
        if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
            return 0.5;
        }
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 4) {
        if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
            return 0.5;
        }
        return 0;
    }else if (section == 10 + self.layouts.count){// 检验人
        return 40;
    }
    if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
        return 0.5;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }else if (section == 1) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }else if (section == 2) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }else if (section == 3) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }else if (section == 4) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }else if (5 + self.layouts.count == section){// 协作人
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }else if (6 + self.layouts.count == section){// 子任务
        
        TFColumnView *view = [TFColumnView columnView];
        view.tag = 0x4455 + section;
        view.titleLebel.text = @"其他信息";
        view.spreadBtn.hidden = YES;
        return view;
    }else if (7 + self.layouts.count == section){// 关联
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }else if (8 + self.layouts.count == section){// 被关联
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }else if (9 + self.layouts.count == section){// 点赞
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }else if (section == 10 + self.layouts.count){// 检验
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
        
    }else{// 自定义
        
        TFCustomerLayoutModel *layout = self.layouts[section-5];
        // app权限
        if ([layout.terminalApp isEqualToString:@"0"]) {
            
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            return view;
        }
        // 新建or编辑不显示系统信息
        if (self.type != 1) {
            if ([layout.name isEqualToString:@"systemInfo"]) {
                
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor clearColor];
                return view;
            }
        }
        if (self.type == 1) {// 详情时显示
            if ([layout.isHideInDetail isEqualToString:@"1"]) {
                
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor clearColor];
                return view;
            }
            
        }else{// 新建or编辑
            if ([layout.isHideInCreate isEqualToString:@"1"]) {
                
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor clearColor];
                return view;
            }
            
        }
        
        
        if ([layout.virValue isEqualToString:@"0"]) {
            
            TFColumnView *view = [TFColumnView columnView];
            view.isSpread = layout.isSpread;
            view.tag = 0x4455 + section;
            view.delegate = self;
            view.titleLebel.text = layout.title;
            [view.spreadBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [view.spreadBtn setTitleColor:GreenColor forState:UIControlStateNormal];
            [view.spreadBtn setImage:nil forState:UIControlStateNormal];
            [view.spreadBtn setImage:nil forState:UIControlStateSelected];
            
            if (self.taskType == 0) {// 主任务
                // 判断编辑任务权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_1" role:self.role]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        view.spreadBtn.hidden = NO;
                    }else{
                        view.spreadBtn.hidden = YES;
                    }
                }else{
                    view.spreadBtn.hidden = YES;
                }
            }else if (self.taskType == 1){// 子任务
                
                // 判断编辑子任务权限
                if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_9" role:self.role]) {
                    
                    if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                        view.spreadBtn.hidden = NO;
                    }else{
                        view.spreadBtn.hidden = YES;
                    }
                }else{
                    view.spreadBtn.hidden = YES;
                }
            }
            
            if (self.type != 1) {
                
                if ([layout.isHideColumnName isEqualToString:@"1"]) {
                    view.titleLebel.hidden = YES;
                }else{
                    view.titleLebel.hidden = NO;
                }
            }else{
                
                view.titleLebel.hidden = NO;
            }
            return view;
        }
        
        if ([layout.virValue isEqualToString:@"1"]) {
            
            TFSubformSectionView *view = [TFSubformSectionView subformSectionView];
            view.tag = 0x888 + section;
            view.titleLabel.text = [NSString stringWithFormat:@"栏目%ld",(long)[layout.position integerValue]];
            view.delegate = self;
            view.isEdit = self.type != 1 ? YES : NO;
            return view;
            
        }
        
        if ([layout.virValue isEqualToString:@"2"]) {
            
            TFSubformAddView *view = [TFSubformAddView subformAddView];
            view.tag = 0x999 + section;
            view.delegate = self;
            return view;
            
        }
        
        
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 10 + self.layouts.count){// 检验人
        
        return self.commentTabBar;
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView.tag == 0x222) {
        [self.keyboard hideKeyBoard];
    }
}

#pragma mark - TFTaskDetailCooperationCellDelegate
-(void)taskDetailCooperationCellHandleSwitchBtn:(UISwitch *)switchBtn{
    
    if (self.project_status && ![self.project_status isEqualToString:@"0"]) {
        if ([self.project_status isEqualToString:@"1"]) {// 归档
            
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.project_status isEqualToString:@"2"]) {// 暂停
            
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [switchBtn setOn:!switchBtn.on animated:YES];
        });
        return;
    }
    
    
    if (self.taskType == 0 || self.taskType == 1) {// 项目任务主和子
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_11" role:self.role]) {
            
            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                if (self.taskType == 0 || self.taskType == 1) {// 项目任务主和子
                    if (switchBtn.on) {
                        [self.projectTaskBL requsetTaskVisibleWithTaskId:self.dataId associatesStatus:@1 taskType:@(self.taskType+1)];
                    }else{
                        [self.projectTaskBL requsetTaskVisibleWithTaskId:self.dataId associatesStatus:@0 taskType:@(self.taskType+1)];
                    }
                    self.coopShow = switchBtn.on;
                }
            }else{
                [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [switchBtn setOn:!switchBtn.on animated:YES];
                });
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [switchBtn setOn:!switchBtn.on animated:YES];
            });
        }
    }else{
        
        if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
            
            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                if (self.taskType == 2 || self.taskType == 3) {// 项目任务主和子
                    
                    if (switchBtn.on) {
                        [self.projectTaskBL requsetPersonnelTaskVisibleWithTaskId:self.dataId participantsOnly:@1 fromType:self.taskType == 2 ? @0 : @1];
                    }else{
                        [self.projectTaskBL requsetPersonnelTaskVisibleWithTaskId:self.dataId participantsOnly:@0 fromType:self.taskType == 2 ? @0 : @1];
                    }
                    self.coopShow = switchBtn.on;
                }
            }else{
                [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [switchBtn setOn:!switchBtn.on animated:YES];
                });
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [switchBtn setOn:!switchBtn.on animated:YES];
            });
        }
    }
    
    
}

#pragma mark - TFTaskDetailHandleCellDelegate
-(void)addStartTime{
    
    
    if (self.taskType == 0) {// 主任务
        
        // 判断编辑任务权限
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_1" role:self.role]) {
            
            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                
                [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDayHourMinute timeSp:self.startTime<=0?[HQHelper getNowTimeSp]:self.startTime onRightTouched:^(NSString *time) {
                    
                    if (self.endTime != 0 && [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"] > self.endTime) {
                        [MBProgressHUD showError:@"截止时间不可小于开始时间" toView:self.view];
                        return ;
                    }
                    self.startTime = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"];
                    [self.tableView reloadData];
                    // 编辑任务
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                    
                }];
            }else{
                [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
        }
    }
    else if (self.taskType == 1){// 子任务
        
        // 判断编辑任务权限
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_9" role:self.role]) {
            
            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                
                [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDayHourMinute timeSp:self.startTime<=0?[HQHelper getNowTimeSp]:self.startTime onRightTouched:^(NSString *time) {
                    
                    if (self.endTime != 0 && [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"] > self.endTime) {
                        [MBProgressHUD showError:@"截止时间不可小于开始时间" toView:self.view];
                        return ;
                    }
                    self.startTime = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"];
                    [self.tableView reloadData];
                    // 编辑任务
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
                    
                }];
                
            }else{
                [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
        }
    }
    else {// 个人子任务
        
        // 判断编辑任务权限
        if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
            
            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                
                [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDayHourMinute timeSp:self.startTime<=0?[HQHelper getNowTimeSp]:self.startTime onRightTouched:^(NSString *time) {
                    
                    if (self.endTime != 0 && [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"] > self.endTime) {
                        [MBProgressHUD showError:@"截止时间不可小于开始时间" toView:self.view];
                        return ;
                    }
                    self.startTime = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"];
                    [self.tableView reloadData];
                    // 编辑任务
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    if (self.taskType == 2) {// 个人主任务
                        [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                    }else{// 个人子任务
                        [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
                    }
                }];
            }else{
                [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
        }
    }
    
}
-(void)addEndTime{
    
    
    if (self.taskType == 0) {// 主任务
        
        // 判断编辑任务权限
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_1" role:self.role]) {
            
            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                
                if ([self.project_time_status isEqualToString:@"1"]) {// 需要判断能否修改截止时间
                    
//                    if (self.endTime != [[self.oldData valueForKey:@"datetime_deadline"] longLongValue]) {
                    
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改截止时间原因" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        alert.delegate = self;
                        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                        alert.tag = 0x4477;
                        [alert show];
                        
//                    }
                }else{
                    
                    [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDayHourMinute timeSp:self.endTime<=0?[HQHelper getNowTimeSp]:self.endTime onRightTouched:^(NSString *time) {
                        
                        if ([HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"] < [HQHelper getNowTimeSp]) {
                            [MBProgressHUD showError:@"截止时间不可小于当前时间" toView:self.view];
                            return ;
                        }
                        
                        self.endTime = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"];
                        [self.tableView reloadData];
                        // 编辑任务
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                        
                    }];
                }
            }else{
                [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
        }
    }
    else if (self.taskType == 1){// 子任务
        
        // 判断编辑任务权限
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_9" role:self.role]) {
            
            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                
                if ([self.project_time_status isEqualToString:@"1"]) {// 需要判断能否修改截止时间
                    
//                    if (self.endTime != [[self.oldData valueForKey:@"datetime_deadline"] longLongValue]) {
                    
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改截止时间原因" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        alert.delegate = self;
                        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                        alert.tag = 0x4477;
                        [alert show];
                        
//                    }
                }else{
                    
                    [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDayHourMinute timeSp:self.endTime<=0?[HQHelper getNowTimeSp]:self.endTime onRightTouched:^(NSString *time) {
                        
                        if ([HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"] < [HQHelper getNowTimeSp]) {
                            [MBProgressHUD showError:@"截止时间不可小于当前时间" toView:self.view];
                            return ;
                        }
                        
                        self.endTime = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"];
                        [self.tableView reloadData];
                        // 编辑任务
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
                        
                        
                    }];
                }
                
            }else{
                [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
        }
    }
    else  {// 个人任务
        
        // 判断编辑任务权限
        if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
            
            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                
                [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDayHourMinute timeSp:self.endTime<=0?[HQHelper getNowTimeSp]:self.endTime onRightTouched:^(NSString *time) {
                    
                    if ([HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"] < [HQHelper getNowTimeSp]) {
                        [MBProgressHUD showError:@"截止时间不可小于当前时间" toView:self.view];
                        return ;
                    }
                    
                    self.endTime = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"];
                    [self.tableView reloadData];
                    // 编辑任务
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    if (self.taskType == 2) {// 主任务
                        [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                    }else{// 子任务
                        [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
                    }
                    
                }];
            }else{
                [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
        }
    }
    
}
#pragma mark - TFTaskDetailCheckCellDelegate
-(void)taskDetailCheckCellHandleSwicth:(UISwitch *)switchBtn{
    
    if (self.project_status && ![self.project_status isEqualToString:@"0"]) {
        if ([self.project_status isEqualToString:@"1"]) {// 归档
            
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.project_status isEqualToString:@"2"]) {// 暂停
            
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [switchBtn setOn:!switchBtn.on animated:YES];
        });
        return;
    }
    
    if (self.taskType == 0) {// 主
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_1" role:self.role]) {
            
            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                
                if (switchBtn.on) {
                    
                    TFProjectMenberManageController *member = [[TFProjectMenberManageController alloc] init];
                    member.type = 1;
                    member.projectId = self.projectId;
                    if (self.checkPeople) {
                        member.selectPeoples = @[self.checkPeople];
                    }
                    member.parameterAction = ^(NSArray *parameter) {
                        
                        
                        if (parameter.count) {
                            self.checkShow = switchBtn.on;
                            
                            self.checkPeople = parameter.firstObject;
                            [self.tableView reloadData];
                            
                            // 编辑任务
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                            
                        }
                    };
                    [self.navigationController pushViewController:member animated:YES];
                }else{
                    self.checkShow = switchBtn.on;
                    self.checkPeople = nil;
    
                    [self.tableView beginUpdates];
                    [self.tableView endUpdates];
                    // 编辑主任务
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                }
                
                
            }else{
                [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [switchBtn setOn:!switchBtn.on animated:YES];
                });
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [switchBtn setOn:!switchBtn.on animated:YES];
            });
        }
        
    }else if (self.taskType == 1){// 子
        
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_9" role:self.role]) {
            
            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                
                self.checkShow = switchBtn.on;
                
                [self.tableView beginUpdates];
                [self.tableView endUpdates];
                // 编辑子任务
//                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
                
            }else{
                [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [switchBtn setOn:!switchBtn.on animated:YES];
                });
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [switchBtn setOn:!switchBtn.on animated:YES];
            });
        }
        
    }
    
    
}
#pragma mark - TFTaskDetailDescCellDelegate
-(void)taskDetailDescCellHeightChange:(CGFloat)height{
    self.descHeight = height;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)taskDetailDescCel:(TFTaskDetailDescCell *)cell didClickedImage:(NSURL *)url{
    
    [self.images removeAllObjects];
    
    TFFileModel *file = [[TFFileModel alloc] init];
    file.file_url = [url absoluteString];
    [self.images addObject:file];
    
    [self didLookAtPhotoActionWithIndex:0];
    
}

#pragma mark - TFTaskDetailFileCellDelegate
-(void)addfileClickedWithCell:(TFTaskDetailFileCell *)cell{
    
    
    if (self.taskType == 0) {// 主任务
        
        // 判断编辑任务权限
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_1" role:self.role]) {
            
            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                
                self.isFile = YES;// 上传附件
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上传附件" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"选择文件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self pushFileLibray];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self openAlbum];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self openCamera];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
        }
    }
    else if (self.taskType == 1){// 子任务
        
        // 判断编辑任务权限
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_9" role:self.role]) {
            
            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                
                self.isFile = YES;// 上传附件
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上传附件" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"选择文件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self pushFileLibray];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self openAlbum];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self openCamera];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }else{
                [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
        }
    }
    else {// 个人任务
        
        // 判断编辑任务权限
        if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
            
            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                
                self.isFile = YES;// 上传附件
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上传附件" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"选择文件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self pushFileLibray];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self openAlbum];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self openCamera];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
        }
    }
    
}
-(void)deletefileWithIndex:(NSInteger)index{
    
    
    if (self.taskType == 0) {// 主任务
        
        // 判断编辑任务权限
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_1" role:self.role]) {
            
            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                
                [self.files removeObjectAtIndex:index];
                [self.tableView reloadData];
                // 编辑任务
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
                
            }else{
                [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
        }
    }
    else if (self.taskType == 1){// 子任务
        
        // 判断编辑任务权限
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_9" role:self.role]) {
            
            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                
                [self.files removeObjectAtIndex:index];
                [self.tableView reloadData];
                // 编辑任务
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
                
            }else{
                [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
        }
    }
    else {// 个人任务
        
        // 判断编辑任务权限
        if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
            
            if (![[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
                
                [self.files removeObjectAtIndex:index];
                [self.tableView reloadData];
                
                // 编辑任务
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
               if (self.taskType == 2){
                    [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
                }else{
                    [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
                }
            }else{
                [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
        }
    }
    
}


-(void)lookWithCell:(TFTaskDetailFileCell *)cell didClickedFile:(TFFileModel *)model index:(NSInteger)index{
    
    if ([[model.file_type lowercaseString] isEqualToString:@"jpg"] || [[model.file_type lowercaseString] isEqualToString:@"png"] || [[model.file_type lowercaseString] isEqualToString:@"gif"] || [[model.file_type lowercaseString] isEqualToString:@"jpeg"]) {// 查看图片
        
        
        [self.images removeAllObjects];
        [self.images addObject:model];
        
//        for (TFFileModel *model in rows.selects) {
//
//            if ([model.file_type integerValue] == 0) {
//
//                [self.images addObject:model];
//            }
//        }
        
        [self didLookAtPhotoActionWithIndex:index];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"doc"] ||
              [[model.file_type lowercaseString] isEqualToString:@"docx"] ||
              [[model.file_type lowercaseString] isEqualToString:@"xls"] ||
              [[model.file_type lowercaseString] isEqualToString:@"xlsx"] ||
              [[model.file_type lowercaseString] isEqualToString:@"ppt"] ||
              [[model.file_type lowercaseString] isEqualToString:@"pptx"] ||
              [[model.file_type lowercaseString] isEqualToString:@"ai"] ||
              [[model.file_type lowercaseString] isEqualToString:@"cdr"] ||
              [[model.file_type lowercaseString] isEqualToString:@"dwg"] ||
              [[model.file_type lowercaseString] isEqualToString:@"ps"] ||
              [[model.file_type lowercaseString] isEqualToString:@"txt"] ||
              [[model.file_type lowercaseString] isEqualToString:@"zip"] ||
              [[model.file_type lowercaseString] isEqualToString:@"rar"] ||
              [[model.file_type lowercaseString] isEqualToString:@"pdf"]){
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HQHelper cacheFileWithUrl:model.file_url fileName:model.file_name completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error == nil) {
                
                // 保存文件
                NSString *filePath = [HQHelper saveCacheFileWithFileName:model.file_name data:data];
                
                if (filePath) {// 写入成功
                    
                    UIDocumentInteractionController *ctrl = [UIDocumentInteractionController  interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
                    ctrl.delegate = self;
                    [ctrl presentPreviewAnimated:YES];
                }
            }else{
                [MBProgressHUD showError:@"读取文件失败" toView:self.view];
            }
            
        } fileHandler:^(NSString *path) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIDocumentInteractionController *ctrl = [UIDocumentInteractionController  interactionControllerWithURL:[NSURL fileURLWithPath:path]];
            ctrl.delegate = self;
            [ctrl presentPreviewAnimated:YES];
        }];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"mp3"]){
        
        
        TFPlayVoiceController *play = [[TFPlayVoiceController alloc] init];
        play.file = model;
        [self.navigationController pushViewController:play animated:YES];
        
    }else{
        
        [MBProgressHUD showError:@"未知文件无法预览" toView:self.view];
    }
}

#pragma mark - TFGeneralSingleCellDelegate
-(void)generalSingleCell:(TFGeneralSingleCell *)cell changedHeight:(CGFloat)height{
    if (cell.textView.isFirstResponder) {
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}
-(void)generalSingleCellDidClickedRightBtn:(UIButton *)rightBtn{
    
    NSInteger section = rightBtn.tag / 0x777;
    NSInteger row = rightBtn.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *model = layout.rows[row];
    
    if ([model.type isEqualToString:@"text"] || [model.type isEqualToString:@"identifier"] || [model.type isEqualToString:@"serialnum"]) {// 单行文本
        
        TFCustomSearchController  *search = [[TFCustomSearchController alloc] init];
        search.keyLabel = model.label;
        search.bean = self.bean;
        search.keyWord = model.fieldValue;
        search.searchMatch = model.name;
        search.searchType = 1;
        search.dataId = self.dataId;
        search.processId = self.customModel.processId;
        search.parameterAction = ^(id parameter) {
            
            
        };
        [self.navigationController pushViewController:search animated:YES];
        
    }
    if ([model.type isEqualToString:@"phone"]) {// 电话
        
        if (self.type != 1) {
            
            TFCustomSearchController  *search = [[TFCustomSearchController alloc] init];
            search.keyLabel = model.label;
            search.bean = self.bean;
            search.keyWord = model.fieldValue;
            search.searchMatch = model.name;
            search.searchType = 1;
            search.dataId = self.dataId;
            search.processId = self.customModel.processId;
            search.parameterAction = ^(id parameter) {
                
                
            };
            [self.navigationController pushViewController:search animated:YES];
        }else{
            
            NSString *tele = [model.fieldValue stringByReplacingOccurrencesOfString:@" " withString:@""];
            tele = [tele stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",tele];
            
            UIWebView *callWebview = [[UIWebView alloc]init];
            
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            
            [self.view addSubview:callWebview];
        }
        
    }
    
    if ([model.type isEqualToString:@"email"]) {// 邮件
        self.attachmentModel = model;
        if (self.type != 1) {
            TFCustomSearchController  *search = [[TFCustomSearchController alloc] init];
            search.keyLabel = model.label;
            search.bean = self.bean;
            search.keyWord = model.fieldValue;
            search.searchMatch = model.name;
            search.searchType = 1;
            search.dataId = self.dataId;
            search.processId = self.customModel.processId;
            search.parameterAction = ^(id parameter) {
                
                
            };
            [self.navigationController pushViewController:search animated:YES];
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:model.fieldValue delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
            alert.delegate = self;
            alert.tag = 0x9876;
            [alert show];
//
//            TFEmailsNewController *newEmail = [[TFEmailsNewController alloc] init];
//            TFEmailReceiveListModel *ee = [[TFEmailReceiveListModel alloc] init];
//            ee.from_recipient = UM.userLoginInfo.employee.email;
//            TFEmailPersonModel *em = [[TFEmailPersonModel alloc] init];
//            em.mail_account = model.fieldValue;
//            ee.to_recipients = [NSMutableArray <TFEmailPersonModel,Optional>arrayWithObject:em];
//            newEmail.detailModel = ee;
//            [self.navigationController pushViewController:newEmail animated:YES];
            
        }
        
    }
    
    if ([model.type isEqualToString:@"barcode"]) {
        self.attachmentModel = model;
        if (self.type != 1) {// 扫一扫
            
            TFScanCodeController *scan = [[TFScanCodeController alloc] init];
            scan.style = [StyleDIY weixinStyle];
            scan.isOpenInterestRect = YES;
            scan.libraryType = SLT_ZXing;
            scan.scanCodeType = SCT_QRCode;
            //镜头拉远拉近功能
            scan.isVideoZoom = YES;
            scan.isNeedScanImage = YES;
            scan.scanAction = ^(NSString *parameter) {
                
                model.fieldValue = parameter;
                [self.tableView reloadData];
            };
            
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:scan];
            navi.modalPresentationStyle = UIModalPresentationFullScreen;

            [self presentViewController:navi animated:YES completion:nil];
            
        }else{// 查看条形码
            
            if (!IsStrEmpty(model.fieldValue)) {// 不为空
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.customBL requestBarcodePictureWithBean:self.bean barcodeValue:model.fieldValue];
            }
        }
        
        if ([model.type isEqualToString:@"location"]) {// 定位
            
            if (self.type != 1) {
                
                TFMapController *locationVc = [[TFMapController alloc] init];
                locationVc.type = LocationTypeSearchLocation;
                locationVc.keyword = model.fieldValue;
                if (model.otherDict) {
                    
                    locationVc.location = CLLocationCoordinate2DMake([[model.otherDict valueForKey:@"latitude"] doubleValue], [[model.otherDict valueForKey:@"longitude"] doubleValue]);
                }
                locationVc.locationAction = ^(TFLocationModel *parameter){
                    
                    if (!model.otherDict) {
                        
                        model.otherDict = [NSMutableDictionary dictionary];
                    }
                    
                    if (parameter.city) {
                        [model.otherDict setObject:parameter.city forKey:@"city"];
                    }
                    if (parameter.name) {
                        [model.otherDict setObject:parameter.name forKey:@"name"];
                    }
                    [model.otherDict setObject:@(parameter.longitude) forKey:@"longitude"];
                    [model.otherDict setObject:@(parameter.latitude) forKey:@"latitude"];
                    [model.otherDict setObject:[NSString stringWithFormat:@"%@#%@#%@",parameter.province,parameter.city,parameter.district] forKey:@"area"];
                    
                    model.fieldValue = [NSString stringWithFormat:@"%@%@%@%@",parameter.province,parameter.city,parameter.district,parameter.address];
                    [self.tableView reloadData];
                    
                    // 联动
                    [self generalSingleCellWithModel:model];
                    
                    
                };
                [self.navigationController pushViewController:locationVc animated:YES];
            }else{
                
                if (model.otherDict && [model.otherDict valueForKey:@"latitude"] && [model.otherDict valueForKey:@"longitude"]) {
                    
                    TFMapController *locationVc = [[TFMapController alloc] init];
                    locationVc.type = LocationTypeLookLocation;
                    locationVc.location = CLLocationCoordinate2DMake([[model.otherDict valueForKey:@"latitude"] doubleValue], [[model.otherDict valueForKey:@"longitude"] doubleValue]);
                    
                    [self.navigationController pushViewController:locationVc animated:YES];
                }
            }
        }
        
    }
    
}

-(void)generalSingleCellDidClickedLeftBtn:(UIButton *)leftBtn{
    
    NSInteger section = leftBtn.tag / 0x777;
    NSInteger row = leftBtn.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *model = layout.rows[row];
    
    if ([model.type isEqualToString:@"barcode"]) {// 生成条形码
        self.attachmentModel = model;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestCreateBarcodeWithBarcodeType:model.field.codeStyle barcodeValue:model.fieldValue];
    }
}

#pragma mark - TFCustomSelectOptionCellDelegate
-(void)customOptionItemCellDidClickedOptions:(NSArray *)options isSingle:(BOOL)isSingle model:(TFCustomerRowsModel *)model level:(NSInteger)level{
    
    
}
#pragma mark - TFCustomAlertViewDelegate
-(void)sureClickedWithOptions:(NSMutableArray *)options{
    
}

#pragma mark - TFCustomAttachmentsCellDelegate
- (void)deleteAttachmentsWithIndex:(NSInteger)index{
    [self.tableView reloadData];
}
- (void)addAttachmentsClickedWithCell:(TFCustomAttachmentsCell *)cell{
    
}

-(void)customAttachmentsCell:(TFCustomAttachmentsCell *)cell didClickedFile:(TFFileModel *)file index:(NSInteger)index{
    
    NSInteger section = cell.tag / 0x777;
    NSInteger row = cell.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *fileCus = layout.rows[row];
    
    [self seeFileWithFileModel:file withRows:fileCus withIndex:index];
}

#pragma mark - TFCustomImageCellDelegate
-(void)customImageCellAddImageClicked:(TFCustomImageCell *)cell withModel:(TFCustomerRowsModel *)model{
    
}
-(void)customImageCellDeleteImageClicked:(NSInteger)index{
    
    [self.tableView reloadData];
}
-(void)customImageCellSeeImageClicked:(TFCustomImageCell *)cell withModel:(TFCustomerRowsModel *)model index:(NSInteger)index{
    
    [self.images removeAllObjects];
    
    for (TFFileModel *file in model.selects) {
        
        if ([file.file_type integerValue] == 0) {
            
            [self.images addObject:file];
        }
    }
    
    [self didLookAtPhotoActionWithIndex:index];
    
}

#pragma mark - TFCustomAttributeTextCellDelegate
-(void)customAttributeTextCell:(TFCustomAttributeTextCell *)cell getWebViewHeight:(CGFloat)height{
    
//    NSInteger section = cell.tag / 0x777;
//    NSInteger row = cell.tag % 0x777;
//
//    if (section > self.layouts.count-1 ) {
//        return;
//    }
//    TFCustomerLayoutModel *layout = self.layouts[section];
//
//    if (layout.rows.count == 0 || row > layout.rows.count-1 ) {
//        return;
//    }
//    TFCustomerRowsModel *model = layout.rows[row];
//
//    if (height != [model.height floatValue]) {
//
//        model.height = [NSNumber numberWithFloat:(height < 150 ? 150 : height)];
//
//        //        [self.tableView reloadData];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
//    }
//    [self.tableView reloadData];
}

-(void)customAttributeTextCell:(TFCustomAttributeTextCell *)cell getWebViewContent:(NSString *)content{
    
    NSInteger section = cell.tag / 0x777;
    NSInteger row = cell.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *model = layout.rows[row];
    model.fieldValue = content;
    
    [self.tableView reloadData];
}

#pragma mark -TFColumnViewDelegate
-(void)columnView:(TFColumnView *)columnView isSpread:(NSString *)isSpread{
    
//    NSInteger index = columnView.tag - 0x4455;
//    TFCustomerLayoutModel *model = [self.layouts objectAtIndex:index-5];
//    model.isSpread = isSpread;
//    model.show = @"1";
//
//    for (TFCustomerLayoutModel *layout in self.layouts) {
//        if ([layout.level isEqualToString:model.level]) {
//            layout.isSpread = isSpread;
//        }
//    }
//    [self.tableView reloadData];
    
    TFAddTaskController *add = [[TFAddTaskController alloc] init];
    if (self.taskType == 0 || self.taskType == 1) {
        add.bean = [NSString stringWithFormat:@"project_custom_%@",[self.projectId description]];
        add.type = 8;
        add.dataId = [[self.detailDict valueForKey:@"customArr"] valueForKey:@"id"];// 不是任务id，布局中的id
        add.project_time_status = self.project_time_status;
        add.mainTaskEndTime = self.mainTaskEndTime;
    }else{
        add.bean = [NSString stringWithFormat:@"project_custom"];
        add.type = 9;
        add.dataId = [[self.detailDict valueForKey:@"customLayout"] valueForKey:@"id"];// 不是任务id，布局中的id
        add.mainTaskEndTime = self.mainTaskEndTime;
    }
    add.taskId = self.dataId;
    add.parentTaskId = self.parentTaskId;
    add.edit = self.taskType + 1;
    add.tableViewHeight = SCREEN_HEIGHT-NaviHeight;
    add.projectId = self.projectId;
    add.fatherRefresh = ^{
        // 刷新详情
        if (self.taskType == 0) {// 项目任务
            
            [self.projectTaskBL requestGetTaskDetailWithTaskId:self.dataId];// 任务详情
            [self.projectTaskBL requestGetChildTaskListWithTaskId:self.dataId nodeCode:self.nodeCode];// 子任务
        }
        if (self.taskType == 1) {// 项目任务子任务
            
            [self.projectTaskBL requestGetChildTaskDetailWithChildTaskId:self.dataId];// 子任务详情
            if (self.childAction) {
                self.childAction();
            }
        }
        if (self.taskType == 2) {// 个人任务
            [self.projectTaskBL requestPersonnelTaskDetailWithTaskId:self.dataId];// 个人任务详情
            [self.projectTaskBL requestGetPersonnelChildTaskListWithTaskId:self.dataId];// 子任务
        }
        if (self.taskType == 3) {// 个人任务子任务
            [self.projectTaskBL requestPersonnelSubTaskDetailWithTaskId:self.dataId];// 个人任务子任务详情
            if (self.childAction) {
                self.childAction();
            }
        }
    };
    [self.navigationController pushViewController:add animated:YES];
    
}


#pragma mark - TFSubformSectionViewDelegate
-(void)subformSectionView:(TFSubformSectionView *)subformSectionView didClickedDeleteBtn:(UIButton *)button{
    
}
#pragma mark - TFSubformAddViewDelegate
-(void)subformAddView:(TFSubformAddView *)subformAddView didClickedAddBtn:(UIButton *)button{
    
}

#pragma mark - TFSubformHeadCellDelegate
-(void)subformHeadCell:(TFSubformHeadCell *)subformHeadCell didClickedAddButton:(UIButton *)button{
    
}

#pragma mark - TFTImageLabelImageCellDelegate
-(void)imageLabelImageCellDidClickedNamePosition:(NSInteger)position{
    
    
    
}

#pragma mark - TFFileElementCellDelegate

-(void)fileElementCell:(TFFileElementCell *)fileElementCell didClickedFile:(TFFileModel *)file index:(NSInteger)index{
    
    
    NSInteger section = fileElementCell.tag / 0x345;
    NSInteger row = fileElementCell.tag % 0x345;
    
    TFCustomerLayoutModel *layout = self.layouts[section-5];
    TFCustomerRowsModel *fileCus = layout.rows[row];
    
    
    [self seeFileWithFileModel:file withRows:fileCus withIndex:index];
    
}
/** 查看文件 */
-(void)seeFileWithFileModel:(TFFileModel *)model withRows:(TFCustomerRowsModel *)rows withIndex:(NSInteger)index{
    
    if ([[model.file_type lowercaseString] isEqualToString:@"jpg"] || [[model.file_type lowercaseString] isEqualToString:@"png"] || [[model.file_type lowercaseString] isEqualToString:@"gif"] || [[model.file_type lowercaseString] isEqualToString:@"jpeg"]) {// 查看图片
        
        
        [self.images removeAllObjects];
        
        for (TFFileModel *model in rows.selects) {
            
            if ([model.file_type integerValue] == 0) {
                
                [self.images addObject:model];
            }
        }
        
        [self didLookAtPhotoActionWithIndex:index];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"doc"] ||
              [[model.file_type lowercaseString] isEqualToString:@"docx"] ||
              [[model.file_type lowercaseString] isEqualToString:@"xls"] ||
              [[model.file_type lowercaseString] isEqualToString:@"xlsx"] ||
              [[model.file_type lowercaseString] isEqualToString:@"ppt"] ||
              [[model.file_type lowercaseString] isEqualToString:@"pptx"] ||
              [[model.file_type lowercaseString] isEqualToString:@"ai"] ||
              [[model.file_type lowercaseString] isEqualToString:@"cdr"] ||
              [[model.file_type lowercaseString] isEqualToString:@"dwg"] ||
              [[model.file_type lowercaseString] isEqualToString:@"ps"] ||
              [[model.file_type lowercaseString] isEqualToString:@"txt"] ||
              [[model.file_type lowercaseString] isEqualToString:@"zip"] ||
              [[model.file_type lowercaseString] isEqualToString:@"rar"] ||
              [[model.file_type lowercaseString] isEqualToString:@"pdf"]){
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HQHelper cacheFileWithUrl:model.file_url fileName:model.file_name completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error == nil) {
                
                // 保存文件
                NSString *filePath = [HQHelper saveCacheFileWithFileName:model.file_name data:data];
                
                if (filePath) {// 写入成功
                    
                    UIDocumentInteractionController *ctrl = [UIDocumentInteractionController  interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
                    ctrl.delegate = self;
                    [ctrl presentPreviewAnimated:YES];
                }
            }else{
                [MBProgressHUD showError:@"读取文件失败" toView:self.view];
            }
            
        } fileHandler:^(NSString *path) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIDocumentInteractionController *ctrl = [UIDocumentInteractionController  interactionControllerWithURL:[NSURL fileURLWithPath:path]];
            ctrl.delegate = self;
            [ctrl presentPreviewAnimated:YES];
        }];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"mp3"]){
        
        
        TFPlayVoiceController *play = [[TFPlayVoiceController alloc] init];
        play.file = model;
        [self.navigationController pushViewController:play animated:YES];
        
    }else{
        
        [MBProgressHUD showError:@"未知文件无法预览" toView:self.view];
    }
}

-(void)fileElementCellDidDeleteFile:(TFFileElementCell *)fileElementCell withIndex:(NSInteger)index{
    
    NSInteger section = fileElementCell.tag / 0x345;
    NSInteger row = fileElementCell.tag % 0x345;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *fileCus = layout.rows[row];
    
    [fileCus.selects removeObjectAtIndex:index];
    
    [self.tableView reloadData];
}


- (void)didLookAtPhotoActionWithIndex:(NSInteger)index{
    
    // 浏览图片
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO; // 分享按钮,默认是
    browser.alwaysShowControls = NO ; // 控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = YES; // 是否全屏,默认是
    browser.enableSwipeToDismiss = NO;
    [browser showNextPhotoAnimated:NO];
    [browser showPreviousPhotoAnimated:NO];
    [browser setCurrentPhotoIndex:index];
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.autoPlayOnAppear = NO;
    [self.navigationController pushViewController:browser animated:YES] ;
}
#pragma mark - 图片浏览器

/**
 * 标题
 */
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index{
    return [NSString stringWithFormat:@"%ld/%ld",index+1,self.images.count] ;
}

/**
 * 图片总数量
 */
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.images.count;
}

/**
 * 图片设置
 */
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    TFFileModel *model = self.images[index];
    MWPhoto *mwPhoto = nil;
    
    if (model.image) {
        mwPhoto = [MWPhoto photoWithImage:model.image];
    }else{
        mwPhoto = [MWPhoto photoWithURL:[HQHelper URLWithString:model.file_url]];
    }
    
    return mwPhoto;
    
}

#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

//可选的2个代理方法 （主要是调整预览视图弹出时候的动画效果，如果不实现，视图从底部推出）
- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    return self.view.frame;
}



#pragma mark - TFImgDoubleLalImgCellDelegate
-(void)cellDidClickedFirstBtn{
    
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
        if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"27"]) {
            [MBProgressHUD showError:@"无权限点赞" toView:self.view];
            return;
        }
    }
    
    BOOL contain = NO;
    
    for (HQEmployModel *model in self.peoples) {
        NSNumber *ID = UM.userLoginInfo.employee.id;
        if ([model.id isEqualToNumber:ID]) {
            contain = YES;
            break;
        }
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.taskType == 0 || self.taskType == 1) {
        
        [self.projectTaskBL requestTaskHeartWithTaskId:self.dataId status:contain?@0:@1 typeStatus:@(self.taskType + 1)];
    }else{
        
        [self.projectTaskBL requestPersonnelTaskHeartWithTaskId:self.dataId fromType:self.taskType == 2 ?@0:@1 status:contain?@0:@1];
    }
}

#pragma mark - HQTFTaskDetailTitleCellDelegate
-(void)taskDetailTitleCell:(HQTFTaskDetailTitleCell *)taskDetailTitleCell didCheckBtn:(UIButton *)checkBtn withModel:(TFProjTaskModel *)model{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"校验意见" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"驳回",@"通过", nil];
    alert.delegate = self;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *filed = [alert textFieldAtIndex:0];
    filed.placeholder = @"请输入校验意见（必填）";
    alert.tag = 0x333;
    [alert show];
}

-(void)taskDetailTitleCell:(HQTFTaskDetailTitleCell *)taskDetailTitleCell didFinishBtn:(UIButton *)finishBtn withModel:(TFProjTaskModel *)model{
    
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
    }
    
    if ([[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
        
        if (self.taskType == 2 || self.taskType == 3) {
            
            if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定激活此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.delegate = self;
                alert.tag = 0x222;
                [alert show];
                
            }else{
                
                [MBProgressHUD showError:@"无权限激活任务" toView:self.view];
                return;
            }
            
        }
        else{
            
            if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_2" role:self.role]) {
                
                if ([self.project_complete_status isEqualToString:@"1"]) {// 填写激活原因
                    
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
                
                [MBProgressHUD showError:@"无权限激活任务" toView:self.view];
                return;
            }
            
        }
        
    }
    else{
        
        if (self.taskType == 2 || self.taskType == 3) {
            
            if ([self.role containsString:@"0"] || [self.role containsString:@"1"]) {
                BOOL haveNOFinish = NO;
                for (TFProjectRowModel *node in self.childTasks) {
                    if ([[node.complete_status description] isEqualToString:@"0"]) {
                        haveNOFinish = YES;
                        break;
                    }
                }
                if (!haveNOFinish) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定完成此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.delegate = self;
                    alert.tag = 0x111;
                    [alert show];
                }else{
                    [MBProgressHUD showError:@"子任务尚未全部完成，无法完成该任务" toView:self.view];
                }
            }else{
                
                [MBProgressHUD showError:@"无权限完成任务" toView:self.view];
                return;
            }
        }else{
            
            if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_2" role:self.role]) {
                BOOL haveNOFinish = NO;
                for (TFProjectRowModel *node in self.childTasks) {
                    if ([[node.complete_status description] isEqualToString:@"0"]) {
                        haveNOFinish = YES;
                        break;
                    }
                }
                if (!haveNOFinish) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定完成此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.delegate = self;
                    alert.tag = 0x111;
                    [alert show];
                }else{
                    [MBProgressHUD showError:@"子任务尚未全部完成，无法完成该任务" toView:self.view];
                }
            }else{
                
                [MBProgressHUD showError:@"无权限完成任务" toView:self.view];
                return;
            }
        }
    }
    
}


#pragma mark - HQSwitchCellDelegate
-(void)switchCellDidSwitchButton:(UISwitch *)switchButton{
    
    
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
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (switchButton.on) {
            [self.projectTaskBL requsetTaskVisibleWithTaskId:self.dataId associatesStatus:@1 taskType:@(self.taskType+1)];
        }else{
            [self.projectTaskBL requsetTaskVisibleWithTaskId:self.dataId associatesStatus:@0 taskType:@(self.taskType+1)];
        }
    }else{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (self.taskType == 2) {
            
            if (switchButton.on) {
                [self.projectTaskBL requsetPersonnelTaskVisibleWithTaskId:self.dataId participantsOnly:@1 fromType:@0];
            }else{
                [self.projectTaskBL requsetPersonnelTaskVisibleWithTaskId:self.dataId participantsOnly:@0 fromType:@0];
            }
        }else{
            
            if (switchButton.on) {
                [self.projectTaskBL requsetPersonnelTaskVisibleWithTaskId:self.dataId participantsOnly:@1 fromType:@1];
            }else{
                [self.projectTaskBL requsetPersonnelTaskVisibleWithTaskId:self.dataId participantsOnly:@0 fromType:@1];
            }
        }
    }
}

#pragma mark - TFTaskRelationListCellDelegate
-(void)taskRelationListLongPressWithModel:(TFProjectSectionModel *)model taskIndex:(NSInteger)taskIndex{
    
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
    self.longPressModel = model;
    self.longPressTaskIndex = taskIndex;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认取消该关联任务吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    alert.tag = 0x99;
    [alert show];
}

-(void)taskRelationListCellDidShow{
    
    [self.tableView reloadData];
}

-(void)addTaskRelation{
    
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
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新建",@"引用", nil];
    sheet.tag = 0x444;
    [sheet showInView:self.view];
    
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
            if (model.task_id && [model.task_type isEqualToString:@"0"]) {// 子任务
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
            
//            model.complete_status = parameter;
//            model.finishType = parameter;
//            [self.moveView refreshData];
        };
        detail.deleteAction = ^{
//            TFProjectSectionModel *sec = self.flows[self.moveView.selectPage];
//
//            [self.moveView loadDataWithSectionModel:sec index:self.moveView.selectPage];
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


#pragma mark - TFChildTaskListCellDelegate
-(void)childTaskDidFinishedWithModel:(TFProjectRowModel *)model{
    
    BOOL addChildTaskAuth = NO;
    if (self.taskType == 0 || self.taskType == 1) {
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_2" role:self.role]) {// 完成任务
            addChildTaskAuth = YES;
        }
        
    }else{
        addChildTaskAuth = [self.role containsString:@"0"] || [self.role containsString:@"1"];
    }
    if (addChildTaskAuth) {
        
        self.childTaskModel = model;
        if ([model.finishType isEqualToNumber:@1]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定激活此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.delegate = self;
            alert.tag = 0x7777;
            [alert show];
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定完成此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.delegate = self;
            alert.tag = 0x8888;
            [alert show];
            
        }
    }else{
        [MBProgressHUD showError:@"无权限" toView:self.view];
    }
    
}

-(void)childTaskDidSelectedWithModel:(TFProjectRowModel *)row{
    
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
        
        [self.childTasks removeObject:row];
        [self.tableView reloadData];
    };
    detail.childAction = ^{
        
        if (self.taskType == 0) {
            
            [self.projectTaskBL requestGetChildTaskListWithTaskId:self.dataId nodeCode:self.nodeCode];
        }
        if (self.taskType == 2) {
            
            [self.projectTaskBL requestGetPersonnelChildTaskListWithTaskId:self.dataId];
        }
    };
    [self.navigationController pushViewController:detail animated:YES];
    
}


-(void)addChildTask{
    
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
        [self.navigationController pushViewController:childTask animated:YES];
    }
    if (self.taskType == 2 || self.taskType == 3) {
        
        if ([[self.detailDict valueForKey:@"complete_status"] isEqualToString:@"1"]) {
            [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
            return;
        }
        TFCreateChildTaskController *childTask = [[TFCreateChildTaskController alloc] init];
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
        [self.navigationController pushViewController:childTask animated:YES];
    }
}



#pragma mark - TFAttributeTextCellDelegate
-(void)attributeTextCell:(TFAttributeTextCell *)attributeTextCell getWebViewHeight:(CGFloat)height{
    
    NSInteger section = attributeTextCell.tag / 0x777;
    NSInteger row = attributeTextCell.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section-5];
    TFCustomerRowsModel *model = layout.rows[row];
    
    if (height != [model.height floatValue]) {
        
        model.height = [NSNumber numberWithFloat:height];
        
        [self.tableView reloadData];
    }
}
-(void)attributeTextCell:(TFAttributeTextCell *)attributeTextCell getWebViewContent:(NSString *)content{
    
    NSInteger section = attributeTextCell.tag / 0x777;
    NSInteger row = attributeTextCell.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section-5];
    TFCustomerRowsModel *model = layout.rows[row];
    model.fieldValue = content;
    
    [self.tableView reloadData];
}

#pragma mark - 所有数据、评论、动态、状态
-(void)setupAllDataView{
    TFAllDataView *allDataView = [[TFAllDataView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,0}];
    self.allDataView = allDataView;
    allDataView.delegate = self;
    
    [allDataView refreshAllDataViewWithDatas:@[]];
//    [self.customBL requestCustomModuleCommentListWithBean:self.bean dataId:self.dataId];// 评论数据
    
}
#pragma mark - TFAllDataViewDelegate
-(void)allDataView:(TFAllDataView *)allDataView didChangeHeight:(CGFloat)height{
    
    NSString *str = self.bottomBtns[self.selectIndex];
    self.allDataView.height = height;
    if ([str isEqualToString:@"所有状态"]) {
        self.tableView.tableFooterView = self.allDataView;
        [self.tableView reloadData];
    }
    
}

- (void)setupStatusView{
    
    TFStatusTableView *statusTable = [[TFStatusTableView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,0}];
    self.statusTable = statusTable;
    statusTable.delegate = self;
    
    if (self.taskType == 0) {
        [self.projectTaskBL requsetGetProjectTaskSeeStatusWithProjectId:self.projectId taskId:self.dataId taskType:@1];//查看数据
    }else if (self.taskType == 1){
        [self.projectTaskBL requsetGetProjectTaskSeeStatusWithProjectId:self.projectId taskId:self.dataId taskType:@2];//查看数据
    }else if (self.taskType == 2){
        [self.projectTaskBL requsetGetPersonnelTaskSeeStatusWithTaskId:self.dataId taskType:@0];//查看数据
    }else{
        [self.projectTaskBL requsetGetPersonnelTaskSeeStatusWithTaskId:self.dataId taskType:@1];//查看数据
    }
}

#pragma mark - TFStatusTableViewDelegate
-(void)statusTableView:(TFStatusTableView *)statusTableView didChangeHeight:(CGFloat)height{
    
    NSString *str = self.bottomBtns[self.selectIndex];
    self.statusTable.height = height;
    if ([str isEqualToString:@"查看状态"]) {
        self.tableView.tableFooterView = self.statusTable;
        [self.tableView reloadData];
    }
    
}

/** 添加动态视图 */
-(void)setupDynamicsView{
    
    TFDynamicsTableView *dynamicsTable = [[TFDynamicsTableView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,0}];
    self.dynamicsTable = dynamicsTable;
    dynamicsTable.delegate = self;
    
    [self.customBL requestCustomModuleDynamicListWithBean:self.bean dataId:self.dataId];// 动态数据
}

#pragma mark - TFDynamicsTableViewDelegate
-(void)dynamicsTableView:(TFDynamicsTableView *)dynamicsTableView didChangeHeight:(CGFloat)height{
    
    NSString *str = self.bottomBtns[self.selectIndex];
    self.dynamicsTable.height = height;
    if ([str isEqualToString:@"动态"]) {
        self.tableView.tableFooterView = self.dynamicsTable;
        [self.tableView reloadData];
    }
    
}

/** 添加评论View */
- (void)setupCommentView{
    
    TFCommentTableView *commentTable = [[TFCommentTableView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,0}];
    self.commentTable = commentTable;
    commentTable.delegate = self;
//    [self.customBL requestCustomModuleCommentListWithBean:self.bean dataId:self.dataId];// 评论数据
}
#pragma mark - TFCommentTableViewDelegate
-(void)commentTableView:(TFCommentTableView *)commentTableView didChangeHeight:(CGFloat)height{
    
    self.commentTable.height = height;
    self.tableView.tableFooterView = self.commentTable;
    [self.tableView reloadData];
//    NSString *str = self.bottomBtns[self.selectIndex];
//    self.commentTable.height = height;
//    if ([str isEqualToString:@"评论"]) {
//        self.tableView.tableFooterView = self.commentTable;
//        [self.tableView reloadData];
//    }
}

-(void)commentTableViewDidClickVioce:(TFFileModel *)model{
    
    TFPlayVoiceController *play = [[TFPlayVoiceController alloc] init];
    play.file = model;
    [self.navigationController pushViewController:play animated:YES];
    
}

-(void)commentTableViewDidClickImage:(UIImageView *)imageView{
    
    NSMutableArray *items = @[].mutableCopy;
    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView image:imageView.image];
    [items addObject:item];
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:0];
    browser.delegate = self;
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlurPhoto;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleDeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces = NO;
    [browser showFromViewController:self];
    
}

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index {
    HQLog(@"selected index: %ld", index);
}

- (void)commentTableViewDidClickFile:(TFFileModel *)file{
    
}
#pragma mark - TFAllDynamicViewDelegate
-(void)allDynamicView:(TFAllDynamicView *)view didClickedArrow:(UIButton *)arrow{
    
    CGPoint point = [view convertPoint:arrow.center toView:KeyWindow];
    [self methodWithPoint:CGPointMake(point.x+20, point.y+20)];
}

-(void)methodWithPoint:(CGPoint)point{
    
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:@[@"所有动态",@"仅评论",@"仅查看状态",@"仅操作日志"] images:nil];
    pop.selectRowAtIndex = ^(NSInteger index) {
        
        self.selectIndex = index;
        NSString *str = self.bottomBtns[index];
        self.commentTabBar.nameLabel.text = str;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requestTaskHybirdDynamicWithTaskId:self.dataId taskType:@(self.taskType + 1) dynamicType:@(self.selectIndex) pageSize:@10000];
        
//        if (index == 0) {// 所有动态
//            if (!self.allDataView) {
//                [self setupAllDataView];
//            }
//            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
//            self.tableView.tableFooterView = self.allDataView;
//            self.keyboard.topBar.hidden = NO;
//            self.commentTabBar.nameLabel.text = @"所有动态";
//
//        }else if (index == 1) {// 评论
//            if (!self.commentTable) {
//                [self setupCommentView];
//            }
//            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
//            self.tableView.tableFooterView = self.commentTable;
//            self.keyboard.topBar.hidden = NO;
//            [self.customBL requestCustomModuleCommentListWithBean:self.bean dataId:self.dataId];// 评论数据
//            self.commentTabBar.nameLabel.text = @"仅评论";
//
//        }else if (index == 2) {// 查看
//            if (!self.statusTable) {
//                [self setupStatusView];
//            }
//            self.tableView.tableFooterView = self.statusTable;
//            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//            self.keyboard.topBar.hidden = YES;
//            if (self.taskType == 0) {
//                [self.projectTaskBL requsetGetProjectTaskSeeStatusWithProjectId:self.projectId taskId:self.dataId taskType:@1];//查看数据
//            }else if (self.taskType == 1){
//                [self.projectTaskBL requsetGetProjectTaskSeeStatusWithProjectId:self.projectId taskId:self.dataId taskType:@2];//查看数据
//            }else if (self.taskType == 2){
//                [self.projectTaskBL requsetGetPersonnelTaskSeeStatusWithTaskId:self.dataId taskType:@0];//查看数据
//            }else{
//                [self.projectTaskBL requsetGetPersonnelTaskSeeStatusWithTaskId:self.dataId taskType:@1];//查看数据
//            }
//            self.commentTabBar.nameLabel.text = @"仅查看状态";
//
//        }else {// 动态
//            if (!self.dynamicsTable) {
//                [self setupDynamicsView];
//            }
//            self.tableView.tableFooterView = self.dynamicsTable;
//            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//            self.keyboard.topBar.hidden = YES;
//            [self.customBL requestCustomModuleDynamicListWithBean:self.bean dataId:self.dataId];// 动态数据
//            self.commentTabBar.nameLabel.text = @"仅操作日志";
//        }
        [self.tableView reloadData];
    };
    
    [pop show];
    
    
}

#pragma mark - 所有状态、评论、动态、状态
- (void)setupCommentTabBar{
    
    TFAllDynamicView *allDynamicView = [TFAllDynamicView allDynamicView];
    allDynamicView.delegate = self;
    self.commentTabBar = allDynamicView;
    
    if (self.taskType == 0 || self.taskType == 1) {// 项目任务
//        [self setupAllDataView];
        [self setupCommentView];
        if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"28"]) {
            
            self.keyboard = [LiuqsEmoticonKeyBoard showKeyBoardInView:self.view type:1];
            self.keyboard.textView.placeholder = @"说点什么吧...";
            self.keyboard.delegate = self;
            [self.keyboard hideKeyBoard];
            
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        }
    }else{// 个人任务
        
//        [self setupAllDataView];
        [self setupCommentView];
        
        self.keyboard = [LiuqsEmoticonKeyBoard showKeyBoardInView:self.view type:1];
        self.keyboard.textView.placeholder = @"说点什么吧...";
        self.keyboard.delegate = self;
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    }
//    if (self.allDataView) {
//        self.tableView.tableFooterView = self.allDataView;
//    }
    NSMutableArray *strs = [NSMutableArray array];
    [strs addObject:@"所有状态"];
    [strs addObject:@"评论"];
    [strs addObject:@"查看状态"];
    [strs addObject:@"动态"];
    self.bottomBtns = strs;
    [self.tableView reloadData];
    
//    return;
//
//    NSMutableArray *strs = [NSMutableArray array];
//
//    if (self.taskType == 0 || self.taskType == 1) {// 项目任务
//
//        if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"28"]) {
//
//            [strs addObject:@"评论"];
//            [self setupCommentView];
//
//            self.keyboard = [LiuqsEmoticonKeyBoard showKeyBoardInView:self.view type:1];
//            self.keyboard.textView.placeholder = @"说点什么吧...";
//            self.keyboard.delegate = self;
//            [self.keyboard hideKeyBoard];
//
//            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
//        }
//    }else{// 个人任务
//
//        [strs addObject:@"评论"];
//        [self setupCommentView];
//
//        self.keyboard = [LiuqsEmoticonKeyBoard showKeyBoardInView:self.view type:1];
//        self.keyboard.textView.placeholder = @"说点什么吧...";
//        self.keyboard.delegate = self;
//
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
//    }
//
//    [strs addObject:@"动态"];
//    [self setupDynamicsView];
//
//
//    [strs addObject:@"查看状态"];
//    [self setupStatusView];
//
//
//    self.bottomBtns = strs;
//
//    CGFloat width = 70;
//
//    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,strs.count == 0? 0: 40}];
//    view.backgroundColor = WhiteColor;
//    for (NSInteger i = 0; i < strs.count; i ++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(15 + i * width, 0, width, 40);
//        if ([strs[i] isEqualToString:@"查看状态"]) {
//            button.frame = CGRectMake(15 + i * width, 0, width+20, 40);
//        }
//        [button setTitle:[NSString stringWithFormat:@" %@",strs[i]] forState:UIControlStateNormal];
//        [button setTitle:[NSString stringWithFormat:@" %@",strs[i]] forState:UIControlStateHighlighted];
//        [button setTitle:[NSString stringWithFormat:@" %@",strs[i]] forState:UIControlStateSelected];
//        [button setTitleColor:BlackTextColor forState:UIControlStateNormal];
//        [button setTitleColor:BlackTextColor forState:UIControlStateHighlighted];
//        [button setTitleColor:GreenColor forState:UIControlStateSelected];
//        NSString *img = [NSString stringWithFormat:@"%@CD",strs[i]];
//        NSString *imgS = [NSString stringWithFormat:@"%@CDS",strs[i]];
//        [button setImage:IMG(img) forState:UIControlStateNormal];
//        [button setImage:IMG(img) forState:UIControlStateHighlighted];
//        [button setImage:IMG(imgS) forState:UIControlStateSelected];
//        [view addSubview:button];
//        button.tag = 0x123 + i;
//        button.titleLabel.font = FONT(14);
//        [button addTarget:self action:@selector(buttonTabClicked:) forControlEvents:UIControlEventTouchUpInside];
//        if (i == 0) {
//            button.selected = YES;
//        }
//        UIView *line = [[UIView alloc] initWithFrame:(CGRect){15 + (i + 1) *width ,12,1,16}];
//        line.backgroundColor = HexColor(0xd9d9d9);
//        [view addSubview:line];
//        if (i == strs.count-1) {
//            line.hidden = YES;
//        }
//        [self.buttons addObject:button];
//    }
//    self.commentTabBar = view;
//    if (self.commentTable) {
//        self.tableView.tableFooterView = self.commentTable;
//    }else if (self.dynamicsTable){
//        self.tableView.tableFooterView = self.dynamicsTable;
//    }else if (self.statusTable){
//        self.tableView.tableFooterView = self.statusTable;
//    }
//
//    [self.tableView reloadData];
}

- (void)buttonTabClicked:(UIButton *)button{
    
    NSInteger tag = button.tag - 0x123;
    
    for (UIButton *btn in self.buttons) {
        btn.selected = NO;
    }
    button.selected = YES;
    
    NSString *str = self.bottomBtns[tag];
    self.selectIndex = tag;
    [self.keyboard hideKeyBoard];
    
    if ([str isEqualToString:@"评论"]) {
        self.tableView.tableFooterView = self.commentTable;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        self.keyboard.topBar.hidden = NO;
        [self.customBL requestCustomModuleCommentListWithBean:self.bean dataId:self.dataId];// 评论数据
    }
    if ([str isEqualToString:@"动态"]) {
        self.tableView.tableFooterView = self.dynamicsTable;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.keyboard.topBar.hidden = YES;
        [self.customBL requestCustomModuleDynamicListWithBean:self.bean dataId:self.dataId];// 动态数据
    }
    if ([str isEqualToString:@"查看状态"]) {
        self.tableView.tableFooterView = self.statusTable;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.keyboard.topBar.hidden = YES;
        if (self.taskType == 0) {
            [self.projectTaskBL requsetGetProjectTaskSeeStatusWithProjectId:self.projectId taskId:self.dataId taskType:@1];//查看数据
        }else if (self.taskType == 1){
            [self.projectTaskBL requsetGetProjectTaskSeeStatusWithProjectId:self.projectId taskId:self.dataId taskType:@2];//查看数据
        }else if (self.taskType == 2){
            [self.projectTaskBL requsetGetPersonnelTaskSeeStatusWithTaskId:self.dataId taskType:@0];//查看数据
        }else{
            [self.projectTaskBL requsetGetPersonnelTaskSeeStatusWithTaskId:self.dataId taskType:@1];//查看数据
        }
    }
    [self.tableView reloadData];
    
}


- (void)keyBoardWillShow:(NSNotification *)noti {
    
    if (self.keyboard.textView.isFirstResponder) {
        
        NSDictionary *userInfo = noti.userInfo;
        NSValue *endValue      = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect endFrame        = endValue.CGRectValue;
        //处理键盘弹出
        [self.keyboard handleKeyBoardShow:endFrame];
        
        [UIView animateWithDuration:keyBoardTipTime animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, endFrame.size.height+44, 0);
        }completion:^(BOOL finished) {
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height-self.tableView.height + endFrame.size.height+44) animated:YES];
        }];
    }
    
}

- (void)keyBoardWillHide:(NSNotification *)noti {
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
}


#pragma mark ==== LiuqsEmotionKeyBoardDelegate ====
-(void)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"@"]) {
        
        //        [self didHeartBtn:nil];
        
    }
}

-(void)recordStarting{
    
    self.enablePanGesture = NO;
}

-(void)cancelStarting{
    
    self.enablePanGesture = YES;
}

#pragma mark - @功能选人
-(void)didHeartBtn:(UIButton *)button{
    
    
    TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
    scheduleVC.selectType = 1;
    scheduleVC.isSingleSelect = YES;
    scheduleVC.actionParameter = ^(NSArray *peoples) {
        
        NSString *str = @"";
        [self.peoples addObjectsFromArray:peoples];
        for (HQEmployModel *model in self.peoples) {
            str = [NSString stringWithFormat:@"%@,",model.employeeName?:model.employee_name];
        }
        str = [str substringToIndex:str.length-1];
        self.keyboard.textView.text = [NSString stringWithFormat:@"@%@%@ ",self.keyboard.textView.text,str];
        
        for (HQEmployModel *model in self.peoples) {
            
            NSString *str1 = [NSString stringWithFormat:@"%@",model.employeeName?:model.employee_name];
            
            NSRange range = [self.keyboard.textView.text rangeOfString:str1];
            model.location = @(range.location);
            model.length = @(range.length);
            
        }
        self.jump = 0;
        [self.keyboard.textView becomeFirstResponder];
        
    };
    self.jump = 1;
    [self.navigationController pushViewController:scheduleVC animated:YES];
}

#pragma mark - 文字改变
- (void)textViewDidChange:(UITextView *)textView{
    
    
    NSString *str = textView.text;
    
    if (str.length == 0) {
        self.keyboard.textView.placeholder = @"说点什么吧...";
    }else{
        self.keyboard.textView.placeholder = @"";
    }
    
    for (HQEmployModel *model in self.peoples) {
        
        NSString *str1 = [NSString stringWithFormat:@"@%@",model.employeeName?:model.employee_name];
        
        if (![str containsString:str1]) {
            
            // 剩余名字位置
            NSRange range = NSMakeRange([model.location integerValue], [model.length integerValue]-1);
            
            if (range.location + range.length > textView.text.length) {// 考虑删除多个字
                
                [self.peoples removeObject:model];
                continue;
            }
            
            str = [str stringByReplacingCharactersInRange:range withString:@""];
            textView.text = str;
            
            [self.peoples removeObject:model];
            break;
        }else{
            
            NSRange range = [str rangeOfString:str1];
            model.location = @(range.location);
            model.length = @(range.length);
        }
    }
    
}


//发送按钮的事件
- (void)sendButtonEventsWithPlainString:(NSString *)PlainStr {
    
    if (!PlainStr.length) {
        [MBProgressHUD showError:@"请输入内容" toView:KeyWindow];
        return;
    }
    //点击发送，发出一条消息
    [self prepareTextMessage:PlainStr];
    
    self.keyboard.textView.text = @"";
    [self.keyboard.topBar resetSubsives];
    
}

/** 发送语音 */
-(void)sendVoiceWithVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration{
    
    
    NSURL *mp3Url = [HQHelper recordCafToMp3WithCafUrl:voicePath toMp3Url:[self getMp3Path]];
    
    [self SendMessageWithVoice:[mp3Url absoluteString]
                 voiceDuration:voiceDuration];
    
    //    [self SendMessageWithVoice:voicePath
    //                 voiceDuration:voiceDuration];
}


/** 发送其他 */
-(void)sendAddItemContentWithIndex:(NSInteger)index{
    self.isFile = NO;// 评论
    switch (index) {
        case 0:
        {
            [self openCamera];
        }
            break;
        case 1:
        {
            [self openAlbum];
        }
            break;
        case 2:
        {
            [self pushFileLibray];
        }
            break;
        case 3:
        {
            [self didHeartBtn:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ---文件库选
- (void)pushFileLibray {
    
    TFFileMenuController *fileVC = [[TFFileMenuController alloc] init];
    
    fileVC.isFileLibraySelect = YES;
    
    fileVC.refreshAction = ^(id parameter) {
        
        TFFolderListModel *model = parameter;
        
        if (self.isFile) {// 上传附件
            TFFileModel *file = [[TFFileModel alloc] init];
            file.file_url = model.fileUrl;
            file.file_name = model.name;
            file.file_type = model.siffix;
            file.file_size = @([model.size integerValue]);
            file.upload_by = UM.userLoginInfo.employee.employee_name;
            file.upload_time = @([HQHelper getNowTimeSp]);
            
            [self.files addObject:file];
            [self.tableView reloadData];
            
            // 编辑任务
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if (self.taskType == 0) {// 主任务
                [self.projectTaskBL requestUpdateTaskWithDict:[self taskHandle]];
            }else  if (self.taskType == 1){// 子任务
                [self.projectTaskBL requestUpdateSubTaskWithDict:[self taskHandle]];
            }else  if (self.taskType == 2){
                [self.projectTaskBL requestEditPersonnelTaskWithDict:[self taskHandle]];
            }else{
                [self.projectTaskBL requestEditPersonnelSubTaskWithDict:[self taskHandle]];
            }
            
            return ;
        }
        
        TFCustomerCommentModel *commentModel = [[TFCustomerCommentModel alloc] init];
        commentModel.fileUrl = model.fileUrl;
        commentModel.fileName = model.name;
        commentModel.fileType = model.siffix;
        commentModel.fileSize = @([model.size integerValue]);
        
        commentModel.employee_name = UM.userLoginInfo.employee.employee_name;
        commentModel.employee_id = UM.userLoginInfo.employee.id;
        commentModel.picture = UM.userLoginInfo.employee.picture;
        commentModel.datetime_time = @([HQHelper getNowTimeSp]);
        
        self.commentModel = commentModel;
        
        model.siffix = [model.siffix stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:model.fileUrl forKey:@"file_url"];
        [dic setObject:@([model.size integerValue]) forKey:@"file_size"];
        [dic setObject:model.siffix forKey:@"file_type"];
        [dic setObject:model.name forKey:@"file_name"];
        
        [dic setObject:@([HQHelper getNowTimeSp]) forKey:@"datetime_time"];
        
        NSMutableArray *files = [NSMutableArray array];
        
        [files addObject:dic];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.bean forKey:@"bean"];
        [dict setObject:self.dataId forKey:@"relation_id"];
        [dict setObject:files forKey:@"information"];
        [dict setObject:@"" forKey:@"content"];
        
        [self.customBL requestCustomModuleCommentWithDict:dict];
        
    };
    
    [self.navigationController pushViewController:fileVC animated:YES];
}


#pragma mark - 发送文本
/** 发送文本消息 */
- (void)prepareTextMessage:(NSString *)text {
    
    
    if (text.length) {
        
        NSMutableArray *arr = [NSMutableArray array];
        NSString *str = @"";
        for (HQEmployModel *mode in self.peoples) {
            [arr addObject:mode.sign_id];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[mode.sign_id description]]];
        }
        if (str.length) {
            str = [str substringToIndex:str.length-1];
        }
        [self.peoples removeAllObjects];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [dict setObject:self.bean forKey:@"bean"];
        [dict setObject:self.dataId forKey:@"relation_id"];
        [dict setObject:text forKey:@"content"];
        [dict setObject:str forKey:@"at_employee"];
        [dict setObject:@[] forKey:@"information"];
        [dict setObject:@0 forKey:@"type"];
        
        TFCustomerCommentModel *model = [[TFCustomerCommentModel alloc] init];
        model.content = text;
        model.employee_name = UM.userLoginInfo.employee.employee_name;
        model.employee_id = UM.userLoginInfo.employee.id;
        model.picture = UM.userLoginInfo.employee.picture;
        model.datetime_time = @([HQHelper getNowTimeSp]);
        
        self.commentModel = model;
        
        [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
        [self.customBL requestCustomModuleCommentWithDict:dict];
        
    }else{
        
        [MBProgressHUD showError:@"请输入内容" toView:KeyWindow];
    }
}


#pragma mark - RecorderPath Helper Method
- (NSString *)getMp3Path {
    NSString *recorderPath = nil;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MMMM-dd";
    recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
    dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MyMp3Sound.mp3", [dateFormatter stringFromDate:now]];
    return recorderPath;
}


#pragma mark - Message Send helper Method
#pragma mark --发送语音
- (void)SendMessageWithVoice:(NSString *)voicePath
               voiceDuration:(NSString*)voiceDuration {
    HQLog(@"Action - SendMessageWithVoice");
    
    TFCustomerCommentModel *model = [[TFCustomerCommentModel alloc] init];
    
    model.fileUrl = voicePath;
    model.fileType = @"mp3";
    model.voiceTime = @([voiceDuration doubleValue]);
    
    model.employee_name = UM.userLoginInfo.employee.employee_name;
    model.employee_id = UM.userLoginInfo.employee.id;
    model.picture = UM.userLoginInfo.employee.picture;
    model.datetime_time = @([HQHelper getNowTimeSp]);
    model.content = @"";
    
    self.commentModel = model;
    //    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setObject:self.bean forKey:@"bean"];
    //    [dict setObject:self.id forKey:@"relation_id"];
    //    [dict setObject:@[] forKey:@"information"];
    //    [self.tableView reloadData];
    [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    
    //    审批  approval    邮件 email    文件  file_library   备忘录  note
    [self.customBL chatFileWithImages:@[] withVioces:@[voicePath] bean:self.bean];
   
}

#pragma mark -调用相册
- (void)photoClick {
    
    [self openAlbum];
}

#pragma mark --调用相机
- (void)cameraClick {
    
    [self openCamera];
}
/** 选择照片处理 */
-(void)handleImages:(NSArray *)arr{
    
    if (arr.count == 0) {
        return;
    }
    // 选择照片上传
    if (self.isFile) {// 上传附件
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL chatFileWithImages:arr.firstObject withVioces:@[] bean:self.bean];
        
        return;
    }
    
    TFCustomerCommentModel *model = [[TFCustomerCommentModel alloc] init];
    
    model.fileType = @"jpg";
    model.image = arr.firstObject;
    
    model.employee_name = UM.userLoginInfo.employee.employee_name;
    model.employee_id = UM.userLoginInfo.employee.id;
    model.picture = UM.userLoginInfo.employee.picture;
    model.datetime_time = @([HQHelper getNowTimeSp]);
    model.content = @"";
    
    self.commentModel = model;
    [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    
    [self.customBL chatFileWithImages:arr withVioces:@[] bean:self.bean];
}


#pragma mark - 打开相册
- (void)openAlbum{
    
    kWEAKSELF
    ZLPhotoActionSheet *sheet =[HQHelper takeHPhotoWithBlock:^(NSArray<UIImage *> *images) {
        [weakSelf handleImages:images];
    }];
    //图片数量
    sheet.configuration.maxSelectCount = 1;
    //如果调用的方法没有传sender，则该属性必须提前赋值
    sheet.sender = self;
    [sheet showPhotoLibrary];
    return;
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 1 ; // 选择图片最大数量
    picker.assetsFilter = [ALAssetsFilter allPhotos]; // 可选择所有相册图片
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    picker.modalPresentationStyle = UIModalPresentationFullScreen;

    [self.navigationController presentViewController:picker animated:YES completion:NULL];
}
#pragma mark - ZYQAssetPickerControllerDelegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        // 添加图片
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        NSString *fileName = [representation filename];
        HQLog(@"fileName : %@",fileName);
        
        if (self.isFile) {// 上传附件
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.customBL chatFileWithImages:@[image] withVioces:@[] bean:self.bean];
            
            return;
        }
        
        TFCustomerCommentModel *model = [[TFCustomerCommentModel alloc] init];
        
        model.fileType = @"jpg";
        model.image = image;
        
        model.employee_name = UM.userLoginInfo.employee.employee_name;
        model.employee_id = UM.userLoginInfo.employee.id;
        model.picture = UM.userLoginInfo.employee.picture;
        model.datetime_time = @([HQHelper getNowTimeSp]);
        model.content = @"";
        
        self.commentModel = model;
        [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
        
        [self.customBL chatFileWithImages:@[image] withVioces:@[] bean:self.bean];
       
    }
    
}

#pragma mark - 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        //        picker.allowsEditing = YES;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;

        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    if (self.isFile) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self.customBL chatFileWithImages:@[image] withVioces:@[] bean:self.bean];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    TFCustomerCommentModel *model = [[TFCustomerCommentModel alloc] init];
    
    model.image = image;
    model.fileType = @"jpg";
    
    model.employee_name = UM.userLoginInfo.employee.employee_name;
    model.employee_id = UM.userLoginInfo.employee.id;
    model.picture = UM.userLoginInfo.employee.picture;
    model.datetime_time = @([HQHelper getNowTimeSp]);
    model.content = @"";
    
    self.commentModel = model;
    [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    
    [self.customBL chatFileWithImages:@[image] withVioces:@[] bean:self.bean];
   
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
