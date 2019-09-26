//
//  TFCustomAlertView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFCustomAlertViewDelegate <NSObject>

@optional
- (void)sureClickedWithOptions:(NSMutableArray *)options;
@end

@interface TFCustomAlertView : UIView

@property (nonatomic, assign) BOOL isSingle;

/** 出现动画 */
-(void)showAnimation;

/** 刷新 */
- (void)refreshCustomAlertViewWithData:(NSArray *)datas;

@property (nonatomic, weak) id <TFCustomAlertViewDelegate>delegate;

@end
