//
//  TFDownloadingView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFDownloadingView : UIView

@property (nonatomic, strong) UILabel *loadLab;

@property (nonatomic, strong) UIProgressView *progressView;

- (instancetype)initWithFrame:(CGRect)frame;

@end
