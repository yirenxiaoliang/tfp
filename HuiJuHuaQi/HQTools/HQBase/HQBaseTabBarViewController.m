//
//  HQBaseTabBarViewController.m
//  HuiJuHuaQi
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseTabBarViewController.h"
#import "HQTabBar.h"
#import "AppDelegate.h"
#import "HQRootButton.h"
#import "HQBaseNavigationController.h"
#import "HQConversationListController.h"
#import "HQTFMeController.h"
#import "HQTFModelBenchController.h"
#import "HQBenchMainfaceModel.h"
#import "TFCompanyCircleController.h"
#import "TFCompanyContactsController.h"
#import "TFPlusController.h"
#import "TFAddressBookController.h"
#import "TFApprovalMainController.h"
#import "TFStatisticsMainController.h"
#import "TFCreateNoteController.h"
#import "TFChatAndContactsController.h"
#import "TFStatisticsMainController.h"
#import "TFProjectAndTaskMainController.h"
#import "TFModelEnterController.h"
#import "TFCustomBL.h"
#import "TFModuleModel.h"
#import "TFAddCustomController.h"
#import "TFCreateProjectController.h"
#import "TFChartDetailController.h"
#import "TFMeController.h"
#import "TFFileMenuController.h"
#import "TFAttendanceTabbarController.h"
#import "TFEmailsNewController.h"

#import "TFBenchMainController.h"
#import "HQMyWorksController.h"
#import "TFProjectBenchController.h"
#import "TFWorkPlatformController.h"
#import "TFTwoWorkPlatformController.h"
#import "TFChartStatisticsController.h"
#import "HuiJuHuaQi-Swift.h"
#import "TFWorkEnterController.h"

#define BottomMargin 300

@interface HQBaseTabBarViewController () <HQTabBarDelegate,TFTabBarDelegate,UITabBarControllerDelegate,UITabBarDelegate>

@property (nonatomic, strong) NSDate *lastSelectedDate;


@property (nonatomic, weak) TFTabBar *bar ;

@end

@implementation HQBaseTabBarViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.delegate = self;
    
    TFWorkEnterController *message = [[TFWorkEnterController alloc] init];
//    TFChartStatisticsController *message = [[TFChartStatisticsController alloc] init];
//    TFChartDetailController *message = [[TFChartDetailController alloc] init];
//    message.type = 1;
//    TFStatisticsMainController * message = [[TFStatisticsMainController alloc] init];
    [self addOneChlildVc:message title:NSLocalizedString(@"Bench", nil) imageName:@"工作台" selectedImageName:@"工作台选中"];
    
    HQConversationListController *addressBook = [[HQConversationListController alloc] init];
    //    TFChatAndContactsController *addressBook = [[TFChatAndContactsController alloc] init];
    [self addOneChlildVc:addressBook title:NSLocalizedString(@"Chats", nil) imageName:@"企信" selectedImageName:@"企信选中"];
    
//    TFModelEnterController *workBench = [[TFModelEnterController alloc] init];
//    workBench.openOften = YES;
//    workBench.hasBanner = YES;
    TFTwoWorkPlatformController *workBench = [[TFTwoWorkPlatformController alloc] init];
//    TFWorkPlatformController *workBench = [[TFWorkPlatformController alloc] init];
//    TFProjectBenchController * workBench = [[TFProjectBenchController alloc] init];
//    HQMyWorksController *workBench = [[HQMyWorksController alloc] init];
//    TFBenchMainController *workBench = [[TFBenchMainController alloc] init];
    [self addOneChlildVc:workBench title:nil imageName:nil selectedImageName:@"应用选中"];
    

    TFAddressBookController *book = [[TFAddressBookController alloc] init];
    [self addOneChlildVc:book title:NSLocalizedString(@"Contacts", nil) imageName:@"通讯录bar" selectedImageName:@"通讯录barSelect"];
    

    
    TFMeController *firendsCircle = [[TFMeController alloc] init];
//    HQTFMeController *firendsCircle = [[HQTFMeController alloc] init];
    [self addOneChlildVc:firendsCircle title:NSLocalizedString(@"Me", nil) imageName:@"我的" selectedImageName:@"我的选中"];
    
//    HQTabBar *tabBar = [[HQTabBar alloc] init];
    TFTabBar *tabBar = [[TFTabBar alloc] init];
    tabBar.delegate = self;
//    tabBar.delegateTwo = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
    self.bar = tabBar;
    [[UITabBar appearance] setTranslucent:NO];
}

