//
//  TFProjectFileController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectFileController.h"
#import "HQTFTwoLineCell.h"
#import "HQTFSearchHeader.h"
#import "TFProjectFileListController.h"

#import "TFProjectTaskBL.h"
#import "TFProjectFileProListModel.h"
#import "TFProjectFileMainModel.h"
#import "TFRefresh.h"
#import "HQTFNoContentView.h"
#import "TFProjectFileTypeController.h"
#import "TFProjectFileNewController.h"
#import "TFProjectFileSearchController.h"

@interface TFProjectFileController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,HQBLDelegate,HQTFTwoLineCellDelegate,UIActionSheetDelegate>

@property (nonatomic, weak) UITableView *tableView;

/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;

/** 搜索状态 */
@property (nonatomic, assign) BOOL searchStatus;

@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

@property (nonatomic, strong) TFProjectFileMainModel *mainModel;
@property (nonatomic, strong) TFProjectFileProListModel *listModel;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) HQTFNoContentView *noContentView;
/** 权限 */
@property (nonatomic, copy) NSString *privilege;

@end

@implementation TFProjectFileController
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.headerSearch removeFromSuperview];
//    [self searchHeaderCancelClicked];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
    
    [self setupTableView];
    
    [self setupHeaderSearch];
    
    self.pageNum = 1;
    self.pageSize = 20;
    
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestListData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:@"RefreshProjectFileList" object:nil];
}

#pragma mark - headerSearch
- (void)setupHeaderSearch{
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    self.header = header;
    header.y = -20;
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}] ;
    [view addSubview:header];
    self.tableView.tableHeaderView = view;
    header.delegate = self;
    
}

#pragma mark - searchHeader Deleaget
-(void)searchHeaderClicked{
    TFProjectFileSearchController *search = [[TFProjectFileSearchController alloc] init];
    search.style = 1;
    search.projectId = self.projectId;
    
    [self.navigationController pushViewController:search animated:YES];
}

- (void)requestListData {
    
    [self.projectTaskBL requestProjectLibraryQueryLibraryListWithId:self.projectId pageNum:@(self.pageNum) pageSize:@(self.pageSize)];
    
    
    [self.projectTaskBL requestGetProjectRoleAndAuthWithProjectId:self.projectId employeeId:UM.userLoginInfo.employee.id];// 权限
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-BottomHeight-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
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
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFProjectFileProListModel *model = self.dataArr[indexPath.row];
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    
    cell.type = TwoLineCellTypeOne;
    
    cell.titleImageWidth = 34.0;
    cell.enterImage.userInteractionEnabled = YES;
    
    if ([model.library_type isEqualToString:@"1"]) {
        
        [cell.titleImage setImage:IMG(@"默认文件夹") forState:UIControlStateNormal];
        
        // 此处由权限控制
        if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"29"]
            || [HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"30"]) {
            
            cell.enterImage.hidden = NO;
            cell.enterImage.userInteractionEnabled = YES;
            [cell.enterImage setImage:IMG(@"下啦") forState:UIControlStateNormal];
        }else{
            cell.enterImage.hidden = YES;
        }
    }
    else {
        cell.enterImage.hidden = YES;
        [cell.titleImage setImage:IMG(@"默认文件夹") forState:UIControlStateNormal];
    }
    
    cell.enterImgTrailW.constant = -15;
    cell.topLabel.text = model.file_name;
    if (indexPath.row == self.dataArr.count - 1) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    cell.delegate = self;
    cell.enterImage.tag = indexPath.row;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFProjectFileProListModel *model = self.dataArr[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
//    TFProjectFileListController *fileListVC = [[TFProjectFileListController alloc] init];
//
//    fileListVC.dataId = model.data_id;
//    fileListVC.type = model.library_type;
//    fileListVC.naviTitle = model.file_name;
//    fileListVC.projectId = self.projectId;
//    fileListVC.folderId = model.id;
//
//    fileListVC.refresh = ^{
//
//        [self requestListData];
//    };

//    [self.navigationController pushViewController:fileListVC animated:YES];
    
    TFProjectFileTypeController *fileVC = [[TFProjectFileTypeController alloc] init];

    fileVC.libraryType = model.library_type;
    fileVC.naviTitle = model.file_name;

    fileVC.projectId = self.projectId;
    fileVC.folderId = model.id;
    fileVC.dataId = model.data_id;
    fileVC.privilege = self.privilege;
    fileVC.refresh = ^{

        [self requestListData];
    };
    
    [self.navigationController pushViewController:fileVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
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

- (void)refreshList:(NSNotification *)note {
    
    [self requestListData];
}

#pragma mark - HQTFTwoLineCellDelegate
-(void)twoLineCell:(HQTFTwoLineCell *)cell didEnterImage:(UIButton *)enterBtn{
    
    self.listModel = self.dataArr[enterBtn.tag];
    
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
    [sheet showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {// 取消
        
    }
    if (buttonIndex == 1) {
        if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"29"]) {// 编辑
            
            TFProjectFileNewController *newVC = [[TFProjectFileNewController alloc] init];
            newVC.projectId = self.projectId;
            newVC.folderId = self.listModel.id;
            newVC.folderName = self.listModel.file_name;
            newVC.isEdit = YES;
            newVC.refresh = ^{
                
                [self requestListData];
            };
            [self.navigationController pushViewController:newVC animated:YES];
            
        }else if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"30"]){// 删除
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.projectTaskBL requestProjectLibraryDelLibraryWithData:self.listModel.file_name fileId:self.listModel.id projectId:self.projectId];
        }
    }
    if (buttonIndex == 2) {
        if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"30"]){// 删除
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.projectTaskBL requestProjectLibraryDelLibraryWithData:self.listModel.file_name fileId:self.listModel.id projectId:self.projectId];
        }
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_projectLibraryQueryLibraryList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.mainModel = resp.body;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.dataArr removeAllObjects];
        }
        
        [self.dataArr addObjectsFromArray:self.mainModel.dataList];
        
        if ([self.mainModel.pageInfo.totalRows integerValue] == self.dataArr.count) {
            
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
    }
    
    if (resp.cmdId == HQCMD_getProjectRoleAndAuth) {
        
        NSDictionary *dict = [resp.body valueForKey:@"priviledge"];
        self.privilege = [dict valueForKey:@"priviledge_ids"];
        
        if (self.actionParameter) {
            self.actionParameter(self.privilege);
        }
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_projectLibraryDelLibrary) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [MBProgressHUD showError:@"删除成功" toView:self.view];
        [self.dataArr removeObject:self.listModel];
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
