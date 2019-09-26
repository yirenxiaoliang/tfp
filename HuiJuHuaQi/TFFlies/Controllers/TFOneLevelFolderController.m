//
//  TFOneLevelFolderController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/26.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFOneLevelFolderController.h"
#import "TFAddFolderController.h"
#import "TFManageFolderController.h"
#import "TFFileMenuController.h"
#import "TFFileAuthController.h"
#import "TFManagerSetController.h"
#import "TFMoveFileController.h"
#import "TFFileDetailController.h"
#import "ZYQAssetPickerController.h"
#import "TFSelectChatPersonController.h"
#import "HQTFSearchHeader.h"
#import "TFFileSearchController.h"

#import "HQTFTwoLineCell.h"
#import "FDActionSheet.h"
#import "AlertView.h"
#import "TFFilePathView.h"
#import "TFHistoryVersionCell.h"
#import "HQTFNoContentView.h"

#import "TFFolderListModel.h"
#import "TFMainListModel.h"

#import "TFFileBL.h"
#import "TFRefresh.h"
#import "TFCachePlistManager.h"

@interface TFOneLevelFolderController ()<UITableViewDelegate,UITableViewDataSource,HQTFTwoLineCellDelegate,TFFilePathViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,HQBLDelegate,HQTFSearchHeaderDelegate,TFHistoryVersionCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *titleArr;

@property (nonatomic, strong) TFFileBL *fileBL;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) TFFolderListModel *listModel;

@property (nonatomic, strong) TFMainListModel *mainModel;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *header;

/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;

@end

@implementation TFOneLevelFolderController

- (NSMutableArray *)titleArr {
    
    if (!_titleArr) {
        
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}

- (NSMutableArray *)pathArr {

    if (!_pathArr) {
        
        _pathArr = [NSMutableArray array];
    }
    return _pathArr;
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
    
    self.pageNum = 1;
    self.pageSize = 10;
    
    self.mainModel = [[TFMainListModel alloc] init];
    _listModel = [[TFFolderListModel alloc] init];
    
    self.fileBL = [TFFileBL build];
    self.fileBL.delegate = self;
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:MoveFileSuccessNotification object:nil];
    
    if (self.isSearch) { //搜索
        
        [self.fileBL requestGetBlurResultParentInfoWithData:self.presentId];
    }
    
    [self setupTableView];
    
    if (self.style == 2) {
        
        if (self.fileSeries > 1) {
            
            [self setupHeaderSearch];
        }
    }
    else {
        
        [self setupHeaderSearch];
    }
    
    if (self.style == 6) {
        
        
    }
    else {
        
        [self requestListData];
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)requestListData {

    
    if (self.fileSeries > 0) { //子级
        
        if (self.style == 4 || self.style == 5) { //我共享的和与我共享
            // HQCMD_queryCompanyPartList
            [self.fileBL requestQueryCompanyPartListWithData:@(self.shareStyle) parentId:self.parentId pageNum:@(self.pageNum) pageSize:@(self.pageSize) sign:@2];
        }
        else {
        
            if (self.style == 2) { //应用文件
                
                if (self.fileSeries == 1) { //应用文件夹一级
                    // HQCMD_queryModuleFileList
                    [self.fileBL requestQueryModuleFileListWithData:@(self.style) pageNum:@(self.pageNum) pageSize:@(self.pageSize) fid:self.modelId];
                }
                else { //应用文件
                    // HQCMD_queryModulePartFileList
                    [self.fileBL requestQueryModulePartFileListWithData:@(self.style) pageNum:@(self.pageNum) pageSize:@(self.pageSize) fid:self.modelId];
                }
                
            }
            else { //公司文件／个人文件
                // HQCMD_queryCompanyPartList
                [self.fileBL requestQueryCompanyPartListWithData:@(self.style) parentId:self.parentId pageNum:@(self.pageNum) pageSize:@(self.pageSize) sign:@2];
            }
            
        }
        
    }
    else { //根目录列表
    
        if (self.style == 2) { //应用文件夹根目录列表
            // HQCMD_queryAppFileList
            [self.fileBL requestQueryAppFileListWithData:@(self.style) pageNum:@(self.pageNum) pageSize:@(self.pageSize)];
        }
        else {
            // HQCMD_queryCompanyList
            [self.fileBL requestQueryCompanyListWithData:@(self.style) pageNum:@(self.pageNum) pageSize:@(self.pageSize) sign:@2];
            if (self.style == 1) {// 获取文件库管理员
                [self.fileBL requestFileAdministrator];
            }
        }
        
    }
    if (self.pageNum == 1) {
        
        NSArray *dicts = [TFCachePlistManager getFileLevelWithStyle:self.style levelId:self.parentId];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in dicts) {
            TFFolderListModel *mo = [[TFFolderListModel alloc] initWithDictionary:dict error:nil];
            if (mo) {
                [arr addObject:mo];
            }
        }
        [self.titleArr removeAllObjects];
        [self.titleArr addObjectsFromArray:arr];
        [self.tableView reloadData];
    }
}

