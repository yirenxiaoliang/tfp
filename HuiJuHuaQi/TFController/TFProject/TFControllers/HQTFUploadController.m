//
//  HQTFUploadController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/30.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFUploadController.h"
#import "HQTFTwoLineCell.h"
#import "HQTFUploadFileView.h"
#import "MWPhotoBrowser.h"
#import "ZYQAssetPickerController.h"
#import "JCHATToolBar.h"
#import "XHVoiceRecordHUD.h"
#import "XHVoiceRecordHelper.h"
#import "AlertView.h"
#import "TFFileModel.h"
#import "HQTFProjectFileController.h"
#import "NewFileFolderViewController.h"
#import "TFUploadFileBL.h"
#import "TFScheduleBL.h"
#import "FLLibarayViewController.h"
#import "TFProjectBL.h"

@interface HQTFUploadController ()<UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate, MWPhotoBrowserDelegate , UIImagePickerControllerDelegate ,SendMessageDelegate,HQTFTwoLineCellDelegate,HQBLDelegate>

/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** 文件数组 */
@property (nonatomic, strong) NSMutableArray *files;

/** 输入框 */
@property (strong, nonatomic) JCHATToolBarContainer *recoder;
/** 录音 */
@property(nonatomic, strong, readwrite) XHVoiceRecordHUD *voiceRecordHUD;
/**
 *  管理录音工具对象
 */
@property(nonatomic, strong) XHVoiceRecordHelper *voiceRecordHelper;

/** images */
@property (nonatomic, strong) NSMutableArray *images;
/** selectIndex */
@property (nonatomic, assign) NSInteger selectIndex;

/** uploadModel */
@property (nonatomic, assign) UploadModel uploadModel;

/** type */
@property (nonatomic, assign) UploadFileType type;
/** projectId */
@property (nonatomic, strong) NSNumber *projectId;
/** taskId */
@property (nonatomic, strong) NSNumber *taskId;

@property (nonatomic, strong) TFUploadFileBL *uploadFileBL;

@property (nonatomic, strong) TFScheduleBL *scheduleBL;

@property (nonatomic, strong) TFProjectBL *projectBL;

@end

@implementation HQTFUploadController


