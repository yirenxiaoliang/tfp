//
//  HQTFContactChoiceView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQTFContactChoiceView : UIView

/**
 * 提示框
 * @param title 标题
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) showContactChoiceView:(NSString *)title
                 onLeftTouched:(ActionHandler)onLeftTouched
                onRightTouched:(ActionParameter)onRightTouched;


@end
