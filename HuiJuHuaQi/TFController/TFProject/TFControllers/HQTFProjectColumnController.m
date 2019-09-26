//
//  HQTFProjectColumnController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProjectColumnController.h"
#import "HQTFTwoLineCell.h"
#import "TFProjectBL.h"
#import "HQTFNoContentView.h"
#import "KSPhotoBrowser.h"
#import "TFPlayVoiceController.h"
#import "MWPhotoBrowser.h"
#import "FileManager.h"

@interface HQTFProjectColumnController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,MWPhotoBrowserDelegate,UIDocumentInteractionControllerDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** TFProjectBL */
@property (nonatomic, strong) TFProjectBL *projectBL;


/** files */
@property (nonatomic, strong) NSMutableArray *files;
/** images */
@property (nonatomic, strong) NSMutableArray *images;

/** noContentView */
@property (nonatomic, strong)  HQTFNoContentView *noContentView;


@end

@implementation HQTFProjectColumnController

-(NSMutableArray *)images{
    
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

-(NSMutableArray *)files{
    if (!_files) {
        _files = [NSMutableArray array];
    }
    return _files;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNoContentView];
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
    [self.projectBL requestProjectFileWithTaskListId:self.projectTaskRow.id];
    
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"项目成员共5个" textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.files.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    cell.type = TwoLineCellTypeTwo;
    cell.topLabel.textColor = LightBlackTextColor;
    cell.bottomLabel.textColor = LightGrayTextColor;
    cell.enterImage.hidden = YES;
    cell.bottomLine.hidden = NO;
    cell.headMargin = 15;
    if (indexPath.row == 0) {
        cell.topLine.hidden = NO;
    }else{
        cell.topLine.hidden = YES;
    }
    if (indexPath.row + 1 == self.files.count) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    
    // 数据
    TFFileModel *model = self.files[indexPath.row];
    
    if ([[model.fileType lowercaseString] isEqualToString:@"jpg"] || [[model.fileType lowercaseString] isEqualToString:@"png"] || [[model.fileType lowercaseString] isEqualToString:@"gif"]) {
        
        [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.fileUrl] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
        [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.fileUrl] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
        
    }else{
        
        UIImage *image = [HQHelper fileTypeWithFileModel:model];
        [cell.titleImage setImage:image forState:UIControlStateNormal];
        [cell.titleImage setImage:image forState:UIControlStateHighlighted];
    }
    
    
    cell.topLabel.text = model.fileName;
    cell.bottomLabel.text = [NSString stringWithFormat:@"%@  %@  %@",model.creatorName,[HQHelper nsdateToTimeNowYear:[model.createTime longLongValue]], [HQHelper fileSizeForKB:[model.fileSize longLongValue]]];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
//    HQTFTwoLineCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    TFFileModel *model = self.files[indexPath.row];
//    if ([[model.fileType lowercaseString] isEqualToString:@"jpg"] || [[model.fileType lowercaseString] isEqualToString:@"png"] || [[model.fileType lowercaseString] isEqualToString:@"gif"]) {
//        
//        [self showImageWithFileModel:model withView:cell.titleImage];
//        
//    }else{
//        
//    }
    
    if ([[model.fileType lowercaseString] isEqualToString:@"jpg"] || [[model.fileType lowercaseString] isEqualToString:@"png"] || [[model.fileType lowercaseString] isEqualToString:@"gif"]) {// 查看图片
        
        
        [self.images removeAllObjects];
        
        for (TFFileModel *model in self.files) {
            
            if ([model.fileType integerValue] == 0) {
                
                [self.images addObject:model];
            }
        }
        
        [self didLookAtPhotoActionWithIndex:indexPath.row];
        
    }else if ([[model.fileType lowercaseString] isEqualToString:@"doc"] ||
              [[model.fileType lowercaseString] isEqualToString:@"docx"] ||
              [[model.fileType lowercaseString] isEqualToString:@"exl"] ||
              [[model.fileType lowercaseString] isEqualToString:@"exls"] ||
              [[model.fileType lowercaseString] isEqualToString:@"ppt"] ||
              [[model.fileType lowercaseString] isEqualToString:@"ai"] ||
              [[model.fileType lowercaseString] isEqualToString:@"cdr"] ||
              [[model.fileType lowercaseString] isEqualToString:@"dwg"] ||
              [[model.fileType lowercaseString] isEqualToString:@"ps"] ||
              [[model.fileType lowercaseString] isEqualToString:@"txt"] ||
              [[model.fileType lowercaseString] isEqualToString:@"zip"]){
        

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HQHelper cacheFileWithUrl:model.fileUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error == nil) {
                
                // 临时文件夹
                NSString *tmpPath = [FileManager dirTmp];
                // 创建文件路径
                NSString *filePath = [FileManager createFile:model.fileName forPath:tmpPath];
                // 将文件写入该路径
                BOOL pass = [data writeToFile:filePath atomically:YES];
                
                if (pass) {// 写入成功
                    
                    UIDocumentInteractionController *ctrl = [UIDocumentInteractionController  interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
                    ctrl.delegate = self;
                    [ctrl presentPreviewAnimated:YES];
                }
            }else{
                [MBProgressHUD showError:@"读取文件失败" toView:self.view];
            }
            
        }];
        
    }else if ([[model.fileType lowercaseString] isEqualToString:@"mp3"]){
        
        
        TFPlayVoiceController *play = [[TFPlayVoiceController alloc] init];
        play.file = model;
        [self.navigationController pushViewController:play animated:YES];
        
    }else{
        
        [MBProgressHUD showError:@"未知文件无法预览" toView:KeyWindow];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
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

- (void)showImageWithFileModel:(TFFileModel *)model withView:(UIButton *)view{
    NSMutableArray *items = @[].mutableCopy;
    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:view thumbImage:view.imageView.image imageUrl:[NSURL URLWithString:model.fileUrl]];
    [items addObject:item];
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:0];
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleDeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.showType = KSPhotoBrowserTypeShareDownload;
    browser.fileTitle = model.fileName;
    browser.bounces = NO;
    [browser showFromViewController:self];
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_projectFile) {
        
        NSMutableArray *arr = resp.body;
        NSMutableArray *files = [NSMutableArray array];
        
        if (self.type == ColumnTypeAll) {
            
            self.files = [NSMutableArray arrayWithArray:arr];
            
        }else if (self.type == ColumnTypeDoc){
            
            for (TFFileModel *model in arr) {
                
                if (![model.fileType isEqualToString:@"jpg"] &&
                    ![model.fileType isEqualToString:@"png"] &&
                    ![model.fileType isEqualToString:@"gif"] &&
                    ![model.fileType isEqualToString:@"mp3"]) {
                    
                    [files addObject:model];
                    
                }
                
            }
            self.files = [NSMutableArray arrayWithArray:files];
            
        }else if (self.type == ColumnTypeImage){
            
            for (TFFileModel *model in arr) {
                
                if ([model.fileType isEqualToString:@"jpg"] ||
                    [model.fileType isEqualToString:@"png"] ||
                    [model.fileType isEqualToString:@"gif"]) {
                    
                    [files addObject:model];

                }
            }
            self.files = [NSMutableArray arrayWithArray:files];
            
        }else{
            
            for (TFFileModel *model in arr) {
                
                if ([model.fileType isEqualToString:@"mp3"]) {
                    
                    [files addObject:model];
                    
                }
            }
            self.files = [NSMutableArray arrayWithArray:files];
            
        }
        if (self.files.count) {
            self.tableView.backgroundView = [UIView new];
        }else{
            self.tableView.backgroundView = self.noContentView;
        }
        
    
        [self.tableView reloadData];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    [self.tableView.mj_footer endRefreshing];
//    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}




#pragma mark - 无内容View
- (void)setupNoContentView{
    HQTFNoContentView *noContent = [HQTFNoContentView noContentView];
    noContent.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.height);
    
    CGRect rect = (CGRect){(SCREEN_WIDTH-Long(150))/2,(self.tableView.height - Long(150))/2 - 60,Long(150),Long(150)};
    
    
    switch (self.type) {
        case ColumnTypeAll:
        {
            [noContent setupImageViewRect:rect imgImage:@"图123" withTipWord:@"暂无数据"];
        }
            break;
        case ColumnTypeDoc:
        {
            [noContent setupImageViewRect:rect imgImage:@"图123" withTipWord:@"暂无文档"];
        }
            break;
        case ColumnTypeImage:
        {
            [noContent setupImageViewRect:rect imgImage:@"图123" withTipWord:@"暂无图片"];
        }
            break;
        case ColumnTypeAudio:
        {
            [noContent setupImageViewRect:rect imgImage:@"图123" withTipWord:@"暂无语音"];
        }
            break;
        default:
            break;
    }
    
    self.noContentView = noContent;
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
