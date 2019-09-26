//
//  HQTFProjectTypeController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProjectTypeController.h"
#import "HQTFProjectProcessCell.h"
#import "HQTFNoContentView.h"
#import "HQTFCreatProjectController.h"
#import "HQTFProjectSeeBoardController.h"
#import "TFProjectBL.h"
#import "MJRefresh.h"
#import "TFProjectListModel.h"

@interface HQTFProjectTypeController ()<UITableViewDelegate,UITableViewDataSource,HQTFNoContentViewDelegate,HQBLDelegate>
/**  UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** projects */
@property (nonatomic, strong) NSMutableArray *projects;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** 请求 */
@property (nonatomic, strong) TFProjectBL *projectBL;
/** 请求数据 */
@property (nonatomic, strong) TFProjectListModel *projectListModel;

/** pageNum */
@property (nonatomic, assign) NSInteger pageNum;
/** pageSize */
@property (nonatomic, assign) NSInteger pageSize;

/** permission 0:无新建公开项目权限 1：新建公开 */
@property (nonatomic, assign) BOOL openPermission;
/** permission 0:无新建bu公开项目权限 1：新建不公开 */
@property (nonatomic, assign) BOOL noOpenPermission;

@end



@implementation HQTFProjectTypeController

-(NSMutableArray *)projects{
    if (!_projects) {
        _projects = [NSMutableArray array];
    }
    return _projects;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexColor(0xc8c8c8, 1) size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
    
    
    [self.projectBL requestGetProjectListWithType:self.projectType pageNum:self.pageNum pageSize:self.pageSize];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setFromNavBottomEdgeLayout];
    [self setupTableView];
    [self setupNoContentView];
    
    self.pageSize = 10;
    self.pageNum = 1;
    // 请求
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
    
    [self.projectBL getPermissionWithModuleId:@1110];
}


#pragma mark - 无内容View
- (void)setupNoContentView{
    HQTFNoContentView *noContent = [HQTFNoContentView noContentView];
    noContent.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.height);
    noContent.delegate = self;
    
    CGRect rect = (CGRect){(SCREEN_WIDTH-Long(150))/2,(self.tableView.height - Long(150))/2 - 60,Long(150),Long(150)};
    
    
    switch (self.projectType) {
        case ProjectTypeWorking:
        {
            if (self.openPermission || self.noOpenPermission) {
                
                [noContent setupImageViewRect:rect imgImage:@"图123" buttonImage:@"加号" buttonWord:@"  新建项目" withTipWord:@"暂无进行中项目，快去新建项目吧"];
            }else{
                
                [noContent setupImageViewRect:rect imgImage:@"图123" withTipWord:@"暂无进行中项目，喝杯咖啡思考人生"];
            }
        }
            break;
        case ProjectTypeOutDate:
        {
            [noContent setupImageViewRect:rect imgImage:@"图123" withTipWord:@"暂无超期项目，喝杯咖啡思考人生"];
        }
            break;
        case ProjectTypeFinished:
        {
            [noContent setupImageViewRect:rect imgImage:@"图123" withTipWord:@"暂无完成项目，喝杯咖啡思考人生"];
        }
            break;
        case ProjectTypePaused:
        {
            [noContent setupImageViewRect:rect imgImage:@"图123" withTipWord:@"暂无暂停项目，喝杯咖啡思考人生"];
        }
            break;
        case ProjectTypeStar:
        {
            [noContent setupImageViewRect:rect imgImage:@"图123" withTipWord:@"暂无收藏项目，喝杯咖啡思考人生"];
        }
            break;
        case ProjectTypeFocus:
        {
            [noContent setupImageViewRect:rect imgImage:@"图123" withTipWord:@"暂无回收项目，喝杯咖啡思考人生"];
        }
            break;
            
        default:
            break;
    }
    
    self.noContentView = noContent;
//    [self.view addSubview:self.noContentView];
}

- (void)noContentViewDidClickedButton{
    
    HQTFCreatProjectController *createProject = [[HQTFCreatProjectController alloc] init];
    [self.navigationController pushViewController:createProject animated:YES];
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageNum = 1;
        
        [self.projectBL requestGetProjectListWithType:self.projectType pageNum:self.pageNum pageSize:self.pageSize];
    }];
    
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        
        [self.projectBL requestGetProjectListWithType:self.projectType pageNum:self.pageNum pageSize:self.pageSize];
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.projects.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HQTFProjectProcessCell *cell = [HQTFProjectProcessCell projectProcessCellWithTableView:tableView];
    cell.groundImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.section%5 + 1]];
    [cell refreshProjectProcessCellWithModel:self.projects[indexPath.section] type:self.projectType];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    HQTFProjectSeeBoardController *seeBoard = [[HQTFProjectSeeBoardController alloc] init];
    seeBoard.projectItem = self.projects[indexPath.section];
    [self.navigationController pushViewController:seeBoard animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
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


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    if (resp.cmdId == HQCMD_getProjList) {
        
        self.projectListModel = resp.body;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.projects removeAllObjects];
        }
        
        [self.projects addObjectsFromArray:self.projectListModel.list];
        
        if (self.projectListModel.totalRows == self.projects.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
//            self.tableView.mj_footer = nil;
//            
//            if (self.projects.count < 10) {
//                self.tableView.tableFooterView = [UIView new];
//            }else{
//                self.tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];;
//            }
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.projects.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_getPermission) {
        
        for (TFPermissionModel *model in resp.body) {
            
            if ([model.code isEqualToNumber:@111001]) {
                self.openPermission = YES;
                continue;
            }
            
            if ([model.code isEqualToNumber:@111002]) {
                self.noOpenPermission = YES;
                continue;
            }
        }
        
        [self setupNoContentView];
        
        [self.projectBL requestGetProjectListWithType:self.projectType pageNum:self.pageNum pageSize:self.pageSize];
    }

}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
    
    if (resp.cmdId == HQCMD_getProjList) {
        
    }
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
