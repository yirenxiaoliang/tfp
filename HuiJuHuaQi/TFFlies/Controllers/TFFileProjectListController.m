//
//  TFFileProjectListController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/16.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFileProjectListController.h"
#import "HQTFSearchHeader.h"
#import "TFFileBL.h"
#import "TFProjectFileMainModel.h"
#import "HQTFTwoLineCell.h"
#import "TFFilePathView.h"
#import "TFRefresh.h"
#import "HQTFNoContentView.h"
#import "TFProjectTaskBL.h"
#import "TFProjectFileSubModel.h"
#import "TFProjectFileListCell.h"
#import "TFProjectFileDetailController.h"
#import "TFFileDetailController.h"
#import "TFProjectFileNewController.h"
#import "TFProjectFileSearchController.h"
#import "ZYQAssetPickerController.h"

@interface TFFileProjectListController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,HQBLDelegate,HQTFTwoLineCellDelegate,TFFilePathViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;

@property (nonatomic, strong) HQTFNoContentView *noContentView;
//网络请求
@property (nonatomic, strong) TFFileBL *fileBL;
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;
//数据模型
@property (nonatomic, strong) TFProjectFileMainModel *mainModel;
@property (nonatomic, strong) TFProjectFileSubModel *subModel;
//分页数据
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;
//数据源
@property (nonatomic, strong) NSMutableArray *dataSources;

/** 记录选择的 */
@property (nonatomic, strong) TFProjectFileProListModel *listModel;

@end

@implementation TFFileProjectListController

- (NSMutableArray *)dataSources {
    
    if (!_dataSources) {
        
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
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
    
    [self setNavi];
    
    [self setupTableView];
    
    if (self.fileSeries == 1) {
        
        [self setupHeaderSearch];
    }
    
    if (self.fileSeries == 3) { //文件列表有搜索
        
        [self setupHeaderSearch];
        
        if ([self.library_type isEqualToString:@"1"]) {
            
            UINavigationItem *item1 = [self itemWithTarget:self action:@selector(moreAction) image:@"projectMenu" highlightImage:@"projectMenu"];
            UINavigationItem *item2 = [self itemWithTarget:self action:@selector(uploadAction) image:@"projectFileUpload" highlightImage:@"projectFileUpload"];
            
            NSMutableArray *arr = [NSMutableArray array];
            if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"29"] || [HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"30"]) {
                [arr addObject:item1];
            }
            if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"31"]) {
                [arr addObject:item2];
            }
            if (!self.isFileLibraySelect) {
                self.navigationItem.rightBarButtonItems = arr;
            }
        }
        
    }
    
    self.pageNum = 1;
    self.pageSize = 20;
    
    self.fileBL = [TFFileBL build];
    self.fileBL.delegate = self;
    
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"RefreshProjectFileList" object:nil];
    [self requestData];
}

- (void)setNavi {
    
    self.navigationItem.title = self.naviTitle;
}

//请求数据
- (void)requestData {
    
    if (self.fileSeries == 0) {
        // HQCMD_projectLibraryQueryProjectLibraryList
        [self.fileBL requestProjectLibraryQueryProjectLibraryListWithData:@(self.pageNum) pageSize:@(self.pageSize)];
    }
    else if (self.fileSeries == 1) {
        // HQCMD_projectLibraryQueryLibraryList
        [self.projectTaskBL requestProjectLibraryQueryLibraryListWithId:self.dataId pageNum:@(self.pageNum) pageSize:@(self.pageSize)];
        
        [self.projectTaskBL requestGetProjectRoleAndAuthWithProjectId:self.dataId employeeId:UM.userLoginInfo.employee.id];// 权限
    }
    else if (self.fileSeries == 2) {
        // HQCMD_projectLibraryQueryFileLibraryList
        [self.projectTaskBL requestprojectLibraryQueryFileLibraryListWithId:self.dataId type:self.library_type pageNum:@(self.pageNum) pageSize:@(self.pageSize)];
    }
    else if (self.fileSeries == 3) {
        // HQCMD_projectLibraryQueryTaskLibraryList
        [self.projectTaskBL requestprojectLibraryQueryTaskLibraryListWithId:self.dataId type:self.library_type pageNum:@(self.pageNum) pageSize:@(self.pageSize) keyWord:nil];
    }

}

