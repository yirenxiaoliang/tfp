//
//  TFProjectFileDetailController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/10.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectFileDetailController.h"
#import "TFAudioFileCell.h"
#import "KSPhotoBrowser.h"

#import "HSDownloadManager.h"
#import "FileManager.h"
#import <QuickLook/QuickLook.h>
#import "PreviewControllerToolbar.h"
#import "PreviewNavigationController.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"

@interface TFProjectFileDetailController ()<UITableViewDelegate,UITableViewDataSource,TFAudioFileCellDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>

@property (nonatomic, strong) UIImageView *bigView;

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) HSDownloadManager *downloadManager;

@property (strong, nonatomic) QLPreviewController *qlpreView;

/** 底部按钮 */
@property (nonatomic, weak) UIView *bottomView;

@end

@implementation TFProjectFileDetailController

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
    
    self.enablePanGesture = NO;
    [self setNavi];
    
    self.downloadManager = [HSDownloadManager sharedInstance];
    self.fileModel.suffix = [self.fileModel.suffix stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if ([[self.fileModel.suffix lowercaseString] isEqualToString:@"jpg"] ||[[self.fileModel.suffix lowercaseString] isEqualToString:@"jpeg"] ||[[self.fileModel.suffix lowercaseString] isEqualToString:@"png"] ||[[self.fileModel.suffix lowercaseString] isEqualToString:@"gif"]) {  //图片
        
        [self createImagePreview];
    }
    else if ([self.fileModel.suffix isEqualToString:@"mp3"]) { //音频
        
        [self createPlayAudioView];
    }
    else { //其他
        
        [self createMainView];
    }
    
    [self setupBottomView];
}

- (void)setupBottomView{
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-NaviHeight-55, SCREEN_WIDTH, 55);
    bottomView.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    bottomView.hidden = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:button];
    button.frame = bottomView.bounds;
    [button setImage:IMG(@"文件下载") forState:UIControlStateNormal];
    [button setImage:IMG(@"文件下载") forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(downloadFile) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setNavi {
    
    self.navigationItem.title = self.fileModel.file_name;
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(shareAction) image:@"项目文库分享" highlightImage:@"项目文库分享"];
}

#pragma mark 图片
- (void)createImagePreview {
    
    _bigView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-64-8)];
    
    _bigView.userInteractionEnabled = YES;

    NSURL *url;
    if (self.isFromChatRoom) {
        
        url = [HQHelper URLWithString:self.fileModel.url];
    }
    else {
        
//        url = [HQHelper URLWithString:[NSString stringWithFormat:@"%@%@%@?id=%@&project_id=%@&width=64",kServerAddress,ServerAdress,@"/common/file/projectDownload",self.fileModel.id,self.projectId]];
        url = [HQHelper URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&project_id=%@&width=64",kServerAddress,@"/common/file/projectDownload",self.fileModel.id,self.projectId]];
    }

    [_bigView sd_setImageWithURL:url];
    _bigView.contentMode = UIViewContentModeScaleAspectFit;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self.view addSubview:_bigView];
    
    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    
    [_bigView addGestureRecognizer:imgTap];
}

#pragma mark - 语音文件
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
    //    self.tableView = tableView;
    
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
    
    if (self.isFromChatRoom) {
        
        model.voiceUrl = self.fileModel.url;
    }
    else {
        
//        model.voiceUrl = [NSString stringWithFormat:@"%@%@%@?id=%@&project_id=%@",kServerAddress,ServerAdress,@"/common/file/projectDownload",self.fileModel.id,self.projectId];
        model.voiceUrl = [NSString stringWithFormat:@"%@%@?id=%@&project_id=%@",kServerAddress,@"/common/file/projectDownload",self.fileModel.id,self.projectId];
    }
    
