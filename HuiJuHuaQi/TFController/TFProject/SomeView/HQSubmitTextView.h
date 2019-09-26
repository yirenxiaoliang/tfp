//
//  HQSubmitTextView.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/4/18.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQSubmitTextView : UIView

/**
 * 提交文字
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void)submitTitlWithTitle:(NSString *)titleStr
             placeholderStr:(NSString *)placeholderStr
                LeftTouched:(ActionHandler)onLeftTouched
             onRightTouched:(gradeAction)onRightTouched;



+ (void)submitTitlWithTitle:(NSString *)titleStr
                       text:(NSString *)text
             placeholderStr:(NSString *)placeholderStr
                LeftTouched:(ActionHandler)onLeftTouched
             onRightTouched:(gradeAction)onRightTouched;



/**
 * 提交文字(最大字符数)
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 * @param maxCharNum  最大字符数
 */
+ (void)submitTitlWithTitle:(NSString *)titleStr
                       text:(NSString *)text
             placeholderStr:(NSString *)placeholderStr
                 maxCharNum:(NSInteger)maxCharNum
                LeftTouched:(ActionHandler)onLeftTouched
             onRightTouched:(gradeAction)onRightTouched;

@end
