//
//  TFSendView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/31.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQEmployModel.h"
#import "TFSendModel.h"

@interface TFSendView : UIView
/**
 * 提示框
 * @param title 标题
 * @param msg 内容
 * @param leftTitle 左按钮标题
 * @param rightTitle 右按钮标题
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) showAlertView:(NSString *)title
                people:(HQEmployModel *)people
               content:(NSString *)content
              password:(NSString *)password
               endTime:(NSString *)endTime
            placehoder:(NSString *)placehoder
         onLeftTouched:(ActionHandler)onLeftTouched
        onRightTouched:(ActionParameter)onRightTouched;
@end
