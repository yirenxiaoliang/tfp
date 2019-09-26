//
//  HQTabBar.h
//  HuiJuHuaQi
//
//  Created by hq001 on 15/12/24.
//  Copyright © 2015年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQTabBar;

@protocol HQTabBarDelegate <UITabBarDelegate>
@optional

- (void)tabBar:(HQTabBar *)tabBar DidClickedPlusButton:(UIButton *)plusButton;

-(void)setIsHidden:(BOOL)isHidden;

@end
@interface HQTabBar : UITabBar
@property (nonatomic , weak) id <HQTabBarDelegate> delegateTwo;
@end
