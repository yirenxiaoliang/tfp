//
//  TFFileCommentController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFileCommentController.h"
#import "JCHATToolBar.h"
#import "HQTFNoContentView.h"
#import "JCHATMoreView.h"
#import "IQKeyboardManager.h"
#import "XHVoiceRecordHUD.h"
#import "XHVoiceRecordHelper.h"
#import "HQTFTaskDynamicCell.h"
#import "TFApprovalLogModel.h"
#import "HQTFTextImageChangeCell.h"
#import "ZYQAssetPickerController.h"
#import "KSPhotoBrowser.h"
#import "TFPlayVoiceController.h"

#import "TFFileBL.h"

#define MoreViewContainerHeight Long(120)

@interface TFFileCommentController ()<UITableViewDelegate,UITableViewDataSource,SendMessageDelegate,UITextViewDelegate,AddBtnDelegate,ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HQTFTaskDynamicCellDelegate,KSPhotoBrowserDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 输入框 */
@property (strong, nonatomic) JCHATToolBarContainer *toolBarContainer;
@property (strong, nonatomic) JCHATMoreViewContainer *moreViewContainer;

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


/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** 动态数组 */
@property (nonatomic, strong) NSMutableArray *dynamics;

/** 用于键盘升降 */
@property(assign, nonatomic) BOOL barBottomFlag;

/** 数据 */
@property (nonatomic, strong) TFTaskDynamicModel *dynamic;

/** open */
@property (nonatomic, assign) BOOL open;
/** 正常状态 */
@property (nonatomic, assign) BOOL normal;

@property (nonatomic, strong) TFFileBL *fileBL;


@end

@implementation TFFileCommentController

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

-(NSMutableArray *)dynamics{
    
    if (!_dynamics) {
        _dynamics = [NSMutableArray array];
        
        //        for (NSInteger i = 0; i < 4; i ++) {
        //
        //            TFTaskDynamicModel *model = [[TFTaskDynamicModel alloc] init];
        //
        //            model.dynamicContent = @"我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵";
        //            model.dynamicType = @(i) ;
        //            model.creatTime = @([HQHelper getNowTimeSp]);
        //            model.images = @[@"",@"",@"",@"",@"",@"",@""];
        //
        //            [_dynamics addObject:model];
        //        }
        
    }
    return _dynamics;
}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无动态"];
    }
    return _noContentView;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.open = NO;
    [self.toolBarContainer.toolbar drawRect:self.toolBarContainer.toolbar.frame];
    self.toolBarContainer.toolbar.heartShow = NO;
    
    [self addNotifation];
    
    IQKeyboardManager *keyBoard = [IQKeyboardManager sharedManager];
    keyBoard.enable = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
    _previousTextViewContentHeight = 31;
    
    [self setupTableView];

        
    [self setupToolBar];
    [self setupMoreView];
    [self.toolBarContainer.toolbar.textView addObserver:self
                                             forKeyPath:@"contentSize"
                                                options:NSKeyValueObservingOptionNew
                                                context:nil];
    
    self.toolBarContainer.toolbar.textView.delegate = self;
    [self.toolBarContainer.toolbar drawRect:self.toolBarContainer.toolbar.frame];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputJumpNotifition:) name:TFProjectTaskInputJumpNotifition object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normalStatus) name:TFProjectDynamicNormalpNotifition object:nil];

    
}


- (void)normalStatus{
    
    self.normal = NO;
}

- (void)inputJumpNotifition:(NSNotification *)noti{
    
    
    HQLog(@"%@",noti.object);
    
    if (noti.object) {//存在
        
        if ([noti.object isEqualToNumber:@0]) {// 语音
            [self.toolBarContainer.toolbar voiceBtnClick:self.toolBarContainer.toolbar.voiceButton];
        }else if ([noti.object isEqualToNumber:@1]){// 输入
            [self.toolBarContainer.toolbar.textView becomeFirstResponder];
        }else if ([noti.object isEqualToNumber:@2]){// 点赞
            
            self.toolBarContainer.toolbar.heartBtn.selected = !self.toolBarContainer.toolbar.heartBtn.selected;
            
            //            [[NSNotificationCenter defaultCenter] postNotificationName:TaskDynamicClickedHeartNotifition object:@(self.toolBarContainer.toolbar.heartBtn.selected)];
            
        }else{// 加号
            
            [self.toolBarContainer.toolbar addBtnClick:self.toolBarContainer.toolbar.addButton];
        }
        
    }
    
    
    self.normal = YES;
    
    self.tableView.top = SCREEN_HEIGHT;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.tableView.top = -30;
        self.tableView.contentInset = UIEdgeInsetsMake(-42, 0, 0, 0);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.tableView.top = 0;
        }];
    }];
    
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

