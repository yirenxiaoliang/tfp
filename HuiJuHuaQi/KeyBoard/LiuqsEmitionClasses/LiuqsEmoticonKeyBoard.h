//
//  LiuqsEmoticonView.h
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/3.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiuqsTopBarView.h"
#import "HQAdviceTextView.h"

@protocol LiuqsEmotionKeyBoardDelegate <NSObject>

@optional
/*
 * 发送按钮的代理事件
 * 参数PlainStr: 转码后的textView的普通字符串
 */
- (void)sendButtonEventsWithPlainString:(NSString *)PlainStr;

/**
 * 发送语音代理事件
 * 参数voicePath: 语音文件路径
 * 参数voiceDuration: 语音时长
 *
 */
- (void)sendVoiceWithVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration;

/**
 * 发送加号里的内容
 * 参数index: 第几个图标
 *
 */
- (void)sendAddItemContentWithIndex:(NSInteger)index;


/*
 * 代理方法：键盘改变的代理事件
 * 用来更新父视图的UI，比如跟随键盘改变的列表高度
 */
- (void)keyBoardChanged;

- (void)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (void)textViewDidEndEditing:(UITextView *)textView;

- (BOOL)textViewShouldEndEditing:(UITextView *)textView;

-(void)textViewDidChange:(UITextView *)textView;

-(void)recordStarting;

- (void)cancelStarting;

@end

@interface LiuqsEmoticonKeyBoard : UIView
/*
 * 输入框，和topbar上的是同一个输入框
 */
@property(nonatomic, strong) HQAdviceTextView *textView;
/*
 * 顶部输入条
 */
@property(nonatomic, strong) LiuqsTopBarView *topBar;
/* 
 * 输入框字体，用来计算表情的大小
 */
@property(nonatomic, strong) UIFont *font;
/*
 * 键盘的代理
 */
@property(nonatomic, weak) id <LiuqsEmotionKeyBoardDelegate> delegate;
/*
 * 收起键盘的方法
 */
- (void)hideKeyBoard;
/** 键盘弹出 */
- (void)handleKeyBoardShow:(CGRect)frame;
/*
 * 初始化方法
 * 参数view必须传入控制器的视图
 * 会返回一个键盘的对象
 * 默认是给17号字体
 *
 * type 0:4种（拍照、相册、视频、文件）1：0:4种（拍照、相册）
 */
+ (instancetype)showKeyBoardInView:(UIView *)view type:(NSInteger)type;


@end
