//
//  TFNoteTextView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//


@class TFNoteTextView;

@protocol TFNoteTextViewDelegate <NSObject>

@optional
- (void)noteTextView:(TFNoteTextView *)noteTextView didCheckBtnWithCheck:(NSInteger)check;

@end


@interface TFNoteTextView : UITextView

/** type 0:文字 1：图片 */
@property (nonatomic, assign) NSInteger type;
/** num 0:无编号  1，2.... 编号的序号 */
@property (nonatomic, assign) NSInteger num;
/** check 0：无待办  1：有待办 2：待办完成 */
@property (nonatomic, assign) NSInteger check;


@property (nonatomic, weak) id <TFNoteTextViewDelegate>noteDelegate;


@end
