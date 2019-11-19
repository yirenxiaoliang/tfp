//
//  TFNewCustomDetailController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNewCustomDetailController.h"
#import "TFCustomDetaiHeaderView.h"
#import "TFCustomDetailScrollView.h"
#import "TFAddCustomController.h"
#import "FDActionSheet.h"
#import "TFCustomChangeView.h"
#import "TFCustomTransferController.h"
#import "TFCustomShareController.h"
#import "TFCustomerCommentController.h"
#import "TFCustomerDynamicController.h"
#import "TFCustomBL.h"
#import "TFCustomDetailRefrenceModel.h"
#import "TFCustomAuthModel.h"
#import "TFReferenceListController.h"
#import "TFCustomFlowController.h"
#import "TFHighseaMoveController.h"
#import "TFHighseaAllocateController.h"
#import "TFHighseaModel.h"
#import "TFCustomEmailListController.h"
#import "TFRelevanceFieldModel.h"
#import "TFCommentTableView.h"
#import "TFPlayVoiceController.h"
#import "KSPhotoBrowser.h"
#import "JCHATToolBar.h"
#import "JCHATMoreView.h"
#import "IQKeyboardManager.h"
#import "XHVoiceRecordHUD.h"
#import "XHVoiceRecordHelper.h"
#import "ZYQAssetPickerController.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFFileMenuController.h"
#import "TFFolderListModel.h"
#import "TFCustomerCommentModel.h"
#import "TFDynamicsTableView.h"
#import "TFEmailTableView.h"
#import "TFMailBL.h"
#import "TFEmailsListModel.h"
#import "TFReferanceModelView.h"
#import "TFAutoMatchDataListController.h"
#import "TFEmailsDetailController.h"
#import "TFApprovalTableView.h"
#import "TFApprovalFlowModel.h"
#import "TFCustomBaseModel.h"

@interface TFNewCustomDetailController ()<UITableViewDelegate,UITableViewDataSource,FDActionSheetDelegate,UIAlertViewDelegate,HQBLDelegate,TFCustomDetailScrollViewDelegate,TFCommentTableViewDelegate,KSPhotoBrowserDelegate,ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LiuqsEmotionKeyBoardDelegate,TFDynamicsTableViewDelegate,TFEmailTableViewDelegate,TFReferanceModelViewDelegate,UIActionSheetDelegate,UIDocumentInteractionControllerDelegate,TFApprovalTableViewDelegate>

/** headerView */
@property (nonatomic, weak) TFCustomDetaiHeaderView *headerView;

/** customDetailScrollView */
@property (nonatomic, weak) TFCustomDetailScrollView *customDetailScrollView;

/** HQBLDelegate */
@property (nonatomic, strong) TFCustomBL *customBL;

/** 子控制器 */
@property (nonatomic, strong) TFAddCustomController *childVc;

/** dynamicsTableView */
@property (nonatomic, strong) TFDynamicsTableView *dynamicsTable;


/** commentTable */
@property (nonatomic, strong) TFCommentTableView *commentTable;

/** emailTable */
@property (nonatomic, strong) TFEmailTableView *emailTable;

/** approvalView */
@property (nonatomic, strong) TFApprovalTableView *approvalView;

/** auths */
@property (nonatomic, strong) NSMutableArray *auths;

/** changes */
@property (nonatomic, strong) NSMutableArray <TFCustomChangeModel>*changes;


/** refrenceModel */
@property (nonatomic, strong)  TFCustomDetailRefrenceModel *refrenceModel;

/** commentAndDynamicDict */
@property (nonatomic, strong) NSDictionary *commentAndDynamicDict;

/** bottomBtns */
@property (nonatomic, strong) NSArray *bottomBtns;

/** highseas */
@property (nonatomic, strong) NSMutableArray *highseas;

/** emails */
@property (nonatomic, strong) NSArray *emails;

/** detailDict */
@property (nonatomic, strong) NSDictionary *detailDict;

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** button */
@property (nonatomic, strong) UIButton *button;

/** commentTabBar */
@property (nonatomic, strong) UIView *commentTabBar;

@property(nonatomic, strong) LiuqsEmoticonKeyBoard *keyboard;

/** peoples */
@property (nonatomic, strong) NSMutableArray *peoples;

/** jump */
@property (nonatomic, assign) NSInteger jump;
/** model */
@property (nonatomic, strong) TFCustomerCommentModel *commentModel;

/** 评论数组 */
@property (nonatomic, strong) NSMutableArray *comments;
/** 动态数组 */
@property (nonatomic, strong) NSMutableArray *dynamics;
/** 邮件数组 */
@property (nonatomic, strong) NSMutableArray *emailModels;
/** 审批数组 */
@property (nonatomic, strong) NSMutableArray *approvals;

/** buttons */
@property (nonatomic, strong) NSMutableArray *buttons;

/** selectIndex */
@property (nonatomic, assign) NSInteger selectIndex;

/** TFMailBL */
@property (nonatomic, strong) TFMailBL *emailBL;

/** pageNum */
@property (nonatomic, assign) NSInteger pageNum;
/** pageSize */
@property (nonatomic, assign) NSInteger pageSize;

/** referanceModelView */
@property (nonatomic, strong) TFReferanceModelView *referanceModelView;

/** menus */
@property (nonatomic, strong) NSArray *menus;

/** 记录 */
@property (nonatomic, copy) NSString *lockedState;

/** referances:关联数组 */
@property (nonatomic, strong) NSMutableArray *referances;
/** referances:自动匹配数组 */
@property (nonatomic, strong) NSMutableArray *autos;

@property (nonatomic, strong) TFCustomAuthModel *auth;

@property (nonatomic, strong) TFCustomBaseModel *layout;

@end

@implementation TFNewCustomDetailController

-(TFReferanceModelView *)referanceModelView{
    if (!_referanceModelView) {
        _referanceModelView = [TFReferanceModelView referanceModelView];
        _referanceModelView.delegate = self;
    }
    return _referanceModelView;
}

-(NSMutableArray *)emailModels{
    if (!_emailModels) {
        _emailModels = [NSMutableArray array];
    }
    return _emailModels;
}

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(NSMutableArray *)approvals{
    if (!_approvals) {
        _approvals = [NSMutableArray array];
    }
    return _approvals;
}
-(NSMutableArray *)comments{
    if (!_comments) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}
-(NSMutableArray *)dynamics{
    if (!_dynamics) {
        _dynamics = [NSMutableArray array];
    }
    return _dynamics;
}


-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}

-(NSMutableArray *)highseas{
    if (!_highseas) {
        _highseas = [NSMutableArray array];
    }
    return _highseas;
}

-(NSMutableArray *)auths{
    if (!_auths) {
        _auths = [NSMutableArray array];
    }
    return _auths;
}

-(NSMutableArray *)changes{
    if (!_changes) {
        _changes = [NSMutableArray<TFCustomChangeModel> array];
    }
    return _changes;
}

-(UIButton *)button{
    if (!_button) {
        
        UIButton *button = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH-40,CGRectGetMaxY(self.headerView.frame),40,39.5} target:self action:@selector(buttonClick)];
        button.backgroundColor = WhiteColor;
        [self.view insertSubview:button aboveSubview:self.customDetailScrollView];
        [button setImage:[UIImage imageNamed:@"taskMenu"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"taskMenu"] forState:UIControlStateHighlighted];
        button.layer.shadowOffset = CGSizeMake(-20, 0);
        button.layer.shadowColor = CellSeparatorColor.CGColor;
        button.layer.shadowRadius = 10;
        button.layer.shadowOpacity = 0.5;
        _button = button;
        button.hidden = YES;
    }
    return _button;
}

- (void)buttonClick{
    
    [self.referanceModelView showAnimation];
}

#pragma mark - TFReferanceModelViewDelegate
-(void)referanceModelViewDidReferance:(TFRelevanceTradeModel *)referance{
    
    [self customDetailScrollViewDidClickedWithModel:referance];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:ClearColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(leftClick) image:@"返回白色" highlightImage:@"返回白色"];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HexAColor(0xffffff, self.customDetailScrollView.top/40.0),NSFontAttributeName:BFONT(20)}];
    
    IQKeyboardManager *keyBoard = [IQKeyboardManager sharedManager];
    keyBoard.enable = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
}

