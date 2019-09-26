//
//  TFWorkPlatformController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/10/31.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFWorkPlatformController.h"
#import "TFEndlessView.h"
#import "HQTFSelectCompanyController.h"
#import "TFModelEnterController.h"
#import "TFLoginBL.h"
#import "TFProjectTaskBL.h"
#import "TFWorkChangeView.h"
#import "TFWorkSheetView.h"
#import "TFProjectTaskDetailController.h"
#import "TFCreateNoteController.h"
#import "TFNewCustomDetailController.h"
#import "TFApprovalDetailController.h"
#import "TFProjectTaskBL.h"
#import "TFMutilStyleSelectPeopleController.h"

#define ADHEIGHT 150
@interface TFWorkPlatformController ()<HQBLDelegate,TFWorkSheetViewDelegate,TFWorkChangeViewDelegate>

/** endlessScrollView */
@property (nonatomic, strong) TFEndlessView *endlessScrollView;

/** banners */
@property (nonatomic, strong) NSArray *banners;
/** handleTask */
@property (nonatomic, strong) TFProjectRowModel *handleTask;
/** TFLoginBL */
@property (nonatomic, strong) TFLoginBL *loginBL;
/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;
/** workChangeView */
@property (nonatomic, strong) TFWorkChangeView *workChangeView;

@property (nonatomic, strong) NSMutableArray *sheets;

@property (nonatomic, assign) CGPoint lastPoint;

@property (nonatomic, assign) NSInteger overdueCount;
@property (nonatomic, assign) NSInteger todayCount;
@property (nonatomic, assign) NSInteger tomorrowCount;
@property (nonatomic, assign) NSInteger laterCount;

@property (nonatomic, strong) NSMutableArray *peoples;

@end

@implementation TFWorkPlatformController

-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}

-(NSMutableArray *)sheets{
    if (!_sheets) {
        _sheets = [NSMutableArray array];
    }
    return _sheets;
}

-(TFEndlessView *)endlessScrollView{
    if (!_endlessScrollView) {
        _endlessScrollView = [[TFEndlessView alloc] initWithFrame:(CGRect){0,-NaviHeight,SCREEN_WIDTH,Long(ADHEIGHT+NaviHeight)}];
    }
    return _endlessScrollView;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){SCREEN_WIDTH,0.5}]];
    [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0x000000, 0.5) size:(CGSize){SCREEN_WIDTH,NaviHeight}] forBarMetrics:0];
    
    self.navigationItem.leftBarButtonItem = [self titleItemWithTitle:UM.userLoginInfo.company.company_name color:WhiteColor imageName:nil withTarget:self action:@selector(changeCompany)];
    
    [self.loginBL requestGetBanner];
    [self.projectTaskBL requestWorkBenchChangePeopleAuth];
    [self.workChangeView refreshWorkChangeViewWithPeoples:self.peoples];
    
    NSString *str = @"";
    for (HQEmployModel *em in self.peoples) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",em.id]];
    }
    if (str.length) {
        str = [str substringToIndex:str.length - 1];
    }
    for (TFWorkSheetView *sheet in self.sheets) {
        [sheet loadDataMemberIds:str];
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)leftClicked{
    TFModelEnterController *model = [[TFModelEnterController alloc] init];
    [self.navigationController pushViewController:model animated:YES];
}

- (void)changeCompany{
    
    HQTFSelectCompanyController *select = [[HQTFSelectCompanyController alloc] init];
    [self.navigationController pushViewController:select animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFromNavBottomEdgeLayout];
    self.view.backgroundColor = WhiteColor;
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
    
    [self.view addSubview:self.endlessScrollView];
    [self setupWorkChangeView];
    [self setupWorkSheetView];
    
    UINavigationItem *item2 = [self itemWithTarget:self action:@selector(leftClicked) image:@"工作台-更多应用" highlightImage:@"工作台-更多应用"];
    self.navigationItem.rightBarButtonItems = @[item2];
    self.navigationItem.title = nil;
    
    // 登录或切换公司socket连接通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCompanySocketConnect) name:ChangeCompanySocketConnect object:nil];
}

-(void)changeCompanySocketConnect{
    
    [self.peoples removeAllObjects];
    [self.workChangeView refreshWorkChangeViewWithPeoples:self.peoples];
    [self.loginBL requestGetBanner];
    [self.projectTaskBL requestWorkBenchChangePeopleAuth];
    for (TFWorkSheetView *sheet in self.sheets) {
        [sheet loadDataMemberIds:@""];
    }
}

