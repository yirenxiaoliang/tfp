//
//  NSString+Regular.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regular)

/** 由数字、字母和特殊字符组成 */
- (BOOL)haveNumberOrAlphabetOrSpecial;

/** 至少包含一个数字和一个字母，其他不限 */
- (BOOL)haveNumberAndAlphabet;

/** 至少包含一个数字、一个字母和一个特殊字符 */
- (BOOL)haveNumberAndAlphabetAndSepecialChar;

/** 至少包含一个数字、一个小写字母和一个大写字母，其他不限 */
- (BOOL)haveNumberAndUpperLowerAlphabet;

/** 至少包含一个数字、一个小写字母、一个大写字母和一个特殊字符 */
- (BOOL)haveNumberAndUpperLowerAlphabetAndSepecialChar;

-(BOOL)haveNumber;

/** 剪切首尾空白字符 */
-(NSString *)trimEmptySpace;

@end