- (void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexAColor(0xc8c8c8, 1) size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:BlackTextColor,NSFontAttributeName:BFONT(20)}];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HexAColor(0xffffff, self.customDetailScrollView.top/40.0),NSFontAttributeName:BFONT(20)}];
    
    IQKeyboardManager *keyBoard = [IQKeyboardManager sharedManager];
    keyBoard.enable = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFromNavBottomEdgeLayout];
    self.view.backgroundColor = WhiteColor;
    self.emailBL = [TFMailBL build];
    self.emailBL.delegate = self;
    self.pageNum = 1;
    self.pageSize = 20000;
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    /** 因页签功能统一，下面两个接口 */
//    [self.customBL requsetCustomReferenceListWithBean:self.bean dataId:self.dataId];// 被关联模块的列表及第一个字段
//    [self.customBL requestAutoMatchModuleWithBean:self.bean];// 获取模块自动匹配模块列表
    [self.customBL requestTabListWithBean:self.bean dataId:self.dataId];// 获取页签列表
    [self.customBL requestCustomModuleAuthWithBean:self.bean];
    [self.customBL requestCustomModuleChangeListWithBean:self.bean];
    [self.customBL requestHighseaListWithBean:self.bean];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentAddDynamic:) name:@"NotificationCommentAndDynamic" object:nil];
    
//    [self setupNavi];
    [self setupDetailHeader];
    [self setupCustomDetailScrollView];
    [self.view insertSubview:self.button aboveSubview:self.customDetailScrollView];
    [self setupTableView];
    [self setupChildVC];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appAction) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

-(void)appAction{
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:ClearColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
    
}

- (void)keyBoardWillShow:(NSNotification *)noti {
    
    NSDictionary *userInfo = noti.userInfo;
    NSValue *endValue      = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame        = endValue.CGRectValue;
    //处理键盘弹出
    [self.keyboard handleKeyBoardShow:endFrame];
    
    [UIView animateWithDuration:keyBoardTipTime animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, endFrame.size.height+44, 0);
    }completion:^(BOOL finished) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height-self.tableView.height + endFrame.size.height+44) animated:YES];
    }];
    
}

- (void)keyBoardWillHide:(NSNotification *)noti {
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
}


#pragma mark ==== LiuqsEmotionKeyBoardDelegate ====
-(void)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"@"]) {
        
//        [self didHeartBtn:nil];
        
    }
}

-(void)recordStarting{
    
    self.enablePanGesture = NO;
}

-(void)cancelStarting{
    
    self.enablePanGesture = YES;
}

#pragma mark - @功能选人
-(void)didHeartBtn:(UIButton *)button{
    
    
    TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
    scheduleVC.selectType = 1;
    scheduleVC.isSingleSelect = YES;
    scheduleVC.actionParameter = ^(NSArray *peoples) {
        
        NSString *str = @"";
        [self.peoples addObjectsFromArray:peoples];
        for (HQEmployModel *model in self.peoples) {
            str = [NSString stringWithFormat:@"%@,",model.employeeName?:model.employee_name];
        }
        str = [str substringToIndex:str.length-1];
        self.keyboard.textView.text = [NSString stringWithFormat:@"@%@%@ ",self.keyboard.textView.text,str];
        
        for (HQEmployModel *model in self.peoples) {
            
            NSString *str1 = [NSString stringWithFormat:@"%@",model.employeeName?:model.employee_name];
            
            NSRange range = [self.keyboard.textView.text rangeOfString:str1];
            model.location = @(range.location);
            model.length = @(range.length);
            
        }
        self.jump = 0;
        [self.keyboard.textView becomeFirstResponder];
        
    };
    self.jump = 1;
    [self.navigationController pushViewController:scheduleVC animated:YES];
}

#pragma mark - 文字改变
- (void)textViewDidChange:(UITextView *)textView{
    
    
    NSString *str = textView.text;
    
    if (str.length == 0) {
        self.keyboard.textView.placeholder = @"说点什么吧...";
    }else{
        self.keyboard.textView.placeholder = @"";
    }
    
    for (HQEmployModel *model in self.peoples) {
        
        NSString *str1 = [NSString stringWithFormat:@"@%@",model.employeeName?:model.employee_name];
        
        if (![str containsString:str1]) {
            
            // 剩余名字位置
            NSRange range = NSMakeRange([model.location integerValue], [model.length integerValue]-1);
            
            if (range.location + range.length > textView.text.length) {// 考虑删除多个字
                
                [self.peoples removeObject:model];
                continue;
            }
            
            str = [str stringByReplacingCharactersInRange:range withString:@""];
            textView.text = str;
            
            [self.peoples removeObject:model];
            break;
        }else{
            
            NSRange range = [str rangeOfString:str1];
            model.location = @(range.location);
            model.length = @(range.length);
        }
    }
    
}


//发送按钮的事件
- (void)sendButtonEventsWithPlainString:(NSString *)PlainStr {
    
    if (!PlainStr.length) {
        [MBProgressHUD showError:@"请输入内容" toView:self.view];
        return;
    }
    //点击发送，发出一条消息
    [self prepareTextMessage:PlainStr];
    
    self.keyboard.textView.text = @"";
    [self.keyboard.topBar resetSubsives];
    
}

/** 发送语音 */
-(void)sendVoiceWithVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration{
    
    
    NSURL *mp3Url = [HQHelper recordCafToMp3WithCafUrl:voicePath toMp3Url:[self getMp3Path]];
    
    [self SendMessageWithVoice:[mp3Url absoluteString]
                 voiceDuration:voiceDuration];
    
    //    [self SendMessageWithVoice:voicePath
    //                 voiceDuration:voiceDuration];
}


/** 发送其他 */
-(void)sendAddItemContentWithIndex:(NSInteger)index{
    
    switch (index) {
        case 0:
        {
            [self openCamera];
        }
            break;
        case 1:
        {
            [self openAlbum];
        }
            break;
        case 2:
        {
            [self pushFileLibray];
        }
            break;
        case 3:
        {
            [self didHeartBtn:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ---文件库选
- (void)pushFileLibray {
    
    TFFileMenuController *fileVC = [[TFFileMenuController alloc] init];
    
    fileVC.isFileLibraySelect = YES;
    
    fileVC.refreshAction = ^(id parameter) {
        
        TFFolderListModel *model = parameter;
        
        TFCustomerCommentModel *commentModel = [[TFCustomerCommentModel alloc] init];
        commentModel.fileUrl = model.fileUrl;
        commentModel.fileName = model.name;
        commentModel.fileType = model.siffix;
        commentModel.fileSize = @([model.size integerValue]);
        
        commentModel.employee_name = UM.userLoginInfo.employee.employee_name;
        commentModel.employee_id = UM.userLoginInfo.employee.id;
        commentModel.picture = UM.userLoginInfo.employee.picture;
        commentModel.datetime_time = @([HQHelper getNowTimeSp]);
        
        self.commentModel = commentModel;
        
        model.siffix = [model.siffix stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:model.fileUrl forKey:@"file_url"];
        [dic setObject:@([model.size integerValue]) forKey:@"file_size"];
        [dic setObject:model.siffix forKey:@"file_type"];
        [dic setObject:model.name forKey:@"file_name"];
        
        [dic setObject:@([HQHelper getNowTimeSp]) forKey:@"datetime_time"];
        
        //        [self.dynamics addObject:commentModel];
        
        NSMutableArray *files = [NSMutableArray array];
        
        //        if (dic) {
        //
        //            if ([[[dic valueForKey:@"file_type"] lowercaseString] isEqualToString:@"mp3"] || [[[dic valueForKey:@"file_type"] lowercaseString] isEqualToString:@"amr"]) {
        //
        //                CGFloat timeSp = [self.commentModel.voiceTime floatValue]*1000;
        //
        //                NSString *str = [NSString stringWithFormat:@"%.0f",timeSp];
        //
        //                [dic setObject:@([str integerValue]) forKey:@"voiceTime"];
        //            }
        //        }
        
        [files addObject:dic];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.bean forKey:@"bean"];
        [dict setObject:self.dataId forKey:@"relation_id"];
        [dict setObject:files forKey:@"information"];
        [dict setObject:@"" forKey:@"content"];
        
        
        [self.customBL requestCustomModuleCommentWithDict:dict];
        
        
        
    };
    
    [self.navigationController pushViewController:fileVC animated:YES];
}


#pragma mark - 发送文本
/** 发送文本消息 */
- (void)prepareTextMessage:(NSString *)text {
    
    
    if (text.length) {
        
        NSMutableArray *arr = [NSMutableArray array];
        NSString *str = @"";
        for (HQEmployModel *mode in self.peoples) {
            [arr addObject:mode.sign_id];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[mode.sign_id description]]];
        }
        if (str.length) {
            str = [str substringToIndex:str.length-1];
        }
        [self.peoples removeAllObjects];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [dict setObject:self.bean forKey:@"bean"];
        [dict setObject:self.dataId forKey:@"relation_id"];
        [dict setObject:text forKey:@"content"];
        [dict setObject:str forKey:@"at_employee"];
        [dict setObject:@[] forKey:@"information"];
        [dict setObject:@0 forKey:@"type"];
        
        TFCustomerCommentModel *model = [[TFCustomerCommentModel alloc] init];
        model.content = text;
        model.employee_name = UM.userLoginInfo.employee.employee_name;
        model.employee_id = UM.userLoginInfo.employee.id;
        model.picture = UM.userLoginInfo.employee.picture;
        model.datetime_time = @([HQHelper getNowTimeSp]);
        
        self.commentModel = model;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestCustomModuleCommentWithDict:dict];
        
    }else{
        
        [MBProgressHUD showError:@"请输入内容" toView:self.view];
    }
}


