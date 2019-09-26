//
//  TFCommentView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/19.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFCommentViewDelegate <NSObject>

@optional
-(void)commentViewDidClickedShareBtn:(UIButton *)button;
-(void)commentViewDidClickedGoodBtn:(UIButton *)button;
-(void)commentViewDidClickedCommentBtn:(UIButton *)button;

@end

@interface TFCommentView : UIView
/** 显示 */
- (void)show;
/** 消失 */
- (void)dismiss;

/** isGood */
@property (nonatomic, assign) BOOL good;

/** delegate */
@property (nonatomic, weak) id<TFCommentViewDelegate>delegate;

@end
