//
//  TFNoticeReadMainController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoticeReadMainController.h"
#import "TFNoticeReadPeopleController.h"

@interface TFNoticeReadMainController ()

@end

@implementation TFNoticeReadMainController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.navigationItem.titleView = self.tabBar;
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexAColor(0xc8c8c8, 1) size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息详情";
    [self setTabBarFrame:CGRectMake(0, 8, SCREEN_WIDTH, 44)
        contentViewFrame:CGRectMake(0, 52.5, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    
    self.tabBar.itemTitleColor = ExtraLightBlackTextColor;
    self.tabBar.itemTitleSelectedColor = BlackTextColor;
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:16];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:20];
    self.tabBar.leftAndRightSpacing = 50;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = GreenColor;
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(40, 0, 0, 0) tapSwitchAnimated:NO];
//    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:40];
    [self.tabBar setScrollEnabledAndItemWidth:(SCREEN_WIDTH-100)/2];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    self.loadViewOfChildContollerWhileAppear = YES;
    
    [self initViewControllers];

    self.view.backgroundColor = BackGroudColor;
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(self.tabBar.frame),SCREEN_WIDTH,0.5}];
    [self.view addSubview:view];
    view.backgroundColor = CellSeparatorColor;
}


- (void)initViewControllers {
    
    TFNoticeReadPeopleController *controller1 = [[TFNoticeReadPeopleController alloc] init];
    controller1.yp_tabItemTitle = @"已读成员";
    controller1.type = 1;
    controller1.readPeoples = self.readpeoples;
    controller1.groupId = self.groupId;
    __weak __typeof(controller1)weakVc1 = controller1;
    controller1.actionParameter = ^(NSArray *parameter) {
        weakVc1.yp_tabItemTitle = [NSString stringWithFormat:@"%ld人已读",parameter.count];
    };
    
    TFNoticeReadPeopleController *controller2 = [[TFNoticeReadPeopleController alloc] init];
    controller2.yp_tabItemTitle = @"未读成员";
    controller2.type = 0;
    controller2.groupId = self.groupId;
    controller2.readPeoples = self.readpeoples;
    __weak __typeof(controller2)weakVc2 = controller2;
    controller2.actionParameter = ^(NSArray *parameter) {
        weakVc2.yp_tabItemTitle = [NSString stringWithFormat:@"%ld人未读",parameter.count];
    };
    
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, nil];
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