#pragma mark - RecorderPath Helper Method
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


#pragma mark - Message Send helper Method
#pragma mark --发送语音
- (void)SendMessageWithVoice:(NSString *)voicePath
               voiceDuration:(NSString*)voiceDuration {
    HQLog(@"Action - SendMessageWithVoice");
    
    TFCustomerCommentModel *model = [[TFCustomerCommentModel alloc] init];
    
    model.fileUrl = voicePath;
    model.fileType = @"mp3";
    model.voiceTime = @([voiceDuration doubleValue]);
    
    model.employee_name = UM.userLoginInfo.employee.employee_name;
    model.employee_id = UM.userLoginInfo.employee.id;
    model.picture = UM.userLoginInfo.employee.picture;
    model.datetime_time = @([HQHelper getNowTimeSp]);
    model.content = @"";
    
    self.commentModel = model;
    //    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setObject:self.bean forKey:@"bean"];
    //    [dict setObject:self.id forKey:@"relation_id"];
    //    [dict setObject:@[] forKey:@"information"];
    //    [self.tableView reloadData];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //    审批  approval    邮件 email    文件  file_library   备忘录  note
    if ([self.bean isEqualToString:@"file_library"] || [self.bean isEqualToString:@"approval"] || [self.bean isEqualToString:@"email"] || [self.bean isEqualToString:@"memo"])  {
        
        [self.customBL chatFileWithImages:@[] withVioces:@[voicePath] bean:self.bean];
    }else{
        [self.customBL uploadFileWithImages:@[] withAudios:@[voicePath] bean:self.bean];
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
        UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        // 添加图片
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        NSString *fileName = [representation filename];
        HQLog(@"fileName : %@",fileName);
        
        
        TFCustomerCommentModel *model = [[TFCustomerCommentModel alloc] init];
        
        model.fileType = @"jpg";
        model.image = image;
        
        model.employee_name = UM.userLoginInfo.employee.employee_name;
        model.employee_id = UM.userLoginInfo.employee.id;
        model.picture = UM.userLoginInfo.employee.picture;
        model.datetime_time = @([HQHelper getNowTimeSp]);
        model.content = @"";
        
        self.commentModel = model;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        if ([self.bean isEqualToString:@"file_library"]|| [self.bean isEqualToString:@"approval"] || [self.bean isEqualToString:@"email"] || [self.bean isEqualToString:@"memo"]) {
            
            [self.customBL chatFileWithImages:@[image] withVioces:@[] bean:self.bean];
        }else{
            [self.customBL uploadFileWithImages:@[image] withAudios:@[] bean:self.bean];
        }
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
    
    
    TFCustomerCommentModel *model = [[TFCustomerCommentModel alloc] init];
    
    model.image = image;
    model.fileType = @"jpg";
    
    model.employee_name = UM.userLoginInfo.employee.employee_name;
    model.employee_id = UM.userLoginInfo.employee.id;
    model.picture = UM.userLoginInfo.employee.picture;
    model.datetime_time = @([HQHelper getNowTimeSp]);
    model.content = @"";
    
    self.commentModel = model;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([self.bean isEqualToString:@"file_library"]|| [self.bean isEqualToString:@"approval"] || [self.bean isEqualToString:@"email"] || [self.bean isEqualToString:@"memo"]) {
        
        [self.customBL chatFileWithImages:@[image] withVioces:@[] bean:self.bean];
    }else{
        [self.customBL uploadFileWithImages:@[image] withAudios:@[] bean:self.bean];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)tableViewHeightChange:(NSNotification *)noti{
    
    self.childVc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, [noti.object floatValue]);
    self.childVc.tableViewHeight = [noti.object floatValue];
    self.tableView.tableHeaderView = self.childVc.view;
    
}

- (void)dealloc{
    self.childVc = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)commentAddDynamic:(NSNotification *)note{
//
//    if (!note.object) return;
//
//    NSNumber *num = nil;
//    if ([note.object isKindOfClass:[NSNumber class]]) {
//        num = note.object;
//    }
//    if ([note.object isKindOfClass:[NSString class]]) {
//        num = @([note.object integerValue]);
//    }
//
//    if ([self.dataId isEqualToNumber:num]) {
//
//        self.commentAndDynamicDict = note.userInfo;
//        [self setupCommentTabBar];
//    }
//
//}

#pragma mark - 底部评论、动态、邮件
- (void)setupCommentTabBar{
    
    if (!self.commentAndDynamicDict) return;
    
    NSMutableArray *strs = [NSMutableArray array];
    if ([[self.commentAndDynamicDict valueForKey:@"commentControl"] isEqualToString:@"1"]) {
        
        [strs addObject:@"评论"];
        [self setupCommentView];
        
        self.keyboard = [LiuqsEmoticonKeyBoard showKeyBoardInView:self.view type:1];
        self.keyboard.textView.placeholder = @"说点什么吧...";
        self.keyboard.delegate = self;
        [self.keyboard hideKeyBoard];
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    }
    
    if ([[self.commentAndDynamicDict valueForKey:@"dynamicControl"] isEqualToString:@"1"]) {
        
        [strs addObject:@"动态"];
        [self setupDynamicsView];
    }
    /** 需求更改，放页签上了 20180929 */
//    if ([[self.commentAndDynamicDict valueForKey:@"emailControl"] isEqualToString:@"1"]) {
//
//        [strs addObject:@"邮件"];
//        [self setupEmailView];
//    }
    if (![[self.commentAndDynamicDict valueForKey:@"approvalControl"] isEqualToString:@""]) {
        
        [strs addObject:@"审批"];
        [self setupApprovalView];
    }
    
    self.bottomBtns = strs;
    
    CGFloat width = 70;
    
    UIView *view1 = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,strs.count == 0? 0: 48}];
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,8,SCREEN_WIDTH,strs.count == 0? 0: 40}];
    [view1 addSubview:view];
    view.backgroundColor = WhiteColor;
    for (NSInteger i = 0; i < strs.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(15 + i * width, 0, width, 40);
        [button setTitle:[NSString stringWithFormat:@" %@",strs[i]] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@" %@",strs[i]] forState:UIControlStateHighlighted];
        [button setTitle:[NSString stringWithFormat:@" %@",strs[i]] forState:UIControlStateSelected];
        [button setTitleColor:BlackTextColor forState:UIControlStateNormal];
        [button setTitleColor:BlackTextColor forState:UIControlStateHighlighted];
        [button setTitleColor:GreenColor forState:UIControlStateSelected];
        NSString *img = [NSString stringWithFormat:@"%@CD",strs[i]];
        NSString *imgS = [NSString stringWithFormat:@"%@CDS",strs[i]];
        [button setImage:IMG(img) forState:UIControlStateNormal];
        [button setImage:IMG(img) forState:UIControlStateHighlighted];
        [button setImage:IMG(imgS) forState:UIControlStateSelected];
        [view addSubview:button];
        button.tag = 0x123 + i;
        button.titleLabel.font = FONT(14);
        [button addTarget:self action:@selector(buttonTabClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.selected = YES;
        }
        UIView *line = [[UIView alloc] initWithFrame:(CGRect){15 + (i + 1) *width ,12,1,16}];
        line.backgroundColor = HexColor(0xd9d9d9);
        [view addSubview:line];
        if (i == strs.count-1) {
            line.hidden = YES;
        }
        [self.buttons addObject:button];
    }
    self.commentTabBar = view1;
    if (self.commentTable) {
        self.tableView.tableFooterView = self.commentTable;
    }else if (self.dynamicsTable){
        self.tableView.tableFooterView = self.dynamicsTable;
    }else if (self.emailTable){
        self.tableView.tableFooterView = self.emailTable;
    }else if (self.approvalView){
        self.tableView.tableFooterView = self.approvalView;
    }
    
    [self.tableView reloadData];
}

