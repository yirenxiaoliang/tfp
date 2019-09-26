//
//  LiuqsEmoticonView.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2016/12/3.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "LiuqsEmoticonKeyBoard.h"
#import "LiuqsEmotionPageView.h"
#import "LiuqsTextAttachment.h"
#import "XHVoiceRecordHUD.h"
#import "XHVoiceRecordHelper.h"
#import "AddBackgroudView.h"

#define bottomBarH 40
#define sendBtnW 60
#define pages 4

@interface LiuqsEmoticonKeyBoard ()<UIScrollViewDelegate,LiuqsTopBarViewDelegate,AddBackgroudViewDelegate>

@property(nonatomic, strong) UIScrollView *baseView;

@property(nonatomic, strong) NSDictionary *emojiDict;

@property(nonatomic, strong) UIButton *sendButton;

@property(nonatomic, strong) UIScrollView *bottomBar;

@property(nonatomic, strong) UIPageControl *pageControl;

@property(nonatomic, strong) UIView *emotionBackgroudView;

/** AddBackgroudView */
@property (nonatomic, strong) AddBackgroudView *addBackgroudView;


//表情大小需要根据字体计算
@property(assign, nonatomic) CGFloat  emotionSize;
/*
 * 用来判断是否是仅取消文字键盘的第一响应,不处理控件的改变;
 * 只有在键盘切换时候赋值为yes，其他任何情况都是no;
 * 用来解决切换键盘闪动的问题
 */
@property(nonatomic, assign) BOOL onlyHideSysKboard;

/** 录音 */
@property(nonatomic, strong, readwrite) XHVoiceRecordHUD *voiceRecordHUD;

/**
 *  管理录音工具对象
 */
@property(nonatomic, strong) XHVoiceRecordHelper *voiceRecordHelper;

/** 来自maxFinish */
@property (nonatomic, assign) BOOL maxFinish;

/** type */
@property (nonatomic, assign) NSInteger type;

/** isRecord */
@property (nonatomic, assign) BOOL isRecord;
@end

@implementation LiuqsEmoticonKeyBoard

- (XHVoiceRecordHelper *)voiceRecordHelper {
    if (!_voiceRecordHelper) {
        __weak __typeof(self)weakSelf = self;
        _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
        
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            NSLog(@"已经达到最大限制时间了，进入下一步的提示");
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf finishRecorded];
            strongSelf.maxFinish = YES;
        };
        
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
        };
        
        _voiceRecordHelper.maxRecordTime = 60.0;
    }
    return _voiceRecordHelper;
}

- (XHVoiceRecordHUD *)voiceRecordHUD {
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _voiceRecordHUD;
}


#pragma mark ==== 懒加载 ====

//带输入框的那一条
- (LiuqsTopBarView *)topBar {

    if (!_topBar) {
        _topBar = [[LiuqsTopBarView alloc]init];
        _topBar.delegate = self;
        self.textView = _topBar.textView;
    }
    return _topBar;
}

- (UIPageControl *)pageControl {

    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.numberOfPages = pages;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl;
}
//底部表情分类条
- (UIScrollView *)bottomBar {

    if (!_bottomBar) {
        _bottomBar = [[UIScrollView alloc]init];
        _bottomBar.pagingEnabled = NO;
        _bottomBar.bounces = YES;
        _bottomBar.delegate = self;
        _bottomBar.showsHorizontalScrollIndicator = NO;
        _bottomBar.backgroundColor = ColorRGB(236, 237, 241);
    }
    return _bottomBar;
}
//存放表情图片的数组
- (NSDictionary *)emojiDict {

    if (!_emojiDict) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LiuqsEmotions" ofType:@"plist"];
        self.emojiDict = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _emojiDict;
}

