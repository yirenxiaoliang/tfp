//
//  TFCompanyCircleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/19.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCompanyCircleController.h"
#import "TFCompanyCircleHeader.h"
#import "TFAlbumImageView.h"
#import "TFAlbumCell.h"
#import "TFCompanyCircleItemModel.h"
#import "TFCompanyCircleCell.h"
#import "HQCategoryItemModel.h"
#import "TFChatPeopleInfoController.h"
#import "KSPhotoBrowser.h"
#import "TFCompanyCircleDetailController.h"
#import "TFSendCompanyCircleController.h"
#import "TFCompanyCircleBL.h"
#import "JCHATToolBar.h"
#import "HQTFNoContentView.h"
#import "TFCompanyCircleListModel.h"
#import "FDActionSheet.h"
#import "ZYQAssetPickerController.h"
#import "TFRefresh.h"
#import "TFPeopleBL.h"
#import "TFLoginBL.h"
#import "TFMapController.h"
#import "TFCachePlistManager.h"
#import "IQKeyboardManager.h"

@interface TFCompanyCircleController ()<UITableViewDelegate,UITableViewDataSource,TFCompanyCircleCellDelegate,KSPhotoBrowserDelegate,HQBLDelegate,SendMessageDelegate,UITextViewDelegate,FDActionSheetDelegate,TFCompanyCircleHeaderDelegate,ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** albums */
@property (nonatomic, strong) NSMutableArray *circleItems;

/** TFCompanyCircleBL */
@property (nonatomic, strong) TFCompanyCircleBL *companyCircleBL;
/** TFPeopleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;
@property (nonatomic, strong) TFLoginBL *loginBL;

/** pageNo */
@property (nonatomic, assign) NSInteger pageNo;
/** pageSize */
@property (nonatomic, assign) NSInteger pageSize;
/** 输入框 */
@property (strong, nonatomic) JCHATToolBarContainer *toolBarContainer;
@property(nonatomic, assign) CGFloat previousTextViewContentHeight;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** 动态的一条frame */
@property (nonatomic, strong) TFCompanyCircleFrameModel *commentCircleFrame;
/** 动态的一条 */
@property (nonatomic, strong) HQCategoryItemModel *commentCircleItem;
/** 动态的一条index */
@property (nonatomic, assign) NSInteger commentCircleItemIndex;
/** 评论的一条 */
@property (nonatomic, strong) HQCommentItemModel *commentItem;
/** 评论的一条index */
@property (nonatomic, assign) NSInteger commentItemIndex;

/** 动态的一条 */
@property (nonatomic, strong) UIImage *backImage;

/** circleHeader */
@property (nonatomic, strong) TFCompanyCircleHeader *circleHeader;

/**
 *  记录键盘的 Heigth
 */
@property(nonatomic, assign) CGFloat keyBoardHeight;

/** first */
@property (nonatomic, assign) BOOL first;


@end

@implementation TFCompanyCircleController

-(NSMutableArray *)circleItems{
    
    if (!_circleItems) {
        _circleItems = [NSMutableArray array];
    }
    return _circleItems;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.toolBarContainer.toolbar drawRect:self.toolBarContainer.toolbar.frame];
    self.toolBarContainer.hidden = YES;
    
    // 走这里控制器重新加载了
    self.pageNo = 1;
    [self.companyCircleBL requestCompanyCircleListWithPageNo:@(self.pageNo) pageSize:@(self.pageSize) isPerson:nil startTime:nil endTime:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    IQKeyboardManager *mana = [IQKeyboardManager sharedManager];
    mana.enable = NO;
    
    
    TFCircleEmployModel *model = [[TFCircleEmployModel alloc] init];
    model.id = UM.userLoginInfo.employee.id;
    model.microblog_background = UM.userLoginInfo.employee.microblog_background;
    model.employeeName = UM.userLoginInfo.employee.employee_name;
    model.photograph = UM.userLoginInfo.employee.picture;
    model.personSignature = UM.userLoginInfo.employee.sign;
    model.telephone = UM.userLoginInfo.employee.phone;
    NSString *str = @"";
    for (TFDepartmentCModel *de in UM.userLoginInfo.departments) {
        str = [str stringByAppendingString:de.department_name];
    }
    if (str.length) {
        
        model.departmentName = [str substringToIndex:str.length-1];
    }else{
        
        model.departmentName = str;
    }
    
    self.circleHeader.employee = model;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    IQKeyboardManager *mana = [IQKeyboardManager sharedManager];
    mana.enable = YES;
    
}
- (void)keyBoardWillShow:(NSNotification *)noti {
    
    NSDictionary *userInfo = noti.userInfo;
    NSValue *endValue      = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame        = endValue.CGRectValue;
    self.toolBarContainer.hidden = NO;
    self.toolBarContainer.y = SCREEN_HEIGHT;
    self.keyBoardHeight = endFrame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        
        self.toolBarContainer.bottom = endFrame.origin.y-64-TopM;
        
    }completion:^(BOOL finished) {
        
    }];
    
}