- (void)buttonTabClicked:(UIButton *)button{
    
    NSInteger tag = button.tag - 0x123;
    
    for (UIButton *btn in self.buttons) {
        btn.selected = NO;
    }
    button.selected = YES;
    
    NSString *str = self.bottomBtns[tag];
    self.selectIndex = tag;
    [self.keyboard hideKeyBoard];
    
    if ([str isEqualToString:@"评论"]) {
        self.tableView.tableFooterView = self.commentTable;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        self.keyboard.topBar.hidden = NO;
        [self.customBL requestCustomModuleCommentListWithBean:self.bean dataId:self.dataId];// 评论数据
    }
    if ([str isEqualToString:@"动态"]) {
        self.tableView.tableFooterView = self.dynamicsTable;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.keyboard.topBar.hidden = YES;
        [self.customBL requestCustomModuleDynamicListWithBean:self.bean dataId:self.dataId];// 动态数据
    }
    if ([str isEqualToString:@"邮件"]) {
        self.tableView.tableFooterView = self.emailTable;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.keyboard.topBar.hidden = YES;
    }
    if ([str isEqualToString:@"审批"]) {
        self.tableView.tableFooterView = self.approvalView;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.keyboard.topBar.hidden = YES;
        [self.customBL requsetApprovalWholeFlowWithProcessDefinitionId:nil bean:self.bean dataId:[self.dataId description]];
    }
    [self.tableView reloadData];
    
}

//
///** 底部tabBar */
//- (void)setupBottomTabBar{
//
//    if (!self.refrenceModel)  return;
//    if (!self.commentAndDynamicDict) return;
//
//    NSMutableArray *strs = [NSMutableArray array];
//    if ([[self.commentAndDynamicDict valueForKey:@"commentControl"] isEqualToString:@"1"]) {
//
//        [strs addObject:@"评论"];
//    }
//
//    if (self.refrenceModel.isOpenProcess && ![self.refrenceModel.isOpenProcess isEqualToNumber:@0]) {
//
//        [strs addObject:@"审批"];
//    }
//
//    if ([[self.commentAndDynamicDict valueForKey:@"dynamicControl"] isEqualToString:@"1"]) {
//
//        [strs addObject:@"动态"];
//    }
//
//    if ([[self.commentAndDynamicDict valueForKey:@"emailControl"] isEqualToString:@"1"]) {
//
//        [strs addObject:@"邮件"];
//    }
//
//    self.bottomBtns = strs;
//
//    if (strs.count) {
//
//        self.childVc.tableViewHeight = SCREEN_HEIGHT - CGRectGetMaxY(self.customDetailScrollView.frame)-64-49;
//    }else{
//
//        self.childVc.tableViewHeight = SCREEN_HEIGHT - CGRectGetMaxY(self.customDetailScrollView.frame)-64;
//    }
//
//
//    UITabBar *tabBar = [[UITabBar alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-64-50,SCREEN_WIDTH,49}];
//    tabBar.delegate = self;
//    NSMutableArray *items = [NSMutableArray array];
//    for (NSInteger i = 0; i < strs.count; i ++) {
//        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:strs[i] image:[[UIImage imageNamed:[NSString stringWithFormat:@"%@customDetail",strs[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@customDetail",strs[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [items addObject:item];
//        item.tag = 0x123 + i;
//        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//        textAttrs[NSForegroundColorAttributeName] = ExtraLightBlackTextColor;
//        textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
//        [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//        [item setTitleTextAttributes:textAttrs forState:UIControlStateSelected];
//    }
//    [tabBar setItems:items];
//
//    [self.view addSubview:tabBar];
//
//}
//
//#pragma mark - UITabBarDelegate
//-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//
//    NSInteger tag = item.tag - 0x123;
//    NSString *str = self.bottomBtns[tag];
//
//    if ([str isEqualToString:@"评论"]) {
//
//        TFCustomerCommentController *comment = [[TFCustomerCommentController alloc] init];
//        comment.bean = self.bean;
//        comment.id = self.dataId;
//        [self.navigationController pushViewController:comment animated:YES];
//    }
//    if ([str isEqualToString:@"动态"]) {
//
//        TFCustomerDynamicController *dynamic = [[TFCustomerDynamicController alloc] init];
//        dynamic.bean = self.bean;
//        dynamic.id = self.dataId;
//        [self.navigationController pushViewController:dynamic animated:YES];
//    }
//    if ([str isEqualToString:@"审批"]) {
//        TFCustomFlowController *flow = [[TFCustomFlowController alloc] init];
//        flow.bean = self.bean;
//        flow.dataId = self.dataId;
//
//        [self.navigationController pushViewController:flow animated:YES];
//    }
//    if ([str isEqualToString:@"邮件"]) {
//        TFCustomEmailListController *email = [[TFCustomEmailListController alloc] init];
//        email.emails = self.emails;
//        [self.navigationController pushViewController:email animated:YES];
//    }
//
//}

-(void)setupApprovalView{
        
    TFApprovalTableView *approvalView = [[TFApprovalTableView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,0}];
    self.approvalView = approvalView;
    approvalView.delegate = self;
    
    [self.customBL requsetApprovalWholeFlowWithProcessDefinitionId:nil bean:self.bean dataId:[self.dataId description]];
}

-(void)approvalTableView:(TFApprovalTableView *)approvalTableView didChangeHeight:(CGFloat)height{
    
    NSString *str = self.bottomBtns[self.selectIndex];
    self.approvalView.height = height;
    if ([str isEqualToString:@"审批"]) {
        self.tableView.tableFooterView = self.approvalView;
        [self.tableView reloadData];
    }
    
}

/** 导航栏 */
- (void)setupNavi{
    
    self.navigationItem.title = TEXT(self.layout.title);
    
    if (self.seaPoolId) {
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(highseaClick) image:@"菜单白色" highlightImage:@"菜单白色"];
        
    }else{
        
//        if (!self.lockedState) {
//            return;
//        }
        
        if ([self.lockedState isEqualToString:@"1"]) {
            
            NSMutableArray *arr = [NSMutableArray array];
            for (TFCustomAuthModel *model in self.auths) {
                if ([model.auth_code isEqualToNumber:@9]) {
                    [arr addObject:model];
                }
            }
            self.auths = arr;
            
        }
        
        if (self.auths.count && (![self.dataAuth isEqualToString:@"0"] || !self.dataAuth)) {
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightClick) image:@"菜单白色" highlightImage:@"菜单白色"];
        }
    }
}

- (void)highseaClick{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    if ([self.isSeasAdmin isEqualToString:@"1"]) {
        
        if (self.highseas.count) {
            [arr addObjectsFromArray:@[@"领取",@"编辑",@"分配",@"删除",@"移动"]];
        }else{
            
            [arr addObjectsFromArray:@[@"领取",@"编辑",@"分配",@"删除"]];
        }
        
    }else{
        
        [arr addObject:@"领取"];
    }
    self.menus = arr;
    
//    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"设置" delegate:self cancelButtonTitle:@"取消" titles:arr];
//    sheet.tag = 0x111;
//    sheet.delegate = self;
//    [sheet show];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"设置" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *str in self.menus) {
        [sheet addButtonWithTitle:str];
    }
    sheet.tag = 0x111;
    [sheet showInView:self.view];
    
}

