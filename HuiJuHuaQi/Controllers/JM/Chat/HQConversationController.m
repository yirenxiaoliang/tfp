//
//  HQConversationController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/11/25.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQConversationController.h"
#import "JCHATMessageTableView.h"
#import "JCHATLoadMessageTableViewCell.h"
#import "JCHATChatModel.h"
#import "JCHATShowTimeCell.h"
#import "JCHATMessageTableViewCell.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "JCHATToolBar.h"
#import "JCHATSendMsgManager.h"
#import "IQKeyboardManager.h"
#import "UIImage+ResizeMagick.h"
#import "JCHATFileManager.h"
#import "XHVoiceRecordHUD.h"
#import "XHVoiceRecordHelper.h"
#import "JCHATMoreView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JCHATPhotoPickerViewController.h"
#import "JCHATPersonViewController.h"
#import "JCHATFriendDetailViewController.h"
#import "JCHATGroupDetailViewController.h"
#import "TFSingleChatDetailController.h"
#import "TFGroupChatDetailController.h"
#import "KSPhotoBrowser.h"
#import "TFLocationModel.h"
#import "TFChatPeopleInfoController.h"
#import "TFIMessageBL.h"
#import "HQEmployModel.h"
#import <QuickLook/QuickLook.h>
#import "FileManager.h"
#import "TFChatCustomModel.h"
#import "TFPlayVoiceController.h"
#import "HQBaseNavigationController.h"

#define MoreViewContainerHeight Long(120)
#define interval 60*2
@interface HQConversationController ()<UITableViewDataSource,
UITableViewDelegate,playVoiceDelegate,PictureDelegate,SendMessageDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,AddBtnDelegate,JCHATPhotoPickerViewControllerDelegate,KSPhotoBrowserDelegate,LocationDelegate,HQBLDelegate,QLPreviewControllerDelegate,QLPreviewControllerDataSource,UIDocumentInteractionControllerDelegate>
/** tableView */
@property (strong, nonatomic) JCHATMessageTableView *messageTableView;
/** 输入框 */
@property (strong, nonatomic) JCHATToolBarContainer *toolBarContainer;
/** 发送照片view */
@property (strong, nonatomic) JCHATMoreViewContainer *moreViewContainer;
/** 用于键盘升降 */
@property(assign, nonatomic) BOOL barBottomFlag;
/** allmessageIds */
@property (nonatomic, strong) NSMutableArray *allmessageIds;
/** 缓存所有的message model */
@property (nonatomic, strong) NSMutableDictionary *allMessageDic;
/** imgDataArr */
@property (nonatomic, strong) NSMutableArray *imgDataArr;
/** userArr */
@property (nonatomic, strong) NSMutableArray *userArr;
/** images */
@property (nonatomic, strong) NSMutableArray *images;


/** 是否是其他消息 */
@property (nonatomic, assign) BOOL isNoOtherMessage;
/** messageOffset */
@property (nonatomic, assign) NSInteger messageOffset;
/**
 *  记录旧的textView contentSize Heigth
 */
@property(nonatomic, assign) CGFloat previousTextViewContentHeight;
@property(nonatomic, assign) JPIMInputViewType textViewInputViewType;
/**
 *  记录键盘的 Height
 */
@property(nonatomic, assign) CGFloat keyBoardHeight;
/** 录音 */
@property(nonatomic, strong, readwrite) XHVoiceRecordHUD *voiceRecordHUD;

/**
 *  管理录音工具对象
 */
@property(nonatomic, strong) XHVoiceRecordHelper *voiceRecordHelper;

/** 该回话免打扰信息 */
@property (nonatomic, assign) BOOL isNoDisturb;

/** TFIMessageBL */
@property (nonatomic, strong) TFIMessageBL *messageBL;

/** HQEmployModel */
@property (nonatomic, strong) HQEmployModel *employee;

/** NSString *filePath */
@property (nonatomic, copy) NSString *filePath;

@end

@implementation HQConversationController
-(NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}
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

- (NSMutableArray *)allmessageIds{
    if (!_allmessageIds) {
        _allmessageIds = [NSMutableArray array];
    }
    return _allmessageIds;
}

-(NSMutableDictionary *)allMessageDic{
    if (!_allMessageDic) {
        _allMessageDic = [NSMutableDictionary dictionary];
    }
    return _allMessageDic;
}
-(NSMutableArray *)imgDataArr{
    if (!_imgDataArr) {
        _imgDataArr = [NSMutableArray array];
    }
    return _imgDataArr;
}
- (NSMutableArray *)userArr{
    if (!_userArr) {
        _userArr = [NSMutableArray array];
    }
    return _userArr;
}
//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    [self scrollToBottomAnimated:NO];
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.gruopType != 1) {
        [self.toolBarContainer.toolbar drawRect:self.toolBarContainer.toolbar.frame];
    }
    [self.conversation refreshTargetInfoFromServer:^(id resultObject, NSError *error) {
        [self.navigationController setNavigationBarHidden:NO];
        // 禁用 iOS7 返回手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        
        if (self.conversation.conversationType == kJMSGConversationTypeGroup) {
            [self updateGroupConversationTittle:nil];
        } else {
            self.title = [resultObject title];
        }
        [self.messageTableView reloadData];
    }];
    IQKeyboardManager *keyBoard = [IQKeyboardManager sharedManager];
    keyBoard.enable = NO;
    
    
    //给键盘注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(applicationDidEnterBackground)
//                                                 name:UIApplicationDidEnterBackgroundNotification
//                                               object:nil];
//    // 确认免打扰
//    [self confirmConservationDisturb];
    // 设置免打扰(当前页面不出现通知提醒)
    [self viewAppearNewsIsDisturb];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexColor(0xc8c8c8) size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
}



-(void)didBack:(UIButton *)sender{
    
    if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
        [[JCHATAudioPlayerHelper shareInstance] stopAudio];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
//    HQBaseNavigationController *base = (HQBaseNavigationController *)self.navigationController;
//    [base popController];
}

