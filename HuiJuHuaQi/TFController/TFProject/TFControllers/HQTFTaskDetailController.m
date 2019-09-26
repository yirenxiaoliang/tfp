//
//  HQTFTaskDetailController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTaskDetailController.h"
#import "HQTFPeopleCell.h"
#import "HQSwitchCell.h"
#import "HQSelectTimeCell.h"
#import "HQTFAddLabelCell.h"
#import "TFProjLabelModel.h"
#import "HQTFThreeLabelCell.h"
#import "HQTFAddPeopleController.h"
#import "HQTFChoicePeopleController.h"
#import "HQTFProjectDescController.h"
#import "HQTFLabelManageController.h"
#import "FDActionSheet.h"
#import "HQTFQuantifyController.h"
#import "HQTFEndTimeController.h"
#import "HQTFRelateCell.h"
#import "HQTFTaskDetailTitleCell.h"
#import "HQTFTextImageChangeCell.h"
#import "HQTFTaskProgressCell.h"
#import "HQTFTwoLineCell.h"
#import "JCHATToolBar.h"
#import "HQTFProjectDescController.h"
#import "HQTFTaskOptionController.h"
#import "HQTFRepeatRowController.h"
#import "HQTFMorePeopleCell.h"
#import "HQTFHeartCell.h"
#import "IQKeyboardManager.h"
#import "JCHATMoreView.h"
#import "XHVoiceRecordHUD.h"
#import "XHVoiceRecordHelper.h"
#import "HQTFUploadFileView.h"
#import "HQTFTestOptionController.h"
#import "HQTFPleaseDelayController.h"
#import "HQTFRepeatSettingController.h"
#import "HQTFUploadController.h"
#import "TFSendView.h"
#import "AlertView.h"
#import "TFProjectBL.h"
#import "TFProjectTaskDetailModel.h"
#import "HQTFTaskOptionController.h"
#import "HQTFProjectDescController.h"
#import "HQTFProjectFileController.h"
#import "TFPlayVoiceController.h"
#import "TFNormalApprovalController.h"
#import "TFApprovalDetailMainController.h"
#import "TFProjectDetailModel.h"
#import "FileManager.h"
#import "MWPhotoBrowser.h"
#import "TFSelectChatPeopleController.h"
#import "TFChatCustomModel.h"
#import "FLLibarayViewController.h"
#import "HQSelectTimeView.h"

#define MoreViewContainerHeight 227

@interface HQTFTaskDetailController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,HQSwitchCellDelegate,FDActionSheetDelegate,SendMessageDelegate,AddBtnDelegate,HQBLDelegate,HQTFTaskDetailTitleCellDelegate,UIDocumentInteractionControllerDelegate,MWPhotoBrowserDelegate,HQTFHeartCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** 输入框 */
@property (strong, nonatomic) JCHATToolBarContainer *toolBarContainer;
@property (strong, nonatomic) JCHATMoreViewContainer *moreViewContainer;

/** 最大偏移 */
@property (nonatomic, assign) CGFloat maxOffset;

/** open */
@property (nonatomic, assign) BOOL open;

@property(nonatomic, assign) CGFloat previousTextViewContentHeight;
/**
 *  记录键盘的 Heigth
 */
@property(nonatomic, assign) CGFloat keyBoardHeight;
/** 录音 */
@property(nonatomic, strong, readwrite) XHVoiceRecordHUD *voiceRecordHUD;
/**
 *  管理录音工具对象
 */
@property(nonatomic, strong) XHVoiceRecordHelper *voiceRecordHelper;

/** 用于键盘升降 */
@property(assign, nonatomic) BOOL barBottomFlag;

/** TFProjectBL */
@property (nonatomic, strong) TFProjectBL *projectBL;

/** TFProjectTaskDetailModel */
@property (nonatomic, strong) TFProjectTaskDetailModel *taskDetail;

/** taskDetail */
//@property (nonatomic, strong) HQTFCreatTaskModel *creatTask;

/** 执行人 */
@property (nonatomic, strong) NSArray *excutors;
/** 协作人 */
@property (nonatomic, strong) NSArray *collaborator;

/** 延时审批id */
@property (nonatomic, strong) NSNumber *delayApproveId;

/** images */
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation HQTFTaskDetailController
-(NSMutableArray *)images{
    
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

//-(HQTFCreatTaskModel *)creatTask{
//    if (!_creatTask) {
//        _creatTask = [[HQTFCreatTaskModel alloc] init];
////        _creatTask.isLike = self.taskDetail.isLike;
////        _creatTask.projTask = self.taskDetail.projTask;
//    }
//    return _creatTask;
//}

- (XHVoiceRecordHelper *)voiceRecordHelper {
    if (!_voiceRecordHelper) {
        kWEAKSELF
        _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
        
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            HQLog(@"已经达到最大限制时间了，进入下一步的提示");
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf finishRecorded];
        };
        
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
        };
        
        _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
    }
    return _voiceRecordHelper;
}


- (XHVoiceRecordHUD *)voiceRecordHUD {
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _voiceRecordHUD;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.open = NO;
    //[self.toolBarContainer.toolbar drawRect:self.toolBarContainer.toolbar.frame];
    //self.toolBarContainer.toolbar.heartShow = YES;
    //self.toolBarContainer.toolbar.addButton.selected = NO;
    
    
    IQKeyboardManager *keyBoard = [IQKeyboardManager sharedManager];
    keyBoard.enable = NO;
    
    [self addNotifation];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    self.open = NO;
    
    IQKeyboardManager *keyBoard = [IQKeyboardManager sharedManager];
    keyBoard.enable = YES;
    
    [self hiddenKeyboard];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)addNotifation{
    
    //给键盘注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    [self.projectBL requestGetProjTaskDetailWithTaskId:self.projectTask.id];
    [self.projectBL requestTaskDeadlineApproveType];
    
    self.view.backgroundColor = WhiteColor;
    _previousTextViewContentHeight = 31;
    [self setupTableView];
    /*[self setupToolBar];
    [self setupMoreView];
    [self.toolBarContainer.toolbar.textView addObserver:self
                                             forKeyPath:@"contentSize"
                                                options:NSKeyValueObservingOptionNew
                                                context:nil];
    
    self.toolBarContainer.toolbar.textView.delegate = self;
    [self.toolBarContainer.toolbar drawRect:self.toolBarContainer.toolbar.frame];*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dynamicDownNotifition) name:TFProjectDynamicDownJumpNotifition object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreHandle:) name:TaskDetailMoreHandleNotifition object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedHeart:) name:TaskDynamicClickedHeartNotifition object:nil];
}

- (void)dynamicDownNotifition{
    self.tableView.bottom = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.tableView.top = 60;
        
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.tableView.top = 0;
        }];
    }];
}

- (void)setupToolBar{
    
    self.toolBarContainer = [[JCHATToolBarContainer alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - TabBarHeight, SCREEN_WIDTH, TabBarHeight)];
    self.toolBarContainer.toolbar.frame = self.toolBarContainer.bounds;
    [self.view addSubview:self.toolBarContainer];
    self.toolBarContainer.toolbar.delegate = nil;
    self.toolBarContainer.toolbar.textView.delegate = nil;
    [self.toolBarContainer.toolbar setUserInteractionEnabled:NO];
    self.toolBarContainer.toolbar.textView.placeHolderTextColor = HexColor(0xcacad0, 1);
    self.toolBarContainer.toolbar.textView.placeHolder = @"说点什么...";
    self.toolBarContainer.toolbar.textView.userInteractionEnabled = NO;
    self.toolBarContainer.toolbar.addButton.userInteractionEnabled = NO;
    self.toolBarContainer.toolbar.voiceButton.userInteractionEnabled = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toolBarClicked:)];
    [self.toolBarContainer addGestureRecognizer:tap];
}

- (void)setupMoreView{
    self.moreViewContainer = [[JCHATMoreViewContainer alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, MoreViewContainerHeight)];
    self.moreViewContainer.moreView.type = MoreViewTypeCommentChat;
    self.moreViewContainer.moreView.frame = self.moreViewContainer.bounds;
    [self.view addSubview:self.moreViewContainer];
    self.moreViewContainer.moreView.delegate = self;
    [self.moreViewContainer.moreView setUserInteractionEnabled:YES];
    _moreViewContainer.moreView.backgroundColor = BackGroudColor;
}


- (void)inputKeyboardWillShow:(NSNotification *)notification{
    
    _barBottomFlag=NO;
    self.toolBarContainer.toolbar.addButton.selected = NO;
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    HQLog(@"%f",animationTime);
    self.keyBoardHeight = keyBoardFrame.size.height;
    
    [UIView animateWithDuration:animationTime animations:^{
        
        self.toolBarContainer.bottom = SCREEN_HEIGHT - 64 - keyBoardFrame.size.height+0.5;
        self.moreViewContainer.top = self.toolBarContainer.bottom;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardFrame.size.height + self.toolBarContainer.height - 49, 0);
    }];
    
    //    [self scrollToEnd];//!
}

- (void)inputKeyboardWillHide:(NSNotification *)notification {
    
    
    if (_barBottomFlag == NO) {
        return;
    }
    
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        
        self.toolBarContainer.bottom = SCREEN_HEIGHT - 64;
        self.moreViewContainer.top = self.toolBarContainer.bottom;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
    //    [self scrollToBottomAnimated:NO];
}

/** 隐藏键盘 */
- (void)hiddenKeyboard{
    
    [self.toolBarContainer.toolbar.textView resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.toolBarContainer.bottom = SCREEN_HEIGHT - 64;
        self.moreViewContainer.top = self.toolBarContainer.bottom;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
    
}

#pragma mark --释放内存
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.toolBarContainer.toolbar.textView removeObserver:self forKeyPath:@"contentSize"];
    
}