-(NSMutableArray *)files{
    
    if (!_files) {
        _files = [NSMutableArray array];
    }
    return _files;
}
-(NSMutableArray *)images{
    
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"关闭" highlightImage:@"关闭"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)sure{
    
//    if (self.actionParameter) {
//        self.actionParameter(self.files);
//    }
    
    if (!self.files.count) {
        [MBProgressHUD showError:@"请选择要上传的文件" toView:KeyWindow];
        return;
    }
    if (self.files.count > 5) {
        
        [MBProgressHUD showError:@"附件最多可以添加5个" toView:KeyWindow];
        return;
    }
    NSMutableArray *images = [NSMutableArray array];
    NSMutableArray *vioces = [NSMutableArray array];
    
    NSNumber *voiceTime;
    for (TFFileModel *model in self.files) {
        
        if ([model.fileType isEqualToString:@"jpg"] && model.image) {// 未上传的Image
            [images addObject:model.image];
        }
        if ([model.fileType isEqualToString:@"mp3"] && model.voicePath && model.voicePath.length > 0) {

            voiceTime = model.voiceDuration;
            [vioces addObject:model.voicePath];
        }
        
    }
    
    if (images.count || vioces.count) {
        
        [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
        if (self.uploadModel == UploadModelProject) {
            [self.uploadFileBL requsetUploadProjectTaskFileWithImages:images withVioces:vioces projectId:self.projectId taskId:self.taskId];
        }
        else if (self.uploadModel == UploadModelFileLibray) { //文件库
        
            [self.uploadFileBL requsetUploadLibrayFileWithImages:images withVioces:vioces withModule:self.uploadModel withDiskId:self.diskId withVoice:voiceTime];
        }
        else if (self.uploadModel == UploadModelSchedule) {
        
            self.scheduleBL = [TFScheduleBL build];
            self.scheduleBL.delegate = self;
            [self.scheduleBL requestUploadScheduleDetailFilesData:images param:self.scheduleDetailId];
        }
        else{
            
            [self.uploadFileBL requsetUploadProjectTaskFileWithImages:images withVioces:vioces withModule:self.uploadModel];
        }
    }
    else{
        
        NSMutableArray *files = [NSMutableArray array];
        for (TFFileModel *model in self.files) {
            
            if (model.fileUrl && ![model.fileUrl isEqualToString:@""]) {
                
                [files addObject:model];
            }
        }
        
        if (self.actionParameter) {
            self.actionParameter(files);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    
}
-(instancetype)initWithFiles:(NSArray<TFFileModel> *)files withUploadModel:(UploadModel)uploadModel withType:(UploadFileType)type projectId:(NSNumber *)projectId taskId:(NSNumber *)taskId{
    
    if (self = [super init]) {
        
        [self.files addObjectsFromArray:files];
        self.uploadModel = uploadModel;
        self.type = type;
        self.projectId = projectId;
        self.taskId = taskId;
    }
    return self;
}

-(instancetype)initWithFiles:(NSArray<TFFileModel> *)files withUploadModel:(UploadModel)uploadModel withType:(UploadFileType)type{
    
    if (self = [super init]) {
        
        self.uploadModel = uploadModel;
        [self.files addObjectsFromArray:files];
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.enablePanGesture = NO;
    [self setupTableView];
    [self setupNavigation];
    [self setupToolBar];
    [self showFileType:self.type];
    
    self.uploadFileBL = [TFUploadFileBL build];
    self.uploadFileBL.delegate = self;
    
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
}

- (void)setupToolBar{
    
    self.recoder = [[JCHATToolBarContainer alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT- TabBarHeight, SCREEN_WIDTH, TabBarHeight)];
    self.recoder.toolbar.frame = self.recoder.bounds;
    self.recoder.toolbar.delegate = self;
    [self.recoder.toolbar setUserInteractionEnabled:YES];
    self.recoder.toolbar.voiceButton.hidden = YES;
    self.recoder.toolbar.addButton.hidden = YES;
    self.recoder.toolbar.recorderType = YES;
    [self.recoder.toolbar drawRect:self.recoder.toolbar.frame];
    [self.recoder.toolbar switchToVoiceInputMode];
    self.recoder.backgroundColor = HexColor(0xf2f2f2, 1);
}

- (void)showRecord{
    
    // 当前窗体
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [[window viewWithTag:0x1234554321] removeFromSuperview];
    
    // 背景mask窗体
    UIButton *bgView = [[UIButton alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    bgView.tag = 0x1234554321;
    [bgView addTarget:self action:@selector(tapBgView:) forControlEvents:UIControlEventTouchDown];
    bgView.alpha = 0;
    
    [bgView addSubview:self.recoder];
    
    [UIView animateWithDuration:0.25 animations:^{
        bgView.alpha = 1;
    }];
  
    [window addSubview:bgView];
    
    // 显示窗体
    [window makeKeyAndVisible];
}

- (void)tapBgView:(UIButton *)tap{
    
    if (self.voiceRecordHelper.recorder.isRecording) {
        return;
    }
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    [UIView animateWithDuration:0.25 animations:^{
        [window viewWithTag:0x1234554321].alpha = 0;
    } completion:^(BOOL finished) {
        
        [self.recoder removeFromSuperview];
        [[window viewWithTag:0x1234554321] removeFromSuperview];
    }];
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
    [self.voiceRecordHUD startRecordingHUDAtView:KeyWindow];
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
    
    // 此处发送语音
    TFFileModel *model = [[TFFileModel alloc] init];
    model.fileName = @"这是一段语音";
    model.fileType = @"mp3";
    model.voicePath = voicePath;
    model.voiceDuration = @([voiceDuration integerValue]);
    [self.files addObject:model];
    
    [self tapBgView:nil];
    
    [self.tableView reloadData];
}



#pragma mark - navi
- (void)setupNavigation{
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"上传" textColor:GreenColor];
    self.navigationItem.title = @"选择附件";
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else{
        return self.files.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    
    if (indexPath.section == 0) {
        
        [cell.titleImage setImage:[UIImage imageNamed:@"添加协作"] forState:UIControlStateNormal];
        [cell.titleImage setImage:[UIImage imageNamed:@"添加协作"] forState:UIControlStateHighlighted];
        cell.topLabel.text = @"添加上传内容";
        cell.topLabel.textColor = GreenColor;
        cell.type = TwoLineCellTypeOne;
        cell.enterImage.hidden = YES;
        cell.bottomLine.hidden = NO;
        cell.headMargin = 0;
        return cell;
        
    }else{
        
        
        TFFileModel *model = self.files[indexPath.row];
        
        if ([[model.fileType lowercaseString] isEqualToString:@"jpg"] || [[model.fileType lowercaseString] isEqualToString:@"png"] || [[model.fileType lowercaseString] isEqualToString:@"gif"]) {// 图片
            
            
            if (model.image) {
                [cell.titleImage setImage:model.image forState:UIControlStateNormal];
                [cell.titleImage setImage:model.image forState:UIControlStateHighlighted];
                
            }else{
                [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.fileUrl] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
                [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.fileUrl] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
            }
            
            cell.topLabel.text = model.fileName;
            cell.titleDescImg.hidden = YES;
            
        }else if ([[model.fileType lowercaseString] isEqualToString:@"mp3"]){// 语音
            [cell.titleImage setImage:[UIImage imageNamed:@"mp3"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"mp3"] forState:UIControlStateHighlighted];
            cell.topLabel.text = model.fileName;
            [cell.titleDescImg setImage:[UIImage imageNamed:@"语音-2"] forState:UIControlStateNormal];
            
            if (model.voiceDuration) {
                
                [cell.titleDescImg setTitle:[NSString stringWithFormat:@" %ld\"",[model.voiceDuration integerValue]] forState:UIControlStateNormal];
            }else{
                
                [cell.titleDescImg setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
            }
            
            
            [cell.titleDescImg setTitleColor:HexColor(0xc2c2c2, 1) forState:UIControlStateNormal];
            cell.titleDescImg.hidden = NO;
        }else if ([[model.fileType lowercaseString] isEqualToString:@"doc"] || [[model.fileType lowercaseString] isEqualToString:@"docx"]){// doc
            [cell.titleImage setImage:[UIImage imageNamed:@"doc"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"doc"] forState:UIControlStateHighlighted];
            cell.topLabel.text = model.fileName;
            cell.titleDescImg.hidden = YES;
        }else if ([[model.fileType lowercaseString] isEqualToString:@"xls"] || [[model.fileType lowercaseString] isEqualToString:@"xlsx"]){// xls
            [cell.titleImage setImage:[UIImage imageNamed:@"xls"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"xls"] forState:UIControlStateHighlighted];
            cell.topLabel.text = model.fileName;
            cell.titleDescImg.hidden = YES;
        }else if ([[model.fileType lowercaseString] isEqualToString:@"ppt"] || [[model.fileType lowercaseString] isEqualToString:@"ppts"]){// ppt
            [cell.titleImage setImage:[UIImage imageNamed:@"ppt"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"ppt"] forState:UIControlStateHighlighted];
            cell.topLabel.text = model.fileName;
            cell.titleDescImg.hidden = YES;
        }else if ([[model.fileType lowercaseString] isEqualToString:@"ai"]){// ai
            [cell.titleImage setImage:[UIImage imageNamed:@"ai"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"ai"] forState:UIControlStateHighlighted];
            cell.topLabel.text = model.fileName;
            cell.titleDescImg.hidden = YES;
        }else if ([[model.fileType lowercaseString] isEqualToString:@"cdr"]){// cdr
            [cell.titleImage setImage:[UIImage imageNamed:@"cdr"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"cdr"] forState:UIControlStateHighlighted];
            cell.topLabel.text = model.fileName;
            cell.titleDescImg.hidden = YES;
        }else if ([[model.fileType lowercaseString] isEqualToString:@"dwg"]){// dwg
            [cell.titleImage setImage:[UIImage imageNamed:@"dwg"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"dwg"] forState:UIControlStateHighlighted];
            cell.topLabel.text = model.fileName;
            cell.titleDescImg.hidden = YES;
        }else if ([[model.fileType lowercaseString] isEqualToString:@"ps"]){// ps
            [cell.titleImage setImage:[UIImage imageNamed:@"ps"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"ps"] forState:UIControlStateHighlighted];
            cell.topLabel.text = model.fileName;
            cell.titleDescImg.hidden = YES;
        }else if ([[model.fileType lowercaseString] isEqualToString:@"pdf"]){// pdf
            [cell.titleImage setImage:[UIImage imageNamed:@"pdf"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"pdf"] forState:UIControlStateHighlighted];
            cell.topLabel.text = model.fileName;
            cell.titleDescImg.hidden = YES;
        }else if ([[model.fileType lowercaseString] isEqualToString:@"txt"]){// txt
            [cell.titleImage setImage:[UIImage imageNamed:@"txt"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"txt"] forState:UIControlStateHighlighted];
            cell.topLabel.text = model.fileName;
            cell.titleDescImg.hidden = YES;
        }else if ([[model.fileType lowercaseString] isEqualToString:@"zip"]){// zip
            [cell.titleImage setImage:[UIImage imageNamed:@"zip"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"zip"] forState:UIControlStateHighlighted];
            cell.topLabel.text = model.fileName;
            cell.titleDescImg.hidden = YES;
        }else{
            
            [cell.titleImage setImage:[UIImage imageNamed:@"未知文件"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"未知文件"] forState:UIControlStateHighlighted];
            cell.topLabel.text = model.fileName;
            cell.titleDescImg.hidden = YES;
        }
    
    
        
        cell.topLabel.textColor = BlackTextColor;
        cell.enterImage.hidden = NO;
        cell.bottomLine.hidden = NO;
        cell.headMargin = 15;
        cell.type = TwoLineCellTypeOne;
        cell.delegate = self;
        cell.enterImage.tag = 0x123 + indexPath.row;
        [cell.enterImage setImage:[UIImage imageNamed:@"关闭30"] forState:UIControlStateNormal];
        [cell.enterImage setBackgroundImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){44,44}] forState:UIControlStateNormal];
        
        if (indexPath.row == self.files.count-1) {

            cell.bottomLine.hidden = YES;
        }
        
        return cell;
        

    }
}

-(void)twoLineCell:(HQTFTwoLineCell *)cell didEnterImage:(UIButton *)enterBtn{
    
    NSInteger index = enterBtn.tag - 0x123;
    
    TFFileModel *model = self.files[index];
    [self.files removeObjectAtIndex:index];
    
    if (self.uploadModel == UploadModelProject) {
        
        if (model.id) {
            [self.uploadFileBL requsetDelProjectFileWithFileId:model.id];
            
        }else{
            [self.tableView reloadData];
        }
    }else{
        
        [self.tableView reloadData];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    if (indexPath.section == 0) {
        
        [HQTFUploadFileView showAlertView:@"上传文件" withType:2 parameterAction:^(NSNumber *parameter) {
            
            [self showFileType:(UploadFileType)[parameter integerValue]];
            
        }];
    }else{
        
        TFFileModel *model = self.files[indexPath.row];
        
        if ([model.fileType isEqualToString:@"jpg"]) {
            
            
            [self.images removeAllObjects];
            
            for (TFFileModel *model in self.files) {
                
                if ([model.fileType integerValue] == 0) {
                    
                    [self.images addObject:model];
                }
            }
            
            [self didLookAtPhotoActionWithIndex:indexPath.row];
            
        }

    }
}


- (void)showFileType:(UploadFileType)type{
    
    
    switch (type) {
        case UploadFileTypeVoice:// 语音
        {
            [self showRecord];
        }
            break;
        case UploadFileTypeCamara:// 拍照
        {
            [self openCamera];
        }
            break;
        case UploadFileTypeAblum:// 相册
        {
            [self openAlbum];
        }
            break;
        case 3:// 文件库
        {
//            FLLibarayViewController *file = [[FLLibarayViewController alloc] init];
//            file.isFromOutside = YES;
//            file.fileArrBlock = ^(NSArray *array) {
//              
//                [self.files addObjectsFromArray:array];
//                [self.tableView reloadData];
//                
//                if (self.uploadModel == UploadModelProject) {
//                    
//                    [self.projectBL requestFileUploadWithFiles:array];
//                    
//                }
//                
//            };
//            [self.navigationController pushViewController:file animated:YES];
        }
            break;
            
        default:
            break;
    }

    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 8;
    }
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


#pragma mark - 打开相册
- (void)openAlbum{
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    
    //图片数量
    NSInteger imgNums;
    
    if (self.isLimit) {
        
        imgNums = 5-self.files.count;
    }
    else {
    
        imgNums = 6;
    }
    picker.maximumNumberOfSelection = imgNums; // 选择图片最大数量
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
        
        
        TFFileModel *model = [[TFFileModel alloc] init];
        model.fileName = fileName;
        model.fileType = @"jpg";
        model.image = tempImg;
        [self.files addObject:model];
    }
    
    [self.tableView reloadData];
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
    
    TFFileModel *model = [[TFFileModel alloc] init];
    model.fileName = @"这是一张自拍图";
    model.fileType = @"jpg";
    model.image = image;
    [self.files addObject:model];
    
    [self.tableView reloadData];
    //获取图片的名字信息
//    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
//    {
//        ALAssetRepresentation *representation = [myasset defaultRepresentation];
//        
//        NSString *fileName = [representation filename];
//        NSLog(@"fileName : %@",fileName);
//    };
//    
//    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
//    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
//    [assetslibrary assetForURL:imageURL
//                   resultBlock:resultblock
//                  failureBlock:nil];
//    
//    
//    PHAssetImageProgressHandler progressHandler = ^(double progress, NSError *__nullable error, BOOL *stop, NSDictionary *__nullable info){
//        
//        
//        NSLog(@"info : %@",info);
//        
//    };
//    PHImageManager *manager  = [PHImageManager defaultManager];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
    [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
    if (resp.cmdId == HQCMD_uploadFile || resp.cmdId == HQCMD_projectTaskFileUpload||resp.cmdId == HQCMD_LibrayUploadFile) {
        
        NSMutableArray *files = [NSMutableArray array];
        for (TFFileModel *model in self.files) {
            
            if (model.fileUrl && ![model.fileUrl isEqualToString:@""]) {
                
                [files addObject:model];
            }
        }
        
        NSArray *newFiles = resp.body;
        
        [files addObjectsFromArray:newFiles];
        
        if (self.actionParameter) {
            self.actionParameter(files);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (resp.cmdId == HQCMD_uploadScheduleFiles) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (resp.cmdId == HQCMD_projectTaskFileDelete) {
        [self.tableView reloadData];
        
        NSMutableArray *files = [NSMutableArray array];
        for (TFFileModel *model in self.files) {
            
            if (model.fileUrl && ![model.fileUrl isEqualToString:@""]) {
                
                [files addObject:model];
            }
        }
        
        if (self.actionParameter) {
            self.actionParameter(files);
        }
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
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
