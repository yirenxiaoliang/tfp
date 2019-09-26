//
//  HQMyWorksController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/1.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQMyWorksController.h"

#import "HQAdvertisementView.h"
#import "HQTFBenchCell.h"
#import "HQRootButton.h"
#import "HQTFDateView.h"
#import "HQTFScheduleView.h"
#import "HQTFTaskHeadView.h"
#import "HQTFTaskCell.h"
#import "HQTFNoticeButton.h"
#import "FDActionSheet.h"
#import "HQTFModelBenchController.h"
#import "HQBaseNavigationController.h"
#import "HQTFNoContentCell.h"
//#import "HQTFProjectMainController.h"
#import "Scan_VC.h"
#import "HQBenchTimeCell.h"
//#import "HQTFProjectBarcodeController.h"
#import "TFMainTaskModel.h"
#import "TFMainScheduleModel.h"
#import "HQTFSelectCompanyController.h"
#import "HQTFRepeatSelectView.h"
#import "HQTFTimePeriodView.h"
#import "TFSendView.h"
#import "HQMainSliderView.h"
#import "HQTFMyWorkBenchCell.h"
#import "TFProjTaskModel.h"
//#import "HQTFTaskRowController.h"
//#import "TFProjectBL.h"
#import "TFWorkBenchModel.h"
#import "HQTFUploadFileView.h"
//#import "HQTFTaskMainController.h"
#import "TFScheduleTimeView.h"
//#import "TFSetPasswordController.h"
#import "GFCalendarView.h"
//#import "TFApprovalDetailMainController.h"
#import "TFStatisticsController.h"
//#import "TFDownloadFileListController.h"
#import "TFCompanyFrameworkController.h"
#import "TFMapController.h"
#import "TFAddCustomController.h"
#import "TFDateView.h"
#import "TFSelectDateView.h"
#import "TFSelectCalendarView.h"
#import "TFCustomListController.h"
#import "TFCustomShareController.h"
#import "TFTagListView.h"
#import "TFMutilFileUploadController.h"
#import "TFStatisticsMainController.h"
#import "TFBurWindowView.h"

@interface HQMyWorksController ()<UITableViewDataSource, UITableViewDelegate,FDActionSheetDelegate,HQTFMyWorkBenchCellDelegate,YPTabBarDelegate,TFScheduleTimeViewDelegate>

@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)HQAdvertisementView *advertisementView;  //上方广告视图
/** 模块视图 */
@property (nonatomic, strong) UIView *modelView;
/** 导航视图 */
@property (nonatomic, strong) UIView *naviView;
/** line视图 */
@property (nonatomic, strong) UIView *lineView;
/** date视图 */
@property (nonatomic, strong) HQTFDateView *dateView;
/** scheduleView视图 */
@property (nonatomic, strong) HQTFScheduleView *scheduleView;
/** taskHeadView视图 */
@property (nonatomic, strong) HQTFTaskHeadView *taskHeadView;
/** noticeButton视图 */
@property (nonatomic, strong) HQTFNoticeButton *noticeButton;
/** outsideBtn视图 */
@property (nonatomic, strong) UIButton *outsideBtn;
/** saoBtn视图 */
@property (nonatomic, strong) UIButton *saoBtn;
/** companyBtn视图 */
@property (nonatomic, strong) UIButton *companyBtn;

/** HQMainSliderView *view */
@property (nonatomic, strong) HQMainSliderView *sliderView;

/** 滑动 */
@property (nonatomic, assign) BOOL isScroll;

/** 二维数组，任务列表 */
@property (nonatomic, strong) NSMutableArray *taskList;


/** TFWorkBenchModel */
@property (nonatomic, strong) TFWorkBenchModel *benchModel;

/** 记录任务列表序号 */
@property (nonatomic, assign) NSUInteger index;

/**  */
@property (nonatomic, strong) id moveTask;


@end

@implementation HQMyWorksController


-(NSMutableArray *)taskList{
    if (!_taskList) {
        _taskList = [NSMutableArray array];
    }
    return _taskList;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [_advertisementView activeTime];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexAColor(0xc8c8c8,1) size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
    
    [_outsideBtn setTitle:TEXT(UM.userLoginInfo.company.company_name) forState:UIControlStateNormal];
    
    
//    [self setupScheduleTimeView];
//    NSString *string = [HQHelper stringForMD5WithString:@"123456"];
//    [self setupddd];
}

//- (void)setupddd{
//    CGFloat width = self.view.bounds.size.width - 20.0;
//    CGPoint origin = CGPointMake(10.0, 64.0 + 70.0);
//    
//    GFCalendarView *calendar = [[GFCalendarView alloc] initWithFrameOrigin:origin width:width];
//    calendar.selectDate = [NSDate date];
//    
//    calendar.selectDateAction = ^(id parameter) {
//        
//        HQLog(@"%@",parameter);
//    };
//    
//    [self.view addSubview:calendar];
//}

