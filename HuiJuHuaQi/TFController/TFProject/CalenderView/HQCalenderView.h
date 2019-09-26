//
//  HQCalenderView.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/2/22.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JBCalendarDate;
@class HQCalenderView;

@protocol HQCalenderViewDelegate <NSObject>

@optional

/**************************************************************
 *@Description:选中了当前Unit的上一个Unit中的时间点
 *@Params:
 *  calenderView:当前calenderView
 *  date:选中的时间点
 *@Return:nil
 **************************************************************/
- (void)calenderView:(HQCalenderView *)calenderView selectedOnPreviousUnitWithDate:(JBCalendarDate *)date;

/**************************************************************
 *@Description:选中了当前Unit中的时间点
 *@Params:
 *  calenderView:当前calenderView
 *  date:选中的时间点
 *@Return:nil
 **************************************************************/
- (void)calenderView:(HQCalenderView *)calenderView selectedDate:(JBCalendarDate *)date isEnd:(BOOL)isEnd;


/**************************************************************
 *@Description:选中了当前Unit的下一个Unit中的时间点
 *@Params:
 *  calenderView:当前calenderView
 *  date:选中的时间点
 *@Return:nil
 **************************************************************/
- (void)calenderView:(HQCalenderView *)calenderView selectedOnNextUnitWithDate:(JBCalendarDate *)date;



/**
 *  滑动日历，或点击上一月下一月时调用
 *
 *  @param calenderView
 *  @param date         显示月的1号
 */
- (void)calenderView:(HQCalenderView *)calenderView scrollActionWithDate:(JBCalendarDate *)date;


@end




@interface HQCalenderView : UIView

@property (nonatomic, strong) NSDate *selectDate;

@property (nonatomic, strong) NSDate *startSelectDate;
@property (nonatomic, strong) NSDate *endSelectDate;

@property (nonatomic, assign) BOOL isEnd;


@property (nonatomic, assign) id <HQCalenderViewDelegate> delegate;









@end
