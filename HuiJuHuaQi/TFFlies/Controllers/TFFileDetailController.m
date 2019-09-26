//
//  TFFileDetailController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFileDetailController.h"
#import "TFDownloadRecordController.h"
#import "TFHistoryVersionController.h"
#import "TFMoveFileController.h"
#import "TFSelectChatPersonController.h"
#import "TFCustomerCommentController.h"
#import "HQTFProjectDescController.h"
#import "PreviewControllerToolbar.h"
#import "PreviewNavigationController.h"

#import "FDActionSheet.h"
#import "AlertView.h"
#import "ZYQAssetPickerController.h"
#import "TFDownloadingView.h"
#import "FileManager.h"
#import "HSDownloadManager.h"
#import "KSPhotoBrowser.h"

#import "TFEmailsBottomView.h"

#import "HQEmployModel.h"
#import "TFChatInfoListModel.h"

#import "TFSocketManager.h"
#import "TFFileBL.h"
#import "TFPlayVoiceController.h"
#import <QuickLook/QuickLook.h>

#import "TFAudioFileCell.h"
#import "HQAudioModel.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "TFMutilStyleSelectPeopleController.h"
#import "TFProjectTaskBL.h"
@interface TFFileDetailController ()<UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate,HQBLDelegate,UIDocumentInteractionControllerDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,TFEmailsBottomViewDelegate,UITableViewDelegate,UITableViewDataSource,TFAudioFileCellDelegate>

@property (nonatomic, strong) UIButton *otherOpenBtn;

@property (nonatomic, strong) UILabel *tipLab;

@property (nonatomic, strong) TFDownloadingView *downloadingView;

@property (nonatomic, strong) UIButton *oprationBtn;

@property (nonatomic, strong) TFFileBL *fileBL;

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) TFSocketManager *socket;

@property (nonatomic, strong) HSDownloadManager *downloadManager;

/** 是否下载完成 */
@property (nonatomic, assign) BOOL isDownloaded;

//@property (strong, nonatomic) QLPreviewController *qlpreView;

@property (nonatomic, assign) NSInteger BtnIndex;

@property (nonatomic, strong) UIImageView *bigView;

//
@property (nonatomic, strong) NSArray *labs;

@property (nonatomic, strong) NSArray *imgs;

@property (nonatomic, strong) TFEmailsBottomView *emailsBottomView;

@property (nonatomic, strong) UIView *mainView;


@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

@end

@implementation TFFileDetailController
- (TFFileDetailModel *)detailModel {
    
    if (!_detailModel) {
        _detailModel = [[TFFileDetailModel alloc] init];
    }
    return _detailModel;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.enablePanGesture = YES;
    self.socket = [TFSocketManager sharedInstance];
    
    self.downloadManager = [HSDownloadManager sharedInstance];
    
    [self setNavi];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    if (self.whereFrom == 0) {
        
        [self requestData];
    }
    else {
        
        self.detailModel.basics = self.basics;
        
        //从聊天进来
        if (self.whereFrom == 1 || self.whereFrom == 2) {
            //本地是否存在该文件
            _isDownloaded = [self.downloadManager isCompletion:self.fileUrl];
            
        }
        else if (self.whereFrom == 3) {
            self.projectTaskBL = [TFProjectTaskBL build];
            self.projectTaskBL.delegate = self;
            
//            _isDownloaded = [self.downloadManager isCompletion:[NSString stringWithFormat:@"%@%@%@?id=%@&project_id=%@",kServerAddress,ServerAdress,@"/common/file/projectDownload",self.detailModel.basics.id,self.projectId]];
            _isDownloaded = [self.downloadManager isCompletion:[NSString stringWithFormat:@"%@%@?id=%@&project_id=%@",kServerAddress,@"/common/file/projectDownload",self.detailModel.basics.id,self.projectId]];
        }else {
//            _isDownloaded = [self.downloadManager isCompletion:[NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/download",self.detailModel.basics.id]];
            _isDownloaded = [self.downloadManager isCompletion:[NSString stringWithFormat:@"%@%@?id=%@",kServerAddress,@"/library/file/download",self.detailModel.basics.id]];
            
        }
        
        if (self.isImg == 1) { //图片
            [self createBigImageView];
        }
        else {
            [self createMainView];
        }
    }
    
    if (self.projectId) {
        [self createBottomView];
    }
}

- (void)requestData {

    self.fileBL = [TFFileBL build];
    self.fileBL.delegate = self;
    
    [self.fileBL requestQueryFileLibarayDetailWithData:self.fileId];
}

- (void)setNavi {
    
    self.navigationItem.title = self.naviTitle;

    if (self.whereFrom == 0) {
        
        if (self.style == 2) { //应用文件没有历史版本
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(downloadRecord) image:@"下载记录" highlightImage:@"下载记录"];
        }
        else {
        
            UIBarButtonItem *add = [self itemWithTarget:self action:@selector(historyVersion) image:@"历史版本" highlightImage:@"历史版本"];
            UIBarButtonItem *person = [self itemWithTarget:self action:@selector(downloadRecord) image:@"下载记录" highlightImage:@"下载记录"];
            
            NSArray *rightBtns = [NSArray arrayWithObjects:add,person, nil];
            
            self.navigationItem.rightBarButtonItems = rightBtns;
        }
        
    }else if (self.whereFrom == 3){
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(downloadRecord) image:@"下载记录" highlightImage:@"下载记录"];
        
    }else if (self.whereFrom == 1){// 聊天进入
        
        if (self.isImg == 1) {
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(imageSave) image:@"菜单" highlightImage:@"菜单"];
        }
        
    }
    
}

-(void)imageSave{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self loadImageFinished:self.bigView.image];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)createBigImageView {

    
    _bigView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-55-BottomM)];
    _bigView.userInteractionEnabled = YES;

    NSURL *url;
    if (self.whereFrom == 1 || self.whereFrom == 2) {
        
        url = [HQHelper URLWithString:[NSString stringWithFormat:@"%@",self.fileUrl]];
    }
    else if (self.whereFrom == 3) {
        
//        url = [HQHelper URLWithString:[NSString stringWithFormat:@"%@%@%@?id=%@&project_id=%@&width=480",kServerAddress,ServerAdress,@"/common/file/projectDownload",self.detailModel.basics.id,self.projectId]];
        url = [HQHelper URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&project_id=%@&width=480",kServerAddress,@"/common/file/projectDownload",self.detailModel.basics.id,self.projectId]];
    }
    else {
    
//        url = [HQHelper URLWithString:[NSString stringWithFormat:@"%@%@%@?id=%@&url=%@&width=480&type=1",kServerAddress,ServerAdress,@"/library/file/downloadCompressedPicture",self.detailModel.basics.id,self.detailModel.basics.url]];
        url = [HQHelper URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&url=%@&width=480&type=1",kServerAddress,@"/library/file/downloadCompressedPicture",self.detailModel.basics.id,self.detailModel.basics.url]];
    }
    
    
    [_bigView sd_setImageWithURL:url];
    _bigView.contentMode = UIViewContentModeScaleAspectFit;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self.view addSubview:_bigView];
    
    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    
    [_bigView addGestureRecognizer:imgTap];
}

