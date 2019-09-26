//
//  NSDate+NSString.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/9/26.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "NSDate+NSString.h"
#import "NSDate+Calendar.h"

@implementation NSDate (NSString)

/** 获取年月日时分秒 yyyy/MM/dd HH:mm:ss：2016/08/23 12:12:34 */
- (NSString *)getYearMonthDayHourMiuthSecond{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}
/** 获取年月日时分 yyyy/MM/dd HH:mm：2016/08/23 12:12 */
- (NSString *)getYearMonthDayHourMiuth{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}
/** 获取年月日 yyyy/MM/dd：2016/08/23 */
- (NSString *)getYearMonthDay{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}

/** 获取年月日 yyyy-MM-dd：2016-08-23 */
- (NSString *)getVerticalYearMonthDay{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}

/** 获取年月日 yyyy-MM：2016-08 */
- (NSString *)getVerticalYearMonth{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}


/** 获取年月日 yyyy/MM：2016/08 */
- (NSString *)getHorizitalYearMonth{
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy/MM"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}

/** 获取时分 HH:mm：12:12 */
- (NSString *)getHourMiuth{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}
/** 获取年周 yyyy年ww周：2016年08周 */
- (NSString *)getYearWeek{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy年"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    NSString* year=[dateFormat stringFromDate:self];
    return [NSString stringWithFormat:@"%@%02ld周",year, [self week]];
}
/** 获取年月 yyyy年ww月：2016年08月 */
- (NSString *)getYearMonth{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy年MM月"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}
/** 获取月日 MM月dd日：08月12日 */
- (NSString *)getMonthDay{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM月dd日"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}

/** 获取年 yyyy年：2015年 */
- (NSString *)getYear{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy年"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}
/** 获取年 yyyy：2015 */
- (NSString *)getyear{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}
/** 获取月 MM月：08月 */
- (NSString *)getMonth{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM月"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}
/** 获取月 MM月：08 */
- (NSString *)getmonth{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}
/** 获取日 dd日：12日 */
- (NSString *)getDay{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd日"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}
/** 获取日 dd日：12 */
- (NSString *)getday{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}
/** 获取小时 HH：12 */
- (NSString *)getHour{
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"HH"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}
/** 获取分钟 mm：34 */
- (NSString *)getMiute{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}
/** 获取秒 ss：34 */
- (NSString *)getSecond{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:self];
}
/** 获取周几 ww：周日 */
- (NSString *)getWeek{
    NSString *weekStr = nil;
    if ([self weekday] == 1) {
        weekStr = @"周日";
    } else if ([self weekday] == 2){
        weekStr = @"周一";
    }else if ([self weekday] == 3){
        weekStr = @"周二";
    }else if ([self weekday] == 4){
        weekStr = @"周三";
    }else if ([self weekday] == 5){
        weekStr = @"周四";
    }else if ([self weekday] == 6){
        weekStr = @"周五";
    }else{
        weekStr = @"周六";
    }
    
    return weekStr;
}
/** 获取时间戳（毫秒） */
- (long long)getTimeSp{
    return [self timeIntervalSince1970]*1000;
}

/** 将时间戳按HH:mm格式时间输出,timeSp为毫秒 */
+ (NSString*)nsdateToTime:(long long)timeSp{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp/1000];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}
/*  获取指定时间的下一天时间戳,timeSp为毫秒  */
+ (long long)getTomorrowWith:(long long)timeSp
{
    NSString *time = [self nsdateToTime:timeSp+24*60*60*1000 formatStr:@"yyyy/MM/dd"];
    time = [NSString stringWithFormat:@"%@ 00:00:00", time];
    return [self changeTimeToTimeSp:time formatStr:@"yyyy/MM/dd HH:mm:ss"] * 1000;
}

/** 将时间戳按指定格式时间输出,timeSp为毫秒 */
+ (NSString*)nsdateToTime:(long long)timeSp formatStr:(NSString *)formatStr
{
    if (timeSp == 0) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp/1000];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormat setTimeZone:timeZone];
    [dateFormat setDateFormat:formatStr];
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}


/** 将指定格式时间转换成时间戳 timeStr（2015年12月12日 23：12）的格式与formatStr（yyyy年MM月dd日 HH：mm）对应一样 */
+ (long long)changeTimeToTimeSp:(NSString *)timeStr formatStr:(NSString *)formatStr
{
    long long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:formatStr];
    NSDate *fromdate=[format dateFromString:timeStr];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [format setTimeZone:timeZone];
    time= (long long)[fromdate timeIntervalSince1970];
    return time;
}

/** 将年周（2015年12周）转化为时间戳 */
+ (long long)changeWeekTimeToTimeSp:(NSString *)timeStr{
    NSString *year = [timeStr substringWithRange:NSMakeRange(0, 4)];
    NSString *week = [timeStr substringWithRange:NSMakeRange(5, 2)];
    
    NSInteger month = [week integerValue] * 7 / 30;
    NSMutableArray *months = [NSMutableArray array];
    if (month == 0) {
        [months addObject:[NSNumber numberWithInteger:month + 1]];
        [months addObject:[NSNumber numberWithInteger:month + 2]];
    }else if (month == 12){
        [months addObject:[NSNumber numberWithInteger:month - 1]];
        [months addObject:[NSNumber numberWithInteger:month]];
    }else{
        [months addObject:[NSNumber numberWithInteger:month - 1]];
        [months addObject:[NSNumber numberWithInteger:month]];
        [months addObject:[NSNumber numberWithInteger:month + 1]];
    }
    
    NSMutableArray *days = [NSMutableArray array];
    for (NSInteger i = 1; i < 32; i ++) {
        [days addObject:[NSNumber numberWithInteger:i]];
    }
    NSString *wantTime = nil;
    for (NSInteger index = [[months firstObject] integerValue]; index < [[months firstObject] integerValue] + months.count; index ++) {
        for (NSInteger day = [[days firstObject] integerValue]; day < [[days firstObject] integerValue] + days.count; day ++) {
            NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
            NSString *time = [NSString stringWithFormat:@"%@/%02ld/%02ld 12:00", year, index, day];
            NSDate *yearDate = [dateFormat dateFromString:time];
            HQLog(@"%ld", [yearDate week]);
            if ([yearDate week] == [week integerValue]) {
                wantTime = time;
                break;
            }
        }
    }
    return [self changeTimeToTimeSp:wantTime formatStr:@"yyyy/MM/dd HH:mm"] * 1000;
}

/** 将年周（2015年12周）转化为该周第一天的年月日（2015年12周的第一天（星期日）格式为：yyyy/MM/dd） */
+ (NSString *)changeWeekTimeToTime:(NSString *)timeStr{
    NSString *year = [timeStr substringWithRange:NSMakeRange(0, 4)];
    NSString *week = [timeStr substringWithRange:NSMakeRange(5, 2)];
    
    NSInteger month = [week integerValue] * 7 / 30;
    NSMutableArray *months = [NSMutableArray array];
    if (month == 0) {
        [months addObject:[NSNumber numberWithInteger:month + 1]];
        [months addObject:[NSNumber numberWithInteger:month + 2]];
    }else if (month == 12){
        [months addObject:[NSNumber numberWithInteger:month - 1]];
        [months addObject:[NSNumber numberWithInteger:month]];
    }else{
        [months addObject:[NSNumber numberWithInteger:month - 1]];
        [months addObject:[NSNumber numberWithInteger:month]];
        [months addObject:[NSNumber numberWithInteger:month + 1]];
    }
    
    NSMutableArray *days = [NSMutableArray array];
    for (NSInteger i = 1; i < 29; i ++) {
        [days addObject:[NSNumber numberWithInteger:i]];
    }
    NSString *wantTime = nil;
    for (NSInteger index = [[months firstObject] integerValue]; index < [[months firstObject] integerValue] + months.count; index ++) {
        for (NSInteger day = [[days firstObject] integerValue]; day < days.count; day ++) {
            NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"yyyy/MM/dd"];
            NSString *time = [NSString stringWithFormat:@"%@/%02ld/%02ld", year, index, day];
            NSDate *yearDate = [dateFormat dateFromString:time];
            if ([yearDate week] == [week integerValue]) {
                wantTime = time;
                break;
            }
        }
    }
    return wantTime;
}












@end
