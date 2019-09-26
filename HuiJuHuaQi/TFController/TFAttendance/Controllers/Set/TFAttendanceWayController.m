//
//  TFAttendanceWayController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAttendanceWayController.h"
#import "TFAddressWayController.h"
#import "TFWifiWayController.h"
#import "FDActionSheet.h"
#import "TFAddPCWiFiController.h"
#import "TFAddPCAddressController.h"

@interface TFAttendanceWayController ()

@end

@implementation TFAttendanceWayController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"考勤方式";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addAttendanceWay) text:@"添加" textColor:GreenColor];
    
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
    
    [self.tabBar setScrollEnabledAndItemWidth:(SCREEN_WIDTH-40)/2];
    
    
    [self initViewControllers];
    
    UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,0.5}];
    [self.view addSubview:lineView];
    lineView.backgroundColor = CellSeparatorColor;
    
}


- (void)initViewControllers {
    
    
    TFAddressWayController *controller1 = [[TFAddressWayController alloc] init];

    controller1.yp_tabItemTitle = @"地点考勤";
    
    TFWifiWayController *controller2 = [[TFWifiWayController alloc] init];

    controller2.yp_tabItemTitle = @"WiFi考勤";
    
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, nil];
}

- (void)addAttendanceWay {
    
    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"添加考勤方式" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"地点考勤",@"Wi-Fi考勤", nil];
    
    
    [sheet show];
}

#pragma mark FDActionSheetDelegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) { //添加考勤地点
        
        TFAddPCAddressController *addAddressVC = [[TFAddPCAddressController alloc] init];
        addAddressVC.type = 0;
        
        [self.navigationController pushViewController:addAddressVC animated:YES];
    }
    else { //添加考勤Wi-Fi
        
        TFAddPCWiFiController *addWifiVC = [[TFAddPCWiFiController alloc] init];

        [self.navigationController pushViewController:addWifiVC animated:YES];
        
    }
    
}

@end
