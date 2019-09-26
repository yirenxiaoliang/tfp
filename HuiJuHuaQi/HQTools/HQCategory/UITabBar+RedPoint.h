//
//  UITabBar+RedPoint.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/4/21.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (RedPoint)

- (void)showBadgeOnItemIndex:(int)index redPointCount:(int)redPointCount;

- (void)hideBadgeOnItemIndex:(int)index;

- (void)removeBadgeOnItemIndex:(int)index;

@end
