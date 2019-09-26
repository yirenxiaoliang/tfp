//
//  AlertView.h
//  WeiYP
//
//  Created by erisenxu on 15/11/13.
//  Copyright © 2015年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIView

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;


/**
 * 提示框（自定义提示文字）
 * @param title 标题
 * @param msg 内容
 * @param leftTitle 左按钮标题
 * @param rightTitle 右按钮标题
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) showAlertView:(NSString *)title
                   msg:(NSString *)msg
             leftTitle:(NSString *)leftTitle
            rightTitle:(NSString *)rightTitle
         onLeftTouched:(ActionHandler)onLeftTouched
        onRightTouched:(ActionHandler)onRightTouched;

/**
 * 提示框(默认为“提示”)
 * @param msg 内容
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) showAlertView:(NSString *)msg
         onLeftTouched:(ActionHandler)onLeftTouched
        onRightTouched:(ActionHandler)onRightTouched;



/**
 *  移除背景点击事件
 */
+ (void)removeBgBtnActionWithAlerView;

@end
