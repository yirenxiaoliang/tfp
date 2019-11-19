//
//  TFCustomerCommentController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/9.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomerCommentController.h"
#import "HQTFNoContentView.h"
#import "JCHATToolBar.h"
#import "JCHATMoreView.h"
#import "IQKeyboardManager.h"
#import "XHVoiceRecordHUD.h"
#import "XHVoiceRecordHelper.h"
#import "HQTFTaskDynamicCell.h"
#import "HQTFTextImageChangeCell.h"
#import "ZYQAssetPickerController.h"
#import "KSPhotoBrowser.h"
#import "MJRefresh.h"
#import "TFPlayVoiceController.h"
#import "TFCompanyGroupController.h"
#import "TFCRMSearchView.h"
#import "TFCustomerCommentModel.h"
#import "HQEmployModel.h"
#import "TFCustomBL.h"
#import "YYLabel.h"
#import "TFMutilStyleSelectPeopleController.h"

#import "TFFileMenuController.h"
#import "TFFolderListModel.h"

#define MoreViewContainerHeight Long(120)

@interface TFCustomerCommentController ()<UITableViewDelegate,UITableViewDataSource,ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,KSPhotoBrowserDelegate,HQTFTaskDynamicCellDelegate,LiuqsEmotionKeyBoardDelegate,HQBLDelegate,UIScrollViewDelegate,UIDocumentInteractionControllerDelegate>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** 动态数组 */
@property (nonatomic, strong) NSMutableArray *dynamics;

/** 数据 */
@property (nonatomic, strong) TFTaskDynamicModel *dynamic;

/** open */
@property (nonatomic, assign) BOOL open;
/** 正常状态 */
@property (nonatomic, assign) BOOL normal;

/** TFCustomBL */
@property (nonatomic, strong) TFCustomBL *customBL;

/**  */
@property (nonatomic, assign) NSInteger pageNum;
/**  */
@property (nonatomic, assign) NSInteger pageSize;

/** peoples */
@property (nonatomic, strong) NSMutableArray *peoples;

/** searchView */
@property (nonatomic, weak) TFCRMSearchView *searchView;


@property(nonatomic, strong) LiuqsEmoticonKeyBoard *keyboard;

/** jump */
@property (nonatomic, assign) NSInteger jump;

/** model */
@property (nonatomic, strong) TFCustomerCommentModel *commentModel;


@end

@implementation TFCustomerCommentController

-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}


-(NSMutableArray *)dynamics{
    
    if (!_dynamics) {
        _dynamics = [NSMutableArray array];
        
//        for (NSInteger i = 0; i < 4; i ++) {
//
//            TFCustomerCommentModel *model = [[TFCustomerCommentModel alloc] init];
//
//            model.employeeName = @"伊人小亮";
//            model.content = @"我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵";
//            model.type = @(i) ;
//            model.time = @([HQHelper getNowTimeSp]);
//            model.voiceTime = @23;
//            model.fileUrl = @"";
//            model.fileSize = @3378;
//            if (i == 1) {
//                model.fileType = @"mp3";
//            }else if (i == 2){
//                model.fileType = @"jpg";
//            }else if (i == 3){
//                model.fileType = @"doc";
//            }
//            model.fileName = @"我是一个文件.doc";
//            [_dynamics addObject:model];
//        }
        
    }
    return _dynamics;
}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
    }
    return _noContentView;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    IQKeyboardManager *keyBoard = [IQKeyboardManager sharedManager];
    keyBoard.enable = NO;
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    IQKeyboardManager *keyBoard = [IQKeyboardManager sharedManager];
    keyBoard.enable = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageSize = 10;
    self.pageNum = 1;
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    [self.customBL requestCustomModuleCommentListWithBean:self.bean dataId:self.id];
    
    
    [self setupTableView];
    
    [self setupCRMSearchView];
    [self setupNavi];
    
    self.keyboard = [LiuqsEmoticonKeyBoard showKeyBoardInView:self.view type:1];
    self.keyboard.textView.placeholder = @"说点什么吧...";
    HQLog(@"%@ ==== %lf",NSStringFromCGRect(self.keyboard.frame) , screenH);
    HQLog(@"%@ ==== %lf == %f",NSStringFromCGRect(self.keyboard.topBar.frame) , keyBoardH, topBarH);
    
    self.keyboard.delegate = self;
    [self.keyboard hideKeyBoard];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyBoardWillShow:(NSNotification *)noti {
    
    NSDictionary *userInfo = noti.userInfo;
    NSValue *endValue      = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame        = endValue.CGRectValue;
    //处理键盘弹出
    [self.keyboard handleKeyBoardShow:endFrame];
    [self ScrollTableViewToBottom];
}


#pragma mark ==== LiuqsEmotionKeyBoardDelegate ====
-(void)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"@"]) {
        
//        [self didHeartBtn:nil];
        
//        [self.keyboard.textView resignFirstResponder];
    }
}

