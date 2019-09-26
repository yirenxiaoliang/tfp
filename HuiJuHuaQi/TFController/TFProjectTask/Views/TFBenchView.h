//
//  TFBenchView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/28.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFProjectSectionModel.h"
@class TFBenchView;

typedef NS_ENUM(NSUInteger, TFMoveViewScrollDirection) {
    TFMoveViewScrollDirectionNone = 0,
    TFMoveViewScrollDirectionLeft,
    TFMoveViewScrollDirectionRight,
    TFMoveViewScrollDirectionUp,
    TFMoveViewScrollDirectionDown,
};


@protocol TFBenchViewDelegate <NSObject>

@optional
/** 数据改变 */
-(void)moveViewWillMoing;
/** 数据改变 */
-(void)moveView:(TFBenchView *)moveView dataChanged:(NSArray *)models destinationIndex:(NSInteger)destinationIndex;
/** 数据改变 */
-(void)moveView:(TFBenchView *)moveView dataChanged:(NSArray *)models destinationIndex:(NSInteger)destinationIndex moveModel:(id)moveModel;
/** 切换page */
-(void)moveView:(TFBenchView *)moveView changePage:(NSInteger)page;
/** 点击 */
-(void)moveView:(TFBenchView *)moveView didClickedItem:(id)model;
/** 滚动 */
-(void)moveView:(TFBenchView *)moveView scrollView:(UIScrollView *)scrollView;
/** 停止滚动 */
-(void)moveView:(TFBenchView *)moveView didEndScrolloWithScrollView:(UIScrollView *)scrollView;
/** 删除一行 */
-(void)moveView:(TFBenchView *)moveView didMinusBtn:(UIButton *)button models:(NSMutableArray *)models;
/** 点击完成 */
-(void)moveView:(TFBenchView *)moveView didClickedFinishItem:(id)model;

@end
@interface TFBenchView : UIView

/** 初始化 0:时间工作流 1:企业工作流  */
-(void)refreshMoveViewWithModels:(NSMutableArray *)models withType:(NSInteger)type;
/** 初始化 0:时间工作流 1:企业工作流  */
@property (nonatomic, assign) NSInteger type;
/** 刷新 */
- (void)refreshData;
/** 加载全部数据 */
- (void)loadAllData;
/** 加载某列数据 */
- (void)loadDataWithSectionModel:(TFProjectSectionModel *)section index:(NSInteger)index;

/** delegate */
@property (nonatomic, weak) id <TFBenchViewDelegate>delegate;

/** selectPage */
@property (nonatomic, assign) NSInteger selectPage;
@end
