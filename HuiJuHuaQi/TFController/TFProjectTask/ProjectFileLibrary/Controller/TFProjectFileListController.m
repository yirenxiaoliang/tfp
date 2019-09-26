//
//  TFProjectFileListController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/18.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectFileListController.h"
#import "HQTFTwoLineCell.h"
#import "HQTFSearchHeader.h"
//#import "TFProjectFileMainController.h"
#import "TFProjectFileNewController.h"

#import "TFProjectTaskBL.h"
#import "TFProjectFileMainModel.h"
#import "TFProjectFileTypeController.h"
#import "TFRefresh.h"
#import "HQTFNoContentView.h"

@interface TFProjectFileListController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,HQBLDelegate,UIAlertViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;

/** 搜索状态 */
@property (nonatomic, assign) BOOL searchStatus;

@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) TFProjectFileMainModel *mainModel;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFProjectFileListController
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
    
    self.navigationItem.title = self.naviTitle;
    
    [self.headerSearch removeFromSuperview];
    [self searchHeaderCancelClicked];
    
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:@"RefreshProjectFileList" object:nil];
    
}

- (void)setupNavi {
    
    if ([self.type isEqualToString:@"1"]) {
        
        self.navigationItem.title = self.naviTitle;
        
        UINavigationItem *item1 = [self itemWithTarget:self action:@selector(moreAction) image:@"projectMenu" highlightImage:@"projectMenu"];
        UINavigationItem *item2 = [self itemWithTarget:self action:@selector(addAction) image:@"shareAdd" highlightImage:@"shareAdd"];
        
        self.navigationItem.rightBarButtonItems = @[item1,item2];
    }
    else {
        
        self.navigationItem.title = self.naviTitle;
    }
}

- (void)requestListData {
    
    [self.projectTaskBL requestprojectLibraryQueryFileLibraryListWithId:self.dataId type:self.type pageNum:@(self.pageNum) pageSize:@(self.pageSize)];
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

#pragma mark - searchHeader Deleaget
-(void)searchHeaderCancelClicked{
    
    self.header.type = SearchHeaderTypeNormal;
    self.headerSearch.type = SearchHeaderTypeNormal;
    [self.headerSearch.textField resignFirstResponder];
    
    if (self.searchStatus) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.headerSearch.y = 24;
            self.tableView.contentInset = UIEdgeInsetsMake(108, 0, 49, 0);
            self.tableView.contentOffset = CGPointMake(0, -108);
        }completion:^(BOOL finished) {
            
            self.tableView.tableHeaderView = self.header;
            self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 49, 0);
            [self.headerSearch removeFromSuperview];
        }];
    }else{
        
        self.tableView.tableHeaderView = self.header;
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 49, 0);
        [self.headerSearch removeFromSuperview];
    }
    self.searchStatus = NO;
}

-(void)searchHeaderClicked{
    
    
}


- (void)refreshList:(NSNotification *)note {
    
    [self requestListData];
}

#pragma mark 导航栏点击事件
- (void)moreAction {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"更多操作" preferredStyle:UIAlertControllerStyleActionSheet];
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
    [alertController addAction:editAction];
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    
    // 3.显示警报控制器
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)addAction {
    
    TFProjectFileNewController *newVC = [[TFProjectFileNewController alloc] init];
    newVC.projectId = self.projectId;
    newVC.parentId = self.dataId;
    newVC.subType = @1;
    newVC.refresh = ^{
      
        [self requestListData];
    };
    [self.navigationController pushViewController:newVC animated:YES];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [self.projectTaskBL requestProjectLibraryDelLibraryWithData:self.naviTitle fileId:self.folderId projectId:self.projectId];
    }
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
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
    
    if ([self.type isEqualToString:@"1"]) {
        
        [cell.titleImage setImage:IMG(@"文件夹绿图") forState:UIControlStateNormal];
    }
    else {
        
        [cell.titleImage setImage:IMG(@"文件夹黄图") forState:UIControlStateNormal];
    }
    
    cell.topLabel.text = model.file_name;
    
    [cell.enterImage setImage:IMG(@"备忘录下一级") forState:UIControlStateNormal];
    
    cell.bottomLine.hidden = NO;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFProjectFileProListModel *model = self.dataArr[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFProjectFileTypeController *fileVC = [[TFProjectFileTypeController alloc] init];
    
    fileVC.dataId = model.data_id;
    fileVC.libraryType = model.library_type;
    fileVC.naviTitle = model.file_name;
    
    fileVC.projectId = self.projectId;
    fileVC.folderId = model.id;
    fileVC.dataId = model.data_id;
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

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_projectLibraryQueryFileLibraryList) {
        
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
    
    if (resp.cmdId == HQCMD_projectLibraryDelLibrary) {
        
        [MBProgressHUD showError:@"删除成功！" toView:self.view];
        
        if (self.refresh) {
            
            self.refresh();
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