- (void)keyBoardWillHide:(NSNotification *)noti {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.toolBarContainer.y = SCREEN_HEIGHT;
        
    }completion:^(BOOL finished) {
        self.toolBarContainer.hidden = YES;
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.companyCircleBL = [TFCompanyCircleBL build];
    self.companyCircleBL.delegate = self;
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
    self.pageSize = 20;
    self.pageNo = 1;
    
    // 获取员工及公司信息后会收到该通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:ChangeCompanySocketConnect object:nil];
    
    [self setupNavi];
    [self setupTableView];
    [self setupHeader];
    [self setupToolBar];
    [self setupNoContentView];
    
    NSArray *datas = [TFCachePlistManager getCircleDatas];
    if (datas.count) {
        [self.circleItems addObjectsFromArray:[self handleDatas:datas]];
        [self.tableView reloadData];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.first = YES;
    }
}

/** 刷新数据 */
- (void)refreshData{
    
    [self.circleItems removeAllObjects];
    
    NSArray *datas = [TFCachePlistManager getCircleDatas];
    [self.circleItems addObjectsFromArray:[self handleDatas:datas]];
    
    [self.tableView reloadData];
}

/** 将字段转化为frameModel */
- (NSArray *)handleDatas:(NSArray *)datas{
    
    NSMutableArray *frames = [NSMutableArray array];
    for (NSDictionary *dict in datas) {
        HQCategoryItemModel *cate = [[HQCategoryItemModel alloc] initWithDictionary:dict error:nil];
        
        if (cate) {
            TFCompanyCircleFrameModel *frameModel = [[TFCompanyCircleFrameModel alloc] init];
            frameModel.circleItem = cate;
            
            [frames addObject:frameModel];
        }
    }
    return frames;
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_companyCircleList) {
        
        TFCompanyCircleListModel *model = resp.body;
        
        if ([self.tableView.mj_footer isRefreshing]) {// 加载更多
            
            [self.tableView.mj_footer endRefreshing];
            
            NSMutableArray *frames = [NSMutableArray array];
            for (HQCategoryItemModel *cate in model.list) {
                TFCompanyCircleFrameModel *frameModel = [[TFCompanyCircleFrameModel alloc] init];
                frameModel.circleItem = cate;
                
                [frames addObject:frameModel];
            }
            [self.circleItems addObjectsFromArray:frames];
            
            [self.tableView reloadData];
            
        }else if ([self.tableView.mj_header isRefreshing]) {// 拉下刷新
            
            [self.tableView.mj_header endRefreshing];
            
            [self.circleItems removeAllObjects];
            
            NSMutableArray *frames = [NSMutableArray array];
            for (HQCategoryItemModel *cate in model.list) {
                TFCompanyCircleFrameModel *frameModel = [[TFCompanyCircleFrameModel alloc] init];
                frameModel.circleItem = cate;
                
                [frames addObject:frameModel];
            }
            [self.circleItems addObjectsFromArray:frames];
            
            [self.tableView reloadData];
            
        }else{// 默默请求，这里更新数据的地方
            
            NSMutableArray *frames = [NSMutableArray array];
            for (HQCategoryItemModel *cate in model.list) {
                TFCompanyCircleFrameModel *frameModel = [[TFCompanyCircleFrameModel alloc] init];
                frameModel.circleItem = cate;
                
                [frames addObject:frameModel];
            }
            
            if (self.circleItems.count == 0) {// 没有数据
                
                [self.circleItems addObjectsFromArray:frames];
                
            }else{// 有数据
                
                // 新数组中的最后一个元素
                TFCompanyCircleFrameModel *last = frames.lastObject;
                HQCategoryItemModel *lastItem = last.circleItem;
                
                // 确定最后一个元素在没在现有的数组中，以及位置
                BOOL have = NO;
                NSInteger index = 0;
                for (NSInteger i = 0; i < self.circleItems.count; i++) {
                    TFCompanyCircleFrameModel *mo = self.circleItems[i];
                    HQCategoryItemModel *moItem = mo.circleItem;
                    if ([[lastItem.id description] isEqualToString:[moItem.id description]]) {
                        have = YES;
                        index = i;
                        break;
                    }
                }
                
                if (have) {// 在现有数组中
                    
                    // index为位置，需要+1
                    [self.circleItems removeObjectsInRange:(NSRange){0,index+1}];
                    [frames addObjectsFromArray:self.circleItems];
                    [self.circleItems removeAllObjects];
                    [self.circleItems addObjectsFromArray:frames];
                    
                }else{// 不在数组中
                    /** 很久才来,新数据很多,无法一次更新完全,会产生中间数据缺失问题 */
                    // 从零开始
                    [self.circleItems removeAllObjects];
                    [self.circleItems addObjectsFromArray:frames];
                    
                }
                
            }
            
        }
        
        
        if ([model.totalRows integerValue] == self.circleItems.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.circleItems.count == 0) {
            
            self.circleHeader.backgroundColor = ClearColor;
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
            self.circleHeader.backgroundColor = WhiteColor;
        }
        
        if (self.first) {// 第一次需要刷新
            [self.tableView reloadData];
            self.first = NO;
        }
        
        // 缓存数据,最多缓存一百条
        NSMutableArray *strs = [NSMutableArray array];
        if (self.circleItems.count <= 100) {
            for (TFCompanyCircleFrameModel *fM in self.circleItems) {
                NSString *ss = [fM.circleItem toJSONString];
                [strs addObject:ss];
            }
        }else{
            
            for (NSInteger i = 0; i < 100; i++) {
                TFCompanyCircleFrameModel *fM = self.circleItems[i];
                NSString *ss = [fM.circleItem toJSONString];
                [strs addObject:ss];
            }
        }
        
        [TFCachePlistManager saveCircleDataWithDatas:strs];
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }
    
    if (resp.cmdId == HQCMD_companyCircleUp) {
        
//        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_companyCircleComment) {
        
        NSMutableArray<HQCommentItemModel,Optional> *commentList = [NSMutableArray<HQCommentItemModel,Optional> arrayWithArray:self.commentCircleItem.commentList];
        [commentList addObject:resp.body];
        
        self.commentCircleItem.commentList = commentList;
        
        if (self.commentCircleItemIndex < self.circleItems.count) {
            
            TFCompanyCircleFrameModel *fr = self.circleItems[self.commentCircleItemIndex];
            fr.circleItem = self.commentCircleItem;
            
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
            
            TFCompanyCircleCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.commentCircleItemIndex inSection:0]];
            cell.frameModel = fr;
            [cell refreshInfinorTable];
            