//发送按钮
- (UIButton *)sendButton {

    if (!_sendButton) {
        _sendButton = [[UIButton alloc]init];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[UIImage createImageWithColor:ColorRGB(0, 186, 255)] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendButttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
//根视图（最底部滚动视图）
- (UIScrollView *)baseView {

    if (!_baseView) {
        _baseView = [[UIScrollView alloc]init];
        _baseView.pagingEnabled = YES;
        _baseView.bounces = NO;
        _baseView.delegate = self;
        _baseView.backgroundColor = WhiteColor;
        _baseView.showsHorizontalScrollIndicator = NO;
    }
    return _baseView;
}

- (UIView *)emotionBackgroudView{
    if (!_emotionBackgroudView) {
        _emotionBackgroudView = [[UIView alloc] init];
        _emotionBackgroudView.backgroundColor = WhiteColor;
    }
    return _emotionBackgroudView;
}

-(AddBackgroudView *)addBackgroudView{
    if (!_addBackgroudView) {
        _addBackgroudView = [[AddBackgroudView alloc] initWithType:self.type];
        _addBackgroudView.delegate1 = self;
    }
    return _addBackgroudView;
}
#pragma mark - AddBackgroudViewDelegate
-(void)addBackgroudView:(AddBackgroudView *)addBackgroudView didSelectIndex:(NSInteger)index{
    
    if ([self.delegate respondsToSelector:@selector(sendAddItemContentWithIndex:)]) {
        [self.delegate sendAddItemContentWithIndex:index];
    }
}

#pragma mark ==== 重载系统方法 ==== 
//构造方法
- (instancetype)initWithType:(NSInteger)type {

    if (self = [super init]){
        self.type = type;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRecoredMP3) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [self methods];
    }
    return self;
}

#pragma mark ==== 自定义方法 ====

- (void)stopRecoredMP3 {
    if (self.isRecord) {
        [self cancelRecord];
    }
}
+ (instancetype)showKeyBoardInView:(UIView *)view type:(NSInteger)type{

    if (!view) {return nil;}
    LiuqsEmoticonKeyBoard *keyboard = [[LiuqsEmoticonKeyBoard alloc]initWithType:type];
    
    [view addSubview:keyboard];
    [view addSubview:keyboard.topBar];
    
    HQLog(@"topBar==%@",NSStringFromCGRect(keyboard.topBar.frame));
    HQLog(@"keyboard==%@",NSStringFromCGRect(keyboard.frame));
    
    return keyboard;
}
- (void)methods {
    
    [self initSomeThing];
    [self configureSubViews];
    [self initSubViewFrames];
    [self creatPageViews];
    [self addNotifations];
}

- (void)hideKeyBoard {

    if (self.topBar.textView.isFirstResponder) {
        [self.topBar.textView resignFirstResponder];
    }
    [UIView animateWithDuration:keyBoardTipTime animations:^{
        self.topBar.Ex_y = screenH - self.topBar.Ex_height - TopM - BottomM;
        self.Ex_y = screenH - BottomM - TopM;
        self.topBar.topBarEmotionBtn.selected = NO;
        self.topBar.CurrentKeyBoardH = keyBoardH;
        [self UpdateSuperView];
    }];
    self.onlyHideSysKboard = NO;
    self.emotionBackgroudView.hidden = YES;
    self.addBackgroudView.hidden = YES;
}

//添加通知监听
- (void)addNotifations {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardWillShow:(NSNotification *)noti {
    
    if (self.textView.isFirstResponder) {
        
        NSDictionary *userInfo = noti.userInfo;
        NSValue *beginValue    = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
        NSValue *endValue      = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect beginFrame      = beginValue.CGRectValue;
        CGRect endFrame        = endValue.CGRectValue;
        self.topBar.CurrentKeyBoardH = endFrame.size.height;
        BOOL isNeedHandle = beginFrame.size.height > 0 && beginFrame.origin.y - endFrame.origin.y > 0;
        //处理键盘走多次
        if (isNeedHandle) {
            //处理键盘弹出
            [self handleKeyBoardShow:endFrame];
        }
    }
}

- (void)keyBoardWillHide:(NSNotification *)noti {
    
    self.topBar.CurrentKeyBoardH = keyBoardH;
    if (!self.onlyHideSysKboard) {
        [self hideKeyBoard];
    }
}

//更新父视图的UI（比如列表的高度）
- (void)UpdateSuperView {

    if ([self.delegate respondsToSelector:@selector(keyBoardChanged)]) {
        [self.delegate keyBoardChanged];
    }
}

//处理键盘弹出
- (void)handleKeyBoardShow:(CGRect)frame {
    
    self.topBar.topBarEmotionBtn.selected = NO;
    [UIView animateWithDuration:keyBoardTipTime animations:^{
        
        self.topBar.Ex_y = screenH - frame.size.height - self.topBar.Ex_height - TopM;
        self.Ex_y = screenH - keyBoardH - BottomM - TopM;
        [self UpdateSuperView];
    }];
}

//初始化参数
- (void)initSomeThing {
    
    if (!self.font) {self.font = [UIFont systemFontOfSize:17.0f];}
    _emotionSize = [self heightWithFont:self.font];
    self.userInteractionEnabled = YES;
    self.backgroundColor = BackGroudColor;
}
//配置子视图
- (void)configureSubViews {
    
    [self addSubview:self.emotionBackgroudView];
    [self addSubview:self.addBackgroudView];
    self.addBackgroudView.hidden = YES;
    self.emotionBackgroudView.hidden = YES;
    
    [self.emotionBackgroudView addSubview:self.baseView];
    [self.emotionBackgroudView addSubview:self.bottomBar];
    [self.emotionBackgroudView addSubview:self.sendButton];
    [self.emotionBackgroudView addSubview:self.pageControl];
}
- (void)initSubViewFrames {

    self.frame = CGRectMake(0, screenH-TopM-BottomM, screenW, keyBoardH);
    self.emotionBackgroudView.frame = CGRectMake(0, 0, screenW, keyBoardH);
    self.addBackgroudView.frame = CGRectMake(0, 0, screenW, keyBoardH);
    
    self.baseView.frame = CGRectMake(0, 0, screenW, rows * emotionW +(rows + 1) * pageH);
    self.baseView.contentSize = CGSizeMake(screenW * pages + 1, rows * emotionW +(rows + 1) * pageH);
    self.sendButton.frame = CGRectMake(screenW - sendBtnW, CGRectGetHeight(self.frame) - bottomBarH, sendBtnW, bottomBarH);
    self.bottomBar.frame = CGRectMake(0, CGRectGetHeight(self.frame) - bottomBarH, screenW - sendBtnW, bottomBarH);
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.baseView.frame) - 5, screenW, 10);
}

