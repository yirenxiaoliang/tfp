//
//  HQMainSliderView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/1.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPTabBar.h"

@interface HQMainSliderView : UIView

/** tabBar */
@property (nonatomic, strong) YPTabBar *tabBar;

-(void)refreshSliderViewWithFinishTask:(NSInteger)finishTask totalTask:(NSInteger)totalTask;

@end
