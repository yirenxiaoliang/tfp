//
//  HQBaseViewController.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/13.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UIViewController+HUD.h"
#import "MBProgressHUD+Add.h"
#import "LCProgressHUD.h"
#import <AVFoundation/AVFoundation.h>

@interface HQBaseViewController : UIViewController

/**
 用了自定义的手势返回，则系统的手势返回屏蔽
 不用自定义的手势返回，则系统的手势返回启用
 */
@property (nonatomic, assign) BOOL enablePanGesture;//是否支持自定义拖动pop手势，默认yes,支持手势


/** vcTag */
@property (nonatomic, assign) NSInteger vcTag;


@property (nonatomic, weak) UIView *shadowLine;

/** 音频播放器 */
@property (nonatomic,strong)AVAudioPlayer *audioPlayer;


- (void)setFromNavBottomEdgeLayout;

/** 创建一个titleItem */
- (id)titleItemWithTitle:(NSString *)title color:(UIColor *)color imageName:(NSString *)imageName withTarget:(id)target action:(SEL)action;
//  创建一个item
- (id)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highlightImage:(NSString *)highlightImage;


- (id)itemWithTarget:(id)target action:(SEL)action text:(NSString *)text textColor:(UIColor *)textColor;


- (id)itemWithTarget:(id)target action:(SEL)action text:(NSString *)text;

// 创建一个图片＋文字的item(图片在左文字在右)
- (id)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image text:(NSString *)text;
- (id)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image text:(NSString *)text textColor:(UIColor *)color;

// 创建一个图片＋文字的item(图片在右文字在左)
- (id)itemWithTarget:(id)target action:(SEL)action rightimage:(NSString *)image lefttext:(NSString *)text;



- (UIView *)creatTableViewFootViewWithNum:(NSInteger)number;

- (UIView *)creatTableViewFootViewWithNum:(NSInteger)number title:(NSString *)title;


- (void)didBack:(UIButton *)sender;

@end
