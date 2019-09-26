//
//  HQTFTimeTableView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/2.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HQTFTimeTableViewDelegate <NSObject>

/**
 *  选择的某个日期
 *
 *  @param selectTimeSp 选择的时间戳
 */
- (void)timeTableViewSelectTimeSp:(long long)selectTimeSp;

@end


@interface HQTFTimeTableView : UIView

@property (assign, nonatomic) id <HQTFTimeTableViewDelegate> delegate;



- (void)refreshTimeTableViewWithSelectTimeSp:(long long)selectTimeSp;

@end
