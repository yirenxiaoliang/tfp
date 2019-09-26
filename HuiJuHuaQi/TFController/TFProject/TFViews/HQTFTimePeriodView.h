//
//  HQTFTimePeriodView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/16.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQTFTimePeriodView : UIView

/**
 * 时间段选择
 *
 * @param startTimeSp 开始时间
 * @param endTimeSp   结束时间
 * @param timeSpArray 时间戳数组（存放开始于结束时间戳）
 */
+ (void) selectTimeViewWithStartTimeSp:(long long)startTimeSp
                             endTimeSp:(long long)endTimeSp
                           timeSpArray:(ActionArray)timeSpArray;

@end
