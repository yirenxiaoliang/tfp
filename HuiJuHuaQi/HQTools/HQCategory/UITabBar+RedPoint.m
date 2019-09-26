//
//  UITabBar+RedPoint.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/4/21.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "UITabBar+RedPoint.h"

#define TabbarItemNums 5   //tabbar的数量

@implementation UITabBar (RedPoint)



- (void)showBadgeOnItemIndex:(int)index redPointCount:(int)redPointCount
{
    
    [self removeBadgeOnItemIndex:index];
    
    if (redPointCount <= 0) {
        
        return;
    }
    
    
    CGRect tabFrame = self.frame;
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    
    UILabel *unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 20, 20)];
    unreadLabel.tag = 888 + index;
    unreadLabel.backgroundColor = RedColor;
    unreadLabel.textColor = [UIColor whiteColor];
    unreadLabel.textAlignment = NSTextAlignmentCenter;
    unreadLabel.font = [UIFont systemFontOfSize:10];
    unreadLabel.layer.cornerRadius = unreadLabel.width / 2;
    unreadLabel.clipsToBounds = YES;
    
    if (redPointCount < 100) {
        unreadLabel.text = [NSString stringWithFormat:@"%d", redPointCount];
    }else {
        unreadLabel.text = @"99+";
    }
    
    [self addSubview:unreadLabel];
}

- (void)hideBadgeOnItemIndex:(int)index{
    
    [self removeBadgeOnItemIndex:index];
    
}

- (void)removeBadgeOnItemIndex:(int)index{
    
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 888+index) {
            
            [subView removeFromSuperview];
            
        }
    }
}



@end