#pragma mark - 初始化TFWorkSheetView
-(void)setupWorkSheetView{
    
    for (NSInteger i = 0 ; i < 4; i ++) {
        
        TFWorkSheetView *sheetView = [[TFWorkSheetView alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(self.workChangeView.frame) + 15 + i * (iPhoneX ? Long(90) : Long(70)),SCREEN_WIDTH,SCREEN_HEIGHT-NaviHeight-TabBarHeight-BottomM+8} type:i];
        sheetView.delegate = self;
        sheetView.tag = i ;
        [self.view addSubview:sheetView];
        [self.sheets addObject:sheetView];
    }
}

#pragma mark - TFWorkSheetViewDelegate
-(void)workSheetViewDidClickedHeader:(TFWorkSheetView *)workSheet{
    
    NSInteger tag = workSheet.tag;
    
    if (workSheet.selected) {
        // 点击的sheet上来，其他下去
        
        [UIView animateWithDuration:0.4 animations:^{
            workSheet.y = 0;
        }];
        
        for (TFWorkSheetView *sheet in self.sheets) {
            
            if (sheet.tag == tag) {
                continue;
            }
            [UIView animateWithDuration:0.4 animations:^{
                sheet.y = SCREEN_HEIGHT;
            }];
        }
        
    }else{
        
        // 归位
        for (NSInteger i = 0; i < self.sheets.count; i ++) {
            TFWorkSheetView *sheet = self.sheets[i];
            sheet.selected = NO;
            [UIView animateWithDuration:0.4 animations:^{
                sheet.y = CGRectGetMaxY(self.workChangeView.frame) + 15 + i * (iPhoneX ? Long(90) : Long(70));
            }];
        }
        
    }
}

-(void)workSheetView:(TFWorkSheetView *)workSheet panBeginWithPoint:(CGPoint)point{
    CGPoint changePoint = [self.view convertPoint:point fromView:workSheet];
    workSheet.y = changePoint.y-Long(25);
    
}
-(void)workSheetView:(TFWorkSheetView *)workSheet panChangeWithPoint:(CGPoint)point{
    CGPoint changePoint = [self.view convertPoint:point fromView:workSheet];
   
    workSheet.y = changePoint.y-Long(25);
    if (workSheet.y <= 0) {
        workSheet.y = 0;
    }
}
-(void)workSheetView:(TFWorkSheetView *)workSheet panEndWithPoint:(CGPoint)point{
    CGPoint changePoint = [self.view convertPoint:point fromView:workSheet];
    
    if (changePoint.y < (SCREEN_HEIGHT-NaviHeight-TabBarHeight-BottomM)/2) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            workSheet.y = 0;
        }];
        
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            workSheet.y = SCREEN_HEIGHT;
        }completion:^(BOOL finished) {
            
            // 归位
            for (NSInteger i = 0; i < self.sheets.count; i ++) {
                TFWorkSheetView *sheet = self.sheets[i];
                sheet.selected = NO;
                [UIView animateWithDuration:0.4 animations:^{
                    sheet.y = CGRectGetMaxY(self.workChangeView.frame) + 15 + i * (iPhoneX ? Long(90) : Long(70));
                }];
            }
        }];
    }
}

-(void)workSheet:(TFWorkSheetView *)workSheet didClickedFinishItem:(TFProjectRowModel *)model{
    
    self.handleTask = model;
    
    if ([model.from isEqualToNumber:@1]) {// 个人任务
        
        if (model.task_id) {// 子任务
            
            [self.projectTaskBL requestGetPersonnelTaskRoleWithTaskId:model.id typeStatus:@1];
            
        }else{// 主任务
            
            [self.projectTaskBL requestGetPersonnelTaskRoleWithTaskId:model.id typeStatus:@0];
        }
    }else{// 项目任务
        
        if (model.task_id) {// 子任务
            
//            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:model.projectId taskId:model.taskInfoId taskType:@2];
            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:model.projectId taskId:model.bean_id taskType:@2];
            
        }else{// 主任务
            
//            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:model.projectId taskId:model.taskInfoId taskType:@1];
            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:model.projectId taskId:model.bean_id taskType:@1];
            
        }
    }
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        if (alertView.tag == 0x111) {// 完成个人任务
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
//            [self.projectTaskBL requestPersonnelTaskFinishOrActiveWithTaskId:self.handleTask.id];
            [self.projectTaskBL requestPersonnelTaskFinishOrActiveWithTaskId:self.handleTask.bean_id];
            
            
        }else if (alertView.tag == 0x222) {// 完成项目任务
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.handleTask.taskInfoId completeStatus:@1 remark:nil];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.handleTask.bean_id completeStatus:@1 remark:nil];
            
        }
        
    }
}

/** 点击 */
-(void)workSheet:(TFWorkSheetView *)workSheet didClickedItem:(TFProjectRowModel *)model{
    
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
            if (model.task_id) {// 子任务
                detail.taskType = 1;
                detail.parentTaskId = model.task_id;
            }else{// 主任务
                detail.taskType = 0;
            }
        }
