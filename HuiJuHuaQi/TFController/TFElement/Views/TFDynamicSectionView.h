//
//  TFDynamicSectionView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/9/6.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFDynamicSectionView : UIView

- (instancetype)initWithFrame:(CGRect)frame date:(long long)timeSp;

/** 时间戳 */
@property (nonatomic, assign) long long timeSp;

@end
