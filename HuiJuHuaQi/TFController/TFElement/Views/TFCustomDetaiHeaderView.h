//
//  TFCustomDetaiHeaderView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/12.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFCustomDetaiHeaderView : UIView

/** logo */
@property (nonatomic, weak) UIImageView *logo;

/** titleLabel */
@property (nonatomic, weak) UILabel *titleLabel;
+(instancetype)customDetaiHeaderView;

/** title */
@property (nonatomic, copy) NSString *title;

/** titleCenterX */
@property (nonatomic, assign) CGFloat titleCenterX;


@end
