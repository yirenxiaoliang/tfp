//
//  TFWorkEnterController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFWorkEnterController.h"
#import "TFWorkEnterCell.h"
#import "TFModuleModel.h"
#import "TFBeanTypeModel.h"
#import "TFFourItemView.h"
#import "HQTFSelectCompanyController.h"
#import "TFEnterPeopleView.h"
#import "TFRefresh.h"
#import "TFWorkSheetView.h"
#import "TFProjectTaskDetailController.h"
#import "TFCreateNoteController.h"
#import "TFNewCustomDetailController.h"
#import "TFApprovalDetailController.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFProjectTaskBL.h"
#import "TFWorkBenchChangePeopleController.h"
#import "TFEnterManageController.h"
#import "TFMailBL.h"
#import "TFEmailUnreadModel.h"
#import "TFCustomBL.h"
#import "TFEmailsMainController.h"
#import "TFEmailsNewController.h"
#import "TFChartStatisticsController.h"
#import "TFApprovalMainController.h"
#import "TFModelEnterController.h"
#import "TFProjectAndTaskMainController.h"
#import "TFNoteMainController.h"
#import "TFCreateNoteController.h"
#import "TFFileMenuController.h"
#import "TFOneLevelFolderController.h"
#import "TFCustomListController.h"
#import "TFAddCustomController.h"
#import "TFCustomAuthModel.h"
#import "TFKnowledgeListController.h"
#import "TFDepartmentModel.h"
#import "TFAttendanceTabbarController.h"
#import "HuiJuHuaQi-Swift.h"
#import "TFPunchCardController.h"
#import "TFSelectStatusController.h"
#import "TFEnterTaskItemView.h"
#import "TFPunchSuccessTipView.h"
#import "TFPunchViewModel.h"
#import "TFPluginModel.h"
#import "TFRequest.h"
#import "TFCachePlistManager.h"

#define Empty 30

@interface TFWorkEnterController ()<UITableViewDelegate,UITableViewDataSource,TFWorkEnterCellDelegate,TFFourItemViewDelegate,TFEnterTaskItemViewDelegate,HQBLDelegate,TFWorkSheetViewDelegate,TFEnterPeopleViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

/** 数据 */
@property (nonatomic, strong) NSMutableArray *modules;


@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, weak)  UIView *bg;
@property (nonatomic, strong) NSMutableArray *peoples;
@property (nonatomic, strong) NSMutableArray *sheets;
/** handleTask */
@property (nonatomic, strong) TFProjectRowModel *handleTask;
/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) NSInteger overdueCount;
@property (nonatomic, assign) NSInteger todayCount;
@property (nonatomic, assign) NSInteger tomorrowCount;
@property (nonatomic, assign) NSInteger laterCount;

@property (nonatomic, weak)  TFEnterPeopleView *peopleView;
@property (nonatomic, assign) CGPoint point;

@property (nonatomic, strong) TFMailBL *mailBL;
@property (nonatomic, strong) TFCustomBL *customBL;
/** 选中的模块 */
@property (nonatomic, strong) TFModuleModel *selectModule;

@property (nonatomic, strong) TFPunchCardController *punchVc;

/** 打卡成功 */
@property (nonatomic, strong) TFPunchSuccessTipView *tipView;
/** 打卡viewModel */
@property (nonatomic, strong) TFPunchViewModel *punchViewModel;
/** 打开开关 1为能自动打卡 */
@property (nonatomic, copy) NSString *punchSwitch;
/** 工作台开关 1为能自动打卡 */
@property (nonatomic, copy) NSString *benchSwitch;

@property (nonatomic, strong) UIView *emptyView;

@end

@implementation TFWorkEnterController

-(UIView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,Empty}];
    }
    return _emptyView;
}

-(TFPunchViewModel *)punchViewModel{
    if (!_punchViewModel) {
        _punchViewModel = [[TFPunchViewModel alloc] init];
    }
    return _punchViewModel;
}

-(TFPunchSuccessTipView *)tipView{
    if (!_tipView) {
        _tipView = [TFPunchSuccessTipView punchSuccessTipView];
        _tipView.frame = CGRectMake(SCREEN_WIDTH+40, (SCREEN_HEIGHT)/2, Long(150), Long(72));
        [self.view addSubview:_tipView];
    }
    return _tipView;
}

