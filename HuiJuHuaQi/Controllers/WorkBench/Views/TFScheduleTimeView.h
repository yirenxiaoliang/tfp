//
//  TFScheduleTimeView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/9.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TFScheduleTimeView;
@protocol TFScheduleTimeViewDelegate <NSObject>

@optional
-(void)scheduleTimeView:(TFScheduleTimeView *)scheduleTimeView selectTimeSp:(long long)timeSp;

@end

@interface TFScheduleTimeView : UIView

/** 初始化方法
 *
 *  @param selectTime 初始时间
 *  @param type 类型 0：天 1:月
 */
- (instancetype)initWithFrame:(CGRect)frame withSelectTime:(long long)selectTime withType:(NSInteger)type;

/** delegate */
@property (nonatomic, weak) id<TFScheduleTimeViewDelegate> delegate;

@end