//            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.commentCircleItemIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
//        [self.tableView reloadData];
        
//        self.commentCircleItem = nil;
//        self.commentItem = nil;
    }
    if (resp.cmdId == HQCMD_companyCircleDelete) {
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_companyCircleCommentDelete) {
//        [self.tableView reloadData];
    }
    

    if (resp.cmdId == HQCMD_ChatFile) {
        
        NSArray *files = resp.body;
        
        NSMutableArray *dicts = [NSMutableArray array];
        for (TFFileModel *model in files) {
            
            [dicts addObject:[model toDictionary]];
        }
        
        if (files.count) {
            TFFileModel *model = files[0];
            TFEmployModel *em = [[TFEmployModel alloc] init];
            em.microblog_background = model.file_url;
            
            [self.peopleBL requestUpdateEmployeeWithEmployee:em];
        }
        
    }
    
    if (resp.cmdId == HQCMD_updateEmployee) {
        
        [self.loginBL requestGetEmployeeInfoAndCompanyInfo];
        self.circleHeader.image = self.backImage;
    }
    
    if (resp.cmdId == HQCMD_getEmployeeAndCompanyInfo) {
        [self.loginBL requestEmployeeList];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

#pragma mark - 无内容View
- (void)setupNoContentView{
    HQTFNoContentView *noContent = [HQTFNoContentView noContentView];
    noContent.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.height);
    
    CGRect rect = (CGRect){(SCREEN_WIDTH-Long(150))/2,(self.tableView.height - Long(150))-100,Long(150),Long(150)};
    
    [noContent setupImageViewRect:rect imgImage:@"图123" withTipWord:@"暂无动态"];
    
    self.noContentView = noContent;
}

