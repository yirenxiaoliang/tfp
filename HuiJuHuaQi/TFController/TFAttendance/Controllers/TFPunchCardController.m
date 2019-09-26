//
//  TFPunchCardController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPunchCardController.h"
#import "TFPunchCardCell.h"
#import "TFPCBottomView.h"
#import "TFPCFinishedView.h"
#import "TFPCTipView.h"
#import "AlertView.h"
#import "TFPunchViewModel.h"
#import "TFAttendanceBL.h"
#import "TFMapController.h"
#import "HQTFNoContentView.h"
#import "TFPutchRecordModel.h"
#import "TFPCMapController.h"
#import "TFPunchCardHeader.h"
#import "TFAddCustomController.h"
#import "TFApprovalDetailController.h"
#import "TFCustomBL.h"
#import <CoreLocation/CoreLocation.h>
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
#import "TFOutMarkController.h"
#import "TFPunchRelationCell.h"
#import "TFCustomAuthModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import "TFMyPunchRuleController.h"
#define PunchCardTime @"PunchCardTime"

@interface TFPunchCardController ()<UITableViewDelegate,UITableViewDataSource,TFPCBottomViewDelegate,TFPCTipViewDelegate,HQBLDelegate,TFPunchCardCellDelegate,CLLocationManagerDelegate,TFPunchCardHeaderDelegate>

@property (nonatomic, weak) UITableView *tableView;
/** 打卡按钮 */
@property (nonatomic, strong) TFPCBottomView *bottomView;
/** 今日打卡完成 */
@property (nonatomic, strong) TFPCFinishedView *finishedView;
/** 打卡成功提示 */
@property (nonatomic, strong) TFPCTipView *tipView;

@property (nonatomic, strong) TFPunchViewModel *punchViewModel;

@property (nonatomic, strong) TFAttendanceBL *attendanceBL;
@property (nonatomic, strong) TFCustomBL *customBL;

@property (nonatomic, assign) long long punchDate;

@property (nonatomic, assign) BOOL noTip;
/** 提示记录 */
@property (nonatomic, strong) TFPutchRecordModel *tipRecord;

@property (nonatomic, strong) NSTimer *timer;

/** 打卡头部 */
@property (nonatomic, strong) TFPunchCardHeader *punchHeader;

/** 定位 */
@property (nonatomic, strong) CLLocationManager *locationManager;
/** 地理编码 */
@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, copy) ActionHandler action;
/** 用于自动打卡间隙 */
@property (nonatomic, assign) long long timeSp;

@end

@implementation TFPunchCardController

-(TFPunchViewModel *)punchViewModel{
    if (!_punchViewModel) {
        _punchViewModel = [[TFPunchViewModel alloc] init];
    }
    return _punchViewModel;
}
-(TFPunchCardHeader *)punchHeader{
    if (!_punchHeader) {
        _punchHeader = [TFPunchCardHeader punchCardHeader];
        _punchHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        _punchHeader.layer.shadowColor = CellSeparatorColor.CGColor;
        _punchHeader.layer.shadowOffset = CGSizeMake(0, 4);
        _punchHeader.layer.shadowRadius = 2;
        _punchHeader.layer.shadowOpacity = 0.5;
        _punchHeader.delegate = self;
    }
    return _punchHeader;
}

#pragma mark - TFPunchCardHeaderDelegate
-(void)punchCardHeaderClickedPosition{
    TFMyPunchRuleController *myRule = [[TFMyPunchRuleController alloc] init];
    myRule.punchViewModel = self.punchViewModel;
    [self.navigationController pushViewController:myRule animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 获取数据
    [self getData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!self.isAuto) {
        [self stopLocation];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.attendanceBL = [TFAttendanceBL build];
    self.attendanceBL.delegate = self;
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    // 获取数据
    self.punchDate = [HQHelper changeTimeToTimeSp:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"] formatStr:@"yyyy-MM-dd"];
//    [[self.punchViewModel.dataCommand execute:@(self.punchDate)] subscribeNext:^(id  _Nullable x) {
//        [self refreshData];
//    }];
    
    self.navigationItem.title = @"打卡";
    [self setupTableView];
    [self.view addSubview:self.punchHeader];
    
    [self createBottomView];
    
    [self createTipView];
    [self currentLocation];
    
    // 接到改变打卡时间的通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"PutchDardChangeTime" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
       self.punchDate = [HQHelper changeTimeToTimeSp: [HQHelper nsdateToTime:[x.object longLongValue] formatStr:@"yyyy-MM-dd"] formatStr:@"yyyy-MM-dd"];
        // 获取数据
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        RACSignal *signal = [self.punchViewModel.dataCommand execute:@(self.punchDate)];
        [signal subscribeNext:^(id  _Nullable x) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self refreshData];
        }];
        [signal subscribeError:^(NSError * _Nullable error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:[error.userInfo valueForKey:@"NSDebugDescription"] toView:self.view];
        }];
    }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.isAuto) {
        // 获取数据
        [self getData];
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:ClearColor] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTranslucent:YES];
        self.shadowLine.hidden = YES;
    }
    
}

