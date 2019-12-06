//
//  TFProjectFileTypeController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/18.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectFileTypeController.h"
#import "TFProjectFileListCell.h"
#import "FDActionSheet.h"
#import "ZYQAssetPickerController.h"
#import "TFProjectFileDetailController.h"
#import "TFFileDetailController.h"

#import "TFProjectTaskBL.h"
#import "TFProjectFileSubModel.h"
#import "TFRefresh.h"
#import "HQTFNoContentView.h"

#import "TFFolderListModel.h"
#import "TFProjectFileNewController.h"
#import "HQTFSearchHeader.h"
#import "TFProjectFileSearchController.h"

@interface TFProjectFileTypeController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,FDActionSheetDelegate,UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,HQTFSearchHeaderDelegate,UIActionSheetDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) TFProjectFileSubModel *subModel;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;

@end

@implementation TFProjectFileTypeController

- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
    }
    return _noContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    
    [self setupTableView];
    [self setupHeaderSearch];
    self.pageNum = 1;
    self.pageSize = 20;
    
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    
    [self requestListData];
}

- (void)setupNavi {
    
    self.navigationItem.title = self.naviTitle;
    
    if ([self.libraryType isEqualToString:@"1"]) {
        
        UINavigationItem *item1 = [self itemWithTarget:self action:@selector(moreAction) image:@"projectMenu" highlightImage:@"projectMenu"];
        UINavigationItem *item2 = [self itemWithTarget:self action:@selector(uploadAction) image:@"projectFileUpload" highlightImage:@"projectFileUpload"];
        
        NSMutableArray *arr = [NSMutableArray array];
        if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"29"] || [HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"30"]) {
            [arr addObject:item1];
        }
        if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"31"]) {
            [arr addObject:item2];
        }
        
        self.navigationItem.rightBarButtonItems = arr;
    }
    
}

#pragma mark 搜索
#pragma mark - headerSearch
- (void)setupHeaderSearch{
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    self.header = header;
    header.backgroundColor = WhiteColor;
    header.button.backgroundColor = BackGroudColor;
    header.delegate = self;
    [self.view addSubview:header];
    
}

#pragma mark - searchHeader Deleaget
-(void)searchHeaderClicked{
    
    TFProjectFileSearchController *search = [[TFProjectFileSearchController alloc] init];
    
    search.dataId = self.dataId;
    search.libraryType = self.libraryType;
    search.projectId = self.projectId;
    
    [self.navigationController pushViewController:search animated:YES];
}

- (void)requestListData {
    
    [self.projectTaskBL requestprojectLibraryQueryTaskLibraryListWithId:self.dataId type:self.libraryType pageNum:@(self.pageNum) pageSize:@(self.pageSize) keyWord:nil];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    MJRefreshGifHeader *header = [TFRefresh headerGifRefreshWithBlock:^{
        
        self.pageNum = 1;
        [self requestListData];
        
    }];
    tableView.mj_header = header;
    
    
    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        self.pageNum ++;
        [self requestListData];
        
    }];
    tableView.mj_footer = footer;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFProjectFileModel *model = self.dataArr[indexPath.row];
    TFProjectFileListCell *cell = [TFProjectFileListCell projectFileListCellWithTableView:tableView];
    
    [cell refreshProjectFileListCellWithModel:model projectId:self.projectId];
    
    cell.bottomLine.hidden = NO;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
