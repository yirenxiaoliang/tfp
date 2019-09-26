//
//  TFProjectFileMainController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/18.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectFileMainController.h"
#import "TFProjectFileTypeController.h"

@interface TFProjectFileMainController ()

@end

@implementation TFProjectFileMainController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    
    [self.tabBar setScrollEnabledAndItemWidth:(SCREEN_WIDTH-40)/5];
    
    
    [self initViewControllers];
    
    UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,0.5}];
    [self.view addSubview:lineView];
    lineView.backgroundColor = CellSeparatorColor;
    
}



- (void)initViewControllers {
    
    
    TFProjectFileTypeController *controller1 = [[TFProjectFileTypeController alloc] init];
    controller1.type = 0;
    controller1.dataId = self.dataId;
    controller1.libraryType = self.type;
    controller1.yp_tabItemTitle = @"全部";
    
    TFProjectFileTypeController *controller2 = [[TFProjectFileTypeController alloc] init];
    controller2.type = 1;
    controller2.yp_tabItemTitle = @"图片";
    
    TFProjectFileTypeController *controller3 = [[TFProjectFileTypeController alloc] init];
    controller3.type = 2;
    controller3.yp_tabItemTitle = @"文档";
    
    TFProjectFileTypeController *controller4 = [[TFProjectFileTypeController alloc] init];
    controller4.type = 3;
    controller4.yp_tabItemTitle = @"音频";
    
    TFProjectFileTypeController *controller5 = [[TFProjectFileTypeController alloc] init];
    controller5.type = 4;
    controller5.yp_tabItemTitle = @"视频";

    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, controller5, nil];
}


@end
