//
//  TFAttendanceCalendarCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAttendanceCalendarCell.h"
#import "SKConstant.h"
#import "SKCalendarManage.h"

@interface TFAttendanceCalendarCell()<SKCalendarViewDelegate>

@property (nonatomic, strong) SKCalendarView * calendarView;
@property (nonatomic, strong) UIButton * nextButton;
@property (nonatomic, strong) UIButton * lastButton;
@property (nonatomic, strong) UILabel * chineseYearLabel;// 农历年
@property (nonatomic, strong) UILabel * chineseMonthAndDayLabel;
@property (nonatomic, strong) UILabel * yearLabel;// 公历年
@property (nonatomic, strong) UILabel * holidayLabel;//节日&节气
@property (nonatomic, strong) UIButton * backToday;// 返回今天

@property (nonatomic, assign) NSUInteger lastMonth;
@property (nonatomic, assign) NSUInteger nextMonth;

@property (nonatomic, strong) NSDate *selectDate;

@property (nonatomic, strong) SKCalendarManage * calendarManage;

@end

@implementation TFAttendanceCalendarCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
//        self.schoCalenderView = [[SchoCustomDateCalenderView alloc] initWithSignInDays:6];
//        [self.view addSubview:self.schoCalenderView];
    }
    return self;
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
        self.lastMonth = _calendarView.lastMonth;// 获取上个月的月份
        self.nextMonth = _calendarView.nextMonth;// 获取下个月的月份
        
    }
    
    return _calendarView;
}

//配置数据
- (void)configAttendanceCalendarCellWithTableView:(NSDate *)date {
    
    self.selectDate = date;
    [self.calendarView checkCalendarWithAppointDate:date];
}

#pragma  mark SKCalendarViewDelegate
- (void)selectDateWithRow:(NSUInteger)row {
    
    self.calendarManage = [SKCalendarManage manage];
    [self.calendarManage calculationThisMonthFirstDayInWeek:self.selectDate];

    
    if ([self.delegate respondsToSelector:@selector(selectDateWithItem:)]) {
        
        [self.delegate selectDateWithItem:row];
    }

}

+ (instancetype)attendanceCalendarCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFAttendanceCalendarCell";
    TFAttendanceCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[TFAttendanceCalendarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self addSubview:self.calendarView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
