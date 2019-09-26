//
//  PubMethods.h
//  ChatTest
//
//  Created by mac-mini on 2017/11/24.
//  Copyright © 2017年 Season. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PubMethods : NSObject

/**
 属性字符串转字符串，包含图片表情替换
 
 @param attr 属性字符串
 @return 转换后的字符串
 */
+ (NSString *)attributeStringToString:(NSAttributedString *)attr;

/**
 包含特殊字符的字符串转换属性字符串
 
 @param str 原字符串，含表情标签
 @return 转换后的属性字符串
 */
+ (NSMutableAttributedString *)stringToAttributeString:(NSString *)str;

@end