//根据页数（通过拥有的表情的个数除以每页表情数计算出来）创建pageView
- (void)creatPageViews {

    for (int i = 0; i < pages; i ++) {
        LiuqsEmotionPageView *pageView = [[LiuqsEmotionPageView alloc]init];
        pageView.page = i;
        [self.baseView addSubview:pageView];
        pageView.frame = CGRectMake(i * screenW, 0, screenW, rows * emotionW +(rows + 1) * pageH);
        __weak typeof (self) weakSelf = self;
        [pageView setDeleteButtonClick:^(LiuqsButton *deleteButton) {
            [weakSelf deleteBtnClick:deleteButton];
        }];
        [pageView setEmotionButtonClick:^(LiuqsButton *emotionButton) {
            [weakSelf insertEmoji:emotionButton];
        }];
    }
}

#pragma mark ==== 事件 ====
//发送按钮事件
- (void)sendButttonClick:(UIButton *)button {

    NSString *plainStr = [self.textView.attributedText getPlainString];
    if ([self.delegate respondsToSelector:@selector(sendButtonEventsWithPlainString:)]) {
        [self.delegate sendButtonEventsWithPlainString:plainStr];
    }
}

- (void)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        [self.delegate textView:textView shouldChangeTextInRange:range replacementText:text];
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

-(void)textViewDidChange:(UITextView *)textView{
    
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:textView];
    }
}