#pragma mark - Key-value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    
    if (self.barBottomFlag) {
        return;
    }
    if (object == self.toolBarContainer.toolbar.textView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
    
}

//- (void)setupToolBar{
//    
//    self.toolBarContainer = [[JCHATToolBarContainer alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - TabBarHeight, SCREEN_WIDTH, TabBarHeight)];
//    self.toolBarContainer.toolbar.frame = self.toolBarContainer.bounds;
//    [self.view addSubview:self.toolBarContainer];
//    self.toolBarContainer.toolbar.delegate = self;
//    self.toolBarContainer.toolbar.textView.delegate = self;
//    [self.toolBarContainer.toolbar setUserInteractionEnabled:YES];
//    self.toolBarContainer.toolbar.textView.placeHolderTextColor = HexColor(0xcacad0, 1);
//    self.toolBarContainer.toolbar.textView.placeHolder = @"说点什么...";
//}

#pragma mark - UITextView Helper Method
- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}
- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottom, 0);
}

#pragma mark --滑动至尾端
//- (void)scrollToEnd {
//    if ([self.allmessageIds count] != 0) {
//        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.allmessageIds count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];//!UITableViewScrollPositionBottom
//    }
//}

//计算input textfield 的高度
- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
    CGFloat maxHeight = [JCHATToolBar maxHeight];
    
    CGFloat contentH = [self getTextViewContentH:textView];
    
    BOOL isShrinking = contentH < _previousTextViewContentHeight;
    CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
    
    if (!isShrinking && (_previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - _previousTextViewContentHeight);
    }
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             
                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     _previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [_toolBarContainer.toolbar adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             if (!isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self.toolBarContainer.toolbar adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        JCHATMessageTextView *textview =_toolBarContainer.toolbar.textView;
        CGSize textSize = [JCHATStringUtils stringSizeWithWidthString:textview.text withWidthLimit:textView.frame.size.width-12 withFont:[UIFont systemFontOfSize:st_toolBarTextSize]];
        
        HQLog(@"%@",NSStringFromCGSize(textSize));
        
        CGFloat textHeight = textSize.height > maxHeight?maxHeight:textSize.height;
        
        self.toolBarContainer.height = textHeight + 16 > 49 ? textHeight + 16 : 49;//!
        
        self.toolBarContainer.bottom = SCREEN_HEIGHT - 64 - self.keyBoardHeight + .5;// 输入框始终在键盘上面
        [self setTableViewInsetsWithBottomValue:self.keyBoardHeight + self.toolBarContainer.height - 49];// 设置tableView底部偏移量
        
        //        [self scrollToEnd];// 滚动到最后
        
        self.previousTextViewContentHeight = MIN(contentH, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}
#pragma mark -调用相册
- (void)photoClick {
    
    
}

#pragma mark --调用相机
- (void)cameraClick {
    
    
}



- (void)dropToolBarNoAnimate {
    
    _previousTextViewContentHeight = 31;
    _toolBarContainer.toolbar.addButton.selected = NO;
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark --toolBarContainer delegate

- (void)inputTextViewWillBeginEditing:(JCHATMessageTextView *)messageInputTextView {
    //    _textViewInputViewType = JPIMInputViewTypeText;
}

- (void)inputTextViewDidBeginEditing:(JCHATMessageTextView *)messageInputTextView {
    if (!_previousTextViewContentHeight)
        _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)inputTextViewDidEndEditing:(JCHATMessageTextView *)messageInputTextView;
{
    if (!_previousTextViewContentHeight)
        _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)noPressmoreBtnClick:(UIButton *)btn {
    
    _barBottomFlag = YES;
    [self.toolBarContainer.toolbar.textView becomeFirstResponder];
}

#pragma mark --按下功能响应
- (void)pressMoreBtnClick:(UIButton *)btn {
    
    _barBottomFlag=NO;
    [self.toolBarContainer.toolbar.textView resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.toolBarContainer.bottom = SCREEN_HEIGHT- 64-self.moreViewContainer.height;
        self.moreViewContainer.bottom = SCREEN_HEIGHT - 64;
        
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.moreViewContainer.height + self.toolBarContainer.height - 49, 0);
    [self.toolBarContainer.toolbar switchToolbarToTextMode];
    //    [self scrollToEnd];
}

- (void)pressVoiceBtnToHideKeyBoard {///!!!
    [self.toolBarContainer.toolbar.textView resignFirstResponder];
    [self dropToolBar];
}
#pragma mark --返回下面的位置
- (void)dropToolBar {
    
    _barBottomFlag =YES;
    _previousTextViewContentHeight = 31;
    _toolBarContainer.toolbar.addButton.selected = NO;
    //    [_messageTableView reloadData];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.toolBarContainer.bottom = SCREEN_HEIGHT - 64;
        self.moreViewContainer.top = SCREEN_HEIGHT - 64;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
    //    [self scrollToEnd];
}

- (void)switchToTextInputMode {
    UITextView *inputview = self.toolBarContainer.toolbar.textView;
    [inputview becomeFirstResponder];
    [self layoutAndAnimateMessageInputTextView:inputview];
}

/** 发送文本 */
- (void)sendText:(NSString *)text {
    [self prepareTextMessage:text];
    
}
/** 发送文本消息 */
- (void)prepareTextMessage:(NSString *)text {
    
    
}
#pragma mark SendMessageDelegate

- (void)didStartRecordingVoiceAction {
    HQLog(@"Action - didStartRecordingVoice");
    [self startRecord];
}

- (void)didCancelRecordingVoiceAction {
    HQLog(@"Action - didCancelRecordingVoice");
    [self cancelRecord];
}

- (void)didFinishRecordingVoiceAction {
    HQLog(@"Action - didFinishRecordingVoiceAction");
    [self finishRecorded];
}

- (void)didDragOutsideAction {
    HQLog(@"Action - didDragOutsideAction");
    [self resumeRecord];
}

- (void)didDragInsideAction {
    HQLog(@"Action - didDragInsideAction");
    [self pauseRecord];
}

- (void)pauseRecord {
    [self.voiceRecordHUD pauseRecord];
}

- (void)resumeRecord {
    [self.voiceRecordHUD resaueRecord];
}

- (void)cancelRecord {
    kWEAKSELF
    [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
        
    }];
}

#pragma mark - Voice Recording Helper Method
- (void)startRecord {
    HQLog(@"Action - startRecord");
    [self.voiceRecordHUD startRecordingHUDAtView:self.view];
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
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.ilbc", [dateFormatter stringFromDate:now]];
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
    HQLog(@"Action - finishRecorded");
    kWEAKSELF
    [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSURL *mp3Url = [HQHelper recordCafToMp3WithCafUrl:strongSelf.voiceRecordHelper.recordPath toMp3Url:[self getMp3Path]];
        
        [strongSelf SendMessageWithVoice:[mp3Url absoluteString]
                           voiceDuration:strongSelf.voiceRecordHelper.recordDuration];
    }];
}

#pragma mark - Message Send helper Method
#pragma mark --发送语音
- (void)SendMessageWithVoice:(NSString *)voicePath
               voiceDuration:(NSString*)voiceDuration {
    HQLog(@"Action - SendMessageWithVoice");
    
    if ([voiceDuration integerValue] <0.5) {
        if ([voiceDuration integerValue]<0.5) {
            HQLog(@"录音时长小于 0.5s");
        }
        return;
    }
    
    // 此处发送语音
    
}

/** 点击心 */
- (void)clickedHeart:(NSNotification *)note{
    BOOL select = [note.object boolValue];
    self.toolBarContainer.toolbar.heartBtn.selected = [note.object boolValue];
    
    if (select) {
        
        [self.projectBL requestAddTaskLikeWithTaskId:self.taskDetail.id];
    }else{
        [self.projectBL requestDeleteTaskLikeWithUpvoteId:self.taskDetail.myUpvoteId];
    }
    
}

/** 点击toolBar */
- (void)toolBarClicked:(UITapGestureRecognizer *)gesture{
    
    CGPoint point = [gesture locationInView:self.toolBarContainer];
    
    HQLog(@"%@",NSStringFromCGPoint(point));
    
    NSInteger location = 0;// 0:点击语音 1:输入框 2:点击加号
    
    if (point.x <= 44) {
        location = 0;
    }else if (point.x <= SCREEN_WIDTH-44-44){
        location = 1;
    }else if (point.x <= SCREEN_WIDTH-44){
        location = 2;
        self.toolBarContainer.toolbar.heartBtn.selected = !self.toolBarContainer.toolbar.heartBtn.selected;
    }else{
        location = 3;
    }
    
    if (location == 2) {
        // 点赞
        
//        self.creatTask.isLike = self.toolBarContainer.toolbar.heartBtn.selected?@1:@0;
        
//        [self.projectBL requestModTaskLikeWithTaskId:self.taskDetail.projTask.id withIsLike:self.creatTask.isLike];
    }
        
    [[NSNotificationCenter defaultCenter] postNotificationName:TFProjectTaskInputJumpNotifition object:@(location)];
    
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tag = 0x1234567;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
//    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 0x1234567) {
        
//        HQLog(@"tableVeiwSzie:%@",NSStringFromCGSize(scrollView.contentSize));
//        HQLog(@"tableVeiwContentOffset:%@",NSStringFromCGPoint(scrollView.contentOffset));
        
        if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.height + 60 && !self.open) {
            self.open = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:TFProjectTaskInputJumpNotifition object:nil];
        }
        
    }
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {// title
        
        return 2;
    }else if (section == 1){//所有人可见、执行者
        
        return 2;
    }else if (section == 2){// 截止日期、优先级、添加标签、重复任务
        return 5;
    }else if (section == 3){// 上传文件
        return 1 + self.taskDetail.attachments.count;
//        return 1 + 4;
        
    }else if (section == 4){// 检测项
        if (!self.taskDetail.subtask || self.taskDetail.subtask.count == 0) {
            return 1;
        }
        return 2 + self.taskDetail.subtask.count;
        
        
//        return 2 + 4;
    }else if (section == 5){
//        if (self.taskDetail.taskUpvotes.count) {
//            return 1;
//        }else{
//            return 0;
//        }
        return 1;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = self.taskDetail.taskListName;
            cell.arrowShowState = YES;
            cell.time.text = @"";
            cell.time.textColor = ExtraLightBlackTextColor;
            cell.timeTitle.font = FONT(16);
            cell.contentView.backgroundColor = BackGroudColor;
            cell.bottomLine.hidden = YES;
            return  cell;
        }else{
            
            HQTFTaskDetailTitleCell *cell = [HQTFTaskDetailTitleCell taskDetailTitleCellWithTableView:tableView];
            [cell refreshTaskDetailTitleCellWithModel:self.projectTask type:0];
            cell.tag = 0x123;
            cell.bottomLine.hidden = YES;
            cell.delegate = self;
            return cell;
        }
        
    }else if (indexPath.section == 1){
        
            
        if (indexPath.row == 0) {
            
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.delegate = self;
            cell.switchBtn.on = [self.taskDetail.isPublic integerValue]==1?YES:NO;
            cell.title.text = @"仅协作人可见";
            
            return cell;
        }else{
            
            if (!self.taskDetail.executor || [self.taskDetail.executor isEqualToNumber:@0]) {
                HQTFMorePeopleCell *cell = [HQTFMorePeopleCell morePeopleCellWithTableView:tableView];
                cell.titleLabel.text = @"执行人";
                cell.contentLabel.text = @"请添加";
                cell.contentLabel.textColor = PlacehoderColor;
                [cell refreshMorePeopleCellWithPeoples:@[]];
                cell.bottomLine.hidden = YES;
                return cell;
            }else{
                HQTFPeopleCell *cell = [HQTFPeopleCell peopleCellWithTableView:tableView];
                cell.titleLabel.text = @"执行人";
                cell.contentLabel.text = @"";
                cell.contentLabel.textColor = LightBlackTextColor;
                cell.bottomLine.hidden = YES;
                HQEmployModel *model = [[HQEmployModel alloc] init];
                model.id = self.taskDetail.executor;
                model.employeeId = self.taskDetail.executor;
                model.employeeName = self.taskDetail.executorName;
                model.photograph = self.taskDetail.executorPhotograph;
                cell.peoples = @[model];
                return cell;
            }
            
        }
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            
            if ([self.taskDetail.taskStatus isEqualToNumber:@1]) {// 完成
                
                HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                cell.timeTitle.text = @"截止时间";
                cell.arrowShowState = YES;
                cell.time.textColor = PlacehoderColor;
                cell.contentView.backgroundColor = WhiteColor;
                cell.timeTitle.font = FONT(14);
                cell.bottomLine.hidden = NO;
                
                if ([self.taskDetail.deadlineType isEqualToNumber:@2]) {
                    
                    cell.time.text = [HQHelper nsdateToTime:[self.taskDetail.deadline longLongValue] formatStr:@"yyyy-MM-dd"];
                }else{
                    
                    cell.time.text = [self caculeteTimeWithTimeSp:[self.taskDetail.deadline longLongValue]];
                }
                cell.time.textColor = LightBlackTextColor;
                
                return  cell;

            }else{// 未完成
                
                if ([self.taskDetail.isOverdue isEqualToNumber:@1]) {// 超时
                    
                    HQTFTextImageChangeCell *cell = [HQTFTextImageChangeCell textImageChangeCellWithTableView:tableView];
                    cell.titleImg = @"";
                    cell.title = [NSString stringWithFormat:@"截止时间"];
                    cell.contentView.backgroundColor = WhiteColor;
                    if ([self.taskDetail.deadlineType isEqualToNumber:@1]) {
                        
                        cell.desc = @"申请延时";
                    }else{
                        cell.desc = @"";
                    }
                    cell.descColor = GreenColor;
                    cell.content = [HQHelper nsdateToTime:[self.taskDetail.deadline longLongValue] formatStr:@"yyyy-MM-dd"];
                    cell.contentColor = RedColor;
                    cell.bottomLine.hidden = NO;
                    cell.tag = 0x2468;
                    return cell;
                    
                }else{// 未超时
                    
                    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                    cell.timeTitle.text = @"截止时间";
                    cell.arrowShowState = YES;
                    cell.time.textColor = PlacehoderColor;
                    cell.contentView.backgroundColor = WhiteColor;
                    cell.timeTitle.font = FONT(14);
                    cell.bottomLine.hidden = NO;
                    
                    if (!self.taskDetail.deadline || [self.taskDetail.deadline isEqualToNumber:@0]) {
                        cell.time.text = @"请选择";
                        cell.time.textColor = PlacehoderColor;
                    }else{
                        //0时间点 1分钟 2小时 3天 4周 5月 6年 7秒
                        if ([self.taskDetail.deadlineType isEqualToNumber:@2]) {
                            
                            cell.time.text = [HQHelper nsdateToTime:[self.taskDetail.deadline longLongValue] formatStr:@"yyyy-MM-dd"];
                        }else{
                            
                            cell.time.text = [self caculeteTimeWithTimeSp:[self.taskDetail.deadline longLongValue]];
                        }
                        cell.time.textColor = LightBlackTextColor;
                    }
                    return  cell;
                    
                }
                
            }
            
        }else if (indexPath.row == 1){
            
            
            if (!self.taskDetail.priority) {
                HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                cell.timeTitle.text = @"优先级  ";
                cell.arrowShowState = YES;
                cell.time.text = @"普通";
                cell.time.textColor = PlacehoderColor;
                return  cell;
            }else{
                HQTFAddLabelCell *cell = [HQTFAddLabelCell addLabelCellWithTableView:tableView];
                [cell refreshAddLabelCellWithPriority:self.taskDetail.priority];
                cell.titleLabel.text = @"优先级";
                cell.bottomLine.hidden = NO;
                return  cell;
            }
            
            
        }else if (indexPath.row == 2){
            
            if (!self.taskDetail.labels || self.taskDetail.labels.count == 0) {
                HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                cell.timeTitle.text = @"标签";
                cell.arrowShowState = YES;
                cell.time.text = @"请选择";
                cell.time.textColor = PlacehoderColor;
                cell.bottomLine.hidden = NO;
                return  cell;
            }else{
                HQTFAddLabelCell *cell = [HQTFAddLabelCell addLabelCellWithTableView:tableView];
                cell.titleLabel.text = @"标签";
                [cell refreshAddLabelCellWithLabels:self.taskDetail.labels];
                cell.bottomLine.hidden = NO;
                return  cell;
            }
        }else  if (indexPath.row == 3){
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"重复列表";
            cell.arrowShowState = YES;
            if (!self.taskDetail.isCycle) {
                cell.time.text = @"请选择";
                cell.time.textColor = PlacehoderColor;
            }else{
//                cell.time.text = self.taskDetail.projTask.isRepeat;
                cell.time.text = @"从不重复";
                cell.time.textColor = LightBlackTextColor;
            }
            cell.contentView.backgroundColor = WhiteColor;
            cell.timeTitle.font = FONT(14);
            cell.bottomLine.hidden = NO;
            return  cell;
            

        }else{
            
            HQTFMorePeopleCell *cell = [HQTFMorePeopleCell morePeopleCellWithTableView:tableView];
            cell.titleLabel.text = @"协作人";
            
            if (!self.taskDetail.teamEmployeeIds || self.taskDetail.teamEmployeeIds.count == 0) {
                
                cell.contentLabel.text = @"请添加";
                cell.contentLabel.textColor = PlacehoderColor;
                cell.contentLabel.textAlignment = NSTextAlignmentLeft;
            }else{
                
                cell.contentLabel.text = [NSString stringWithFormat:@"%ld人",self.taskDetail.teamEmployeeIds.count];
                cell.contentLabel.textColor = ExtraLightBlackTextColor;
                cell.contentLabel.textAlignment = NSTextAlignmentRight;
                
            }
            [cell refreshMorePeopleCellWithPeoples:self.taskDetail.teamEmployeeIds];
            cell.bottomLine.hidden = YES;
            return cell;
            

        }
        
    }else if (indexPath.section == 3){
        
        
        if (indexPath.row == 0) {
            
            HQTFThreeLabelCell *cell = [HQTFThreeLabelCell threeLabelCellWithTableView:tableView];
            cell.leftLabel.text = @"附件";
            cell.rightLabel.text = @"上传附件";
            return cell;
            
        }else{
            
            
            HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
            cell.type = TwoLineCellTypeTwo;
            
            TFFileModel *file = self.taskDetail.attachments[indexPath.row-1];
            
            [cell refreshCellWithFileModel:file];
            
            return cell;
        }
        
    }else if (indexPath.section == 4){
        
        if (indexPath.row == 0) {
            
            HQTFThreeLabelCell *cell = [HQTFThreeLabelCell threeLabelCellWithTableView:tableView];
            cell.leftLabel.text = @"指派任务";
            cell.rightLabel.text = @"添加";
            return cell;
        
        }else{
            
            if (indexPath.row == 1) {
                
                
                HQTFTaskProgressCell *cell = [HQTFTaskProgressCell taskProgressCellWithTableView:tableView];
                
                [cell refreshTaskProgressCellWithTotalTask:[self.taskDetail.subTaskCount integerValue] finish:[self.taskDetail.subTaskFinishCount integerValue]];
                return cell;
                
                
            }else{
                
                HQTFTaskDetailTitleCell *cell = [HQTFTaskDetailTitleCell taskDetailTitleCellWithTableView:tableView];
                [cell refreshTaskDetailTitleCellWithModel:self.taskDetail.subtask[indexPath.row-2] type:1];
                cell.bottomLine.hidden = NO;
                if (indexPath.row-1 == self.taskDetail.subtask.count) {
                    cell.bottomLine.hidden = YES;
                }
                cell.delegate = self;
                cell.tag = 0x456 + indexPath.row - 2;
                return cell;
                
            }

        }
    
    }else if (indexPath.section == 5){
        
        HQTFHeartCell *cell = [HQTFHeartCell heartCellWithTableView:tableView];
        cell.isShow = YES;
        cell.delegate = self;
        [cell refreshHeartCellWithPeoples:self.taskDetail.taskUpvotes];
        
        return cell;
    }else{
        
        HQTFTextImageChangeCell *cell = [HQTFTextImageChangeCell textImageChangeCellWithTableView:tableView];
        cell.titleImg = @"动态1";
        cell.title = [NSString stringWithFormat:@"  评论"];
        cell.contentView.backgroundColor = BackGroudColor;
        cell.content = @"";
        cell.desc = @"";
        cell.bottomLine.hidden = YES;
        cell.tag = 0x2468;
        return cell;
    }
    
    
}