//- (void)setupScheduleTimeView{
//    
//    TFScheduleTimeView *view = [[TFScheduleTimeView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,Long(130)} withSelectTime:[HQHelper getNowTimeSp] withType:1];
//    view.delegate = self;
//    [self.view addSubview:view];
//}
//#pragma mark - TFScheduleTimeViewDelegate
//-(void)scheduleTimeView:(TFScheduleTimeView *)scheduleTimeView selectTimeSp:(long long)timeSp{
//    
//    HQLog(@"-----%@-----",[HQHelper nsdateToTimeNowYear:timeSp]);
//}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [_advertisementView pauseTime];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexAColor(0xc8c8c8, 1) size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFromNavBottomEdgeLayout];
    [self setupTableView];
    [self setupMainSliderView];
//    [self setupScheduleView];
//    [self setupTaskHeadView];
    [self setupNavigation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(childTableViewScroll:) name:WorkBenchChildTableViewScrollNotifition object:nil];
    
//    self.projectBL = [TFProjectBL build];
//    self.projectBL.delegate = self;
    
//    [self setupTFTagListView];
    
}


- (void)setupTFTagListView{
    TFTagListView *view = [[TFTagListView alloc] initWithFrame:(CGRect){0,100,SCREEN_WIDTH,300}];
    view.backgroundColor = RedColor;
    [self.view addSubview:view];
    
    NSArray *arr = @[@"我是我是我是我是我是我是我是我是我是我是我是",@"我是我是我是我是我是我是我是我是",@"我是我是我是我是我是我是我是",@"我是我是我是我是我是我是",@"我是我是我是我是我是",@"我是我是我是我是",@"我是我是我是",@"我是我是",@"我是"];
    
    NSMutableArray *models = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        
        TFCustomerOptionModel *model = [[TFCustomerOptionModel alloc] init];
        model.label = arr[ABS(arc4random_uniform((int)arr.count))];
        model.color = @"#23ab78";
        [models addObject:model];
    }
    
    [view refreshWithOptions:models];
    
}

- (void)childTableViewScroll:(NSNotification *)note{
    
    BOOL isScroll = [note.object boolValue];
    
    self.tableView.scrollEnabled = !isScroll;

    if (self.tableView.scrollEnabled) {
        
        HQLog(@"&&&&&&&&&&%d",isScroll);
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.tableView.contentOffset = CGPointMake(0, 0);
        }];
    }
    
}

-(void)dealloc{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Navigation
- (void)setupNavigation{
    
    UIButton *leftBarButtonItem = [HQHelper buttonWithFrame:(CGRect){0,20,44,44} normalImageStr:@"透明统计" highImageStr:@"透明统计" target:self action:@selector(leftClicked)];
    self.saoBtn = leftBarButtonItem;
    
    UIButton *rightBarButtonItem = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH-44,20,44,44} normalImageStr:@"企业" highImageStr:@"企业" target:self action:@selector(rightClicked)];
    self.companyBtn = rightBarButtonItem;
    
    
    _outsideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _outsideBtn.frame = CGRectMake(0, 20, SCREEN_WIDTH-100, 44);
    [_outsideBtn setTitle:TEXT(UM.userLoginInfo.company.company_name) forState:UIControlStateNormal];
    [_outsideBtn setTitleColor:WhiteColor forState:0];
    _outsideBtn.titleLabel.font = FONT(20);
    
    UIView *naviView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,64}];
    [self.view addSubview:naviView];
    self.naviView =naviView;
    
    _outsideBtn.centerX = SCREEN_WIDTH/2;
    
    [naviView addSubview:leftBarButtonItem];
    [naviView addSubview:rightBarButtonItem];
    [naviView addSubview:_outsideBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){0,64-.5,SCREEN_WIDTH,0.5}];
    lineView.backgroundColor = HexAColor(0xc8c8c8, 0);
    [self.view addSubview:lineView];
    self.lineView = lineView;
}

- (void)setupTFBurWindowView{
//    TFBurWindowView *view = [[TFBurWindowView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:view];
//    
//    [view refreshItemWithModels:@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""] rect:CGRectZero type:0];
}