- (void)setNavi {

    self.navigationItem.title = self.naviTitle;
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(returnClick) image:@"返回" text:@"返回" textColor:GreenColor];

    if (!self.isFileLibraySelect) {
        
        if (self.style == 1) { //公司文件
            
            if (self.fileSeries>0) { //子级
                
                if (self.isManager == 0 && self.canUpload == 0) { //如果既不是管理员，也没有上传权限
                    
                    self.navigationItem.rightBarButtonItem = [self itemWithTarget:nil action:nil text:nil];
                }
                else {
                    
                    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addFolder) image:@"加号" highlightImage:@"加号"];
                }
            }
            else {
                // 需求更改，根目录需要文件库管理员才能添加文件夹 20181212
//                self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addFolder) image:@"加号" highlightImage:@"加号"];
            }
            
        }
        else if (self.style == 2) { //应用文件
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:nil action:nil text:nil];
            
        }
        else if (self.style == 3) { //个人文件
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addFolder) image:@"加号" highlightImage:@"加号"];
            
        }

    }
    

}

#pragma mark - headerSearch
- (void)setupHeaderSearch{
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    self.header = header;
    self.tableView.tableHeaderView = header;
    header.delegate = self;
    
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    self.headerSearch = headerSearch;
    headerSearch.type = SearchHeaderTypeMove;
    headerSearch.delegate = self;
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    if (self.style == 2) {
        
        if (self.fileSeries > 1) {
            
            tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        }
    }
    else {
        
        tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    MJRefreshNormalHeader *header = [TFRefresh headerNormalRefreshWithBlock:^{
        
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
    
    return self.titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFFolderListModel *model = self.titleArr[indexPath.row];
    
    if ([model.sign isEqualToString:@"0"]) { //文件夹
    
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        
        cell.titleImage.backgroundColor = [HQHelper colorWithHexString:model.color];
        cell.titleImageWidth = 40;
        cell.topLabel.text = model.name;
        cell.topLabel.textColor = LightBlackTextColor;
        [cell.enterImage setImage:IMG(@"下啦") forState:UIControlStateNormal];
        cell.delegate = self;
        cell.type = TwoLineCellTypeOne;
        cell.enterImage.tag = 0x123+indexPath.row;
        cell.enterImage.userInteractionEnabled = YES;
        [cell.titleImage setImage:IMG(@"文件夹") forState:UIControlStateNormal];
        cell.bottomLine.hidden = YES;
        cell.topLine.hidden = NO;
        cell.enterImgTrailW.constant = 0;
    
        if (self.style == 1) { //公司文件
            
            if ([model.type isEqualToString:@"1"]) { //私有
                
                [cell.titleImage setImage:IMG(@"新建文件夹") forState:UIControlStateNormal];
                
                if ([model.is_manage isEqualToNumber:@1]) { //管理员
                    
                    cell.enterImage.hidden = NO;
                }
                else { //非管理员
                    
                    cell.enterImage.hidden = YES;
                }
                
                
            }
            else { //公开
                
                
                if ([model.is_manage isEqualToNumber:@1]) { //管理员
                    
                    cell.enterImage.hidden = NO;
                }
                else { //非管理员
                    
                    cell.enterImage.hidden = YES;
                }
            }

        }
        else if (self.style == 2) { //应用文件
        
            cell.enterImage.hidden = YES;
        }
        else if (self.style == 3) { //个人文件
        
            cell.enterImage.hidden = NO;
        }
        else if (self.style == 4) { //我共享的
            
            if (self.fileSeries == 0) {
                
                cell.enterImage.hidden = NO;
            }
            else {
            
                cell.enterImage.hidden = YES;
            }
            
        }
        else if (self.style == 5) { //与我共享
            
            if (self.fileSeries == 0) {
                
                cell.enterImage.hidden = NO;
            }
            else {
                
                
                cell.enterImage.hidden = YES;
            }
        }
        
        
        if (self.fileSeries > 0) { //线
            
            cell.topLine.hidden = NO;
        }
        else {
            
            if (indexPath.row == 0) {
                
                cell.topLine.hidden = YES;
            }else{
                cell.topLine.hidden = NO;
            }
        }
        
        if (self.isFileLibraySelect) {  //文件库选进来隐藏操作按钮
            
            cell.enterImage.hidden = YES;
        }
        return cell;
    
    }
    else { //文件

        TFHistoryVersionCell *cell = [TFHistoryVersionCell HistoryVersionCellWithTableView:tableView];
        
        cell.versionLab.hidden = YES;
        cell.delegate = self;
        cell.index = indexPath.row;
        cell.topLine.hidden = NO;
        
        model.style = @(self.style);
        
        [cell refreshFileListDataWithModel:model];
        
        if (self.style == 4 || self.style == 5) { //共享和与我共享
            
            if (self.fileSeries == 0) {
                
                cell.moreImgV.hidden = NO;
            }
            else {
            
                cell.moreImgV.hidden = YES;
            }
            
        }
        
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFFolderListModel *model = self.titleArr[indexPath.row];
    
    if ([model.sign isEqualToString:@"0"]) { //文件夹
        
//        NSInteger stylemenu = 0;
//        if (self.style == 4 || self.style == 5) { //我共享的／与我共享的传table_id
//            
//            stylemenu = [model.table_id integerValue];
//        }
//        else {
//        
//            stylemenu = self.style;
//        }
        
        
        TFOneLevelFolderController *oneLevel = [[TFOneLevelFolderController alloc] init];
        
        oneLevel.fileSeries = self.fileSeries + 1;
        oneLevel.naviTitle = model.name;
        oneLevel.parentId = model.id;
        oneLevel.modelId = model.model_id; //应用文件用模块id
        oneLevel.style = self.style;
        oneLevel.shareStyle = [model.table_id integerValue]; //我共享的／与我共享的传table_id
        oneLevel.parentUrl = model.url;
        oneLevel.shareFileId = model.file_id;
        
        oneLevel.isManager = [model.is_manage integerValue]; //是不是当前文件夹管理员
        oneLevel.canUpload = [model.upload integerValue]?:self.canUpload; //当前文件夹下能不能上传
        
        oneLevel.pathArr = [NSMutableArray arrayWithArray:self.pathArr];
        [oneLevel.pathArr addObject:model.name];
        oneLevel.isFileLibraySelect = self.isFileLibraySelect;
        
        oneLevel.refreshAction = ^(id parameter) {
            
            if (self.refreshAction) {
                
                 [self.navigationController popViewControllerAnimated:NO];
                
                self.refreshAction(parameter);
                
               
            }
        };
        
        [self.navigationController pushViewController:oneLevel animated:YES];
    }
    else {
    
        if (self.isFileLibraySelect) {
            
//            model.fileUrl = [NSString stringWithFormat:@"%@%@%@?id=%@",kServerAddress,ServerAdress,@"/library/file/download",model.id];
            
            
            if ([model.siffix isEqualToString:@"jpg"] ||[model.siffix isEqualToString:@"jpeg"] ||[model.siffix isEqualToString:@"png"] ||[model.siffix isEqualToString:@"gif"] ) {
                model.fileUrl = [NSString stringWithFormat:@"%@?id=%@&url=%@&width=480&type=1",@"/library/file/downloadCompressedPicture",model.id,model.url];
            }else{
                model.fileUrl = [NSString stringWithFormat:@"%@?id=%@",@"/library/file/download",model.id];
            }
            if (self.refreshAction) {
                
                [self.navigationController popViewControllerAnimated:NO];
                
                self.refreshAction(model);
                
            }
            
        }
        else {
        
            TFFileDetailController *fileDetail = [[TFFileDetailController alloc] init];
            
            fileDetail.fileId = model.id;
            fileDetail.style = self.style;
            fileDetail.naviTitle = model.name;
            fileDetail.pathArr = [NSMutableArray arrayWithArray:self.pathArr];
            [fileDetail.pathArr addObject:model.name];
            
            if ([model.siffix isEqualToString:@"jpg"] ||[model.siffix isEqualToString:@"jpeg"] ||[model.siffix isEqualToString:@"png"] ||[model.siffix isEqualToString:@"gif"] ) {
                
                fileDetail.isImg = 1;
            }
            
            fileDetail.refreshAction = ^{
                
                self.pageNum = 1;
                [self requestListData];
            };
            
            [self.navigationController pushViewController:fileDetail animated:YES];
        }
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.fileSeries == 0) {
        
        return 0;
    }
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] init];
    
//    UILabel *lab = [UILabel initCustom:CGRectMake(0, 0, SCREEN_WIDTH-30, 0) title:@"   公司文件" titleColor:kUIColorFromRGB(0x20BF9A) titleFont:14 bgColor:WhiteColor];
//    
//    lab.textAlignment = NSTextAlignmentLeft;
//    
//    return lab;
//    [view addSubview:lab];
//    
//    view.backgroundColor = kUIColorFromRGB(0xFFFFFF);
//    return view;
    TFFilePathView *pathView = [[TFFilePathView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,35 ) titleArr:self.pathArr];
    
    pathView.delegate = self;
    
    return pathView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark 通知方法
- (void)refreshData:(NSNotification *)noti {

    self.pageNum = 1;
    [self requestListData];
    
    [self.tableView reloadData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark TFHistoryVersionCellDelegate
- (void)moreOperationClick:(NSInteger)index {

    NSString *operationStr = @"";
    
    _listModel = self.titleArr[index];
    
    if (self.style == 4) {
    
        operationStr = @"取消共享";
        
    }
    else if (self.style == 5) {
    
        operationStr = @"退出共享";
    }
    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:operationStr, nil];
    
    sheet.tag = 104;
    
    [sheet show];
}

#pragma mark TFFilePathViewDelegate
- (void)selectFilePath:(NSInteger)index {

    if (index == 0) {
        

        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            
            if ([controller isKindOfClass:[TFOneLevelFolderController class]]) {
                
                TFOneLevelFolderController *menu =(TFOneLevelFolderController *)controller;
                
                if (menu.fileSeries == 0) {
                    
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
            }
        }
    }
    else {
    
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            if (self.isSearch) {
                
                if ([controller isKindOfClass:[TFOneLevelFolderController class]] ) {
                    TFOneLevelFolderController *one =(TFOneLevelFolderController *)controller;
                    
                    if (one.fileSeries == index) {
                        
                        [self.navigationController popToViewController:controller animated:YES];
                        break;
                    }
                    
                }

            }
            else {
            
                if ([controller isKindOfClass:[TFOneLevelFolderController class]] ) {
                    TFOneLevelFolderController *one =(TFOneLevelFolderController *)controller;
                    
                    if (one.fileSeries == index) {
                        
                        [self.navigationController popToViewController:controller animated:YES];
                        break;
                    }
                    
                }
            }

        }
    }
    
    
//    TFOneLevelFolderController *controller = self.navigationController.viewControllers[index+1];
//    
//    [self.navigationController popToViewController:controller animated:YES];

    
}

#pragma mark - searchHeader Delegate
-(void)searchHeaderClicked{
    
    TFFileSearchController *search = [[TFFileSearchController alloc] init];
    
    search.style = self.style;
    if (self.style == 2) {
        
        search.fileId = self.modelId;
    }
    else {
        
        search.fileId = self.shareFileId;
    }
    
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark HQTFTwoLineCellDelegate
- (void)twoLineCell:(HQTFTwoLineCell *)cell didEnterImage:(UIButton *)enterBtn {

    NSInteger index = enterBtn.tag - 0x123;
    
    _listModel = self.titleArr[index];
    
    if (self.fileSeries == 0) {
        
        NSArray *array = [NSArray array];
        
        if (self.style == 1) {
            
            array = @[@"成员管理",@"管理文件夹",@"删除文件夹"];
        }
        else if (self.style == 3) {
        
            array = @[@"管理文件夹",@"移动",@"共享",@"删除"];
        }
        else if (self.style == 4) {
        
            array = @[@"取消共享"];
        }
        else if (self.style == 5) {
        
            array = @[@"退出共享"];
        }
        
        FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" titles:array];
        
        sheet.tag = 101;
        [sheet show];
        
    }
    else {
    
        FDActionSheet *sheet;
        if (self.style == 1) {
            
            sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"管理员设置",@"管理文件夹",@"移动",@"共享",@"删除", nil];
        }
        else if (self.style == 3) {
        
            sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"管理文件夹",@"移动",@"共享",@"删除", nil];
        }
        
        
        sheet.tag = 102;
        [sheet show];
    }
    
}

#pragma mark 导航栏点击事件
- (void)addFolder {

    FDActionSheet *sheet;
    
    if (self.style == 1) { //公司文件
        
        if (self.fileSeries == 0) {
            
            TFAddFolderController *addFolder = [[TFAddFolderController alloc] init];
            
            addFolder.fileSeries = self.fileSeries;
            addFolder.style = self.style;
            addFolder.refreshAction = ^{
                
                self.pageNum = 1;
                
                [self requestListData];
            };
            
            [self.navigationController pushViewController:addFolder animated:YES];
        }
        else {
            
            if (self.isManager == 1) { //是管理员
                
                sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相册中上传",@"新增文件夹", nil];
            }
            else {
            
                if (self.canUpload == 1) {
                    
                    sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相册中上传", nil];
                }

            }

        }

    }
    else if (self.style == 3) { //个人文件
    
        sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相册中上传",@"新增文件夹", nil];
        
    }
    
    sheet.tag = 103;
    
    [sheet show];
}

- (void)editAuth {

    TFFileAuthController *fileAuth = [[TFFileAuthController alloc] init];
    
    fileAuth.naviTitle = self.naviTitle;
    fileAuth.style = self.style;
    
    [self.navigationController pushViewController:fileAuth animated:YES];
}

- (void)returnClick {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark FDActionSheetDelegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {

    if (sheet.tag == 101) {
        
        if (self.style == 1) {
            
            if (buttonIndex == 0) {
                
                TFFileAuthController *fileAuth = [[TFFileAuthController alloc] init];
                
                fileAuth.naviTitle = _listModel.name;
                fileAuth.style = self.style;
                fileAuth.folderId = _listModel.id;
                fileAuth.fileSeries = self.fileSeries;
                
                [self.navigationController pushViewController:fileAuth animated:YES];
            }
            else if (buttonIndex == 1) {
                
                TFManageFolderController *manageFolder = [[TFManageFolderController alloc] init];
                
                manageFolder.folderId = _listModel.id;
                manageFolder.labColor = _listModel.color;
                manageFolder.folderName = _listModel.name;
                manageFolder.refreshAction = ^{
                    
                    self.pageNum = 1;
                    [self requestListData];
                };
                
                [self.navigationController pushViewController:manageFolder animated:YES];
            }
            else if (buttonIndex == 2) { //删除
                
                [AlertView showAlertView:@"提示" msg:@"删除后此文件夹中的文件与子文件夹将会一并删除且不可恢复。你确定要删除吗？" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
                    
                } onRightTouched:^{
                    
                    [self.fileBL requestDelFileLibraryWithData:_listModel.id];
                }];
            }

        }
        else if (self.style == 3) {
        
            switch (buttonIndex) {
                case 0: //管理文件夹
                {
                    
                    TFManageFolderController *manageFolder = [[TFManageFolderController alloc] init];
                    
                    manageFolder.folderId = _listModel.id;
                    manageFolder.labColor = _listModel.color;
                    manageFolder.folderName = _listModel.name;
                    manageFolder.refreshAction = ^{
                        
                        self.pageNum = 1;
                        [self requestListData];
                    };
                    
                    [self.navigationController pushViewController:manageFolder animated:YES];
                }
                    break;
                case 1: //移动
                {
                    
                    TFMoveFileController *moveFile = [[TFMoveFileController alloc] init];
                    
                    moveFile.pathArr = [NSMutableArray array];
                    [moveFile.pathArr addObject:self.pathArr[0]];
                    
                    moveFile.folderId = _listModel.id;
                    moveFile.folderSeries = 0; //不管哪一级进去都先获取第一级文件夹
                    moveFile.style = self.style;
                    moveFile.type = 0;
                    
                    [self.navigationController pushViewController:moveFile animated:YES];
                }
                    break;
                case 2: //共享
                {
                    
                    TFSelectChatPersonController *select = [[TFSelectChatPersonController alloc] init];
                    
                    select.type = 1;
                    
                    select.haveGroup = NO;
                    
                    select.actionParameter = ^(id parameter) {
                        
                        NSArray *peoples = parameter;
                        
                        NSString *managerStr = @"";
                        
                        for (HQEmployModel *model in peoples) {
                            
                            managerStr = [managerStr stringByAppendingFormat:@",%@", model.id];
                        }
                        
                        managerStr = [managerStr substringFromIndex:1];
                        
                        [self.fileBL requestShareFileLibarayWithData:_listModel.id shareBy:managerStr];
                        
                    };
                    
                    [self.navigationController pushViewController:select animated:YES];
                }
                    break;
                case 3: //删除
                {
                    
                    [AlertView showAlertView:@"提示" msg:@"删除后此文件夹中的文件与子文件夹将会一并删除且不可恢复。你确定要删除吗？" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
                        
                    } onRightTouched:^{
                        
                        [self.fileBL requestDelFileLibraryWithData:_listModel.id];
                    }];
                }
                    break;

                    
                default:
                    break;
            }
        }
        else if (self.style == 4) {
        
            [self.fileBL requestCancelShareWithData:_listModel.file_id];
        }
        else if (self.style == 5) {
        
            [self.fileBL requestQuitShareWithData:_listModel.file_id];
        }
        
    }
    else if (sheet.tag == 102) {
    
    
        NSInteger index = 0;
        if (self.style == 1) {
            
            index = buttonIndex;
        }
        else if (self.style == 3) {
        
            index = buttonIndex+1;
        }
        
        switch (index) {
            case 0: //管理员设置
            {
            
                TFManagerSetController *managerSet = [[TFManagerSetController alloc] init];
                
                managerSet.parentId = _listModel.id;
                managerSet.fileSeries = self.fileSeries;
                managerSet.style = self.style;
                
                [self.navigationController pushViewController:managerSet animated:YES];
            }
                break;
            case 1: //管理文件夹
            {
                
                TFManageFolderController *manageFolder = [[TFManageFolderController alloc] init];
                
                manageFolder.folderId = _listModel.id;
                manageFolder.labColor = _listModel.color;
                manageFolder.folderName = _listModel.name;
                manageFolder.refreshAction = ^{
                    
                    self.pageNum = 1;
                    [self requestListData];
                };
                
                [self.navigationController pushViewController:manageFolder animated:YES];
            }
                break;
            case 2: //移动
            {
                
                TFMoveFileController *moveFile = [[TFMoveFileController alloc] init];
                
                moveFile.pathArr = [NSMutableArray array];
                [moveFile.pathArr addObject:self.pathArr[0]];
                
                moveFile.folderId = _listModel.id;
                moveFile.folderSeries = 0; //不管哪一级进去都先获取第一级文件夹
                moveFile.style = self.style;
                moveFile.type = 0;
                
                [self.navigationController pushViewController:moveFile animated:YES];
            }
                break;
            case 3: //共享
            {
                
                TFSelectChatPersonController *select = [[TFSelectChatPersonController alloc] init];
                
                select.type = 1;
                
                select.haveGroup = NO;
                
                select.actionParameter = ^(id parameter) {
                  
                    NSArray *peoples = parameter;
                    
                    NSString *managerStr = @"";
                    
                    for (HQEmployModel *model in peoples) {
                        
                        managerStr = [managerStr stringByAppendingFormat:@",%@", model.id];
                    }
                    
                    managerStr = [managerStr substringFromIndex:1];
                    
                    [self.fileBL requestShareFileLibarayWithData:_listModel.id shareBy:managerStr];
                    
                };
                
                [self.navigationController pushViewController:select animated:YES];
            }
                break;
            case 4: //删除
            {
                
                [AlertView showAlertView:@"提示" msg:@"删除后此文件夹中的文件与子文件夹将会一并删除且不可恢复。你确定要删除吗？" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
                    
                } onRightTouched:^{
                    
                    [self.fileBL requestDelFileLibraryWithData:_listModel.id];
                }];
            }
                break;
                
            default:
                break;
        }
    }
    else if (sheet.tag == 103) {
    
        if (buttonIndex == 0) {
            
            [self openAlbum];
        }
        else if (buttonIndex == 1) {
            
            TFAddFolderController *addFolder = [[TFAddFolderController alloc] init];
            
            addFolder.fileSeries = self.fileSeries;
            addFolder.style = self.style;
            addFolder.parentId = [self.parentId stringValue];
            addFolder.refreshAction = ^{
                
                self.pageNum = 1;
                [self requestListData];
            };
            
            [self.navigationController pushViewController:addFolder animated:YES];
        }
    }
    else if (sheet.tag == 104) {
    
        if (self.style == 4) {
            
            [self.fileBL requestCancelShareWithData:_listModel.file_id];
        }
        else if (self.style == 5) {
        
           [self.fileBL requestQuitShareWithData:_listModel.file_id];
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
        UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        // 添加图片
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        NSString *fileName = [representation filename];
        HQLog(@"fileName : %@",fileName);
        
        // 选择照片上传
        
    
//        NSDictionary *dic = @{
//                              @"id":[self.parentId stringValue],
//                              @"url":self.parentUrl,
//                              @"style":@(self.style),
//                              };
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.fileBL requestFileLibraryUploadWithData:self.parentId folderUrl:self.parentUrl type:@(self.style) datas:@[image]];
        
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_queryCompanyList || resp.cmdId == HQCMD_queryCompanyPartList || resp.cmdId == HQCMD_queryAppFileList || resp.cmdId == HQCMD_queryModuleFileList|| resp.cmdId == HQCMD_queryModulePartFileList) {
        
        
        self.mainModel = resp.body;
        
//        _titleArr = self.mainModel.dataList;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.titleArr removeAllObjects];
        }
        
        [self.titleArr addObjectsFromArray:self.mainModel.dataList];
        
        if ([self.mainModel.pageInfo.totalRows integerValue] == self.titleArr.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.titleArr.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
            
        }else{
            self.tableView.backgroundView = [UIView new];
        }

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.tableView reloadData];
        
            
        NSMutableArray *arr = [NSMutableArray array];
        for (TFFolderListModel *mo in self.mainModel.dataList) {
            NSString *str = [mo toJSONString];
            [arr addObject:str];
        }
        [TFCachePlistManager saveFileLevelWithStyle:self.style levelId:self.parentId datas:arr];
            
        
    }
    
    
    if (resp.cmdId == HQCMD_getBlurResultParentInfo) {
        
        if (self.style == 1) {
            
            [self.pathArr addObject:@"公司文件"];
        }
        else if (self.style == 2) {
            
            [self.pathArr addObject:@"应用文件"];
        }
        else if (self.style == 3) {
            
            [self.pathArr addObject:@"个人文件"];
        }
        else if (self.style == 4) {
            
            [self.pathArr addObject:@"我共享的"];
        }
        else if (self.style == 5) {
            
            [self.pathArr addObject:@"与我共享"];
        }
        
        for (TFFolderListModel *model in resp.body) {
            
            [self.pathArr addObject:model.name];
            
            
        }
        
        self.fileSeries = self.pathArr.count;
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_delFileLibrary) {
        
        self.pageNum = 1;
        
        [self requestListData];
        
        [self.tableView reloadData];
        
        [MBProgressHUD showError:@"删除成功！" toView:self.view];
    }
    
    if (resp.cmdId == HQCMD_shareFileLibaray) {
        
        [MBProgressHUD showError:@"共享成功！" toView:self.view];
    }
    if (resp.cmdId == HQCMD_cancelShare) {
        
        [MBProgressHUD showError:@"取消共享成功！" toView:self.view];
        
        self.pageNum = 1;
        [self requestListData];
    }
    if (resp.cmdId == HQCMD_quitShare) {
        
        [MBProgressHUD showError:@"退出共享成功！" toView:self.view];
        
        self.pageNum = 1;
        [self requestListData];
    }
    
    if (resp.cmdId == HQCMD_fileLibraryUpload) { //文件上传
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.pageNum = 1;
        [self requestListData];
        
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_fileAdministrator) {
        
        NSDictionary *dict = resp.body;
        NSNumber *admin = [dict valueForKey:@"admin"];
        
        if ([admin.description isEqualToString:@"1"]) {
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addFolder) image:@"加号" highlightImage:@"加号"];
        }else{
            self.navigationItem.rightBarButtonItem = nil;
        }
        
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