#pragma mark - 初始化tableView
- (void)createPlayAudioView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-55-8) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.scrollEnabled = NO;
    
    [self.view addSubview:tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFAudioFileCell *cell = [TFAudioFileCell audioFileCellWithTableView:tableView];
    HQAudioModel *model = [[HQAudioModel alloc] init];
    
    if (self.whereFrom == 1 || self.whereFrom == 2) {
        
        model.voiceUrl = self.fileUrl;
    }
    else if (self.whereFrom == 3) {
        
//        model.voiceUrl = [NSString stringWithFormat:@"%@%@%@?id=%@&project_id=%@",kServerAddress,ServerAdress,@"/common/file/projectDownload",self.detailModel.basics.id,self.projectId];
        model.voiceUrl = [NSString stringWithFormat:@"%@%@?id=%@&project_id=%@",kServerAddress,@"/common/file/projectDownload",self.detailModel.basics.id,self.projectId];
    }
    else {
        
//        model.voiceUrl = [NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/downloadWithoutRecord",self.fileId];
        model.voiceUrl = [NSString stringWithFormat:@"%@%@?id=%@",kServerAddress,@"/library/file/downloadWithoutRecord",self.fileId];
    }
    
//    model.voiceUrl = @"http://192.168.1.183:8081/custom-gateway/common/file/download4Show?bean=chat111&fileName=201806291616120.mp4&contentType=video/mp4&fileSize=17924152";
    //        model.voiceDuration = self.file.voiceDuration;
    cell.bottomLine.hidden = YES;
    [cell refreshAudioFileCellWithAudioModel:model withType:1];
    cell.delegate =self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_HEIGHT-NaviHeight-55-8;
}


