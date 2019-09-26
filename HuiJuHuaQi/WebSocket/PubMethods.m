//
//  PubMethods.m
//  ChatTest
//
//  Created by mac-mini on 2017/11/24.
//  Copyright © 2017年 Season. All rights reserved.
//

#import "PubMethods.h"

@implementation PubMethods

/**
 属性字符串转字符串，包含图片表情替换
 
 @param attr 属性字符串
 @return 转换后的字符串
 */
+ (NSString *)attributeStringToString:(NSAttributedString *)attr {
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]initWithAttributedString:attr];
    // 遍历整个属性字符串，获取其中的图片内容
    [attr enumerateAttributesInRange:NSMakeRange(0, attr.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        NSTextAttachment *textAtt = attrs[@"NSAttachment"];
        
        if (textAtt) {
            
            // 将图片与表情列表中图片比较，获取图片名
            for (NSString *name in [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoNames" ofType:@"plist"]]) {
                
                if([[UIImage imageNamed:name] isEqual:textAtt.image]) {
                    
                    // 使用[图片名]的形式替换掉图片
                    [result replaceCharactersInRange:range withString:[NSString stringWithFormat:@"[%@]",name]];
                }
            }
        }
        
        
    }];
    
    return [result string];
    
}


/**
 包含特殊字符的字符串转换属性字符串
 
 @param str 原字符串，含表情标签
 @return 转换后的属性字符串
 */
+ (NSMutableAttributedString *)stringToAttributeString:(NSString *)str {
    
    if (str == nil) {
        
        str = @"";
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    // 正则，查找 [...]
    NSString *emotionPattern = @"\\[[0-9a-zA-Z_\\u4e00-\\u9fa5]+\\]";
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:emotionPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    // 查找到的数组
    NSArray * arr = [re matchesInString:str options:0 range:NSMakeRange(0,str.length)];
    
    // 遍历表情列表，根据表情名获取图片
    for (NSInteger i = arr.count -1; i >= 0; i--) {
        
        NSTextCheckingResult *rst = arr[i];
        
        for (NSString *name in [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoNames" ofType:@"plist"]]) {
            
            // 根据表情名获取图片
            if ([[NSString stringWithFormat:@"[%@]",name] isEqualToString:[str substringWithRange:rst.range]]) {
                
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
                textAttachment.image = [UIImage imageNamed:name];
                textAttachment.bounds = CGRectMake(0, -3, 20, 20);
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                [attr replaceCharactersInRange:rst.range withAttributedString:imageStr];
            }
        }
        
    }
    return attr;
}


@end