#pragma mark - headerSearch
- (void)setupHeaderSearch{
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    self.header = header;
    self.tableView.tableHeaderView = header;
    header.delegate = self;
    
}

#pragma mark - HQTFSearchHeaderDelegate
-(void)searchHeaderClicked{
    
    TFProjectFileSearchController *search = [[TFProjectFileSearchController alloc] init];
    search.dataId = self.dataId;
    search.libraryType = self.library_type;
    search.projectId = self.projectId;
    if (self.fileSeries == 1) {
        search.style = 1;
    }
    search.isFileLibraySelect = self.isFileLibraySelect;
    search.parameterAction = ^(id parameter) {
        if (self.parameterAction) {
            [self.navigationController popViewControllerAnimated:NO];
            
            self.parameterAction(parameter);
        }
    };
    [self.navigationController pushViewController:search animated:YES];
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
    if (self.fileSeries == 3 || self.fileSeries == 1) {
        
        tableView.contentInset = UIEdgeInsetsMake(-20, 0, -20, 0);
    }
    
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    MJRefreshNormalHeader *header = [TFRefresh headerNormalRefreshWithBlock:^{
        
        self.pageNum = 1;
        [self requestData];
        
    }];
    tableView.mj_header = header;
    
    
    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        self.pageNum ++;
        [self requestData];
        
    }];
    tableView.mj_footer = footer;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.fileSeries == 3) { //文件
        
        TFProjectFileModel *model = self.dataSources[indexPath.row];
        TFProjectFileListCell *cell = [TFProjectFileListCell projectFileListCellWithTableView:tableView];
        cell.enterBtn.hidden = YES;
        [cell refreshProjectFileListCellWithModel:model projectId:self.dataId];
        
        cell.bottomLine.hidden = NO;
        
        return cell;
    }
    else { //文件夹
        
        TFProjectFileProListModel *model = self.dataSources[indexPath.row];
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        
        cell.titleImageWidth = 40;
        cell.topLabel.text = model.file_name;
        cell.topLabel.textColor = kUIColorFromRGB(0x4A4A4A);
        cell.delegate = self;
        cell.type = TwoLineCellTypeOne;
        cell.enterImage.tag = indexPath.row;
        cell.enterImage.userInteractionEnabled = YES;
        if ([model.library_type isEqualToString:@"0"]) {
            
            cell.enterImage.hidden = YES;
            [cell.titleImage setImage:IMG(@"默认文件夹") forState:UIControlStateNormal];
        }else{
            
            [cell.titleImage setImage:IMG(@"默认文件夹") forState:UIControlStateNormal];
            
            if (!self.isFileLibraySelect) {
                
                // 此处由权限控制
                if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"29"]
                    || [HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"30"]) {
                    
                    cell.enterImage.hidden = NO;
                    cell.enterImage.userInteractionEnabled = YES;
                    [cell.enterImage setImage:IMG(@"下啦") forState:UIControlStateNormal];
                }else{
                    cell.enterImage.hidden = YES;
                }
            }else{
                
                cell.enterImage.hidden = YES;
            }
        }
        cell.topLine.hidden = NO;
        cell.bottomLine.hidden = YES;
        
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.fileSeries == 3) { //文件
        
        TFFolderListModel *fileModel = [[TFFolderListModel alloc] init];
        TFProjectFileModel *projectFileModel = self.dataSources[indexPath.row];
        fileModel.employee_name = projectFileModel.employee_name;
        fileModel.create_time = projectFileModel.create_time;
        fileModel.siffix = projectFileModel.suffix;
        fileModel.size = projectFileModel.size;
        fileModel.name = projectFileModel.file_name;
        fileModel.url = projectFileModel.url;
        fileModel.id = projectFileModel.id;
        fileModel.siffix = [fileModel.siffix stringByReplacingOccurrencesOfString:@"." withString:@""];
        
//        fileModel.fileUrl = [NSString stringWithFormat:@"%@%@%@?id=%@&project_id=%@",kServerAddress,ServerAdress,@"/common/file/projectDownload",fileModel.id,self.projectId];
        fileModel.fileUrl = [NSString stringWithFormat:@"%@?id=%@&project_id=%@",@"/common/file/projectDownload",fileModel.id,self.projectId];
        
        if (self.isFileLibraySelect) {// 选文件发送中聊天
            
            if (self.parameterAction) {
                [self.navigationController popViewControllerAnimated:NO];
                
                self.parameterAction(fileModel);
                
                
            }
            
            return;
        }
        
        TFFileDetailController *detailVC = [[TFFileDetailController alloc] init];
        
        
        
        if ([fileModel.siffix isEqualToString:@"jpg"] || [fileModel.siffix isEqualToString:@"jpeg"] || [fileModel.siffix isEqualToString:@"png"] || [fileModel.siffix isEqualToString:@"gif"]) {
            
            detailVC.isImg = 1;
        }
        
        detailVC.basics = fileModel;
        detailVC.naviTitle = fileModel.name;
        detailVC.projectId = self.projectId;
        detailVC.whereFrom = 3;
        detailVC.privilege = self.privilege;
        detailVC.library_type = self.library_type;
        detailVC.refreshAction = ^{
            [self requestData];
        };
    
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else { //文件夹
        
        TFProjectFileProListModel *model = self.dataSources[indexPath.row];
        
        TFFileProjectListController * proListVC = [[TFFileProjectListController alloc] init];
        proListVC.isFileLibraySelect = self.isFileLibraySelect;
        if (self.fileSeries == 1) {// 直接跳过第二层，去第三层
            proListVC.fileSeries = self.fileSeries+2; //文件夹层级
        }else{
            proListVC.fileSeries = self.fileSeries+1; //文件夹层级
        }
        proListVC.naviTitle = model.file_name;
        proListVC.dataId = model.data_id; //项目id
        proListVC.library_type = model.library_type; //文件夹类型
        proListVC.projectId = self.projectId?:model.data_id;
        proListVC.id = model.id;
        proListVC.pathArr = [NSMutableArray arrayWithArray:self.pathArr]; //文件导航
        [proListVC.pathArr addObject:model.file_name];
        proListVC.privilege = self.privilege;
        proListVC.refreshAction = ^{
            [self requestData];
        };
        proListVC.parameterAction = ^(id parameter) {
        
            if (self.parameterAction) {
                [self.navigationController popViewControllerAnimated:NO];
                
                self.parameterAction(parameter);
            }
        };
        [self.navigationController pushViewController:proListVC animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.fileSeries == 3) {
        
        return 80;
    }
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    TFFilePathView *pathView = [[TFFilePathView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,35 ) titleArr:self.pathArr];
    
    pathView.delegate = self;
    
    return pathView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


#pragma mark - HQTFTwoLineCellDelegate
-(void)twoLineCell:(HQTFTwoLineCell *)cell didEnterImage:(UIButton *)enterBtn{
    
    self.listModel = self.dataSources[enterBtn.tag];
    
    NSMutableArray *arr = [NSMutableArray array];
    if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"29"]) {
        [arr addObject:@"编辑"];
    }
    if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"30"]) {
        [arr addObject:@"删除"];
    }
    
    if (arr.count == 0) {
        return;
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *str in arr) {
        [sheet addButtonWithTitle:str];
    }
    sheet.tag = 0x344;
    [sheet showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 0x990) {
        
        if (buttonIndex == 0) {
            
            [self openCamera];
        }
        else if (buttonIndex == 1) {
            
            [self openAlbum];
        }
    }
    
    if (actionSheet.tag == 0x344) {
        if (buttonIndex == 0) {// 取消
            
        }
        if (buttonIndex == 1) {
            if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"29"]) {// 编辑
                
                TFProjectFileNewController *newVC = [[TFProjectFileNewController alloc] init];
                newVC.projectId = self.dataId;
                newVC.folderId = self.listModel.id;
                newVC.folderName = self.listModel.file_name;
                newVC.isEdit = YES;
                newVC.action = ^(NSString *time) {
                    self.listModel.file_name = time;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:newVC animated:YES];
                
            }else if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"30"]){// 删除
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestProjectLibraryDelLibraryWithData:self.listModel.file_name fileId:self.listModel.id projectId:self.dataId];
            }
        }
        if (buttonIndex == 2) {
            if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"30"]){// 删除
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestProjectLibraryDelLibraryWithData:self.listModel.file_name fileId:self.listModel.id projectId:self.dataId];
            }
        }
    }
    
}



