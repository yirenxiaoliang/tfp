//
//  TFProjectModelMainController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectModelMainController.h"
#import "TFProjectModelController.h"
#import "TFMyModelController.h"
#import "TFProjectClassModel.h"

@interface TFProjectModelMainController ()

/** TFProjectClassModel */
@property (nonatomic, strong) TFProjectClassModel *projectModel;
/** controller1 */
@property (nonatomic, weak) TFProjectModelController *controller1;
/** controller2 */
@property (nonatomic, weak) TFMyModelController *controller2;

@end

@implementation TFProjectModelMainController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTabBarFrame:CGRectMake(0, 0, SCREEN_WIDTH-180, 44)
        contentViewFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-NaviHeight)];
    
    self.tabBar.itemTitleColor = HexColor(0x909090);
    self.tabBar.itemTitleSelectedColor = HexAColor(0x3689e9, 1);
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:18];
    self.tabBar.itemTitleSelectedFont = FONT(18);
    self.tabBar.leftAndRightSpacing = 0;
    [self.tabBar removeFromSuperview];
    self.navigationItem.titleView = self.tabBar;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = HexAColor(0x3689e9, 1);
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(42, 0, 0, 0) tapSwitchAnimated:NO];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    self.loadViewOfChildContollerWhileAppear = YES;
    self.interceptRightSlideGuetureInFirstPage = YES;
    
    [self.tabBar setScrollEnabledAndItemWidth:(SCREEN_WIDTH-180)/2];
    
    [self initViewControllers];
    
//    [self setupNavigation];
}

//- (void)setupNavigation{
//    
//    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GrayTextColor];
//}
//
//- (void)sure{
//    
//    if (self.parameter) {
//        self.parameter(self.projectModel);
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

- (void)initViewControllers {
    
    
    TFProjectModelController *controller1 = [[TFProjectModelController alloc] init];
    self.controller1 = controller1;
    controller1.yp_tabItemTitle = @"项目模板";
    controller1.parameter = ^(id parameter) {
        if (self.parameter) {
            self.parameter(parameter);
            [self.navigationController popViewControllerAnimated:YES];
        }
    };

    TFMyModelController *controller2 = [[TFMyModelController alloc] init];
    self.controller2 = controller2;
    controller2.yp_tabItemTitle = @"我的模板";
    controller2.parameter = ^(id parameter) {
        if (self.parameter) {
            self.parameter(parameter);
            [self.navigationController popViewControllerAnimated:YES];
        }
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