-(TFMailBL *)mailBL{
    if (!_mailBL) {
        _mailBL = [TFMailBL build];
        _mailBL.delegate = self;
    }
    return _mailBL;
}
-(TFCustomBL *)customBL{
    if (!_customBL) {
        _customBL = [TFCustomBL build];
        _customBL.delegate = self;
    }
    return _customBL;
}

-(NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

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
- (NSMutableArray *)modules{
    if (!_modules) {
        _modules = [NSMutableArray array];
        TFModuleModel *model = [[TFModuleModel alloc] init];
        model.english_name = @"data";
        [_modules addObject:model];
    }
    return _modules;
}

-(UIView *)headerView{
    if (!_headerView) {
        
        _headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH, Long(116 + 110)}];
        _headerView.backgroundColor = ClearColor;
        
//        UIView *firstView = [[UIView alloc] initWithFrame:(CGRect){0,-NaviHeight,SCREEN_WIDTH,NaviHeight + Long(96)}];
//        [_headerView addSubview:firstView];
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:firstView.bounds];
//        imageView.image = IMG(@"enterImage");
//        [firstView addSubview:imageView];
//        firstView.backgroundColor = ClearColor;
//        imageView.contentMode = UIViewContentModeScaleToFill;
        
        TFEnterPeopleView *peopleView = [TFEnterPeopleView enterPeopleView];
        peopleView.delegate = self;
        peopleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, Long(116));
        [_headerView addSubview:peopleView];
        self.peopleView = peopleView;
        
        UIView *fourView = [[UIView alloc] initWithFrame:(CGRect){10,CGRectGetMaxY(peopleView.frame),SCREEN_WIDTH-20,Long(110)}];
        [_headerView addSubview:fourView];
        fourView.backgroundColor = WhiteColor;
        fourView.layer.cornerRadius = 6;
        fourView.layer.masksToBounds = YES;
        
        for (NSInteger i = 0 ; i < 4; i++) {
            TFEnterTaskItemView *view = [TFEnterTaskItemView enterTaskItemView];
            view.delegate = self;
            view.type = i;
            view.tag = i ;
            [fourView addSubview:view];
            view.frame = CGRectMake(i * fourView.frame.size.width/4, 0, fourView.frame.size.width/4, fourView.frame.size.height);
            [self.items addObject:view];
        }
    }
    
    return _headerView;
}

-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,180}];
        
        UIView *addBg = [[UIView alloc] init];
        addBg.frame = CGRectMake((SCREEN_WIDTH-50)/2, 30, 50, 50);
        addBg.backgroundColor = ClearColor;
        [_footerView addSubview:addBg];
        addBg.layer.cornerRadius = 25;
        addBg.layer.shadowOffset = CGSizeZero;
        addBg.layer.shadowColor = LightGrayTextColor.CGColor;
        addBg.layer.shadowRadius = 4;
        addBg.layer.shadowOpacity = 0.5;
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = addBg.bounds;
        [addBg addSubview:addBtn];
        addBtn.layer.cornerRadius = 25;
        addBtn.layer.masksToBounds = YES;
        [addBtn setImage:IMG(@"添加模块") forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *addLabel = [[UILabel alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(addBg.frame),SCREEN_WIDTH,30}];
        [_footerView addSubview:addLabel];
        addLabel.text = @"添加";
        addLabel.textColor = GrayTextColor;
        addLabel.font = FONT(12);
        addLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(addLabel.frame),SCREEN_WIDTH,40}];
        [_footerView addSubview:descLabel];
        descLabel.text = @"点击“添加”可将模块添加到工作台";
        descLabel.font = FONT(10);
        descLabel.textColor = GrayTextColor;
        descLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _footerView;
}
-(void)addClicked{
    TFEnterManageController *enter = [[TFEnterManageController alloc] init];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.modules];
    [arr removeObjectAtIndex:0];
    enter.shows = arr;
    enter.refreshAction = ^(NSMutableArray  *parameter) {
        
        [self.modules removeAllObjects];
        
        TFModuleModel *model = [[TFModuleModel alloc] init];
        model.english_name = @"data";
        [self.modules addObject:model];
        
        [self.modules addObjectsFromArray:parameter];
        [self.tableView reloadData];
    };
    
    [self.navigationController pushViewController:enter animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:HexColor(0x0062B1)] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [self titleItemWithTitle:UM.userLoginInfo.company.company_name color:WhiteColor imageName:@"whiteDown" withTarget:self action:@selector(changeCompany)];
    [self.peopleView refreshChangePeopleViewPeoples:self.peoples];

    if (self.tableView.contentOffset.y <= NaviHeight) {
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:HexColor(0x3689E9)] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTranslucent:YES];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:HexColor(0x3689E9)] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTranslucent:NO];
    }
    
    if (![UM.userLoginInfo.isLogin isEqualToString:@"1"]) {// teamface需登录
        return;
    }
    
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;

    // 判断切换公司后从新判断
    self.punchSwitch = nil;
    self.benchSwitch = nil;
   // 自动打卡
    [self autoPunchFunction];
    
}