/** 获取数据 */
-(void)getData{
    
    self.punchViewModel.cardModel = nil;
    [self.locationManager startUpdatingLocation];  //开始定位
    
    if (self.punchDate == 0) {
        self.punchDate = [HQHelper changeTimeToTimeSp:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"] formatStr:@"yyyy-MM-dd"];
    }
    RACSignal *signal = [self.punchViewModel.dataCommand execute:@(self.punchDate)];
    [signal subscribeNext:^(id  _Nullable x) {
        [self refreshData];
        self.isData = YES;
        if (self.isAuto) {// 数据回来了就打卡
            [self punchCardClicked];
        }
    }];
    [signal subscribeError:^(NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"NSDebugDescription"] toView:self.view];
    }];
}
/** 开启定位 */
-(void)startLocation{
    [self.locationManager startUpdatingLocation];  //开始定位
}

/** 停止定位 */
-(void)stopLocation{
    [self.locationManager stopUpdatingLocation];  //停止定位
    self.punchViewModel.location = nil;
}


-(void)timerMethod{
    
    HQLog(@"我来了");
    if (self.punchViewModel.location == nil) {
        [self currentLocation];
    }
    // 获取数据
    [[self.punchViewModel.dataCommand execute:@(self.punchDate)] subscribeNext:^(id  _Nullable x) {
        [self refreshData];
    }];
    
}

-(void)dealloc{
//    [self.timer invalidate];
//    self.timer = nil;
}

