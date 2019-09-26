//
//  HQCalendarLogic.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/2/23.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQCalendarLogic : NSObject

/*******************************************
 *@Description:类方法，为实现单例模型
 *@Params:nil
 *@return:返回唯一的
 *******************************************/
+ (HQCalendarLogic *)defaultCalendarLogic;



//  计算某月的相关信息
- (NSArray *)getSomeOneMonthMessage:(NSDate *)date;



@end