-(void)getModuleSwitchInfo{
    
    [[TFRequest sharedManager] requestGET:URL(@"/moduleManagement/findModuleList") parameters:nil progress:nil success:^(NSDictionary *response) {
        NSArray *datas = response[kData];
        BOOL have = NO;
        for (NSDictionary *dict in datas) {
            if ([[dict valueForKey:@"bean"] isEqualToString:@"project"]) {
                if ([[dict valueForKey:@"onoff_status"] isEqualToString:@"1"]) {
                    self.tableView.tableHeaderView = self.headerView;
                    self.benchSwitch = @"1";
                    [self setupWorkSheetView];
                    [self requestTask];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:CurrentKey];
                    self.bg.height = NaviHeight + Long(116) + Long(110)/2;
                }else{
                    self.benchSwitch = @"0";
                    self.tableView.tableHeaderView = self.emptyView;
                    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CurrentKey];
                    self.bg.height = NaviHeight + 38 + Empty;
                    
                }
                have = YES;
            }
        }
        if (!have) {
            
            self.bg.height = NaviHeight + 38 + Empty;
            self.benchSwitch = @"0";
            self.tableView.tableHeaderView = self.emptyView;
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CurrentKey];
        }
    } failure:nil];
}

/** 自动打卡功能 */
-(void)autoPunchFunction{
    
    if (self.punchSwitch == nil) {// 请求模块
        [[TFRequest sharedManager] requestGET:URL(@"/moduleManagement/findModuleList") parameters:nil progress:nil success:^(NSDictionary *response) {
            NSArray *datas = response[kData];
            
            BOOL have = NO;
            for (NSDictionary *dict in datas) {
                if ([[dict valueForKey:@"bean"] isEqualToString:@"attendance"] && [[dict valueForKey:@"onoff_status"] isEqualToString:@"1"]) {
                    self.punchSwitch = @"0";
                    [self autoPunchFunction];
                    HQLog(@"==========有考勤模块=========");
                }
                if ([[dict valueForKey:@"bean"] isEqualToString:@"project"]) {
                    if ([[dict valueForKey:@"onoff_status"] isEqualToString:@"1"]) {
                        self.tableView.tableHeaderView = self.headerView;
                        self.benchSwitch = @"1";
                        [self setupWorkSheetView];
                        [self requestTask];
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:CurrentKey];
                        self.bg.height = NaviHeight + Long(116) + Long(110)/2;
                    }else{
                        self.benchSwitch = @"0";
                        self.tableView.tableHeaderView = self.emptyView;
                        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CurrentKey];
                        
                        self.bg.height = NaviHeight + 38 + Empty;
                    }
                    
                    have = YES;
                }
            }
            if (!have) {
                self.benchSwitch = @"0";
                self.tableView.tableHeaderView = self.emptyView;
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CurrentKey];
                
                self.bg.height = NaviHeight + 38 + Empty;
            }
        } failure:nil];
    }else if ([self.punchSwitch isEqualToString:@"0"]) {// 是否能打卡
        [[self.punchViewModel.quickCommand execute:[NSDictionary dictionary]] subscribeNext:^(NSArray *x) {
            for (TFPluginModel *model in x) {
                if ([[model.plugin_type description] isEqualToString:@"1"] && [[model.plugin_status description] isEqualToString:@"1"]) {
                    self.punchSwitch = @"1";
                    [self autoPunchFunction];
                    HQLog(@"==========开启了自动打卡=========");
                }
            }
        }];
    }else if ([self.punchSwitch isEqualToString:@"1"]){// 自动打卡
        // 初始化
        [self setupChild];
        // 出现获取打卡信息
        [self.punchVc getData];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 消失停止定位
    
    [self.punchVc stopLocation];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    self.navigationItem.title = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(active) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 登录或切换公司socket连接通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCompanySocketConnect) name:ChangeCompanySocketConnect object:nil];
    [self setupTableView];
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

}

