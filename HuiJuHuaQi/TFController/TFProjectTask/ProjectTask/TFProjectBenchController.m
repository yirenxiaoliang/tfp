//
//  TFProjectBenchController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectBenchController.h"
#import "TFBenchView.h"
#import "TFProjectSectionModel.h"
#import "TFEndlessView.h"
#import "YPTabBar.h"
#import "TFProjectRowFrameModel.h"
#import "TFLoginBL.h"
#import "TFProjectTaskBL.h"
#import "TFModelEnterController.h"
#import "PopoverView.h"
#import "HQTFSelectCompanyController.h"
#import "TFEnterpriseFlowListController.h"
#import "TFProjectTaskDetailController.h"
#import "TFCreateNoteController.h"
//#import "TFCustomDetailController.h"
#import "TFNewCustomDetailController.h"
#import "TFApprovalDetailController.h"
#import "TFProjectTaskBL.h"

#define ADHEIGHT 160

@interface TFProjectBenchController ()<TFBenchViewDelegate,YPTabBarDelegate,HQBLDelegate,UIAlertViewDelegate>

/** moving */
@property (nonatomic, assign) BOOL moving;
/** tabBar */
@property (nonatomic, strong) YPTabBar *tabBar;
/** endlessScrollView */
@property (nonatomic, strong) TFEndlessView *endlessScrollView;

/** moveView */
@property (nonatomic, weak) TFBenchView *moveView;

/** lastPoint */
@property (nonatomic, assign) CGFloat lastPoint;
/** currentPoint */
@property (nonatomic, assign) CGFloat currentPoint;

/** TFLoginBL */
@property (nonatomic, strong) TFLoginBL *loginBL;

/** banners */
@property (nonatomic, strong) NSArray *banners;

/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** flows */
@property (nonatomic, strong) NSMutableArray *flows;

/** selectIndex */
@property (nonatomic, assign) NSInteger selctIndex;

/** line */
@property (nonatomic, weak) UIView *line;
/** handleTask */
@property (nonatomic, strong) TFProjectRowModel *handleTask;

/** lastScrollView */
@property (nonatomic, strong) UIScrollView *lastScrollView;


@end

@implementation TFProjectBenchController

-(NSMutableArray *)flows{
    if (!_flows) {
        _flows = [NSMutableArray array];
    }
    return _flows;
}

-(TFEndlessView *)endlessScrollView{
    if (!_endlessScrollView) {
        _endlessScrollView = [[TFEndlessView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,ADHEIGHT}];
    }
    return _endlessScrollView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){SCREEN_WIDTH,0.5}]];
    
    self.navigationItem.leftBarButtonItem = [self titleItemWithTitle:UM.userLoginInfo.company.company_name color:BlackTextColor imageName:nil withTarget:self action:@selector(changeCompany)];
    
    [self.loginBL requestGetBanner];
    [self.moveView loadAllData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)leftClicked{
    TFModelEnterController *model = [[TFModelEnterController alloc] init];
    [self.navigationController pushViewController:model animated:YES];
}

- (void)rightClicked{
    
    PopoverView *popView = [[PopoverView alloc] initWithPoint:(CGPoint){SCREEN_WIDTH-10,64} titles:@[@"时间工作流",@"企业工作流"] images:nil];
    popView.selectRowAtIndex = ^(NSInteger index) {
        
        self.selctIndex = index;
        
        if (index == 0) {
            
            NSMutableArray *arr = [NSMutableArray array];
            NSArray *titles = @[@"超期任务",@"今日任务",@"明日任务",@"以后任务"];
            for (NSInteger i = 0; i < titles.count; i++) {
                TFProjectSectionModel *model = [[TFProjectSectionModel alloc] init];
                model.id = @(i + 1);
                model.name = titles[i];
                [arr addObject:model];
            }
            self.flows = arr;
            [self.moveView refreshMoveViewWithModels:arr withType:0];
            [self refreshTabBarWithTitles:arr];
            [self.moveView loadAllData];
            
        }else{
            
            TFEnterpriseFlowListController *flow = [[TFEnterpriseFlowListController alloc] init];
            
            flow.parameter = ^(NSMutableArray *parameter) {
                
                self.flows = parameter;
                [self.moveView refreshMoveViewWithModels:parameter withType:1];
                [self refreshTabBarWithTitles:parameter];
                [self.moveView loadAllData];
                
            };
            
            [self.navigationController pushViewController:flow animated:YES];
        }
        
        
    };
    [popView show];
}