#pragma mark - HQTFHeartCellDelegate
-(void)heartCellDidClickedHeart:(UIButton *)heartBtn{
    
    if (!heartBtn.selected) {
        
        [self.projectBL requestAddTaskLikeWithTaskId:self.taskDetail.id];
    }else{
        [self.projectBL requestDeleteTaskLikeWithUpvoteId:self.taskDetail.myUpvoteId];
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            HQTFTaskOptionController *desc = [[HQTFTaskOptionController alloc] init];
            desc.listItem = self.projectSeeModel;
            [self.navigationController pushViewController:desc animated:YES];
        }
    }
    
    if ([self.taskDetail.taskPermission isEqualToNumber:@0]) {// 没权限
        [MBProgressHUD showError:@"您无权限" toView:KeyWindow];
        return;
    }
    
    if (indexPath.section == 1) {
        
//        if (indexPath.row == 0) {// 任务描述
//            HQTFProjectDescController *desc = [[HQTFProjectDescController alloc] init];
//            desc.type = 4;
//            desc.descString = self.taskDetail.projTask.descript;
//            [self.navigationController pushViewController:desc animated:YES];
//        }
        
        if (indexPath.row == 1) {// 指派
            
            if (![self.taskDetail.taskPermission isEqualToNumber:@2]) {// 没权限
                [MBProgressHUD showError:@"您无权限" toView:KeyWindow];
                return;
            }
//            if (![self.taskDetail.creatorId isEqualToNumber:UM.userLoginInfo.employee.id]) {
//                return;
//            }
//            HQTFChoicePeopleController *choice = [[HQTFChoicePeopleController alloc] init];
//            
//            if (self.taskDetail.executor) {
//                
//                HQEmployModel *model = [[HQEmployModel alloc] init];
//                model.id = self.taskDetail.executor;
//                model.employeeId = self.taskDetail.executor;
//                model.employeeName = self.taskDetail.executorName;
//                model.photograph = self.taskDetail.executorPhotograph;
//                choice.employees = @[model];// 执行人
//            }
//            choice.type = ChoicePeopleTypeCreateTaskExcutor;
//            choice.Id = self.taskDetail.projectId;
//            choice.projectItem = self.projectSeeModel.project;
//            choice.sectionTitle = @"任务执行人";
//            choice.rowTitle = @"添加执行人";
//            if (!self.taskDetail.executor) {
//                choice.instantPush = YES;
//            }
//            
//            choice.actionParameter = ^(NSMutableArray<Optional,HQEmployModel> *people){
//                
//                
//                self.projectTask.excutors = people;
//                NSMutableArray *ids = [NSMutableArray array];
//                for (HQEmployModel *employ in people) {
//                    [ids addObject:employ.id?employ.id:employ.employeeId];
//                }
//                
//                if (ids.count) {
//                    HQEmployModel *em = people[0];
//                    self.projectTask.executor = em.id?em.id:em.employeeId;
//                    self.projectTask.executorName = em.employeeName;
//                    self.projectTask.executorPhotograph = em.photograph;
//                    self.projectTask.executorPosition = em.position;
//                    
//                    self.taskDetail.executor = em.id?em.id:em.employeeId;
//                    self.taskDetail.executorName = em.employeeName;
//                    self.taskDetail.executorPhotograph = em.photograph;
//                }
////
////                NSMutableArray *coll = [NSMutableArray array];
////                for (HQEmployModel *employ in self.taskDetail.collaborator) {
////                    [coll addObject:employ.id];
////                }
////                self.creatTask.addCollaboratorIds = coll;
//                
//                [self.projectBL requestUpdateProjTaskWithModel:self.projectTask];
////                [self.projectBL requestUpdateTaskExcutorWithTaskId:self.creatTask.projTask.id withAddExcutorIds:self.creatTask.addExcutorIds];
//                
//            };
//            
//            [self.navigationController pushViewController:choice animated:NO];
            
            HQTFAddPeopleController *addPeople = [[HQTFAddPeopleController alloc] init];
            
            if (self.taskDetail.executor) {
                
                HQEmployModel *model = [[HQEmployModel alloc] init];
                model.id = self.taskDetail.executor;
                model.employeeId = self.taskDetail.executor;
                model.employeeName = self.taskDetail.executorName;
                model.photograph = self.taskDetail.executorPhotograph;
                addPeople.employees = @[model];// 执行人
            }
            addPeople.type = ChoicePeopleTypeCreateTaskExcutor;
            addPeople.Id = self.taskDetail.projectId;
            addPeople.projectItem = self.projectSeeModel.project;
            addPeople.actionParameter = ^(NSMutableArray<Optional,HQEmployModel> *peoples){
                
                
                self.projectTask.excutors = peoples;
                NSMutableArray *ids = [NSMutableArray array];
                for (HQEmployModel *employ in peoples) {
                    [ids addObject:employ.id?employ.id:employ.employeeId];
                }
                
                if (ids.count) {
                    HQEmployModel *em = peoples[0];
                    self.projectTask.executor = em.id?em.id:em.employeeId;
                    self.projectTask.executorName = em.employeeName;
                    self.projectTask.executorPhotograph = em.photograph;
                    self.projectTask.executorPosition = em.position;
                    
                    self.taskDetail.executor = em.id?em.id:em.employeeId;
                    self.taskDetail.executorName = em.employeeName;
                    self.taskDetail.executorPhotograph = em.photograph;
                }
                
                [self.projectBL requestUpdateProjTaskWithModel:self.projectTask];
                
                
            };
            
            [self.navigationController pushViewController:addPeople animated:YES];
            
            
            
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            
           
            if ([self.taskDetail.isOverdue isEqualToNumber:@1]) {// 超时
                if ([self.taskDetail.deadlineType isEqualToNumber:@1]) {// 时间点就不能申请延时
                    
                    if ([self.taskDetail.approvePermission isEqualToNumber:@0]) {// 没权限
                        return;
                    }
                    
                    if (!self.taskDetail.executor) {
                        [MBProgressHUD showError:@"只有执行人可申请延时" toView:self.view];
                        return;
                    }
                    
                    if ([UM.userLoginInfo.employee.employee_id isEqualToNumber:self.taskDetail.executor]) {// 是执行者
                        
                        if (self.delayApproveId) {
                            
                            TFNormalApprovalController *approve = [[TFNormalApprovalController alloc] init];
                            approve.approvalType = FunctionModelTypeTaskDeley;
                            approve.approvalTypeId = self.delayApproveId;
                            
                            TFApprovalDetailModel *model = [[TFApprovalDetailModel alloc] init];
                            model.taskId = self.projectTask.id;
                            model.placeDecription = self.projectTask.title;
                            model.endDate = self.projectTask.deadline;
                            model.isFixed = @1;
                            TFApprovalPeopleModel *people = [[TFApprovalPeopleModel alloc] init];
                            people.id = self.taskDetail.creatorId;
                            people.employeeId = self.taskDetail.creatorId;
                            people.employeeName = self.taskDetail.creatorName;
                            people.photograph = self.taskDetail.creatorPhotograph;
                            people.position = self.taskDetail.creatorPosition;
                            NSMutableArray<TFApprovalPeopleModel,Optional> *arr = [NSMutableArray<TFApprovalPeopleModel,Optional> array];
                            [arr addObject:people];
                            model.approverList = arr;
                            approve.approvalDetail = model;
                            
                            NSMutableArray *ids = [NSMutableArray arrayWithObject:self.taskDetail.creatorId];
                            model.approverListIds = ids;
                            
                            [self.navigationController pushViewController:approve animated:YES];
                        }
                        

                    }else{
                        
                        [MBProgressHUD showError:@"只有执行人可申请延时" toView:self.view];
                        return;
                    }
                    
                    
                }
                
                
            }else{
                
                if (![self.taskDetail.taskPermission isEqualToNumber:@2]) {// 没权限
                    return;
                }
//                HQTFEndTimeController *repeat = [[HQTFEndTimeController alloc] init];
////                repeat.date = [HQHelper nsdateToTime:[self.taskDetail.projTask.deadline longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
//                repeat.date = (!self.projectTask.deadline || [self.projectTask.deadline isEqualToNumber:@0])?[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd HH:mm"]:[HQHelper nsdateToTime:[self.projectTask.deadline longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
//                repeat.deadlineType = self.taskDetail.deadlineType==nil?@2:self.taskDetail.deadlineType;
//                repeat.deadlineUnit = self.taskDetail.deadlineUnit==nil?@0:self.taskDetail.deadlineUnit;
//                repeat.timeAction = ^(NSArray *parameter){
//                    // 0时间点 1分钟 2小时 3天 4周 5月 6年 7秒
//                    NSString *date = parameter[1];
//                    long long timeSp = [HQHelper changeTimeToTimeSp:date formatStr:@"yyyy-MM-dd HH:mm"];
//                    
//                    if (self.projectSeeModel.project.endTime && ![self.projectSeeModel.project.endTime isEqualToNumber:@0]) {
//                        
//                        if ([self.projectSeeModel.project.endTime longLongValue] < timeSp) {
//                            [MBProgressHUD showError:@"任务截止时间不能超过项目截止时间" toView:KeyWindow];
//                            return ;
//                        }
//                    }
//                    
//                    self.taskDetail.deadlineUnit = parameter[0];
//                    self.taskDetail.deadline = [NSNumber numberWithLongLong:timeSp];
//                    
//                    self.projectTask.deadlineType = self.taskDetail.deadlineUnit;
//                    self.projectTask.deadline = self.taskDetail.deadline;
//                    [self.projectBL requestUpdateProjTaskWithModel:self.projectTask];
//                };
//                
//                [self.navigationController pushViewController:repeat animated:YES];
                
                [HQSelectTimeView selectTimeViewWithType:SelectTimeViewType_YearMonthDayHourMiuth timeSp:(!self.projectTask.deadline || [self.projectTask.deadline isEqualToNumber:@0])?[HQHelper getNowTimeSp]:[self.projectTask.deadline longLongValue] LeftTouched:^{
                    
                } onRightTouched:^(NSString *time) {
                    
                    HQLog(@"%@",time);
                    
                    if ([time isEqualToString:@""]) {// 清空
                        
                        self.taskDetail.deadline = [NSNumber numberWithLongLong:[HQHelper getNowTimeSp]];
                        [self.tableView reloadData];
                        return ;
                    }
                    
                    long long timeSp = [HQHelper changeTimeToTimeSp:[NSString stringWithFormat:@"%@",time] formatStr:@"yyyy-MM-dd HH:mm"];
                    
                    
                    if (self.projectSeeModel.project.endTime && ![self.projectSeeModel.project.endTime isEqualToNumber:@0]) {
                        
                        if ([self.projectSeeModel.project.endTime longLongValue] < timeSp) {
                            [MBProgressHUD showError:@"任务截止时间不能超过项目截止时间" toView:KeyWindow];
                            return ;
                        }
                    }
                    
                    self.taskDetail.deadlineType = @2;
                    self.taskDetail.deadline = [NSNumber numberWithLongLong:timeSp];
                    
                    self.projectTask.deadlineType = self.taskDetail.deadlineType;
                    self.projectTask.deadline = self.taskDetail.deadline;
                    [self.projectBL requestUpdateProjTaskWithModel:self.projectTask];
                }];

                
            }
            
        }
        
        if (indexPath.row == 1) {
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"优先级" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"普通",@"紧急",@"非常紧急",nil];
            
            UIColor *color = LightBlackTextColor;
            if ([self.taskDetail.priority integerValue] == 1) {
                color = PriorityUrgent;
            }else if ([self.taskDetail.priority integerValue] == 2){
                color = PriorityVeryUrgent;
            }
            
            [sheet setButtonTitleColor:color bgColor:WhiteColor fontSize:FONT(18) atIndex:[self.taskDetail.priority integerValue]];
            
            [sheet show];
        }
        if (indexPath.row == 2) {// 标签
            HQTFLabelManageController *label = [[HQTFLabelManageController alloc] init];
            label.projectId = self.projectTask.projectId;
            label.type = LabelManageControllerSelect;
            label.didSelectLabels = [NSMutableArray arrayWithArray:self.taskDetail.labels];
            label.labelAction = ^(id parameter){
            
                self.taskDetail.labels = parameter;
                
                NSMutableArray<Optional,TFProjLabelModel> *labelIds = [NSMutableArray<Optional,TFProjLabelModel> array];
                for (TFProjLabelModel *label in self.taskDetail.labels) {
                    [labelIds addObject:label.labelId];
                }
                self.projectTask.labelIds = labelIds;
                self.projectTask.labels = parameter;
                [self.projectBL requestUpdateProjTaskWithModel:self.projectTask];
                
            };
            [self.navigationController pushViewController:label animated:YES];
            
        }
        if (indexPath.row == 3) {// 重复设置
            
            HQTFRepeatSettingController *repeat = [[HQTFRepeatSettingController alloc] init];
            [self.navigationController pushViewController:repeat animated:YES];
            
        }
        if (indexPath.row == 4) {
            
            HQTFChoicePeopleController *choice = [[HQTFChoicePeopleController alloc] init];
            choice.isMutual = YES;
            choice.Id = self.taskDetail.projectId;
            choice.employees = self.taskDetail.teamEmployeeIds;// 协作人
            choice.type = ChoicePeopleTypeCreateTaskcollaborator;
            choice.Id = self.taskDetail.projectId;
            choice.sectionTitle = @"任务协作人";
            choice.rowTitle = @"添加协作人";
            choice.projectItem = self.projectSeeModel.project;
            if (!self.taskDetail.teamEmployeeIds.count) {
                choice.instantPush = YES;
            }
            
            choice.actionParameter = ^(NSMutableArray<Optional,HQEmployModel> *people){
                
                
                self.taskDetail.teamEmployeeIds = people;
                
                NSMutableArray *ids = [NSMutableArray array];
                for (HQEmployModel *employ in people) {
                    [ids addObject:employ.id?employ.id:employ.employeeId];
                }
                
                self.projectTask.teamUserIds = ids;
                self.projectTask.teamUsers = people;
                
                [self.projectBL requestModifyTaskCooparationWithTaskId:self.taskDetail.id teamEmpIds:ids];
//                [self.projectBL requestUpdateProjTaskWithModel:self.projectTask];
            };
            
            [self.navigationController pushViewController:choice animated:NO];
        }
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
//            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"文件库",@"选择已有照片",@"拍照上传",nil];
//            
//            sheet.tag = 222;
//            [sheet setButtonTitleColor:BlackTextColor bgColor:nil fontSize:FONT(16) atIndex:0];
//            [sheet setButtonTitleColor:BlackTextColor bgColor:nil fontSize:FONT(16) atIndex:1];
//            [sheet setCancelButtonTitleColor:BlackTextColor bgColor:CellClickColor fontSize:FONT(16)];
//            [sheet show];
            
            [HQTFUploadFileView showAlertView:@"上传文件" withType:1 parameterAction:^(NSNumber *parameter) {
                
                HQLog(@"======%@",parameter);
                
                [self uploadFileWithType:[parameter integerValue]];
                
            }];
            
        }else{
            TFFileModel *model = self.taskDetail.attachments[indexPath.row-1];
            if ([[model.fileType lowercaseString] isEqualToString:@"jpg"] || [[model.fileType lowercaseString] isEqualToString:@"png"] || [[model.fileType lowercaseString] isEqualToString:@"gif"]) {// 查看图片
                
                
                [self.images removeAllObjects];
                
                for (TFFileModel *model in self.taskDetail.attachments) {
                    
                    if ([model.fileType integerValue] == 0) {
                        
                        [self.images addObject:model];
                    }
                }
                
                [self didLookAtPhotoActionWithIndex:indexPath.row];
                
            }else if ([[model.fileType lowercaseString] isEqualToString:@"doc"] ||
                      [[model.fileType lowercaseString] isEqualToString:@"docx"] ||
                      [[model.fileType lowercaseString] isEqualToString:@"exl"] ||
                      [[model.fileType lowercaseString] isEqualToString:@"exls"] ||
                      [[model.fileType lowercaseString] isEqualToString:@"ppt"] ||
                      [[model.fileType lowercaseString] isEqualToString:@"ai"] ||
                      [[model.fileType lowercaseString] isEqualToString:@"cdr"] ||
                      [[model.fileType lowercaseString] isEqualToString:@"dwg"] ||
                      [[model.fileType lowercaseString] isEqualToString:@"ps"] ||
                      [[model.fileType lowercaseString] isEqualToString:@"txt"] ||
                      [[model.fileType lowercaseString] isEqualToString:@"zip"]){
                
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [HQHelper cacheFileWithUrl:model.fileUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (error == nil) {
                        
                        // 临时文件夹
                        NSString *tmpPath = [FileManager dirTmp];
                        // 创建文件路径
                        NSString *filePath = [FileManager createFile:model.fileName forPath:tmpPath];
                        // 将文件写入该路径
                        BOOL pass = [data writeToFile:filePath atomically:YES];
                        
                        if (pass) {// 写入成功
                            
                            UIDocumentInteractionController *ctrl = [UIDocumentInteractionController  interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
                            ctrl.delegate = self;
                            [ctrl presentPreviewAnimated:YES];
                        }
                    }else{
                        [MBProgressHUD showError:@"读取文件失败" toView:self.view];
                    }
                    
                }];
                
            }else if ([[model.fileType lowercaseString] isEqualToString:@"mp3"]){
                
                
                TFPlayVoiceController *play = [[TFPlayVoiceController alloc] init];
                play.file = model;
                [self.navigationController pushViewController:play animated:YES];
                
            }else{
                
                [MBProgressHUD showError:@"未知文件无法预览" toView:KeyWindow];
            }
            
            
        }
        
    }
    
    if (indexPath.section == 4) {
        
        if (indexPath.row == 0) {
            
            if (self.projectTask.subtask.count >= 10) {
                
                [MBProgressHUD showError:@"指派任务最多10个" toView:self.view];
                return;
            }
            
            HQTFTestOptionController *option = [[HQTFTestOptionController alloc] init];
            option.taskDetail = self.projectTask;
            option.projectItem = self.projectSeeModel.project;
            option.successAction = ^{// 刷新
                
                [self.projectBL requestGetProjTaskDetailWithTaskId:self.projectTask.id];
            };
            [self.navigationController pushViewController:option animated:YES];
        }
        
        if (indexPath.row == 2) {
            
            TFProjTaskModel *subtask = self.taskDetail.subtask[indexPath.row - 2];
            HQTFTestOptionController *option = [[HQTFTestOptionController alloc] init];
            option.isEdit = YES;
            option.subtask = subtask;
            option.taskDetail = self.projectTask;
            option.projectItem = self.projectSeeModel.project;
            option.successAction = ^{// 刷新
                
                [self.projectBL requestGetProjTaskDetailWithTaskId:self.projectTask.id];
            };
            [self.navigationController pushViewController:option animated:YES];
        }
        
    }
    
    if (indexPath.section == 5) {
        
    }
    
    if (indexPath.section == 6) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TFProjectTaskInputJumpNotifition object:nil];
    }
    
}


