//
//  TFAllSelectView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFAllSelectViewDelegate <NSObject>

@optional
-(void)allSelectViewDidClickedAllSelectBtn:(UIButton *)selectBtn;
-(void)allSelectViewDidClickedSelectSubBtn:(UIButton *)selectBtn;

@end

@interface TFAllSelectView : UIView

/** delegate */
@property (nonatomic, weak) id <TFAllSelectViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectSub;

+ (instancetype)allSelectView;

@end