- (void)createMainView {
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-64)];
    self.mainView.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    
    [self.view addSubview:self.mainView];

    //文件格式图片
    UIImageView *fileImg = [[UIImageView alloc] init];
    
    self.detailModel.basics.siffix = [self.detailModel.basics.siffix stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if ([[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"mp3"]){// 语音

        fileImg.image = IMG(@"mp3");

    }else if ([[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"mp4"] ||
              [[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"mov"]){// 视频
        
        fileImg.image = IMG(@"mp4");
        
    }else if ([[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"doc"] || [[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"docx"]){// doc
        
        fileImg.image = IMG(@"doc");
        
    }else if ([[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"xls"] || [[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"xlsx"]){// xls
        
        fileImg.image = IMG(@"xls");
        
    }else if ([[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"ppt"] || [[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"pptx"]){// ppt
        
        fileImg.image = IMG(@"ppt");
        
    }else if ([[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"ai"]){// ai
        
        fileImg.image = IMG(@"ai");
        
    }else if ([[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"cdr"]){// cdr
        
        fileImg.image = IMG(@"cdr");
        
    }else if ([[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"dwg"]){// dwg
        
        fileImg.image = IMG(@"dwg");
        
    }else if ([[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"ps"]){// ps
        
        fileImg.image = IMG(@"ps");
        
    }else if ([[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"pdf"]){// pdf
        
        fileImg.image = IMG(@"pdf");
        
    }else if ([[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"txt"]){// txt
        
        fileImg.image = IMG(@"txt");
        
    }else if ([[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"zip"] ||
              [[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"rar"]){// zip
        
        fileImg.image = IMG(@"zip");
        
    }else{
        
        fileImg.image = IMG(@"未知文件");
        
    }

    fileImg.frame = CGRectZero;
    [self.mainView addSubview:fileImg];
    
    //更新人和时间
    UILabel *updateTimeLab = [UILabel initCustom:CGRectZero title:[NSString stringWithFormat:@"%@最后更新于%@",self.detailModel.basics.employee_name,[HQHelper nsdateToTime:[self.detailModel.basics.create_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"]] titleColor:kUIColorFromRGB(0x69696C) titleFont:12 bgColor:ClearColor];
    
    [self.mainView addSubview:updateTimeLab];
    
    //提示
    _tipLab = [UILabel initCustom:CGRectZero title:@"该文件暂不支持在线预览，请下载后查看～" titleColor:kUIColorFromRGB(0xA0A0AE) titleFont:14 bgColor:ClearColor];
    
    [self.mainView addSubview:_tipLab];
    
    //其他应用打开按钮
    _otherOpenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _otherOpenBtn.frame = CGRectZero;
    _otherOpenBtn.backgroundColor = kUIColorFromRGB(0x00BAEF);
    _otherOpenBtn.layer.cornerRadius = 10.0;
    _otherOpenBtn.layer.masksToBounds = YES;
    
    NSString *btnTitle = @"";
    if (_isDownloaded) {
        
        btnTitle = @"打开";
    }
    else {
    
        btnTitle = [NSString stringWithFormat:@"下载（%@）",[HQHelper fileSizeForKB:[self.detailModel.basics.size integerValue]]];
    }
    
    [_otherOpenBtn setTitle:btnTitle forState:UIControlStateNormal];
    [_otherOpenBtn setTitleColor:kUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [_otherOpenBtn addTarget:self action:@selector(openFile) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mainView addSubview:_otherOpenBtn];
    
    if (self.style == 1 || self.style == 2) {
        
        if ([self.detailModel.download isEqualToNumber:@0]) {
            
            _otherOpenBtn.hidden = YES;
        }
        else {
            
            _otherOpenBtn.hidden = NO;
        }
    }
    else {
        
        _otherOpenBtn.hidden = NO;
    }
    
    [fileImg mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset((SCREEN_WIDTH-68)/2);
        make.top.equalTo(self.view.mas_top).offset(90);
        make.width.height.equalTo(@68);
        
    }];
    
    [updateTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(fileImg.mas_bottom).offset(12);
        make.width.equalTo(@(SCREEN_WIDTH-30));
        make.height.equalTo(@17);
        
    }];
    
    [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(updateTimeLab.mas_bottom).offset(30);
        make.width.equalTo(@(SCREEN_WIDTH-30));
        make.height.equalTo(@20);
        
    }];
    
    [_otherOpenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(70);
        make.top.equalTo(_tipLab.mas_bottom).offset(20);
        make.width.equalTo(@(SCREEN_WIDTH-140));
        make.height.equalTo(@36);
        
    }];
    
    _downloadingView = [[TFDownloadingView alloc] init];
    _downloadingView.frame = CGRectZero;
    
    _downloadingView.hidden = YES;
    
    [self.mainView addSubview:_downloadingView];
    
    [_downloadingView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(updateTimeLab.mas_bottom).offset(55);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@30);
        
    }];
    
}

- (void)initBottomViewData {

    NSString *imgN = @"";
    if ([self.detailModel.fabulous_status isEqualToNumber:@1]) { //点赞
        
        imgN = @"赞";
    }
    else {
        
        imgN = @"点赞";
    }
    
    
    if (self.style == 2) { //应用文件
        
        self.imgs = @[imgN,@"文件下载",@"headMenu"];
        
        self.labs = @[[NSString stringWithFormat:@"%ld",[self.detailModel.fabulous_count integerValue]],@"",@""];
    }
    else if (self.style == 4 || self.style == 5) { //共享文件
        
        self.imgs = @[@"评论-7",imgN,@"文件下载"];
        
        self.labs = @[[NSString stringWithFormat:@"%ld",[self.detailModel.comment_count integerValue]],@"",@""];
    }
    else { //公司和个人文件
        
        if (self.style == 1) {
            
            if ([self.detailModel.download isEqualToNumber:@0]) {
                
                self.imgs = @[@"评论-7",imgN,@"headMenu"];
                self.labs = @[[NSString stringWithFormat:@"%ld",[self.detailModel.comment_count integerValue]],@"",@""];
            }
            else {
                
                self.imgs = @[@"评论-7",imgN,@"文件下载",@"headMenu"];
                self.labs = @[[NSString stringWithFormat:@"%ld",[self.detailModel.comment_count integerValue]],@"",@"",@""];
            }
        }
        else {
            
            self.imgs = @[@"评论-7",imgN,@"文件下载",@"headMenu"];
            self.labs = @[[NSString stringWithFormat:@"%ld",[self.detailModel.comment_count integerValue]],@"",@"",@""];
        }
        
    }
}

#pragma mark 创建底部按钮
- (void)createBottomView {
    

//    self.emailsBottomView = [[TFEmailsBottomView alloc] initWithBottomViewFrame:CGRectMake(0, SCREEN_HEIGHT-64-49, SCREEN_WIDTH, 49) labs:self.labs image:self.imgs];
//    
//    self.emailsBottomView.backgroundColor = kUIColorFromRGB(0xFFFFFF);
//    self.emailsBottomView.delegate = self;
//    
//    [self.view addSubview:self.emailsBottomView];

    
    
    _buttons = [NSMutableArray array];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-NaviHeight-55-BottomM, SCREEN_WIDTH, 55);
    bottomView.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bottomView];
    
    NSArray *imgArr = [NSArray array];
    
    NSString *imgN = @"";
    if ([self.detailModel.fabulous_status isEqualToNumber:@1]) { //点赞
        
        imgN = @"赞";
    }
    else {
    
        imgN = @"点赞";
    }
    
    imgArr = @[@"评论-7",imgN,@"文件下载",@"headMenu"];
    
    //按钮数量
    NSInteger count;
    if (self.style == 2) {
        
        
        if ([self.detailModel.download isEqualToNumber:@0]) {
            count = 2;
            imgArr = @[imgN,@"headMenu"];
        }else{
            
            count = 3;
            imgArr = @[imgN,@"文件下载",@"headMenu"];
        }
    }
    else if (self.style == 4 || self.style == 5) {// 我共享的，与我共享的
        
        count = 3;
        
        imgArr = @[@"评论-7",imgN,@"文件下载"];
    }
    else {
        
        if (self.style == 1) {
            
            if ([self.detailModel.download isEqualToNumber:@0]) {
                
                count = 3;
                
                imgArr = @[@"评论-7",imgN,@"headMenu"];
            }
            else {
                
                count = 4;
            }
        }
        else {
            
            count = 4;
        }
        
    }
    
    if (self.noAuth) {// 小助手@进入 20190115
        NSMutableArray *itemss = [NSMutableArray array];
        for (NSString *ss in imgArr) {
            if ([ss isEqualToString:@"headMenu"]) {
                continue;
            }
            [itemss addObject:ss];
        }
        imgArr = itemss;
        count = imgArr.count;
    }
    
    
    /** 尹明亮20181012添加此if ---start--- */
    if (self.projectId) {
        
        if ([self.library_type isEqualToString:@"1"]) {
            if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"30"]) {
                
                count = 2;
                
                imgArr = @[@"文件下载",@"删除24"];
            }else{
                
                count = 1;
                
                imgArr = @[@"文件下载"];
            }
        }else{
            
            count = 1;
            
            imgArr = @[@"文件下载"];
        }
        
    }
    /** 尹明亮20181012添加此if ---end---  */
    
    CGFloat btnW = (SCREEN_WIDTH-30)/count;
    
    
    for (int i=0; i<count; i++) {
        
        _oprationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _oprationBtn.tag = i;
        _oprationBtn.frame = CGRectMake(btnW*i+15, 0, btnW, 55);
        [_oprationBtn addTarget:self action:@selector(bottomOperation:) forControlEvents:UIControlEventTouchUpInside];
        
        [_oprationBtn setImage:IMG(imgArr[i]) forState:UIControlStateNormal];
        
        if (self.style == 2) {
            
            if (i==0 && [self.detailModel.fabulous_count integerValue]>0) {
                
                _oprationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
                [_oprationBtn setTitle:[NSString stringWithFormat:@"%ld",[self.detailModel.fabulous_count integerValue]] forState:UIControlStateNormal];
                [_oprationBtn setTitleColor:kUIColorFromRGB(0x69696C) forState:UIControlStateNormal];
                _oprationBtn.titleLabel.font = FONT(16);
                //button标题的偏移量，这个偏移量是相对于图片的
                //            oprationBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
                
            }
        }
        else {
        
            if (i==0 && [self.detailModel.comment_count integerValue]>0) {
                
                _oprationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
                [_oprationBtn setTitle:[NSString stringWithFormat:@"%ld",[self.detailModel.comment_count integerValue]] forState:UIControlStateNormal];
                [_oprationBtn setTitleColor:kUIColorFromRGB(0x69696C) forState:UIControlStateNormal];
                _oprationBtn.titleLabel.font = FONT(16);
                //button标题的偏移量，这个偏移量是相对于图片的
                //            oprationBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
                
            }
            if (i==1 && [self.detailModel.fabulous_count integerValue]>0) {
                
                _oprationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
                [_oprationBtn setTitle:[NSString stringWithFormat:@"%ld",[self.detailModel.fabulous_count integerValue]] forState:UIControlStateNormal];
                [_oprationBtn setTitleColor:kUIColorFromRGB(0x69696C) forState:UIControlStateNormal];
                _oprationBtn.titleLabel.font = FONT(16);
                //button标题的偏移量，这个偏移量是相对于图片的
                //            oprationBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
                
            }

        }
        
        [_buttons addObject:_oprationBtn];
        
        [bottomView addSubview:_oprationBtn];
        
        
    }
    
}

#pragma mark 导航栏点击事件
- (void)downloadRecord {

    TFDownloadRecordController *downloadRecord = [[TFDownloadRecordController alloc] init];
    
    downloadRecord.fileId = self.fileId;
    if (self.whereFrom == 3) {
        downloadRecord.isProject = YES;
        downloadRecord.fileId = self.detailModel.basics.id;
    }
    
    [self.navigationController pushViewController:downloadRecord animated:YES];
}

- (void)historyVersion {

    TFHistoryVersionController *historyVersion = [[TFHistoryVersionController alloc] init];
    
    historyVersion.fileId = self.fileId;
    historyVersion.download = self.detailModel.download;
    historyVersion.style = self.style;
    
    [self.navigationController pushViewController:historyVersion animated:YES];
}

#pragma mark 其他应用打开
- (void)openFile {
    
    if (_isDownloaded) {
        
//        if ([self.detailModel.basics.siffix isEqualToString:@"mp4"] ||
//            [self.detailModel.basics.siffix isEqualToString:@"mov"]) {
//
//            _tipLab.hidden = NO;
//            _otherOpenBtn.hidden = NO;
//            _downloadingView.hidden = YES;
//        }
//        else {
//
//            _tipLab.hidden = YES;
//            _otherOpenBtn.hidden = YES;
//            _downloadingView.hidden = NO;
//        }
        
        _tipLab.hidden = NO;
        _otherOpenBtn.hidden = NO;
        _downloadingView.hidden = YES;
    }
    else {
        
        _tipLab.hidden = YES;
        _otherOpenBtn.hidden = YES;
        _downloadingView.hidden = NO;
    }
    
    
    
    NSString *url = @"";
    if (self.whereFrom == 1 || self.whereFrom == 2) { //从聊天室进来
        
        url = self.fileUrl;
    }
    else if (self.whereFrom == 3) { //从项目文库来
        
//        url = [NSString stringWithFormat:@"%@%@%@?id=%@&project_id=%@&opType=2",kServerAddress,ServerAdress,@"/common/file/projectDownload",self.detailModel.basics.id,self.projectId];
        url = [NSString stringWithFormat:@"%@%@?id=%@&project_id=%@&opType=2",kServerAddress,@"/common/file/projectDownload",self.detailModel.basics.id,self.projectId];
    }
    else {
    
//        url = [NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/download",self.detailModel.basics.id];
        url = [NSString stringWithFormat:@"%@%@?id=%@",kServerAddress,@"/library/file/download",self.detailModel.basics.id];
    }
    
    [self.downloadManager download:url fileName:self.detailModel.basics.name progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        
        NSLog(@"progress:%f",progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _downloadingView.loadLab.text = [NSString stringWithFormat:@"下载中...(%@/%@)",[HQHelper fileSizeForKB:receivedSize],[HQHelper fileSizeForKB:expectedSize]];
            _downloadingView.progressView.progress = progress;
        });

        
    } state:^(DownloadState state) { //完成
        
        NSLog(@"state:%u",state);
        if (state == DownloadStateCompleted) {
            
            
        }
        
    } completion:^(NSString *filePath, NSInteger fileSize) {
        
        NSLog(@"filepath:%@",filePath);
        NSLog(@"fileSize:%ld",fileSize);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{

            _tipLab.hidden = NO;
            _otherOpenBtn.hidden = NO;
            _downloadingView.hidden = YES;
            [_otherOpenBtn setTitle:@"打开" forState:UIControlStateNormal];
            _isDownloaded = YES;
        });
        
        self.detailModel.basics.siffix = [self.detailModel.basics.siffix stringByReplacingOccurrencesOfString:@"." withString:@""];
        if ([[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"mp3"]) {
            

            HQMainQueue(^{
                
                self.mainView.hidden = YES;
                [self createPlayAudioView];
            });
            


        }
        else if ([[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"mp4"] || [[self.detailModel.basics.siffix lowercaseString] isEqualToString:@"mov"]) {

            
            AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
            //2、创建视频播放视图的控制器
            AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
            //3、将创建的AVPlayer赋值给控制器自带的player
            playerVC.player = player;
            //4、跳转到控制器播放
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:playerVC animated:YES completion:nil];
            [playerVC.player play];
            
        }
        else {
        
            
            dispatch_async(dispatch_get_main_queue(), ^{

                _tipLab.hidden = NO;
                _otherOpenBtn.hidden = NO;
                _downloadingView.hidden = YES;
                [_otherOpenBtn setTitle:@"打开" forState:UIControlStateNormal];
            });
            
            UIDocumentInteractionController *ctrl = [UIDocumentInteractionController  interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
            ctrl.delegate = self;
            [ctrl presentPreviewAnimated:YES];

        }
        

    }];
}

-(void)audioCell:(TFAudioFileCell *)audioCell withPlayer:(AVAudioPlayer *)player {

    self.audioPlayer = player;
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

#pragma mark - 在此代理处加载需要显示的文件
- (NSURL *)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    

    NSString *pathStr=[self.downloadManager getFilePathWithFileName:self.detailModel.basics.name];
    NSURL *fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",pathStr]];

    
    return fileURL;
}

#pragma mark - 返回文件的个数
-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}
#pragma mark - 即将要退出浏览文件时执行此方法
-(void)previewControllerWillDismiss:(QLPreviewController *)controller {
}

#pragma mark 底部操作按钮
- (void)bottomOperation:(UIButton *)button {
    
    
    /** 尹明亮20181012添加此if ---start--- */
    if (self.projectId) {
        
        NSInteger tag = button.tag;
        if (tag == 0) {// 下载按钮
            
            if (self.isImg == 1) {
                if (self.bigView.image) {
                    [self loadImageFinished:self.bigView.image];
                }else{
                    [MBProgressHUD showError:@"图片加载中..." toView:self.view];
                }
            }else{
                [self openFile];
            }
        }
        if (tag == 1) {// 删除按钮
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该文件吗？" preferredStyle:UIAlertControllerStyleAlert];
            // 2.1 创建按钮
            UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                
                
            }];
            
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestProjectLibraryDelLibraryWithData:self.naviTitle fileId:self.basics.id projectId:self.projectId];
                
            }];
            
            
            // 2.2 添加按钮
            [alertController addAction:editAction];
            [alertController addAction:deleteAction];
            
            
            // 3.显示警报控制器
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        return;
    }
    /** 尹明亮20181012添加此if ---end---  */
    
    if (self.style == 2) {
        
        switch (button.tag) {
            case 0:
            {
                
                _BtnIndex = button.tag;
                
                _oprationBtn = _buttons[_BtnIndex];
                
                _oprationBtn.enabled = NO;
                if ([self.detailModel.fabulous_status isEqualToNumber:@0]) {
                    
                    self.detailModel.fabulous_status = @1;
                    [_oprationBtn setImage:IMG(@"赞") forState:UIControlStateNormal];
                    
                    self.detailModel.fabulous_count = @([self.detailModel.fabulous_count integerValue]+1);
                    [_oprationBtn setTitle:[NSString stringWithFormat:@"%ld",[self.detailModel.fabulous_count integerValue]] forState:UIControlStateNormal];
                    _oprationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
                    [_oprationBtn setTitleColor:kUIColorFromRGB(0x69696C) forState:UIControlStateNormal];
                    _oprationBtn.titleLabel.font = FONT(16);
                }
                else {
                    
                    self.detailModel.fabulous_status = @0;
                    
                    [_oprationBtn setImage:IMG(@"点赞") forState:UIControlStateNormal];
                    self.detailModel.fabulous_count = @([self.detailModel.fabulous_count integerValue]-1);
                    
                    if (self.detailModel.fabulous_count>0) {
                        
                        
                        _oprationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
                        [_oprationBtn setTitleColor:kUIColorFromRGB(0x69696C) forState:UIControlStateNormal];
                        _oprationBtn.titleLabel.font = FONT(16);
                    }
                    
                    [_oprationBtn setTitle:[NSString stringWithFormat:@"%ld",[self.detailModel.fabulous_count integerValue]] forState:UIControlStateNormal];
                    
                }
                
                
                [self.fileBL requestWhetherFabulousWithData:self.detailModel.basics.id status:self.detailModel.fabulous_status];
            }
                
                break;
            case 1:
            {
                
                if ([self.detailModel.download isEqualToNumber:@1]) { //有权限能下载
                    
                    if (self.isImg == 1) { //是图片保存到相册
                        
//                        NSString *string = [NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/download",self.detailModel.basics.id];
                        NSString *string = [NSString stringWithFormat:@"%@%@?id=%@",kServerAddress,@"/library/file/download",self.detailModel.basics.id];
                        NSString *fileName = [NSString stringWithFormat:@"%@.%@",[HQHelper stringForMD5WithString:string],[self.detailModel.basics.siffix lowercaseString]?:@"jpg"];
                        [HQHelper cacheFileWithUrl:string fileName:fileName completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                            
                            
                            // 保存文件
                            NSString *filePath = [HQHelper saveCacheFileWithFileName:fileName data:data];
                            
                            if (filePath) {
                                UIImage *img = [UIImage imageWithData:data];
                                
                                [self loadImageFinished:img];
                            }
                            
                        } fileHandler:^(NSString *path) {
                            
                            UIImage *img = [UIImage imageWithContentsOfFile:path];
                            
                            [self loadImageFinished:img];
                        }];
                    }
                    else { //文件就下载到沙盒
                        
                        [self openFile];
                    }
                    
                }
                else { //无权限
                    
                    [self moreOperarionClicked];
                }
                
            }
                
                break;
            case 2:
            {
                
                
                [self moreOperarionClicked];
            }
                
                break;
                
            default:
                break;
        }

    }
    else {
    
        switch (button.tag) {
            case 0:
            {
                
                TFCustomerCommentController *comment = [[TFCustomerCommentController alloc] init];
                
                comment.id = self.detailModel.basics.id;
                comment.bean = @"file_library";
                comment.style = @(self.style);
                
                comment.refreshAction = ^(id parameter) {
                    
                    _BtnIndex = button.tag;
                    
                    _oprationBtn = _buttons[_BtnIndex];
                    
                    [_oprationBtn setTitle:[NSString stringWithFormat:@"%ld",[parameter integerValue]] forState:UIControlStateNormal];
                };
                
                [self.navigationController pushViewController:comment animated:YES];
            }
                
                break;
            case 1:
            {
                
                _BtnIndex = button.tag;
                
                _oprationBtn = _buttons[_BtnIndex];
                
                _oprationBtn.enabled = NO;
                if ([self.detailModel.fabulous_status isEqualToNumber:@0]) {
                    
                    self.detailModel.fabulous_status = @1;
                    [_oprationBtn setImage:IMG(@"赞") forState:UIControlStateNormal];
                    
                    self.detailModel.fabulous_count = @([self.detailModel.fabulous_count integerValue]+1);
                    [_oprationBtn setTitle:[NSString stringWithFormat:@"%ld",[self.detailModel.fabulous_count integerValue]] forState:UIControlStateNormal];
                    _oprationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
                    [_oprationBtn setTitleColor:kUIColorFromRGB(0x69696C) forState:UIControlStateNormal];
                    _oprationBtn.titleLabel.font = FONT(16);
                }
                else {
                    
                    self.detailModel.fabulous_status = @0;
                    
                    [_oprationBtn setImage:IMG(@"点赞") forState:UIControlStateNormal];
                    self.detailModel.fabulous_count = @([self.detailModel.fabulous_count integerValue]-1);
                    
                    if (self.detailModel.fabulous_count>0) {
                        
                        
                        _oprationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
                        [_oprationBtn setTitleColor:kUIColorFromRGB(0x69696C) forState:UIControlStateNormal];
                        _oprationBtn.titleLabel.font = FONT(16);
                    }
                    
                    [_oprationBtn setTitle:[NSString stringWithFormat:@"%ld",[self.detailModel.fabulous_count integerValue]] forState:UIControlStateNormal];
                    
                }
                
                
                [self.fileBL requestWhetherFabulousWithData:self.detailModel.basics.id status:self.detailModel.fabulous_status];
            }
                
                break;
            case 2:
            {
                
                if (self.style == 1) { //公司文件
                    
                    if ([self.detailModel.download isEqualToNumber:@1]) { //有权限能下载
                        
                        if (self.isImg == 1) { //是图片保存到相册
                            
//                            NSString *string = [NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/download",self.detailModel.basics.id];
                            NSString *string = [NSString stringWithFormat:@"%@%@?id=%@",kServerAddress,@"/library/file/download",self.detailModel.basics.id];
                            NSString *fileName = [NSString stringWithFormat:@"%@.%@",[HQHelper stringForMD5WithString:string],[self.detailModel.basics.siffix lowercaseString]?:@"jpg"];
                            [HQHelper cacheFileWithUrl:string fileName:fileName completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                
                                // 保存文件
                                NSString *filePath = [HQHelper saveCacheFileWithFileName:fileName data:data];
                                
                                if (filePath) {
                                    UIImage *img = [UIImage imageWithData:data];
                                    
                                    [self loadImageFinished:img];
                                }
                            } fileHandler:^(NSString *path) {
                                
                                UIImage *img = [UIImage imageWithContentsOfFile:path];
                                
                                [self loadImageFinished:img];
                            }];
                        }
                        else { //文件就下载到沙盒
                            
                            [self openFile];
                        }
                        
                    }
                    else { //无权限
                        
                        [self moreOperarionClicked];
                    }

                }
                else {
                
                    if (self.isImg == 1) { //是图片保存到相册
                        
//                        NSString *string = [NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/download",self.detailModel.basics.id];
                        NSString *string = [NSString stringWithFormat:@"%@%@?id=%@",kServerAddress,@"/library/file/download",self.detailModel.basics.id];
                        NSString *fileName = [NSString stringWithFormat:@"%@.%@",[HQHelper stringForMD5WithString:string],[self.detailModel.basics.siffix lowercaseString]?:@"jpg"];
                        [HQHelper cacheFileWithUrl:string fileName:fileName completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                            
                            
                            // 保存文件
                            NSString *filePath = [HQHelper saveCacheFileWithFileName:fileName data:data];
                            
                            if (filePath) {
                                UIImage *img = [UIImage imageWithData:data];
                                
                                [self loadImageFinished:img];
                            }
                        } fileHandler:^(NSString *path) {
                            
                            UIImage *img = [UIImage imageWithContentsOfFile:path];
                            
                            [self loadImageFinished:img];
                        }];
                    }
                    else { //文件就下载到沙盒
                        
                        [self openFile];
                    }
                }
                
            }
                
                break;
            case 3:
            {
                
                
                [self moreOperarionClicked];
            }
                
                break;
                
            default:
                break;
        }

    }
}

#pragma mark TFEmailsBottomViewDelegate
- (void)bottomButtonClicked:(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 0:
        {
            
            TFCustomerCommentController *comment = [[TFCustomerCommentController alloc] init];
            
            comment.id = self.detailModel.basics.id;
            comment.bean = @"file_library";
            comment.refreshAction = ^(id parameter) {
                
//                [self.emailsBottomView refreshButtonTitle:parameter index:buttonIndex];

                [self.emailsBottomView removeFromSuperview];
                
                NSString *imgN = @"";
                if ([self.detailModel.fabulous_status isEqualToNumber:@1]) { //点赞
                    
                    imgN = @"赞";
                }
                else {
                    
                    imgN = @"点赞";
                }
                
                self.labs = @[[NSString stringWithFormat:@"%@",parameter],self.detailModel.fabulous_count,@"",@""];
                
                self.imgs = @[@"评论-7",imgN,@"文件下载",@"headMenu"];
                
                [self createBottomView];
//                self.imgs = @[@"评论-7",@"赞",@"文件下载",@"headMenu"];
//                self.labs = @[[NSString stringWithFormat:@"%@",parameter],@"",@"",@""];
//                
//                self.emailsBottomView = [[TFEmailsBottomView alloc] initWithBottomViewFrame:CGRectMake(0, SCREEN_HEIGHT-64-49, SCREEN_WIDTH, 49) labs:self.labs image:self.imgs];
                
//                _BtnIndex = button.tag;
                
//                _oprationBtn = _buttons[_BtnIndex];
                
//                [_oprationBtn setTitle:[NSString stringWithFormat:@"%ld",[parameter integerValue]] forState:UIControlStateNormal];
            };
            
            [self.navigationController pushViewController:comment animated:YES];
        }
            
            break;
        case 1:
        {
            
//            _BtnIndex = button.tag;
            
//            _oprationBtn = _buttons[_BtnIndex];
            
            _oprationBtn.enabled = NO;
            if ([self.detailModel.fabulous_status isEqualToNumber:@0]) {
                
                self.detailModel.fabulous_status = @1;
                
                [_oprationBtn setImage:IMG(@"赞") forState:UIControlStateNormal];
                
                self.detailModel.fabulous_count = @([self.detailModel.fabulous_count integerValue]+1);
                [_oprationBtn setTitle:[NSString stringWithFormat:@"%ld",[self.detailModel.fabulous_count integerValue]] forState:UIControlStateNormal];
                _oprationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
                [_oprationBtn setTitleColor:kUIColorFromRGB(0x69696C) forState:UIControlStateNormal];
                _oprationBtn.titleLabel.font = FONT(16);
            }
            else {
                
                self.detailModel.fabulous_status = @0;
                
                [_oprationBtn setImage:IMG(@"点赞") forState:UIControlStateNormal];
                self.detailModel.fabulous_count = @([self.detailModel.fabulous_count integerValue]-1);
                
                if (self.detailModel.fabulous_count>0) {
                    
                    
                    _oprationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
                    [_oprationBtn setTitleColor:kUIColorFromRGB(0x69696C) forState:UIControlStateNormal];
                    _oprationBtn.titleLabel.font = FONT(16);
                }
                
                [_oprationBtn setTitle:[NSString stringWithFormat:@"%ld",[self.detailModel.fabulous_count integerValue]] forState:UIControlStateNormal];
                
            }
            
            
            [self.fileBL requestWhetherFabulousWithData:self.detailModel.basics.id status:self.detailModel.fabulous_status];
        }
            
            break;
        case 2:
        {
            
            if ([self.detailModel.download isEqualToNumber:@1]) { //有权限能下载
                
                if (self.isImg == 1) { //是图片保存到相册
                    
//                    NSString *string = [NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/download",self.detailModel.basics.id];
                    NSString *string = [NSString stringWithFormat:@"%@%@?id=%@",kServerAddress,@"/library/file/download",self.detailModel.basics.id];
                    NSString *fileName = [NSString stringWithFormat:@"%@.%@",[HQHelper stringForMD5WithString:string],[self.detailModel.basics.siffix lowercaseString]?:@"jpg"];
                    [HQHelper cacheFileWithUrl:string fileName:fileName completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        
                        
                        // 保存文件
                        NSString *filePath = [HQHelper saveCacheFileWithFileName:fileName data:data];
                        
                        if (filePath) {
                            UIImage *img = [UIImage imageWithData:data];
                            
                            [self loadImageFinished:img];
                        }
                    } fileHandler:^(NSString *path) {
                        
                        UIImage *img = [UIImage imageWithContentsOfFile:path];
                        
                        [self loadImageFinished:img];
                    }];
                }
                else { //文件就下载到沙盒
                    
                    [self openFile];
                }
                
            }
            else { //无权限
                
                [self moreOperarionClicked];
            }
            
        }
            
            break;
        case 3:
        {
            
            
            [self moreOperarionClicked];
        }
            
            break;
            
        default:
            break;
    }

}

#pragma mark 更多操作
- (void)moreOperarionClicked {

    NSArray *operationArr = [NSArray array];
    
    if ([self.detailModel.basics.create_by isEqualToNumber:UM.userLoginInfo.employee.id] && [self.detailModel.is_manage integerValue] != 1) { //是创建者
        
        operationArr = @[@"发送到聊天",@"重命名",@"上传新版本"];
        
    }
    else if ([self.detailModel.is_manage integerValue] == 1) { //管理员
        
        operationArr = @[@"发送到聊天",@"重命名",@"上传新版本",@"移动",@"复制",@"共享",@"删除"];
    }
    else { //成员
        
        operationArr = @[@"发送到聊天"];
    }
    
    if (self.style == 3) { //个人文件
        
        
        operationArr = @[@"发送到聊天",@"重命名",@"上传新版本",@"转为公司文件",@"移动",@"复制",@"共享",@"删除"];
    }
    
    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" titles:operationArr];
    
    sheet.tag = 101;
    
    //            if (self.style == 3) {
    //
    //                sheet.tag = 103;
    //            }
    
    [sheet show];

}

#pragma mark 保存到相册
- (void)loadImageFinished:(UIImage *)image
{
    [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
        
        if (granted) {
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        }
        else if (!firstTime )
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相册权限，是否前往设置" cancel:@"取消" setting:@"设置"];
        }
        
    }];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    
    [MBProgressHUD showError:@"保存成功" toView:self.view];
    
}