//删除按钮事件
- (void)deleteBtnClick:(LiuqsButton *)btn {
    
    [self.textView deleteBackward];
}

//点击表情时，插入图片到输入框
- (void)insertEmoji:(LiuqsButton *)btn {
    //创建附件
    LiuqsTextAttachment *emojiTextAttachment = [LiuqsTextAttachment new];
    NSString *emojiTag = [self getKeyForValue:btn.emotionName fromDict:self.emojiDict];
    emojiTextAttachment.emojiTag = emojiTag;
    //取到表情对应的表情
    NSString *imageName = btn.emotionName;
    //给附件设置图片
    emojiTextAttachment.image = [UIImage imageNamed:imageName];
    // 给附件设置尺寸
    emojiTextAttachment.bounds = CGRectMake(0, -4, _emotionSize, _emotionSize);
    //textview插入富文本，用创建的附件初始化富文本
    [_textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment] atIndex:_textView.selectedRange.location];
    _textView.selectedRange = NSMakeRange(_textView.selectedRange.location + 1, _textView.selectedRange.length);
    //重设输入框字体
    [self resetTextStyle];
}

- (void)resetTextStyle {
    
    NSRange wholeRange = NSMakeRange(0, _textView.textStorage.length);
    [_textView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [_textView.textStorage addAttribute:NSFontAttributeName value:self.font range:wholeRange];
    [self.textView scrollRectToVisible:CGRectMake(0, 0, _textView.contentSize.width, _textView.contentSize.height) animated:NO];
    //重新设置输入框视图的frame
    [self.topBar resetSubsives];
}

#pragma mark ==== topBar代理方法 ====

///代理方法，点击表情按钮触发方法
- (void)TopBarEmotionBtnDidClicked:(UIButton *)emotionBtn {
    
    self.addBackgroudView.hidden = YES;
    
    if (self.topBar.topBarAddBtn.selected) {
        
        self.emotionBackgroudView.frame = CGRectMake(0, keyBoardH, screenW, keyBoardH);
        
        [UIView animateWithDuration:0.35 animations:^{
            
            self.emotionBackgroudView.frame = CGRectMake(0, 0, screenW, keyBoardH);
            
        }];
        
        [self showEmotionKeyBorad];
        self.topBar.textView.hidden = NO;
        self.topBar.startRecordButton.hidden = YES;
        self.topBar.topBarVoiceBtn.selected = NO;
        self.topBar.topBarEmotionBtn.selected = YES;
        self.topBar.topBarAddBtn.selected = NO;
        [self UpdateSuperView];
        
    }else{
        
        if (emotionBtn.selected) {
            
            self.emotionBackgroudView.hidden = YES;
            [self showSystemKeyBoard];
            
        }else {
            [self showEmotionKeyBorad];
            
            self.topBar.textView.hidden = NO;
            self.topBar.startRecordButton.hidden = YES;
            self.topBar.topBarVoiceBtn.selected = NO;
        }
    }
    
}
/** 点击语音 */
-(void)TopBarVoiceBtnDidClicked:(UIButton *)voiceBtn{
   
    if (voiceBtn.selected) {
        
        self.topBar.textView.hidden = NO;
        self.topBar.startRecordButton.hidden = YES;
        
        self.onlyHideSysKboard = NO;
        if (!self.textView.isFirstResponder) {
            [self.textView becomeFirstResponder];
        }
        [UIView animateWithDuration:keyBoardTipTime animations:^{
            
            self.topBar.Ex_y = screenH - self.topBar.Ex_height - self.topBar.CurrentKeyBoardH - TopM;
            self.Ex_y = screenH - self.Ex_height - BottomM - TopM;
        }];
        
        self.topBar.topBarVoiceBtn.selected = NO;
        [self UpdateSuperView];
        
    }else {
        
        self.topBar.textView.hidden = YES;
        self.topBar.startRecordButton.hidden = NO;
        
        [self hideKeyBoard];
        
        self.topBar.topBarVoiceBtn.selected = YES;
        [self UpdateSuperView];
    }
    
}
/** 点击加号 */
-(void)TopBarAddBtnDidClicked:(UIButton *)addBtn{
    
    self.addBackgroudView.hidden = NO;
    self.emotionBackgroudView.hidden = YES;
    
    
    if (self.topBar.topBarEmotionBtn.selected) {
        
        self.addBackgroudView.frame = CGRectMake(0, keyBoardH, screenW, keyBoardH);
        
        [UIView animateWithDuration:0.35 animations:^{
            
            self.addBackgroudView.frame = CGRectMake(0, 0, screenW, keyBoardH);
            
        }];
        
        self.topBar.topBarEmotionBtn.selected = NO;
        self.topBar.topBarAddBtn.selected = YES;
        [self UpdateSuperView];
        
    }else{
        
        if (addBtn.selected) {
            
            self.onlyHideSysKboard = NO;
            if (!self.textView.isFirstResponder) {
                [self.textView becomeFirstResponder];
            }
            [UIView animateWithDuration:keyBoardTipTime animations:^{
                
                self.topBar.Ex_y = screenH - self.topBar.Ex_height - self.topBar.CurrentKeyBoardH - TopM;
                self.Ex_y = screenH - self.Ex_height - BottomM - TopM;
            }];
            self.topBar.topBarAddBtn.selected = NO;
            
            [self UpdateSuperView];
            
        }else {
            
            if (self.textView.isFirstResponder) {
                self.onlyHideSysKboard = YES;
                [self.textView resignFirstResponder];
            }
            self.onlyHideSysKboard = NO;
            [UIView animateWithDuration:keyBoardTipTime animations:^{
                
                self.topBar.Ex_y = screenH - self.topBar.Ex_height - self.topBar.CurrentKeyBoardH - TopM - BottomM;
                self.Ex_y = screenH - self.Ex_height - BottomM - TopM;
            }];
            self.topBar.topBarAddBtn.selected = YES;
            self.topBar.textView.hidden = NO;
            self.topBar.startRecordButton.hidden = YES;
            self.topBar.topBarVoiceBtn.selected = NO;
            [self UpdateSuperView];
        }
    }
    
}

//展示表情键盘
- (void)showEmotionKeyBorad {
    
    if (self.textView.isFirstResponder) {
        self.onlyHideSysKboard = YES;
        [self.textView resignFirstResponder];
    }
    self.onlyHideSysKboard = NO;
    self.emotionBackgroudView.hidden = NO;
    [UIView animateWithDuration:keyBoardTipTime animations:^{
       
        self.topBar.Ex_y = screenH - self.topBar.Ex_height - self.topBar.CurrentKeyBoardH - TopM- BottomM;
        self.Ex_y = screenH - self.Ex_height - BottomM - TopM;
    }];
    self.topBar.topBarEmotionBtn.selected = YES;
    [self UpdateSuperView];
}

//展示文字键盘
- (void)showSystemKeyBoard {

    self.onlyHideSysKboard = NO;
    if (!self.textView.isFirstResponder) {
        [self.textView becomeFirstResponder];
    }
    [UIView animateWithDuration:keyBoardTipTime animations:^{
        
        self.topBar.Ex_y = screenH - self.topBar.Ex_height - self.topBar.CurrentKeyBoardH - TopM;
        self.Ex_y = screenH - self.Ex_height - BottomM - TopM;
    }];
    self.topBar.topBarEmotionBtn.selected = NO;
    self.emotionBackgroudView.hidden = YES;
    [self UpdateSuperView];
}

- (void)needUpdateSuperView {

    [self UpdateSuperView];
    
}
//键盘发送事件
- (void)sendAction {

    [self sendButttonClick:nil];
}

#pragma mark - 录音

- (void)didStartRecordingVoiceAction {
    NSLog(@"Action - didStartRecordingVoice");
    [self startRecord];
    self.isRecord = YES;
    if ([self.delegate respondsToSelector:@selector(recordStarting)]) {
        [self.delegate recordStarting];
    }
}

- (void)didCancelRecordingVoiceAction {
    NSLog(@"Action - didCancelRecordingVoice");
    [self cancelRecord];
    if ([self.delegate respondsToSelector:@selector(cancelStarting)]) {
        
        [self.delegate cancelStarting];
    }
}

- (void)didFinishRecordingVoiceAction {
    NSLog(@"Action - didFinishRecordingVoiceAction");
    self.isRecord = NO;
    if (!self.maxFinish) {
        
        [self finishRecorded];
    }
}

- (void)didDragOutsideAction {
    NSLog(@"Action - didDragOutsideAction");
    [self resumeRecord];
}

- (void)didDragInsideAction {
    NSLog(@"Action - didDragInsideAction");
    [self pauseRecord];
}

- (void)pauseRecord {
    [self.voiceRecordHUD pauseRecord];
}

- (void)resumeRecord {
    [self.voiceRecordHUD resaueRecord];
}

- (void)cancelRecord {
    
    self.isRecord = NO;
    __weak __typeof(self)weakSelf = self;
    [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
        
    }];
}

