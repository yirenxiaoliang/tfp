//
//  TFClassesDetailController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/15.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFClassesDetailController.h"
#import "TFPCPeoplesCell.h"
#import "TFSelectDateView.h"
#import "TFAttendanceCalendarCell.h"
#import "SKCalendarView.h"
#import "TFAtdSingleLableCell.h"
#import "TFMutilStyleSelectPeopleController.h"

#import "TFAttendanceBL.h"
#import "SKCalendarManage.h"
#import "TFAtdClassDetailModel.h"
#import "HQTFNoContentCell.h"
#import "TFArrangeClassModel.h"
#import "NSDate+NSString.h"

@interface TFClassesDetailController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFAttendanceCalendarCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) SKCalendarView * calendarView;

/** 选中的那天 */
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) TFAttendanceBL *attendanceBL;

@property (nonatomic, strong) NSMutableArray *dataSources;

@property (nonatomic, strong) SKCalendarManage * calendarManage;


@property (nonatomic, strong) HQEmployModel *empModel;

@property (nonatomic, assign) long long timeSp;

@property (nonatomic, strong) TFArrangeClassModel *detailModel;

@property (nonatomic, strong) TFAtdClassModel *classModel;

@end

@implementation TFClassesDetailController

- (HQEmployModel *)empModel {
    
    if (!_empModel) {
        
        _empModel = [[HQEmployModel alloc] init];
        _empModel.id = UM.userLoginInfo.employee.id;
        _empModel.employee_name = UM.userLoginInfo.employee.employee_name;
        _empModel.picture = UM.userLoginInfo.employee.picture;
        
    }
    return _empModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeSp = [HQHelper getNowTimeSp];
    self.calendarManage = [SKCalendarManage manage];
    self.date = [NSDate date];
    //计算本月的第一天是星期几
    [self.calendarManage calculationThisMonthFirstDayInWeek:self.date];
    
    
    [self setNavi];
    [self setupTableView];
    
    self.attendanceBL = [TFAttendanceBL build];
    self.attendanceBL.delegate = self;
    
    [self requestData];
    
}

- (void)requestData {
    
    [self.attendanceBL requestGetAttendanceManagementFindAppDetailWithMonth:@(self.timeSp) employeeId:UM.userLoginInfo.employee.id];
}

- (void)setNavi {
    
    self.navigationItem.title = @"排班详情";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(selectDate) text:[NSString stringWithFormat:@"%@",[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM"]] textColor:GreenColor];
    

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
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            TFPCPeoplesCell *cell = [TFPCPeoplesCell PCPeoplesCellWithTableView:tableView];
            
            [cell configClassesDetailCellWithData:self.empModel];
            cell.memberLab.hidden = YES;
            cell.bottomLine.hidden = NO;
            cell.headMargin = 0;
            cell.positionLab.text = [NSString stringWithFormat:@"考勤组：%@",self.detailModel.group_name];
            return cell;
        }
        else if (indexPath.row == 1) {
            
            TFAttendanceCalendarCell *cell = [TFAttendanceCalendarCell attendanceCalendarCellWithTableView:tableView];
            
            cell.delegate = self;
            [cell configAttendanceCalendarCellWithTableView:self.date];
            return cell;
            
        }
    }
    else {


        if (!self.classModel.classDesc || [self.classModel.classDesc isEqualToString:@""]) {
            
            HQTFNoContentCell *cell = [HQTFNoContentCell noContentCellWithTableView:tableView withImage:@"图123" withText:@"当天没有安排排班，如需排班请在登录PC端操作"];
            
            return cell;
        }
        else {
            
            TFAtdSingleLableCell *cell = [TFAtdSingleLableCell atdSingleLableCellWithTableView:tableView];
            cell.singleLab.text = [NSString stringWithFormat:@"    %@    ",self.classModel.classDesc];
            cell.singleLab.layer.cornerRadius = 3.0;
            cell.singleLab.layer.masksToBounds = YES;
            cell.singleLab.backgroundColor = kUIColorFromRGB(0x27D5E1);
            return cell;
        }
        
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            TFMutilStyleSelectPeopleController *select = [[TFMutilStyleSelectPeopleController alloc] init];
            
            select.selectType = 1;
            select.isSingleSelect = YES;
            
            select.actionParameter = ^(id parameter) {
                
                self.empModel = parameter[0];
                
                [self.tableView reloadData];
                [self requestData];
            };
            
            [self.navigationController pushViewController:select animated:YES];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {
            
            return 274;
        }
    }
    else if (indexPath.section == 1) {
        
        if (!self.classModel.classDesc || [self.classModel.classDesc isEqualToString:@""]) {
            
            return 205;
        }
        else {
            
            return 66;
        }
    }
    
    return 80;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        
        return 44;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *lab = [UILabel initCustom:CGRectMake(15, 0, SCREEN_WIDTH-30, 44) title:@"考勤班次" titleColor:kUIColorFromRGB(0x999999) titleFont:14 bgColor:ClearColor];
    lab.textAlignment = NSTextAlignmentLeft;
    
    [view addSubview:lab];
    view.backgroundColor = kUIColorFromRGB(0xf2f2f2);
    return view;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark 切换月份
- (void)selectDate {
    
    [TFSelectDateView selectDateViewWithType:DateViewType_YearMonth timeSp:self.timeSp onRightTouched:^(NSString *time) {
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(selectDate) text:time textColor:GreenColor];
        
        NSString *dateStr = [NSString stringWithFormat:@"%@-01",time];
        long long timeSp = [HQHelper changeTimeToTimeSp:dateStr formatStr:@"yyyy-MM-dd"];
        self.date = [NSDate dateWithTimeIntervalSince1970:timeSp/1000];
        self.timeSp = timeSp;
        
        //计算本月的第一天是星期几
        [self.calendarManage calculationThisMonthFirstDayInWeek:self.date];
        
        [self requestData];
    }];
    
}


#pragma mark TFAttendanceCalendarCellDelegate(选择日期)
- (void)selectDateWithItem:(NSInteger)item {
    
    NSString *str = [self.calendarManage.calendarDate[item] description];
    if(IsStrEmpty(str)){
        return;
    }else{
        
        NSString *dateStr = [NSString stringWithFormat:@"%04ld-%02ld-%02ld",self.calendarManage.year,self.calendarManage.month,[str integerValue]];
        long long time = [HQHelper changeTimeToTimeSp:dateStr formatStr:@"yyyy-MM-dd"];
        self.date = [NSDate dateWithTimeIntervalSince1970:time/1000];
        NSInteger day = [self.date.getday integerValue] - 1;
        self.classModel = self.detailModel.classes_arr[day];
        [self.tableView reloadData];
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    self.detailModel = resp.body;
    NSInteger day = [self.date.getday integerValue] - 1;
    self.classModel = self.detailModel.classes_arr[day];
    
    [self.tableView reloadData];
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