//图片点击
- (void)tapAction {
    
    NSMutableArray *items = @[].mutableCopy;
    
    NSString *url = @"";
    if (self.whereFrom == 1 || self.whereFrom == 2) {
        
        url = self.fileUrl;
    }
    else if (self.whereFrom == 3) {
            
//        url = [NSString stringWithFormat:@"%@%@%@?id=%@&project_id=%@",kServerAddress,ServerAdress,@"/common/file/projectDownload",self.detailModel.basics.id,self.projectId];
        url = [NSString stringWithFormat:@"%@%@?id=%@&project_id=%@",kServerAddress,@"/common/file/projectDownload",self.detailModel.basics.id,self.projectId];
        
    }
    else {
    
//        url = [NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/download",self.detailModel.basics.id];
        url = [NSString stringWithFormat:@"%@%@?id=%@",kServerAddress,@"/library/file/download",self.detailModel.basics.id];
    }

    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(_bigView.centerX, _bigView.centerY, 0, 0)];
    [self.view addSubview:imgV];
    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imgV thumbImage:_bigView.image imageUrl:[HQHelper URLWithString:url]];
    [items addObject:item];
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:0];
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlurPhoto;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleDot;
    browser.showType = KSPhotoBrowserTypeNone;
    browser.fileTitle = self.detailModel.basics.name;
    //    browser.delegate = self;
    browser.bounces = NO;
    [browser showFromViewController:self];
}


