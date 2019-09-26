//
//  TFSliderCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFSliderItem : NSObject

/** 背景颜色 */
@property (nonatomic, strong) UIColor *bgColor;
/** 名字 */
@property (nonatomic, copy) NSString *name;
/** 二次确认 0:不需要 1：需要 */
@property (nonatomic, assign) NSInteger confirm;

@end


@protocol TFSliderCellDelegate <NSObject>

@optional
/** 点击了哪个item */
-(void)sliderCellDidClickedIndex:(NSInteger)index;
/** 点击cell */
-(void)sliderCellSelectedIndexPath:(NSIndexPath *)indexPath;
/** cell将要右滑 */
-(void)sliderCellWillScrollIndexPath:(NSIndexPath *)indexPath;

@end

@interface TFSliderCell : HQBaseCell

@property (nonatomic, assign,readonly) BOOL isSlider;

/** UIScrollView *scrollView */
@property (nonatomic, weak) UIScrollView *scrollView ;
/** 存放子控件 */
@property (nonatomic, weak) UIView *bgView;

/** indexPath */
@property (nonatomic, strong) NSIndexPath *indexPath;


+ (instancetype)sliderCellWithTableView:(UITableView *)tableView;

/** delegate */
@property (nonatomic, weak) id <TFSliderCellDelegate>delegate;

/** 刷新左滑Items */
- (void)refreshSliderCellItemsWithItems:(NSArray <TFSliderItem *>*)items;
/** 隐藏item */
- (void)hiddenItem;

@end
