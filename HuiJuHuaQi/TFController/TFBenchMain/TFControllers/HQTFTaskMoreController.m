//
//  HQTFTaskMoreController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTaskMoreController.h"
#import "HQTFTaskTypeController.h"

@interface HQTFTaskMoreController ()

@end

@implementation HQTFTaskMoreController

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
    
   
    UINavigationItem *item2 = [self itemWithTarget:self action:@selector(searchClick) image:@"搜索project" highlightImage:@"搜索project"];
    self.navigationItem.rightBarButtonItems = @[item2];
    
    self.navigationItem.title = @"我的任务";
}

- (void)searchClick{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setTabBarFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)
        contentViewFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44)];
    
    self.tabBar.itemTitleColor = ExtraLightBlackTextColor;
    self.tabBar.itemTitleSelectedColor = GreenColor;
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:16];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:18];
    self.tabBar.leftAndRightSpacing = 20;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = GreenColor;
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(40, 0, 0, 0) tapSwitchAnimated:NO];
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:0];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    self.loadViewOfChildContollerWhileAppear = YES;
    self.interceptRightSlideGuetureInFirstPage = YES;
    
    [self.tabBar setScrollEnabledAndItemWidth:(SCREEN_WIDTH-40)/3];
    
    [self initViewControllers];
    
    self.view.layer.masksToBounds = NO;
}

- (void)initViewControllers {
    HQTFTaskTypeController *controller1 = [[HQTFTaskTypeController alloc] init];
    controller1.yp_tabItemTitle = @"未完成";
    
    HQTFTaskTypeController *controller2 = [[HQTFTaskTypeController alloc] init];
    controller2.yp_tabItemTitle = @"已完成";
    
    HQTFTaskTypeController *controller3 = [[HQTFTaskTypeController alloc] init];
    controller3.yp_tabItemTitle = @"我创建的";
    
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, nil];
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
