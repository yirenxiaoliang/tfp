//
//  TFAttendanceTabbarController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAttendanceTabbarController.h"
#import "TFPunchCardController.h"
#import "TFAttendanceStatisticsController.h"
#import "TFAttendanceSetController.h"
#import "TFChartsMainController.h"
#import "TFSelectDateView.h"
#import "TFAttendanceBL.h"
#import "TFPCSettingDetailMocel.h"
#import "TFCustomBL.h"
#import "TFApprovalAttemdanceController.h"
#import "TFPCRuleController.h"

@interface TFAttendanceTabbarController ()<UITabBarDelegate,HQBLDelegate>

/** tarBar */
@property (nonatomic, strong) UITabBar *tabBar;

/** items */
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, assign) long long timeSp;

@property (nonatomic, strong) TFCustomBL *customBL;

@end

@implementation TFAttendanceTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.timeSp = [HQHelper getNowTimeSp];
    self.enablePanGesture = YES;
    NSNumber *roleType = [[NSUserDefaults standardUserDefaults] valueForKey:@"RoleType"];
    if (!([roleType isEqualToNumber:@2] || [roleType isEqualToNumber:@3])) {
    
        self.customBL = [TFCustomBL build];
        self.customBL.delegate = self;
        [self.customBL requestGetAuthSystemStableModule];
    }

    TFPunchCardController *punchCard = [[TFPunchCardController alloc] init];

    [self addChildViewController:punchCard];
    punchCard.view.frame = self.view.bounds;
    [self.view addSubview:punchCard.view];
    
    TFApprovalAttemdanceController *approval = [[TFApprovalAttemdanceController alloc] init];
    [self addChildViewController:approval];
    
    TFAttendanceStatisticsController *attendanceStatistics = [[TFAttendanceStatisticsController alloc] init];

    [self addChildViewController:attendanceStatistics];
    
    
    if ([roleType isEqualToNumber:@2] || [roleType isEqualToNumber:@3]) {
//        TFAttendanceSetController *attendanceSet = [[TFAttendanceSetController alloc] init];
        TFPCRuleController *attendanceSet = [[TFPCRuleController alloc] init];
        
        [self addChildViewController:attendanceSet];
        
    }
    
    
    NSMutableArray<UITabBarItem *> *arr = [NSMutableArray<UITabBarItem *> array];
    self.items = arr;
    
    [arr addObject:[self addOneItemWithTitle:@"打卡" imageName:@"打卡未点击" selectedImageName:@"打卡点击" tag:0]];
    [arr addObject:[self addOneItemWithTitle:@"审批" imageName:@"审批attend" selectedImageName:@"审批attendance" tag:1]];
    
    [arr addObject:[self addOneItemWithTitle:@"统计" imageName:@"未点击统计" selectedImageName:@"点击统计" tag:2]];
    
    if ([roleType isEqualToNumber:@2] || [roleType isEqualToNumber:@3]) {
        [arr addObject:[self addOneItemWithTitle:@"设置" imageName:@"设置未点击" selectedImageName:@"设置点击" tag:3]];
    }
    
    self.tabBar = [[UITabBar alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-NaviHeight-TabBarHeight-BottomM,SCREEN_WIDTH,TabBarHeight}];
    self.tabBar.items = self.items;
    self.tabBar.delegate = self;
    [self.view addSubview:self.tabBar];
    [self.tabBar setSelectedItem:self.items[0]];
    
    [self setupNavigationWithTag:0];
    
//    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(changeDate) text:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"] textColor:GreenColor];
    self.navigationItem.rightBarButtonItem = nil;
    
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getSystemStableModule) {
        
        BOOL have = NO;
        NSArray *arr = resp.body;
        for (NSDictionary *dict in arr) {
            if ([[dict valueForKey:@"bean"] isEqualToString:@"attendance"]) {
                have = YES;
                break;
            }
        }
        
        if (have) {
            
//            TFAttendanceSetController *attendanceSet = [[TFAttendanceSetController alloc] init];
            TFPCRuleController *attendanceSet = [[TFPCRuleController alloc] init];
            
            [self addChildViewController:attendanceSet];
            
            [self.items addObject:[self addOneItemWithTitle:@"设置" imageName:@"设置未点击" selectedImageName:@"设置点击" tag:3]];
            
            self.tabBar.items = self.items;
        }
        
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

-(void)changeDate{
    
    [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDay timeSp:self.timeSp onRightTouched:^(NSString *time) {
        
        long long che = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd"];
        long long now = [HQHelper changeTimeToTimeSp:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"] formatStr:@"yyyy-MM-dd"];
        if (che > now) {
            [MBProgressHUD showError:@"不能查看将来的数据" toView:self.view];
            return ;
        }
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(changeDate) text:time textColor:GreenColor];
        
        self.timeSp = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PutchDardChangeTime" object:@(self.timeSp)];
        
    }];
}

- (void)setupNavigationWithTag:(NSInteger)tag{
    
    
    if (tag == 0) {
        
        self.navigationItem.title = @"打卡";
//        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(changeDate) text:[HQHelper nsdateToTime:self.timeSp formatStr:@"yyyy-MM-dd"] textColor:GreenColor];
        self.navigationItem.rightBarButtonItem = nil;
    }
    else if (tag == 1) {
        
        self.navigationItem.title = @"审批";
        UIBarButtonItem *add = nil;
        
        self.navigationItem.rightBarButtonItem = add;
    }
    else if (tag == 2) {
        
        self.navigationItem.title = @"统计";
        UIBarButtonItem *add = [self itemWithTarget:self action:@selector(chartAction) image:@"奖杯" highlightImage:@"奖杯"];
        
        self.navigationItem.rightBarButtonItem = add;
    }
    else if (tag == 3) {
        
        self.navigationItem.title = @"设置";
        self.navigationItem.rightBarButtonItem = nil;
        
    }

    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    
    for (HQBaseViewController *vc in self.childViewControllers) {
        
        [vc.view removeFromSuperview];
        
        
    }
    HQBaseViewController *vc  = self.childViewControllers[item.tag];
    [self.view insertSubview:vc.view atIndex:0];
    
    
    [self setupNavigationWithTag:item.tag];
    
    
}

/** 添加item */
- (UITabBarItem *)addOneItemWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName tag:(NSInteger)tag
{
    
    UITabBarItem *item = [[UITabBarItem alloc] init];
    item.title = title;
    item.tag = tag;
    
    //     设置tabBarItem的普通文字颜色(预留)
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = RGBColor(106,106,106);
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置tabBarItem的选中文字颜色(预留)
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = RGBColor(38,138,228);
    [item setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    // 设置选中的图标
    UIImage *normalImage = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (IOS7_AND_LATER) {
        // 声明这张图片用原图(别渲染)
        normalImage  = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    item.image = normalImage;
    item.selectedImage = selectedImage;
    
    return  item;
    
}

- (void)chartAction {
    
    TFChartsMainController *chartsMainVC = [[TFChartsMainController alloc] init];
    
    [self.navigationController pushViewController:chartsMainVC animated:YES];
    
}

@end
