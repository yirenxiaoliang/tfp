//
//  TFProjectMainController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectMainController.h"
#import "TFProjectListController.h"

@interface TFProjectMainController ()<YPTabBarDelegate>

@end

@implementation TFProjectMainController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xffffff, 1) size:(CGSize){SCREEN_WIDTH,NaviHeight}] forBarMetrics:0];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTabBarFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)
        contentViewFrame:CGRectMake(0, 44.5, SCREEN_WIDTH,SCREEN_HEIGHT-NaviHeight-45)];
    
    self.tabBar.itemTitleColor = HexColor(0x909090);
    self.tabBar.itemTitleSelectedColor = HexAColor(0x3689e9, 1);
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:14];
    self.tabBar.itemTitleSelectedFont = FONT(14);
    self.tabBar.leftAndRightSpacing = 20;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = HexAColor(0x3689e9, 1);
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(42, 0, 0, 0) tapSwitchAnimated:NO];
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    self.loadViewOfChildContollerWhileAppear = YES;
    self.interceptRightSlideGuetureInFirstPage = YES;
    
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:20];
    self.tabBar.delegate = self;
    
    [self initViewControllers];
    
    UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,0.5}];
    [self.view addSubview:lineView];
    lineView.backgroundColor = HexColor(0xAFAFAF);
    
}

#pragma mark - YPTabBarDelegate
-(void)yp_tabBar:(YPTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index{
    [super yp_tabBar:tabBar didSelectedItemAtIndex:index];
    
    if (self.indexAction) {
        self.indexAction(@(self.tabBar.selectedItemIndex));
    }
}


- (void)initViewControllers {
    
    
    TFProjectListController *controller1 = [[TFProjectListController alloc] init];
    controller1.type = 0;
    controller1.yp_tabItemTitle = @"全部";
    
    TFProjectListController *controller2 = [[TFProjectListController alloc] init];
    controller2.type = 1;
    controller2.yp_tabItemTitle = @"我负责";
    
    TFProjectListController *controller3 = [[TFProjectListController alloc] init];
    controller3.type = 2;
    controller3.yp_tabItemTitle = @"我参与";
    
    TFProjectListController *controller4 = [[TFProjectListController alloc] init];
    controller4.type = 3;
    controller4.yp_tabItemTitle = @"我创建";
    
    TFProjectListController *controller5 = [[TFProjectListController alloc] init];
    controller5.type = 4;
    controller5.yp_tabItemTitle = @"进行中";
    
    TFProjectListController *controller6 = [[TFProjectListController alloc] init];
    controller6.type = 5;
    controller6.yp_tabItemTitle = @"已完成";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, controller5, controller6, nil];
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
