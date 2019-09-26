//
//  TFCompanyCircleDetailController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCompanyCircleDetailController.h"
#import "TFAlbumImageView.h"
#import "TFAlbumCell.h"
#import "TFCompanyCircleItemModel.h"
#import "TFCompanyCircleCell.h"
#import "HQCategoryItemModel.h"
#import "TFChatPeopleInfoController.h"
#import "KSPhotoBrowser.h"
#import "JCHATToolBar.h"
#import "JCHATMessageTextView.h"
#import "IQKeyboardManager.h"
#import "JCHATMoreView.h"
#import "TFCompanyCircleBL.h"
#import "FDActionSheet.h"
#import "TFMapController.h"

#define MoreViewContainerHeight 227

@interface TFCompanyCircleDetailController ()<UITableViewDelegate,UITableViewDataSource,TFCompanyCircleCellDelegate,KSPhotoBrowserDelegate,SendMessageDelegate,UITextViewDelegate,HQBLDelegate,FDActionSheetDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** 输入框 */
@property (strong, nonatomic) JCHATToolBarContainer *toolBarContainer;
@property (strong, nonatomic) JCHATMoreViewContainer *moreViewContainer;
@property(nonatomic, assign) CGFloat previousTextViewContentHeight;

/** 用于键盘升降 */
@property(assign, nonatomic) BOOL barBottomFlag;

/**
 *  记录键盘的 Heigth
 */
@property(nonatomic, assign) CGFloat keyBoardHeight;


/** TFCompanyCircleBL */
@property (nonatomic, strong) TFCompanyCircleBL *companyCircleBL;

/** 评论的一条 */
@property (nonatomic, strong) HQCommentItemModel *commentItem;
/** 评论的一条index */
@property (nonatomic, assign) NSInteger commentItemIndex;

@end

@implementation TFCompanyCircleDetailController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupTableView];
    _previousTextViewContentHeight = 31;
    [self setupToolBar];
    
    self.companyCircleBL = [TFCompanyCircleBL build];
    self.companyCircleBL.delegate = self;
}
#pragma mark - navi
- (void)setupNavi{
    self.navigationItem.title = @"详情";
}
#pragma mark - setupToolBar
- (void)setupToolBar{
    
    self.toolBarContainer = [[JCHATToolBarContainer alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - BottomM - 49, SCREEN_WIDTH, 49)];
    self.toolBarContainer.toolbar.frame = self.toolBarContainer.bounds;
    [self.view addSubview:self.toolBarContainer];
    self.toolBarContainer.toolbar.delegate = self;
    self.toolBarContainer.toolbar.textView.delegate = self;
    [self.toolBarContainer.toolbar setUserInteractionEnabled:YES];
    self.toolBarContainer.toolbar.textView.placeHolderTextColor = HexAColor(0xcacad0, 1);
    self.toolBarContainer.toolbar.textView.placeHolder = @"说点什么...";
    
    [self.toolBarContainer.toolbar drawRect:self.toolBarContainer.toolbar.frame];
//    self.toolBarContainer.toolbar.toolBarType = JCHATToolBarTypeGood;
//    self.toolBarContainer.toolbar.toolBarType = JCHATToolBarTypeChat;
    self.toolBarContainer.toolbar.toolBarType = JCHATToolBarTypeCircle;
//    self.toolBarContainer.toolbar.toolBarType = JCHATToolBarTypeUploadVioce;
    
    [self.toolBarContainer.toolbar.textView addObserver:self
                                             forKeyPath:@"contentSize"
                                                options:NSKeyValueObservingOptionNew
                                                context:nil];
}

#pragma mark --释放内存
- (void)dealloc {
    
    [self.toolBarContainer.toolbar.textView removeObserver:self forKeyPath:@"contentSize"];
}
#pragma mark - Key-value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (object == self.toolBarContainer.toolbar.textView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
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

#pragma mark - UITextView Helper Method
- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark --按下功能响应
- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottom, 0);
}

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

