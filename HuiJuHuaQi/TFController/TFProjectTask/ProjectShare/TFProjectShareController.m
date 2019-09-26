//
//  TFProjectShareController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectShareController.h"
#import "TFProShareSearchController.h"
#import "TFProjectAddShareController.h"

/** model */
#import "TFProjectShareMainModel.h"

/** view */
#import "HQTFNoContentView.h"
#import "HQTFSearchHeader.h"
#import "TFProjectShareListCell.h"

#import "TFProjectTaskBL.h"
#import "TFRefresh.h"

@interface TFProjectShareController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,HQBLDelegate>

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

@property (nonatomic, strong) TFProjectShareMainModel *mainModel;

@property (nonatomic, strong) NSMutableArray *shareArr;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** 编辑editModel */
@property (nonatomic, strong) TFProjectShareInfoModel *editModel;


@end

@implementation TFProjectShareController

- (NSMutableArray *)shareArr {

    if (!_shareArr) {
        
        _shareArr = [NSMutableArray array];
    }
    return _shareArr;
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
    
    [self requestData];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:@"refreshProjectShareListNotification" object:nil];
}

- (void)requestData {

    [self.projectTaskBL requestProjectShareControllerQueryListWithData:@(self.pageNum) pageSize:@(self.pageSize) keyword:nil type:@0 projectId:self.projectId];
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
    
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    self.headerSearch = headerSearch;
    headerSearch.type = SearchHeaderTypeMove;
    headerSearch.delegate = self;
    
}

#pragma mark - searchHeader Deleaget

-(void)searchHeaderClicked{
    
    
    TFProShareSearchController *search = [[TFProShareSearchController alloc] init];
    search.projectId = self.projectId;
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    MJRefreshGifHeader *header = [TFRefresh headerGifRefreshWithBlock:^{
        
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
    return self.shareArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TFProjectShareListCell *cell = [TFProjectShareListCell projectShareListCellWithTableView:tableView];
    
    [cell refreshProjectShareListCellWithData:self.shareArr[indexPath.row]];
    
    if (indexPath.row == self.shareArr.count - 1) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
 
    TFProjectShareInfoModel *model = self.shareArr[indexPath.row];
    
    TFProjectAddShareController *detail = [[TFProjectAddShareController alloc] init];
    detail.projectModel = self.projectModel;
    detail.type = 1;
    detail.shareId = model.id;
    detail.proId = model.project_id;
    detail.refresh = ^{
      
        [self requestData];
    };
    
    [self.navigationController pushViewController:detail animated:YES];
    
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

#pragma mark ---------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TFProjectShareInfoModel *model = self.shareArr[indexPath.row];
    if ([model.top_status isEqualToString:@"1"]) {
        
        return @"取消置顶";
    }
    else {
        
        return @"置顶";
    }
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.section == 0) {
    //        return UITableViewCellEditingStyleNone;
    //    }else{
    return UITableViewCellEditingStyleDelete;
    //    }
}
//先设置Cell可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TFProjectShareInfoModel *model = self.shareArr[indexPath.row];
    self.editModel = model;
    if ([model.top_status isEqualToString:@"1"]) {
        
        [self.projectTaskBL requestProjectShareControllerShareStickWithId:model.id status:@0];
    }
    else {
        
        [self.projectTaskBL requestProjectShareControllerShareStickWithId:model.id status:@1];
    }
    //
    
    
}

#pragma mark 通知方法
- (void)refreshList:(NSNotification *)note {
    
    [self requestData];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_projectShareControllerQueryList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.mainModel = resp.body;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.shareArr removeAllObjects];
        }
        
        [self.shareArr addObjectsFromArray:self.mainModel.dataList];
        
        if ([self.mainModel.pageInfo.totalRows integerValue] == self.shareArr.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.shareArr.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
            
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.tableView reloadData];

    }
    if (resp.cmdId == HQCMD_projectShareControllerShareStick) {
        
        [MBProgressHUD showError:@"设置成功" toView:self.view];
        
//        [self requestData];
        self.editModel.top_status = [self.editModel.top_status isEqualToString:@"1"]?@"0":@"1";
        if ([self.editModel.top_status isEqualToString:@"1"]) {
            [self.shareArr removeObject:self.editModel];
            [self.shareArr insertObject:self.editModel atIndex:0];
        }
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