//        detail.dataId = model.taskInfoId;
        detail.dataId = model.bean_id;
        detail.action = ^(id parameter) {
            
            model.complete_status = parameter;
            model.finishType = parameter;
            [workSheet refreshData];
        };
        detail.deleteAction = ^{
            
            NSString *str = @"";
            for (HQEmployModel *em in self.peoples) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",em.id]];
            }
            if (str.length) {
                str = [str substringToIndex:str.length - 1];
            }
            [workSheet loadDataMemberIds:str];
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

#pragma mark - 初始化workChangeView
-(void)setupWorkChangeView{

    TFWorkChangeView *workChangeView = [TFWorkChangeView workChangeView];
    workChangeView.frame = CGRectMake(60, CGRectGetMaxY(self.endlessScrollView.frame) + 23, SCREEN_WIDTH-Long(120), Long(60));
    workChangeView.delegate = self;
    self.workChangeView = workChangeView;
    [self.view addSubview:workChangeView];
}

#pragma mark - TFWorkChangeViewDelegate
-(void)workChangeViewDidClickedPeople{
    
    TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
    scheduleVC.selectType = 1;
    scheduleVC.isSingleSelect = NO;
    scheduleVC.defaultPoeples = self.peoples;
    //            scheduleVC.noSelectPoeples = model.selects;
    scheduleVC.actionParameter = ^(NSArray *parameter) {
        
        NSString *str = @"";
        for (HQEmployModel *em in parameter) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",em.id]];
        }
        if (str.length) {
            str = [str substringToIndex:str.length - 1];
        }
        
        self.peoples = [NSMutableArray arrayWithArray:parameter];
        [self.workChangeView refreshWorkChangeViewWithPeoples:self.peoples];
        for (TFWorkSheetView *sheet in self.sheets) {
            [sheet loadDataMemberIds:str];
        }
        
    };
    [self.navigationController pushViewController:scheduleVC animated:YES];
    
    
}
-(void)workSheet:(TFWorkSheetView *)workSheet taskCount:(NSInteger)taskCount{
    
    if (workSheet.tag == 0) {
        self.overdueCount = taskCount;
    }else if (workSheet.tag == 1){
        self.todayCount = taskCount;
    }else if (workSheet.tag == 1){
        self.tomorrowCount = taskCount;
    }else if (workSheet.tag == 1){
        self.laterCount = taskCount;
    }
    self.workChangeView.taskCount = self.overdueCount + self.todayCount + self.tomorrowCount + self.laterCount;
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getBanner) {
        
        self.banners = resp.body;
        [self.endlessScrollView refreshEndlessViewWithImages:self.banners];
    }
    
    if (resp.cmdId == HQCMD_finishOrActiveTask || resp.cmdId == HQCMD_finishOrActiveChildTask || resp.cmdId == HQCMD_finishOrActivePersonnelTask) {// 任务激活
        
        self.handleTask.complete_status = [self.handleTask.complete_status isEqualToNumber:@1]?@0:@1;
        self.handleTask.finishType = self.handleTask.complete_status;
        if ([self.handleTask.finishType isEqualToNumber:@0]) {
            self.handleTask.activeNum = @([self.handleTask.activeNum integerValue] + 1);
        }
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        for (TFWorkSheetView *view in self.sheets) {
            [view refreshData];
        }
        
    }
    if (resp.cmdId == HQCMD_moveTimeWorkBench || resp.cmdId == HQCMD_moveEnterpriseWorkBench) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"移动成功" toView:self.view];
    }
    
    if (resp.cmdId == HQCMD_getPersonnelTaskRole) {
        
        NSString *role = [TEXT([resp.body valueForKey:@"role"]) description];
        
        if ([role containsString:@"0"] || [role containsString:@"1"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定完成此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.delegate = self;
            alert.tag = 0x111;
            [alert show];
            
        }else{
            [MBProgressHUD showError:@"无权限修改" toView:self.view];
        }
        
    }
    if (resp.cmdId == HQCMD_getProjectFinishAndActiveAuth) {
        
        NSDictionary *dict = resp.body;
        NSString *auth = [[dict valueForKey:@"finish_task_role"] description];
        
        if ([auth isEqualToString:@"1"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定完成此任务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.delegate = self;
            alert.tag = 0x222;
            [alert show];
            
        }else{
            [MBProgressHUD showError:@"无权限修改" toView:self.view];
        }
        
    }
    
    if (resp.cmdId == HQCMD_workBenchChangeAuth) {
        
        NSDictionary *dict = resp.body;
        NSString *str = [dict valueForKey:@"haveChagnePrivilege"];
        self.workChangeView.auth = [str description];
//        self.workChangeView.auth = @"1";
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
