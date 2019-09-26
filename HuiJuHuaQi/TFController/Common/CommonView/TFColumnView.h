//
//  TFColumnView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/6.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TFColumnView;
@protocol TFColumnViewDelegate <NSObject>

@optional
-(void)columnView:(TFColumnView *)columnView isSpread:(NSString *)isSpread;

@end

@interface TFColumnView : UIView

/** titleLebel */
@property (nonatomic, weak) UILabel *titleLebel;
/** spreadBtn */
@property (nonatomic, weak) UIButton *spreadBtn;
/** delegate */
@property (nonatomic, weak) id <TFColumnViewDelegate>delegate;
/** isSpread */
@property (nonatomic, copy) NSString *isSpread;

+ (instancetype)columnView;
@end