#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

//可选的2个代理方法 （主要是调整预览视图弹出时候的动画效果，如果不实现，视图从底部推出）
- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    return self.view.frame;
}


- (void)didLookAtPhotoActionWithIndex:(NSInteger)index{
    
    // 浏览图片
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO; // 分享按钮,默认是
    browser.alwaysShowControls = NO ; // 控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = YES; // 是否全屏,默认是
    browser.enableSwipeToDismiss = NO;
    [browser showNextPhotoAnimated:NO];
    [browser showPreviousPhotoAnimated:NO];
    [browser setCurrentPhotoIndex:index];
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.autoPlayOnAppear = NO;
    [self.navigationController pushViewController:browser animated:YES] ;
}
#pragma mark - 图片浏览器

/**
 * 标题
 */
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index{
    return [NSString stringWithFormat:@"%ld/%ld",index+1,self.images.count] ;
}

/**
 * 图片总数量
 */
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.images.count;
}

/**
 * 图片设置
 */
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    TFFileModel *model = self.images[index];
    MWPhoto *mwPhoto = nil;
    
    if (model.image) {
        mwPhoto = [MWPhoto photoWithImage:model.image];
    }else{
        mwPhoto = [MWPhoto photoWithURL:[NSURL URLWithString:model.fileUrl]];
    }
    
    return mwPhoto;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            return 42;
        }
        return [HQTFTaskDetailTitleCell refreshTaskDetailTitleCellHeightWithModel:self.projectTask type:0];
        
    }else if (indexPath.section == 1){
        return 55;
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 2) {
            
            return [HQTFAddLabelCell refreshAddLabelCellHeightWithLabels:self.taskDetail.labels];
        }else{
            return 55;
        }
    }else if (indexPath.section == 3 || indexPath.section == 4){
        
        if (indexPath.row == 0) {
            return 55;
        }
        return 70;
    }else if (indexPath.section == 3 || indexPath.section == 4){
        
        if (indexPath.row == 0) {
            return 55;
        }
        return 70;
    }else if (indexPath.section == 5){
        return [HQTFHeartCell refreshHeartCellHeightWithPeoples:self.taskDetail.taskUpvotes withType:1];
    }else{
        return 55;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    
    if (section == 3) {// 文件
        
        if (!self.taskDetail.attachments || self.taskDetail.attachments.count == 0) {
            return 0;
        }
    }
   
    if (section == 5 || section == 6) {
        return 0;
    }
    return 8;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 0x1234567) {
        
        [self hiddenKeyboard];
    }
}

