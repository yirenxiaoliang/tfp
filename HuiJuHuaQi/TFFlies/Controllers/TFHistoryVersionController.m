//
//  TFHistoryVersionController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFHistoryVersionController.h"

#import "TFHistoryVersionCell.h"

#import "TFFileBL.h"

#import "FDActionSheet.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"

@interface TFHistoryVersionController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TFFileBL *fileBL;

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation TFHistoryVersionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"历史版本";
    
    [self setupTableView];
    
    self.fileBL = [TFFileBL build];
    self.fileBL.delegate = self;
    
    [self.fileBL requestQueryVersionListWithData:self.fileId];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFFolderListModel *model = _datas[indexPath.row];
    
    TFHistoryVersionCell *cell = [TFHistoryVersionCell HistoryVersionCellWithTableView:tableView];
    
    model.versionNum = @(indexPath.row);
    model.versionCount = @(_datas.count);
    
    [cell refreshHistoryVersionDataWithModel:model];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.style == 1 || self.style == 2) {
        
        if ([self.download isEqualToNumber:@1]) { //有权限
            
            self.model = _datas[indexPath.row];
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
            
            [sheet show];
        }
    }
    else {
        
        self.model = _datas[indexPath.row];
        FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
        
        [sheet show];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8;
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

#pragma mark FDActionSheetDelegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {

    self.model.suffix = [self.model.suffix stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (buttonIndex == 0) {
        
        if ([self.model.suffix isEqualToString:@"jpg"] || [self.model.suffix isEqualToString:@"jpeg"] || [self.model.suffix isEqualToString:@"png"] ||[self.model.suffix isEqualToString:@"gif"]) {
            
//            NSString *string = [NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/download",self.fileId];
            NSString *string = [NSString stringWithFormat:@"%@%@?id=%@",kServerAddress,@"/library/file/download",self.fileId];
            NSString *fileName = [NSString stringWithFormat:@"%@.%@",[HQHelper stringForMD5WithString:string],self.model.suffix];
            [HQHelper cacheFileWithUrl:string fileName:fileName completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                [HQHelper saveCacheFileWithFileName:fileName data:data];
                
                UIImage *img = [UIImage imageWithData:data];
                
                [self loadImageFinished:img];
                
            } fileHandler:^(NSString *path) {
                
                UIImage *img = [UIImage imageWithContentsOfFile:path];
                
                [self loadImageFinished:img];
            }];
            
            
        }
        else {
            
//            NSString *string = [NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/downloadHistoryFile",self.model.id];
//            [HQHelper cacheFileWithUrl:string fileName:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//
//
//            } fileHandler:^(NSString *path) {
//
//            }];
        }
        

    }
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
    
    [MBProgressHUD showError:@"保存成功！" toView:self.view];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_queryVersionList) {
        
        _datas = resp.body;
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