#pragma mark - Voice Recording Helper Method
- (void)startRecord {
    NSLog(@"Action - startRecord");
    [self.voiceRecordHUD startRecordingHUDAtView:[UIApplication sharedApplication].keyWindow];
    [self.voiceRecordHelper startRecordingWithPath:[self getRecorderPath] StartRecorderCompletion:^{
    }];
}
#pragma mark - RecorderPath Helper Method
- (NSString *)getRecorderPath {
    NSString *recorderPath = nil;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MMMM-dd";
    recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
    dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.aac", [dateFormatter stringFromDate:now]];
    return recorderPath;
}

- (NSString *)getMp3Path {
    NSString *recorderPath = nil;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MMMM-dd";
    recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
    dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MyMp3Sound.mp3", [dateFormatter stringFromDate:now]];
    return recorderPath;
}

- (void)finishRecorded {
    
    if ([self.delegate respondsToSelector:@selector(cancelStarting)]) {
        
        [self.delegate cancelStarting];
    }
    NSLog(@"Action - finishRecorded");
    self.maxFinish = NO;
    __weak __typeof(self)weakSelf = self;
    [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([strongSelf.voiceRecordHelper.recordDuration integerValue]<0.5) {
            if ([strongSelf.voiceRecordHelper.recordDuration integerValue]<0.5) {
                NSLog(@"录音时长小于 0.5s");
            }
            return;
        }
        
        if ([strongSelf.delegate respondsToSelector:@selector(sendVoiceWithVoice:voiceDuration:)]) {
            
            [strongSelf.delegate sendVoiceWithVoice:strongSelf.voiceRecordHelper.recordPath voiceDuration:strongSelf.voiceRecordHelper.recordDuration];
        }
        
//        NSURL *mp3Url = [HQHelper recordCafToMp3WithCafUrl:strongSelf.voiceRecordHelper.recordPath toMp3Url:[self getMp3Path]];
//        
//        [strongSelf SendMessageWithVoice:[mp3Url absoluteString]
//                           voiceDuration:strongSelf.voiceRecordHelper.recordDuration];
    }];
}



#pragma mark ==== scrollView代理 ====
//改变pageControl
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
}

#pragma mark ==== 工具 ====
//根据字体计算表情的高度
- (CGFloat)heightWithFont:(UIFont *)font {
    
    if (!font){font = [UIFont systemFontOfSize:17];}
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize maxsize = CGSizeMake(100, MAXFLOAT);
    CGSize size = [@"/" boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.height;
}
//通过value获取到对应的key
- (NSString *)getKeyForValue:(NSString *)value fromDict:(NSDictionary *)dict {

   __block NSString *resultKey;
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    
        if ([obj isEqualToString:value]) {
            resultKey = key;
        }
    }];
    return resultKey;
}


@end
