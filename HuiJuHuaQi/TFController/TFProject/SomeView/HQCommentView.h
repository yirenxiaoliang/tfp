//
//  HQCommentView.h
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/15.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQCommentView : UIView
/**
 * 评分
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) commentGradeWithLeftTouched:(ActionHandler)onLeftTouched onRightTouched:(gradeAction)onRightTouched;
@end
