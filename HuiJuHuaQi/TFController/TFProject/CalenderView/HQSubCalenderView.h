//
//  HQSubCalenderView.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/2/22.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQSubCalenderView;
@class JBCalendarDate;

@protocol HQSubCalenderDelegate <NSObject>

/**************************************************************
 *@Description:选中了当前Unit的上一个Unit中的时间点
 *@Params:
 *  subCalenderView:当前subCalenderView
 *  date:选中的时间点
 *@Return:nil
 **************************************************************/
- (void)subCalenderView:(HQSubCalenderView *)subCalenderView selectedOnPreviousUnitWithDate:(JBCalendarDate *)date;

/**************************************************************
 *@Description:选中了当前Unit中的时间点
 *@Params:
 *  subCalenderView:当前subCalenderView
 *  date:选中的时间点
 *@Return:nil
 **************************************************************/
- (void)subCalenderView:(HQSubCalenderView *)subCalenderView selectedDate:(JBCalendarDate *)date isEnd:(BOOL)isEnd;


/**************************************************************
 *@Description:选中了当前Unit的下一个Unit中的时间点
 *@Params:
 *  subCalenderView:当前subCalenderView
 *  date:选中的时间点
 *@Return:nil
 **************************************************************/
- (void)subCalenderView:(HQSubCalenderView *)subCalenderView selectedOnNextUnitWithDate:(JBCalendarDate *)date;



@end





@interface HQSubCalenderView : UIView


@property (nonatomic, weak) id <HQSubCalenderDelegate> delegate;

@property (nonatomic, strong) NSDate *startSelectDate;
@property (nonatomic, strong) NSDate *endSelectDate;

/** 是否为截止日期 */
@property (nonatomic, assign) BOOL isEnd;


/**
 *  刷新当页日历
 *
 *  @param calenderArr  日期数据（上月，本月，下月）
 *  @param selectDate   当前选中日期
 *  @param grayPointArr 有灰点的日期
 */
- (void)refreshSubCalenderViewWithCalenderArr:(NSArray *)calenderArr
                              startSelectDate:(NSDate *)startSelectDate
                                endSelectDate:(NSDate *)endSelectDate;







@end