- (void)updateGroupConversationTittle:(JMSGGroup *)newGroup {
    JMSGGroup *group;
    if (newGroup == nil) {
        group = self.conversation.target;
    } else {
        group = newGroup;
    }
    
    if ([group.name isEqualToString:@""]) {
        self.title = @"群聊";
    } else {
        self.title = group.name;
    }
    if (self.gruopType != 1) {
        
        self.title = [NSString stringWithFormat:@"%@(%lu)",self.title,(unsigned long)[group.memberArray count]];
    }
    [self getGroupMemberListWithGetMessageFlag:NO];
    if (self.isConversationChange) {
        [self cleanMessageCache];
        [self getPageMessage];
        self.isConversationChange = NO;
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.conversation clearUnreadCount];
    [[JCHATAudioPlayerHelper shareInstance] stopAudio];
    [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
    IQKeyboardManager *keyBoard = [IQKeyboardManager sharedManager];
    keyBoard.enable = YES;
    
    [self.view endEditing:YES];
    // 取消监听
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIApplicationDidEnterBackgroundNotification
//                                                  object:nil];
    
    // 设置为原来的免打扰
    [self viewDisppearNewsIsDisturb];
    
}
/** 应用在该页面进入后台时，消息提醒 */
//- (void)applicationDidEnterBackground{
//    
//    // 设置免打扰(当前页面不出现通知提醒)
//    [self viewDisppearNewsIsDisturb];
//}

/** 确认回话免打扰 */
- (void)confirmConservationDisturb{
    if (_conversation.conversationType == kJMSGConversationTypeSingle) {
        JMSGUser * user = _conversation.target;
        if (user.isNoDisturb) {
            self.isNoDisturb = YES;
        }else{
            self.isNoDisturb = NO;
        }
       
    } else {
        JMSGGroup *group = _conversation.target;
        if (group.isNoDisturb) {
            self.isNoDisturb = YES;
        }else{
            self.isNoDisturb = NO;
        }
    
    }
}

/**
 *  在聊天时消息免打扰（在该聊天界面不应再通知提醒）
 */
- (void)viewAppearNewsIsDisturb{
    
    if (self.isNoDisturb == YES) {
        return;
    }else{
        if (_conversation.conversationType == kJMSGConversationTypeSingle) {
            JMSGUser * user = _conversation.target;
            [user setIsNoDisturb:YES handler:^(id resultObject, NSError *error) {
                if (error == nil) {
                    HQLog(@"消息免打扰！");
                }
            }];
        } else {
            JMSGGroup *group = _conversation.target;
            [group setIsNoDisturb:YES handler:^(id resultObject, NSError *error) {
                if (error == nil) {
                    HQLog(@"消息免打扰！");
                }
            }];
        }
    }
}
/**
 *  聊天界面消失时设置用户设置的免打扰模式
 */
- (void)viewDisppearNewsIsDisturb{
    
    if (_conversation.conversationType == kJMSGConversationTypeSingle) {
        JMSGUser * user = _conversation.target;
        [user setIsNoDisturb:self.isNoDisturb handler:^(id resultObject, NSError *error) {
            if (error == nil) {
                HQLog(@"消息免打扰！");
                [[NSNotificationCenter defaultCenter] postNotificationName:AsynchronizeFinishNotification object:nil];
            }
        }];
    } else {
        JMSGGroup *group = _conversation.target;
        [group setIsNoDisturb:self.isNoDisturb handler:^(id resultObject, NSError *error) {
            if (error == nil) {
                HQLog(@"消息免打扰！");
                [[NSNotificationCenter defaultCenter] postNotificationName:AsynchronizeFinishNotification object:nil];
            }
        }];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setFromNavBottomEdgeLayout];
    self.navigationItem.title = self.conversation.title;
    [self setupView];
    [self setupToolBar];
    [self setupMoreView];
    [self addNotification];
    [self addDelegate];
    [self getGroupMemberListWithGetMessageFlag:YES];
    self.messageBL = [TFIMessageBL build];
    self.messageBL.delegate = self;
    
    if (self.conversation.conversationType == kJMSGConversationTypeSingle) {
        JMSGUser *user = (JMSGUser *)_conversation.target;
        
        [self.messageBL employeeWithImUserName:user.username];
    }
    // 确认免打扰
    [self confirmConservationDisturb];
    // 设置免打扰(当前页面不出现通知提醒)
    [self viewAppearNewsIsDisturb];
}
#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_messageGetEmployee) {
        
        self.employee = resp.body;
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}


/** 初始化 */
- (void)setupView{
    [self setupNavigation];
    [self setupTableView];
}

- (void)setupToolBar{
    self.toolBarContainer = [[JCHATToolBarContainer alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - TabBarHeight, SCREEN_WIDTH, TabBarHeight)];
    self.toolBarContainer.toolbar.frame = self.toolBarContainer.bounds;
    [self.view addSubview:self.toolBarContainer];
    self.toolBarContainer.toolbar.delegate = self;
    self.toolBarContainer.toolbar.textView.delegate = self;
    [self.toolBarContainer.toolbar setUserInteractionEnabled:YES];
    self.toolBarContainer.toolbar.textView.text = [[JCHATSendMsgManager ins] draftStringWithConversation:self.conversation];
}

- (void)setupMoreView{
    self.moreViewContainer = [[JCHATMoreViewContainer alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, MoreViewContainerHeight)];
    
    if (self.conversation.conversationType == kJMSGConversationTypeSingle) {
        self.moreViewContainer.moreView.type = MoreViewTypeSingleChat;
    }else{
        self.moreViewContainer.moreView.type = MoreViewTypeGroupChat;
    }
    self.moreViewContainer.moreView.frame = self.moreViewContainer.bounds;
    [self.view addSubview:self.moreViewContainer];
    self.moreViewContainer.moreView.delegate = self;
    [self.moreViewContainer.moreView setUserInteractionEnabled:YES];
    _moreViewContainer.moreView.backgroundColor = BackGroudColor;
}
#pragma mark -调用相册
- (void)photoClick {
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        JCHATPhotoPickerViewController *photoPickerVC = [[JCHATPhotoPickerViewController alloc] init];
        photoPickerVC.photoDelegate = self;
        [self presentViewController:photoPickerVC animated:YES completion:NULL];
    } failureBlock:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有相册权限" message:@"请到设置页面获取相册权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

