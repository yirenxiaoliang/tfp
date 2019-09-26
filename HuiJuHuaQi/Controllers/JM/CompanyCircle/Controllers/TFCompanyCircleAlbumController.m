//
//  TFCompanyCircleAlbumController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCompanyCircleAlbumController.h"
#import "TFCompanyCircleHeader.h"
#import "TFAlbumImageView.h"
#import "TFAlbumCell.h"
#import "TFCompanyCircleItemModel.h"
#import "TFCompanyCircleBL.h"
#import "TFCompanyCircleListModel.h"
#import "TFCompanyCircleHeader.h"
#import "MJRefresh.h"
#import "HQTFNoContentView.h"
#import "HQCategoryItemModel.h"
#import "TFCompanyCircleFrameModel.h"
#import "TFCompanyCircleDetailController.h"
#import "TFChatPeopleInfoController.h"
#import "TFPeopleBL.h"

@interface TFCompanyCircleAlbumController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFCompanyCircleHeaderDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** albums */
@property (nonatomic, strong) NSMutableArray *albums;

/** TFCompanyCircleBL */
@property (nonatomic, strong) TFCompanyCircleBL *companyCircleBL;
/** TFPeopleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;

/** pageNo */
@property (nonatomic, assign) NSInteger pageNo;
/** pageSize */
@property (nonatomic, assign) NSInteger pageSize;

/** FCompanyCircleHeader *header */
@property (nonatomic, strong) TFCompanyCircleHeader *circleHeader;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFCompanyCircleAlbumController

-(NSMutableArray *)albums{

    if (!_albums) {
        _albums = [NSMutableArray array];
        
//        for (NSInteger i = 0; i < 20; i ++) {
//            
//            TFCompanyCircleItemModel *model = [[TFCompanyCircleItemModel alloc] init];
//            model.createDate = [NSNumber numberWithLongLong:[HQHelper getNowTimeSp]-24*60*60*1000];
//            model.addressDesc = @"深圳市南山区高新南一道";
//            model.images = @[@"",@""];
//            model.content = @"看看我这里有没有好远或有好远或者有好远或者者好看的东西有的看...";
//            [_albums addObject:model];
//            
//            if (i == 4 || i == 8 || i == 12) {
//                model.images = @[];
//            }
//            
//            if (i == 2) {
//                model.images = @[@""];
//            }
//            
//            if (i == 7) {
//                model.images = @[@"",@"",@""];
//            }
//            
//            if (i == 9) {
//                model.images = @[@"",@"",@"",@""];
//            }
//            
//            
//            if (i == 1 || i == 8) {
//                
//                model.content = @"看看我这里有没有好";
//            }
//        }
//        
    }
    return _albums;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
//        
//        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}] forBarMetrics:UIBarMetricsDefault];
//        
//        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}]];
//    }
    
    
//    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"返回白色" highlightImage:@"返回白色"];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
//        
//        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
//        
//        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexColor(0xc8c8c8, 1) size:(CGSize){SCREEN_WIDTH,0.5}]];
//    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupHeader];
    [self setupNoContentView];
    self.navigationItem.title = @"相册";
    self.pageNo = 1;
    self.pageSize = 10;
    self.companyCircleBL = [TFCompanyCircleBL build];
    self.companyCircleBL.delegate = self;
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
    
    
    [self.companyCircleBL requestCompanyCircleListWithPageNo:@(self.pageNo) pageSize:@(self.pageSize) isPerson:self.employeeId startTime:nil endTime:nil];
    
    [self.peopleBL requestEmployeeDetailWithEmployeeId:self.employeeId];
    
    
//    TFAlbumImageView *view = [[TFAlbumImageView alloc] initWithFrame:(CGRect){100,100,100,100}];
//    [self.view addSubview:view];
//    [view refreshAlbumImageViewWithImages:@[@"",@"",@"",@""]];
}
#pragma mark - 无内容View
- (void)setupNoContentView{
    HQTFNoContentView *noContent = [HQTFNoContentView noContentView];
    noContent.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.height);
    
    CGRect rect = (CGRect){(SCREEN_WIDTH-Long(150))/2,(self.tableView.height - Long(150))-100,Long(150),Long(150)};
    [noContent setupImageViewRect:rect imgImage:@"图123" withTipWord:@"暂无动态"];
    
    self.noContentView = noContent;
}
#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
    if (resp.cmdId == HQCMD_companyCircleList) {
        
        TFCompanyCircleListModel *model = resp.body;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.albums removeAllObjects];
        }
        
        [self.albums addObjectsFromArray:model.list];
        
        if ([model.totalRows integerValue] == self.albums.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.albums.count == 0) {
            
            self.circleHeader.backgroundColor = ClearColor;
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
            self.circleHeader.backgroundColor = WhiteColor;
        }
        
        [self.tableView reloadData];

    }
    
    
    if (resp.cmdId == HQCMD_employeeDetail) {
        
        
        TFCircleEmployModel *em = [[TFCircleEmployModel alloc] init];
        
        NSDictionary *company = [resp.body valueForKey:@"companyInfo"];
        NSDictionary *employee = [resp.body valueForKey:@"employeeInfo"];
        NSArray *departments = [resp.body valueForKey:@"departmentInfo"];
        
        em.employeeName =  [employee valueForKey:@"employee_name"];
        em.companyName =  [company valueForKey:@"company_name"];
        em.personSignature = [employee valueForKey:@"sign"];
        em.photograph = [employee valueForKey:@"picture"];
        em.microblog_background = [employee valueForKey:@"microblog_background"];
        em.id = [employee valueForKey:@"id"];
        em.employeeId = [employee valueForKey:@"id"];
        em.sign_id = [employee valueForKey:@"sign_id"];
        em.telephone = [employee valueForKey:@"phone"];
        
        NSString *str = @"";
        for (NSDictionary *de in departments) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[de valueForKey:@"department_name"]]];
        }
        if (str.length) {
            
            em.departmentName = [str substringToIndex:str.length-1];
        }else{
            
            em.departmentName = str;
        }

        
        self.circleHeader.employee = em;
        
        
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    [self.tableView.mj_footer endRefreshing];
//    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}


- (void)setupHeader{
    
    TFCompanyCircleHeader *header = [TFCompanyCircleHeader companyCircleHeader];
    self.tableView.tableHeaderView = header;
    self.circleHeader = header;
    header.delegate = self;
    
}

-(void)companyCircleHeaderDidClickedHeadWithEmployee:(TFCircleEmployModel *)employee{
    
    TFChatPeopleInfoController *chat = [[TFChatPeopleInfoController alloc] init];
    chat.employee = employee;
    [self.navigationController pushViewController:chat animated:YES];
    
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = WhiteColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albums.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFAlbumCell *cell = [TFAlbumCell albumCellWithTableView:tableView];
    
    [cell refreshAlbumCellWithModel:self.albums[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFCompanyCircleDetailController *detail = [[TFCompanyCircleDetailController alloc] init];
    HQCategoryItemModel *cate = self.albums[indexPath.row];
    TFCompanyCircleFrameModel *model = [[TFCompanyCircleFrameModel alloc] init];
    model.circleItem = cate;
    detail.frameModel = model;
    detail.deleteAction = ^(id parameter) {
        if (parameter) {
            [self.albums removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }
    };
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [TFAlbumCell refreshAlbumCellHeightWithModel:self.albums[indexPath.row]];
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