#pragma mark TFFilePathViewDelegate
- (void)selectFilePath:(NSInteger)index {
    
    if (index == 0) { //点第一个（项目文件）
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[TFFileProjectListController class]]) {
                
                TFFileProjectListController *menu =(TFFileProjectListController *)controller;
                
                if (menu.fileSeries == 0) {
                    
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
            }
        }
    }
    else {
        
        for (UIViewController *controller in self.navigationController.viewControllers) {

            if ([controller isKindOfClass:[TFFileProjectListController class]] ) {
                TFFileProjectListController *one =(TFFileProjectListController *)controller;
                
                if (one.fileSeries == index) {
                    
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
                
            }
            
        }
    }
 
}

#pragma mark - 加号
-(void)addFolder{
    
    TFProjectFileNewController *newFileVC = [[TFProjectFileNewController alloc] init];
    newFileVC.projectId = self.dataId;
    newFileVC.parentId = self.dataId;
    newFileVC.subType = @0;//创建文件夹
    [self.navigationController pushViewController:newFileVC animated:YES];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
    if (resp.cmdId == HQCMD_getProjectRoleAndAuth) {
        
        NSDictionary *dict = [resp.body valueForKey:@"priviledge"];
        self.privilege = [dict valueForKey:@"priviledge_ids"];
        
        if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"31"]) {// 添加文件夹
            
            if (!self.isFileLibraySelect) {
                self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addFolder) image:@"加号" highlightImage:@"加号"];
            }
        }
        
        [self.tableView reloadData];
        
        return;
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
    
    if (resp.cmdId == HQCMD_commonFileProjectUpload) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self requestData];
        
        return;
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (resp.cmdId == HQCMD_projectLibraryQueryTaskLibraryList) {
        
        //文件列表
        self.subModel = resp.body;
        
    }
    else {
        //前三级文件夹列表
        self.mainModel = resp.body;
    }
    
    if ([self.tableView.mj_footer isRefreshing]) {
        
        [self.tableView.mj_footer endRefreshing];
        
    }else {
        
        [self.tableView.mj_header endRefreshing];
        
        [self.dataSources removeAllObjects];
    }
    
    if (self.fileSeries == 3) {
        
        [self.dataSources addObjectsFromArray:self.subModel.dataList];
        
        if ([self.subModel.pageInfo.totalRows integerValue] == self.dataSources.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
    }
    else {
        
        [self.dataSources addObjectsFromArray:self.mainModel.dataList];
        
        if ([self.mainModel.pageInfo.totalRows integerValue] == self.dataSources.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
    }
    
    
    if (self.dataSources.count == 0) {
        
        self.tableView.backgroundView = self.noContentView;
        
    }else{
        self.tableView.backgroundView = [UIView new];
    }
    
    [self.tableView reloadData];
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
        newVC.folderId = self.id;
        newVC.isEdit = YES;
        
        newVC.action = ^(NSString *time) {
            
            self.navigationItem.title = time;
            [self.pathArr replaceObjectAtIndex:self.pathArr.count-1 withObject:time];
            [self.tableView reloadData];
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
    sheet.tag = 0x990;
    [sheet showInView:self.view];
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [self.projectTaskBL requestProjectLibraryDelLibraryWithData:self.naviTitle fileId:self.id projectId:self.projectId];
    }
}


#pragma mark - 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
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

#pragma mark - 打开相册
- (void)openAlbum {
    
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
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL projectFileWithImages:@[image] bean:@"project" fileId:self.dataId projectId:self.projectId];
    }
    
}









@end