#pragma mark --调用相机
- (void)cameraClick {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        NSString *requiredMediaType = ( NSString *)kUTTypeImage;
//        NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
//        [picker setMediaTypes:arrMediaTypes];
        picker.showsCameraControls = YES;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker.editing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark -- 调用地图
-(void)locationClick{
//    HQTFSportController *location = [[HQTFSportController alloc] init];
//    location.locationAction = ^(TFLocationModel *location){
//
//        HQLog(@"===location===");
//        JMSGMessage *locationMessage = nil;
//        JCHATChatModel *model =[[JCHATChatModel alloc] init];
//        JMSGLocationContent *locationContent = [[JMSGLocationContent alloc] initWithLatitude:[NSNumber numberWithDouble:location.latitude] longitude:[NSNumber numberWithDouble:location.longitude] scale:@1 address:location.name];
//
//        locationMessage = [_conversation createMessageWithContent:locationContent];
//        [_conversation sendMessage:locationMessage];
//        [model setChatModelWith:locationMessage conversationType:_conversation];
//        [self addMessage:model];
//
//    };
//    [self.navigationController pushViewController:location animated:YES];
}

#pragma mark - 调用电话
-(void)telephoneClick{
    
    if (self.employee && self.employee.telephone && [HQHelper checkTel:self.employee.telephone]) {
        
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.employee.telephone];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[HQHelper URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
}

#pragma mark - HMPhotoPickerViewController Delegate
- (void)JCHATPhotoPickerViewController:(JCHATPhotoSelectViewController *)PhotoPickerVC selectedPhotoArray:(NSArray *)selected_photo_array {
    for (UIImage *image in selected_photo_array) {
        [self prepareImageMessage:image];
    }
    [self dropToolBarNoAnimate];
}

- (void)dropToolBarNoAnimate {
    
    _barBottomFlag =YES;
    _previousTextViewContentHeight = 31;
    _toolBarContainer.toolbar.addButton.selected = NO;
    [_messageTableView reloadData];
}


#pragma mark - UIImagePickerController Delegate
//相机,相册Finish的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.movie"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [MBProgressHUD showMessage:@"不支持视频发送" view:self.view];
        return;
    }
    UIImage *image;
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self prepareImageMessage:image];
    [self dropToolBarNoAnimate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --发送图片
- (void)prepareImageMessage:(UIImage *)img {
    HQLog(@"Action - prepareImageMessage");
    img = [img resizedImageByWidth:upLoadImgWidth];
    
    JMSGMessage* message = nil;
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    JMSGImageContent *imageContent = [[JMSGImageContent alloc] initWithImageData:UIImagePNGRepresentation(img)];
    if (imageContent) {
        message = [_conversation createMessageWithContent:imageContent];
        [[JCHATSendMsgManager ins] addMessage:message withConversation:_conversation];
        [self addmessageShowTimeData:message.timestamp];
        [model setChatModelWith:message conversationType:_conversation];
        [_imgDataArr addObject:model];
        model.photoIndex = [_imgDataArr count] - 1;
        [model setupImageSize];
        [self addMessage:model];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark --toolBarContainer delegate

- (void)inputTextViewWillBeginEditing:(JCHATMessageTextView *)messageInputTextView {
    _textViewInputViewType = JPIMInputViewTypeText;
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

- (void)inputTextViewDidChange:(JCHATMessageTextView *)messageInputTextView {
    [[JCHATSendMsgManager ins] updateConversation:self.conversation withDraft:messageInputTextView.text];
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
    
    self.messageTableView.contentInset = UIEdgeInsetsMake(0, 0, self.moreViewContainer.height + self.toolBarContainer.height - 49, 0);
    [self.toolBarContainer.toolbar switchToolbarToTextMode];
    [self scrollToEnd];
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
        self.messageTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
    [self scrollToEnd];
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
    HQLog(@"Action - prepareTextMessage");
    if ([text isEqualToString:@""] || text == nil) {
        return;
    }
    [[JCHATSendMsgManager ins] updateConversation:_conversation withDraft:@""];
    JMSGMessage *message = nil;
    JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:text];
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    
    message = [_conversation createMessageWithContent:textContent];//!
    [_conversation sendMessage:message];
    [self addmessageShowTimeData:message.timestamp];
    [model setChatModelWith:message conversationType:_conversation];
    [self addMessage:model];
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
    
    JMSGMessage *voiceMessage = nil;
    JCHATChatModel *model =[[JCHATChatModel alloc] init];
    JMSGVoiceContent *voiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:[NSData dataWithContentsOfFile:voicePath]
                                                                   voiceDuration:[NSNumber numberWithInteger:[voiceDuration integerValue]]];
    
    voiceMessage = [_conversation createMessageWithContent:voiceContent];
    [_conversation sendMessage:voiceMessage];
    [model setChatModelWith:voiceMessage conversationType:_conversation];
    [JCHATFileManager deleteFile:voicePath];
    [self addMessage:model];
}

#pragma mark - 导航栏
- (void)setupNavigation {
    self.navigationController.navigationBar.translucent = NO;
    
    if (self.gruopType == 1) {
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addFriends) image:@"个人资料" highlightImage:@"个人资料"];
    }else{
        
        if (self.conversation.conversationType == kJMSGConversationTypeSingle) {
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addFriends) image:@"个人资料" highlightImage:@"个人资料"];
        } else {
            [self updateGroupConversationTittle:nil];
            if ([((JMSGGroup *)_conversation.target) isMyselfGroupMember]) {
                
                self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addFriends) image:@"群资料" highlightImage:@"群资料"];
            } else {
                
                self.navigationItem.rightBarButtonItem = nil;
            }
        }
    }
    
    [_conversation clearUnreadCount];
    
}
#pragma mark --增加朋友
- (void)addFriends
{
    [self.view endEditing:YES];
    
    if (self.gruopType == 1) {
        
        TFSingleChatDetailController *single = [[TFSingleChatDetailController alloc] init];
        single.gruopType = self.gruopType;
        single.conversation = _conversation;
        
        single.refreshAction = ^{
            
            [self getGroupMemberListWithGetMessageFlag:YES];
        };
        [self.navigationController pushViewController:single animated:YES];
       
    }else{
        if (self.conversation.conversationType == kJMSGConversationTypeSingle) {
            TFSingleChatDetailController *single = [[TFSingleChatDetailController alloc] init];
            single.gruopType = self.gruopType;
            single.conversation = _conversation;
            
            single.refreshAction = ^{
                
                [self getGroupMemberListWithGetMessageFlag:YES];
            };
            [self.navigationController pushViewController:single animated:YES];
            
        } else {
            TFGroupChatDetailController *group = [[TFGroupChatDetailController alloc] init];
            group.gruopType = self.gruopType;
            group.conversation = _conversation;
            group.refreshAction = ^{
                
                [self getGroupMemberListWithGetMessageFlag:YES];
            };
            [self.navigationController pushViewController:group animated:YES];
        }
    }
    
  

//    JCHATGroupDetailViewController *groupDetailCtl = [[JCHATGroupDetailViewController alloc] init];
//    groupDetailCtl.hidesBottomBarWhenPushed = YES;
//    groupDetailCtl.conversation = _conversation;
//    groupDetailCtl.sendMessageCtl = self;
//    [self.navigationController pushViewController:groupDetailCtl animated:YES];
}