- (void)rightClick{
    
    if (!self.auths.count)return;
    
    NSMutableArray *strs = [NSMutableArray array];
    
    for (TFCustomAuthModel *model in self.auths) {
        if (model.func_name) {
            [strs addObject:model.func_name];
        }
    }
    
    self.menus = strs;
    
//    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"设置" delegate:self cancelButtonTitle:@"取消" titles:strs];
//    sheet.delegate = self;
//    [sheet show];
    
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"设置" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *str in self.menus) {
        [sheet addButtonWithTitle:str];
    }
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        return;
    }
    NSString *str = self.menus[buttonIndex - 1];
    
    if (actionSheet.tag == 0x111) {// 公海池
        
        if ([str isEqualToString:@"领取"]) {
            
            // 领取
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.customBL requestHighseaTakeWithDataId:self.dataId bean:self.bean seasPoolId:self.seaPoolId];
            
        }
        else if ([str isEqualToString:@"编辑"]) {
            
            // 编辑
            TFAddCustomController *add = [[TFAddCustomController alloc] init];
            add.type = 2;
            add.taskKey = self.taskKey;
            add.tableViewHeight = SCREEN_HEIGHT - NaviHeight;
            add.bean = self.bean;
            add.dataId = self.dataId;
            add.isSeasPool = @"1";
            add.seaPoolId = self.seaPoolId;
            add.moduleId = self.moduleId;
            add.isSeasAdmin = self.isSeasAdmin;
            add.refreshAction = ^{
                
                if (self.childVc.refreshAction) {
                    self.childVc.refreshAction();
                }
                if (self.refreshAction) {
                    self.refreshAction();
                }
            };
            [self.navigationController pushViewController:add animated:YES];
            
        }
        else if ([str isEqualToString:@"分配"]){
            
            // 分配
            TFHighseaAllocateController *allocate = [[TFHighseaAllocateController alloc] init];
            
            allocate.dataId = self.dataId;
            allocate.bean = self.bean;
            allocate.seaPoolId = self.seaPoolId;
            allocate.refreshAction = ^{
                if (self.deleteAction) {
                    self.deleteAction();
                }
                [self.navigationController popViewControllerAnimated:YES];
            };
            
            [self.navigationController pushViewController:allocate animated:YES];
            
        }
        else if ([str isEqualToString:@"移动"]){
            
            // 移动
            TFHighseaMoveController *move = [[TFHighseaMoveController alloc] init];
            move.type = 0;
            move.dataId = self.dataId;
            move.bean = self.bean;
            move.seaPoolId = self.seaPoolId;
            move.dataSource = self.highseas;
            move.refreshAction = ^{
                
                if (self.deleteAction) {
                    
                    self.deleteAction();
                }
                [self.navigationController popViewControllerAnimated:YES];
            };
            
            [self.navigationController pushViewController:move animated:YES];
        }
        else if ([str isEqualToString:@"删除"]){
            
            // 删除
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除后不可恢复，确认要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 0x555;
            alertView.delegate = self;
            [alertView show];
        }
        
    }
    else{
        if ([str isEqualToString:@"新增"]) {
            // 新增
            TFAddCustomController *add = [[TFAddCustomController alloc] init];
            add.type = 0;
            add.tableViewHeight = SCREEN_HEIGHT - NaviHeight;
            add.bean = self.bean;
            add.moduleId = self.moduleId;
            [self.navigationController pushViewController:add animated:YES];
            
        }
        else if ([str isEqualToString:@"导出"]) {
            
            // 导出
            [MBProgressHUD showError:@"移动端无法导出" toView:self.view];
            
        }
        else if ([str isEqualToString:@"编辑"]) {// 编辑
                
            TFAddCustomController *add = [[TFAddCustomController alloc] init];
            add.type = 2;
            add.tableViewHeight = SCREEN_HEIGHT - NaviHeight;
            add.bean = self.bean;
            add.dataId = self.dataId;
            add.moduleId = self.moduleId;
            add.refreshAction = ^{
                
                if (self.childVc.refreshAction) {
                    self.childVc.refreshAction();
                }
                if (self.refreshAction) {
                    self.refreshAction();
                }
            };
            [self.navigationController pushViewController:add animated:YES];
            
        }
        else if ([str isEqualToString:@"共享"]){
            
            TFCustomShareController *share = [[TFCustomShareController alloc] init];
            share.type = 0;
            share.dataId = self.dataId;
            share.bean = self.bean;
            [self.navigationController pushViewController:share animated:YES];
        }
        else if ([str isEqualToString:@"删除"]){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除后不可恢复，确认要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 0x555;
            alertView.delegate = self;
            [alertView show];
        }
        else if ([str isEqualToString:@"转换"]){
            
            if (self.changes.count == 0) {
                [MBProgressHUD showError:@"无转换模块" toView:self.view];
                return;
            }
            
            [TFCustomChangeView showCustomChangeView:@"可转换目标模块" items:self.changes onRightTouched:^(id parameter){
                
                NSMutableArray *ids = [NSMutableArray array];
                for (TFCustomChangeModel *model in parameter) {
                    
                    [ids addObject:model.id];
                }
                
                [self.customBL requestCustomModuleChangeWithBean:self.bean dataId:self.dataId ids:ids];
                
            }];
            
        }
        else if ([str isEqualToString:@"转移负责人"]){
            
            TFCustomTransferController *transfer = [[TFCustomTransferController alloc] init];
            transfer.bean = self.bean;
            transfer.dataId = self.dataId;
            NSArray *ar = [self.detailDict valueForKey:@"personnel_principal"];
            transfer.principal = ar.firstObject;
            transfer.refreshAction = ^{
                
                if (self.childVc.refreshAction) {
                    self.childVc.refreshAction();
                }
                if (self.refreshAction) {
                    self.refreshAction();
                }
            };
            [self.navigationController pushViewController:transfer animated:YES];
            
        }
        else if ([str isEqualToString:@"打印"]){
            
            [MBProgressHUD showError:@"移动端无法打印" toView:self.view];
            
        }
        else if ([str isEqualToString:@"复制"]){
            
            TFAddCustomController *add = [[TFAddCustomController alloc] init];
            add.type = 3;
            add.tableViewHeight = SCREEN_HEIGHT - NaviHeight;
            add.bean = self.bean;
            add.dataId = self.dataId;
            add.moduleId = self.moduleId;
            add.refreshAction = ^{
                
                if (self.refreshAction) {
                    self.refreshAction();
                }
            };
            [self.navigationController pushViewController:add animated:YES];
            
        }
        else if ([str isEqualToString:@"退回公海池"]){
            
            TFHighseaMoveController *move = [[TFHighseaMoveController alloc] init];
            move.type = 1;
            move.dataId = self.dataId;
            move.bean = self.bean;
            move.dataSource = self.highseas;
            move.refreshAction = ^{
                
                if (self.deleteAction) {
                    self.deleteAction();
                }
                [self.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:move animated:YES];
            
        }
        
    }
    
}