#pragma mark - UITabBarDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    if (IsStrEmpty(item.title)) {
        self.bar.plusBtn.selected = YES;
    }else{
        self.bar.plusBtn.selected = NO;
    }
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    // 确保当前在回话列表界面
    if ([tabBarController.selectedViewController isEqual:tabBarController.viewControllers[1]]) {
        // ! 即将选中的页面是之前上一次选中的控制器页面
        if (![viewController isEqual:tabBarController.selectedViewController]) {
            return YES;
        }
        
        // 获取当前点击时间
        NSDate *currentDate = [NSDate date];
        CGFloat timeInterval = currentDate.timeIntervalSince1970 - _lastSelectedDate.timeIntervalSince1970;
        
        // 两次点击时间间隔少于 0.5S 视为一次双击
        if (timeInterval < 0.5) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ConversationTabBarItemDoubleClick" object:nil];
            // 双击之后将上次选中时间置为1970年0点0时0分0秒,用以避免连续三次或多次点击
            _lastSelectedDate = [NSDate dateWithTimeIntervalSince1970:0];
            return NO;
        }
        // 若是单击将当前点击时间复制给上一次单击时间
        _lastSelectedDate = currentDate;
        
    }
    
    return YES;
}


- (void)jumpWithModel:(TFModuleModel *)model{
    
    HQLog(@"============%@===========",NSStringFromClass([self.selectedViewController class]));
    
    if ([model.english_name isEqualToString:@"add"]) {
        
        TFModelEnterController *enter = [[TFModelEnterController alloc] init];
        enter.type = 4;
        enter.hidesBottomBarWhenPushed = YES;
        [self.selectedViewController pushViewController:enter animated:YES];
        
    }else if ([model.english_name isEqualToString:@"project"]) {
        
        TFCreateProjectController *createPro = [[TFCreateProjectController alloc] init];
        createPro.type = 0;
        createPro.hidesBottomBarWhenPushed = YES;
        [self.selectedViewController pushViewController:createPro animated:YES];
        
    }else if ([model.english_name isEqualToString:@"memo"]){
        
        TFCreateNoteController *createVC = [[TFCreateNoteController alloc] init];
        createVC.type = 0;
        createVC.hidesBottomBarWhenPushed = YES;
        [self.selectedViewController pushViewController:createVC animated:YES];
        
        
    }else if ([model.english_name isEqualToString:@"library"]){
        
        TFFileMenuController *menu = [[TFFileMenuController alloc] init];
        menu.hidesBottomBarWhenPushed = YES;
        [self.selectedViewController pushViewController:menu animated:YES];
        
        
    }else if ([model.english_name isEqualToString:@"approval"]){
        
        TFModelEnterController *enter = [[TFModelEnterController alloc] init];
        enter.type = 2;
        enter.hidesBottomBarWhenPushed = YES;
        [self.selectedViewController pushViewController:enter animated:YES];
        
    }else if ([model.english_name isEqualToString:@"email"]){
        
        TFEmailsNewController *newEmail = [[TFEmailsNewController alloc] init];
        
        newEmail.hidesBottomBarWhenPushed = YES;
        [self.selectedViewController pushViewController:newEmail animated:YES];
        
    }else{
        TFAddCustomController *add = [[TFAddCustomController alloc] init];
        add.type = 0;
        add.tableViewHeight = SCREEN_HEIGHT - 64;
        add.bean = model.english_name;
        add.hidesBottomBarWhenPushed = YES;
        [self.selectedViewController pushViewController:add animated:YES];
    }
}

-(void)tabBarDidClickedPlusButtonWithTabBar:(TFTabBar *)tabBar button:(UIButton *)button{
    
    TFPlusController *plusVc = [[TFPlusController alloc] init];
    plusVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.definesPresentationContext = YES;
    plusVc.parameterAction = ^(TFModuleModel *model) {
        
        [self jumpWithModel:model];
    };
    [self presentViewController:plusVc animated:NO completion:nil];
    
}

#pragma mark - tabBar代理方法
//- (void)tabBar:(HQTabBar *)tabBar DidClickedPlusButton:(UIButton *)plusButton{
//    
//    
//    TFPlusController *plusVc = [[TFPlusController alloc] init];
//    plusVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    self.definesPresentationContext = YES;
//    plusVc.parameterAction = ^(TFModuleModel *model) {
//      
//        [self jumpWithModel:model];
//    };
//    [self presentViewController:plusVc animated:NO completion:nil];
//    
//}

/** 添加子控制器 */
- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    
//     设置tabBarItem的普通文字颜色(预留)
        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
        textAttrs[NSForegroundColorAttributeName] = RGBColor(106,106,106);
        textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
        [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
        // 设置tabBarItem的选中文字颜色(预留)
        NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
//    selectedTextAttrs[NSForegroundColorAttributeName] = RGBColor(74, 182, 125);
    selectedTextAttrs[NSForegroundColorAttributeName] = RGBColor(38,138,228);
        [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    
    // 设置标题相当于同时设置了tabBarItem.title和navigationItem.title
    childVc.title = title;
    //这里是设置tabbar的消息小圆点
    //childVc.tabBarItem.badgeValue=@"3";
    // 设置图标
    // 设置选中的图标
    UIImage *normalImage = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (IOS7_AND_LATER) {
        // 声明这张图片用原图(别渲染)
        normalImage  = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    childVc.tabBarItem.image = normalImage;
    childVc.tabBarItem.selectedImage = selectedImage;
    
    // 添加为tabbar控制器的子控制器
    HQBaseNavigationController *nav = [[HQBaseNavigationController alloc] initWithRootViewController:childVc];
    
    
    [self addChildViewController:nav];
    
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
