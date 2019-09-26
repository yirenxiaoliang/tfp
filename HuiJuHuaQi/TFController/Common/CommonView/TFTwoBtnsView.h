//
//  TFTwoBtnsView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/12.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFTwoBtnsModel.h"


@class TFTwoBtnsView;
@protocol TFTwoBtnsViewDelegate <NSObject>

@optional
- (void)twoBtnsView:(TFTwoBtnsView *)twoBtnsView didSelectIndex:(NSInteger)index;
- (void)twoBtnsView:(TFTwoBtnsView *)twoBtnsView didSelectModel:(TFTwoBtnsModel *)model;

@end

@interface TFTwoBtnsView : UIView

/** 初始化方法
 *  @pragma titles 存放Model数组
 */
-(instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray<TFTwoBtnsModel> *)titles;
/** 初始化方法
 *  @pragma titles 存放Model数组
 */
-(instancetype)initWithFrame:(CGRect)frame withTitles1:(NSArray<TFTwoBtnsModel> *)titles;

-(instancetype)initWithFrame:(CGRect)frame withImages:(NSArray<TFTwoBtnsModel> *)images;

/** 既可设置文字，也可设置图片 */
-(instancetype)initWithFrame:(CGRect)frame withModels:(NSArray<TFTwoBtnsModel> *)models;

/** delegate */
@property (nonatomic, weak) id <TFTwoBtnsViewDelegate>delegate;

@end
