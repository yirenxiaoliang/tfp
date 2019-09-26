//
//  TFAttendanceMonthController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/14.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAttendanceMonthController.h"
#import "SKCalendarView.h"
#import "TFAttendanceBL.h"
#import "TFCalendarMonthModel.h"
#import "TFAttendanceMonthCell.h"
#import "NSDate+Calendar.h"
#import "HQTFNoContentView.h"
#import "TFSelectDateView.h"

@interface TFAttendanceMonthController ()<SKCalendarViewDelegate,HQBLDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) SKCalendarView *calendarView;

@property (nonatomic, strong) TFAttendanceBL *attendanceBL;

@property (nonatomic, strong) TFCalendarMonthModel *monthModel;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) TFCalendarMonthItemModel *currentItem;


@property (nonatomic, strong) HQTFNoContentView *noContentView;
@end

@implementation TFAttendanceMonthController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2-44,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}
- (SKCalendarView *)calendarView
{
    if (!_calendarView) {
        _calendarView = [[SKCalendarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 274)];
        //        _calendarView.layer.cornerRadius = 5;
        //        _calendarView.layer.borderColor = [UIColor blackColor].CGColor;
        //        _calendarView.layer.borderWidth = 0.5;
        _calendarView.delegate = self;// 获取点击日期的方法，一定要遵循协议
        _calendarView.calendarTitleColor = kUIColorFromRGB(0x8C96AB);
        _calendarView.calendarTodayTitleColor = [UIColor redColor];// 今天标题字体颜色
        _calendarView.calendarTodayTitle = @"今日";// 今天下标题
        _calendarView.dateColor = kUIColorFromRGB(0xDEEAFF);// 今天日期数字背景颜色
        _calendarView.calendarTodayColor = kUIColorFromRGB(0x667490);// 今天日期字体颜色
        _calendarView.dayoffInWeekColor = kUIColorFromRGB(0xCACAD0);//双休日字体颜色
        _calendarView.springColor = [UIColor colorWithRed:48 / 255.0 green:200 / 255.0 blue:104 / 255.0 alpha:1];// 春季节气颜色
        _calendarView.summerColor = [UIColor colorWithRed:18 / 255.0 green:96 / 255.0 blue:0 alpha:8];// 夏季节气颜色
        _calendarView.autumnColor = [UIColor colorWithRed:232 / 255.0 green:195 / 255.0 blue:0 / 255.0 alpha:1];// 秋季节气颜色
        _calendarView.winterColor = [UIColor colorWithRed:77 / 255.0 green:161 / 255.0 blue:255 / 255.0 alpha:1];// 冬季节气颜色
        _calendarView.holidayColor = [UIColor redColor];//节日字体颜色
//        self.lastMonth = _calendarView.lastMonth;// 获取上个月的月份
//        self.nextMonth = _calendarView.nextMonth;// 获取下个月的月份
    }
    
    return _calendarView;
}

#pragma mark - SKCalendarViewDelegate
-(void)selectDateWithRow:(NSUInteger)row{
    NSInteger ii = row - self.calendarView.calendarManage.dayInWeek + 1;
    if (ii  < self.monthModel.dateList.count && ii >= 0) {
        self.currentItem = self.monthModel.dateList[row - self.calendarView.calendarManage.dayInWeek + 1];
        self.datas = [NSArray arrayWithArray:self.currentItem.attendanceList];
        
        if (self.datas.count) {
            self.tableView.backgroundView = nil;
        }else{
            self.tableView.backgroundView = self.noContentView;
        }
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.calendarView];
    self.navigationItem.title = @"打卡月历";
    self.punchDate = [HQHelper changeTimeToTimeSp:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM"] formatStr:@"yyyy-MM"];
    
    [self.calendarView checkCalendarWithAppointDate:[NSDate dateWithTimeIntervalSince1970:self.punchDate/1000]];
    self.attendanceBL = [TFAttendanceBL build];
    self.attendanceBL.delegate = self;
    [self.attendanceBL requestAttendanceDataWithAttendanceMonth:@(self.punchDate) employeeId:nil];
    [self setupTableView];
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(selectDate) text:[HQHelper nsdateToTime:self.punchDate formatStr:@"yyyy-MM"]];
}

-(void)selectDate{
    
    [TFSelectDateView selectDateViewWithType:DateViewType_YearMonth timeSp:self.punchDate onRightTouched:^(NSString *time) {
        
        self.punchDate = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM"];
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(selectDate) text:time];
        [self.calendarView checkCalendarWithAppointDate:[NSDate dateWithTimeIntervalSince1970:self.punchDate/1000]];
        self.calendarView.selectedRow = self.calendarView.calendarManage.dayInWeek-1;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.attendanceBL requestAttendanceDataWithAttendanceMonth:@(self.punchDate) employeeId:nil];
        
    }];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (resp.cmdId == HQCMD_attendanceEmployeeMonthStatistics) {
        self.monthModel = resp.body;
        
        // 当前前
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.punchDate/1000];
        NSDate *now = [NSDate date];
        if (date.month == now.month && date.year == now.year) {// 当前月
            self.currentItem = self.monthModel.dateList[now.day-1];
            self.datas = [NSArray arrayWithArray:self.currentItem.attendanceList];
            self.calendarView.selectedRow = self.calendarView.calendarManage.todayPosition;
        }else{
            self.currentItem = self.monthModel.dateList.firstObject;
            self.datas = [NSArray arrayWithArray:self.currentItem.attendanceList];
            self.calendarView.selectedRow = self.calendarView.calendarManage.dayInWeek-1;// 选择第一天
        }
        
        if (self.datas.count) {
            self.tableView.backgroundView = nil;
        }else{
            self.tableView.backgroundView = self.noContentView;
        }
        // 赋值，刷新
        self.calendarView.dataList = self.monthModel.dateList;
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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.calendarView.height, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-self.calendarView.height) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}
#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFAttendanceMonthCell *cell = [TFAttendanceMonthCell attendanceMonthCellWithTableView:tableView];
    [cell refreshAttendanceMonthCellWithModel:self.datas[indexPath.row]];
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }else{
        cell.topLine.hidden = NO;
    }
    if (indexPath.row == self.datas.count-1) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!IsStrEmpty(self.currentItem.groupName)) {
        
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-30,44}];
        [view addSubview:label];
        label.font = FONT(14);
        label.textColor = ExtraLightBlackTextColor;
        view.backgroundColor = BackGroudColor;
        label.text = [NSString stringWithFormat:@"考勤组：%@",TEXT(self.currentItem.groupName)];
        return view;
    }else{
        return [UIView new];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!IsStrEmpty(self.currentItem.groupName)) {
        return 44;
    }
    return 0.5;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.5;
    
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