- (void)photoClick{
    [self openAlbum];
}
- (void)cameraClick{
    
    [self openCamera];
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

- (void)setupToolBar{
    
    self.toolBarContainer = [[JCHATToolBarContainer alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - TabBarHeight, SCREEN_WIDTH, TabBarHeight)];
    self.toolBarContainer.toolbar.frame = self.toolBarContainer.bounds;
    [self.view addSubview:self.toolBarContainer];
    self.toolBarContainer.toolbar.delegate = self;
    self.toolBarContainer.toolbar.textView.delegate = self;
    [self.toolBarContainer.toolbar setUserInteractionEnabled:YES];
    self.toolBarContainer.toolbar.textView.placeHolderTextColor = kUIColorFromRGB(0xcacad0);
    self.toolBarContainer.toolbar.textView.placeHolder = @"说点什么...";
    
}

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
#pragma mark - 打开相册
- (void)openAlbum{
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 1 ; // 选择图片最大数量
    picker.assetsFilter = [ALAssetsFilter allPhotos]; // 可选择所有相册图片
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self.navigationController presentViewController:picker animated:YES completion:NULL];
}
#pragma mark - ZYQAssetPickerControllerDelegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        // 添加图片
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        NSString *fileName = [representation filename];
        HQLog(@"fileName : %@",fileName);
        
    //    [self.tableView reloadData];
    }
}

#pragma mark - 打开相机
- (void)openCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        //        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //    TFFileModel *model = [[TFFileModel alloc] init];
    //    model.fileName = @"这是一张自拍图";
    //    model.fileType = @"jpg";
    //    model.image = image;
    //    [self.files addObject:model];
    //
    //    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//
//
//- (void)didLookAtPhotoActionWithIndex:(NSInteger)index{
//
//    // 浏览图片
//    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//    browser.displayActionButton = NO; // 分享按钮,默认是
//    browser.alwaysShowControls = NO ; // 控制条件控件 是否显示,默认否
//    browser.zoomPhotosToFill = YES; // 是否全屏,默认是
//    browser.enableSwipeToDismiss = NO;
//    [browser showNextPhotoAnimated:NO];
//    [browser showPreviousPhotoAnimated:NO];
//    [browser setCurrentPhotoIndex:index];
//    browser.displayNavArrows = NO;
//    browser.displaySelectionButtons = NO;
//    browser.enableGrid = NO;
//    browser.startOnGrid = NO;
//    browser.autoPlayOnAppear = NO;
//    [self.navigationController pushViewController:browser animated:YES] ;
//}
//#pragma mark - 图片浏览器
//
///**
// * 标题
// */
//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index{
//    return [NSString stringWithFormat:@"%ld/%ld",index+1,self.images.count] ;
//}
//
///**
// * 图片总数量
// */
//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
//    return self.images.count;
//}
//
///**
// * 图片设置
// */
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
//    TFFileModel *model = self.images[index];
//    MWPhoto *mwPhoto = nil;
//
//    if (model.image) {
//        mwPhoto = [MWPhoto photoWithImage:model.image];
//    }else{
//        mwPhoto = [MWPhoto photoWithURL:[NSURL URLWithString:model.fileUrl]];
//    }
//
//    return mwPhoto;
//
//}
//

- (void)dropToolBarNoAnimate {
    
    _previousTextViewContentHeight = 31;
    _toolBarContainer.toolbar.addButton.selected = NO;
    
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
    
    if ([voiceDuration integerValue]<0.5) {
        if ([voiceDuration integerValue]<0.5) {
            HQLog(@"录音时长小于 0.5s");
        }
        return;
    }
    
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-TabBarHeight) style:UITableViewStylePlain];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(-42, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.backgroundView = [UIView new];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.dynamics.count == 0) {
        tableView.backgroundView = self.noContentView;
        self.noContentView.centerY = (self.tableView.height-Long(200))/2;
    }else{
        [self.noContentView removeFromSuperview];
    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dynamics.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        HQTFTextImageChangeCell *cell = [HQTFTextImageChangeCell textImageChangeCellWithTableView:tableView];
        cell.titleImg = @"动态1";
        cell.contentView.backgroundColor = BackGroudColor;
        cell.bottomLine.hidden = YES;
            
        cell.title = [NSString stringWithFormat:@"  评论  %ld条",self.dynamics.count];

        
        return cell;
    }
    
    HQTFTaskDynamicCell *cell = [HQTFTaskDynamicCell taskDynamicCellWithTableView:tableView];
    cell.delegate = self;
        
    [cell refreshApproveCellWithModel:self.dynamics[indexPath.row]];

    if (self.dynamics.count == indexPath.row + 1) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
    [self hiddenKeyboard];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 42;
    }
    
    return [HQTFTaskDynamicCell refreshApproveCellHeightWithModel:self.dynamics[indexPath.row]];

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
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
    
    [self hiddenKeyboard];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.normal) {
        return;
    }
    
    if (scrollView.contentOffset.y < -60 && !self.open) {
        
        self.open = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TFProjectDynamicDownJumpNotifition object:nil];
    }
    
}

#pragma mark - HQTFTaskDynamicCellDelegate
-(void)taskDynamicCell:(HQTFTaskDynamicCell *)taskDynamicCell didClickVoice:(TFFileModel *)model{
    
    TFPlayVoiceController *play = [[TFPlayVoiceController alloc] init];
    play.file = model;
    [self.navigationController pushViewController:play animated:YES];
    
}

-(void)taskDynamicCell:(HQTFTaskDynamicCell *)taskDynamicCell didClickImage:(UIImageView *)imageView{
    
    NSMutableArray *items = @[].mutableCopy;
    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView image:imageView.image];
    [items addObject:item];
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:0];
    browser.delegate = self;
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlurPhoto;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleDeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces = NO;
    [browser showFromViewController:self];
    
}

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index {
    HQLog(@"selected index: %ld", index);
}



@end
