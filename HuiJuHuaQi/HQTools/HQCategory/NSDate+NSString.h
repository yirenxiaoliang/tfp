//
//  NSDate+NSString.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/9/26.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NSString)

/** 获取年月日时分秒 yyyy/MM/dd HH:mm:ss：2016/08/23 12:12:34 */
- (NSString *)getYearMonthDayHourMiuthSecond;

/** 获取年月日时分 yyyy/MM/dd HH:mm：2016/08/23 12:12 */
- (NSString *)getYearMonthDayHourMiuth;

/** 获取年月日 yyyy/MM/dd：2016/08/23 */
- (NSString *)getYearMonthDay;

/** 获取年月日 yyyy-MM-dd：2016-08-23 */
- (NSString *)getVerticalYearMonthDay;

/** 获取年月日 yyyy/MM：2016/08 */
- (NSString *)getHorizitalYearMonth;

/** 获取年月日 yyyy-MM：2016-08 */
- (NSString *)getVerticalYearMonth;

/** 获取时分 HH:mm：12:12 */
- (NSString *)getHourMiuth;

/** 获取年周 yyyy年ww周：2016年08周 */
- (NSString *)getYearWeek;

/** 获取年月 yyyy年ww月：2016年08月 */
- (NSString *)getYearMonth;

/** 获取月日 MM月dd日：08月12日 */
- (NSString *)getMonthDay;

/** 获取年 yyyy年：2015年 */
- (NSString *)getYear;

/** 获取年 yyyy：2015 */
- (NSString *)getyear;

/** 获取月 MM月：08月 */
- (NSString *)getMonth;

/** 获取月 MM月：08 */
- (NSString *)getmonth;

/** 获取日 dd日：12日 */
- (NSString *)getDay;

/** 获取日 dd日：12 */
- (NSString *)getday;

/** 获取小时 HH：12 */
- (NSString *)getHour;

/** 获取分钟 mm：34 */
- (NSString *)getMiute;

/** 获取秒 ss：34 */
- (NSString *)getSecond;

/** 获取周几 ww：周日 */
- (NSString *)getWeek;

/** 获取时间戳（毫秒） */
- (long long)getTimeSp;

/** 将时间戳按HH:mm格式时间输出,timeSp为毫秒 */
+ (NSString*)nsdateToTime:(long long)timeSp;

/*  获取指定时间的下一天时间戳,timeSp为毫秒  */
+ (long long)getTomorrowWith:(long long)timeSp;

/** 将时间戳按指定格式时间输出,timeSp为毫秒 */
+ (NSString*)nsdateToTime:(long long)timeSp formatStr:(NSString *)formatStr;

/** 将指定格式时间转换成时间戳 timeStr（2015年12月12日 23：12）的格式与formatStr（yyyy年MM月dd日 HH：mm）对应一样 */
+ (long long)changeTimeToTimeSp:(NSString *)timeStr formatStr:(NSString *)formatStr;

/** 将年周（2015年12周）转化为时间戳 */
+ (long long)changeWeekTimeToTimeSp:(NSString *)timeStr;

/** 将年周（2015年12周）转化为该周第一天的年月日（2015年12周的第一天（星期日）格式为：yyyy/MM/dd） */
+ (NSString *)changeWeekTimeToTime:(NSString *)timeStr;



@end
