//
//  HQTFTaskDynamicController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTaskDynamicController.h"
#import "JCHATToolBar.h"
#import "HQTFNoContentView.h"
#import "JCHATMoreView.h"
#import "IQKeyboardManager.h"
#import "XHVoiceRecordHUD.h"
#import "XHVoiceRecordHelper.h"
#import "HQTFTaskDynamicCell.h"
#import "TFTaskDynamicModel.h"
#import "HQTFTextImageChangeCell.h"
#import "TFProjectBL.h"
#import "TFTaskDynamicListModel.h"
#import "ZYQAssetPickerController.h"
#import "KSPhotoBrowser.h"
#import "TFTaskLogListModel.h"
#import "MJRefresh.h"
#import "TFPlayVoiceController.h"
#import "TFCompanyGroupController.h"

#define MoreViewContainerHeight Long(120)

@interface HQTFTaskDynamicController ()<UITableViewDelegate,UITableViewDataSource,SendMessageDelegate,UITextViewDelegate,AddBtnDelegate,HQBLDelegate,ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,KSPhotoBrowserDelegate,HQTFTaskDynamicCellDelegate>
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

/** TFProjectBL */
@property (nonatomic, strong) TFProjectBL *projectBL;

/**  */
@property (nonatomic, assign) NSInteger pageNum;
/**  */
@property (nonatomic, assign) NSInteger pageSize;

/** peoples */
@property (nonatomic, strong) NSMutableArray *peoples;


@end

@implementation HQTFTaskDynamicController

-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
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
    self.toolBarContainer.toolbar.heartShow = YES;
    
    [self addNotifation];
    
    IQKeyboardManager *keyBoard = [IQKeyboardManager sharedManager];
    keyBoard.enable = NO;
    
    if (self.type == 0) {
        
        [self.projectBL requestGetTaskCommentWithTaskId:self.taskDetail.id pageNo:1 pageSize:10];
    }else{
        
        [self.projectBL requestGetTaskDynamicWithTaskId:self.taskDetail.id pageNo:1 pageSize:10];
    }
    
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
    
    self.pageSize = 10;
    self.pageNum = 1;
    
    [self setupTableView];
    
    if (self.type == 0) {
        
        [self setupToolBar];
        [self setupMoreView];
        [self.toolBarContainer.toolbar.textView addObserver:self
                                                 forKeyPath:@"contentSize"
                                                    options:NSKeyValueObservingOptionNew
                                                    context:nil];
        
        self.toolBarContainer.toolbar.textView.delegate = self;
        self.toolBarContainer.toolbar.heartShow = NO;
        [self.toolBarContainer.toolbar drawRect:self.toolBarContainer.toolbar.frame];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputJumpNotifition:) name:TFProjectTaskInputJumpNotifition object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normalStatus) name:TFProjectDynamicNormalpNotifition object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(projetTaskHeartNotifition:) name:ProjetTaskHeartNotifition object:nil];
    
    
    // 网络请求
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
    
}

/** 任务详情初始化心的选中与否 */
//- (void)projetTaskHeartNotifition:(NSNotification *)note{
//    
//    NSNumber *num = note.object;
//    self.toolBarContainer.toolbar.heartBtn.selected = [num isEqualToNumber:@0]?NO:YES;
//    
//}

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
    self.toolBarContainer.toolbar.textView.placeHolderTextColor = HexColor(0xcacad0, 1);
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
#pragma mark -调用相册
- (void)photoClick {
    
    [self openAlbum];
}

#pragma mark --调用相机
- (void)cameraClick {
    
    [self openCamera];
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
        
        [self.projectBL requestAddTaskCommentUploadWithTaskId:self.taskDetail.id voiceDuration:@0 images:@[tempImg] voices:@[]];
    }
    
}

#pragma mark - 打开相机
- (void)openCamera
{
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
    
    [self.projectBL requestAddTaskCommentUploadWithTaskId:self.taskDetail.id voiceDuration:@0 images:@[image] voices:@[]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dropToolBarNoAnimate {
    
    _previousTextViewContentHeight = 31;
    _toolBarContainer.toolbar.addButton.selected = NO;
    
}


#pragma mark --toolBarContainer delegate

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
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    _barBottomFlag = YES;
    [self.toolBarContainer.toolbar.textView becomeFirstResponder];
}

#pragma mark --按下功能响应
- (void)pressMoreBtnClick:(UIButton *)btn {
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
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
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
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
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    UITextView *inputview = self.toolBarContainer.toolbar.textView;
    [inputview becomeFirstResponder];
    [self layoutAndAnimateMessageInputTextView:inputview];
}

#pragma mark - @功能选人
-(void)didHeartBtn:(UIButton *)button{
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:TaskDynamicClickedHeartNotifition object:@(button.selected)];
    
    TFCompanyGroupController *depart = [[TFCompanyGroupController alloc] init];
    depart.type = 2;
    depart.isSingle = YES;
    depart.employees = self.peoples;
    depart.actionParameter = ^(NSArray *peoples){
        
        //        [self.peoples removeAllObjects];
        NSString *str = @"";
        [self.peoples addObjectsFromArray:peoples];
        for (HQEmployModel *model in self.peoples) {
            str = [NSString stringWithFormat:@"@%@,",model.employeeName];
        }
        str = [str substringToIndex:str.length-1];
        self.toolBarContainer.toolbar.textView.text = [NSString stringWithFormat:@"%@%@ ",self.toolBarContainer.toolbar.textView.text,str];
        
        for (HQEmployModel *model in self.peoples) {
            
            NSString *str1 = [NSString stringWithFormat:@"@%@",model.employeeName];
            
            NSRange range = [self.toolBarContainer.toolbar.textView.text rangeOfString:str1];
            model.location = @(range.location);
            model.length = @(range.length);
            
        }
        
    };
    [self.navigationController pushViewController:depart animated:YES];
    
}