-(void)recordStarting{
    
    self.enablePanGesture = NO;
}

-(void)cancelStarting{
    
    self.enablePanGesture = YES;
}

#pragma mark - @功能选人
//-(void)didHeartBtn:(UIButton *)button{
//
////    TFCompanyGroupController *depart = [[TFCompanyGroupController alloc] init];
////    depart.type = 2;
////    depart.isSingle = YES;
////    depart.employees = self.peoples;
////    depart.actionParameter = ^(NSArray *peoples){
////
////        //        [self.peoples removeAllObjects];
////        NSString *str = @"";
////        [self.peoples addObjectsFromArray:peoples];
////        for (HQEmployModel *model in self.peoples) {
////            str = [NSString stringWithFormat:@"@%@,",model.employeeName];
////        }
////        str = [str substringToIndex:str.length-1];
////        self.keyboard.textView.text = [NSString stringWithFormat:@"%@%@ ",self.keyboard.textView.text,str];
////
////        for (HQEmployModel *model in self.peoples) {
////
////            NSString *str1 = [NSString stringWithFormat:@"@%@",model.employeeName];
////
////            NSRange range = [self.keyboard.textView.text rangeOfString:str1];
////            model.location = @(range.location);
////            model.length = @(range.length);
////
////        }
////
////        [self.keyboard.textView becomeFirstResponder];
////    };
////    [self.navigationController pushViewController:depart animated:YES];
//
//
//    TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
//    scheduleVC.selectType = 1;
//    scheduleVC.isSingleSelect = YES;
//    scheduleVC.actionParameter = ^(NSArray *peoples) {
//
//        NSString *str = @"";
//        [self.peoples addObjectsFromArray:peoples];
//        for (HQEmployModel *model in self.peoples) {
//            str = [NSString stringWithFormat:@"%@,",model.employeeName?:model.employee_name];
//        }
//        str = [str substringToIndex:str.length-1];
//        self.keyboard.textView.text = [NSString stringWithFormat:@"%@%@ ",self.keyboard.textView.text,str];
//
//        for (HQEmployModel *model in self.peoples) {
//
//            NSString *str1 = [NSString stringWithFormat:@"%@",model.employeeName?:model.employee_name];
//
//            NSRange range = [self.keyboard.textView.text rangeOfString:str1];
//            model.location = @(range.location);
//            model.length = @(range.length);
//
//        }
//        self.jump = 0;
//        [self.keyboard.textView becomeFirstResponder];
//
//    };
//    self.jump = 1;
//    [self.navigationController pushViewController:scheduleVC animated:YES];
//}

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
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self ScrollTableViewToBottom];
    }];
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
        [dict setObject:self.id forKey:@"relation_id"];
        [dict setObject:files forKey:@"information"];
        [dict setObject:@"" forKey:@"content"];
        
        
        [self.customBL requestCustomModuleCommentWithDict:dict];
    

        
    };
    
    [self.navigationController pushViewController:fileVC animated:YES];
}

- (void)keyBoardChanged {
    
    [UIView animateWithDuration:keyBoardTipTime animations:^{
        
        [self updateChatList];
    }];
}


//重设tabbleview的frame并根据是否在底部来执行滚动到底部的动画（不在底部就不执行，在底部才执行）
- (void)updateChatList {
    
    CGFloat offSetY = self.tableView.contentSize.height - self.tableView.Ex_height;
    //判断是否需要滚动到底部，给一个误差值
    if (self.tableView.contentOffset.y > offSetY - 5 || self.tableView.contentOffset.y > offSetY + 5) {
        
        self.tableView.Ex_height = self.keyboard.topBar.Ex_y - 44;
        [self ScrollTableViewToBottom];
    }else {
        
        self.tableView.Ex_height = self.keyboard.topBar.Ex_y - 44;
    }
}
//滚动到底部
- (void)ScrollTableViewToBottom {
    
    if (!self.dynamics.count) {return;}
    if (self.dynamics.count - 1 >= 1) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dynamics.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
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
        [dict setObject:self.id forKey:@"relation_id"];
        [dict setObject:text forKey:@"content"];
        [dict setObject:str forKey:@"at_employee"];
        [dict setObject:@[] forKey:@"information"];
        [dict setObject:@0 forKey:@"type"];
        if (self.style) {
            
            [dict setObject:self.style forKey:@"style"];
        }
        
        if (self.approvalItem.process_definition_id) {
            [dict setObject:self.approvalItem.process_definition_id forKey:@"processInstanceId"];
        }
//        if (self.approvalItem.fromType) {
            [dict setObject:@4 forKey:@"fromType"];
//        }
        if (self.approvalItem.module_bean) {
            [dict setObject:self.approvalItem.module_bean forKey:@"moduleBean"];
        }
        if (self.approvalItem.approval_data_id) {
            [dict setObject:self.approvalItem.approval_data_id forKey:@"dataId"];
        }
        
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



#pragma mark - navigation
- (void)setupNavi{
    
    self.navigationItem.title = @"评论";
}

#pragma mark - 初始化筛选View
- (void)setupCRMSearchView{
    TFCRMSearchView *view = [TFCRMSearchView CRMSearchView];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    [self.view addSubview:view];
    view.filterBtn.hidden = YES;
    view.arrowImage.hidden = YES;
    [view refreshSearchViewWithTitle:[NSString stringWithFormat:@"全部%@",@"评论"] number:0];
    self.searchView = view;
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
    picker.modalPresentationStyle = UIModalPresentationFullScreen;

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
        picker.modalPresentationStyle = UIModalPresentationFullScreen;

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

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-46.5-44) style:UITableViewStylePlain];
    
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.backgroundView = [UIView new];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewClicked:)];
    [tableView.backgroundView addGestureRecognizer:tap];
}