- (void)leftClicked{
    
//    [self setupTFBurWindowView];return;
//    UIView *view = [[UIView alloc] initWithFrame:(CGRect){100,100,1,100}];
//    [self.view addSubview:view];
//    view.backgroundColor = WhiteColor;
//    
//    [HQHelper drawVerDashLine:view lineLength:8 lineSpacing:2 lineColor:GreenColor];
//
//    TFStatisticsController *statistics = [[TFStatisticsController alloc] init];
//    [self.navigationController pushViewController:statistics animated:YES];
//    
//    TFCompanyFrameworkController *companyGroup = [[TFCompanyFrameworkController alloc] init];
//    companyGroup.type = 0;
//    [self.navigationController pushViewController:companyGroup animated:YES];
//    return;
//    TFMutilFileUploadController *list = [[TFMutilFileUploadController alloc] init];
//    [self.navigationController pushViewController:list animated:YES];
//    return;
//    TFStatisticsMainController *sta = [[TFStatisticsMainController alloc] init];
//    [self.navigationController pushViewController:sta animated:YES];
    
    HQTFModelBenchController *list = [[HQTFModelBenchController alloc] init];
    [self.navigationController pushViewController:list animated:YES];
    return;
//    TFCustomShareController *list = [[TFCustomShareController alloc] init];
//    list.type = 0;
//    [self.navigationController pushViewController:list animated:YES];
//    return;
//    TFCustomListController *list = [[TFCustomListController alloc] init];
//    [self.navigationController pushViewController:list animated:YES];
//    return;
    
//    [TFSelectCalendarView selectCalendarViewWithType:DateViewType_HourMinute timeSp:[HQHelper getNowTimeSp] onRightTouched:^(NSString *time) {
//        
//    }];
//    
//    return;
//    [TFSelectDateView selectDateViewWithType:DateViewType_Year timeSp:[HQHelper getNowTimeSp] onRightTouched:^(NSString *time) {
//        
//        
//    }];
//    
//    return;
//    TFDateView *dateView = [TFDateView selectDateViewWithFrame:(CGRect){0,64,SCREEN_WIDTH,400} type:DateViewType_HourMinuteSecond timeSp:[HQHelper getNowTimeSp]];
//    
//    [self.view addSubview:dateView];
//    
//    return;
//    TFAddCustomController *fileList = [[TFAddCustomController alloc] init];
//    fileList.type = 1;
//    fileList.bean = @"bean1512009193932";
//    fileList.tableViewHeight = SCREEN_HEIGHT - 64;
//    [self.navigationController pushViewController:fileList animated:YES];
//    TFMapController *fileList = [[TFMapController alloc] init];
//    [self.navigationController pushViewController:fileList animated:YES];
//    TFCompanyFrameworkController *fileList = [[TFCompanyFrameworkController alloc] init];
//    [self.navigationController pushViewController:fileList animated:YES];
    
    
//    HQEmployModel *model = [[HQEmployModel alloc] init];
//    model.id = @4566622;
//    model.employeeName = @"伊人小亮22";
//    
//    NSDictionary *dict = @{
//                                  @"bean":@"客人22",
//                                  @"title":@"客人22",
//                                  @"version":@"客人22",
//                                  @"layout":[model toJSONString]
//                                  };
//    [CDM saveLayoutWithDic:dict];
//    
    
//    NSArray *arr = @[@"rredfsaf",@"rrsdfs",@"rrsds",@"sdrrfs",@"grrr",@"rfrr"];
//    
//    NSPredicate *pr = [NSPredicate predicateWithFormat:@"SELF == 'sds'"];
//    
//    NSArray *arr2 = [arr filteredArrayUsingPredicate:pr];
//    
//    for (NSString *str in arr2) {
//        HQLog(@"%@",str);
//    }
    
    
//    NSInteger value = -3;
//    NSAssert(value >= 0, @"条件不成立，即断言失败，程序终止");
    
//    return;
//    [HQTFUploadFileView showAlertView:@"更多操作" withType:0 parameterAction:^(id parameter) {
//        
//    }];
    
    
    
//    TFFinishPersonDataController *taskRow = [[TFFinishPersonDataController alloc] init];
//    taskRow.type = FinishDataType_person;
//    [self.navigationController pushViewController:taskRow animated:YES];
//    return;
    
//    [TFSendView showAlertView:@"发送给："
//                       people:nil
//                      content:@"我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个络地址哦"
//                     password:@"3456"
//                      endTime:@"2017-09-08"
//                   placehoder:@"我想说点东西"
//                onLeftTouched:^{
//                    
//                }
//               onRightTouched:^(id parameter){
//                   
//               }];
    
    //    [HQTFRepeatSelectView selectTimeViewWithStartWithType:0 start:@"5" end:@"" timeArray:^(NSArray *array) {
    //
    //        HQLog(@"%@",array);
    //    }];
    //    [HQTFTimePeriodView selectTimeViewWithStartTimeSp:33333333 endTimeSp:66666666666 timeSpArray:^(NSArray *array) {
    //
    //    }];
    
//        Scan_VC * vc=[[Scan_VC alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    HQTFTaskRowController *taskRow = [[HQTFTaskRowController alloc] init];
//    [self.navigationController pushViewController:taskRow animated:YES];
}