- (void)getGroupMemberListWithGetMessageFlag:(BOOL)getMesageFlag {
    if (self.conversation && self.conversation.conversationType == kJMSGConversationTypeGroup) {
        JMSGGroup *group = nil;
        group = self.conversation.target;
        self.userArr = [NSMutableArray arrayWithArray:[group memberArray]];
        [self isContantMeWithUserArr:self.userArr];
        if (getMesageFlag) {
            [self getPageMessage];
        }
    } else {
        if (getMesageFlag) {
            [self getPageMessage];
        }
//        [self hidenDetailBtn:NO];
    }
}

- (void)isContantMeWithUserArr:(NSMutableArray *)userArr {
    BOOL hideFlag = YES;
    for (NSInteger i =0; i< [userArr count]; i++) {
        JMSGUser *user = [userArr objectAtIndex:i];
        if ([user.username isEqualToString:[JMSGUser myInfo].username]) {
            hideFlag = NO;
            break;
        }
    }
//    [self hidenDetailBtn:hideFlag];
}

- (void)getPageMessage {
    HQLog(@"Action - getAllMessage");
    [self cleanMessageCache];
    NSMutableArray * arrList = [[NSMutableArray alloc] init];
    [self.allmessageIds addObject:[[NSObject alloc] init]];
    
    self.messageOffset = messagefristPageNumber;
    [arrList addObjectsFromArray:[[[self.conversation messageArrayFromNewestWithOffset:@0 limit:@(self.messageOffset)] reverseObjectEnumerator] allObjects]];
    if ([arrList count] < messagefristPageNumber) {
        self.isNoOtherMessage = YES;
        [self.allmessageIds removeObjectAtIndex:0];
    }
    
    for (NSInteger i=0; i< [arrList count]; i++) {
        JMSGMessage *message = [arrList objectAtIndex:i];
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setChatModelWith:message conversationType:self.conversation];
        if (message.contentType == kJMSGContentTypeImage) {
            [self.imgDataArr addObject:model];
            model.photoIndex = [self.imgDataArr count] - 1;
        }
        
        [self dataMessageShowTime:message.timestamp];
        [self.allMessageDic setObject:model forKey:model.message.msgId];
        [self.allmessageIds addObject:model.message.msgId];
    }
    [self.messageTableView reloadData];
    [self scrollToBottomAnimated:NO];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    
    NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
    
    if (rows > 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.allmessageIds count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}
#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (void)dataMessageShowTime:(NSNumber *)timeNumber{
    NSString *messageId = [self.allmessageIds lastObject];
    JCHATChatModel *lastModel = self.allMessageDic[messageId];
    NSTimeInterval timeInterVal = [timeNumber longLongValue];
    
    // 时间为毫秒时，转换成秒
    if (timeInterVal > 1999999999) {
        timeInterVal = floor(timeInterVal / 1000);
    }
    if ([lastModel.messageTime longLongValue] > 1999999999) {
        lastModel.messageTime = [NSNumber numberWithLongLong:floor([lastModel.messageTime longLongValue] / 1000)];
    }
    if ([self.allmessageIds count]>0 && lastModel.isTime == NO) {
        NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime longLongValue]];
        NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
        NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
        if (fabs(timeBetween) > interval) {
            JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
            timeModel.timeId = [self getTimeId];
            timeModel.isTime = YES;
            timeModel.messageTime = @(timeInterVal);
            timeModel.contentHeight = [timeModel getTextHeight];//!
            [self.allMessageDic setObject:timeModel forKey:timeModel.timeId];
            [self.allmessageIds addObject:timeModel.timeId];
        }
    } else if ([self.allmessageIds count] ==0) {//首条消息显示时间
        JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
        timeModel.timeId = [self getTimeId];
        timeModel.isTime = YES;
        timeModel.messageTime = @(timeInterVal);
        timeModel.contentHeight = [timeModel getTextHeight];//!
        [self.allMessageDic setObject:timeModel forKey:timeModel.timeId];
        [self.allmessageIds addObject:timeModel.timeId];
    } else {
        HQLog(@"不用显示时间");
    }
}

#pragma mark -- 清空消息缓存
- (void)cleanMessageCache {
    [self.allMessageDic removeAllObjects];
    [self.allmessageIds removeAllObjects];
    [self.messageTableView reloadData];
}

#pragma mark --add Delegate
- (void)addDelegate {
    [JMessage addDelegate:self withConversation:self.conversation];
}

#pragma mark --JMessageDelegate
- (void)onSendMessageResponse:(JMSGMessage *)message
                        error:(NSError *)error {
    HQLog(@"Event - sendMessageResponse");
    [self relayoutTableCellWithMsgId:message.msgId];
    
    if (message != nil) {
        NSLog(@"发送的 Message:  %@",message);
    }
    
    if (error != nil) {
        HQLog(@"Send response error - %@", error);
        [_conversation clearUnreadCount];
        NSString *alert = [JCHATStringUtils errorAlert:error];
        if (alert == nil) {
            alert = [error description];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:alert toView:self.view];
        return;
    }
    JCHATChatModel *model = _allMessageDic[message.msgId];
    if (!model) {
        return;
    }
}

#pragma mark --收到消息
- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error {
    if (message != nil) {
        HQLog(@"收到的message: %@",message);
    }
    if (error != nil) {
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setErrorMessageChatModelWithError:error];
        [self addMessage:model];
        return;
    }
    
    if (![self.conversation isMessageForThisConversation:message]) {
        return;
    }
    
    if (message.contentType == kJMSGContentTypeCustom) {
        return;
    }
    HQLog(@"Event - receiveMessageNotification");
    JCHATMAINTHREAD((^{
        if (!message) {
            HQLog(@"get the nil message .");
            return;
        }
        
        if (_allMessageDic[message.msgId] != nil) {
            HQLog(@"该条消息已加载");
            return;
        }
        
        if (message.contentType == kJMSGContentTypeEventNotification) {
            if (((JMSGEventContent *)message.content).eventType == kJMSGEventNotificationRemoveGroupMembers
                && ![((JMSGGroup *)_conversation.target) isMyselfGroupMember]) {
                [self setupNavigation];
            }
        }
        
        if (_conversation.conversationType == kJMSGConversationTypeSingle) {
        } else if (![((JMSGGroup *)_conversation.target).gid isEqualToString:((JMSGGroup *)message.target).gid]){
            return;
        }
        
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setChatModelWith:message conversationType:_conversation];
        if (message.contentType == kJMSGContentTypeImage) {
            [_imgDataArr addObject:model];
        }
        model.photoIndex = [_imgDataArr count] -1;
        [self addmessageShowTimeData:message.timestamp];
        [self addMessage:model];
    }));
}
#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (void)addmessageShowTimeData:(NSNumber *)timeNumber{
    NSString *messageId = [self.allmessageIds lastObject];
    JCHATChatModel *lastModel = self.allMessageDic[messageId];
    NSTimeInterval timeInterVal = [timeNumber longLongValue];
    
    // 时间为毫秒时，转换成秒
    if (timeInterVal > 1999999999) {
        timeInterVal = floor(timeInterVal / 1000);
    }
    if ([lastModel.messageTime longLongValue] > 1999999999) {
        lastModel.messageTime = [NSNumber numberWithLongLong:floor([lastModel.messageTime longLongValue] / 1000)];
    }
    if ([self.allmessageIds count] > 0 && lastModel.isTime == NO) {
        
        NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime longLongValue]];
        NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
        NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
        if (fabs(timeBetween) > interval) {
            [self addTimeData:timeInterVal];
        }
    } else if ([self.allmessageIds count] == 0) {//首条消息显示时间
        [self addTimeData:timeInterVal];
    } else {
        HQLog(@"不用显示时间");
    }
}
- (void)addTimeData:(NSTimeInterval)timeInterVal {
    JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
    timeModel.timeId = [self getTimeId];
    timeModel.isTime = YES;
    timeModel.messageTime = @(timeInterVal);
    timeModel.contentHeight = [timeModel getTextHeight];//!
    [self addMessage:timeModel];
}

