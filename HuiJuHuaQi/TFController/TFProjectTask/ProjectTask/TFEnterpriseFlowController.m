//
//  TFEnterpriseFlowController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/22.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEnterpriseFlowController.h"
#import "TFBenchView.h"
#import "TFProjectSectionModel.h"
#import "TFEndlessView.h"
#import "YPTabBar.h"
#import "TFProjectRowFrameModel.h"
#import "TFLoginBL.h"
#define ADHEIGHT 160

@interface TFEnterpriseFlowController ()<TFBenchViewDelegate,YPTabBarDelegate,HQBLDelegate>

/** moving */
@property (nonatomic, assign) BOOL moving;
/** tabBar */
@property (nonatomic, strong) YPTabBar *tabBar;
/** endlessScrollView */
@property (nonatomic, strong) TFEndlessView *endlessScrollView;

/** moveView */
@property (nonatomic, weak) TFBenchView *moveView;

/** lastPoint */
@property (nonatomic, assign) CGFloat lastPoint;
/** currentPoint */
@property (nonatomic, assign) CGFloat currentPoint;

/** TFLoginBL */
@property (nonatomic, strong) TFLoginBL *loginBL;

/** banners */
@property (nonatomic, strong) NSArray *banners;

@end

@implementation TFEnterpriseFlowController

-(TFEndlessView *)endlessScrollView{
    if (!_endlessScrollView) {
        _endlessScrollView = [[TFEndlessView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,ADHEIGHT}];
    }
    return _endlessScrollView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.loginBL requestGetBanner];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){SCREEN_WIDTH,0.5}]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getBanner) {
        
        self.banners = resp.body;
        [self.endlessScrollView refreshEndlessViewWithImages:self.banners];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    //    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
    [self.loginBL requestGetBanner];
    
    [self.view addSubview:self.endlessScrollView];
    [self.view addSubview:self.tabBar];
    
    self.enablePanGesture = NO;
    TFBenchView *moveView = [[TFBenchView alloc] initWithFrame:CGRectMake(0, ADHEIGHT+44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomHeight-44)];
    moveView.delegate = self;
    [self.view insertSubview:moveView atIndex:0];
    self.moveView = moveView;
    
    [self refreshEnterpriseFlow];
}

- (void)refreshEnterpriseFlow{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < 6; i++) {
        TFProjectSectionModel *model = [[TFProjectSectionModel alloc] init];
        model.name = [NSString stringWithFormat:@"企业流%ld",i];
        
        NSMutableArray<TFProjectRowModel> *tasks = [NSMutableArray<TFProjectRowModel> array];
        NSMutableArray *frames = [NSMutableArray array];
        for (NSInteger j = 0; j < 10; j ++) {
            TFProjectRowModel *task = [[TFProjectRowModel alloc] init];
            task.name = [NSString stringWithFormat:@"我是名字%ld",j];
            task.hidden = @"0";
            
            task.urgeType = @(j % 2);
            task.finishType = @(j % 2);
            task.taskName = [NSString stringWithFormat:@"我是任务名称我是任务名称我是任务名称我是任务名称我是任务名称我是任务名称我是任务名称%ld",j];
            task.activeNum = @((j % 2)*5);
            
            if (j % 3 == 0) {
                
                task.startTime = @([HQHelper getNowTimeSp]);
                task.endTime = @([HQHelper getNowTimeSp] + 1000 * 24 * 60 * 60 * 2);
            }else if (j % 3 == 1) {
                
                task.endTime = @([HQHelper getNowTimeSp] + 1000 * 24 * 60 * 60 * 2);
                
            }else{
                
                task.endTime = @([HQHelper getNowTimeSp] - 1000 * 24 * 60 * 60 * j);
                
            }
            
            task.childTaskNum = @100;
            
            task.finishChildTaskNum = @(j % 5);
            
            TFEmployModel *model = [[TFEmployModel alloc] init];
            model.id = UM.userLoginInfo.employee.id;
            model.employee_name = UM.userLoginInfo.employee.employee_name;
            model.picture = UM.userLoginInfo.employee.picture;
            task.responsibler = model;
            
            NSArray *sss = @[@"",@"我",@"是好",@"人么呀",@"打底裤的"];
            NSMutableArray *ops = [NSMutableArray array];
            for (NSInteger l = 0; l < (j % 5); l ++) {
                
                TFCustomerOptionModel *opti = [[TFCustomerOptionModel alloc] init];
                opti.color = @"#12e456";
                opti.label = [NSString stringWithFormat:@"%@%ld",sss[arc4random_uniform(5)],l];
                [ops addObject:opti];
            }
            task.tagList = ops;
            
            TFProjectRowFrameModel *frame = [[TFProjectRowFrameModel alloc] init];
            frame.projectRow = task;
            [frames addObject:frame];
            
            [tasks addObject:task];
        }
        model.frames = frames;
        model.tasks = tasks;
        [arr addObject:model];
    }
    
    [self.moveView refreshMoveViewWithModels:arr withType:0];
    self.moveView.backgroundColor = WhiteColor;
    self.view.backgroundColor = WhiteColor;
    
    
    // 刷新tabbar
    NSMutableArray<YPTabItem *> *items = [NSMutableArray<YPTabItem *> array];
    for (NSInteger i = 0; i < arr.count; i++) {
        TFProjectSectionModel *model = arr[i];
        YPTabItem *item = [[YPTabItem alloc] init];
        item.title = model.name;
        [items addObject:item];
    }
    self.tabBar.items = items;
    self.tabBar.selectedItemIndex = 0;
    
}

