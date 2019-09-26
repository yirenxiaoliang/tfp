//
//  LiuqsTopBarView.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/12.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "LiuqsTopBarView.h"
#import "JCHATAudioPlayerHelper.h"
#import "JCHATRecordAnimationView.h"


#define maxHeight 90

@interface LiuqsTopBarView () <UITextViewDelegate>


@property(nonatomic, strong) UIView *topLine;

@property(nonatomic, strong) UIView *bottomLine;




/**
 *  录音动画视图
 */
@property (strong, nonatomic) JCHATRecordAnimationView *recordAnimationView;


@end

@implementation LiuqsTopBarView

#pragma mark ==== 懒加载控件 ====
- (HQAdviceTextView *)textView {

    if (!_textView) {
        _textView = [[HQAdviceTextView alloc]init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.cornerRadius = 5;
        _textView.layer.borderWidth = 0.5f;
        _textView.layer.borderColor = ColorRGB(215, 215, 225).CGColor;
        _textView.scrollEnabled = YES;
        _textView.frame = CGRectMake(emotionBtnW + 10, 5, TextViewW, TextViewH);
        self.textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:17.0f];
        [_textView scrollRangeToVisible:NSMakeRange(_textView.text.length, 1)];
    }
    return _textView;
}

- (UIView *)bottomLine {

    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = ColorRGB(215, 215, 225);
    }
    return _bottomLine;
}

- (UIView *)topLine {

    if (!_topLine) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = ColorRGB(215, 215, 225);
    }
    return _topLine;
}