- (void)changeCompany{
    
    HQTFSelectCompanyController *select = [[HQTFSelectCompanyController alloc] init];
    [self.navigationController pushViewController:select animated:YES];
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
        [self.moveView refreshData];
        
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
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
//    [self.projectTaskBL requestGetWorkBenchList];
    
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
    
    [self.view addSubview:self.endlessScrollView];
    [self.view addSubview:self.tabBar];
    
//    UINavigationItem *item2 = [self itemWithTarget:self action:@selector(leftClicked) image:@"工作台-更多应用" highlightImage:@"工作台-更多应用"];
//    UINavigationItem *item1 = [self itemWithTarget:self action:@selector(rightClicked) image:@"工作台-切换" highlightImage:@"工作台-切换"];
//    self.navigationItem.rightBarButtonItems = @[item1,item2];
    UINavigationItem *item2 = [self itemWithTarget:self action:@selector(leftClicked) image:@"工作台-更多应用" highlightImage:@"工作台-更多应用"];
    self.navigationItem.rightBarButtonItems = @[item2];
    self.navigationItem.title = nil;
    
    self.enablePanGesture = YES;
    TFBenchView *moveView = [[TFBenchView alloc] initWithFrame:CGRectMake(0, ADHEIGHT+44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomHeight-44)];
    moveView.delegate = self;
    [self.view insertSubview:moveView atIndex:0];
    self.moveView = moveView;
    
    self.moveView.backgroundColor = WhiteColor;
    self.view.backgroundColor = WhiteColor;
    
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *titles = @[@"超期任务",@"今日任务",@"明日任务",@"以后任务"];
    for (NSInteger i = 0; i < titles.count; i++) {
        TFProjectSectionModel *model = [[TFProjectSectionModel alloc] init];
        model.id = @(i + 1);
        model.name = titles[i];
        [arr addObject:model];
    }
    self.flows = arr;
    [self.moveView refreshMoveViewWithModels:arr withType:0];
    [self refreshTabBarWithTitles:arr];
    [self.moveView loadAllData];
}


- (void)refreshTabBarWithTitles:(NSArray *)titles{
    
    // 刷新tabbar
    NSMutableArray<YPTabItem *> *items = [NSMutableArray<YPTabItem *> array];
    for (NSInteger i = 0; i < titles.count; i++) {
        TFProjectSectionModel *model = titles[i];
        YPTabItem *item = [[YPTabItem alloc] init];
        item.title = model.name;
        [items addObject:item];
    }
    self.tabBar.items = items;
    self.tabBar.selectedItemIndex = 0;
    if (self.selctIndex == 0) {
        self.tabBar.itemSelectedBgColor = HexColor(0xFC591F);
        self.tabBar.itemTitleSelectedColor = HexColor(0xFC591F);
    }else{
        self.tabBar.itemSelectedBgColor = GreenColor;
        self.tabBar.itemTitleSelectedColor = GreenColor;
    }
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:20];
    if (titles.count) {
        self.line.hidden = NO;
    }else{
        self.line.hidden = YES;
    }
    
}


-(YPTabBar *)tabBar{
    
    if (!_tabBar) {
        _tabBar = [[YPTabBar alloc] initWithFrame:(CGRect){0,ADHEIGHT,SCREEN_WIDTH,44}];
        [self.view addSubview:_tabBar];
        _tabBar.delegate = self;
        _tabBar.itemTitleColor = HexColor(0x909090);
        _tabBar.itemTitleSelectedColor = GreenColor;
        _tabBar.itemSelectedBgColor = GreenColor;
        _tabBar.itemTitleFont = [UIFont systemFontOfSize:16];
        _tabBar.itemTitleSelectedFont = FONT(16);
        _tabBar.selectedItemIndex = 0 ;
        _tabBar.leftAndRightSpacing = 20;
        _tabBar.backgroundColor = WhiteColor;
//        [_tabBar setScrollEnabledAndItemWidth:(SCREEN_WIDTH-40)/4];
        [_tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:20];
        [_tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(42, 10, 0,10) tapSwitchAnimated:NO];
        
        
    }
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,0.5}];
    [_tabBar addSubview:line];
    line.backgroundColor = HexColor(0xAFAFAF);
    _tabBar.layer.masksToBounds = NO;
    line.hidden = YES;
    self.line = line;
    return _tabBar;
}


#pragma mark - YPTabBarDelegate
-(void)yp_tabBar:(YPTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index{
    
    if (self.moving)return;
    
    self.moveView.selectPage = index;
}

#pragma mark - TFMoveViewDelegate
-(void)moveView:(TFBenchView *)moveView didClickedFinishItem:(TFProjectRowModel *)model{
    
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
            
            [self.projectTaskBL requestPersonnelTaskFinishOrActiveWithTaskId:self.handleTask.id];
            
            
        }else if (alertView.tag == 0x222) {// 完成项目任务
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.handleTask.taskInfoId completeStatus:@1 remark:nil];
            [self.projectTaskBL requestTaskFinishOrActiveWithTaskId:self.handleTask.bean_id completeStatus:@1 remark:nil];
            
        }
        
    }
}

/** 点击 */
-(void)moveView:(TFBenchView *)moveView didClickedItem:(TFProjectRowModel *)model{
    
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
            [self.moveView refreshData];
        };
        detail.deleteAction = ^{
            TFProjectSectionModel *sec = self.flows[self.moveView.selectPage];
            
            [self.moveView loadDataWithSectionModel:sec index:self.moveView.selectPage];
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

-(void)moveView:(TFBenchView *)moveView changePage:(NSInteger)page{
    
    self.tabBar.selectedItemIndex = page;
}

-(void)moveViewWillMoing{
    self.moving = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.tabBar.y = 0;
        self.endlessScrollView.bottom = self.tabBar.top;
        self.moveView.top = self.tabBar.bottom;
    }];
}