- (void)onReceiveMessageDownloadFailed:(JMSGMessage *)message {
    if (![self.conversation isMessageForThisConversation:message]) {
        return;
    }
    
    HQLog(@"Event - receiveMessageNotification");
    JCHATMAINTHREAD((^{
        if (!message) {
            HQLog(@"get the nil message .");
            return;
        }
        
        if (self.conversation.conversationType == kJMSGConversationTypeSingle) {
        } else if (![((JMSGGroup *)self.conversation.target).gid isEqualToString:((JMSGGroup *)message.target).gid]){
            return;
        }
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setChatModelWith:message conversationType:self.conversation];
        if (message.contentType == kJMSGContentTypeImage) {
            [self.imgDataArr addObject:model];
        }
        model.photoIndex = [self.imgDataArr count] -1;
        [self addmessageShowTimeData:message.timestamp];
        [self addMessage:model];
    }));
}

- (void)relayoutTableCellWithMsgId:(NSString *) messageId{
    if ([messageId isEqualToString:@""]) {
        return;
    }
    NSInteger index = [self.allmessageIds indexOfObject:messageId];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    JCHATMessageTableViewCell *tableviewcell = [self.messageTableView cellForRowAtIndexPath:indexPath];
    [tableviewcell layoutAllView];
}
#pragma mark --添加message
- (void)addMessage:(JCHATChatModel *)model {
    if (model.isTime) {
        [self.allMessageDic setObject:model forKey:model.timeId];
        [self.allmessageIds addObject:model.timeId];
        [self addCellToTabel];
        return;
    }
    [self.allMessageDic setObject:model forKey:model.message.msgId];
    [self.allmessageIds addObject:model.message.msgId];
    [self addCellToTabel];
}

#pragma mark -- 刷新对应的
- (void)addCellToTabel {
    NSIndexPath *path = [NSIndexPath indexPathForRow:[self.allmessageIds count]-1 inSection:0];
    [_messageTableView beginUpdates];
    [_messageTableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    [_messageTableView endUpdates];
    [self scrollToEnd];
}


#pragma mark --加载通知
- (void)addNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cleanMessageCache)
                                                 name:kDeleteAllMessage
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AlertToSendImage:)
                                                 name:kAlertToSendImage
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteMessage:)
                                                 name:kDeleteMessage
                                               object:nil];
    
    [self.toolBarContainer.toolbar.textView addObserver:self
                                             forKeyPath:@"contentSize"
                                                options:NSKeyValueObservingOptionNew
                                                context:nil];
    self.toolBarContainer.toolbar.textView.delegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isDisturbNotifition:)
                                                 name:IsDisturbNotifition
                                               object:nil];
    
}

- (void)isDisturbNotifition:(NSNotification *)note{
    
    self.isNoDisturb = [note.object boolValue];
}


#pragma mark --释放内存
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.toolBarContainer.toolbar.textView removeObserver:self forKeyPath:@"contentSize"];
    
    [JMessage removeDelegate:self withConversation:_conversation];
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


#pragma mark - UITextView Helper Method
- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - Layout Message Input View Helper Method

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
        
        [self scrollToEnd];// 滚动到最后
        
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

#pragma mark - Scroll Message TableView Helper Method

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
    self.messageTableView.contentInset = UIEdgeInsetsMake(0, 0, bottom, 0);
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
        self.moreViewContainer.top = SCREEN_HEIGHT - 64 - keyBoardFrame.size.height;
        self.messageTableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardFrame.size.height + self.toolBarContainer.height - 49, 0);
    }];
    
    [self scrollToEnd];//!
}

- (void)inputKeyboardWillHide:(NSNotification *)notification {
    
    [self tapClick:nil];
    
    if (_barBottomFlag == NO) {
        return;
    }
    
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        
        self.toolBarContainer.bottom = SCREEN_HEIGHT - 64;
        self.moreViewContainer.top = SCREEN_HEIGHT - 64;
        self.messageTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
    [self scrollToBottomAnimated:NO];
}

- (void)AlertToSendImage:(NSNotification *)notification {
    UIImage *img = notification.object;
    [self prepareImageMessage:img];
}

- (void)deleteMessage:(NSNotification *)notification {
    JMSGMessage *message = notification.object;
    [self.conversation deleteMessageWithMessageId:message.msgId];
    [self.allMessageDic removeObjectForKey:message.msgId];
    [self.allmessageIds removeObject:message.msgId];
    [self.messageTableView loadMoreMessage];
}


#pragma mark --滑动至尾端
- (void)scrollToEnd {
    if ([self.allmessageIds count] != 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.allmessageIds count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];//!UITableViewScrollPositionBottom
    }
}