/** 发送文本 */
- (void)sendText:(NSString *)text {
    [self prepareTextMessage:text];
}
/** 发送文本消息 */
- (void)prepareTextMessage:(NSString *)text {
    
    if (text.length) {
        
        if (self.commentItem) {// 回复
            if (![self.commentItem.receiverId isEqualToString:[UM.userLoginInfo.employee.id description]]) {
                
                [self.companyCircleBL requestCompanyCircleUpWithCircleId:self.frameModel.circleItem.id senderId:nil receiverId:self.commentItem.senderId content:text];
            }else{
                
                [self.companyCircleBL requestCompanyCircleUpWithCircleId:self.frameModel.circleItem.id senderId:nil receiverId:nil content:text];
            }
        }else{
            [self.companyCircleBL requestCompanyCircleUpWithCircleId:self.frameModel.circleItem.id senderId:nil receiverId:nil content:text];
        }
    }
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCompanyCircleCell *cell = [TFCompanyCircleCell companyCircleCellWithTableView:tableView];
    cell.frameModel.circleItem = self.frameModel.circleItem;
    cell.frameModel = self.frameModel;
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    for (TFCompanyCircleCell *cell in self.tableView.visibleCells) {
        if ([cell.frameModel.circleItem.commentShow isEqualToNumber:@1]) {
            
            [cell commentDismiss];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCompanyCircleFrameModel *model = self.frameModel;
    
    return model.cellHeight;
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
    
    for (TFCompanyCircleCell *cell in self.tableView.visibleCells) {
        if ([cell.frameModel.circleItem.commentShow isEqualToNumber:@1]) {
            
            [cell commentDismiss];
        }
    }
    
}

#pragma mark - TFCompanyCircleCellDelegate
/** 点击全文按钮 */
-(void)companyCircleCell:(TFCompanyCircleCell *)cell didClickedAllWordBtn:(UIButton *)button{
    
    [self.view endEditing:YES];

    for (TFCompanyCircleCell *cell in self.tableView.visibleCells) {
        if ([cell.frameModel.circleItem.commentShow isEqualToNumber:@1]) {
            
            [cell commentDismiss];
        }
    }
    
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    TFCompanyCircleFrameModel *model = self.frameModel;
    model.circleItem = cell.frameModel.circleItem;
    
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    
}
/** 点击删除按钮 */
- (void)companyCircleCell:(TFCompanyCircleCell *)circleCell didClickedDeleteBtn:(UIButton *)button;
{
    for (TFCompanyCircleCell *cell in self.tableView.visibleCells) {
        if ([cell.frameModel.circleItem.commentShow isEqualToNumber:@1]) {
            
            [cell commentDismiss];
        }
    }
    [self.view endEditing:YES];
    
    HQCategoryItemModel *model = circleCell.frameModel.circleItem;
    [self.companyCircleBL requestCompanyCircleDeleteWithCircleId:model.id];

}
/** 点击共享按钮 */
- (void)companyCircleCell:(TFCompanyCircleCell *)circleCell didClickedShareBtn:(UIButton *)button;
{
    [self.view endEditing:YES];
    
    [MBProgressHUD showError:@"敬请期待" toView:self.view];
    return;
    
    HQCategoryItemModel *model = circleCell.frameModel.circleItem;
    
    NSString *text = model.info;
    UIImage *image = nil;
    if (model.images.count) {
        TFFileModel *file = model.images[0];
        
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[HQHelper URLWithString:file.file_url]]];
    }
    
    if ((!text || [text isEqualToString:@""]) && !image) {
        [MBProgressHUD showError:@"无内容不能分享" toView:self.view];
        return;
    }

}
/** 点击点赞按钮 */
- (void)companyCircleCell:(TFCompanyCircleCell *)circleCell didClickedGoodBtn:(UIButton *)button{
    [self.view endEditing:YES];
    HQCategoryItemModel *model = circleCell.frameModel.circleItem;
    [self.companyCircleBL requestCompanyCircleUpWithCircleId:model.id];
    
    if ([model.isPraise isEqualToNumber:@1]) {// 点赞
        
        NSMutableArray<Optional,HQEmployModel> *praises = [NSMutableArray<Optional,HQEmployModel> arrayWithArray:model.praiseList];
        
        HQEmployModel *employ = [[HQEmployModel alloc] init];
        employ.employeeId = UM.userLoginInfo.employee.id;
        employ.id = UM.userLoginInfo.employee.id;
        employ.employeeName = UM.userLoginInfo.employee.employee_name;
        employ.photograph = UM.userLoginInfo.employee.picture;
        [praises addObject:employ];
        model.praiseList = praises;
        
    }else{// 取消
        
        NSMutableArray<Optional,HQEmployModel> *praises = [NSMutableArray<Optional,HQEmployModel> arrayWithArray:model.praiseList];
        
        for (HQEmployModel *emp in praises) {
            
            if ([emp.employeeId isEqualToNumber:UM.userLoginInfo.employee.id]) {
                [praises removeObject:emp];
                break;
            }
            
        }
        model.praiseList = praises;
    }
    

}
/** 点击评论按钮 */
- (void)companyCircleCell:(TFCompanyCircleCell *)cell withCommentItem:(HQCategoryItemModel *)commentItem didClickedCommentBtn:(UIButton *)button{
    
    [self.toolBarContainer.toolbar.textView becomeFirstResponder];
    self.toolBarContainer.toolbar.textView.placeHolder = @"说点什么...";
}
/** 点击点赞列表中的人及评论中的人 */
- (void)companyCircleCell:(TFCompanyCircleCell *)cell didClickedGoodPeople:(HQEmployModel *)people;
{
    for (TFCompanyCircleCell *cell in self.tableView.visibleCells) {
        if ([cell.frameModel.circleItem.commentShow isEqualToNumber:@1]) {
            
            [cell commentDismiss];
        }
    }
    [self.view endEditing:YES];
    
    TFChatPeopleInfoController *peopleInfo = [[TFChatPeopleInfoController alloc] init];
    peopleInfo.employee = people;
    [self.navigationController pushViewController:peopleInfo animated:YES];
}
/** 点击评论进行回复 */
- (void)companyCircleCell:(TFCompanyCircleCell *)cell withCommentItem:(HQCommentItemModel *)commentItem index:(NSInteger)index{
    
    if ([commentItem.senderId isEqualToNumber:UM.userLoginInfo.employee.id]) {
        
        FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"删除我的评论" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",nil];
        sheet.tag = 0x12345;
        [sheet setButtonTitleColor:RedColor bgColor:WhiteColor fontSize:FONT(18) atIndex:0];
        
        [sheet show];
        self.commentItem = commentItem;
        self.commentItemIndex = index;
        
    }else{
        
        self.toolBarContainer.hidden = NO;
        [self.toolBarContainer.toolbar.textView becomeFirstResponder];
        self.toolBarContainer.toolbar.textView.placeHolder = [NSString stringWithFormat:@"回复%@",commentItem.senderName];
        self.commentItem = commentItem;
    }

}

- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    
    
    if (sheet.tag == 0x12345) {// 删除评论
        
        [self.companyCircleBL requestCompanyCircleCommentDeleteWithCommentId:self.commentItem.commentId];
        
        NSMutableArray<HQCommentItemModel,Optional> *comments = [NSMutableArray<HQCommentItemModel,Optional> arrayWithArray:self.frameModel.circleItem.commentList];
        [comments removeObjectAtIndex:self.commentItemIndex];
        
        self.frameModel.circleItem.commentList = comments;
    }
}



/** 点击头像 */
- (void)companyCircleCell:(TFCompanyCircleCell *)circleCell didClickedHeadBtn:(UIButton *)button{
    
    for (TFCompanyCircleCell *cell in self.tableView.visibleCells) {
        if ([cell.frameModel.circleItem.commentShow isEqualToNumber:@1]) {
            
            [cell commentDismiss];
        }
    }
    [self.view endEditing:YES];
    
    HQCategoryItemModel *model = circleCell.frameModel.circleItem;
    
    TFChatPeopleInfoController *peopleInfo = [[TFChatPeopleInfoController alloc] init];
    HQEmployModel *emp = [[HQEmployModel alloc] init];
    emp.id = model.employeeId;
    
    peopleInfo.employee = emp;
    [self.navigationController pushViewController:peopleInfo animated:YES];
}
/** 点击地址 */
- (void)companyCircleCell:(TFCompanyCircleCell *)cell didClickedAddressWithLongitude:(NSNumber*)longitude withLatitude:(NSNumber*)latitude{
    
    for (TFCompanyCircleCell *cell in self.tableView.visibleCells) {
        if ([cell.frameModel.circleItem.commentShow isEqualToNumber:@1]) {
            
            [cell commentDismiss];
        }
    }
    [self.view endEditing:YES];

    TFMapController *locationVc = [[TFMapController alloc] init];
    locationVc.type = LocationTypeLookLocation;
    locationVc.location = (CLLocationCoordinate2D){[latitude doubleValue],[longitude doubleValue]};
    [self.navigationController pushViewController:locationVc animated:YES];
}
/** 点击图片 */
-(void)companyCircleCell:(TFCompanyCircleCell *)cell pictureViewWithImageViews:(NSArray *)imageViews didImageViewWithIndex:(NSInteger)index{
    
    [self.view endEditing:YES];
    
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < imageViews.count; i++) {
        UIImageView *imageView = imageViews[i];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView image:imageView.image];
        [items addObject:item];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:index];
    browser.delegate = self;
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleRotation;
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
    
    if (resp.cmdId == HQCMD_companyCircleUp) {
        
        if (self.deleteAction) {
            self.deleteAction(nil);
        }
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_companyCircleComment) {
        
        NSMutableArray<HQCommentItemModel,Optional> *commentList = [NSMutableArray<HQCommentItemModel,Optional> arrayWithArray:self.frameModel.circleItem.commentList];
        [commentList addObject:resp.body];
        
        self.frameModel.circleItem.commentList = commentList;
        [self.tableView reloadData];
        
        if (self.refreshAction) {
            self.refreshAction(nil);
        }
        
        
    }
    if (resp.cmdId == HQCMD_companyCircleDelete) {
        if (self.deleteAction) {
            self.deleteAction(self.frameModel);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (resp.cmdId == HQCMD_companyCircleCommentDelete) {
        
        if (self.deleteAction) {
            self.deleteAction(nil);
        }
        [self.tableView reloadData];
    }

}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    [self.tableView.mj_footer endRefreshing];
//    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