//    NSURL *url = [HQHelper URLWithString:[NSString stringWithFormat:@"%@%@%@?id=%@&project_id=%@&width=64",kServerAddress,ServerAdress,@"/common/file/projectDownload",self.fileModel.id,self.projectId]];
//    model.voiceUrl = [NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/downloadWithoutRecord",self.fileModel.id];
    //    model.voiceUrl = @"http://192.168.1.183:8081/custom-gateway/common/file/download4Show?bean=chat111&fileName=201806291616120.mp4&contentType=video/mp4&fileSize=17924152";
    //        model.voiceDuration = self.file.voiceDuration;
    cell.bottomLine.hidden = YES;
    [cell refreshAudioFileCellWithAudioModel :model withType:1];
    cell.delegate =self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
}

- (void)createMainView {
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight)];
    self.mainView.backgroundColor = kUIColorFromRGB(0xF2F2F2);
    
    [self.view addSubview:self.mainView];
    
    //文件格式图片
    UIImageView *fileImg = [[UIImageView alloc] init];
    
    self.fileModel.suffix = [self.fileModel.suffix stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if ([[self.fileModel.suffix lowercaseString] isEqualToString:@"mp4"] ||
        [[self.fileModel.suffix lowercaseString] isEqualToString:@"mov"]){// 视频
        
        fileImg.image = IMG(@"mp4");
        
    }else if ([[self.fileModel.suffix lowercaseString] isEqualToString:@"doc"] || [[self.fileModel.suffix lowercaseString] isEqualToString:@"docx"]){// doc
        
        fileImg.image = IMG(@"doc");
        
    }else if ([[self.fileModel.suffix lowercaseString] isEqualToString:@"xls"] || [[self.fileModel.suffix lowercaseString] isEqualToString:@"xlsx"]){// xls
        
        fileImg.image = IMG(@"xls");
        
    }else if ([[self.fileModel.suffix lowercaseString] isEqualToString:@"ppt"] || [[self.fileModel.suffix lowercaseString] isEqualToString:@"pptx"]){// ppt
        
        fileImg.image = IMG(@"ppt");
        
    }else if ([[self.fileModel.suffix lowercaseString] isEqualToString:@"ai"]){// ai
        
        fileImg.image = IMG(@"ai");
        
    }else if ([[self.fileModel.suffix lowercaseString] isEqualToString:@"cdr"]){// cdr
        
        fileImg.image = IMG(@"cdr");
        
    }else if ([[self.fileModel.suffix lowercaseString] isEqualToString:@"dwg"]){// dwg
        
        fileImg.image = IMG(@"dwg");
        
    }else if ([[self.fileModel.suffix lowercaseString] isEqualToString:@"ps"]){// ps
        
        fileImg.image = IMG(@"ps");
        
    }else if ([[self.fileModel.suffix lowercaseString] isEqualToString:@"pdf"]){// pdf
        
        fileImg.image = IMG(@"pdf");
        
    }else if ([[self.fileModel.suffix lowercaseString] isEqualToString:@"txt"]){// txt
        
        fileImg.image = IMG(@"txt");
        
    }else if ([[self.fileModel.suffix lowercaseString] isEqualToString:@"zip"] ||
              [[self.fileModel.suffix lowercaseString] isEqualToString:@"rar"]){// zip
        
        fileImg.image = IMG(@"zip");
        
    }else{
        
        fileImg.image = IMG(@"未知文件");
        
    }
    
    fileImg.frame = CGRectZero;
    [self.mainView addSubview:fileImg];
    
    //文件名
    UILabel *nameLab = [UILabel initCustom:CGRectZero title:self.fileModel.file_name titleColor:kUIColorFromRGB(0x323232) titleFont:14 bgColor:ClearColor];
    
    [self.mainView addSubview:nameLab];
    
    //文件大小
    UILabel *sizeLab = [UILabel initCustom:CGRectZero title:[HQHelper fileSizeForKB:[self.fileModel.size integerValue]] titleColor:kUIColorFromRGB(0x999999) titleFont:11 bgColor:ClearColor];
    
    [self.mainView addSubview:sizeLab];
    
    //在线预览
    UILabel *previewLab = [UILabel initCustom:CGRectZero title:@"在线预览" titleColor:GreenColor titleFont:13 bgColor:ClearColor];
    
    [self.mainView addSubview:previewLab];
    
    //下载按钮
    UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadBtn.frame = CGRectZero;
    downloadBtn.backgroundColor = kUIColorFromRGB(0x3689E9);
    downloadBtn.layer.cornerRadius = 4.0;
    downloadBtn.layer.masksToBounds = YES;
    downloadBtn.titleLabel.font = FONT(13);
    [downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downloadBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(downloadFile) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mainView addSubview:downloadBtn];
    
    //删除按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectZero;
    deleteBtn.backgroundColor = kUIColorFromRGB(0xf2f2f2);
    deleteBtn.layer.cornerRadius = 4.0;
    deleteBtn.layer.masksToBounds = YES;
    deleteBtn.layer.borderWidth = 0.5;
    deleteBtn.layer.borderColor = [kUIColorFromRGB(0xF55A23) CGColor];
    deleteBtn.titleLabel.font = FONT(13);
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:kUIColorFromRGB(0xF55A23) forState:UIControlStateNormal];
//    [deleteBtn addTarget:self action:@selector(deleteFile) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mainView addSubview:deleteBtn];
    
    [fileImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset((SCREEN_WIDTH-68)/2);
        make.top.equalTo(self.view.mas_top).offset(90);
        make.width.height.equalTo(@68);
        
    }];
    
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(fileImg.mas_bottom).offset(12);
        make.centerX.equalTo(fileImg.mas_centerX);
        make.width.equalTo(@(SCREEN_WIDTH-30));
        make.height.equalTo(@20);
    }];
    
    [sizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(nameLab.mas_bottom).offset(6);
        make.centerX.equalTo(fileImg.mas_centerX);
        make.width.equalTo(@(SCREEN_WIDTH-30));
        make.height.equalTo(@17);
    }];
    
    [previewLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(sizeLab.mas_bottom).offset(6);
        make.centerX.equalTo(fileImg.mas_centerX);
        make.width.equalTo(@(SCREEN_WIDTH-30));
        make.height.equalTo(@18);
    }];
    
    [downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(previewLab.mas_bottom).offset(30);
        make.centerX.equalTo(fileImg.mas_centerX);
        make.width.equalTo(@(SCREEN_WIDTH-150));
        make.height.equalTo(@30);
    }];
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(downloadBtn.mas_bottom).offset(20);
        make.centerX.equalTo(fileImg.mas_centerX);
        make.width.equalTo(@(SCREEN_WIDTH-150));
        make.height.equalTo(@30);
    }];
    
