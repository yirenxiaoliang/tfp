//
//  HQNotPassSubmitView.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/7/4.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQTwoLableSubmitView : UIView

/**
 * 提交文字
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void)submitPlaceholderStr:(NSString *)placeholderStr secondPlaceholder:(NSString *)secondPlaceholder
                       title:(NSString *)title secondTitle:(NSString *)secondTitle
                  maxCharNum:(NSInteger)maxCharNum
                 LeftTouched:(ActionHandler)onLeftTouched
              onRightTouched:(gradeAction)onRightTouched;

@end
