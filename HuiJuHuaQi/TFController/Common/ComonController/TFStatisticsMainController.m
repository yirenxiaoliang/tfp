//
//  TFStatisticsMainController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFStatisticsMainController.h"
#import "TFStatisticsListController.h"
#import "TFChartListController.h"
#import "TFChartDetailController.h"

@interface TFStatisticsMainController ()

@end

@implementation TFStatisticsMainController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - Navigation
- (void)setupNavigation{
    self.navigationItem.title = @"数据分析";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setTabBarFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 30)
        contentViewFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50)];
    
    self.tabBar.itemTitleColor = GreenColor;
    self.tabBar.itemTitleSelectedColor = WhiteColor;
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:16];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:16];
    self.tabBar.leftAndRightSpacing = 0;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = GreenColor;
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(0, 0, 0, 0) tapSwitchAnimated:NO];
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:0];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    self.loadViewOfChildContollerWhileAppear = YES;
    self.interceptRightSlideGuetureInFirstPage = YES;
    
    [self.tabBar setScrollEnabledAndItemWidth:(SCREEN_WIDTH-30)/2];
    
    [self initViewControllers];
    
    self.view.layer.masksToBounds = NO;
    self.view.backgroundColor = BackGroudColor;
    self.tabBar.backgroundColor = BackGroudColor;
    self.tabBar.layer.cornerRadius = 4;
    self.tabBar.layer.borderColor = GreenColor.CGColor;
    self.tabBar.layer.borderWidth = 1;
    self.tabBar.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCompany) name:ChangeCompanySocketConnect object:nil];
    
}

- (void)changeCompany{
    
    self.tabBar.selectedItemIndex = 0;
}


/**
 *  已经切换到指定index
 */
- (void)yp_tabBar:(YPTabBar *)tabBar willSelectItemAtIndex:(NSUInteger)index{
    
    
}



- (void)initViewControllers {
    
    TFStatisticsListController *controller1 = [[TFStatisticsListController alloc] init];
    controller1.yp_tabItemTitle = @"报表";
//    controller1.yp_tabItemImage = [UIImage imageNamed:@"tableGray"];
//    controller1.yp_tabItemSelectedImage = [UIImage imageNamed:@"tableGreen"];
    
    TFChartDetailController *controller2 = [[TFChartDetailController alloc] init];
    controller2.type = 1;
    controller2.yp_tabItemTitle = @"仪表盘";
//    controller2.yp_tabItemImage = [UIImage imageNamed:@"chartGray"];
//    controller2.yp_tabItemSelectedImage = [UIImage imageNamed:@"chartGreen"];
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller2, controller1, nil];
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
