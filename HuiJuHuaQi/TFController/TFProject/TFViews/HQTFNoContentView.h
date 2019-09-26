//
//  HQTFNoContentView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HQTFNoContentViewDelegate <NSObject>

@optional
- (void)noContentViewDidClickedButton;
@end

@interface HQTFNoContentView : UIView

/** tipText */
@property (nonatomic, copy) NSString *tipText;
/** delegate */
@property (nonatomic, weak) id <HQTFNoContentViewDelegate>delegate;

/** 有按钮 */
- (void)setupImageViewRect:(CGRect)imgRect imgImage:(NSString *)imgImage buttonImage:(NSString *)btnImage buttonWord:(NSString *)btnWord withTipWord:(NSString *)tipWord;

- (void)setupImageViewRect:(CGRect)imgRect imgImage:(NSString *)imgImage buttonWord:(NSString *)btnWord withTipWord:(NSString *)tipWord;

/** 无按钮 */
- (void)setupImageViewRect:(CGRect)imgRect imgImage:(NSString *)imgImage withTipWord:(NSString *)tipWord;

/** 无按钮有转圈 */
- (void)setupImageViewRect:(CGRect)imgRect imgImage:(NSString *)imgImage withTipWord:(NSString *)tipWord loadTip:(BOOL)loadTip;

+ (HQTFNoContentView *)noContentView;
@end
