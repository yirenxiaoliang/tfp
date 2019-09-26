//
//  TFTwoWorkPlatformController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTwoWorkPlatformController.h"
#import "TFModelEnterController.h"
#import "TFEndlessView.h"
#import "TFLoginBL.h"
#import "TFProjectTaskBL.h"
#import "HQTFSelectCompanyController.h"
#import "TFWorkSheetView.h"
#import "TFProjectTaskDetailController.h"
#import "TFCreateNoteController.h"
#import "TFNewCustomDetailController.h"
#import "TFApprovalDetailController.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFChangePeopleView.h"
#import "TFFourItemView.h"
#import "HQPageControl.h"
#import "TFRefresh.h"
#import "TFWorkBenchChangePeopleController.h"
#import "TFRequest.h"

#define ADHEIGHT 160
@interface TFTwoWorkPlatformController ()<UITableViewDataSource,UITableViewDelegate,HQBLDelegate,TFWorkSheetViewDelegate,TFChangePeopleViewDelegate,TFFourItemViewDelegate>

/** endlessScrollView */
@property (nonatomic, strong) TFEndlessView *endlessScrollView;
@property (nonatomic, weak) UITableView *tableView;
/** TFLoginBL */
@property (nonatomic, strong) TFLoginBL *loginBL;
/** banners */
@property (nonatomic, strong) NSArray *banners;
/** handleTask */
@property (nonatomic, strong) TFProjectRowModel *handleTask;
/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;
@property (nonatomic, strong) NSMutableArray *sheets;
@property (nonatomic, assign) NSInteger overdueCount;
@property (nonatomic, assign) NSInteger todayCount;
@property (nonatomic, assign) NSInteger tomorrowCount;
@property (nonatomic, assign) NSInteger laterCount;

@property (nonatomic, strong) NSMutableArray *peoples;
@property (nonatomic, strong) NSMutableArray *items;

/** changePeopleView */
@property (nonatomic, strong) TFChangePeopleView *changePeopleView;

@property (nonatomic, strong) UIView *taskView;

@property (nonatomic, strong) TFModelEnterController *childVc;


@end

@implementation TFTwoWorkPlatformController

-(UIView *)taskView{
    if (!_taskView) {
        _taskView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,Long(166)}];
        _taskView.backgroundColor = WhiteColor;
        CGFloat width = (SCREEN_WIDTH - 2 * 15)/3;
        
        TFChangePeopleView *changePeopleView = [TFChangePeopleView changePeopleView];
        changePeopleView.delegate = self;
        [changePeopleView refreshChangePeopleViewPeoples:self.peoples];
        changePeopleView.frame = CGRectMake(15, 4, width, Long(142));
        [_taskView addSubview:changePeopleView];
        self.changePeopleView = changePeopleView;
        
        CGFloat topMargin = 4;
        NSInteger row = 0;
        NSInteger col = 0;
        for (NSInteger i = 0; i < 4; i ++) {
            
            row = i / 2;
            col = i % 2;
            
            TFFourItemView *itemView = [TFFourItemView fourItemView];
            itemView.tag = i ;
            itemView.type = i ;
            itemView.delegate = self;
            itemView.frame = CGRectMake(CGRectGetMaxX(changePeopleView.frame) + col * width + topMargin, topMargin + row * (Long(150) - 4 * topMargin) / 2, width, (Long(150)) / 2);
            [_taskView addSubview:itemView];
            [self.items addObject:itemView];
        }
        
    }
    return _taskView;
}

-(TFEndlessView *)endlessScrollView{
    if (!_endlessScrollView) {
        _endlessScrollView = [[TFEndlessView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,ADHEIGHT}];
        _endlessScrollView.isBorder = YES;
    }
    return _endlessScrollView;
}

-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}
-(NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}


-(NSMutableArray *)sheets{
    if (!_sheets) {
        _sheets = [NSMutableArray array];
    }
    return _sheets;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){SCREEN_WIDTH,0.5}]];
    
    self.navigationItem.leftBarButtonItem = [self titleItemWithTitle:@"应用中心" color:BlackTextColor imageName:nil withTarget:nil action:nil];
//    self.navigationItem.leftBarButtonItem = [self titleItemWithTitle:UM.userLoginInfo.company.company_name color:BlackTextColor imageName:@"workDown" withTarget:self action:@selector(changeCompany)];
    
    [self.loginBL requestGetBanner];
//    [self.projectTaskBL requestWorkBenchChangePeopleAuth];
    
}