- (void)setupTableView {
    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.view addGestureRecognizer:gesture];
    [self.view setBackgroundColor:BackGroudColor];
    _messageTableView = [[JCHATMessageTableView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT - 64 - 49} style:UITableViewStylePlain];
    _messageTableView.userInteractionEnabled = YES;
    _messageTableView.showsVerticalScrollIndicator = NO;
    _messageTableView.delegate = self;
    _messageTableView.dataSource = self;
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _messageTableView.backgroundColor = BackGroudColor;
    [self.view addSubview:_messageTableView];
}
- (void)tapClick:(UIGestureRecognizer *)gesture {
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.toolBarContainer.bottom = SCREEN_HEIGHT - 64;
        self.moreViewContainer.top = SCREEN_HEIGHT - 64;
        self.messageTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
//    [self scrollToBottomAnimated:NO];
    self.toolBarContainer.toolbar.addButton.selected = NO;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allmessageIds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isNoOtherMessage) {
        if (indexPath.row == 0) {
            static NSString *cellLoadIdentifier = @"loadCell"; //name
            JCHATLoadMessageTableViewCell *cell = (JCHATLoadMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellLoadIdentifier];
            
            if (cell == nil) {
                cell = [[JCHATLoadMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellLoadIdentifier];
            }
            [cell startLoading];
            [self performSelector:@selector(flashToLoadMessage) withObject:nil afterDelay:0];
            return cell;
        }
    }
    NSString *messageId = self.allmessageIds[indexPath.row];
    if (!messageId) {
        HQLog(@"messageId is nil%@",messageId);
        return nil;
    }
    
    JCHATChatModel *model = self.allMessageDic[messageId];
    if (!model) {
        HQLog(@"JCHATChatModel is nil%@", messageId);
        return nil;
    }
    
    if (model.isTime == YES || model.message.contentType == kJMSGContentTypeEventNotification || model.isErrorMessage) {
        static NSString *cellIdentifier = @"timeCell";
        JCHATShowTimeCell *cell = (JCHATShowTimeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATShowTimeCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (model.isErrorMessage) {
            cell.messageTimeLabel.text = [NSString stringWithFormat:@"%@ 错误码:%ld",st_receiveErrorMessageDes,model.messageError.code];
            return cell;
        }
        
        if (model.message.contentType == kJMSGContentTypeEventNotification) {
            cell.messageTimeLabel.text = [((JMSGEventContent *)model.message.content) showEventNotification];
        } else {
            cell.messageTimeLabel.text = [JCHATStringUtils getFriendlyDateString:[model.messageTime longLongValue]];
        }
        return cell;
        
    } else {
        static NSString *cellIdentifier = @"MessageCell";
        JCHATMessageTableViewCell *cell = (JCHATMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[JCHATMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.conversation = self.conversation;
        }
        
        [cell setCellData:model delegate:self indexPath:indexPath];
        cell.headView.contentMode = UIViewContentModeScaleAspectFill;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isNoOtherMessage) {
        if (indexPath.row == 0) { //这个是第 0 行 用于刷新
            return 40;
        }
    }
    NSString *messageId = self.allmessageIds[indexPath.row];
    JCHATChatModel *model = self.allMessageDic[messageId];
    if (model.isTime == YES) {
        return 31;
    }
    
    if (model.message.contentType == kJMSGContentTypeEventNotification) {
        return model.contentHeight + 20;
    }
    
    if (model.message.contentType == kJMSGContentTypeText) {
        return model.contentHeight + 20;
    } else if (model.message.contentType == kJMSGContentTypeImage) {
        
        if (model.imageSize.height == 0) {
            [model setupImageSize];
        }
         CGFloat height = (model.imageSize.height < 44?60:model.imageSize.height + 20);
        if (model.conversation.conversationType == kJMSGConversationTypeGroup) {
            
            if ([model.message isReceived]) {
                return GroupChatNameViewHeight + height;
            }
        }
        return height;
        
    } else if (model.message.contentType == kJMSGContentTypeVoice) {
       
        if (model.conversation.conversationType == kJMSGConversationTypeGroup) {
            
            if ([model.message isReceived]) {
                return GroupChatNameViewHeight + 60 ;
            }
        }
        return 60 ;
    } else {
        return model.contentSize.height + 40;
    }
}
#pragma mark -PlayVoiceDelegate

- (void)successionalPlayVoice:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if ([self.allmessageIds count] - 1 > indexPath.row) {
        NSString *messageId = self.allmessageIds[indexPath.row + 1];
        JCHATChatModel *model = self.allMessageDic[ messageId];
        
        if (model.message.contentType == kJMSGContentTypeVoice && model.message.flag) {
            JCHATMessageTableViewCell *voiceCell =(JCHATMessageTableViewCell *)[self.messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
            [voiceCell playVoice];
        }
    }
}

- (void)setMessageIDWithMessage:(JMSGMessage *)message chatModel:(JCHATChatModel * __strong *)chatModel index:(NSInteger)index {
    [self.allMessageDic removeObjectForKey:(*chatModel).message.msgId];
    [self.allMessageDic setObject:*chatModel forKey:message.msgId];
    
    if ([self.allmessageIds count] > index) {
        [self.allmessageIds removeObjectAtIndex:index];
        [self.allmessageIds insertObject:message.msgId atIndex:index];
    }
}

- (void)selectHeadView:(JCHATChatModel *)model {
    if (!model.message.fromUser) {
        [MBProgressHUD showMessage:@"该用户为API用户" view:self.view];
        return;
    }
    
    [self.view endEditing:YES];
    
//    if (![model.message isReceived]) {
//        
//        JCHATPersonViewController *personCtl =[[JCHATPersonViewController alloc] init];
//        personCtl.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:personCtl animated:YES];
//    } else {
//        JCHATFriendDetailViewController *friendCtl = [[JCHATFriendDetailViewController alloc]initWithNibName:@"JCHATFriendDetailViewController" bundle:nil];
//        if (self.conversation.conversationType == kJMSGConversationTypeSingle) {
//            friendCtl.userInfo = model.message.fromUser;
//            friendCtl.isGroupFlag = NO;
//        } else {
//            friendCtl.userInfo = model.message.fromUser;
//            friendCtl.isGroupFlag = YES;
//        }
//        
//        [self.navigationController pushViewController:friendCtl animated:YES];
//    }
    
    
    if (![model.message isReceived]) {// 自己
        
        TFChatPeopleInfoController *peopleInfo = [[TFChatPeopleInfoController alloc] init];
        peopleInfo.jmsUser = model.message.fromUser;
        peopleInfo.isMyself = YES;
        [self.navigationController pushViewController:peopleInfo animated:YES];
        
    } else {// 别人
        
        TFChatPeopleInfoController *peopleInfo = [[TFChatPeopleInfoController alloc] init];
        peopleInfo.jmsUser = model.message.fromUser;
        peopleInfo.isMyself = NO;
        [self.navigationController pushViewController:peopleInfo animated:YES];
        
    }
}

#pragma mark -连续播放语音
- (void)getContinuePlay:(UITableViewCell *)cell
              indexPath:(NSIndexPath *)indexPath {
    JCHATMessageTableViewCell *tempCell = (JCHATMessageTableViewCell *) cell;
    if ([self.allmessageIds count] - 1 > indexPath.row) {
        NSString *messageId = self.allmessageIds[indexPath.row + 1];
        JCHATChatModel *model = self.allMessageDic[ messageId];
        if (model.message.contentType == kJMSGContentTypeVoice && [model.message.flag isEqualToNumber:@(0)] && [model.message isReceived]) {
            if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
                tempCell.continuePlayer = NO;
            }else {
                tempCell.continuePlayer = YES;
            }
        }
    }
}

#pragma mark 预览图片 PictureDelegate
//PictureDelegate
- (void)tapPicture:(NSIndexPath *)index tapView:(UIImageView *)tapView tableViewCell:(UITableViewCell *)tableViewCell {
    [self.view endEditing:YES];
    
    JCHATMessageTableViewCell *cell =(JCHATMessageTableViewCell *)tableViewCell;
    NSInteger count = _imgDataArr.count;
    
//    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
//    for (int i = 0; i<count; i++) {
//        JCHATChatModel *messageObject = [_imgDataArr objectAtIndex:i];
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.message = messageObject;
//        photo.srcImageView = tapView; // 来源于哪个UIImageView
//        [photos addObject:photo];
//    }
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = [_imgDataArr indexOfObject:cell.model];
//    //  browser.currentPhotoIndex = cell.model.photoIndex; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    browser.conversation =_conversation;
//    [browser show];
    
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < count; i++) {
        JCHATChatModel *messageObject = [_imgDataArr objectAtIndex:i];
        
        JMSGImageContent *content = (JMSGImageContent *)messageObject.message.content;
        KSPhotoItem *item = [[KSPhotoItem alloc] init];
        item.messageObject = content;
        UIImageView *imageView = [[UIImageView alloc] init];
        if ([_imgDataArr indexOfObject:cell.model] == i) {
            imageView = tapView;
            item = [KSPhotoItem itemWithSourceView:imageView image:imageView.image];
        }
        [items addObject:item];
    }
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:[_imgDataArr indexOfObject:cell.model]];
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