#pragma mark - 开关cell

-(void)switchCellDidSwitchButton:(UISwitch *)switchButton{
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        [self.tableView reloadData];
        return;
    }
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    if ([self.taskDetail.taskPermission isEqualToNumber:@0]) {
        [MBProgressHUD showError:@"您无权限" toView:KeyWindow];
        [self.tableView reloadData];
        return;
    }
    
    switchButton.on = !switchButton.on;
    self.taskDetail.isPublic = switchButton.on?@1:@0;
    self.projectTask.isPublic = self.taskDetail.isPublic;
    [self.projectBL requestUpdateProjTaskWithModel:self.projectTask];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    self.taskDetail.priority = @(buttonIndex);
    self.projectTask.priority = @(buttonIndex);
    [self.projectBL requestUpdateProjTaskWithModel:self.projectTask];
}

#pragma mark - 上传文件
- (void)uploadFileWithType:(NSInteger)type{
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    if (type == 3) {// 文件库
        
        
        FLLibarayViewController *file = [[FLLibarayViewController alloc] init];
        file.isFromOutside = YES;
        file.fileArrBlock = ^(NSArray *array) {
            
            for (TFFileModel *file in array) {
                
                file.createTime = @([HQHelper getNowTimeSp]);
//                file.employeeName = UM.userLoginInfo.employee.employeeName;
//                file.employeeId = UM.userLoginInfo.employee.id;
//                file.photograph = UM.userLoginInfo.employee.photograph;
//                file.creatorId = UM.userLoginInfo.employee.id;
                file.projectId = self.projectSeeModel.project.id;
                file.taskId = self.projectTask.id;
                
            }
            NSMutableArray<Optional,TFFileModel> *arr = [NSMutableArray <Optional,TFFileModel>arrayWithArray:self.taskDetail.attachments];
            [arr addObjectsFromArray:array];
            self.taskDetail.attachments = arr;
            self.projectTask.fileCount = @(self.taskDetail.attachments.count);
            
                
            [self.projectBL requestFileUploadWithFiles:array];
                
            
            
        };
        [self.navigationController pushViewController:file animated:YES];
        
        return;
    }
    
    
    HQTFUploadController *upload = [[HQTFUploadController alloc] initWithFiles:self.taskDetail.attachments withUploadModel:UploadModelProject withType:(UploadFileType)type projectId:self.projectSeeModel.project.id taskId:self.projectTask.id];
    
    upload.actionParameter = ^(NSArray<Optional,TFFileModel> *files){
        
        for (TFFileModel *file in files) {
            
            if (!file.employeeId || [file.employeeId isEqualToNumber:@0]) {
                file.createTime = @([HQHelper getNowTimeSp]);
//                file.employeeName = UM.userLoginInfo.employee.employeeName;
//                file.employeeId = UM.userLoginInfo.employee.id;
//                file.photograph = UM.userLoginInfo.employee.photograph;
            }
        }
        
        self.taskDetail.attachments = files;
        self.projectTask.fileCount = @(files.count);
        [self.tableView reloadData];
        
    };
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController pushViewController:upload animated:NO];
    });
}

