//
//  TFBoardView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFBoardView,TFProjectSectionModel,TFProjectRowModel;
typedef NS_ENUM(NSUInteger, TFMoveViewScrollDirection) {
    TFMoveViewScrollDirectionNone = 0,
    TFMoveViewScrollDirectionLeft,
    TFMoveViewScrollDirectionRight,
    TFMoveViewScrollDirectionUp,
    TFMoveViewScrollDirectionDown,
};

@protocol TFBoardViewDelegate <NSObject>

@optional
/** 数据改变 */
-(void)boardViewWillMoing;
/** 数据改变(拖拽列) */
-(void)boardView:(TFBoardView *)boardView dataChanged:(NSArray *)models destinationIndex:(NSInteger)destinationIndex;
/** 数据改变(拖拽任务) */
-(void)boardView:(TFBoardView *)boardView dataChanged:(NSArray *)models destinationIndex:(NSInteger)destinationIndex originalIndex:(NSInteger)originalIndex moveTask:(TFProjectRowModel *)moveTask;
/** 切换page */
-(void)boardView:(TFBoardView *)boardView changePage:(NSInteger)page;
/** 点击完成 */
-(void)boardView:(TFBoardView *)boardView didClickedFinishItem:(id)model;
/** 点击 */
-(void)boardView:(TFBoardView *)boardView didClickedItem:(id)model;
/** 滚动 */
-(void)boardView:(TFBoardView *)boardView scrollView:(UIScrollView *)scrollView;
/** 任务列菜单 */
-(void)boardView:(TFBoardView *)boardView didMenuWithModel:(TFProjectSectionModel *)model menus:(NSArray *)menus;
/** 任务列新建 */
-(void)boardViewDidTaskRow;
/** 在某任务列新建任务 */
-(void)boardView:(TFBoardView *)boardView addTaskWithModel:(TFProjectSectionModel *)model;

@end
@interface TFBoardView : UIView

/** isPreview */
@property (nonatomic, assign) BOOL isPreview;


/** 初始化 type 0:可移动可添加列 1:可移动不可添加列 2:不可移动不可添加列 */
-(void)refreshMoveViewWithModels:(NSArray *)models withType:(NSInteger)type;
/** 刷新 */
- (void)refreshData;
/** 加载全部数据 */
- (void)loadAllData;

/** delegate */
@property (nonatomic, weak) id <TFBoardViewDelegate>delegate;

/** selectPage */
@property (nonatomic, assign) NSInteger selectPage;

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;
/** 模板ID */
@property (nonatomic, strong) NSNumber *temp_id;


/** 加载某列数据 */
- (void)loadDataWithSectionModel:(TFProjectSectionModel *)section index:(NSInteger)index;

/** type 0:可移动可添加列 1:可移动不可添加列 2:不可移动不可添加列 */
@property (nonatomic, assign) NSInteger type;

/** viewHeight */
@property (nonatomic, assign) CGFloat viewHeight;



@end