- (void)rightClicked{
    HQTFSelectCompanyController *company = [[HQTFSelectCompanyController alloc] init];
    [self.navigationController pushViewController:company animated:YES];
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    tableView.backgroundColor = BackGroudColor;
//    [self setupAdvertisementView];
//    tableView.tableHeaderView = _advertisementView;
    tableView.layer.masksToBounds = NO;
    
//    UILabel *label = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    //    label.backgroundColor = GreenColor;
//    tableView.tableFooterView = label;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self setupScrollView];
    
    [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
}

#pragma mark - HQMainSliderView
- (void)setupMainSliderView{
    
//    HQTFDateView *dateView = [HQTFDateView dateView];
//    dateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
//    dateView.lineB.hidden = YES;
//    self.dateView = dateView;
    //    dateView.backgroundColor = RedColor;
    
    HQMainSliderView *view = [[HQMainSliderView alloc] initWithFrame:(CGRect){0,120,SCREEN_WIDTH,83}];
    view.tabBar.delegate = self;
    self.sliderView = view;
}
//#pragma mark - scheduleView
//- (void)setupScheduleView{
//    HQTFScheduleView *scheduleView = [HQTFScheduleView scheduleView];
//    self.scheduleView = scheduleView;
//}
//
//#pragma mark - TaskHeadView
//- (void)setupTaskHeadView{
//    
//    HQTFTaskHeadView *taskHeadView = [[HQTFTaskHeadView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
//    self.taskHeadView = taskHeadView;
//    
//}
#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sliderView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
            
    HQTFMyWorkBenchCell *cell = [HQTFMyWorkBenchCell myWorkBenchCellWithTableView:tableView];
    cell.delegate = self;
//    cell.taskList = self.taskList;
    [cell refreshMyWorkBenchCellWithModel:self.benchModel];
    cell.contentView.layer.masksToBounds = NO;
    cell.layer.masksToBounds = NO;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 83;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_HEIGHT-83-64-49;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - HQTFMyWorkBenchCellDelegate
/** 任务 */
-(void)myWorkBenchCellDidClickedTask:(TFProjTaskModel *)model{
    
//    HQTFTaskMainController *taskMain = [[HQTFTaskMainController alloc] init];
//    taskMain.projectTask = model;
//    
//    [self.navigationController pushViewController:taskMain animated:YES];
}

/** 审批 */
-(void)myWorkBenchCellDidClickedApproval:(TFApprovalItemModel *)model{
    
//    TFApprovalDetailMainController *approval = [[TFApprovalDetailMainController alloc] init];
//    approval.approvalId = model.id;
//    approval.taskId = model.id;
//    approval.approvalType = (FunctionModelType)(FunctionModelTypeAll + [model.type integerValue]);
//    [self.navigationController pushViewController:approval animated:YES];
}

-(void)myWorkBenchCellWithScrollView:(UIScrollView *)scrollView{
    
    [self.sliderView.tabBar updateSubViewsWhenParentScrollViewScroll:scrollView];

//    HQTFMyWorkBenchCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    cell.open = NO;
    
}
-(void)myWorkBenchCellWithSelectIndex:(NSInteger)selectIndex{
    
    self.sliderView.tabBar.selectedItemIndex = selectIndex;
    
}

-(void)myWorkBenchCellDidDownBtnWithSelectIndex:(NSInteger)selectIndex withModel:(id)model{
    
    self.moveTask = model;
    
    if ([model isKindOfClass:[TFProjTaskModel class]]) {
        if (self.index == 0) {
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"移动至" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"今天要做",@"明天要做",@"以后要做",nil];
            
            [sheet show];
        }else if (self.index == 1){
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"移动至" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"明天要做",@"以后要做",nil];
            
            [sheet show];
        }else if (self.index == 2){
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"移动至" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"今天要做",@"以后要做",nil];
            
            [sheet show];
        }else{
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"移动至" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"今天要做",@"明天要做",nil];
            
            [sheet show];
        }

        
    }else{
        
        if (self.index == 0) {
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"移动至" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"今天要做",@"明天要做",@"以后要做",nil];
            
            [sheet show];
        }else if (self.index == 1){
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"移动至" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"明天要做",@"以后要做",nil];
            
            [sheet show];
        }else if (self.index == 2){
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"移动至" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"今天要做",@"以后要做",nil];
            
            [sheet show];
        }else{
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"移动至" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"今天要做",@"明天要做",nil];
            
            [sheet show];
        }

    }
    
}