#pragma mark - LocationDelegate
-(void)tapLocation:(NSIndexPath *)index tapView:(UIImageView *)tapView tableViewCell:(UITableViewCell *)tableViewCell{
    
    
    JCHATMessageTableViewCell *cell =(JCHATMessageTableViewCell *)tableViewCell;
    JCHATChatModel *model = cell.model;
    
    JMSGLocationContent *location = (JMSGLocationContent *)model.message.content;
    
    // 查看地图
//    HQTFSportController *locationVc = [[HQTFSportController alloc] init];
//    locationVc.location = (CLLocationCoordinate2D){[location.latitude doubleValue],[location.longitude doubleValue]};
//    locationVc.type = LocationTypeLookLocation;
//    [self.navigationController pushViewController:locationVc animated:YES];
    
}

#pragma mark - FileDelegate
- (void)tapFile:(NSIndexPath *)index
        tapView:(UIImageView *)tapView
  tableViewCell:(UITableViewCell *)tableViewCell{
    
    JCHATMessageTableViewCell *cell =(JCHATMessageTableViewCell *)tableViewCell;
    JCHATChatModel *model = cell.model;
    
    JMSGFileContent *file = (JMSGFileContent *)model.message.content;
    [file fileData:^(NSData *data, NSString *objectId, NSError *error) {
        
        // 临时文件夹
        NSString *tmpPath = [FileManager dirTmp];
        // 创建文件路径
        NSString *filePath = [FileManager createFile:file.fileName forPath:tmpPath];
        self.filePath = filePath;
        // 将文件写入该路径
        
        BOOL pass = [data writeToFile:filePath atomically:YES];
//        BOOL pass = [FileManager writeFile:filePath text:file];
        
        if (pass) {// 写入成功
            
//            QLPreviewController *myQlPreViewController = [[QLPreviewController alloc]init];
//            
//            myQlPreViewController.delegate = self;
//            
//            myQlPreViewController.dataSource = self;
//            
//            [myQlPreViewController setCurrentPreviewItemIndex:0];
//            
//            [self presentViewController:myQlPreViewController animated:YES completion:nil];
////            [self.navigationController pushViewController:myQlPreViewController animated:YES];
            
            UIDocumentInteractionController *ctrl = [UIDocumentInteractionController  interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
            ctrl.delegate = self;
            [ctrl presentPreviewAnimated:YES];
        }
        
    }];
    
}


#pragma mark - CustomDelegate
- (void)tapCustom:(NSIndexPath *)index
          tapView:(UIImageView *)tapView
    tableViewCell:(UITableViewCell *)tableViewCell{
    
    
    JCHATMessageTableViewCell *cell =(JCHATMessageTableViewCell *)tableViewCell;
    JCHATChatModel *chatmodel = cell.model;
    
    JMSGCustomContent *custom = (JMSGCustomContent *)chatmodel.message.content;
    TFChatCustomModel *customModel = [[TFChatCustomModel alloc] initWithDictionary:custom.customDictionary error:nil];
    
    if ([customModel.type isEqualToNumber:@1111]) {
        
        //        TFFileModel *model = customModel.file;
        TFFileModel *model = [[TFFileModel alloc] init];
        model.file_url = customModel.fileUrl;
        model.file_size = customModel.fileSize;
        model.file_name = customModel.fileName;
        model.file_type = customModel.fileType;
        if ([[model.file_type lowercaseString] isEqualToString:@"jpg"] || [[model.file_type lowercaseString] isEqualToString:@"png"] || [[model.file_type lowercaseString] isEqualToString:@"gif"] || [[model.file_type lowercaseString] isEqualToString:@"jpeg"]) {// 查看图片
            
            
            [self.images removeAllObjects];
            
            if ([model.file_type integerValue] == 0) {
                
                [self.images addObject:model];
            }
            
            [self didLookAtPhotoActionWithFileModel:model tapView:tapView];
            
        }else if ([[model.file_type lowercaseString] isEqualToString:@"doc"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"docx"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"exl"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"exls"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"ppt"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"ai"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"cdr"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"dwg"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"ps"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"txt"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"pdf"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"zip"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"rar"]){
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [HQHelper cacheFileWithUrl:model.file_url fileName:model.file_name completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (error == nil) {
                    
                    // 保存文件
                    NSString *filePath = [HQHelper saveCacheFileWithFileName:model.file_name data:data];
                    
                    if (filePath) {// 写入成功
                        
                        UIDocumentInteractionController *ctrl = [UIDocumentInteractionController  interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
                        ctrl.delegate = self;
                        [ctrl presentPreviewAnimated:YES];
                    }
                    
                }else{
                    [MBProgressHUD showError:@"读取文件失败" toView:self.view];
                }
                
            } fileHandler:^(NSString *path) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                UIDocumentInteractionController *ctrl = [UIDocumentInteractionController  interactionControllerWithURL:[NSURL fileURLWithPath:path]];
                ctrl.delegate = self;
                [ctrl presentPreviewAnimated:YES];
            }];
            
        }else if ([[model.file_type lowercaseString] isEqualToString:@"mp3"] || [[model.file_type lowercaseString] isEqualToString:@"amr"]){
            
            
            TFPlayVoiceController *play = [[TFPlayVoiceController alloc] init];
            play.file = model;
            [self.navigationController pushViewController:play animated:YES];
            
        }else{
            
            [MBProgressHUD showError:@"未知文件无法预览" toView:self.view];
        }
        
    }
    else{// 链接
        
        if ([customModel.type isEqualToNumber:@1110]) {// 任务
            
//            HQTFTaskMainController *taskMain = [[HQTFTaskMainController alloc] init];
//            TFProjTaskModel *model = [[TFProjTaskModel alloc] init];
//            model.id = customModel.id;
//            taskMain.projectTask = model;
//            
//            [self.navigationController pushViewController:taskMain animated:YES];
        }
        else if ([customModel.type isEqualToNumber:@1114]) { //日程
        
//            HQDetailAndDynamiocBarVC *scheduleVC = [[HQDetailAndDynamiocBarVC alloc] init];
//            
//            scheduleVC.scheId = customModel.id;
//            
//            [self.navigationController pushViewController:scheduleVC animated:YES];
        }
        else if ([customModel.type isEqualToNumber:@1117]) { //工作汇报
            
//            YPDayAndWeekBarController *workReportVC = [[YPDayAndWeekBarController alloc] init];
//            
//            workReportVC.dailyMainId = [NSString stringWithFormat:@"%@",customModel.id];
//            workReportVC.isPlan = customModel.reportType;
//            workReportVC.type = customModel.workType;
//            workReportVC.isAprroved = customModel.isReport;
//            [self.navigationController pushViewController:workReportVC animated:YES];
        }else if ([customModel.type isEqualToNumber:@1113]){
            
//            TFApprovalDetailMainController *approval = [[TFApprovalDetailMainController alloc] init];
//            //        TFApprovalItemModel *model = [[TFApprovalItemModel alloc] init];
//            approval.approvalId = customModel.id;
//            //        approval.approvalType = (FunctionModelType)(FunctionModelTypeAll + [model.type integerValue]);
//            [self.navigationController pushViewController:approval animated:YES];
        }
    }

}