- (void)moreHandle:(NSNotification *)note{
    
    
    switch ([note.object integerValue]) {
        case 0:
        {
            // 1.第一步选人
            TFSelectChatPeopleController *select = [[TFSelectChatPeopleController alloc] init];
            select.type = 1;
            select.isSingle = YES;
            select.actionParameter = ^(NSArray *parameter) {
                
                // 2.第二步展示输入
                HQEmployModel *employee = parameter.lastObject;
                [TFSendView showAlertView:@"发送给："
                                   people:employee
                                  content:self.taskDetail.title
                                 password:nil
                                  endTime:nil
                               placehoder:@"说点什么"
                            onLeftTouched:^{
                                
                            }
                           onRightTouched:^(TFSendModel *sendModel){
                               
                               // 3.第三步发送信息
                               [JMSGConversation createSingleConversationWithUsername:sendModel.people.imUserName appKey:JMESSAGE_APPKEY completionHandler:^(id resultObject, NSError *error) {
                                   
                                   if (error == nil) {
                                       JMSGConversation *conversation = resultObject;
                                       TFChatCustomModel *customModel = [[TFChatCustomModel alloc] init];
                                       customModel.id = self.taskDetail.id;
                                       customModel.title = self.taskDetail.title;
                                       customModel.type = @1110;
                                       
//                                       HQEmployModel *emp = [[HQEmployModel alloc] init];
//                                       emp.employeeName = self.taskDetail.creatorName;
//                                       emp.employeeId = self.taskDetail.creatorId;
//                                       emp.id = self.taskDetail.creatorId;
//                                       customModel.creator = emp;
                                       
                                       customModel.employeeName = self.taskDetail.creatorName;
                                       customModel.employeeId = self.taskDetail.creatorId;
                                       
                                       customModel.createTime = self.taskDetail.createTime;
                                       
                                       // 自定义消息
                                       JMSGCustomContent *customContent = [[JMSGCustomContent alloc] initWithCustomDictionary:[customModel toDictionary]];
                                       JMSGMessage *customMessage = [conversation createMessageWithContent:customContent];
                                       [conversation sendMessage:customMessage];
                                       
                                       if (sendModel.inputText && ![sendModel.inputText isEqualToString:@""]) {// 说了什么
                                           
                                           // 文本消息
                                           JMSGTextContent *customContent = [[JMSGTextContent alloc] initWithText:sendModel.inputText];
                                           JMSGMessage *customMessage = [conversation createMessageWithContent:customContent];
                                           [conversation sendMessage:customMessage];
                                       }
                                       
                                       
                                   } else {
                                       HQLog(@"createSingleConversationWithUsername");
                                   }
                               }];

                           }];
                
                
            };
            [self.navigationController pushViewController:select animated:YES];
            
        }
            break;
        case 1:
        {
            return;
            [TFSendView showAlertView:@"发送给："
                               people:@"伊人小亮"
                              content:@"我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个络地址哦"
                             password:@"3456"
                              endTime:@"2017-09-08"
                           placehoder:nil
                        onLeftTouched:^{
                            
                        }
                       onRightTouched:^(id parameter){
                           
                       }];
        }
            break;
        case 2:
        {
            
            return;
            [TFSendView showAlertView:@"发送给："
                               people:@"伊人小亮"
                              content:@"我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个络地址哦"
                             password:@"3456"
                              endTime:@"2017-09-08"
                           placehoder:nil
                        onLeftTouched:^{
                            
                        }
                       onRightTouched:^(id parameter){
                           
                       }];
        }
            break;
        case 3:
        {
            return;
            [TFSendView showAlertView:@"发送到邮箱："
                               people:nil
                              content:@"我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个络地址哦"
                             password:@"3456"
                              endTime:@"2017-09-08"
                           placehoder:@"我想说点东西"
                        onLeftTouched:^{
                            
                        }
                       onRightTouched:^(id parameter){
                           
                       }];
        }
            break;
        case 4:
        {
            HQTFProjectDescController *desc = [[HQTFProjectDescController alloc] init];
            desc.naviTitle = @"任务名称";
            desc.sectionTitle = @"任务名称";
            desc.descString = self.taskDetail.title;
            desc.descAction = ^(NSString *time){
                self.projectTask.title = time;
                self.taskDetail.title = time;
                [self.projectBL requestUpdateProjTaskWithModel:self.projectTask];
            };
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController pushViewController:desc animated:YES];
            });
        }
            break;
        case 5:
        {
            [AlertView showAlertView:@"删除任务" msg:@"删除后该任务无法恢复" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
                
            } onRightTouched:^{
                
                [self.projectBL requestDelProjTaskWithProjTaskId:self.taskDetail.id];
            }];
        }
            break;
        case 6:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - HQTFTaskDetailTitleCellDelegate