/** 用于快速打卡 */
-(void)setupChild{
    if (self.punchVc) {
        return;
    }
    self.punchVc = [[TFPunchCardController alloc] init];
    self.punchVc.isAuto = YES;
    [self addChildViewController:self.punchVc];
    [self.punchVc startLocation];
    [self.view addSubview:self.tipView];
    kWEAKSELF
    self.punchVc.autoAction = ^{
        
        weakSelf.tipView.timeLabel.text = [HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"HH:mm"];
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.tipView.x = SCREEN_WIDTH - Long(140);
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.tipView.x = SCREEN_WIDTH+40;
                }];
            });
        }];
    };
}

-(void)changeCompanySocketConnect{
    
    [self.peoples removeAllObjects];
    [self.peopleView refreshChangePeopleViewPeoples:self.peoples];
    
    
    // 判断切换公司后从新判断
    self.punchSwitch = nil;
    self.benchSwitch = nil;
    
    [self refrehData];
    
    [self autoPunchFunction];
    
    // 是不是有协作
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:CurrentKey];
    if (str && [str isEqualToString:@"1"]) {
        self.tableView.tableHeaderView = self.headerView;
        self.bg.height = NaviHeight + Long(116) + Long(110)/2;
        
    }else{
        self.tableView.tableHeaderView = self.emptyView;
        self.bg.height = NaviHeight + 38 + Empty;
    }
}

/** 拿出缓存数据 */
- (void)handleDataWithDatas:(NSArray *)datas{
    
    if (datas == nil || datas.count == 0) {
        return;
    }
    
    self.modules = nil;
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dict in datas) {
        TFModuleModel *model = [[TFModuleModel alloc] initWithDictionary:dict error:nil];
        if (model) {
            [arr addObject:model];
        }
    }
    [self.modules addObjectsFromArray:arr];
    
    [self.tableView reloadData];
}

-(void)refrehData{
    
    [self.customBL requestWorkEnterShowModule];
    [self handleDataWithDatas:[TFCachePlistManager getBenchModuleList]];
    
    [self requestTask];
    
    self.navigationItem.leftBarButtonItem = [self titleItemWithTitle:UM.userLoginInfo.company.company_name color:WhiteColor imageName:@"whiteDown" withTarget:self action:@selector(changeCompany)];
    
    [self getModuleSwitchInfo];
}

-(void)requestTask{
    
    if ([self.benchSwitch isEqualToString:@"1"]) {
        
        [self.projectTaskBL requestWorkBenchChangePeopleAuth];
        
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
    [self.peopleView refreshChangePeopleViewPeoples:self.peoples];
}

-(void)active{
    
//    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
    
    if (![UM.userLoginInfo.isLogin isEqualToString:@"1"]) {// teamface需登录
        return;
    }
    
    [self.customBL requestWorkEnterShowModule];
    [self handleDataWithDatas:[TFCachePlistManager getBenchModuleList]];
    
    
    self.navigationItem.leftBarButtonItem = [self titleItemWithTitle:UM.userLoginInfo.company.company_name color:WhiteColor imageName:@"whiteDown" withTarget:self action:@selector(changeCompany)];
    
    
    // 快速打卡
    [self autoPunchFunction];
    
    // 是不是有协作
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:CurrentKey];
    if (str && [str isEqualToString:@"1"]) {
        self.tableView.tableHeaderView = self.headerView;
        [self requestTask];
        self.bg.height = NaviHeight + Long(116) + Long(110)/2;
        
    }else{
        self.tableView.tableHeaderView = self.emptyView;
        self.bg.height = NaviHeight + 38 + Empty;
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_workEnterShow) {
        [self.tableView.mj_header endRefreshing];
        [self.modules removeAllObjects];
        
        TFModuleModel *model = [[TFModuleModel alloc] init];
        model.english_name = @"data";
        [self.modules addObject:model];
        
        [self.modules addObjectsFromArray:resp.body];
        [self.tableView reloadData];
        
        // 将模块数据缓存起来，启动进入时出现闪动，体验不好
        [TFCachePlistManager saveBenchModuleListWithDatas:resp.data];
    
        
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
        self.peopleView.auth = [str description];
        //        self.changePeopleView.auth = @"1";
    }
    
    if (resp.cmdId == HQCMD_mailOperationQueryUnreadNumsByBox) {
        
        NSMutableArray *arr = [NSMutableArray array];
        for (TFEmailUnreadModel *model in resp.body) {
            if ([[model.mail_box_id description] isEqualToString:@"1"]) {
                [arr addObject:@([model.count integerValue])];
            }
        }
        if (arr.count == 0) {
            [arr addObject:@0];
        }
        self.selectModule.emailUnreads = arr;
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_customApprovalCount) {
        
        NSMutableArray *arr = [NSMutableArray array];
        if ([resp.body valueForKey:@"treatCount"]) {
            [arr addObject:[resp.body valueForKey:@"treatCount"]];
        }else{
            [arr addObject:@0];
        }
        if ([resp.body valueForKey:@"copyCount"]) {
            [arr addObject:[resp.body valueForKey:@"copyCount"]];
        }else{
            [arr addObject:@0];
        }
        self.selectModule.approvalUnreads = arr;
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_customModuleAuth) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL have = NO;
        for (TFCustomAuthModel *model in resp.body) {
            if ([model.auth_code isEqualToNumber:@1]) {
                have = YES;
                break;
            }
        }
        if (have) {
            TFAddCustomController *add = [[TFAddCustomController alloc] init];
            add.type = 0;
            add.tableViewHeight = SCREEN_HEIGHT - 64;
            add.bean = self.selectModule.english_name;
            add.moduleId = self.selectModule.id;
            [self.navigationController pushViewController:add animated:YES];
        }
    }
    
    if (resp.cmdId == HQCMD_customChildMenuList) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.selectModule.submenus = resp.body;
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

