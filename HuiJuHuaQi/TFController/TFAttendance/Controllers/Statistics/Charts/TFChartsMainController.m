//
//  TFChartsMainController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChartsMainController.h"
#import "TFChartsSubController.h"
#import "TFAttendanceBL.h"
#import "TFGroupListModel.h"
#import "PopoverView.h"

@interface TFChartsMainController ()<HQBLDelegate,YPTabBarDelegate>
@property (nonatomic, strong) TFAttendanceBL *attendanceBL;

@property (nonatomic, strong) TFGroupListModel *model;
@property (nonatomic, strong) TFAttendanceGroupModel *ruleModel;
@end

@implementation TFChartsMainController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationItem.title = @"排行榜";
    [self setTabBarFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)
        contentViewFrame:CGRectMake(0, 44.5, SCREEN_WIDTH,SCREEN_HEIGHT-64-45)];
    
    self.tabBar.itemTitleColor = HexColor(0x909090);
    self.tabBar.itemTitleSelectedColor = HexAColor(0x3689e9, 1);
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:14];
    self.tabBar.itemTitleSelectedFont = FONT(14);
    self.tabBar.leftAndRightSpacing = 20;
    self.tabBar.delegate = self;
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = HexAColor(0x3689e9, 1);
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(42, 0, 0, 0) tapSwitchAnimated:NO];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    self.loadViewOfChildContollerWhileAppear = YES;
    self.interceptRightSlideGuetureInFirstPage = YES;
    
    [self.tabBar setScrollEnabledAndItemWidth:(SCREEN_WIDTH-40)/3];
    
    
    [self initViewControllers];
    
    UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,0.5}];
    [self.view addSubview:lineView];
    lineView.backgroundColor = CellSeparatorColor;
    
    self.attendanceBL = [TFAttendanceBL build];
    self.attendanceBL.delegate = self;
    
    [self.attendanceBL requestAttendanceGroupList];
    
    self.selectedControllerIndex = 2;
    self.selectedControllerIndex = 1;
    self.selectedControllerIndex = 0;
}

//-(void)yp_tabBar:(YPTabBar *)tabBar willSelectItemAtIndex:(NSUInteger)index{
////    if (self.ruleModel) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"AttendanceGroupList" object:self.ruleModel];
////    }
//}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_attendanceGroupList) {
        
        self.model = resp.body;
        TFAttendanceGroupModel *mo = nil;
        if (!self.model.list_set_type || [self.model.list_set_type isEqualToNumber:@0]) {
            mo = self.model.dataList.firstObject;
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(group) text:@"考勤组"];
            self.ruleModel = mo;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AttendanceGroupList" object:mo];
    }
}

-(void)group{
    
    NSMutableArray *strs = [NSMutableArray array];
    for (TFAttendanceGroupModel *model in self.model.dataList) {
        [strs addObject:model.name];
    }
    
    PopoverView *pop = [[PopoverView alloc] initWithPoint:CGPointMake(SCREEN_WIDTH-10, 64) titles:strs images:nil];
    pop.selectRowAtIndex = ^(NSInteger index) {
        
        TFAttendanceGroupModel *mo = self.model.dataList[index];
        self.ruleModel = mo;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AttendanceGroupList" object:mo];
    };
    
    [pop show];
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}



- (void)initViewControllers {
    
    
    TFChartsSubController *controller1 = [[TFChartsSubController alloc] init];
    controller1.type = 0;
    controller1.yp_tabItemTitle = @"早到榜";
    
    TFChartsSubController *controller2 = [[TFChartsSubController alloc] init];
    controller2.type = 1;
    controller2.yp_tabItemTitle = @"勤勉榜";
    
    TFChartsSubController *controller3 = [[TFChartsSubController alloc] init];
    controller3.type = 2;
    controller3.yp_tabItemTitle = @"迟到榜";
    
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, nil];
}

@end
