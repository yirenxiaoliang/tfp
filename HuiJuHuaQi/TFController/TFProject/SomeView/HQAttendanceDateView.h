//
//  HQAttendanceDateView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/10/11.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HQAttendanceDateViewDelegate <NSObject>

@optional
- (void)attendanceDateViewWithDate:(NSDate *)date;
- (void)attendanceDateViewDidClickedTimeWithDate:(NSDate *)date;

@end

@interface HQAttendanceDateView : UIView
+ (instancetype)attendanceDateView;
@property (nonatomic, weak) id<HQAttendanceDateViewDelegate>delegate;
/** 当前Date */
@property (nonatomic, strong) NSDate *currentDate;
/** 类型 */
@property (nonatomic, assign) NSInteger type;
@end