- (void)changeCompany{
    
    HQTFSelectCompanyController *select = [[HQTFSelectCompanyController alloc] init];
    [self.navigationController pushViewController:select animated:YES];
}

#pragma mark - TFEnterPeopleViewDelegate
-(void)changePeopleViewDidClickedPeople{
    
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
        [self.peopleView refreshChangePeopleViewPeoples:self.peoples];
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
        workSheet.y = NaviHeight;
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

#pragma mark - TFEnterTaskItemViewDelegate
-(void)enterTaskItemViewClickedWithIndex:(NSInteger)index{
    
    NSInteger tag = index;
    
    TFWorkSheetView *workSheet = self.sheets[tag];
    if (workSheet.taskCount == 0) {
        [MBProgressHUD showError:@"暂无数据" toView:self.view];
        return;
    }
    
    workSheet.layer.masksToBounds = YES;
    workSheet.selected = YES;
    workSheet.height = 0;
    workSheet.y = NaviHeight + 90;
    [UIView animateWithDuration:.5 animations:^{
        workSheet.height = SCREEN_HEIGHT-NaviHeight-TabBarHeight-BottomM+8;
        workSheet.y = NaviHeight;
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
            workSheet.y = NaviHeight;
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
    if (workSheet.y <= NaviHeight) {
        workSheet.y = NaviHeight;
    }
}
-(void)workSheetView:(TFWorkSheetView *)workSheet panEndWithPoint:(CGPoint)point{
    CGPoint changePoint = [self.view convertPoint:point fromView:workSheet];
    
    if (changePoint.y < (SCREEN_HEIGHT-NaviHeight-TabBarHeight-BottomM)/2) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            workSheet.y = NaviHeight;
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
    
//    if ([model.from isEqualToNumber:@1]) {// 个人任务
//
//        if (model.task_id) {// 子任务
//
//            [self.projectTaskBL requestGetPersonnelTaskRoleWithTaskId:model.id typeStatus:@1];
//
//        }else{// 主任务
//
//            [self.projectTaskBL requestGetPersonnelTaskRoleWithTaskId:model.id typeStatus:@0];
//        }
//    }else{// 项目任务
//
//        if (model.task_id) {// 子任务
//
//            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:model.projectId taskId:model.taskInfoId taskType:@2];
//
//        }else{// 主任务
//
//            [self.projectTaskBL requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:model.projectId taskId:model.taskInfoId taskType:@1];
//
//        }
//    }
    TFSelectStatusController *select = [[TFSelectStatusController alloc] init];
    select.type = 2;
    select.task = model;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:select];
    select.refresh = ^{
        [workSheet refreshData];
    };
    [self presentViewController:navi animated:YES completion:nil];
    
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
        note.noteId = model.id;
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
    
    if (workSheet.tag >= self.items.count) {
        return;
    }
    
    TFEnterTaskItemView *itemView = self.items[workSheet.tag];
    itemView.taskNum = taskCount;
    if (workSheet.tag == 0) {
        self.overdueCount = taskCount;
    }else if (workSheet.tag == 1){
        self.todayCount = taskCount;
    }else if (workSheet.tag == 2){
        self.tomorrowCount = taskCount;
    }else if (workSheet.tag == 3){
        self.laterCount = taskCount;
    }
    self.peopleView.taskCount = self.overdueCount + self.todayCount + self.tomorrowCount + self.laterCount;
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-BottomHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(NaviHeight, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
//    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    MJRefreshNormalHeader *head = [TFRefresh headerNormalRefreshWithBlock:^{
        [self refrehData];
    }];
    head.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    head.stateLabel.textColor = WhiteColor;
    tableView.mj_header = head;
    
    tableView.backgroundView = [UIView new];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,NaviHeight + Long(116) + Long(110)/2}];