#pragma mark FDActionSheetDelegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {

    if (sheet.tag == 101) {
        
        if (buttonIndex<3) {
            
            switch (buttonIndex) {
                case 0:
                {
                    
                    TFSelectChatPersonController *select = [[TFSelectChatPersonController alloc] init];
                    
                    select.type = 0;
                    
                    select.haveGroup = YES;
                    
                    select.isSend = YES;
                    
                    TFFileModel *fileModel = [[TFFileModel alloc] init];
                    
//                    fileModel.file_url = [NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/downloadWithoutRecord",self.detailModel.basics.id];
                    fileModel.file_url = [NSString stringWithFormat:@"%@?id=%@",@"/library/file/downloadWithoutRecord",self.detailModel.basics.id];
                    fileModel.file_type = self.detailModel.basics.siffix;
                    fileModel.file_name = self.detailModel.basics.name;
                    fileModel.file_size = @([self.detailModel.basics.size integerValue]);
                    fileModel.fileId = self.detailModel.basics.id;
                    
                    select.fileModel = fileModel;
                    
                    [self.navigationController pushViewController:select animated:YES];
                }
                    
                    break;
                case 1: //重命名
                {
                    
                    HQTFProjectDescController *desc = [[HQTFProjectDescController alloc] init];
                    desc.descString = self.detailModel.basics.name;
                    desc.naviTitle = @"重命名";
                    desc.sectionTitle = @"文件名称";
                    desc.descAction = ^(NSString *text){
                        
                        self.detailModel.basics.name = text;
                        
                        [self.fileBL requestEditRenameWithData:self.detailModel.basics.id fname:self.detailModel.basics.name];
                        
                        self.navigationItem.title = self.detailModel.basics.name;
                        
                    };
                    [self.navigationController pushViewController:desc animated:YES];
                }
                    
                    break;
                case 2:
                {
                    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相册中上传", nil];
                    
                    sheet.tag = 102;
                    [sheet show];
                    
                }
                    
                    break;
                default:
                    break;
            }

        }
        else {
        
            if (self.style == 1) {
                
                buttonIndex = buttonIndex + 1;
            }
            switch (buttonIndex) {
                case 3:
                {
                    TFMoveFileController *moveFile = [[TFMoveFileController alloc] init];
                    
                    moveFile.pathArr = [NSMutableArray array];
                    [moveFile.pathArr addObject:self.pathArr[0]];
                    
                    moveFile.folderId = self.detailModel.basics.id;
                    moveFile.folderSeries = 0; //不管哪一级进去都先获取第一级文件夹
                    moveFile.style = 1; //传公司文件style
                    moveFile.type = 2; //转为公司文件（跟复制一样）
                    
                    [self.navigationController pushViewController:moveFile animated:YES];
                    
                }
                    
                    break;
                case 4:
                {
                    
                    TFMoveFileController *moveFile = [[TFMoveFileController alloc] init];
                    
                    moveFile.pathArr = [NSMutableArray array];
                    [moveFile.pathArr addObject:self.pathArr[0]];
                    
                    moveFile.folderId = self.detailModel.basics.id;
                    moveFile.folderSeries = 0; //不管哪一级进去都先获取第一级文件夹
                    moveFile.style = self.style;
                    moveFile.type = 0; //移动
                    
                    [self.navigationController pushViewController:moveFile animated:YES];
                }
                    
                    break;
                case 5:
                {
                    TFMoveFileController *moveFile = [[TFMoveFileController alloc] init];
                    
                    moveFile.pathArr = [NSMutableArray array];
                    [moveFile.pathArr addObject:self.pathArr[0]];
                    
                    moveFile.folderId = self.detailModel.basics.id;
                    moveFile.folderSeries = 0; //不管哪一级进去都先获取第一级文件夹
                    moveFile.style = self.style;
                    moveFile.type = 1; //复制
                    
                    [self.navigationController pushViewController:moveFile animated:YES];
                    
                }
                    
                    break;
                case 6:
                {
                    
                    TFMutilStyleSelectPeopleController *select = [[TFMutilStyleSelectPeopleController alloc] init];
                    select.isSingleSelect = NO;
                    select.selectType = 1;
                    
                    select.actionParameter = ^(id parameter) {
                        
                        NSArray *peoples = parameter;
                        
                        NSString *str = @"";
                        
                        for (HQEmployModel *model in peoples) {
                            
                            str = [str stringByAppendingFormat:@",%@", model.id];
                        }
                        
                        str = [str substringFromIndex:1];
                        
                        [self.fileBL requestShareFileLibarayWithData:self.fileId shareBy:str];
                        
                    };
                    
                    [self.navigationController pushViewController:select animated:YES];
                }
                    
                    break;
                case 7:
                {
                    
                    [AlertView showAlertView:@"提示" msg:@"删除文件后历史版本也会被一并删除，且不可恢复。你确定要删除吗？" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
                        
                    } onRightTouched:^{
                        
                        [self.fileBL requestDelFileLibraryWithData:self.detailModel.basics.id];
                    }];
                }
                    
                    break;
                    
                default:
                    break;
            }

        }
        
    }
    else if (sheet.tag == 102) {
            
        [self openAlbum];

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
        UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        // 添加图片
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        NSString *fileName = [representation filename];
        HQLog(@"fileName : %@",fileName);
        
        // 选择照片上传
        
        [self.fileBL requestFileVersionUploadWithData:self.detailModel.basics.id folderUrl:self.detailModel.basics.url type:@(self.style) datas:@[image]];
        
        
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_queryFileLibarayDetail) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.detailModel = resp.body;
        