#pragma mark - FDActionSheetDelegate
-(void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    
    
    if (sheet.tag == 0x111) {// 公海池
        
        if ([self.isSeasAdmin isEqualToString:@"1"]) {
            
            // @"领取",@"编辑",@"分配",@"移动",@"删除"
            if (buttonIndex == 0) {
                
                // 领取
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.customBL requestHighseaTakeWithDataId:self.dataId bean:self.bean seasPoolId:self.seaPoolId];
                
            }else if (buttonIndex == 1){
                // 编辑
                TFAddCustomController *add = [[TFAddCustomController alloc] init];
                add.type = 2;
                add.taskKey = self.taskKey;
                add.tableViewHeight = SCREEN_HEIGHT - NaviHeight;
                add.bean = self.bean;
                add.dataId = self.dataId;
                add.isSeasPool = @"1";
                add.seaPoolId = self.seaPoolId;
                add.moduleId = self.moduleId;
                add.refreshAction = ^{
                    
                    if (self.childVc.refreshAction) {
                        self.childVc.refreshAction();
                    }
                    if (self.refreshAction) {
                        self.refreshAction();
                    }
                };
                [self.navigationController pushViewController:add animated:YES];
                
            }else if (buttonIndex == 2){
                // 分配
                TFHighseaAllocateController *allocate = [[TFHighseaAllocateController alloc] init];
                
                allocate.dataId = self.dataId;
                allocate.bean = self.bean;
                allocate.seaPoolId = self.seaPoolId;
                allocate.refreshAction = ^{
                    if (self.deleteAction) {
                        self.deleteAction();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                };
                
                [self.navigationController pushViewController:allocate animated:YES];
                
            }else if (buttonIndex == 3){
                
                // 删除
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除后不可恢复，确认要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 0x555;
                alertView.delegate = self;
                [alertView show];
                
            }else{
                
                // 移动
                TFHighseaMoveController *move = [[TFHighseaMoveController alloc] init];
                move.type = 0;
                move.dataId = self.dataId;
                move.bean = self.bean;
                move.seaPoolId = self.seaPoolId;
                move.dataSource = self.highseas;
                move.refreshAction = ^{
                    
                    if (self.deleteAction) {
                        
                        self.deleteAction();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                };
                
                [self.navigationController pushViewController:move animated:YES];
                
            }
            
        }else{
            
            // 领取
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.customBL requestHighseaTakeWithDataId:self.dataId bean:self.bean seasPoolId:self.seaPoolId];
            
        }
        
        return;
    }
    
    
    // 权限
    TFCustomAuthModel *model = self.auths[buttonIndex];
    
    switch ([model.auth_code integerValue]) {
        case 1:// 新增
        {
            TFAddCustomController *add = [[TFAddCustomController alloc] init];
            add.type = 0;
            add.tableViewHeight = SCREEN_HEIGHT - NaviHeight;
            add.bean = self.bean;
            add.moduleId = self.moduleId;
            [self.navigationController pushViewController:add animated:YES];
            
        }
            break;
        case 2: // 导出
        {
            [MBProgressHUD showError:@"移动端无法导出" toView:self.view];
            
        }
            break;
        case 3:// 编辑
        {
            
            TFAddCustomController *add = [[TFAddCustomController alloc] init];
            add.type = 2;
            add.tableViewHeight = SCREEN_HEIGHT - NaviHeight;
            add.bean = self.bean;
            add.dataId = self.dataId;
            add.moduleId = self.moduleId;
            add.refreshAction = ^{
                
                if (self.childVc.refreshAction) {
                    self.childVc.refreshAction();
                }
                if (self.refreshAction) {
                    self.refreshAction();
                }
            };
            [self.navigationController pushViewController:add animated:YES];
        }
            break;
        case 4:// 共享
        {
            
            TFCustomShareController *share = [[TFCustomShareController alloc] init];
            share.type = 0;
            share.dataId = self.dataId;
            share.bean = self.bean;
            [self.navigationController pushViewController:share animated:YES];
        }
            break;
        case 5:// 删除
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除后不可恢复，确认要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 0x555;
            alertView.delegate = self;
            [alertView show];
            
        }
            break;
        case 6:// 转换
        {
            if (self.changes.count == 0) {
                [MBProgressHUD showError:@"无转换模块" toView:self.view];
                return;
            }
            
            [TFCustomChangeView showCustomChangeView:@"可转换目标模块" items:self.changes onRightTouched:^(id parameter){
                
                NSMutableArray *ids = [NSMutableArray array];
                for (TFCustomChangeModel *model in parameter) {
                    
                    [ids addObject:model.id];
                }
                
                [self.customBL requestCustomModuleChangeWithBean:self.bean dataId:self.dataId ids:ids];
                
            }];
            
            
        }
            break;
        case 7:// 转移负责人
        {
            //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定将当前数据的负责人转移给其他负责人？" message:@"转移成功后，该操作将无法恢复。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            //            alertView.tag = 0x777;
            //            alertView.delegate = self;
            //            [alertView show];
            
            TFCustomTransferController *transfer = [[TFCustomTransferController alloc] init];
            transfer.bean = self.bean;
            transfer.dataId = self.dataId;
            transfer.refreshAction = ^{
                
                if (self.childVc.refreshAction) {
                    self.childVc.refreshAction();
                }
                if (self.refreshAction) {
                    self.refreshAction();
                }
            };
            [self.navigationController pushViewController:transfer animated:YES];
        }
            break;
        case 8:// 打印
        {
            [MBProgressHUD showError:@"移动端无法打印" toView:self.view];
            
        }
            break;
        case 9:// 复制
        {
            TFAddCustomController *add = [[TFAddCustomController alloc] init];
            add.type = 3;
            add.tableViewHeight = SCREEN_HEIGHT - NaviHeight;
            add.bean = self.bean;
            add.dataId = self.dataId;
            add.moduleId = self.moduleId;
            add.refreshAction = ^{
                
                if (self.refreshAction) {
                    self.refreshAction();
                }
            };
            [self.navigationController pushViewController:add animated:YES];
        }
            break;
        case 10:// 退回
        {
            TFHighseaMoveController *move = [[TFHighseaMoveController alloc] init];
            move.type = 1;
            move.dataId = self.dataId;
            move.bean = self.bean;
            move.dataSource = self.highseas;
            move.refreshAction = ^{
                
                if (self.deleteAction) {
                    self.deleteAction();
                }
                [self.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:move animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.tag == 0x555) {// 删除
        if (buttonIndex == 1) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSString *subform = @"";
            for (NSString *str in [self.detailDict allKeys]) {
                
                if ([str containsString:@"subform"]) {
                    subform = [subform stringByAppendingString:[NSString stringWithFormat:@"%@,",str]];
                }
            }
            if (subform.length) {
                subform = [subform substringToIndex:subform.length-1];
            }
            
            [self.customBL requsetCustomDeleteWithBean:self.bean dataId:self.dataId subformFields:subform];
        }
    }
    
}


/** 头部控件 */
- (void)setupDetailHeader{
    TFCustomDetaiHeaderView *headerView = [TFCustomDetaiHeaderView customDetaiHeaderView];
    self.headerView = headerView;
    self.headerView.logo.hidden = YES;
    [self.view addSubview:headerView];
    
}

/** 模块滚动控件 */
- (void)setupCustomDetailScrollView{
    TFCustomDetailScrollView *customDetailScrollView = [[TFCustomDetailScrollView alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(self.headerView.frame),SCREEN_WIDTH-40,0}];
    [customDetailScrollView refreshScrollViewWithItems:@[] type:1];
    [self.view addSubview:customDetailScrollView];
    self.customDetailScrollView = customDetailScrollView;
    customDetailScrollView.delegate1 = self;
    customDetailScrollView.backgroundColor = WhiteColor;
    
}

#pragma mark - TFCustomDetailScrollViewDelegate
-(void)customDetailScrollViewDidClickedWithModel:(TFRelevanceTradeModel *)model{
    
//    if (model.isAuto) {// 自动匹配列表
//
//        TFAutoMatchDataListController *match = [[TFAutoMatchDataListController alloc] init];
//        match.relevance = model;
//        match.dataId = self.dataId;
//        [self.navigationController pushViewController:match animated:YES];
//
//    }else{// 关联列表
//
//        TFReferenceListController *list = [[TFReferenceListController alloc] init];
//        list.dataId = self.dataId;
//        list.bean = model.moduleName;
//        list.naviTitle = model.moduleLabel;
//        list.fieldName = model.fieldName;
//        list.lastDetailDict = self.detailDict;
//        [self.navigationController pushViewController:list animated:YES];
//    }
    
    //  0 自定义页签 1关联关系 2邮件 3自动化匹配
    if ([model.condition_type isEqualToNumber:@0]) {
        
        TFReferenceListController *list = [[TFReferenceListController alloc] init];
        list.dataId = self.dataId;
        list.bean = model.target_bean;
        list.naviTitle = model.chinese_name;
        list.tradeModel = model;
        [self.navigationController pushViewController:list animated:YES];
        
    }else if ([model.condition_type isEqualToNumber:@1]){
        
        TFReferenceListController *list = [[TFReferenceListController alloc] init];
        list.dataId = self.dataId;
        list.bean = model.target_bean;
        list.naviTitle = model.chinese_name;
        list.fieldName = model.fieldName;
        list.lastDetailDict = self.detailDict;
        list.tradeModel = model;
        list.sorceBean = model.sorce_bean;
        list.targetBean = model.target_bean;
        [self.navigationController pushViewController:list animated:YES];
        
    }else if ([model.condition_type isEqualToNumber:@2]){
        
        TFCustomEmailListController *email = [[TFCustomEmailListController alloc] init];
        email.emails = self.emails;
        email.relevance = model;
        email.dataId = self.dataId;
        email.dataAuth = self.auth.data_auth;
        [self.navigationController pushViewController:email animated:YES];
        
    }else if ([model.condition_type isEqualToNumber:@3]){
        
        TFAutoMatchDataListController *match = [[TFAutoMatchDataListController alloc] init];
        match.relevance = model;
        match.dataId = self.dataId;
        match.dataAuth = self.auth.data_auth;
        [self.navigationController pushViewController:match animated:YES];
    }
    
    
}

/** 子控制器 */
- (void)setupChildVC{
    
    TFAddCustomController *add = [[TFAddCustomController alloc] init];
    add.vcTag = [self.dataId integerValue];
    add.isChild = YES;
    add.fatherRefresh = ^{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    };
    add.type = 1;
    add.translucent = YES;
    add.tableViewHeight = SCREEN_HEIGHT - CGRectGetMaxY(self.customDetailScrollView.frame)-NaviHeight;
    add.bean = self.bean;
    add.dataId = self.dataId;
    add.seaPoolId = self.seaPoolId;
    add.isSeasAdmin = self.isSeasAdmin;
    if (self.seaPoolId) {
        add.isSeasPool = @"1";
    }
    add.moduleId = self.moduleId;
    add.emailBlock = ^(NSArray *parameter) {

        self.emails = parameter;

//        NSString *str = @"";
//        for (NSString *sss in self.emails) {
//
//            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",sss]];
//        }
//        if (str.length) {
//            str = [str substringToIndex:str.length-1];
//        }
//
//        [self.emailBL getCustomEmailListWithPageNum:self.pageNum pageSize:self.pageSize accountName:str];

    };
    add.detailBlock = ^(NSDictionary *parameter) {
        self.detailDict = parameter;
        self.lockedState = [[self.detailDict valueForKey:@"lockedState"] description];
        self.moduleId = [self.detailDict valueForKey:@"module_id"];
        
        TFFieldNameModel *model = [[TFFieldNameModel alloc] initWithDictionary:[self.detailDict valueForKey:@"operationInfo"] error:nil];
        
        self.headerView.title = [HQHelper stringWithFieldNameModel:model];
        self.headerView.logo.hidden = NO;
        
        [self setupNavi];
    };
    add.commentBlock = ^(NSDictionary *parameter) {
        
        self.commentAndDynamicDict = parameter;
        [self setupCommentTabBar];
    };
    add.heightBlock = ^(NSNumber *parameter) {
        
        self.childVc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, [parameter floatValue]);
        self.childVc.tableViewHeight = [parameter floatValue];
        self.tableView.tableHeaderView = self.childVc.view;
    };
    add.layoutBlock = ^(TFCustomBaseModel *parameter) {
        self.layout = parameter;
        [self setupNavi];
    };
    
    [self addChildViewController:add];
    
    self.tableView.tableHeaderView = add.view;
    
    self.childVc = add;
    
}

