//
//  TFWorkSheetView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/10/31.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TFWorkSheetView;
@protocol TFWorkSheetViewDelegate <NSObject>

@optional
-(void)workSheetViewDidClickedHeader:(TFWorkSheetView *)workSheet;
-(void)workSheetView:(TFWorkSheetView *)workSheet panBeginWithPoint:(CGPoint)point;
-(void)workSheetView:(TFWorkSheetView *)workSheet panChangeWithPoint:(CGPoint)point;
-(void)workSheetView:(TFWorkSheetView *)workSheet panEndWithPoint:(CGPoint)point;
/** 点击 */
-(void)workSheet:(TFWorkSheetView *)workSheet didClickedItem:(id)model;
/** 点击完成 */
-(void)workSheet:(TFWorkSheetView *)workSheet didClickedFinishItem:(id)model;
/** 任务数量变化 */
-(void)workSheet:(TFWorkSheetView *)workSheet taskCount:(NSInteger)taskCount;

@end

@interface TFWorkSheetView : UIView


- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, weak) id delegate;

@property (nonatomic, assign) NSInteger taskCount;

/** 刷新 */
- (void)refreshData;

/** 加载数据 */
- (void)loadDataMemberIds:(NSString *)memberIds;


@end

NS_ASSUME_NONNULL_END