-(void)refrehData{
    
    [self.loginBL requestGetBanner];
//    [self.projectTaskBL requestWorkBenchChangePeopleAuth];
//
//    [self.changePeopleView refreshChangePeopleViewPeoples:self.peoples];
//
//    NSString *str = @"";
//    for (HQEmployModel *em in self.peoples) {
//        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",em.id]];
//    }
//    if (str.length) {
//        str = [str substringToIndex:str.length - 1];
//    }
//    for (TFWorkSheetView *sheet in self.sheets) {
//        [sheet loadDataMemberIds:str];
//    }
    
    [self.childVc refreshModuleData];// 模块刷新
}

- (void)changeCompany{
    
    HQTFSelectCompanyController *select = [[HQTFSelectCompanyController alloc] init];
    [self.navigationController pushViewController:select animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
//    self.projectTaskBL = [TFProjectTaskBL build];
//    self.projectTaskBL.delegate = self;
    [self setupTableView];
    [self setupChildVc];
//    [self setupWorkSheetView];
    
    self.navigationItem.title = nil;
    
    // 登录或切换公司socket连接通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCompanySocketConnect) name:ChangeCompanySocketConnect object:nil];
    
//    UINavigationItem *item2 = [self itemWithTarget:self action:@selector(leftClicked) image:@"工作台-更多应用" highlightImage:@"工作台-更多应用"];
//    self.navigationItem.rightBarButtonItems = @[item2];
    
    [self.loginBL requestGetBanner];
    
}


- (void)leftClicked{
    TFModelEnterController *model = [[TFModelEnterController alloc] init];
    [self.navigationController pushViewController:model animated:YES];
}

-(void)changeCompanySocketConnect{
    
//    [self.peoples removeAllObjects];
//    [self.changePeopleView refreshChangePeopleViewPeoples:self.peoples];
    
    [self refrehData];
}
#pragma mark - 初始化TFWorkSheetView
-(void)setupWorkSheetView{
    
    for (NSInteger i = 0 ; i < 4; i ++) {
        
        TFWorkSheetView *sheetView = [[TFWorkSheetView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT-NaviHeight-TabBarHeight-BottomM+8} type:i];
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
                sheet.y = SCREEN_HEIGHT;
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
                    sheet.y = SCREEN_HEIGHT;
                }];
            }
        }];
    }
}