-(void)myWorkBenchCellDidFinishBtn:(UIButton *)button withModel:(TFProjTaskModel *)model{
    
    
    model.taskStatus = button.selected?@0:@1;
    NSInteger finish = 0;
    if ([model.taskStatus isEqualToNumber:@0]) {
        model.activeCount = @([model.activeCount integerValue] + 1);
        finish = -1;
    }else{
        finish = 1;
    }
    switch (self.index) {
        case 0:
        {
            self.benchModel.overdueTask.finishTaskCount = @(([self.benchModel.overdueTask.finishTaskCount integerValue] + finish) <= 0?0:([self.benchModel.overdueTask.finishTaskCount integerValue] + finish));
            [self.sliderView refreshSliderViewWithFinishTask:[self.benchModel.overdueTask.finishTaskCount integerValue] totalTask:[self.benchModel.overdueTask.taskCount integerValue]];
        }
            break;
        case 1:
        {
            self.benchModel.todayTask.finishTaskCount = @(([self.benchModel.todayTask.finishTaskCount integerValue] + finish) <= 0?0:([self.benchModel.todayTask.finishTaskCount integerValue] + finish));
            [self.sliderView refreshSliderViewWithFinishTask:[self.benchModel.todayTask.finishTaskCount integerValue] totalTask:[self.benchModel.todayTask.taskCount integerValue]];
        }
            break;
        case 2:
        {
            self.benchModel.tomorrowTask.finishTaskCount = @(([self.benchModel.tomorrowTask.finishTaskCount integerValue] + finish) <= 0?0:([self.benchModel.tomorrowTask.finishTaskCount integerValue] + finish));
            [self.sliderView refreshSliderViewWithFinishTask:[self.benchModel.tomorrowTask.finishTaskCount integerValue] totalTask:[self.benchModel.tomorrowTask.taskCount integerValue]];
        }
            break;
        case 3:
        {
            self.benchModel.futureTask.finishTaskCount = @(([self.benchModel.futureTask.finishTaskCount integerValue] + finish) <= 0?0:([self.benchModel.futureTask.finishTaskCount integerValue] + finish));
            [self.sliderView refreshSliderViewWithFinishTask:[self.benchModel.futureTask.finishTaskCount integerValue] totalTask:[self.benchModel.futureTask.taskCount integerValue]];
        }
            break;
            
        default:
            break;
    }
    
    
//    [self.projectBL requestModTaskStatusWithTaskId:model.id isFinish:model.taskStatus];
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    // 1超期任务 2今天要做 3明天要做 4以后要做
    
    // 第一个任务的更新时间
    NSNumber *overTime = @0;
    NSNumber *todayTime = @0;
    NSNumber *tomorrowTime = @0;
    NSNumber *futureTime = @0;
    
    // 超期
    if (self.benchModel.overdueTask.tasks.count) {// 有任务
        
        id task1 = self.benchModel.overdueTask.tasks[0];
        
        if ([task1 isKindOfClass:[TFProjTaskModel class]]) {
            
            TFProjTaskModel *task = task1;
            
            overTime = @([task.inTime longLongValue]-1);
        }
        
        if ([task1 isKindOfClass:[TFApprovalItemModel class]]) {
            
            TFApprovalItemModel *task = task1;
            
            overTime = @([task.inTime longLongValue]-1);

        }
        
//        TFProjTaskModel *task = self.benchModel.overdueTask.tasks[0];
//        overTime = @([task.inTime longLongValue]-1);
        
    }else{
        overTime = [NSNumber numberWithLongLong:[HQHelper getNowTimeSp]-86400000-1];
    }
    
    // 今天
    if (self.benchModel.todayTask.tasks.count) {// 有任务
        
        id task1 = self.benchModel.todayTask.tasks[0];
        
        if ([task1 isKindOfClass:[TFProjTaskModel class]]) {
            
            TFProjTaskModel *task = task1;
            
            todayTime = @([task.inTime longLongValue]-1);
        }
        
        if ([task1 isKindOfClass:[TFApprovalItemModel class]]) {
            
            TFApprovalItemModel *task = task1;
            
            todayTime = @([task.inTime longLongValue]-1);
            
        }
        
//        TFProjTaskModel *task = self.benchModel.todayTask.tasks[0];
//        todayTime = @([task.inTime longLongValue]-1);
        
    }else{
        todayTime = [NSNumber numberWithLongLong:[HQHelper getNowTimeSp] - 1];
    }
    
    // 明天
    if (self.benchModel.tomorrowTask.tasks.count) {// 有任务
        
        id task1 = self.benchModel.tomorrowTask.tasks[0];
        
        if ([task1 isKindOfClass:[TFProjTaskModel class]]) {
            
            TFProjTaskModel *task = task1;
            
            tomorrowTime = @([task.inTime longLongValue]-1);
        }
        
        if ([task1 isKindOfClass:[TFApprovalItemModel class]]) {
            
            TFApprovalItemModel *task = task1;
            
            tomorrowTime = @([task.inTime longLongValue]-1);
            
        }
        
//        TFProjTaskModel *task = self.benchModel.tomorrowTask.tasks[0];
//        tomorrowTime = @([task.inTime longLongValue]-1);
        
    }else{
        tomorrowTime = [NSNumber numberWithLongLong:[HQHelper getNowTimeSp]+ 86400000-1];
    }
    
    // 将来
    if (self.benchModel.futureTask.tasks.count) {// 有任务
        
        id task1 = self.benchModel.futureTask.tasks[0];
        
        if ([task1 isKindOfClass:[TFProjTaskModel class]]) {
            
            TFProjTaskModel *task = task1;
            
            futureTime = @([task.inTime longLongValue]-1);
        }
        
        if ([task1 isKindOfClass:[TFApprovalItemModel class]]) {
            
            TFApprovalItemModel *task = task1;
            
            futureTime = @([task.inTime longLongValue]-1);
            
        }
        
//        TFProjTaskModel *task = self.benchModel.futureTask.tasks[0];
//        futureTime = @([task.inTime longLongValue]-1);
        
    }else{
        futureTime = [NSNumber numberWithLongLong:[HQHelper getNowTimeSp]+ 3*86400000-1];
    }
    
    NSNumber *itemId = nil;
    
    if ([self.moveTask isKindOfClass:[TFProjTaskModel class]]) {
        
        TFProjTaskModel *model = self.moveTask;
        itemId = model.id;
        
        if (self.index == 0) {
            if (buttonIndex == 0) {
                
//                [self.projectBL requestModTaskPositionWithTaskId:itemId inTime:todayTime];
            }else if (buttonIndex == 1){
//                [self.projectBL requestModTaskPositionWithTaskId:itemId inTime:tomorrowTime];
            }else{
//                [self.projectBL requestModTaskPositionWithTaskId:itemId inTime:futureTime];
            }
        }else if (self.index == 1){
//            if (buttonIndex == 0) {
//                [self.projectBL requestModTaskPositionWithTaskId:itemId inTime:overTime];
//            }else
            if (buttonIndex == 0){
//                [self.projectBL requestModTaskPositionWithTaskId:itemId inTime:tomorrowTime];
            }else{
//                [self.projectBL requestModTaskPositionWithTaskId:itemId inTime:futureTime];
            }
        }else if (self.index == 2){
//            if (buttonIndex == 0) {
//                [self.projectBL requestModTaskPositionWithTaskId:itemId inTime:overTime];
//            }else
            
            if (buttonIndex == 0){
//                [self.projectBL requestModTaskPositionWithTaskId:itemId inTime:todayTime];
            }else{
//                [self.projectBL requestModTaskPositionWithTaskId:itemId inTime:futureTime];
            }
        }else{
//            if (buttonIndex == 0) {
//                [self.projectBL requestModTaskPositionWithTaskId:itemId inTime:overTime];
//            }else
            
            if (buttonIndex == 0){
//                [self.projectBL requestModTaskPositionWithTaskId:itemId inTime:todayTime];
            }else{
//                [self.projectBL requestModTaskPositionWithTaskId:itemId inTime:tomorrowTime];
            }
        }

    }
    
    if ([self.moveTask isKindOfClass:[TFApprovalItemModel class]]) {
        
        TFApprovalItemModel *model = self.moveTask;
        itemId = model.id;
        
        if (self.index == 0) {
            if (buttonIndex == 0) {
                
//                [self.projectBL requestModApprovalPositionWithApproveId:itemId inTime:todayTime];
            }else if (buttonIndex == 1){
//                [self.projectBL requestModApprovalPositionWithApproveId:itemId inTime:tomorrowTime];
            }else{
//                [self.projectBL requestModApprovalPositionWithApproveId:itemId inTime:futureTime];
            }
        }else if (self.index == 1){
            if (buttonIndex == 0){
//                [self.projectBL requestModApprovalPositionWithApproveId:itemId inTime:tomorrowTime];
            }else{
//                [self.projectBL requestModApprovalPositionWithApproveId:itemId inTime:futureTime];
            }
        }else if (self.index == 2){
           if (buttonIndex == 0){
//                [self.projectBL requestModApprovalPositionWithApproveId:itemId inTime:todayTime];
            }else{
//                [self.projectBL requestModApprovalPositionWithApproveId:itemId inTime:futureTime];
            }
        }else{
            if (buttonIndex == 0){
//                [self.projectBL requestModApprovalPositionWithApproveId:itemId inTime:todayTime];
            }else{
//                [self.projectBL requestModApprovalPositionWithApproveId:itemId inTime:tomorrowTime];
            }
        }

    }

    
   
}


