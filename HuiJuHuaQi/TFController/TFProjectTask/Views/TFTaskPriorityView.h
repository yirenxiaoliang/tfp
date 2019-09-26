//
//  TFTaskPriorityView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/18.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFTaskPriorityView : UIView


/** type 0:状态 1：优先级
 *  status type == 0 时 0：未开始 1：进行中 2：暂停 3：已完成
 *  status type == 1 时 0：普通 1：紧急 2：非常紧急
 */
+(void)taskPriorityViewWithType:(NSInteger)type status:(NSInteger)status sure:(ActionParameter)sure;

/**
 *  prioritys 为选项
 */
+(void)taskPriorityViewWithPrioritys:(NSArray *)prioritys type:(NSInteger)type sure:(ActionParameter)sure;

@end

NS_ASSUME_NONNULL_END