-(YPTabBar *)tabBar{
    
    if (!_tabBar) {
        _tabBar = [[YPTabBar alloc] initWithFrame:(CGRect){0,ADHEIGHT,SCREEN_WIDTH,44}];
        [self.view addSubview:_tabBar];
        _tabBar.delegate = self;
        _tabBar.itemTitleColor = HexColor(0x909090);
        _tabBar.itemTitleSelectedColor = GreenColor;
        _tabBar.itemTitleFont = [UIFont systemFontOfSize:16];
        _tabBar.itemTitleSelectedFont = FONT(16);
        _tabBar.selectedItemIndex = 0 ;
        _tabBar.leftAndRightSpacing = 20;
        _tabBar.backgroundColor = WhiteColor;
        [_tabBar setScrollEnabledAndItemWidth:(SCREEN_WIDTH-40)/4];
        
        [_tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(42, (SCREEN_WIDTH-40)/4-10, 0, (SCREEN_WIDTH-40)/4-10) tapSwitchAnimated:NO];
        _tabBar.itemSelectedBgColor = GreenColor;
        
        
    }
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,0.5}];
    [_tabBar addSubview:line];
    line.backgroundColor = HexColor(0xAFAFAF);
    _tabBar.layer.masksToBounds = NO;
    
    return _tabBar;
}
#pragma mark - YPTabBarDelegate
-(void)yp_tabBar:(YPTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index{
    
    if (self.moving)return;
    
    self.moveView.selectPage = index;
}

#pragma mark - TFMoveViewDelegate
-(void)moveView:(TFBenchView *)moveView changePage:(NSInteger)page{
    
    self.tabBar.selectedItemIndex = page;
}

-(void)moveViewWillMoing{
    self.moving = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.tabBar.y = 0;
        self.endlessScrollView.bottom = self.tabBar.top;
        self.moveView.top = self.tabBar.bottom;
    }];
}

-(void)moveView:(TFBenchView *)moveView dataChanged:(NSArray *)models destinationIndex:(NSInteger)destinationIndex{
    
    self.moving = NO;
}

-(void)moveView:(TFBenchView *)moveView scrollView:(UIScrollView *)scrollView{
    
    //    HQLog(@"===========%f=========",scrollView.contentOffset.y);
    
    if (self.moving) return;
    
    if (scrollView.contentOffset.y < 0 ) {
        
        if (self.tabBar.y == 0) {
            [UIView animateWithDuration:0.25 animations:^{
                
                self.endlessScrollView.y = 0;
                self.tabBar.top = self.endlessScrollView.bottom;
                self.moveView.top = self.tabBar.bottom;
            }];
        }
        return;
    }
    
    if (scrollView.contentOffset.y+self.moveView.height >= scrollView.contentSize.height) {
        return;
    }
    
    self.currentPoint = scrollView.contentOffset.y;
    
    if (self.lastPoint >= self.currentPoint) {// 往下走
        
        self.endlessScrollView.y += (self.lastPoint - self.currentPoint);
        self.tabBar.y += (self.lastPoint - self.currentPoint);
        if (self.endlessScrollView.y >= 0) {
            self.endlessScrollView.y = 0;
        }
        self.tabBar.top = self.endlessScrollView.bottom;
        self.moveView.top = self.tabBar.bottom;
    }else{// 往上走
        
        self.endlessScrollView.y -= (self.currentPoint - self.lastPoint);
        self.tabBar.y -= (self.currentPoint - self.lastPoint);
        if (self.tabBar.y <= 0) {
            self.tabBar.y = 0;
        }
        self.endlessScrollView.bottom = self.tabBar.top;
        self.moveView.top = self.tabBar.bottom;
        
    }
    
    self.lastPoint = self.currentPoint;
    
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