#pragma mark - SliderViewDelegate
-(void)yp_tabBar:(YPTabBar *)tabBar willSelectItemAtIndex:(NSUInteger)index{
    
    HQTFMyWorkBenchCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.selectIndex = index;
    self.index = index;
    
    if (index == 0) {
        [self.sliderView refreshSliderViewWithFinishTask:[self.benchModel.overdueTask.finishTaskCount integerValue] totalTask:[self.benchModel.overdueTask.taskCount integerValue]];
    }else if (index == 1){
        [self.sliderView refreshSliderViewWithFinishTask:[self.benchModel.todayTask.finishTaskCount integerValue] totalTask:[self.benchModel.todayTask.taskCount integerValue]];
    }else if (index == 2){
        [self.sliderView refreshSliderViewWithFinishTask:[self.benchModel.tomorrowTask.finishTaskCount integerValue] totalTask:[self.benchModel.tomorrowTask.taskCount integerValue]];
    }else{
        [self.sliderView refreshSliderViewWithFinishTask:[self.benchModel.futureTask.finishTaskCount integerValue] totalTask:[self.benchModel.futureTask.taskCount integerValue]];
    }
}

#pragma mark - 初始化广告视图
- (void)setupAdvertisementView
{
    
    _advertisementView = [[HQAdvertisementView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Long(105))];
    _advertisementView.tableView.frame = CGRectMake(0, -64, SCREEN_WIDTH, Long(105)+64);
    _advertisementView.rowHeight = Long(105)+64;
    _advertisementView.pageColor = HexAColor(0xffffff, 0.4);
    _advertisementView.pageCurrentColor = HexAColor(0xffffff, 1);
    _advertisementView.datas = [NSMutableArray arrayWithArray:@[[UIImage imageNamed:@"滚屏图1"],[UIImage imageNamed:@"滚屏图2"],[UIImage imageNamed:@"滚屏图3"]]];
}

