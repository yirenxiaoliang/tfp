//
//  HQTFProjectFileRowController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProjectFileRowController.h"
#import "HQTFProjectColumnController.h"

@interface HQTFProjectFileRowController ()

@end

@implementation HQTFProjectFileRowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"文件列表";
    
    [self setTabBarFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)
        contentViewFrame:CGRectMake(0, 44.5, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44)];
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,0.5}];
    [self.view addSubview:line];
    line.backgroundColor = CellSeparatorColor;
    
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
    
    [self.tabBar setScrollEnabledAndItemWidth:SCREEN_WIDTH/4 - 12];
    
    [self initViewControllers];
    
    self.view.layer.masksToBounds = NO;
}

- (void)initViewControllers {
    
    HQTFProjectColumnController *controller1 = [[HQTFProjectColumnController alloc] init];
    controller1.yp_tabItemTitle = @"全部";
    controller1.type = ColumnTypeAll;
    controller1.projectTaskRow = self.projectTaskRow;
    
    HQTFProjectColumnController *controller2 = [[HQTFProjectColumnController alloc] init];
    controller2.yp_tabItemTitle = @"文档";
    controller2.type = ColumnTypeDoc;
    controller2.projectTaskRow = self.projectTaskRow;
    
    HQTFProjectColumnController *controller3 = [[HQTFProjectColumnController alloc] init];
    controller3.yp_tabItemTitle = @"图片";
    controller3.type = ColumnTypeImage;
    controller3.projectTaskRow = self.projectTaskRow;
    
    HQTFProjectColumnController *controller4 = [[HQTFProjectColumnController alloc] init];
    controller4.yp_tabItemTitle = @"语音";
    controller4.type = ColumnTypeAudio;
    controller4.projectTaskRow = self.projectTaskRow;
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, nil];
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