/** 输入框 */
- (void)setupToolBar{
    
    self.toolBarContainer = [[JCHATToolBarContainer alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - TabBarHeight-TopM-BottomM, SCREEN_WIDTH, TabBarHeight)];
    self.toolBarContainer.toolbar.frame = self.toolBarContainer.bounds;
    [self.view addSubview:self.toolBarContainer];
    self.toolBarContainer.toolbar.delegate = self;
    self.toolBarContainer.toolbar.textView.delegate = self;
    [self.toolBarContainer.toolbar setUserInteractionEnabled:YES];
    self.toolBarContainer.toolbar.textView.placeHolderTextColor = HexAColor(0xcacad0, 1);
    self.toolBarContainer.toolbar.textView.placeHolder = @"说点什么...";
    self.toolBarContainer.toolbar.toolBarType = JCHATToolBarTypeCircle;
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
        
        self.toolBarContainer.bottom = SCREEN_HEIGHT - 64 - self.keyBoardHeight - TopM;// 输入框始终在键盘上面
        HQLog(@"===%f",self.toolBarContainer.bottom);
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
    
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (text.length) {
        
        if (self.commentItem) {// 回复
            if (![self.commentItem.senderId isEqualToNumber:UM.userLoginInfo.employee.id]) {
                
                [self.companyCircleBL requestCompanyCircleUpWithCircleId:self.commentCircleItem.id senderId:UM.userLoginInfo.employee.id receiverId:self.commentItem.senderId content:text];
            }else{
                
                [self.companyCircleBL requestCompanyCircleUpWithCircleId:self.commentCircleItem.id senderId:UM.userLoginInfo.employee.id receiverId:nil content:text];
            }
        }else{
            [self.companyCircleBL requestCompanyCircleUpWithCircleId:self.commentCircleItem.id senderId:nil receiverId:nil content:text];
        }
        [self.view endEditing:YES];
    }else{
        [MBProgressHUD showError:@"请输入文字" toView:KeyWindow];
    }
}

#pragma mark - navi
- (void)setupNavi{
    self.navigationItem.title = @"同事圈";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(creatCircle) image:@"相机circle" highlightImage:@"相机circle"];
}
- (void)creatCircle{
    
    TFSendCompanyCircleController *sender = [[TFSendCompanyCircleController alloc] init];
//    sender.refreshAction = ^{
//
//        self.pageNo = 1;
//        [self.companyCircleBL requestCompanyCircleListWithPageNo:@(self.pageNo) pageSize:@(self.pageSize) isPerson:nil startTime:nil endTime:nil];
//    };
    [self.navigationController pushViewController:sender animated:YES];
}