- (void)setupScrollView{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Long(105))];
    self.tableView.tableHeaderView = scrollView;
    NSMutableArray *images = [NSMutableArray arrayWithArray:@[[UIImage imageNamed:@"滚屏图3"],[UIImage imageNamed:@"滚屏图1"],[UIImage imageNamed:@"滚屏图2"],[UIImage imageNamed:@"滚屏图3"],[UIImage imageNamed:@"滚屏图1"]]];
    scrollView.layer.masksToBounds = NO;
    
    scrollView.contentSize = CGSizeMake(images.count * SCREEN_WIDTH, Long(105));
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    for (NSInteger i = 0; i < images.count; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){i*SCREEN_WIDTH,-64,SCREEN_WIDTH,Long(105)+64}];
        [scrollView addSubview:imageView];
        imageView.image = images[i];
    }
    
    
    
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat minAlphaOffset = 0;
    
    CGFloat maxAlphaOffset = Long(105);
    
    CGFloat offset = scrollView.contentOffset.y;
    
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    
    //    if (offset >= Long(105) + 64) {
    //        if (_tableView.contentSize.height <= _tableView.height) {
    //            return;
    //        }
    //        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64);
    //
    //    }else if (offset >= Long(105)) {
    //        if (_tableView.contentSize.height <= _tableView.height) {
    //            return;
    //        }
    //        _tableView.frame = CGRectMake(0, offset-Long(105)-64, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - offset + Long(105));
    //
    //    }else {
    //        _tableView.frame = CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT - 49);
    //
    //    }
    
    [self setNavBarColorWithAlpha:alpha];
    
}