//    TFProjectFileDetailController *detailVC = [[TFProjectFileDetailController alloc] init];
//    detailVC.fileModel = self.dataArr[indexPath.row];
//    detailVC.projectId = self.projectId;
//    [self.navigationController pushViewController:detailVC animated:YES];
    TFFileDetailController *detailVC = [[TFFileDetailController alloc] init];

    TFFolderListModel *fileModel = [[TFFolderListModel alloc] init];
    TFProjectFileModel *projectFileModel = self.dataArr[indexPath.row];
    fileModel.employee_name = projectFileModel.employee_name;
    fileModel.create_time = projectFileModel.create_time;
    fileModel.siffix = projectFileModel.suffix;
    fileModel.size = projectFileModel.size;
    fileModel.name = projectFileModel.file_name;
    fileModel.url = projectFileModel.url;
    fileModel.id = projectFileModel.id;
    
    fileModel.siffix = [fileModel.siffix stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ([fileModel.siffix isEqualToString:@"jpg"] || [fileModel.siffix isEqualToString:@"jpeg"] || [fileModel.siffix isEqualToString:@"png"] || [fileModel.siffix isEqualToString:@"gif"]) {
        
        detailVC.isImg = 1;
    }
    
    detailVC.basics = fileModel;
    detailVC.naviTitle = fileModel.name;
    detailVC.projectId = self.projectId;
    detailVC.whereFrom = 3;
    detailVC.privilege = self.privilege;
    detailVC.library_type = self.libraryType;
    detailVC.refreshAction = ^{
        [self requestListData];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
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

#pragma mark 导航点击事件
- (void)moreAction {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更多操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 2.1 创建按钮
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        TFProjectFileNewController *newVC = [[TFProjectFileNewController alloc] init];
        newVC.projectId = self.projectId;
        newVC.parentId = self.projectId;
        newVC.folderName = self.naviTitle;
        newVC.subType = @1;
        newVC.folderId = self.folderId;
        newVC.isEdit = YES;
        
        newVC.action = ^(NSString *time) {
            
            self.navigationItem.title = time;
        };
        
        [self.navigationController pushViewController:newVC animated:YES];
        
    }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert show];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    // 2.2 添加按钮
    if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"29"]) {
        [alertController addAction:editAction];
    }
    if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"30"]) {
        [alertController addAction:deleteAction];
    }
    [alertController addAction:cancelAction];
    
    // 3.显示警报控制器
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)uploadAction {
    
//    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照上传",@"手机相册", nil];
//
//    [sheet show];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"手机相册", nil];
    [sheet showInView:self.view];
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [self.projectTaskBL requestProjectLibraryDelLibraryWithData:self.naviTitle fileId:self.folderId projectId:self.projectId];
    }
}
#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//#pragma mark FDActionSheetDelegate
//- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        
        [self openCamera];
    }
    else if (buttonIndex == 1) {
        
        [self openAlbum];
    }
}

#pragma mark - 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;

        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 拍照上传
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.projectTaskBL projectFileWithImages:@[image] bean:@"project" fileId:self.dataId projectId:self.projectId];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 选择照片处理 */
-(void)handleImages:(NSArray *)arr{
    
    if (arr.count == 0) {
        return;
    }
    // 选择照片上传
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.projectTaskBL projectFileWithImages:arr bean:@"project" fileId:self.dataId projectId:self.projectId];
}


#pragma mark - 打开相册
- (void)openAlbum{
    
    kWEAKSELF
    ZLPhotoActionSheet *sheet =[HQHelper takeHPhotoWithBlock:^(NSArray<UIImage *> *images) {
        [weakSelf handleImages:images];
    }];
    //图片数量
    sheet.configuration.maxSelectCount = 9;
    //如果调用的方法没有传sender，则该属性必须提前赋值
    sheet.sender = self;
    [sheet showPhotoLibrary];
    return;
    
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
        
        // 选择照片上传
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL projectFileWithImages:@[image] bean:@"project" fileId:self.dataId projectId:self.projectId];
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_projectLibraryQueryTaskLibraryList) {
        
        self.subModel = resp.body;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.dataArr removeAllObjects];
        }
        
        [self.dataArr addObjectsFromArray:self.subModel.dataList];
        
        if ([self.subModel.pageInfo.totalRows integerValue] == self.dataArr.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.dataArr.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
            
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_projectLibraryDelLibrary) {
        
        [MBProgressHUD showError:@"删除成功" toView:self.view];
        
        if (self.refresh) {
            
            self.refresh();
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    
    if (resp.cmdId == HQCMD_commonFileProjectUpload) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self requestListData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