#pragma mark - 文字改变
- (void)inputTextViewDidChange:(JCHATMessageTextView *)messageInputTextView{
    
    
    NSString *str = messageInputTextView.text;
    
    for (HQEmployModel *model in self.peoples) {
        
        NSString *str1 = [NSString stringWithFormat:@"@%@",model.employeeName];
        
        if (![str containsString:str1]) {
            
            // 剩余名字位置
            NSRange range = NSMakeRange([model.location integerValue], [model.length integerValue]-1);
            
            if (range.location + range.length > messageInputTextView.text.length) {// 考虑删除多个字
                
                [self.peoples removeObject:model];
                continue;
            }
            
            str = [str stringByReplacingCharactersInRange:range withString:@""];
            messageInputTextView.text = str;
            
            [self.peoples removeObject:model];
            break;
        }else{
            
            NSRange range = [str rangeOfString:str1];
            model.location = @(range.location);
            model.length = @(range.length);
        }
    }
    
}

#pragma mark - 发送文本
- (void)sendText:(NSString *)text {
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    [self prepareTextMessage:text];
}
/** 发送文本消息 */
- (void)prepareTextMessage:(NSString *)text {
   
    if (text.length) {
        NSMutableArray *arr = [NSMutableArray array];
        for (HQEmployModel *mode in self.peoples) {
            [arr addObject:mode.id?mode.id:mode.employeeId];
        }
        [self.peoples removeAllObjects];
        [self.projectBL requestAddTaskCommentTextWithTaskId:self.taskDetail.id content:text empIds:arr];
        
    }
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
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
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
    }
    
    [self.projectBL requestAddTaskCommentUploadWithTaskId:self.taskDetail.id voiceDuration:@([voiceDuration integerValue]) images:@[] voices:@[voicePath]];
    
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-TabBarHeight) style:UITableViewStylePlain];
    
    if (self.type == 1) {
        tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(-42, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.backgroundView = [UIView new];
    
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        
        if (self.type == 0) {
            
            [self.projectBL requestGetTaskCommentWithTaskId:self.taskDetail.id pageNo:self.pageNum pageSize:10];
        }else{
            
            [self.projectBL requestGetTaskDynamicWithTaskId:self.taskDetail.id pageNo:self.pageNum pageSize:10];
        }
        
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.dynamics.count == 0) {
        tableView.backgroundView = self.noContentView;
        self.noContentView.centerY = (self.tableView.height-Long(180))/2;
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
        if (self.type == 0) {
            
            cell.title = [NSString stringWithFormat:@"  评论  %ld条",self.dynamics.count];
        }else{
            
            cell.title = [NSString stringWithFormat:@"  动态  %ld条",self.dynamics.count];
        }
        
        return cell;
    }
    
    HQTFTaskDynamicCell *cell = [HQTFTaskDynamicCell taskDynamicCellWithTableView:tableView];
    cell.delegate = self;
    if (self.type == 0) {
        [cell refreshCommentCellWithTaskDynamicItemModel:self.dynamics[indexPath.row]];
    }else{
        [cell refreshDynamicCellWithTaskDynamicItemModel:self.dynamics[indexPath.row]];
    }
    
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
    if (self.type == 0) {
        
        
        return [HQTFTaskDynamicCell refreshCommentCellHeightWithTaskDynamicItemModel:self.dynamics[indexPath.row]];
    }else{
        
        
        return [HQTFTaskDynamicCell refreshDynamicCellHeightWithTaskDynamicItemModel:self.dynamics[indexPath.row]];
    }
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



#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getTaskCommentList) {
        
//        TFTaskDynamicListModel *listModel = resp.body;
//        [self.dynamics removeAllObjects];
//        [self.dynamics addObjectsFromArray:listModel.list];
//        [self.tableView reloadData];
        
        
        
        TFTaskDynamicListModel *listModel = resp.body;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.dynamics removeAllObjects];
        }
        
        [self.dynamics addObjectsFromArray:listModel.list];
        
        if (listModel.totalRows == self.dynamics.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
            self.tableView.mj_footer = nil;
            
            if (self.dynamics.count < 10) {
                self.tableView.tableFooterView = [UIView new];
            }else{
                self.tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];;
            }
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.dynamics.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_getTaskDynamicList) {
        
        TFTaskLogListModel *listModel = resp.body;
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (TFTaskLogItemModel *item in listModel.list) {
            
            for (TFTaskLogContentModel *content in item.datas) {
                
                [arr addObject:content];
            }
        }
        
//        [self.dynamics removeAllObjects];
//        [self.dynamics addObjectsFromArray:arr];
//        [self.tableView reloadData];
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.dynamics removeAllObjects];
        }
        
        [self.dynamics addObjectsFromArray:arr];
        
        if (listModel.totalRows == self.dynamics.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
            self.tableView.mj_footer = nil;
            
            if (self.dynamics.count < 10) {
                self.tableView.tableFooterView = [UIView new];
            }else{
                self.tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];;
            }
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.dynamics.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_addTaskCommentText || resp.cmdId == HQCMD_addTaskCommentUpload) {
        
        [self.projectBL requestGetTaskCommentWithTaskId:self.taskDetail.id pageNo:1 pageSize:10];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    [self.tableView.mj_footer endRefreshing];
//    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