#pragma mark - tableView头部
- (void)setupHeader{
    
    TFCompanyCircleHeader *header = [TFCompanyCircleHeader companyCircleHeader];
    header.headerType = CompanyCircleHeaderTypeNoDescription;
    header.delegate = self;
    self.tableView.tableHeaderView = header;
    self.circleHeader = header;
    
    TFCircleEmployModel *model = [[TFCircleEmployModel alloc] init];
    model.id = UM.userLoginInfo.employee.id;
    model.microblog_background = UM.userLoginInfo.employee.microblog_background;
    model.employeeName = UM.userLoginInfo.employee.employee_name;
    model.photograph = UM.userLoginInfo.employee.picture;
    model.personSignature = UM.userLoginInfo.employee.sign;
    model.telephone = UM.userLoginInfo.employee.phone;
    NSString *str = @"";
    for (TFDepartmentCModel *de in UM.userLoginInfo.departments) {
        str = [str stringByAppendingString:de.department_name];
    }
    if (str.length) {
        
        model.departmentName = [str substringToIndex:str.length-1];
    }else{
        
        model.departmentName = str;
    }
    
    header.employee = model;
}

#pragma mark - TFCompanyCircleHeaderDelegate
-(void)companyCircleHeaderDidClickedHeadWithEmployee:(TFCircleEmployModel *)employee{
    
    TFChatPeopleInfoController *peopleInfo = [[TFChatPeopleInfoController alloc] init];
    peopleInfo.employee = employee;
    [self.navigationController pushViewController:peopleInfo animated:YES];
}

-(void)companyCircleHeaderDidClickedBackground{
    
    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"更换相册封面" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"手机相册",@"拍照",nil];
    sheet.tag = 0x67890;
    [sheet show];
    
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = WhiteColor;
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    tableView.mj_header = [TFRefresh headerGifRefreshWithBlock:^{
        
        self.pageNo = 1;
        
        [self.companyCircleBL requestCompanyCircleListWithPageNo:@(self.pageNo) pageSize:@(self.pageSize) isPerson:nil startTime:nil endTime:nil];
    }];
    
    
    tableView.mj_footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        self.pageNo ++;
        
        [self.companyCircleBL requestCompanyCircleListWithPageNo:@(self.pageNo) pageSize:@(self.pageSize) isPerson:nil startTime:nil endTime:nil];
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.circleItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCompanyCircleCell *cell = [TFCompanyCircleCell companyCircleCellWithTableView:tableView];
    cell.tag = indexPath.row;
    TFCompanyCircleFrameModel *frameModel = self.circleItems[indexPath.row];
//    frameModel.circleItem = frameModel.circleItem;
    cell.frameModel = frameModel;
    cell.delegate = self;
    if (self.circleItems.count-1 == indexPath.row) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    for (TFCompanyCircleCell *cell in self.tableView.visibleCells) {
        if ([cell.frameModel.circleItem.commentShow isEqualToNumber:@1]) {
            
            [cell commentDismiss];
        }
    }
    
