//
//  HQTFTaskMainController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTaskMainController.h"
#import "HQTFTaskDetailController.h"
#import "HQTFTaskDynamicController.h"
#import "HQTFUploadFileView.h"

@interface HQTFTaskMainController ()

/** titleView */
//@property (nonatomic, strong) UIView *titleView;
//@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation HQTFTaskMainController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.titleView = self.tabBar;
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"关闭" highlightImage:@"关闭"];
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(menuClick) image:@"菜单" highlightImage:@"菜单"];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexColor(0xc8c8c8, 1) size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)menuClick{
    
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    if ([self.projectSeeModel.project.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    [HQTFUploadFileView showAlertView:@"更多操作" withType:0 parameterAction:^(NSNumber *parameter) {
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TaskDetailMoreHandleNotifition object:parameter];
        
    }];
    
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.titleLabel = [HQHelper labelWithFrame:(CGRect){0,-44,160,44} text:@"动态" textColor:BlackTextColor textAlignment:NSTextAlignmentCenter font:FONT(20)];
//    self.titleView = [[UIView alloc] initWithFrame:(CGRect){0,0,160,44}];
//    [self.titleView addSubview:self.titleLabel];
    
    [self setTabBarFrame:CGRectMake(0, 0, 210, 44)
        contentViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    
    self.tabBar.itemTitleColor = ExtraLightBlackTextColor;
    self.tabBar.itemTitleSelectedColor = GreenColor;
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:16];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:20];
    self.tabBar.leftAndRightSpacing = 0;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = GreenColor;
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(40, 0, 0, 0) tapSwitchAnimated:NO];
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:40];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    self.loadViewOfChildContollerWhileAppear = YES;
    
    [self.tabBar setScrollEnabledAndItemWidth:70];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    
    [self initViewControllers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputJumpNotifition:) name:TFProjectTaskInputJumpNotifition object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dynamicDownNotifition) name:TFProjectDynamicDownJumpNotifition object:nil];
    
    
    self.selectedControllerIndex = 1;
    self.selectedControllerIndex = 0;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TFProjectDynamicNormalpNotifition object:nil];
}

- (void)inputJumpNotifition:(NSNotification *)noti{
    
    self.selectedControllerIndex = 1;
//    self.navigationItem.titleView = self.titleView;
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        self.titleLabel.top = 0;
//    }];
    
//    self.contentScrollView.scrollEnabled = NO;
}

- (void)dynamicDownNotifition{
    
    self.selectedControllerIndex = 0;
    
    self.navigationItem.titleView = self.tabBar;
    
//    self.titleLabel.top = 44;
    
//    self.contentScrollView.scrollEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TFProjectDynamicNormalpNotifition object:nil];
    
}


- (void)initViewControllers {
    
    HQTFTaskDetailController *controller1 = [[HQTFTaskDetailController alloc] init];
    controller1.projectTask = self.projectTask;
    controller1.projectSeeModel = self.projectSeeModel;
    controller1.yp_tabItemTitle = @"详情";
    
    HQTFTaskDynamicController *controller2 = [[HQTFTaskDynamicController alloc] init];
    controller2.taskDetail = self.projectTask;
    controller2.projectSeeModel = self.projectSeeModel;
    controller2.yp_tabItemTitle = @"评论";
    controller2.type = 0;
    
    HQTFTaskDynamicController *controller3 = [[HQTFTaskDynamicController alloc] init];
    controller3.taskDetail = self.projectTask;
    controller3.yp_tabItemTitle = @"动态";
    controller3.type = 1;
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2,controller3, nil];
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
