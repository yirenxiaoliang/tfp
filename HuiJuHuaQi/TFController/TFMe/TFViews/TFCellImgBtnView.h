//
//  TFCellImgBtnView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/7/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TFCellImgBtnView;

@protocol TFCellImgBtnViewDelegate <NSObject>

- (void)cellImgBtnView:(TFCellImgBtnView *)cellImgBtnView btnClicked :(NSInteger)index;

@end


@interface TFCellImgBtnView : UIView

- (instancetype)initWithimgBtnViewFrame:(CGRect)frame labs:(NSArray *)labes image:(NSArray *)images textFont:(UIFont *)font textColor:(UIColor *)textColor;

@property (nonatomic, strong) NSArray *labs;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *lab;

@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, strong) UIColor *textColor;

/** delegate */
@property (nonatomic, weak) id <TFCellImgBtnViewDelegate>delegate;

@end
