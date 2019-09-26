//
//  TFChildTaskProgressView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFChildTaskProgressView : UIView

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
+ (instancetype)childTaskProgressView;

/** rate */
@property (nonatomic, assign) CGFloat rate;


@end
