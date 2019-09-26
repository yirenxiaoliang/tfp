//
//  TFAttendanceStatisticsController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAttendanceStatisticsController.h"
#import "TFStatisticsSubController.h"
#import "TFDayStatisticsController.h"

@interface TFAttendanceStatisticsController ()

@end

@implementation TFAttendanceStatisticsController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self setTabBarFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)
        contentViewFrame:CGRectMake(0, 44.5, SCREEN_WIDTH,SCREEN_HEIGHT-64-45)];
    
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
    
    [self.tabBar setScrollEnabledAndItemWidth:(SCREEN_WIDTH-40)/3];
    
    
    [self initViewControllers];
    
    UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,0.5}];
    [self.view addSubview:lineView];
    lineView.backgroundColor = CellSeparatorColor;
    
}


- (void)initViewControllers {
    
    
//    TFStatisticsSubController *controller1 = [[TFStatisticsSubController alloc] init];
//    controller1.type = 0;
    TFDayStatisticsController *controller1 = [[TFDayStatisticsController alloc] init];
    controller1.yp_tabItemTitle = @"日统计";
    
    TFStatisticsSubController *controller2 = [[TFStatisticsSubController alloc] init];
    controller2.type = 1;
    controller2.yp_tabItemTitle = @"月统计";
    
    TFStatisticsSubController *controller3 = [[TFStatisticsSubController alloc] init];
    controller3.type = 2;
    controller3.yp_tabItemTitle = @"我的";
    
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, nil];
}


@end