- (void)didLookAtPhotoActionWithFileModel:(TFFileModel *)model tapView:(UIImageView *)tapView{
    
    // 浏览图片
    NSMutableArray *items = @[].mutableCopy;
    
//    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:tapView image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[HQHelper URLWithString:model.fileUrl]]]];
    
    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:tapView imageUrl:[HQHelper URLWithString:model.file_url]];
    
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


#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}


- (id)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:self.filePath]; //返回文件路径
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



#pragma mark --获取所有发送消息图片
- (NSArray *)getAllMessagePhotoImg {
    NSMutableArray *urlArr =[NSMutableArray array];
    for (NSInteger i=0; i<[self.allmessageIds count]; i++) {
        NSString *messageId = self.allmessageIds[i];
        JCHATChatModel *model = _allMessageDic[messageId];
        if (model.message.contentType == kJMSGContentTypeImage) {
            [urlArr addObject:((JMSGImageContent *)model.message.content)];
        }
    }
    return urlArr;
}

- (void)flashToLoadMessage {
    NSMutableArray * arrList = @[].mutableCopy;
    NSArray *newMessageArr = [self.conversation messageArrayFromNewestWithOffset:@(self.messageOffset) limit:@(messagePageNumber)];
    [arrList addObjectsFromArray:newMessageArr];
    if ([arrList count] < messagePageNumber) {// 判断还有没有新数据
        self.isNoOtherMessage = YES;
        [self.allmessageIds removeObjectAtIndex:0];
    }
    
    self.messageOffset += messagePageNumber;
    for (NSInteger i = 0; i < [arrList count]; i++) {
        JMSGMessage *message = arrList[i];
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setChatModelWith:message conversationType:self.conversation];
        
        if (message.contentType == kJMSGContentTypeImage) {
            [self.imgDataArr insertObject:model atIndex:0];
            model.photoIndex = [self.imgDataArr count] - 1;
        }
        
        [self.allMessageDic setObject:model forKey:model.message.msgId];
        [self.allmessageIds insertObject:model.message.msgId atIndex: self.isNoOtherMessage?0:1];
        [self dataMessageShowTimeToTop:message.timestamp];// FIXME:
    }
    
    [self.messageTableView loadMoreMessage];
}
- (void)dataMessageShowTimeToTop:(NSNumber *)timeNumber{
    NSString *messageId = [self.allmessageIds lastObject];
    JCHATChatModel *lastModel = self.allMessageDic[messageId];
    NSTimeInterval timeInterVal = [timeNumber longLongValue];
    if ([self.allmessageIds count]>0 && lastModel.isTime == NO) {
        NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime doubleValue]];
        NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
        NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
        if (fabs(timeBetween) > interval) {
            JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
            timeModel.timeId = [self getTimeId];
            timeModel.isTime = YES;
            timeModel.messageTime = @(timeInterVal);
            timeModel.contentHeight = [timeModel getTextHeight];
            [self.allMessageDic setObject:timeModel forKey:timeModel.timeId];
            [self.allmessageIds insertObject:timeModel.timeId atIndex: self.isNoOtherMessage?0:1];
        }
    } else if ([self.allmessageIds count] ==0) {//首条消息显示时间
        JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
        timeModel.timeId = [self getTimeId];
        timeModel.isTime = YES;
        timeModel.messageTime = @(timeInterVal);
        timeModel.contentHeight = [timeModel getTextHeight];
        [self.allMessageDic setObject:timeModel forKey:timeModel.timeId];
        [self.allmessageIds insertObject:timeModel.timeId atIndex: self.isNoOtherMessage?0:1];
    } else {
        HQLog(@"不用显示时间");
    }
}
- (NSString *)getTimeId {
    NSString *timeId = [NSString stringWithFormat:@"%d",arc4random()%1000000];
    return timeId;
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
