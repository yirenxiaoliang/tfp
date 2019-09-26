//
//  FSSegment.h
//  BaseProject
//
//  Created by luyuan on 16/4/26.
//  Copyright © 2016年 soonking. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSSegment : UIView

// 标题数组
@property(nonatomic,strong) NSArray *titles;

// 标题未选中颜色
@property(nonatomic,strong) UIColor *normalTitleColor;

// 标题选中颜色
@property(nonatomic,strong) UIColor *selectedTitleColor;

// 选中索引
@property(nonatomic,assign) NSInteger selectedIndex;

// 选中事件
@property(nonatomic,copy) void (^block)(NSInteger selectedIndex);

/**
 *  初始化
 *
 *  @param frame              frame
 *  @param titles             标题数组
 *  @param normalTitleColor   标题未选中颜色
 *  @param selectedTitleColor 标题选中颜色
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titles NormalTitleColor:(UIColor *)normalTitleColor SelectedTitleColor:(UIColor *)selectedTitleColor;

/**
 *  初始化
 *
 *  @param frame  frame
 *  @param titles 标题数组
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titles;
@end