- (void)setNavBarColorWithAlpha:(CGFloat)alpha
{
//    HQLog(@"%f", alpha);
    
    //    [self.navigationController.navigationBar lt_setBackgroundColor:HexAColor(0xfafbfc, alpha)];
    
    //    UIView *lineView = [self.navigationController.navigationBar viewWithTag:0x1314];
    //    lineView.alpha = alpha;
    
    self.naviView.backgroundColor = HexAColor(0xffffff, alpha);
    self.lineView.backgroundColor = HexAColor(0xc8c8c8, alpha);
    CGFloat titleAlpha;
    if (alpha >= 0.95) {
        
        self.naviView.backgroundColor = HexAColor(0xffffff, 1);
        self.lineView.backgroundColor = HexAColor(0xc8c8c8, 1);
        
        titleAlpha = 0;
        
        [self.saoBtn setImage:[UIImage imageNamed:@"统计"] forState:UIControlStateNormal];
        [self.saoBtn setImage:[UIImage imageNamed:@"统计"] forState:UIControlStateHighlighted];
        [self.companyBtn setImage:[UIImage imageNamed:@"企业12"] forState:UIControlStateHighlighted];
        [self.companyBtn setImage:[UIImage imageNamed:@"企业12"] forState:UIControlStateNormal];
        self.dateView.lineB.hidden = NO;
    }else {
        
        titleAlpha = 1 - alpha;
        
        [self.saoBtn setImage:[UIImage imageNamed:@"透明统计"] forState:UIControlStateNormal];
        [self.saoBtn setImage:[UIImage imageNamed:@"透明统计"] forState:UIControlStateHighlighted];
        
        [self.companyBtn setImage:[UIImage imageNamed:@"企业"] forState:UIControlStateHighlighted];
        [self.companyBtn setImage:[UIImage imageNamed:@"企业"] forState:UIControlStateNormal];
        self.dateView.lineB.hidden = YES;
    }
    
    //    HQLog(@"____________%f_________",255*titleAlpha);
    UIColor *titleColor = RGBAColor(255*titleAlpha, 255*titleAlpha, 255*titleAlpha, 1);
    [self.outsideBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [self.outsideBtn setTitleColor:titleColor forState:UIControlStateHighlighted];
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:
    //                                                                          titleColor,
    //                                                                      NSFontAttributeName:FONT(19)}];
    
//    if (alpha >= 1.0 && !self.isScroll) {
//        self.tableView.scrollEnabled = NO;
//        self.isScroll = YES;
//        [[NSNotificationCenter defaultCenter] postNotificationName:WorkBenchMainTableViewScrollNotifition object:@0];
//    }
//    if (alpha < 1.0 && self.isScroll){
//        self.isScroll = NO;
//        self.tableView.scrollEnabled = YES;
//        [[NSNotificationCenter defaultCenter] postNotificationName:WorkBenchMainTableViewScrollNotifition object:@1];
//    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    UITableView *tableView = object;
    
//    HQLog(@"++++++++%f",tableView.contentOffset.y);
    
    if (tableView.contentOffset.y >= Long(105)) {
        
        if (!self.isScroll) {
            
            self.tableView.scrollEnabled = NO;
            self.isScroll = YES;
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:WorkBenchMainTableViewScrollNotifition object:@0];
        }
    }
    if (tableView.contentOffset.y < Long(105)){
        
        if (self.isScroll) {
            self.isScroll = NO;
            self.tableView.scrollEnabled = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:WorkBenchMainTableViewScrollNotifition object:@1];
        }
    }
    
}

#pragma mark - 网络请求代理
//-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
//    
//    if (resp.cmdId == HQCMD_getWorkbench) {
//        
//        self.benchModel = resp.body;
//        
//        if (self.index == 0) {
//            [self.sliderView refreshSliderViewWithFinishTask:[self.benchModel.overdueTask.finishTaskCount integerValue] totalTask:[self.benchModel.overdueTask.taskCount integerValue]];
//        }else if (self.index == 1){
//            [self.sliderView refreshSliderViewWithFinishTask:[self.benchModel.todayTask.finishTaskCount integerValue] totalTask:[self.benchModel.todayTask.taskCount integerValue]];
//        }else if (self.index == 2){
//            [self.sliderView refreshSliderViewWithFinishTask:[self.benchModel.tomorrowTask.finishTaskCount integerValue] totalTask:[self.benchModel.tomorrowTask.taskCount integerValue]];
//        }else{
//            [self.sliderView refreshSliderViewWithFinishTask:[self.benchModel.futureTask.finishTaskCount integerValue] totalTask:[self.benchModel.futureTask.taskCount integerValue]];
//        }
//        
//        [self.tableView reloadData];
//    }
//    
//    if (resp.cmdId == HQCMD_modTaskPosition) {
//        
//        HQLog(@"移动任务位置");
//        [self.projectBL requestGetWorkbench];
//    }
//    
//    if (resp.cmdId == HQCMD_modApprovalPosition) {
//        
//        HQLog(@"移动审批位置");
//        [self.projectBL requestGetWorkbench];
//    }
//    
//    if (resp.cmdId == HQCMD_modTaskStatus) {
//        
//        [self.tableView reloadData];
//    }
//    
//}
//
//-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
//    
////    [self.tableView.mj_footer endRefreshing];
////    [self.tableView.mj_header endRefreshing];
//    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
//}


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
