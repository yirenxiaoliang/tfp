//
//  TFSubformAddView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/30.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFSubformAddView;
@protocol TFSubformAddViewDelegate <NSObject>

@optional
-(void)subformAddView:(TFSubformAddView *)subformAddView didClickedAddBtn:(UIButton *)button;

@end


@interface TFSubformAddView : UIView


/** deleteBtn */
@property (nonatomic, weak) UIButton *addBtn;


+(instancetype)subformAddView;

/** delegate */
@property (nonatomic, weak) id <TFSubformAddViewDelegate>delegate;



@end