-(void)workSheet:(TFWorkSheetView *)workSheet didClickedFinishItem:(TFProjectRowModel *)model{
    
    self.handleTask = model;
    
    if ([model.from isEqualToNumber:@1]) {// 个人任务
        
        if (model.task_id) {// 子任务
            
//            [self.projectTaskBL requestGetPersonnelTaskRoleWithTaskId:model.id typeStatus:@1];
            [self.projectTaskBL requestGetPersonnelTaskRoleWithTaskId:model.bean_id typeStatus:@1];
            
        }else{// 主任务
            
//            [self.projectTaskBL requestGetPersonnelTaskRoleWithTaskId:model.id typeStatus:@0];
            [self.projectTaskBL requestGetPersonnelTaskRoleWithTaskId:model.bean_id typeStatus:@0];
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
            if (self.handleTask.task_id) {// 子任务
                
//                [self.projectTaskBL requestChildTaskFinishOrActiveWithTaskId:self.handleTask.taskInfoId completeStatus:@1 remark:nil];
                [self.projectTaskBL requestChildTaskFinishOrActiveWithTaskId:self.handleTask.bean_id completeStatus:@1 remark:nil];
            }else{// 主任务
//                [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.handleTask.taskInfoId completeStatus:@1 remark:nil];
                [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.handleTask.bean_id completeStatus:@1 remark:nil];
            }
            
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
        detail.action = ^(NSDictionary *parameter) {
            
            model.complete_status = [parameter valueForKey:@"complete_status"];
            model.finishType = [parameter valueForKey:@"complete_status"];
            model.passed_status = [parameter valueForKey:@"passed_status"];
            [workSheet refreshData];
            
            NSString *str = @"";
            for (HQEmployModel *em in self.peoples) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",em.id]];
            }
            if (str.length) {
                str = [str substringToIndex:str.length - 1];
            }
            [workSheet loadDataMemberIds:str];
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

-(void)workSheet:(TFWorkSheetView *)workSheet taskCount:(NSInteger)taskCount{
    
    TFFourItemView *itemView = self.items[workSheet.tag];
    itemView.taskCount = taskCount;
    if (workSheet.tag == 0) {
        self.overdueCount = taskCount;
    }else if (workSheet.tag == 1){
        self.todayCount = taskCount;
    }else if (workSheet.tag == 2){
        self.tomorrowCount = taskCount;
    }else if (workSheet.tag == 3){
        self.laterCount = taskCount;
    }
    self.changePeopleView.taskCount = self.overdueCount + self.todayCount + self.tomorrowCount + self.laterCount;
}

#pragma mark - TFChangePeopleViewDelegate
-(void)changePeopleViewDidClickedPeople{
    
//    TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
//    scheduleVC.selectType = 1;
//    scheduleVC.isSingleSelect = NO;
//    scheduleVC.defaultPoeples = self.peoples;
//    //            scheduleVC.noSelectPoeples = model.selects;
//    scheduleVC.actionParameter = ^(NSArray *parameter) {
//
//        NSString *str = @"";
//        for (HQEmployModel *em in parameter) {
//            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",em.id]];
//        }
//        if (str.length) {
//            str = [str substringToIndex:str.length - 1];
//        }
//
//        self.peoples = [NSMutableArray arrayWithArray:parameter];
//        [self.changePeopleView refreshChangePeopleViewPeoples:self.peoples];
//        for (TFWorkSheetView *sheet in self.sheets) {
//            [sheet loadDataMemberIds:str];
//        }
//
//    };
//    [self.navigationController pushViewController:scheduleVC animated:YES];
//
    
    TFWorkBenchChangePeopleController *copyer = [[TFWorkBenchChangePeopleController alloc] init];
    
    copyer.defaultPoeples = self.peoples;
    copyer.actionParameter = ^(id parameter) {
        
        NSString *str = @"";
        for (HQEmployModel *em in parameter) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",em.id]];
        }
        if (str.length) {
            str = [str substringToIndex:str.length - 1];
        }

        self.peoples = [NSMutableArray arrayWithArray:parameter];
        [self.changePeopleView refreshChangePeopleViewPeoples:self.peoples];
        for (TFWorkSheetView *sheet in self.sheets) {
            [sheet loadDataMemberIds:str];
        }
        
    };
    [self.navigationController pushViewController:copyer animated:YES];
    
    
}

#pragma mark - TFFourItemViewDelegate
-(void)fourItemViewDidClicked:(TFFourItemView *)itemView{
    NSInteger tag = itemView.tag;
    
    TFWorkSheetView *workSheet = self.sheets[tag];
    workSheet.selected = YES;
    [UIView animateWithDuration:0.4 animations:^{
        workSheet.y = 0;
    }];
    
    
    // 点击一次刷新一次
    NSString *str = @"";
    for (HQEmployModel *em in self.peoples) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",em.id]];
    }
    if (str.length) {
        str = [str substringToIndex:str.length - 1];
    }
    [workSheet loadDataMemberIds:str];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getBanner) {
        
        [self.tableView.mj_header endRefreshing];
        self.banners = resp.body;
        if (self.banners.count) {
            self.tableView.tableHeaderView = self.endlessScrollView;
            [self.endlessScrollView refreshEndlessViewWithImages:self.banners];
        }else{
            self.tableView.tableHeaderView = nil;
//            [self.endlessScrollView refreshEndlessViewWithImages:self.banners];
        }
    }
    
    if (resp.cmdId == HQCMD_finishOrActiveTask || resp.cmdId == HQCMD_finishOrActiveChildTask || resp.cmdId == HQCMD_finishOrActivePersonnelTask) {// 任务激活
        
        self.handleTask.complete_status = [self.handleTask.complete_status isEqualToNumber:@1]?@0:@1;
        self.handleTask.finishType = self.handleTask.complete_status;
        if ([self.handleTask.finishType isEqualToNumber:@0]) {
            self.handleTask.activeNum = @([self.handleTask.activeNum integerValue] + 1);
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
//        for (TFWorkSheetView *view in self.sheets) {
//            [view refreshData];
//        }
        
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
        
        [self.tableView.mj_header endRefreshing];
        NSDictionary *dict = resp.body;
        NSString *str = [dict valueForKey:@"haveChagnePrivilege"];
        self.changePeopleView.auth = [str description];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}
#pragma mark - 子控制器
-(void)setupChildVc{
    TFModelEnterController *enter = [[TFModelEnterController alloc] init];
    enter.openOften = YES;
    [self addChildViewController:enter];
    self.tableView.tableFooterView = enter.view;
    __weak __typeof(enter)weakEnter = enter;
    enter.heightBlock = ^(NSNumber *parameter) {
        weakEnter.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, [parameter floatValue]);
        self.tableView.tableFooterView = weakEnter.view;
        [self.tableView setContentOffset:(CGPoint){0,} animated:NO];
    };
    self.childVc = enter;
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-TabBarHeight-BottomM) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;

    tableView.mj_header = [TFRefresh headerNormalRefreshWithBlock:^{
        
        [self refrehData];// 刷新数据
        
    }];
    
}
#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    return self.taskView;
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    return Long(150);
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y <= 2) {
        self.shadowLine.hidden = YES;
    }else{
        self.shadowLine.hidden = NO;
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
