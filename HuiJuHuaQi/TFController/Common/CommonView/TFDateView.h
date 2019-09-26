//
//  TFDateView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/4.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFDateView;
@protocol TFDateViewDelegate <NSObject>

@optional
-(void)dateView:(TFDateView *)dateView selectDate:(NSString *)selectDate;

@end

@interface TFDateView : UIView

/** delegate */
@property (nonatomic, weak) id <TFDateViewDelegate>delegate;

/** timeSp */
@property (nonatomic, assign) long long timeSp;
/**
 * 时间选择
 *
 * @param dateType 时间选择器类型
 * @param timeSp   开始时间
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (instancetype)selectDateViewWithFrame:(CGRect)frame
                                   type:(DateViewType)type
                                 timeSp:(long long)timeSp;


@end
