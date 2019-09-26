//
//  HQTFSelectDateView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQTFSelectDateView : UIView


/**
 * 选择日期
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) showDateViewOnLeftTouched:(ActionHandler)onLeftTouched
                    onRightTouched:(ActionParameter)onRightTouched;
@end