/** 添加动态视图 */
-(void)setupDynamicsView{
    
    TFDynamicsTableView *dynamicsTable = [[TFDynamicsTableView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,0}];
    self.dynamicsTable = dynamicsTable;
    dynamicsTable.delegate = self;
    
    [self.customBL requestCustomModuleDynamicListWithBean:self.bean dataId:self.dataId];// 动态数据
}

#pragma mark - TFDynamicsTableViewDelegate
-(void)dynamicsTableView:(TFDynamicsTableView *)dynamicsTableView didChangeHeight:(CGFloat)height{
    
    NSString *str = self.bottomBtns[self.selectIndex];
    self.dynamicsTable.height = height;
    if ([str isEqualToString:@"动态"]) {
        self.tableView.tableFooterView = self.dynamicsTable;
        [self.tableView reloadData];
    }
    
}

/** 初始化邮件View */
- (void)setupEmailView{
    
    TFEmailTableView *emailTable = [[TFEmailTableView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,0}];
    self.emailTable = emailTable;
    [emailTable refreshEmailTableViewWithDatas:@[]];
    emailTable.delegate = self;
    
}

#pragma mark - TFEmailTableViewDelegate
-(void)emailTableView:(TFEmailTableView *)emailTableView didChangeHeight:(CGFloat)height{
    
    NSString *str = self.bottomBtns[self.selectIndex];
    self.emailTable.height = height;
    if ([str isEqualToString:@"邮件"]) {
        self.tableView.tableFooterView = self.emailTable;
        [self.tableView reloadData];
    }
}
-(void)emailTableViewDidClickedEmailWithModel:(TFEmailReceiveListModel *)model{
    
    TFEmailsDetailController *emailsDetaiVC = [[TFEmailsDetailController alloc] init];
    emailsDetaiVC.model = model;
    emailsDetaiVC.emailId = model.id;
    emailsDetaiVC.boxId = model.mail_box_id;
    emailsDetaiVC.refresh = ^{
        [self.emailTable refreshEmailTableViewWithDatas:self.emailModels];
    };
    [self.navigationController pushViewController:emailsDetaiVC animated:YES];
}


/** 添加评论View */
- (void)setupCommentView{
    
    TFCommentTableView *commentTable = [[TFCommentTableView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,0}];
    self.commentTable = commentTable;
    commentTable.delegate = self;
    
    [self.customBL requestCustomModuleCommentListWithBean:self.bean dataId:self.dataId];// 评论数据
}
#pragma mark - TFCommentTableViewDelegate
-(void)commentTableView:(TFCommentTableView *)commentTableView didChangeHeight:(CGFloat)height{
    
    NSString *str = self.bottomBtns[self.selectIndex];
    self.commentTable.height = height;
    if ([str isEqualToString:@"评论"]) {
        self.tableView.tableFooterView = self.commentTable;
        [self.tableView reloadData];
    }
}

-(void)commentTableViewDidClickVioce:(TFFileModel *)model{
    
    TFPlayVoiceController *play = [[TFPlayVoiceController alloc] init];
    play.file = model;
    [self.navigationController pushViewController:play animated:YES];
    
}

