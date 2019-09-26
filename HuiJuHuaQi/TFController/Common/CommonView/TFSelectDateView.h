//
//  TFSelectDateView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/5.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFSelectDateView : UIView

/**
 * 时间选择
 *
 * @param dateType 时间选择器类型
 * @param timeSp   开始时间
 * @param onRightTouched 右按钮被点击
 */
+ (void) selectDateViewWithType:(DateViewType)type
                         timeSp:(long long)timeSp
                 onRightTouched:(Action)onRightTouched;

@end