-(void)taskDetailTitleCell:(HQTFTaskDetailTitleCell *)taskDetailTitleCell didDescriptionWithModel:(TFProjTaskModel *)model{
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    if ([self.taskDetail.taskPermission isEqualToNumber:@0]) {// 没权限
        [MBProgressHUD showError:@"您无权限" toView:KeyWindow];
        return;
    }
    if (taskDetailTitleCell.tag == 0x123) {
        
        HQTFProjectDescController *desc = [[HQTFProjectDescController alloc] init];
        desc.type = 4;
        desc.descString = self.taskDetail.descript;
        desc.isNoNecessary = YES;
        desc.descAction = ^(NSString *desc){
            
            self.taskDetail.descript = desc;
            self.projectTask.descript = desc;
            [self.projectBL requestUpdateProjTaskWithModel:self.projectTask];
        };
        [self.navigationController pushViewController:desc animated:YES];
    }
    
}

-(void)taskDetailTitleCell:(HQTFTaskDetailTitleCell *)taskDetailTitleCell didFinishBtn:(UIButton *)finishBtn withModel:(TFProjTaskModel *)model{
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    if ([self.taskDetail.taskPermission isEqualToNumber:@0]) {// 没权限
        [MBProgressHUD showError:@"您无权限" toView:KeyWindow];
        return;
    }
    
    if (taskDetailTitleCell.tag == 0x123) {
        if ([model.taskStatus isEqualToNumber:@1]) {// 完成
            
            [self taskDetailTitleCell:taskDetailTitleCell changeTaskStatusFinishBtn:finishBtn withModel:model];
        }else{// 未完成
            
            if ([model.isOverdue isEqualToNumber:@0]) {// 未超期
                
                [self taskDetailTitleCell:taskDetailTitleCell changeTaskStatusFinishBtn:finishBtn withModel:model];
            }else{// 超期
                
                if ([model.deadlineType isEqualToNumber:@2]) {// 时间点
                    
                    [self taskDetailTitleCell:taskDetailTitleCell changeTaskStatusFinishBtn:finishBtn withModel:model];
                }else{// 时间段
                    
                    if ([model.isHasApprove isEqualToNumber:@1]) {// 有审批
                        
                        if (![self.taskDetail.approvePermission isEqualToNumber:@0]) {// 有权限
                            // 跳转到审批
                            TFApprovalDetailMainController *approve = [[TFApprovalDetailMainController alloc] init];
                            approve.approvalId = model.approveId;
                            approve.taskId = model.id;
                            approve.approvalType = FunctionModelTypeTaskDeley;
                            [self.navigationController pushViewController:approve animated:YES];
                            
                        }else{// 没权限
                            [MBProgressHUD showError:@"您无权限" toView:KeyWindow];
                            return;
                        }
                        
                    }else{
                        
                        [self taskDetailTitleCell:taskDetailTitleCell changeTaskStatusFinishBtn:finishBtn withModel:model];
                    }
                }
            }
        }

    }else{// 子任务
        
        [self taskDetailTitleCell:taskDetailTitleCell changeTaskStatusFinishBtn:finishBtn withModel:model];
        
    }
    
}
- (void)taskDetailTitleCell:(HQTFTaskDetailTitleCell *)taskDetailTitleCell changeTaskStatusFinishBtn:(UIButton *)finishBtn withModel:(TFProjTaskModel *)model{
    
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    if ([self.taskDetail.taskPermission isEqualToNumber:@0]) {// 无权限
        
        [MBProgressHUD showError:@"您无权限" toView:KeyWindow];
        return;
    }
    
    if (taskDetailTitleCell.tag == 0x123) {// 任务
        
        model.taskStatus = finishBtn.selected?@0:@1;
        self.projectTask.taskStatus = model.taskStatus;
        
        if ([model.taskStatus isEqualToNumber:@0]) {
            self.projectTask.activeCount = @([self.projectTask.activeCount integerValue] + 1);
            
            NSNumber *num = @([self.projectSeeModel.listTaskFinishCount integerValue]-1);
            num = [num integerValue]<=0?@0:num;
            self.projectSeeModel.listTaskFinishCount = num;
            
        }else{
            NSNumber *total = self.projectSeeModel.listTaskCount;
            
            self.projectSeeModel.listTaskFinishCount = (([self.projectSeeModel.listTaskFinishCount integerValue]+1) >= [total integerValue])?total:@([self.projectSeeModel.listTaskFinishCount integerValue]+1);
        }
        
        [self.projectBL requestModTaskStatusWithTaskId:model.id isFinish:model.taskStatus];
        
    }else{// 子任务
        
        model.taskStatus = finishBtn.selected?@0:@1;
        
        if ([model.taskStatus isEqualToNumber:@0]) {
            
            NSNumber *num = @([self.taskDetail.subTaskFinishCount integerValue]-1);
            num = [num integerValue]<=0?@0:num;
            self.taskDetail.subTaskFinishCount = num;
        }else{
            
            NSInteger total = self.taskDetail.subtask.count;
            self.taskDetail.subTaskFinishCount = ([self.taskDetail.subTaskFinishCount integerValue]+1) >= total?@(total):@([self.taskDetail.subTaskFinishCount integerValue]+1);
        }
        
        [self.projectBL requestModTaskStatusWithTaskId:model.id isFinish:model.taskStatus];
    }
}

