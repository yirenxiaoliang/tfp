//
//  HQSelectTimeView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/6/20.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum HQSelectTimeViewType{
    /** datePicker控制 */
    SelectTimeViewType_YearMonthDayHourMiuth,// 年月日时分
    SelectTimeViewType_YearMonthDay,         // 年月日
    SelectTimeViewType_HourMiuth,            // 时分
    
    /** pickerView控制 */
    SelectTimeViewType_YearMonth,            // 年月
    SelectTimeViewType_YearWeek,             // 年周
    SelectTimeViewType_Miuth           // 分
    
}SelectTimeViewType;

@interface HQSelectTimeView : UIView
/**
 * 时间选择
 *
 * @param dateType 时间选择器类型
 * @param timeSp   开始时间
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) selectTimeViewWithType:(SelectTimeViewType)type
                         timeSp:(long long)timeSp
                    LeftTouched:(ActionHandler)onLeftTouched
                 onRightTouched:(Action)onRightTouched;

/**
 * 时间选择
 *
 * @param dateType 时间选择器类型
 * @param timeSp   开始时间
 * @param timeTitle   时间标题
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) selectTimeViewWithType:(SelectTimeViewType)type
                         timeSp:(long long)timeSp
                      timeTitle:(NSString *)timeTitle
                    LeftTouched:(ActionHandler)onLeftTouched
                 onRightTouched:(Action)onRightTouched;
/**
 * 时间选择
 *
 * @param dateType 时间选择器类型
 * @param timeSp   开始时间
 * @param timeTitle   时间标题
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) selectTimeViewWithType:(SelectTimeViewType)type
                         timeSp:(long long)timeSp
                     showHeader:(BOOL)show
                    LeftTouched:(ActionHandler)onLeftTouched
                 onRightTouched:(Action)onRightTouched;
@end
