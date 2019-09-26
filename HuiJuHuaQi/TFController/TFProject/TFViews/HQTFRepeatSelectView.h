//
//  HQTFRepeatSelectView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQTFRepeatSelectView : UIView

/**
 * 时间选择
 *
 * @param type    类型  0:一个转（选择重复次数） 1：二个转（重复频率和次数）2：二个转（截止时间段）3：时长选择
 * @param start   第一个数值
 * @param end     第二个数值（type==0时，此值传@""）
 * @param timeArray   时间字符串
 */
+ (void) selectTimeViewWithStartWithType:(NSInteger)type
                                   start:(NSString *)start
                                     end:(NSString *)end
                               timeArray:(ActionArray)timeArray;


/**
 * 时间选择
 *
 * @param type    类型  0:一个转（选择重复次数） 1：二个转（重复频率和次数）2：二个转（截止时间段）3：时长选择
 * @param start   第一个数值
 * @param end     第二个数值（type==0时，此值传@""）
 * @param timeArray   时间字符串
 */
+ (void) selectTimeViewWithStartWithType:(NSInteger)type
                                   title:(NSString *)title
                                   start:(NSString *)start
                                     end:(NSString *)end
                               timeArray:(ActionArray)timeArray;
@end