- (UIButton *)topBarEmotionBtn {

    if (!_topBarEmotionBtn) {
        _topBarEmotionBtn = [[UIButton alloc]init];
        [_topBarEmotionBtn setImage:[UIImage imageNamed:@"表情"] forState:UIControlStateNormal];
        [_topBarEmotionBtn setImage:[UIImage imageNamed:@"键盘2"] forState:UIControlStateSelected];
        [_topBarEmotionBtn addTarget:self action:@selector(emotionBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBarEmotionBtn;
}
- (UIButton *)topBarAddBtn {
    
    if (!_topBarAddBtn) {
        _topBarAddBtn = [[UIButton alloc]init];
        [_topBarAddBtn setImage:[UIImage imageNamed:@"group_topic_add"] forState:UIControlStateNormal];
        [_topBarAddBtn setImage:[UIImage imageNamed:@"group_topic_add"] forState:UIControlStateSelected];
        [_topBarAddBtn addTarget:self action:@selector(addBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBarAddBtn;
}

- (UIButton *)topBarVoiceBtn {
    
    if (!_topBarVoiceBtn) {
        _topBarVoiceBtn = [[UIButton alloc]init];
        [_topBarVoiceBtn setImage:[UIImage imageNamed:@"group_topic_voice"] forState:UIControlStateNormal];
        [_topBarVoiceBtn setImage:[UIImage imageNamed:@"键盘2"] forState:UIControlStateSelected];
        [_topBarVoiceBtn addTarget:self action:@selector(voiceBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBarVoiceBtn;
}

- (UIButton *)startRecordButton{
    if (!_startRecordButton) {
        _startRecordButton = [[UIButton alloc]init];
        [_startRecordButton setTitleColor:ColorRGB(0x4a, 0x4a, 0x4a) forState:UIControlStateNormal];
        [_startRecordButton setTitleColor:ColorRGB(0x4a, 0x4a, 0x4a) forState:UIControlStateHighlighted];
        [_startRecordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_startRecordButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        _startRecordButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [_startRecordButton setBackgroundImage:[self createImageWithColor:ColorRGB(0xf2, 0xf2, 0xf2) size:(CGSize){1,1}] forState:UIControlStateNormal];
        [_startRecordButton setBackgroundImage:[self createImageWithColor:ColorRGB(0xf2, 0xf2, 0xf2) size:(CGSize){1,1}] forState:UIControlStateHighlighted];
        
        [_startRecordButton addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_startRecordButton addTarget:self action:@selector(holdDownButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [_startRecordButton addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_startRecordButton addTarget:self action:@selector(holdDownDragOutside) forControlEvents:UIControlEventTouchDragExit];
        [_startRecordButton addTarget:self action:@selector(holdDownDragInside) forControlEvents:UIControlEventTouchDragEnter];
        [_startRecordButton setHidden:YES];
        [self addSubview:_startRecordButton];
        _startRecordButton.layer.cornerRadius = 4;
        _startRecordButton.layer.masksToBounds = YES;
        _startRecordButton.layer.borderWidth = 0.5;
        _startRecordButton.layer.borderColor = ColorRGB(0xc8, 0xc8, 0xc8).CGColor;
        _startRecordButton.hidden = YES;
    }
    return _startRecordButton;
}

-(JCHATRecordAnimationView *)recordAnimationView{
    
    if (!_recordAnimationView) {
        
        UIWindow *window =(UIWindow *)[UIApplication sharedApplication].keyWindow;
        _recordAnimationView=[[JCHATRecordAnimationView alloc]initWithFrame:CGRectMake((screenW-140)/2, (screenH -64 - 49 - 140)/2, 140, 140)];
        [window addSubview:_recordAnimationView];
    }
    return _recordAnimationView;
}


- (void)holdDownButtonTouchDown {
    if ([self.delegate respondsToSelector:@selector(didStartRecordingVoiceAction)]) {
        [[JCHATAudioPlayerHelper shareInstance] stopAudio];
        [self.delegate didStartRecordingVoiceAction];
    }
}

- (void)holdDownButtonTouchUpOutside {
    if ([self.delegate respondsToSelector:@selector(didCancelRecordingVoiceAction)]) {
        [self.delegate didCancelRecordingVoiceAction];
    }
}

- (void)holdDownButtonTouchUpInside {
    if ([self.delegate respondsToSelector:@selector(didFinishRecordingVoiceAction)]) {
        [self.delegate didFinishRecordingVoiceAction];
    }
}

- (void)holdDownDragOutside {
    if ([self.delegate respondsToSelector:@selector(didDragOutsideAction)]) {
        [self.delegate didDragOutsideAction];
    }
}

- (void)holdDownDragInside {
    if ([self.delegate respondsToSelector:@selector(didDragInsideAction)]) {
        [self.delegate didDragInsideAction];
    }
}

- (void)levelMeterChanged:(float)levelMeter{
    [self.recordAnimationView changeanimation:levelMeter];
}

- (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}



//构造方法
- (instancetype)init {
    
    self = [super init];
    if (self) {[self userMethod];}
    return self;
}

//自定义方法
- (void)userMethod {

    [self initSomething];
    [self addSubviews];
    [self layoutViews];
    
}

//初始化数据设置
- (void)initSomething {

    self.userInteractionEnabled = YES;
    self.backgroundColor = ColorRGB(236, 237, 241);
    self.CurrentKeyBoardH = keyBoardH;
}
//添加子视图
- (void)addSubviews {
    
    [self addSubview:self.textView];
    [self addSubview:self.topLine];
    [self addSubview:self.bottomLine];
    [self addSubview:self.topBarEmotionBtn];
    [self addSubview:self.topBarAddBtn];
    [self addSubview:self.topBarVoiceBtn];
    [self addSubview:self.startRecordButton];
}
//约束位置
- (void)layoutViews {
    
    self.frame = CGRectMake(0, screenH - TopM - topBarH, screenW, CGRectGetMaxY(self.textView.frame) + 5);
    self.bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, screenW, 0.5);
    self.topLine.frame = CGRectMake(0, 0, screenW, 0.5);
    self.topBarAddBtn.frame = CGRectMake(CGRectGetMaxX(self.frame) - 5 - emotionBtnW, CGRectGetHeight(self.frame) - 5 - emotionBtnH, emotionBtnW, emotionBtnH);
    self.topBarEmotionBtn.frame = CGRectMake(CGRectGetMinX(self.topBarAddBtn.frame)-emotionBtnW, CGRectGetHeight(self.frame) - 5 - emotionBtnH, emotionBtnW, emotionBtnH);
    self.topBarVoiceBtn.frame = CGRectMake(5, CGRectGetHeight(self.frame) - 5 - emotionBtnH, emotionBtnW, emotionBtnH);
    self.startRecordButton.frame = self.textView.frame;
}

//更新子视图
- (void)updateSubviews {

    CGFloat differenceH = self.textView.Ex_height - TextViewH;
    if (self.textView.isFirstResponder) {
        self.frame = CGRectMake(0, screenH - TopM - self.CurrentKeyBoardH - topBarH - differenceH, screenW, CGRectGetMaxY(self.textView.frame) + 5);
    }else{
        self.frame = CGRectMake(0, screenH - TopM -BottomM - self.CurrentKeyBoardH - topBarH - differenceH, screenW, CGRectGetMaxY(self.textView.frame) + 5);
    }
    self.bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, screenW, 0.5);
    self.topLine.frame = CGRectMake(0, 0, screenW, 0.5);
    self.topBarAddBtn.frame = CGRectMake(CGRectGetMaxX(self.frame) - 5 - emotionBtnW, CGRectGetHeight(self.frame) - 5 - emotionBtnH, emotionBtnW, emotionBtnH);
    self.topBarEmotionBtn.frame = CGRectMake(CGRectGetMinX(self.topBarAddBtn.frame)-emotionBtnW, CGRectGetHeight(self.frame) - 5 - emotionBtnH, emotionBtnW, emotionBtnH);
    self.topBarVoiceBtn.frame = CGRectMake(5, CGRectGetHeight(self.frame) - 5 - emotionBtnH, emotionBtnW, emotionBtnH);
    self.startRecordButton.frame = self.textView.frame;
    
    if ([self.delegate respondsToSelector:@selector(needUpdateSuperView)]) {
        [self.delegate needUpdateSuperView];
    }
}

#pragma mark === 事件 ====
/** 点击表情按钮 */
- (void)emotionBtnDidClicked:(UIButton *)emotionBtn {
    
    if ([self.delegate respondsToSelector:@selector(TopBarEmotionBtnDidClicked:)]) {
        [self.delegate TopBarEmotionBtnDidClicked:emotionBtn];
    }
}

/** 点击加号按钮 */
- (void)addBtnDidClicked:(UIButton *)addBtn{
    
    if ([self.delegate respondsToSelector:@selector(TopBarAddBtnDidClicked:)]) {
        [self.delegate TopBarAddBtnDidClicked:addBtn];
    }
    
}

/** 点击语音按钮 */
- (void)voiceBtnDidClicked:(UIButton *)voiceBtn{
    
    if ([self.delegate respondsToSelector:@selector(TopBarVoiceBtnDidClicked:)]) {
        [self.delegate TopBarVoiceBtnDidClicked:voiceBtn];
    }
    
}



//共有方法，用于主动触发键盘改变的方法
- (void)resetSubsives {

    [self textViewDidChange:self.textView];
}

#pragma mark ==== textView代理方法 ====

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(sendAction)]) {
            [self.delegate sendAction];
        }
        return NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        [self.delegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

//监听键盘改变，重设控件frame
- (void)textViewDidChange:(UITextView *)textView {
    
    CGFloat width   = CGRectGetWidth(textView.frame);
    CGSize newSize  = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    CGRect newFrame = textView.frame;
    CGRect maxFrame = textView.frame;
    maxFrame.size   = CGSizeMake(width, maxHeight);
    newFrame.size   = CGSizeMake(width, newSize.height);
    [UIView animateWithDuration:0.25 animations:^{
        if (newSize.height <= maxHeight) {
            
            textView.frame  = newFrame;
            textView.scrollEnabled = NO;
        }else {
            
            textView.frame = maxFrame;
            textView.scrollEnabled = YES;
        }
        [self updateSubviews];
    }];
    
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:textView];
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {

    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        
        [self.delegate textViewDidEndEditing:textView];
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {

    if ([self.delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        
        [self.delegate textViewShouldEndEditing:textView];
    }
    return YES;
}

@end
