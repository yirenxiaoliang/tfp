//
//  NSString+Regular.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "NSString+Regular.h"

@implementation NSString (Regular)

/** ( ~ ` @ # $ % ^ & * - _ = + | \ ? / ( ) < > [ ] { } “ , . ; ‘ !） */


/** 由数字、字母和特殊字符组成 */
- (BOOL)haveNumberOrAlphabetOrSpecial
{
    NSString *str = @"([0-9]*|[a-zA-Z]*|[&~`@#%_\\(\\)\\[\\]\\{\\}\\$\\^\\*\\.\\?\\|=\\+/<>\\\",\\\\;'!-])*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [predicate evaluateWithObject:self];
}

-(BOOL)haveNumber{
    
    NSString *str = @"[0-9]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [predicate evaluateWithObject:self];
}

-(BOOL)haveAlphabet{
    
    NSString *str = @"[a-zA-Z]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [predicate evaluateWithObject:self];
}

-(BOOL)haveLowerAlphabet{
    
    NSString *str = @"[a-z]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [predicate evaluateWithObject:self];
}

-(BOOL)haveUpperAlphabet{
    
    NSString *str = @"[A-Z]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [predicate evaluateWithObject:self];
}

-(BOOL)haveSpecialChar{
    
    NSString *str = @"[&~`@#%_\\(\\)\\[\\]\\{\\}\\$\\^\\*\\.\\?\\|=\\+/<>\\\",\\\\;'!-]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [predicate evaluateWithObject:self];
}

/** 至少包含一个数字和一个字母，其他不限 */
- (BOOL)haveNumberAndAlphabet
{
//    NSString *str = @"[0-9]+|[a-zA-Z]+|[&~`@#%_\\(\\)\\[\\]\\{\\}\\$\\^\\*\\.\\?\\|=\\+/<>\\\",\\\\;'!-]*";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
//    return [predicate evaluateWithObject:self];
    
    if ([self haveNumberOrAlphabetOrSpecial]) {
        
        BOOL num = NO;
        BOOL alp = NO;
        for(int i =0; i < [self length]; i++)
        {
            NSString *temp = [self substringWithRange:NSMakeRange(i, 1)];
            
            if ([temp haveNumber]) {
                num = YES;
            }
            if ([temp haveAlphabet]) {
                alp = YES;
            }
        }
        
        return num && alp;
        
    }else{
        return NO;
    }
    
}

/** 至少包含一个数字、一个字母和一个特殊字符 */
- (BOOL)haveNumberAndAlphabetAndSepecialChar
{
//    NSString *str = @"([0-9]+|[a-zA-Z]+|[&~`@#%_\\(\\)\\[\\]\\{\\}\\$\\^\\*\\.\\?\\|=\\+/<>\\\",\\\\;'!-]+)+([0-9]+|[a-zA-Z]+|[&~`@#%_\\(\\)\\[\\]\\{\\}\\$\\^\\*\\.\\?\\|=\\+/<>\\\",\\\\;'!-]+)+([0-9]+|[a-zA-Z]+|[&~`@#%_\\(\\)\\[\\]\\{\\}\\$\\^\\*\\.\\?\\|=\\+/<>\\\",\\\\;'!-]+)+";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
//    return [predicate evaluateWithObject:self];
    
    
    if ([self haveNumberOrAlphabetOrSpecial]) {
        
        BOOL num = NO;
        BOOL alp = NO;
        BOOL sep = NO;
        for(int i =0; i < [self length]; i++)
        {
            NSString *temp = [self substringWithRange:NSMakeRange(i, 1)];
            
            if ([temp haveNumber]) {
                num = YES;
            }
            if ([temp haveAlphabet]) {
                alp = YES;
            }
            if ([temp haveSpecialChar]) {
                sep = YES;
            }
        }
        
        return num && alp && sep;
        
    }else{
        return NO;
    }
}


/** 至少包含一个数字、一个小写字母和一个大写字母，其他不限 */
- (BOOL)haveNumberAndUpperLowerAlphabet
{
//    NSString *str = @"([0-9]+|[a-z]+|[A-Z]+|[&~`@#%_\\(\\)\\[\\]\\{\\}\\$\\^\\*\\.\\?\\|=\\+/<>\\\",\\\\;'!-]*)+([0-9]+|[a-z]+|[A-Z]+|[&~`@#%_\\(\\)\\[\\]\\{\\}\\$\\^\\*\\.\\?\\|=\\+/<>\\\",\\\\;'!-]*)+([0-9]+|[a-z]+|[A-Z]+|[&~`@#%_\\(\\)\\[\\]\\{\\}\\$\\^\\*\\.\\?\\|=\\+/<>\\\",\\\\;'!-]*)+";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
//    return [predicate evaluateWithObject:self];
    
    
    if ([self haveNumberOrAlphabetOrSpecial]) {
        
        BOOL num = NO;
        BOOL low = NO;
        BOOL upp = NO;
        for(int i =0; i < [self length]; i++)
        {
            NSString *temp = [self substringWithRange:NSMakeRange(i, 1)];
            
            if ([temp haveNumber]) {
                num = YES;
            }
            if ([temp haveLowerAlphabet]) {
                low = YES;
            }
            if ([temp haveUpperAlphabet]) {
                upp = YES;
            }
        }
        
        return num && low && upp;
        
    }else{
        return NO;
    }
}


/** 至少包含一个数字、一个小写字母、一个大写字母和一个特殊字符 */
- (BOOL)haveNumberAndUpperLowerAlphabetAndSepecialChar
{
//    NSString *str = @"([0-9]+|[a-z]+|[A-Z]+|[&~`@#%_\\(\\)\\[\\]\\{\\}\\$\\^\\*\\.\\?\\|=\\+/<>\\\",\\\\;'!-]+)+([0-9]+|[a-z]+|[A-Z]+|[&~`@#%_\\(\\)\\[\\]\\{\\}\\$\\^\\*\\.\\?\\|=\\+/<>\\\",\\\\;'!-]+)+([0-9]+|[a-z]+|[A-Z]+|[&~`@#%_\\(\\)\\[\\]\\{\\}\\$\\^\\*\\.\\?\\|=\\+/<>\\\",\\\\;'!-]+)+([0-9]+|[a-z]+|[A-Z]+|[&~`@#%_\\(\\)\\[\\]\\{\\}\\$\\^\\*\\.\\?\\|=\\+/<>\\\",\\\\;'!-]+)+";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
//    return [predicate evaluateWithObject:self];
    
    
    if ([self haveNumberOrAlphabetOrSpecial]) {
        
        BOOL num = NO;
        BOOL low = NO;
        BOOL upp = NO;
        BOOL sep = NO;
        for(int i =0; i < [self length]; i++)
        {
            NSString *temp = [self substringWithRange:NSMakeRange(i, 1)];
            
            if ([temp haveNumber]) {
                num = YES;
            }
            if ([temp haveLowerAlphabet]) {
                low = YES;
            }
            if ([temp haveUpperAlphabet]) {
                upp = YES;
            }
            if ([temp haveSpecialChar]) {
                sep = YES;
            }
        }
        
        return num && low && upp && sep;
        
    }else{
        return NO;
    }
}




@end
