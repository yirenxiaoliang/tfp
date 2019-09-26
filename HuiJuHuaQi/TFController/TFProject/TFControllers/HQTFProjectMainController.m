//
//  HQTFProjectMainController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProjectMainController.h"
#import "HQTFProjectTypeController.h"
#import "HQTFCreatProjectController.h"
#import "HQTFUploadController.h"
#import "TFProjectSearchController.h"
#import "TFProjectBL.h"

@interface HQTFProjectMainController ()<HQBLDelegate>
/** UIView *statusView */
@property (nonatomic, strong) UIView *statusView;

/** projectBL */
@property (nonatomic, strong) TFProjectBL *projectBL;

/** permission 0:无新建公开项目权限 1：新建公开 */
@property (nonatomic, assign) BOOL openPermission;
/** permission 0:无新建bu公开项目权限 1：新建不公开 */
@property (nonatomic, assign) BOOL noOpenPermission;


@end

@implementation HQTFProjectMainController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexColor(0xc8c8c8, 1) size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
    
    

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    if (!self.statusView) {
//        UIView *statusView = [[UIView alloc] initWithFrame:(CGRect){-0.5,-64,SCREEN_WIDTH,64}];
//        statusView.backgroundColor = NavigationBarColor;
//        statusView.layer.borderColor =HexColor(0xc8c8c8, 1).CGColor;
//        statusView.layer.borderWidth = 0.5;
//        statusView.layer.shadowOffset = CGSizeMake(0,0);
//        statusView.layer.shadowColor = HexColor(0xc8c8c8, 1).CGColor;
//        statusView.layer.shadowOpacity = 0.9;//阴影透明度，默认0
//        statusView.layer.shadowRadius = 0.5;
//        [self.view addSubview:statusView];
//        self.statusView = statusView;
//        UIView *navi = [self.navigationController.navigationBar snapshotViewAfterScreenUpdates:YES];
//        navi.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
//        [statusView addSubview:navi];
//    }
    
}
#pragma mark - Navigation
- (void)setupNavigation{
    
    if (self.openPermission || self.noOpenPermission) {
        
        UINavigationItem *item1 = [self itemWithTarget:self action:@selector(addClick) image:@"添加项目" highlightImage:@"添加项目"];
        UINavigationItem *itemE = [self itemWithTarget:self action:@selector(addClick) image:@"" highlightImage:@""];
        UINavigationItem *item2 = [self itemWithTarget:self action:@selector(searchClick) image:@"搜索project" highlightImage:@"搜索project"];
        self.navigationItem.rightBarButtonItems = @[item2,itemE,item1];
        
    }else{
        
        UINavigationItem *item2 = [self itemWithTarget:self action:@selector(searchClick) image:@"搜索project" highlightImage:@"搜索project"];
        self.navigationItem.rightBarButtonItems = @[item2];
    }
    
    
    self.navigationItem.title = @"协作项目";
}

- (void)addClick{
    HQTFCreatProjectController *creat = [[HQTFCreatProjectController alloc] init];
    [self.navigationController pushViewController:creat animated:YES];
}

- (void)searchClick{
    TFProjectSearchController *upload = [[TFProjectSearchController alloc] init];
    [self.navigationController pushViewController:upload animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setTabBarFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)
                            contentViewFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    
    self.tabBar.itemTitleColor = ExtraLightBlackTextColor;
    self.tabBar.itemTitleSelectedColor = GreenColor;
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:16];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:18];
    self.tabBar.leftAndRightSpacing = 20;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = GreenColor;
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(40, 0, 0, 0) tapSwitchAnimated:NO];
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:40];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    self.loadViewOfChildContollerWhileAppear = YES;
    self.interceptRightSlideGuetureInFirstPage = YES;
    
    [self.tabBar setScrollEnabledAndItemWidth:SCREEN_WIDTH/4 - 12];
    
    [self initViewControllers];
    
    self.view.layer.masksToBounds = NO;
    
    
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
    [self.projectBL getPermissionWithModuleId:@1110];
}

- (void)initViewControllers {
    HQTFProjectTypeController *controller1 = [[HQTFProjectTypeController alloc] init];
    controller1.yp_tabItemTitle = @"进行中";
    controller1.projectType = ProjectTypeWorking;
    
    HQTFProjectTypeController *controller2 = [[HQTFProjectTypeController alloc] init];
    controller2.yp_tabItemTitle = @"已超期";
    controller2.projectType = ProjectTypeOutDate;
    
    HQTFProjectTypeController *controller3 = [[HQTFProjectTypeController alloc] init];
    controller3.yp_tabItemTitle = @"已完成";
    controller3.projectType = ProjectTypeFinished;
    
    HQTFProjectTypeController *controller4 = [[HQTFProjectTypeController alloc] init];
    controller4.yp_tabItemTitle = @"已暂停";
    controller4.projectType = ProjectTypePaused;
    
    HQTFProjectTypeController *controller5 = [[HQTFProjectTypeController alloc] init];
    controller5.yp_tabItemTitle = @"收藏夹";
    controller5.projectType = ProjectTypeStar;
    
    HQTFProjectTypeController *controller6 = [[HQTFProjectTypeController alloc] init];
    controller6.yp_tabItemTitle = @"回收站";
    controller6.projectType = ProjectTypeFocus;
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, controller5, controller6, nil];
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
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
        
        [self setupNavigation];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    [self.tableView.mj_footer endRefreshing];
//    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
