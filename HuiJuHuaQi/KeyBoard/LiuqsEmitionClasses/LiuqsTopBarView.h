//
//  LiuqsTopBarView.h
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/12.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQAdviceTextView.h"

@protocol LiuqsTopBarViewDelegate <NSObject>


@optional
/*
 * 代理方法，点击表情按钮触发方法
 */
- (void)TopBarEmotionBtnDidClicked:(UIButton *)emotionBtn;

/*
 * 代理方法，点击加号按钮触发方法
 */
- (void)TopBarAddBtnDidClicked:(UIButton *)addBtn;

/*
 * 代理方法，点击语音按钮触发方法
 */
- (void)TopBarVoiceBtnDidClicked:(UIButton *)voiceBtn;

/*
 * 代理方法 ，点击数字键盘发送的事件
 */
- (void)sendAction;
/*
 * 键盘改变刷新父视图
 */
- (void)needUpdateSuperView;

- (void)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (void)textViewDidEndEditing:(UITextView *)textView;

- (BOOL)textViewShouldEndEditing:(UITextView *)textView;

- (void)textViewDidChange:(UITextView *)textView;
/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction;
/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction;
/**
 *  松开手指完成录音
 */
- (void)didFinishRecordingVoiceAction;
/**
 *  当手指离开按钮的范围内时，主要为了通知外部的HUD
 */
- (void)didDragOutsideAction;
/**
 *  当手指再次进入按钮的范围内时，主要也是为了通知外部的HUD
 */
- (void)didDragInsideAction;


@end

@interface LiuqsTopBarView : UIView
/*
 * topbar代理
 */
@property(assign,nonatomic)id <LiuqsTopBarViewDelegate> delegate;
/*
 * topbar上面的输入框
 */
@property(strong,nonatomic)HQAdviceTextView *textView;
/*
 * 表情按钮
 */
@property(nonatomic, strong) UIButton *topBarEmotionBtn;
/*
 * 语音按钮
 */
@property(nonatomic, strong) UIButton *topBarVoiceBtn;

/**
 *  开始录音button
 */
@property (strong, nonatomic) UIButton *startRecordButton;

/*
 * 加号按钮
 */
@property(nonatomic, strong) UIButton *topBarAddBtn;

/*
 * 当前键盘的高度， 区分是文字键盘还是表情键盘
 */
@property(nonatomic, assign) CGFloat CurrentKeyBoardH;
/*
 * 用于主动触发输入框改变的方法
 */
- (void)resetSubsives;


@end