- (void)tableViewClicked:(UITapGestureRecognizer *)tap{
    
    [self.keyboard hideKeyBoard];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    [self.keyboard hideKeyBoard];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.dynamics.count == 0) {
        tableView.backgroundView = self.noContentView;
        self.noContentView.centerY = (self.tableView.height-Long(180))/2;
    }else{
        [self.noContentView removeFromSuperview];
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dynamics.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HQTFTaskDynamicCell *cell = [HQTFTaskDynamicCell taskDynamicCellWithTableView:tableView];
    cell.delegate = self;
    [cell refreshCommentCellWithCustomModel:self.dynamics[indexPath.row]];
   
    if (self.dynamics.count == indexPath.row + 1) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    [self.view endEditing:YES];
    [self.keyboard hideKeyBoard];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [HQTFTaskDynamicCell refreshCommentCellHeightWithCustomModel:self.dynamics[indexPath.row]];
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


#pragma mark -
-(void)taskDynamicCell:(HQTFTaskDynamicCell *)taskDynamicCell didClickVoice:(TFFileModel *)model{
    
    [self.view endEditing:YES];
    [self.keyboard hideKeyBoard];
    
    TFPlayVoiceController *play = [[TFPlayVoiceController alloc] init];
    play.file = model;
    [self.navigationController pushViewController:play animated:YES];
    
}


-(void)taskDynamicCell:(HQTFTaskDynamicCell *)taskDynamicCell didClickImage:(UIImageView *)imageView{
    
    [self.view endEditing:YES];
    [self.keyboard hideKeyBoard];
    
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

-(void)taskDynamicCell:(HQTFTaskDynamicCell *)taskDynamicCell didClickFile:(TFFileModel *)model{
    
    [self.view endEditing:YES];
    [self.keyboard hideKeyBoard];
    
    if ([[model.file_type lowercaseString] isEqualToString:@"jpg"] || [[model.file_type lowercaseString] isEqualToString:@"png"] || [[model.file_type lowercaseString] isEqualToString:@"gif"] || [[model.file_type lowercaseString] isEqualToString:@"jpeg"]) {// 查看图片
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.center = self.view.center;
        
        [self taskDynamicCell:nil didClickImage:view];
        
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


- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customCommentList) {
        
        //        TFTaskDynamicListModel *listModel = resp.body;
        //        [self.dynamics removeAllObjects];
        //        [self.dynamics addObjectsFromArray:listModel.list];
        //        [self.tableView reloadData];
        
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.dynamics removeAllObjects];
        }
        
        [self.dynamics addObjectsFromArray:resp.body];
        
//        if (listModel.totalRows == self.dynamics.count) {
//            
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            
//            self.tableView.mj_footer = nil;
//            
//            if (self.dynamics.count < 10) {
//                self.tableView.tableFooterView = [UIView new];
//            }else{
//                self.tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];;
//            }
//            
//        }else {
//            
//            [self.tableView.mj_footer resetNoMoreData];
//        }
        
        if (self.dynamics.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.searchView refreshSearchViewWithTitle:@"全部评论" number:self.dynamics.count];
        
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_customCommentSave) {// 保存
        
        if (self.commentModel) {
            [self.dynamics addObject:self.commentModel];
        }
        
        if (self.dynamics.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.searchView refreshSearchViewWithTitle:@"全部评论" number:self.dynamics.count];
        [self.tableView reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (self.refreshAction) { //
            
            self.refreshAction(@(self.dynamics.count));
        }
        
        [self ScrollTableViewToBottom];
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
        [dict setObject:self.id forKey:@"relation_id"];
        [dict setObject:files forKey:@"information"];
        [dict setObject:@"" forKey:@"content"];
        
        
        if (arr.count) {
            
            TFFileModel *file = arr[0];
            self.commentModel.fileUrl = file.file_url;
        }
        
        [self.customBL requestCustomModuleCommentWithDict:dict];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    //    [self.tableView.mj_footer endRefreshing];
    //    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
