//
//  TFCustomChangeView.h
//  HuiJuHuaQi
//
//  Created by HQ-30 on 2017/12/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFCustomChangeModel.h"
@interface TFCustomChangeView : UIView

/**
 * 提示框
 * @param title 标题
 * @param onRightTouched 右按钮被点击
 */
+ (void) showCustomChangeView:(NSString *)title
                        items:(NSArray <TFCustomChangeModel> *)items
               onRightTouched:(ActionParameter)onRightTouched;


@end