//        _isDownloaded = [self.downloadManager isCompletion:[NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/download",self.detailModel.basics.id]];
        _isDownloaded = [self.downloadManager isCompletion:[NSString stringWithFormat:@"%@%@?id=%@",kServerAddress,@"/library/file/download",self.detailModel.basics.id]];

        self.detailModel.basics.siffix = [self.detailModel.basics.siffix stringByReplacingOccurrencesOfString:@"." withString:@""];
        if ([self.detailModel.basics.siffix isEqualToString:@"jpg"] ||[self.detailModel.basics.siffix isEqualToString:@"jpeg"] ||[self.detailModel.basics.siffix isEqualToString:@"png"] ||[self.detailModel.basics.siffix isEqualToString:@"gif"] ) {
            
            self.isImg = 1;
            
            [self createBigImageView];
        }

        else {
        
            [self createMainView];
            
            if (_isDownloaded) {
                
                _tipLab.hidden = NO;
                _otherOpenBtn.hidden = NO;
                _downloadingView.hidden = YES;
                _isDownloaded = YES;
                [_otherOpenBtn setTitle:@"打开" forState:UIControlStateNormal];
            }
        }
        
        if (self.whereFrom == 0) {
            
//            [self initBottomViewData];
            
            [self createBottomView];
        }
        
        
    }
    if (resp.cmdId == HQCMD_shareFileLibaray) {
        
        [MBProgressHUD showError:@"共享成功" toView:self.view];
    }
    if (resp.cmdId == HQCMD_editRename) {
        
        
    }
    if (resp.cmdId == HQCMD_whetherFabulous) {
        
        _oprationBtn = _buttons[_BtnIndex];
        
        _oprationBtn.enabled = YES;
    }
    
    if (resp.cmdId == HQCMD_projectLibraryDelLibrary) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [MBProgressHUD showError:@"删除成功" toView:self.view];
        
        if (self.refreshAction) {
            self.refreshAction();
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        return;
    }
    
    if (resp.cmdId == HQCMD_delFileLibrary) {
        
        if (self.refreshAction) {
            
            self.refreshAction();
        }
        
        [MBProgressHUD showError:@"删除成功" toView:self.view];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    
    if (resp.cmdId == HQCMD_FileVersionUpload) { //上传新版本
        
        if (self.refreshAction) {
            
            self.refreshAction();
        }
        
        [MBProgressHUD showError:@"上传成功" toView:self.view];
        
        [self.navigationController popViewControllerAnimated:YES];


    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}


@end
