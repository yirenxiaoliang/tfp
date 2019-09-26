//
//  HQCalenderItemView.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/2/22.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBCalendarDate.h"

@class HQCalenderItemView;
@protocol HQCalenderItemDelegate <NSObject>

//  点击了上一个Unit中的某个unitTileView
- (void)tappedInPreviousUnitOnUnitTileView:(HQCalenderItemView *)unitTileView;
//  点击了下一个Unit中的某个unitTileView
- (void)tappedInNextUnitOnUnitTileView:(HQCalenderItemView *)unitTileView;


//  点击当前Unit中的某个unitTileView
- (void)tappedInSelectedUnitOnUnitTileView:(HQCalenderItemView *)unitTileView isEnd:(BOOL)isEnd;

@end


@interface HQCalenderItemView : UIView


@property (nonatomic, assign) id <HQCalenderItemDelegate> delegate;


//  日期
@property (nonatomic, strong)   JBCalendarDate *date;

/** isEnd */
@property (nonatomic, assign) BOOL isEnd;

@property (nonatomic, strong) NSDate *startSelectDate;

@property (nonatomic, strong) NSDate *endSelectDate;


//  是否是当前Unit之外的日期
//@property (nonatomic, assign)   BOOL previousUnit;  //  上一个Unit
//
//@property (nonatomic, assign)   BOOL nextUnit;      //  下一个Unit

//  是否选中
//@property (nonatomic, assign)   BOOL selected;



//  日期中“日”显示的Label
@property (nonatomic, strong)   UILabel *dayLabel;


//  标记灰点
//@property (nonatomic, strong)   UIView  *grayPointView;


//  当前选中绿色圆背景
@property (nonatomic, strong)   UIView  *greenBgView;


//@property (nonatomic, assign) BOOL futureTimeCanDidBool;   //未来时间能点不，YES为能点

//- (void)reloadCalenderItem:(JBCalendarDate *)date;


@end
