//
//  TFMoveView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFMoveView;
typedef NS_ENUM(NSUInteger, TFMoveViewScrollDirection) {
    TFMoveViewScrollDirectionNone = 0,
    TFMoveViewScrollDirectionLeft,
    TFMoveViewScrollDirectionRight,
    TFMoveViewScrollDirectionUp,
    TFMoveViewScrollDirectionDown,
};


@protocol TFMoveViewDelegate <NSObject>

@optional
/** 数据改变 */
-(void)moveViewWillMoing;
/** 数据改变 */
-(void)moveView:(TFMoveView *)moveView dataChanged:(NSArray *)models destinationIndex:(NSInteger)destinationIndex;
/** 切换page */
-(void)moveView:(TFMoveView *)moveView changePage:(NSInteger)page;
/** 点击 */
-(void)moveView:(TFMoveView *)moveView didClickedItem:(id)model;
/** 滚动 */
-(void)moveView:(TFMoveView *)moveView scrollView:(UIScrollView *)scrollView;
/** 删除一行 */
-(void)moveView:(TFMoveView *)moveView didMinusBtn:(UIButton *)button models:(NSMutableArray *)models;

@end

@interface TFMoveView : UIView

/** 初始化 0:任务的移动 1:任务分类及任务列的移动 2:工作台的移动 */
-(void)refreshMoveViewWithModels:(NSMutableArray *)models withType:(NSInteger)type;
/** 刷新 */
- (void)refreshData;

/** delegate */
@property (nonatomic, weak) id <TFMoveViewDelegate>delegate;

/** selectPage */
@property (nonatomic, assign) NSInteger selectPage;


@end
