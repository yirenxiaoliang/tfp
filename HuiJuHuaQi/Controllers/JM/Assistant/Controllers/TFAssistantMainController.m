//
//  TFAssistantMainController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/4.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAssistantMainController.h"
#import "TFAssistantTypeController.h"
#import "TFAssistantSettingController.h"

@interface TFAssistantMainController ()<YPTabBarDelegate>

/** item */
@property (nonatomic, strong) NSMutableArray *item;
/** items */
@property (nonatomic, strong) NSMutableArray *items;


@end

@implementation TFAssistantMainController

-(NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
-(NSMutableArray *)item{
    if (!_item) {
        _item = [NSMutableArray array];
    }
    return _item;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexAColor(0xc8c8c8, 1) size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
#pragma mark - Navigation
- (void)setupNavigation{
    
    UINavigationItem *item1 = [self itemWithTarget:self action:@selector(deleteClick) text:@"清空" textColor:GreenColor];
    UINavigationItem *item2 = [self itemWithTarget:self action:@selector(settingClick) image:@"设置灰色" highlightImage:@"设置灰色"];
    [self.items addObjectsFromArray:@[item2,item1]];
    
    [self.item addObject:item2];
    
    switch (self.assistantType) {
        case AssistantTypeNote:
            self.navigationItem.title = @"随手记助手";
            break;
        case AssistantTypeTask:
            self.navigationItem.title = @"任务助手";
            break;
        case AssistantTypeSchedule:
            self.navigationItem.title = @"日程助手";
            break;
        case AssistantTypeFile:
            self.navigationItem.title = @"文件库助手";
            break;
        case AssistantTypeApproval:
            self.navigationItem.title = @"审批助手";
            break;
        case AssistantTypeNotice:
            self.navigationItem.title = @"公告助手";
            break;
        case AssistantTypeReport:
            self.navigationItem.title = @"工作汇报助手";
            break;
            
        default:
            break;
    }
}

- (void)deleteClick{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AssistantMessageClearNotifitoin object:nil];
    
}



- (void)settingClick{
    TFAssistantSettingController *setting = [[TFAssistantSettingController alloc] init];
    setting.typeModel = self.typeModel;
    setting.assistantType = self.assistantType;
    setting.conversation = self.conversation;
    [self.navigationController pushViewController:setting animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setTabBarFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)
        contentViewFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44)];
    
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
    self.interceptRightSlideGuetureInFirstPage = YES;
    
    [self.tabBar setScrollEnabledAndItemWidth:(SCREEN_WIDTH-40)/3];
    
    [self initViewControllers];
    
    self.view.layer.masksToBounds = NO;
}

/**
 *  已经切换到指定index
 */
- (void)yp_tabBar:(YPTabBar *)tabBar willSelectItemAtIndex:(NSUInteger)index{
    
    switch (index) {
        case 0:
        case 1:
            self.navigationItem.rightBarButtonItems = self.item;
            break;
            
        default:
            self.navigationItem.rightBarButtonItems = self.items;
            break;
    }
}



- (void)initViewControllers {
    TFAssistantTypeController *controller1 = [[TFAssistantTypeController alloc] init];
    controller1.yp_tabItemTitle = @"未读";
    controller1.type = AssistantStatusTypeUnread;
    controller1.assistantType = self.assistantType;
    controller1.conversation = self.conversation;
    
    
    TFAssistantTypeController *controller2 = [[TFAssistantTypeController alloc] init];
    controller2.yp_tabItemTitle = @"已读";
    controller2.type = AssistantStatusTypeRead;
    controller2.assistantType = self.assistantType;
    
    TFAssistantTypeController *controller3 = [[TFAssistantTypeController alloc] init];
    controller3.yp_tabItemTitle = @"待处理";
    controller3.type = AssistantStatusTypeHandle;
    controller3.assistantType = self.assistantType;
    
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, nil];
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