-(void)refreshData{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (!self.punchViewModel.cardModel.id || !self.punchViewModel.cardModel.class_info.id){// 无考勤规则
        
         // 无班次
         if (self.punchViewModel.cardModel.record_list.count) {
             self.tableView.backgroundView = nil;
         }else{
             if (!self.punchViewModel.cardModel.id) {
                 HQTFNoContentView *view = [HQTFNoContentView noContentView];
                 [view setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2 -167 ,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"没有打卡规则，请联系管理员设置"];
                 self.tableView.backgroundView = view;
             }else{
                 HQTFNoContentView *view = [HQTFNoContentView noContentView];
                 [view setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2 -167 ,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"没有考勤班次，请联系管理员设置"];
                 self.tableView.backgroundView = view;
             }
         }
         
         // 休息
         NSString *now = [HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"];
         NSString *start = [HQHelper nsdateToTime:self.punchDate formatStr:@"yyyy-MM-dd"];
         if ([now isEqualToString:start]) {// 今天
             self.finishedView.hidden = YES;
             self.bottomView.hidden = NO;
         }else{
             self.finishedView.hidden = YES;
             self.bottomView.hidden = YES;
         }
         
         [self.bottomView refreshPCTimeWithModel:self.punchViewModel.currentRecord];
         
//         [self.timer invalidate];
//         self.timer = nil;
    }
     else if ([self.punchViewModel.cardModel.class_info.id isEqualToNumber:@0]) {// 有考勤规则，休息班次
         
         // 休息
         NSString *now = [HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"];
         NSString *start = [HQHelper nsdateToTime:self.punchDate formatStr:@"yyyy-MM-dd"];
         
         if (self.punchViewModel.cardModel.record_list.count) {
             self.tableView.backgroundView = nil;
         }else{
             HQTFNoContentView *view = [HQTFNoContentView noContentView];
             [view setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2 -167,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"今天不上班，好好休息"];
             self.tableView.backgroundView = view;
         }
         if ([now isEqualToString:start]) {// 今天
             
             self.finishedView.hidden = YES;
             self.bottomView.hidden = NO;
             
         }else{
             self.finishedView.hidden = YES;
             self.bottomView.hidden = YES;
         }
         
         [self.bottomView refreshPCTimeWithModel:self.punchViewModel.currentRecord];
         
//         [self.timer invalidate];
//         self.timer = nil;
         
     }
    else{// 今日有考勤组的
        
        if (self.punchViewModel.currentRecord) {// 还有未完成的卡
            self.finishedView.hidden = YES;
            self.bottomView.hidden = NO;
            
            // 此处开启定时器刷打卡记录
//            if (self.timer == nil) {
//                self.timer = [NSTimer timerWithTimeInterval:10.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
//                [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//            }
            
            
        }else{// 今日全部完成了打卡
            
            if ([[HQHelper nsdateToTime:self.punchDate formatStr:@"yyyy-MM-dd"] isEqualToString:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"]]) {// 今天
                self.finishedView.hidden = NO;
                [self.finishedView refreshFinishStatus:self.punchViewModel.tatol_status];
            }else{
                self.finishedView.hidden = YES;
            }
            self.bottomView.hidden = YES;
            
//            [self.timer invalidate];
//            self.timer = nil;
        }
        
        self.tableView.backgroundView = nil;
        [self.bottomView refreshPCTimeWithModel:self.punchViewModel.currentRecord];
        
        long long now = [HQHelper changeTimeToTimeSp:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"] formatStr:@"yyyy-MM-dd"];
        if (self.punchDate - now > 0) {// 大于今天，不让打卡
            self.bottomView.hidden = YES;
        }
        
    }
    if (self.punchViewModel.cardModel && !IsStrEmpty(self.punchViewModel.cardModel.name)) {
        self.punchHeader.positionLabel.text = [NSString stringWithFormat:@"%@（查看规则）",TEXT(self.punchViewModel.cardModel.name)];
        self.punchHeader.positionLabel.hidden = NO;
    }else{
        self.punchHeader.positionLabel.hidden = YES;
    }
    
    [self.tableView reloadData];
}

/** 获取定位信息 */
-(void)currentLocation{
    
    [LBXPermission authorizeWithType:LBXPermissionType_Location completion:^(BOOL granted, BOOL firstTime) {
        
        if (granted)
        {
            
        }
        else if (!firstTime)
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有定位权限，是否前往设置" cancel:@"取消" setting:@"设置"];
        }
        
    }];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    /*
     定位精确度
     kCLLocationAccuracyBestForNavigation    最适合导航
     kCLLocationAccuracyBest    精度最好的
     kCLLocationAccuracyNearestTenMeters    附近10米
     kCLLocationAccuracyHundredMeters    附近100米
     kCLLocationAccuracyKilometer    附近1000米
     kCLLocationAccuracyThreeKilometers    附近3000米
     */
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    /*
     每隔多少米更新一次位置，即定位更新频率
     */
    self.locationManager.distanceFilter = kCLDistanceFilterNone; //系统默认值
//    self.locationManager.distanceFilter = 50.0; //系统默认值
   
    [self.locationManager requestWhenInUseAuthorization]; //使用期间定位
    [self.locationManager startUpdatingLocation];  //开始定位
    self.geocoder = [[CLGeocoder alloc] init];
    // 监听定位代理
    [[self rac_signalForSelector:@selector(locationManager:didUpdateLocations:) fromProtocol:@protocol(CLLocationManagerDelegate)] subscribeNext:^(RACTuple * _Nullable x) {

        HQLog(@"RACTuple==%@",x);
        NSArray *arr = x.second;
        [self.geocoder reverseGeocodeLocation:arr.firstObject completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error){

            if (placemarks == nil) {
                return ;
            }
            HQLog(@"placemarks==%@",placemarks);
            CLPlacemark *mark = placemarks.firstObject;
            NSString *str = [[mark.addressDictionary valueForKey:@"FormattedAddressLines"] firstObject];
            HQLog(@"address==%@",str);
            TFLocationModel *parameter = [[TFLocationModel alloc] init];
            parameter.totalAddress = str;
            parameter.latitude = mark.location.coordinate.latitude;
            parameter.longitude = mark.location.coordinate.longitude;
            
            self.punchViewModel.location = parameter;
            
            [self.punchViewModel.refreshSignal subscribeNext:^(id  _Nullable x) {
                [self.tableView reloadData];
                [self.bottomView refreshPCTimeWithModel:self.punchViewModel.currentRecord];
                if (self.isAuto) {// 获取到地址信息就尝试打卡
                    [self punchCardClicked];
                }
            }];
            
         }];
    }];

//    return;
//
//    TFMapController *locationVc = [[TFMapController alloc] initWithType:LocationTypeHideLocation];
//    locationVc.type = LocationTypeHideLocation;
//    locationVc.locationAction = ^(TFLocationModel *parameter){
//
//        self.punchViewModel.location = parameter;
//
//        [self.punchViewModel.refreshSignal subscribeNext:^(id  _Nullable x) {
//            [self.tableView reloadData];
//            [self.bottomView refreshPCTimeWithModel:self.punchViewModel.currentRecord];
//        }];
//
//    };
//    [self addChildViewController:locationVc];
}

- (void)createTipView {
    
    self.tipView = [[TFPCTipView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    self.tipView.hidden = YES;
    self.tipView.delegate = self;
    if (self.isAuto == NO) {
        [KeyWindow addSubview:self.tipView];
    }
}

- (void)createBottomView {
    
    self.bottomView = [[TFPCBottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-NaviHeight-203-BottomHeight, SCREEN_WIDTH, 203)];
    
    self.bottomView.delegate = self;
    [self.view insertSubview:self.bottomView aboveSubview:self.tableView];
    self.bottomView.hidden = YES;
    
    self.finishedView = [[TFPCFinishedView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-NaviHeight-120-BottomHeight, SCREEN_WIDTH, 120)];
    
    [self.view insertSubview:self.finishedView aboveSubview:self.tableView];
    self.finishedView.hidden = YES;
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-60) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 203+BottomHeight, 0);
    tableView.backgroundColor = WhiteColor;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.punchViewModel.cardModel.relation_module.count;
    }
    return self.punchViewModel.cardModel.record_list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        TFRelationModuleModel *module = self.punchViewModel.cardModel.relation_module[indexPath.row];

        TFPunchRelationCell *cell = [TFPunchRelationCell punchRelationCellWithTableView:tableView];
        [cell refreshPunchRelationCellWithModel:module];
        return cell;
        
    }else{
        
        TFPunchCardCell *cell = [TFPunchCardCell PunchCardCellWithTableView:tableView];
        
        TFPutchRecordModel *record = self.punchViewModel.cardModel.record_list[indexPath.row];
        [cell configPunchCardCellWithModel:record];
        cell.delegate = self;
        cell.bottomLine.hidden = YES;
        cell.topLine.hidden = YES;
        if (self.punchViewModel.cardModel.record_list.count-1 == indexPath.row) {
            cell.line.hidden = YES;
        }else{
            cell.line.hidden = NO;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        
        TFRelationModuleModel *model = self.punchViewModel.cardModel.relation_module[indexPath.row];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestQueryApprovalDataWithDataId:model.data_id type:nil bean:model.bean_name processInstanceId:nil taskKey:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }
    return 143;
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

/** 更新打卡 */
-(void)punchCardCellDidChange:(TFPutchRecordModel *)model{
    self.noTip = YES;
    self.punchViewModel.currentRecord = model;
    BOOL locationTure = [self.punchViewModel judgeLocationIsTure];
    if (locationTure) {
        [self requestPunchCark];
    }else{
        [MBProgressHUD showError:@"不在考勤范围" toView:self.view];
    }
}
/** 申请补卡 */
-(void)addCardCellDidChange:(TFPutchRecordModel *)model{
    
    if([model.punchcard_status isEqualToString:@"5"]){// 缺卡，申请缺卡
        
        // 判断新建权限
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestCustomModuleAuthWithBean:model.bean_name];// 权限
        kWEAKSELF
        self.action = ^{
            TFAddCustomController *add = [[TFAddCustomController alloc] init];
            add.type = 0;
            add.tableViewHeight = SCREEN_HEIGHT - 64;
            add.bean = model.bean_name;
            [weakSelf.navigationController pushViewController:add animated:YES];
        };
    }
//    if([model.punchcard_status isEqualToString:@"1"]){// 正常，查看审批详情
    else{// 正常，查看审批详情
        
        
        if (!IsStrEmpty(model.bean_name) && !IsStrEmpty(model.data_id)) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.customBL requestQueryApprovalDataWithDataId:@([model.data_id integerValue]) type:nil bean:model.bean_name processInstanceId:nil taskKey:nil];
        }else{
            
            if([model.is_outworker isEqualToString:@"0"]){// 外勤打卡，查看备注
                
                TFOutMarkController *outMark = [[TFOutMarkController alloc] init];
                outMark.recordModel = model;
                [self.navigationController pushViewController:outMark animated:YES];
                
            }
        }
        
    }
    
}

