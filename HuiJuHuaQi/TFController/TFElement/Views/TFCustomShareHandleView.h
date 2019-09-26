//
//  TFCustomShareHandleView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/12.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TFCustomShareHandleViewDelegate <NSObject>

@optional
-(void)customShareHandleViewDidClickedDeleteBtn:(UIButton *)deleteBtn;
-(void)customShareHandleViewDidClickedEditBtn:(UIButton *)editBtn;

@end


@interface TFCustomShareHandleView : UIView

/** deleteBtn */
@property (nonatomic, weak) UIButton *deleteBtn;
/** editBtn */
@property (nonatomic, weak) UIButton *editBtn;

+(instancetype)customShareHandleView;

/** delegate */
@property (nonatomic, weak) id <TFCustomShareHandleViewDelegate>delegate;

@end