//    _downloadingView = [[TFDownloadingView alloc] init];
//    _downloadingView.frame = CGRectZero;
//    _downloadingView.hidden = YES;
//
//    [self.mainView addSubview:_downloadingView];
//
//    [_downloadingView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.view.mas_left).offset(0);
//        make.top.equalTo(updateTimeLab.mas_bottom).offset(55);
//        make.width.equalTo(@(SCREEN_WIDTH));
//        make.height.equalTo(@30);
//
//    }];
    
}

#pragma mark TFAudioFileCellDelegate
-(void)audioCell:(TFAudioFileCell *)audioCell withPlayer:(AVAudioPlayer *)player {
    
    self.audioPlayer = player;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_HEIGHT-NaviHeight-55-8;
}

#pragma mark 图片点击
- (void)tapAction {
    
    NSMutableArray *items = @[].mutableCopy;
    
    NSString *url = @"";
    if (self.isFromChatRoom) {
        
        url = self.fileModel.url;
    }
    else {
        
//        url = [NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/download",self.fileModel.id];
        url = [NSString stringWithFormat:@"%@%@?id=%@",kServerAddress,@"/library/file/download",self.fileModel.id];
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
    browser.fileTitle = self.fileModel.file_name;
    //    browser.delegate = self;
    browser.bounces = NO;
    [browser showFromViewController:self];
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
#pragma mark 下载
- (void)downloadFile {
    
   if ([[self.fileModel.suffix lowercaseString] isEqualToString:@"jpg"] ||[[self.fileModel.suffix lowercaseString] isEqualToString:@"jpeg"] ||[[self.fileModel.suffix lowercaseString] isEqualToString:@"png"] ||[[self.fileModel.suffix lowercaseString] isEqualToString:@"gif"]) {  //图片
       if (self.bigView.image) {
           [self loadImageFinished:self.bigView.image];
       }else{
           [MBProgressHUD showError:@"图片加载中..." toView:self.view];
       }
       return;
   }
    
//    NSString *url = [NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/download",self.fileModel.id];
    NSString *url = [NSString stringWithFormat:@"%@%@?id=%@",kServerAddress,@"/library/file/download",self.fileModel.id];
    [self.downloadManager download:url fileName:self.fileModel.file_name progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        
        NSLog(@"progress:%f",progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            _downloadingView.loadLab.text = [NSString stringWithFormat:@"下载中...(%@/%@)",[HQHelper fileSizeForKB:receivedSize],[HQHelper fileSizeForKB:expectedSize]];
//            _downloadingView.progressView.progress = progress* 100;
        });
        
        
    } state:^(DownloadState state) { //完成
        
        NSLog(@"state:%u",state);
        
        
    } completion:^(NSString *filePath, NSInteger fileSize) {
        
        NSLog(@"filepath:%@",filePath);
        NSLog(@"fileSize:%ld",fileSize);

            
        self.qlpreView =[[QLPreviewController alloc]init];
        self.qlpreView.view.frame =self.view.bounds;
        self.qlpreView.delegate=self;
        self.qlpreView.dataSource=self;
        
        [[UIToolbar appearance] setHidden:YES];
        //设置导航栏背景颜色
        [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
        //修改中间标题颜色
        NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        [[UINavigationBar appearance] setTitleTextAttributes:dict];
        //状态栏
        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
        //透明
        [[UINavigationBar appearance] setTranslucent:YES];
        
        PreviewControllerToolbar *preToolbar = [[PreviewControllerToolbar alloc] init];
        PreviewNavigationController *previewNavigationController = [[PreviewNavigationController alloc] initWithNavigationBarClass:nil toolbarClass:[preToolbar class]];
        
        self.qlpreView.hidesBottomBarWhenPushed = YES;
        
        previewNavigationController.imgName = self.fileModel.file_name;
//        previewNavigationController.imgUrl = [NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/download",self.fileModel.id];
        previewNavigationController.imgUrl = [NSString stringWithFormat:@"%@%@?id=%@",kServerAddress,@"/library/file/download",self.fileModel.id];
        
        
        [previewNavigationController pushViewController:self.qlpreView animated:YES];
        previewNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;

        [self presentViewController:previewNavigationController animated:YES completion:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{

        });

        
    }];
}

#pragma mark - 在此代理处加载需要显示的文件
- (NSURL *)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    
    //    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HSCache"];
    //    NSString *path23 = [path stringByAppendingPathComponent:[self.downloadManager fileIdWithUrl:[NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/download",_detailModel.basics.id]]];
    
    NSString *pathStr=[self.downloadManager getFilePathWithFileName:self.fileModel.file_name];
    NSURL *fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",pathStr]];
    
    //    NSString *cachesPath = cachesPathArr[0];
    //    NSLog(@"%@", cachesPath);
    
    //    NSString *pathStr=[[NSBundle mainBundle] pathForResource:[self.downloadManager fileIdWithUrl:[NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/download",_detailModel.basics.id]] ofType:@"jpg"];
    
    //NSString *pathStr=[self.downloadManager fileIdWithUrl:[NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/download",_detailModel.basics.id]];
    //    NSURL *fileURL = [NSURL fileURLWithPath:path23];
    
    
    return fileURL;
}

#pragma mark - 返回文件的个数
-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}
#pragma mark - 即将要退出浏览文件时执行此方法
-(void)previewControllerWillDismiss:(QLPreviewController *)controller {
}

#pragma mark 分享
- (void)shareAction {
    
    
}

@end