//    bg.image = IMG(@"enterImage");
    bg.backgroundColor = HexColor(0x3689E9);
    bg.contentMode = UIViewContentModeScaleToFill;
    [tableView.backgroundView addSubview:bg];
    self.bg = bg;
    self.tableView.mj_header.alpha = 0;
}
#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modules.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TFWorkEnterCell *cell = [TFWorkEnterCell workEnterCellWithTableView:tableView];
    [cell refreshWorkEnterCellWithModule:self.modules[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [TFWorkEnterCell workEnterCellHeightWithModule:self.modules[indexPath.row]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint point = scrollView.contentOffset;
    if ([self.benchSwitch isEqualToString:@"1"]) {
        self.bg.height = (Long(116) + Long(110)/2) - point.y <= 0 ? 0 : (Long(116) + Long(110)/2) - point.y;
    }else{
        self.bg.height = 38 + Empty - point.y <= 0 ? 0 : 38 + Empty - point.y;
    }
    self.point = point;
    HQLog(@"%lf",(-point.y-NaviHeight)*1.0/NaviHeight*1.0);
    self.tableView.mj_header.alpha = (-point.y-NaviHeight)*1.0/NaviHeight*1.0;
    
//    if (point.y <= NaviHeight) {
//        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:ClearColor] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setTranslucent:YES];
//    }else{
//        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:HexColor(0x3689E9)] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setTranslucent:NO];
//    }
    
    [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:HexColor(0x3689E9)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:NO];
}

#pragma mark - TFWorkEnterCellDelegate
-(void)workEnterCellDidClickedAddWithModule:(TFModuleModel *)module{
    
    if ([module.english_name isEqualToString:@"email"]) {
        TFEmailsNewController *add = [[TFEmailsNewController alloc] init];
        [self.navigationController pushViewController:add animated:YES];
    }else if ([module.english_name isEqualToString:@"approval"]){
        TFModelEnterController *model = [[TFModelEnterController alloc] init];
        model.type = 2;
        [self.navigationController pushViewController:model animated:YES];
    }else if ([module.english_name isEqualToString:@"memo"]){
        TFCreateNoteController *note = [[TFCreateNoteController alloc] init];
        [self.navigationController pushViewController:note animated:YES];
    }else if ([module.english_name containsString:@"bean"]){
        // 调权限接口
        self.selectModule = module;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestCustomModuleAuthWithBean:module.english_name];
    }
}
-(void)workEnterCellDidClickedItemWithModule:(TFModuleModel *)module index:(NSInteger)index{
    
    if ([module.english_name isEqualToString:@"email"]) {
        TFEmailsMainController *email = [[TFEmailsMainController alloc] init];
        email.outBoxId = @(index + 1);
        [self.navigationController pushViewController:email animated:YES];
        
    }else if ([module.english_name isEqualToString:@"approval"]){
        TFApprovalMainController *approval = [[TFApprovalMainController alloc] init];
        if (index == 0) {
            approval.selectIndex = @1;
        }else if (index == 1) {
            approval.selectIndex = @3;
        }else if (index == 2) {
            approval.selectIndex = @0;
        }
        [self.navigationController pushViewController:approval animated:YES];
    }else if ([module.english_name isEqualToString:@"library"]){
        TFOneLevelFolderController *oneLevel = [[TFOneLevelFolderController alloc] init];
        NSString *name = @"";
        NSInteger style = 0;
        if (index == 0) {
            name = @"公司文件";
            style = 0;
        }else if (index == 1){
            name = @"应用文件";
            style = 1;
        }else if (index == 2){
            name = @"项目文件";
            style = 5;
        }else if (index == 3){
            name = @"个人文件";
            style = 2;
        }else if (index == 4){
            name = @"我共享的";
            style = 3;
        }else if (index == 5){
            name = @"与我共享";
            style = 4;
        }
        oneLevel.naviTitle = name;
        oneLevel.pathArr = [NSMutableArray array];
        [oneLevel.pathArr addObject:name];
        oneLevel.style = style;
        [self.navigationController pushViewController:oneLevel animated:YES];
    }
}
-(void)workEnterCellDidClickedSubmenuWithModule:(TFModuleModel *)module beanType:(TFBeanTypeModel *)beanType index:(NSInteger)index{
    
 if ([module.english_name containsString:@"bean"]){
     TFCustomListController *custom = [[TFCustomListController alloc] init];
     custom.module = module;
     beanType.select = @1;
     [self.navigationController pushViewController:custom animated:YES];
    }
}
-(void)workEnterCellEnterMainWithModule:(TFModuleModel *)module{
    
    if ([module.english_name isEqualToString:@"email"]) {
        TFEmailsMainController *email = [[TFEmailsMainController alloc] init];
        [self.navigationController pushViewController:email animated:YES];
    }else if ([module.english_name isEqualToString:@"repository_libraries"]){
        TFKnowledgeListController *knowledge = [[TFKnowledgeListController alloc] init];
        [self.navigationController pushViewController:knowledge animated:YES];
    }else if ([module.english_name isEqualToString:@"approval"]){
        TFApprovalMainController *approval = [[TFApprovalMainController alloc] init];
        [self.navigationController pushViewController:approval animated:YES];
    }else if ([module.english_name isEqualToString:@"project"]){
        TFProjectAndTaskMainController *project =[[TFProjectAndTaskMainController alloc] init];
        [self.navigationController pushViewController:project animated:YES];
    }else if ([module.english_name isEqualToString:@"memo"]){
        TFNoteMainController *note = [[TFNoteMainController alloc] init];
        [self.navigationController pushViewController:note animated:YES];
    }else if ([module.english_name isEqualToString:@"library"]){
        TFFileMenuController *menu = [[TFFileMenuController alloc] init];
        [self.navigationController pushViewController:menu animated:YES];
    }else if ([module.english_name isEqualToString:@"data"]){
        TFChartStatisticsController *chart = [[TFChartStatisticsController alloc] init];
        [self.navigationController pushViewController:chart animated:YES];
    }else if ([module.english_name isEqualToString:@"attendance"]){
        TFAttendanceTabbarController *attendanceTabbar = [[TFAttendanceTabbarController alloc] init];
        [self.navigationController pushViewController:attendanceTabbar animated:YES];
    }else if ([module.english_name containsString:@"bean"]){
        TFCustomListController *custom = [[TFCustomListController alloc] init];
        for (TFBeanTypeModel *type in module.submenus) {
            type.select = nil;
        }
        TFBeanTypeModel *mo = module.submenus.firstObject;
        mo.select = @1;
        custom.module = module;
        [self.navigationController pushViewController:custom animated:YES];
    }
    
}

-(void)workEnterCellDidClickedShow:(BOOL)show module:(TFModuleModel *)module{
//    [self.tableView beginUpdates];
//    [self.tableView endUpdates];
    [self.tableView setContentOffset:self.point animated:NO];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.selectModule = module;
    if (show) {
        [self requestModuleDataWithModule:module];
    }
}
/** 请求数据 */
-(void)requestModuleDataWithModule:(TFModuleModel *)module{
    
    if ([module.english_name isEqualToString:@"email"]) {
        [self.mailBL getMailOperationQueryUnreadNumsByBoxData];
    }else if ([module.english_name isEqualToString:@"approval"]){
        [self.customBL requestApprovalCount];// 数量
    }else if ([module.english_name containsString:@"bean"]){
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (!self.selectModule.submenus) {
            [self.customBL requsetCustomChildMenuListWithModuleId:self.selectModule.id];// 子菜单
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