/** 计算某个时间点与今天相差 */
- (NSString *)caculeteTimeWithTimeSp:(long long)timeSp{
    
    //    HQLog(@"今天：%@====self.date:%@",[HQHelper getYearMonthDayHourMiuthWithDate:[NSDate date]],[HQHelper getYearMonthDayHourMiuthWithDate:self.date]);
    // 多少秒
    long long time = (timeSp-[HQHelper getNowTimeSp])/1000.0;
    
    time = ABS(time);
    
    CGFloat day = time/(24*60*60.0);
    
    NSInteger intDay = (NSInteger)day;
    
    CGFloat hour = (day - intDay)*24.0;
    
    NSInteger intHour = (NSInteger)hour;
    
    CGFloat minute = (hour - intHour)*60.0;
    
    NSInteger intMinute = (NSInteger)minute;
    
    NSString *str = [NSString stringWithFormat:@"%ld天  %ld小时  %ld分",intDay,intHour,intMinute];
    
    return str;
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
    if (resp.cmdId == HQCMD_getProjTaskDetail) {
        
        self.taskDetail = resp.body;
        
        self.projectTask.title = self.taskDetail.title;
        self.projectTask.descript = self.taskDetail.descript;
        
        
        for (TFProjLabelModel *label in self.taskDetail.labels) {
            label.id = label.labelId;
        }
        
        
        if (!self.projectSeeModel) {
            
            NSNumber *projectId = nil;
            
            if (self.projectTask.projectId) {
                projectId = self.projectTask.projectId;
            }else if (self.taskDetail.projectId){
                projectId = self.taskDetail.projectId;
            }
            
            if (!projectId) {
                [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
                [MBProgressHUD showError:@"此条数据有问题" toView:KeyWindow];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
            [self.projectBL requestGetProjectDetailWithProjectId:projectId];
        }else{
            
            [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
        }
        
        
        // 点赞是否选中
        self.toolBarContainer.toolbar.heartBtn.selected = (!self.taskDetail.myUpvoteId || [self.taskDetail.myUpvoteId isEqualToNumber:@0])?NO:YES ;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ProjetTaskHeartNotifition object:(!self.taskDetail.myUpvoteId || [self.taskDetail.myUpvoteId isEqualToNumber:@0])?@0:@1];
        
    }
    
    if (resp.cmdId == HQCMD_delProjTask) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DeleteProjetTaskNotifition object:self.taskDetail.id];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_updateProjTask) {
        
    }
    
    if (resp.cmdId == HQCMD_addTaskAttachs) {
//        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_updateTaskExcutor) {
        
        
        
    }
    
    if (resp.cmdId == HQCMD_updateTaskCollaborator) {
        
        
    }
    
    if (resp.cmdId == HQCMD_modTaskStatus) {
        
    }
    
    if (resp.cmdId == HQCMD_projectTaskUpvoteAdd) {
        
        HQEmployModel *model = resp.body;
        NSMutableArray<Optional,HQEmployModel> *arr = [NSMutableArray<Optional,HQEmployModel> arrayWithArray:self.taskDetail.taskUpvotes];
        [arr addObject:model];
        self.taskDetail.taskUpvotes = arr;
        self.taskDetail.myUpvoteId = model.id;
        [self.tableView reloadData];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:ProjetTaskHeartNotifition object:(!self.taskDetail.myUpvoteId || [self.taskDetail.myUpvoteId isEqualToNumber:@0])?@0:@1];
    }
    if (resp.cmdId == HQCMD_projectTaskUpvoteDelete) {
        
        NSMutableArray<Optional,HQEmployModel> *arr = [NSMutableArray<Optional,HQEmployModel> array];
        for (HQEmployModel *em in self.taskDetail.taskUpvotes) {
            
            if ([em.id isEqualToNumber:self.taskDetail.myUpvoteId]) {
                continue;
            }else{
                [arr addObject:em];
            }
        }
        
        self.taskDetail.taskUpvotes = arr;
        self.taskDetail.myUpvoteId = nil;
        [self.tableView reloadData];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:ProjetTaskHeartNotifition object:(!self.taskDetail.myUpvoteId || [self.taskDetail.myUpvoteId isEqualToNumber:@0])?@0:@1];
    }
    
    if (resp.cmdId == HQCMD_projectTaskApplyType) {
        
        NSDictionary *dict = resp.body;
        self.delayApproveId = [dict valueForKey:@"id"];
        
    }
    
    if (resp.cmdId == HQCMD_getProjectDetail) {
        
        [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
        self.projectSeeModel = [[TFProjectSeeModel alloc] init];
        TFProjectDetailModel *detail = resp.body;
        self.projectSeeModel.project = detail.project;
        
    }
    if (resp.cmdId == HQCMD_taskCooperationModify) {
        
    }
    
    if (resp.cmdId == HQCMD_taskFileInfoSave) {
        
    }
    [self.tableView reloadData];
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
//    [self.tableView.mj_footer endRefreshing];
//    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
    
//    if (resp.cmdId == HQCMD_projectTaskApplyType) {
//        
//        [self.projectBL requestTaskDeadlineApproveType];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
