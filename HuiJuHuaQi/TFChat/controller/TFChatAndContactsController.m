
//
//  TFChatAndContactsController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChatAndContactsController.h"
#import "TFAddressBookController.h"
#import "HQConversationListController.h"
@interface TFChatAndContactsController ()

/** 聊天 */
@property (nonatomic, strong) HQConversationListController *conversation;


@end

@implementation TFChatAndContactsController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    [self setTabBarFrame:CGRectMake(0, 0, ((SCREEN_WIDTH - 88)/2 - 20) * 2, 44)
        contentViewFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-NaviHeight-BottomHeight)];
    
    [self.tabBar removeFromSuperview];
    self.navigationItem.titleView = self.tabBar;
    
    self.tabBar.itemTitleColor = ExtraLightBlackTextColor;
    self.tabBar.itemTitleSelectedColor = HexAColor(0x222222, 1);
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:18];
    self.tabBar.itemTitleSelectedFont = BFONT(20);
    self.tabBar.leftAndRightSpacing = 0;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = HexAColor(0x62b031, 1);
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(44, 0, 0, 0) tapSwitchAnimated:NO];
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:40];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    self.loadViewOfChildContollerWhileAppear = YES;
    self.interceptRightSlideGuetureInFirstPage = YES;
    
    [self.tabBar setScrollEnabledAndItemWidth:(SCREEN_WIDTH - 100)/2 - 25];
    
    self.contentScrollView.scrollEnabled = NO;// 禁止滑动
    
    [self initViewControllers];
    
    [self setupNavigation];
}


- (void)setupNavigation {
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"企信";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightClicked) image:@"聊天chat" highlightImage:@"聊天chat"];
    
    UIBarButtonItem *item1 = [self itemWithTarget:self action:@selector(leftClick) image:@"扫码灰色" highlightImage:@"扫码灰色"];
    
    
    self.navigationItem.leftBarButtonItems = @[item1];
    
}

- (void)rightClicked{
    [self.conversation rightClicked];
}
- (void)leftClick{
    [self.conversation leftClick];
}

- (void)initViewControllers {
    
    
    HQConversationListController *controller1 = [[HQConversationListController alloc] init];
    controller1.yp_tabItemTitle = @"消息";
    self.conversation = controller1;
    
    TFAddressBookController *controller2 = [[TFAddressBookController alloc] init];
    controller2.yp_tabItemTitle = @"通讯录";
    
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
