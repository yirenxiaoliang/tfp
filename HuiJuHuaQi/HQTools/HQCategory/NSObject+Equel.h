//
//  NSObject+Equel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/14.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Equel)

- (BOOL)isEqualToString:(NSString *)aString;

- (BOOL)isEqualToNumber:(NSNumber *)number;

@end

NS_ASSUME_NONNULL_END
