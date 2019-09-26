//
//  TFNoteView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/21.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TFNoteView,TFNoteModel;
@protocol TFNoteViewDelegate <NSObject>

@optional
/** 传值 */
-(void)noteView:(TFNoteView *)noteView noteItems:(NSArray *)noteItems;
/** 高度发生变化 */
-(void)noteView:(TFNoteView *)noteView changedHeight:(CGFloat)height;
/** 键盘点击的index事件 */
-(void)noteView:(TFNoteView *)noteView accessoryIndex:(NSInteger)index;
/** check点击事件 */
-(void)noteView:(TFNoteView *)noteView check:(NSInteger)index model:(TFNoteModel *)model;


@end

@interface TFNoteView : UIView

/** delegate */
@property (nonatomic, weak) id<TFNoteViewDelegate>delegate;

/* 刷新*/
-(void)refreshNoteViewWithNotes:(NSArray *)notes withType:(NSInteger)type;

- (void)didClickedPhoto;


@end