-(void)commentTableViewDidClickImage:(UIImageView *)imageView{
    
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

- (void)commentTableViewDidClickFile:(TFFileModel *)model{
    
    if ([[model.file_type lowercaseString] isEqualToString:@"jpg"] || [[model.file_type lowercaseString] isEqualToString:@"png"] || [[model.file_type lowercaseString] isEqualToString:@"gif"] || [[model.file_type lowercaseString] isEqualToString:@"jpeg"]) {// 查看图片
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.center = self.view.center;
        
        
        [self commentTableViewDidClickImage:view];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"doc"] ||
              [[model.file_type lowercaseString] isEqualToString:@"docx"] ||
              [[model.file_type lowercaseString] isEqualToString:@"xls"] ||
              [[model.file_type lowercaseString] isEqualToString:@"xlsx"] ||
              [[model.file_type lowercaseString] isEqualToString:@"ppt"] ||
              [[model.file_type lowercaseString] isEqualToString:@"pptx"] ||
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
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"mp3"]){
        
        
        TFPlayVoiceController *play = [[TFPlayVoiceController alloc] init];
        play.file = model;
        [self.navigationController pushViewController:play animated:YES];
        
    }else{
        
        [MBProgressHUD showError:@"未知文件无法预览" toView:self.view];
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


/** 关联及自动处理列表 */
- (void)referanceModuleAndAutoHandle{
    
//    if (!self.referances || !self.autos) {
//        return;
//    }
    
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObjectsFromArray:self.referances];
    [arr addObjectsFromArray:self.autos];
    
    [self.referanceModelView refreshReferanceViewWithModels:arr];
    [self.customDetailScrollView refreshScrollViewWithItems:arr type:1];
    if (arr.count) {
        self.customDetailScrollView.height = 40;
        self.button.hidden = NO;
        self.customDetailScrollView.line.hidden = NO;
    }else{
        self.customDetailScrollView.height = 0;
        self.button.hidden = YES;
        self.customDetailScrollView.line.hidden = YES;
    }
    self.tableView.top = CGRectGetMaxY(self.customDetailScrollView.frame);
    self.tableView.height = SCREEN_HEIGHT-NaviHeight-self.customDetailScrollView.height-BottomM;
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customApprovalWholeFlow) {
        
        NSArray *arrr = resp.body;
        
        [self.approvals removeAllObjects];
        for (NSInteger i = 0; i < arrr.count; i ++) {
            TFApprovalFlowModel *model = arrr[i];
            if ([model.task_key isEqualToString:@"endEvent"]) {// 去掉中间的endEvent
                if (i != arrr.count-1) {
                    continue;
                }
            }
            [self.approvals addObject:model];
        }
        
        for (NSInteger i = 1; i < self.approvals.count; i++) {
            TFApprovalFlowModel *flow = self.approvals[i-1];
            
            TFApprovalFlowModel *nextflow = self.approvals[i];
            
            nextflow.previousColor = flow.selfColor;
            if ([nextflow.task_status_id isEqualToString:@"-3"]) {
                nextflow.selfColor = flow.selfColor;
            }
            
            if ([nextflow.process_type isEqualToNumber:@0]) {// 固定流程
                
                if ([flow.task_key isEqualToString:nextflow.task_key]) {
                    
                    if ([nextflow.task_status_id isEqualToString:@"4"] || [nextflow.task_status_id isEqualToString:@"5"]) {
                        
                        nextflow.dot = @0;
                    }else{
                        nextflow.dot = @1;
                    }
                }else{
                    nextflow.dot = @0;
                }
                if ([flow.task_key isEqualToString:@"firstTask"]) {
                    flow.dot = @0;
                }
                
            }else{// 自由流程
                flow.dot = @0;
                nextflow.dot = @0;
                
            }
            
        }
        [self.approvalView refreshApprovalTableViewWithDatas:self.approvals];
        
    }
    if (resp.cmdId == HQCMD_customRefernceModule) {// 关联模块及第一个字段
        
        TFCustomDetailRefrenceModel *model = resp.body;
        self.refrenceModel = model;
        NSMutableArray *arr = [NSMutableArray array];
        
        for (TFRelevanceTradeModel *ddd in model.refModules) {
            
            if ([ddd.show isEqualToString:@"1"]) {
                [arr addObject:ddd];
            }
        }
        self.referances = arr;
        
        [self referanceModuleAndAutoHandle];
        
//        self.headerView.title = [HQHelper stringWithFieldNameModel:model.operationInfo];
//        self.headerView.logo.hidden = NO;
    
    }
    
    if (resp.cmdId == HQCMD_getAutoMatchModuleList) {// 自动匹配
        
        self.autos = resp.body;
        
        [self referanceModuleAndAutoHandle];
    }
    
    if (resp.cmdId == HQCMD_getTabList) {// 页签列表
        
        TFCustomDetailRefrenceModel *model = resp.body;
        self.refrenceModel = model;
        NSMutableArray *arr = [NSMutableArray array];
        
        for (TFRelevanceTradeModel *ddd in model.dataList) {
            if ([ddd.condition_type isEqualToNumber:@2]) {
                ddd.chinese_name = @"邮件";
            }
            if ([ddd.condition_type isEqualToNumber:@3]) {
                ddd.chinese_name = [NSString stringWithFormat:@"匹配.%@",ddd.chinese_name];
            }
            [arr addObject:ddd];
        }
        self.referances = arr;
        
        [self referanceModuleAndAutoHandle];
        
//        self.headerView.title = [HQHelper stringWithFieldNameModel:model.operationInfo];
//        self.headerView.logo.hidden = NO;
    }
    
    if (resp.cmdId == HQCMD_customModuleAuth) {// 权限
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (TFCustomAuthModel *model in resp.body) {
//            if ([model.data_auth integerValue] == 0) {
//                continue;
//            }
            
            switch ([model.auth_code integerValue]) {
                case 1:
                    model.func_name = @"新增";
                    break;
                case 2:
                    model.func_name = @"导出";
                    break;
                case 3:
                    model.func_name = @"编辑";
                    break;
                case 4:
                    model.func_name = @"共享";
                    break;
                case 5:
                    model.func_name = @"删除";
                    break;
                case 6:
                    model.func_name = @"转换";
                    break;
                case 7:
                    model.func_name = @"转移负责人";
                    break;
                case 8:
                    model.func_name = @"打印";
                    break;
                default:
                    break;
            }
            
            if ([model.auth_code isEqualToNumber:@1] || [model.auth_code isEqualToNumber:@2] || [model.auth_code isEqualToNumber:@8]) {
                continue;
            }
            
            [arr addObject:model];
        }
        self.auth = arr.firstObject;
        
        
        BOOL have = NO;
        for (TFCustomAuthModel *model in resp.body) {
            
//            if ([model.data_auth integerValue] == 0) {
//                continue;
//            }
            if ([model.auth_code isEqualToNumber:@1]) {
                have = YES;
                break;
            }
        }
        
        [arr addObjectsFromArray:self.auths];
        
        if (have) {
            TFCustomAuthModel *model = [[TFCustomAuthModel alloc] init];
            model.auth_code = @9;
            model.func_name = @"复制";
            [arr insertObject:model atIndex:0];
        }
        
        self.auths = arr;
        
        [self setupNavi];
    }
    
    if (resp.cmdId == HQCMD_customDelete) {// 删除
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (self.deleteAction) {
            self.deleteAction();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_customModuleChangeList) {
        
        self.changes = resp.body;
        
    }
    
    if (resp.cmdId == HQCMD_customModuleChange) {
        
        [MBProgressHUD showImageSuccess:@"转换成功" toView:self.view];
    }
    
    if (resp.cmdId == HQCMD_highseaTake) {
        
        if (self.deleteAction) {
            self.deleteAction();
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"领取成功" toView:self.view];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_highseaList) {
        
        if (self.seaPoolId) {
            
            NSArray *arr = resp.body;
            
            for (TFHighseaModel *model in arr) {
                
                if ([model.id isEqualToNumber:self.seaPoolId]) {
                    continue;
                }
                
                [self.highseas addObject:model];
            }
        }else{
            [self.highseas addObjectsFromArray:resp.body];
        }
        
        if (self.highseas.count) {
            
            TFCustomAuthModel *model = [[TFCustomAuthModel alloc] init];
            model.auth_code = @10;
            model.func_name = @"退回公海池";
            [self.auths insertObject:model atIndex:self.auths.count];
            
            [self setupNavi];
        }
    }
    
    if (resp.cmdId == HQCMD_customCommentList) {
        
        [self.comments removeAllObjects];
        [self.comments addObjectsFromArray:resp.body];
        
        [self.commentTable refreshCommentTableViewWithDatas:self.comments];
        
    }
    
    if (resp.cmdId == HQCMD_customCommentSave) {// 保存
        
        if (self.commentModel) {
            [self.comments addObject:self.commentModel];
        }
        
        [self.commentTable refreshCommentTableViewWithDatas:self.comments];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.keyboard hideKeyBoard];
        });
    }
    
    if (resp.cmdId == HQCMD_uploadFile || resp.cmdId == HQCMD_ChatFile) {
        
        NSArray *arr = resp.body;
        NSMutableArray *files = [NSMutableArray array];
        for (TFFileModel *ff in arr) {
            
            NSMutableDictionary *dd = [NSMutableDictionary dictionaryWithDictionary:[ff toDictionary]];
            
            if (dd) {
                
                if ([[ff.file_type lowercaseString] isEqualToString:@"mp3"] || [[ff.file_type lowercaseString] isEqualToString:@"amr"]) {
                    
                    CGFloat timeSp = [self.commentModel.voiceTime floatValue]*1000;
                    
                    NSString *str = [NSString stringWithFormat:@"%.0f",timeSp];
                    
                    [dd setObject:@([str integerValue]) forKey:@"voiceTime"];
                }
                
                
                [files addObject:dd];
            }
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.bean forKey:@"bean"];
        [dict setObject:self.dataId forKey:@"relation_id"];
        [dict setObject:files forKey:@"information"];
        [dict setObject:@"" forKey:@"content"];
        
        
        if (arr.count) {
            
            TFFileModel *file = arr[0];
            self.commentModel.fileUrl = file.file_url;
        }
        
        [self.customBL requestCustomModuleCommentWithDict:dict];
    }
    
    if (resp.cmdId == HQCMD_customDynamicList) {
        
        [self.dynamics removeAllObjects];
        [self.dynamics addObjectsFromArray:resp.body];

        [self.dynamicsTable refreshDynamicsTableViewWithDatas:self.dynamics];
    }
    
    if (resp.cmdId == HQCMD_customEmailList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        TFEmailsListModel *model = resp.body;
//        TFPageInfoModel *listModel = model.pageInfo;
//        if ([self.tableView.mj_footer isRefreshing]) {
//            [self.tableView.mj_footer endRefreshing];
//        }else {
//            [self.tableView.mj_header endRefreshing];
//            [self.list removeAllObjects];
//        }
        [self.emailModels removeAllObjects];
        [self.emailModels addObjectsFromArray:model.dataList];
//        if ([listModel.totalRows integerValue] <= self.list.count) {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }else {
//            [self.tableView.mj_footer resetNoMoreData];
//        }
        
        [self.emailTable refreshEmailTableViewWithDatas:self.emailModels];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}



#pragma mark - 初始化tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.customDetailScrollView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-40-BottomM) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view insertSubview:tableView belowSubview:self.customDetailScrollView];
    self.tableView = tableView;
    tableView.tag = 0x234;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = @"ewcfds";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
        return 0.5;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.commentTabBar;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 0x234) {
        [self firstLabelAnimation];
    }
}

- (void)firstLabelAnimation{
    
    CGPoint point = self.tableView.contentOffset;
//    HQLog(@"%@",NSStringFromCGPoint(point));
    
    CGFloat Y = self.customDetailScrollView.top - point.y;
    if (Y <= 0) {
        Y = 0;
        self.navigationItem.title = @"";
    }else if (Y >=40){
        Y = 40;
        self.navigationItem.title = TEXT(self.layout.title);
    }else{
        if (Y < 10) {
            self.navigationItem.title = @"";
        } else{
            self.navigationItem.title = TEXT(self.layout.title);
        }
    }
    self.customDetailScrollView.top = Y;
    self.button.top = Y;
    self.tableView.top = self.customDetailScrollView.bottom;
    self.headerView.titleLabel.bottom = self.customDetailScrollView.top+NaviHeight;
    self.headerView.titleLabel.centerX = SCREEN_WIDTH/2 - Y*(SCREEN_WIDTH/2-self.headerView.titleCenterX)/40.0;
//    self.headerView.titleLabel.width = Y/40.0 *60 + (SCREEN_WIDTH-120);
    
    CGFloat alpha = Y/40.0;
    self.headerView.logo.alpha = alpha;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HexAColor(0xffffff, alpha),NSFontAttributeName:BFONT(20)}];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView.tag == 0x234) {
        [self.keyboard hideKeyBoard];
    }
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