-(void)moveView:(TFBenchView *)moveView dataChanged:(NSArray *)models destinationIndex:(NSInteger)destinationIndex moveModel:(TFProjectRowModel *)moveModel{
    
    self.moving = NO;
    
    if (self.selctIndex == 0) {// 时间工作台
        
        TFProjectSectionModel *sec = models[destinationIndex];
        NSMutableArray *arr = [NSMutableArray array];
        for (TFProjectRowModel *row in sec.tasks) {
            NSDictionary *dict = [row toDictionary];
            if (dict) {
                [arr addObject:dict];
            }
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requestTimeWorkBenchMoveWithTimeId:moveModel.timeId workbenchTag:@(destinationIndex+1) dataList:arr];
        
    }else{// 企业工作台
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        TFProjectSectionModel *sec = self.flows[destinationIndex];
        [self.projectTaskBL requestEnterpriseWorkBenchMoveWithTaskId:moveModel.id flowId:sec.key];
    }
    
}

-(void)moveView:(TFBenchView *)moveView didEndScrolloWithScrollView:(UIScrollView *)scrollView{

    if (self.tabBar.y < ADHEIGHT/2) {

        [UIView animateWithDuration:0.25 animations:^{

            self.tabBar.top = 0;
            self.endlessScrollView.bottom = self.tabBar.top;
            self.moveView.top = self.tabBar.bottom;
        }];
    }else{

        [UIView animateWithDuration:0.25 animations:^{

            self.endlessScrollView.y = 0;
            self.tabBar.top = self.endlessScrollView.bottom;
            self.moveView.top = self.tabBar.bottom;
        }];

    }
}

//-(void)moveView:(TFBenchView *)moveView scrollView:(UIScrollView *)scrollView{
//
////    HQLog(@"===========%f=========",scrollView.contentOffset.y);
//
//    if (self.moving) return;
//
//    if (scrollView.contentOffset.y < 0 ) {
//
//        if (self.tabBar.y == 0) {
//            [UIView animateWithDuration:0.25 animations:^{
//
//                self.endlessScrollView.y = 0;
//                self.tabBar.top = self.endlessScrollView.bottom;
//                self.moveView.top = self.tabBar.bottom;
//            }];
//        }
//        return;
//    }
//
//    if (scrollView.contentOffset.y+self.moveView.height >= scrollView.contentSize.height) {
//        return;
//    }
//
//    self.currentPoint = scrollView.contentOffset.y;
//
//    if (self.lastPoint >= self.currentPoint) {// 往下走
//
//        self.endlessScrollView.y += (self.lastPoint - self.currentPoint);
//        self.tabBar.y += (self.lastPoint - self.currentPoint);
//        if (self.endlessScrollView.y >= 0) {
//            self.endlessScrollView.y = 0;
//        }
//        self.tabBar.top = self.endlessScrollView.bottom;
//        self.moveView.top = self.tabBar.bottom;
//
////        if (self.tabBar.y > 3*ADHEIGHT/4) {
////
////            [UIView animateWithDuration:0.25 animations:^{
////
////                self.endlessScrollView.y = 0;
////                self.tabBar.top = self.endlessScrollView.bottom;
////                self.moveView.top = self.tabBar.bottom;
////            }];
////        }
//
//    }else{// 往上走
//
//        self.endlessScrollView.y -= (self.currentPoint - self.lastPoint);
//        self.tabBar.y -= (self.currentPoint - self.lastPoint);
//        if (self.tabBar.y <= 0) {
//            self.tabBar.y = 0;
//        }
//        self.endlessScrollView.bottom = self.tabBar.top;
//        self.moveView.top = self.tabBar.bottom;
//
////        if (self.tabBar.y < ADHEIGHT/4) {
////
////            [UIView animateWithDuration:0.25 animations:^{
////
////                self.tabBar.top = 0;
////                self.endlessScrollView.bottom = self.tabBar.top;
////                self.moveView.top = self.tabBar.bottom;
////            }];
////        }
//    }
//
//    self.lastPoint = self.currentPoint;
//
//}


-(void)moveView:(TFBenchView *)moveView scrollView:(UIScrollView *)scrollView{

    HQLog(@"===========%f=========",scrollView.contentOffset.y);
    if (scrollView == self.lastScrollView) {
        
        self.tabBar.y = ADHEIGHT - scrollView.contentOffset.y;
        if (self.tabBar.y <= 0) {
            self.tabBar.y = 0;
        }else if (self.tabBar.y >= ADHEIGHT){
            self.tabBar.y = ADHEIGHT;
        }
        self.endlessScrollView.bottom = self.tabBar.top;
        self.moveView.top = self.tabBar.bottom;
        
    }else{
        
        
    }
    
    self.lastScrollView = scrollView;
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
