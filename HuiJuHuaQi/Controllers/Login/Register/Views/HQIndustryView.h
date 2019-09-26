//
//  HQIndustryView.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/18.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureIndustryBlock)(id result);

@interface HQIndustryView : UIView

@property (nonatomic, copy) SureIndustryBlock sureIndustryBlock;

@property (nonatomic, assign) BOOL hideState;   //YES为隐藏

- (void)showView;

- (void)cancelView;

@end