//    TFCompanyCircleFrameModel *frameModel = self.circleItems[indexPath.row];
//    TFCompanyCircleFrameModel *model = [[TFCompanyCircleFrameModel alloc] init];
//    model.type = 1;
//    model.circleItem = frameModel.circleItem;
//    
//    TFCompanyCircleDetailController *detail = [[TFCompanyCircleDetailController alloc] init];
//    detail.frameModel = model;
//    detail.deleteAction = ^(TFCompanyCircleFrameModel *parameter) {
//        
//        [self.circleItems removeObject:parameter];
//        [self.tableView reloadData];
//    };
//    detail.refreshAction = ^(id parameter) {
//        
//        [self.tableView reloadData];
//    };
//    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCompanyCircleFrameModel *model = self.circleItems[indexPath.row];
    
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
    
    for (TFCompanyCircleCell *cell in self.tableView.visibleCells) {
        if ([cell.frameModel.circleItem.commentShow isEqualToNumber:@1]) {
            
            [cell commentDismiss];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    if (self.toolBarContainer.toolbar.textView.isFirstResponder) {
    
        [self.view endEditing:YES];
//        self.toolBarContainer.hidden = YES;
//    }
}

#pragma mark - TFCompanyCircleCellDelegate

/** 长按删除评论 */
-(void)companyCircleCell:(TFCompanyCircleCell *)cell didLongPressWithCommentItem:(HQCommentItemModel *)commentItem index:(NSInteger)index{
    
    
    
}
/** 点击全文按钮 */
-(void)companyCircleCell:(TFCompanyCircleCell *)cell didClickedAllWordBtn:(UIButton *)button{
    
    for (TFCompanyCircleCell *cell in self.tableView.visibleCells) {
        if ([cell.frameModel.circleItem.commentShow isEqualToNumber:@1]) {
            
            [cell commentDismiss];
        }
    }
    [self.view endEditing:YES];
    
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    TFCompanyCircleFrameModel *model = self.circleItems[path.row];
    model.circleItem = cell.frameModel.circleItem;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    cell.frameModel = model;
    
//    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
   
//    [self.tableView reloadData];
    
}

/** 点击删除按钮 */
- (void)companyCircleCell:(TFCompanyCircleCell *)circleCell didClickedDeleteBtn:(UIButton *)button
{
    for (TFCompanyCircleCell *cell in self.tableView.visibleCells) {
        if ([cell.frameModel.circleItem.commentShow isEqualToNumber:@1]) {
            
            [cell commentDismiss];
        }
    }
    [self.view endEditing:YES];
    
    HQCategoryItemModel *model = circleCell.frameModel.circleItem;
    [self.companyCircleBL requestCompanyCircleDeleteWithCircleId:model.id];
    
    if (circleCell.tag < self.circleItems.count) {
        [self.circleItems removeObjectAtIndex:circleCell.tag];
    }
    
}
/** 点击共享按钮 */
- (void)companyCircleCell:(TFCompanyCircleCell *)circleCell didClickedShareBtn:(UIButton *)button
{
    
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
    
    circleCell.frameModel.circleItem = model;
    
//    [self.tableView beginUpdates];
//    [self.tableView endUpdates];
    
    circleCell.frameModel = circleCell.frameModel;
    
    [self.tableView reloadData];
    
    [circleCell refreshInfinorTable];
    
    
}

/** 点击评论按钮 */
- (void)companyCircleCell:(TFCompanyCircleCell *)cell withCommentItem:(HQCategoryItemModel *)commentItem didClickedCommentBtn:(UIButton *)button{
    
    self.toolBarContainer.hidden = NO;
    [self.toolBarContainer.toolbar.textView becomeFirstResponder];
    self.toolBarContainer.toolbar.textView.placeHolder = @"说点什么...";
    self.commentCircleItem = cell.frameModel.circleItem;
    self.commentCircleItemIndex = cell.tag;
    self.commentItem = nil;
}

/** 点击显示按钮 */
-(void)companyCircleCell:(TFCompanyCircleCell *)circleCell didClickedShowBtn:(UIButton *)button{
    
    for (TFCompanyCircleCell *cell in self.tableView.visibleCells) {
        
        if (circleCell != cell) {
            
            if ([cell.frameModel.circleItem.commentShow isEqualToNumber:@1]) {
                
                [cell commentDismiss];
            }
        }
    }
    [self.view endEditing:YES];
    
}

/** 点击点赞列表中的人及评论中的人 */
- (void)companyCircleCell:(TFCompanyCircleCell *)circleCell didClickedGoodPeople:(HQEmployModel *)people
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
        self.commentCircleItem = cell.frameModel.circleItem;
        self.commentCircleItemIndex = cell.tag;
        self.commentItem = commentItem;
        self.commentItemIndex = index;
        self.commentCircleFrame = cell.frameModel;
        
    }else{
        
        self.toolBarContainer.hidden = NO;
        [self.toolBarContainer.toolbar.textView becomeFirstResponder];
        self.toolBarContainer.toolbar.textView.placeHolder = [NSString stringWithFormat:@"回复%@",commentItem.senderName];
        self.commentCircleItem = cell.frameModel.circleItem;
        self.commentCircleItemIndex = cell.tag;
        self.commentItem = commentItem;
    }
    
}

- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    
    
    if (sheet.tag == 0x12345) {// 删除评论
        
        [self.companyCircleBL requestCompanyCircleCommentDeleteWithCommentId:self.commentItem.commentId];
        
        NSMutableArray<HQCommentItemModel,Optional> *comments = [NSMutableArray<HQCommentItemModel,Optional> arrayWithArray:self.commentCircleItem.commentList];
        if (self.commentItemIndex < comments.count) {
            [comments removeObjectAtIndex:self.commentItemIndex];
        }
        self.commentCircleItem.commentList = comments;
        self.commentCircleFrame.circleItem = self.commentCircleItem;
        
        if (self.commentCircleItemIndex < self.circleItems.count) {
            
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
            
            TFCompanyCircleCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.commentCircleItemIndex inSection:0]];
            cell.frameModel = self.commentCircleFrame;
            [cell refreshInfinorTable];
            
            //            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.commentCircleItemIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }else{// 换背景
        
        if (buttonIndex == 0) {
            [self openAlbum];
        }else{
            [self openCamera];
        }
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
        self.backImage = tempImg;
//        [self.companyCircleBL uploadFileWithImages:@[tempImg] withVioces:@[] withModule:4];
        
        [self.peopleBL chatFileWithImages:@[tempImg] withVioces:@[] bean:@"circle111"];
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
    
    self.backImage = image;
//    [self.companyCircleBL uploadFileWithImages:@[image] withVioces:@[] withModule:4];
    
    [self.peopleBL chatFileWithImages:@[image] withVioces:@[] bean:@"circle111"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    emp.id = @([model.employeeId integerValue]);
    
    peopleInfo.employee = emp;
    [self.navigationController pushViewController:peopleInfo animated:YES];
}
/** 点击地址 */
- (void)companyCircleCell:(TFCompanyCircleCell *)circleCell didClickedAddressWithLongitude:(NSNumber*)longitude withLatitude:(NSNumber*)latitude{
    
    for (TFCompanyCircleCell *cell in self.tableView.visibleCells) {
        if ([cell.frameModel.circleItem.commentShow isEqualToNumber:@1]) {
            
            [cell commentDismiss];
        }
    }
    [self.view endEditing:YES];
    
    
    // 查看地图
//    HQTFSportController *locationVc = [[HQTFSportController alloc] init];
//    locationVc.location = (CLLocationCoordinate2D){[latitude doubleValue],[longitude doubleValue]};
//    locationVc.type = LocationTypeLookLocation;
//    [self.navigationController pushViewController:locationVc animated:YES];
    
    
    TFMapController *locationVc = [[TFMapController alloc] init];
    locationVc.address = circleCell.frameModel.circleItem.address;
    locationVc.type = LocationTypeLookLocation;
    locationVc.location = (CLLocationCoordinate2D){[latitude doubleValue],[longitude doubleValue]};
    [self.navigationController pushViewController:locationVc animated:YES];
    
}
/** 点击图片 */
-(void)companyCircleCell:(TFCompanyCircleCell *)circleCell pictureViewWithImageViews:(NSArray *)imageViews didImageViewWithIndex:(NSInteger)index{
    
    for (TFCompanyCircleCell *cell in self.tableView.visibleCells) {
        if ([cell.frameModel.circleItem.commentShow isEqualToNumber:@1]) {
            
            [cell commentDismiss];
        }
    }
    [self.view endEditing:YES];
    
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < imageViews.count; i++) {
        UIImageView *imageView = imageViews[i];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView image:imageView.image];
        [items addObject:item];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:index];
    browser.delegate = self;
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleDeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces = NO;
    [browser showFromViewController:self];
    
}

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index {
    HQLog(@"selected index: %ld", index);
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
