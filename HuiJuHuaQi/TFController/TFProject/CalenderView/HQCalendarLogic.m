//
//  HQCalendarLogic.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/2/23.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQCalendarLogic.h"
#import "JBCalendarDate.h"
#import "NSDate+Calendar.h"

@interface HQCalendarLogic ()

@property (nonatomic, retain) NSArray *daysInSelectedMonth;
@property (nonatomic, retain) NSArray *daysInFinalWeekOfPreviousMonth;
@property (nonatomic, retain) NSArray *daysInFirstWeekOfFollowingMonth;

@end

@implementation HQCalendarLogic

+ (HQCalendarLogic *)defaultCalendarLogic
{
    static HQCalendarLogic *staticCalendarLogic;
    if (!staticCalendarLogic) {
        staticCalendarLogic = [[HQCalendarLogic alloc] init];
    }
    
    return staticCalendarLogic;
}



//////////////////////////////////////////////
//            Month And Week
//////////////////////////////////////////////
//  ------------------------Public------------------------

//  本月日历中，上一个月最后一周的天数
- (NSUInteger)numberOfDaysInPreviousPartialWeekWithDate:(NSDate *)date
{
    return (date.weekday - 1);
}

//  本月日历中，下一个月第一周的天数
- (NSUInteger)numberOfDaysInFollowingPartialWeekWithDate:(NSDate *)date
{
    return (7 - [date lastDayOfTheMonth].weekday);
}




//////////////////////////////////////////////
//                  Month
//////////////////////////////////////////////
//  本月日历中，上一个月最后一周的日期列表
- (NSArray *)calculateDaysInFinalWeekOfPreviousMonthWithDate:(NSDate *)date
{
    NSMutableArray *days = [NSMutableArray array];
    
    NSDate *beginningOfPreviousMonth = [date firstDayOfThePreviousMonth];
    NSUInteger numberOfDaysOfPreviousMonth = [beginningOfPreviousMonth numberOfDaysInMonth];
    NSUInteger numberOfDaysInPreviousPartialWeek = [self numberOfDaysInPreviousPartialWeekWithDate:date];
    
    for (NSUInteger day = numberOfDaysOfPreviousMonth - numberOfDaysInPreviousPartialWeek + 1; day <= numberOfDaysOfPreviousMonth; day++) {
        
        JBCalendarDate *calendarDate = [JBCalendarDate dateWithYear:beginningOfPreviousMonth.year
                                                              Month:beginningOfPreviousMonth.month
                                                                Day:day];
        calendarDate.monthState = NO;
        [days addObject:calendarDate];
    }
    
    return days;
}

//  本月日历中，本月的日期列表
- (NSArray *)calculateDaysInSelectedMonthWithDate:(NSDate *)date
{
    NSMutableArray *days = [NSMutableArray array];
    
    NSUInteger numberOfDaysInSelectedMonth = [date numberOfDaysInMonth];
    for (NSUInteger day = 1; day <= numberOfDaysInSelectedMonth; day++) {
        
        JBCalendarDate *calendarDate = [JBCalendarDate dateWithYear:date.year
                                                              Month:date.month
                                                                Day:day];
        calendarDate.monthState = YES;
        [days addObject:calendarDate];
    }
    
    return days;
}

//  本月日历中，下一个月第一周的日期列表
- (NSArray *)calculateDaysInFirstWeekOfFollowingMonthWithDate:(NSDate *)date
{
    NSMutableArray *days = [NSMutableArray array];
    
    NSDate *firstDayOfTheFollowingMonth = [date firstDayOfTheFollowingMonth];
    
    NSUInteger numberOfDaysInFollowingPartialWeek = [self numberOfDaysInFollowingPartialWeekWithDate:date];
    
    for (NSUInteger day = 1; day <= numberOfDaysInFollowingPartialWeek; day++) {
        
        JBCalendarDate *calendarDate = [JBCalendarDate dateWithYear:firstDayOfTheFollowingMonth.year
                                                              Month:firstDayOfTheFollowingMonth.month
                                                                Day:day];
        calendarDate.monthState = NO;
        [days addObject:calendarDate];
    }
    
    return days;
}

//  本月日历中，下一个月前两周的日期列表
- (NSArray *)calculateDaysInFirstWeekOfFollowingMonthOfTwoWeeksWithDate:(NSDate *)date
{
    NSMutableArray *days = [NSMutableArray array];
    
    NSDate *firstDayOfTheFollowingMonth = [date firstDayOfTheFollowingMonth];
    
    NSUInteger numberOfDaysInFollowingPartialWeek = [self numberOfDaysInFollowingPartialWeekWithDate:date];
    
    for (NSUInteger day = 1; day <= numberOfDaysInFollowingPartialWeek+7; day++) {
        
        JBCalendarDate *calendarDate = [JBCalendarDate dateWithYear:firstDayOfTheFollowingMonth.year
                                                              Month:firstDayOfTheFollowingMonth.month
                                                                Day:day];
        calendarDate.monthState = NO;
        [days addObject:calendarDate];
    }
    
    return days;
}





//  计算某月的相关信息
- (NSArray *)getSomeOneMonthMessage:(NSDate *)date
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        self.daysInSelectedMonth = [self calculateDaysInSelectedMonthWithDate:date];
        
        self.daysInFinalWeekOfPreviousMonth = [self calculateDaysInFinalWeekOfPreviousMonthWithDate:date];
        
        
        if (self.daysInSelectedMonth.count + self.daysInFinalWeekOfPreviousMonth.count > 35) {
            
            self.daysInFirstWeekOfFollowingMonth = [self calculateDaysInFirstWeekOfFollowingMonthWithDate:date];
        }else {
            self.daysInFirstWeekOfFollowingMonth = [self calculateDaysInFirstWeekOfFollowingMonthOfTwoWeeksWithDate:date];
        }
    
    
        return @[self.daysInFinalWeekOfPreviousMonth,
                 self.daysInSelectedMonth,
                 self.daysInFirstWeekOfFollowingMonth];
//    }
    
        
}


@end