#pragma mark TFPCBottomViewDelegate
-(void)punchCardTipLocationClicked:(TFPutchRecordModel *)model{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (TFAtdWatDataListModel *model in self.punchViewModel.cardModel.attendance_address) {
        for (TFAtdLocationModel *lo in model.location) {
            TFLocationModel *ca = [[TFLocationModel alloc] init];
            ca.latitude = [lo.lat doubleValue];
            ca.longitude = [lo.lng doubleValue];
            ca.address = lo.address;
            ca.name = lo.name;
            ca.effective_range = model.effective_range;
            [arr addObject:ca];
        }
    }
    
    TFPCMapController *map = [[TFPCMapController alloc] init];
    map.locations = arr;
    map.punchViewModel = self.punchViewModel;
    map.punchDate = self.punchDate;
    if ([model.isPunch isEqualToString:@"1"]) {// 地址
        map.type = 1;
    }
    [self.navigationController pushViewController:map animated:YES];
}

- (void)punchCardClicked {// 打卡
    
    if (self.isAuto) {
        if ([self.punchViewModel.currentRecord.isPunch isEqualToString:@"0"] ||
            [self.punchViewModel.currentRecord.isPunch isEqualToString:@"3"]) {// 不能打，外勤
            return;
        }
        if ([self.punchViewModel.currentRecord.freedom isEqualToString:@"1"]) {// 不能自由打卡
            return;
        }
        
        if ([HQHelper getNowTimeSp] - self.timeSp < 10 * 1000) {// 大于10秒才能自动打下次卡
            return;
        }
        if ([self.punchViewModel.currentRecord.punchcard_status isEqualToString:@"1"] ||
            [self.punchViewModel.currentRecord.punchcard_status isEqualToString:@"2"]) {// 正常打卡，迟到打卡
        
            self.timeSp = [HQHelper getNowTimeSp];
            [self requestPunchCark];
        }
        
    }
    else{
        if ([self.punchViewModel.currentRecord.isPunch isEqualToString:@"0"]) {// 不能打卡
            [MBProgressHUD showError:@"不在考勤范围" toView:self.view];
            return;
        }
        NSNumber *time = [[NSUserDefaults standardUserDefaults] valueForKey:PunchCardTime];
        if ([HQHelper getNowTimeSp] - [time longLongValue] < 15 * 1000) {// 小于15秒，提示
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"打卡间隔时间需要15秒" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        self.noTip = NO;
        [self requestPunchCark];
    }
}

-(void)requestPunchCark{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.punchViewModel.currentRecord.punchcard_key) {
        [dict setObject:self.punchViewModel.currentRecord.punchcard_key forKey:@"punchcardTimeField"];
    }
    [dict setObject:@(self.punchDate) forKey:@"attendanceDate"];
    if (self.punchViewModel.cardModel.id) {
        [dict setObject:self.punchViewModel.cardModel.id forKey:@"groupId"];
    }
    if (self.punchViewModel.currentRecord.punchcard_type) {
        [dict setObject:self.punchViewModel.currentRecord.punchcard_type forKey:@"punchcardType"];
    }
    
    [dict setObject:@1 forKey:@"isOutworker"];
    if ([self.punchViewModel.currentRecord.isPunch isEqualToString:@"2"]) {
        [dict setObject:@(1) forKey:@"punchcardWay"];
    }else if ([self.punchViewModel.currentRecord.isPunch isEqualToString:@"1"]) {
        [dict setObject:@(0) forKey:@"punchcardWay"];
    }else if ([self.punchViewModel.currentRecord.isPunch isEqualToString:@"3"]) {
        [dict setObject:@(0) forKey:@"punchcardWay"];
        [dict setObject:@0 forKey:@"isOutworker"];
    }
    UIDevice *divice = [UIDevice currentDevice];
    [dict setObject:divice.model forKey:@"punchcardEquipment"];
    if (self.punchViewModel.currentRecord.punchcard_address) {
        [dict setObject:self.punchViewModel.currentRecord.punchcard_address forKey:@"punchcardAddress"];
    }
    if (self.punchViewModel.currentRecord.remark) {
        [dict setObject:self.punchViewModel.currentRecord.remark forKey:@"remark"];
    }
    if (self.punchViewModel.currentRecord.photo) {
        [dict setObject:self.punchViewModel.currentRecord.photo forKey:@"photo"];
    }
    
    if ([self.punchViewModel.currentRecord.punchcard_status isEqualToString:@"3"]) {// 早退
        NSString *str = [NSString stringWithFormat:@"%@ %@",[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"],self.punchViewModel.currentRecord.expect_punchcard_time];
        long long expSp = [HQHelper changeTimeToTimeSp:str formatStr:@"yyyy-MM-dd HH:mm"];
        long long now = [HQHelper getNowTimeSp];
        NSString *time = [NSString stringWithFormat:@"你早退了%lld分钟！",(expSp - now)/1000/60];
        if ((expSp - now)/1000/60 > 60) {
            time = [NSString stringWithFormat:@"你早退了%lld小时%lld分钟",((expSp - now)/1000/60)/60,((expSp - now)/1000/60)%60];
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:time message:[NSString stringWithFormat:@"下班时间：%@",self.punchViewModel.currentRecord.expect_punchcard_time] preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定打卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //    [self.attendanceBL requestPunchAttendanceWithDict:dict];
            RACSignal *signal = [self.punchViewModel.punchCommand execute:dict];
            [signal subscribeNext:^(id  _Nullable x) {
                [self punchAfterRefreshData];
            }];
            [signal subscribeError:^(NSError * _Nullable error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSString *str = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
                if (self.isAuto == NO) {
                    [MBProgressHUD showError:str toView:KeyWindow];
                }
            }];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //    [self.attendanceBL requestPunchAttendanceWithDict:dict];
        RACSignal *signal = [self.punchViewModel.punchCommand execute:dict];
        [signal subscribeNext:^(id  _Nullable x) {
            [self punchAfterRefreshData];
            if (self.isAuto) {// 自动打卡成功振动一下提示
                //  播放
                AudioServicesPlaySystemSound(1007);
                // 震动
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                //  停止播放
                AudioServicesRemoveSystemSoundCompletion(1007);
                // 停止震动
                AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
                if (self.autoAction) {
                    self.autoAction();
                }
                HQLog(@"==========自动打卡成功=========");
            }
        }];
        [signal subscribeError:^(NSError * _Nullable error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *str = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
            if (self.isAuto == NO) {
                [MBProgressHUD showError:str toView:KeyWindow];
            }
        }];
    }
    
}

-(void)punchAfterRefreshData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@([HQHelper getNowTimeSp]) forKey:PunchCardTime];
    [user synchronize];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    // 展示提示框
    if (!self.noTip && ![self.punchViewModel.currentRecord.id isEqualToNumber:@(0)] && ![self.punchViewModel.currentRecord.id isEqualToNumber:@(-1)]) {
        self.tipView.hidden = NO;
        if (self.isAuto == NO) {
            [KeyWindow addSubview:self.tipView];
        }
    }else if (self.noTip && ![self.punchViewModel.currentRecord.id isEqualToNumber:@(0)] && ![self.punchViewModel.currentRecord.id isEqualToNumber:@(-1)]){
        [MBProgressHUD showImageSuccess:@"更新成功" toView:self.view];
    }
    self.tipRecord = self.punchViewModel.currentRecord;
    self.tipRecord.real_punchcard_time = [NSString stringWithFormat:@"%lld",[HQHelper getNowTimeSp]];
    [self.tipView refreshTipViewWithModel:self.tipRecord];
    // 刷新数据
    [[self.punchViewModel.dataCommand execute:@(self.punchDate)] subscribeNext:^(id  _Nullable x) {
        [self refreshData];
    }];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    if (resp.cmdId == HQCMD_punchAttendance) {
        
        [self punchAfterRefreshData];
    }
    
    if (resp.cmdId == HQCMD_CustomQueryApprovalData) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        TFApprovalListItemModel *model = resp.body;
        
        TFApprovalDetailController *approval = [[TFApprovalDetailController alloc] init];
        approval.isReadRequest = YES;
        approval.approvalItem = model;
        approval.listType = [model.fromType integerValue];
        
        [self.navigationController pushViewController:approval animated:YES];
    }
    
    if (resp.cmdId == HQCMD_customModuleAuth) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *auths = resp.body;
        
        BOOL have = NO;
        for (TFCustomAuthModel *model in auths) {
            
            if ([model.auth_code isEqualToNumber:@1]) {
                have = YES;
                break;
            }
        }
        
        if (have) {
            if (self.action) {
                self.action();
            }
        }else{
            [MBProgressHUD showError:@"无权限" toView:self.view];
        }
        
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (self.isAuto == NO) {
        [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
    }
}

#pragma mark TFPCTipViewDelegate
- (void)knowClicked {
    
    self.tipView.hidden = YES;
    self.noTip = NO;
}

@end
