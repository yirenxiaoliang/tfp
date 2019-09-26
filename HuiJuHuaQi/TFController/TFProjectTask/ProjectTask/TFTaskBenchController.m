//
//  TFTaskBenchController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/16.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskBenchController.h"
//#import "TFEndlessScrollView.h"
#import "YPTabBar.h"
#import "TFMoveView.h"
#import "TFProjectSectionModel.h"
#import "TFProjectBenchController.h"

#define ADHEIGHT Long(105)

@interface TFTaskBenchController ()<YPTabBarDelegate,TFMoveViewDelegate>

/** endlessScrollView */
//@property (nonatomic, strong) TFEndlessScrollView *endlessScrollView;

/** tabBar */
@property (nonatomic, strong) YPTabBar *tabBar;

/** moveView */
@property (nonatomic, strong) TFMoveView *moveView;

@end

@implementation TFTaskBenchController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enablePanGesture = NO;
    [self.view addSubview:self.moveView];
//    [self.view addSubview:self.endlessScrollView];
//    [self.view addSubview:self.tabBar];
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(ccc) text:@"good"];
}
- (void)ccc{
    TFProjectBenchController *bench = [[TFProjectBenchController alloc] init];
    [self.navigationController pushViewController:bench animated:YES];
}


//-(TFEndlessScrollView *)endlessScrollView{
//    if (!_endlessScrollView) {
//        _endlessScrollView = [[TFEndlessScrollView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,ADHEIGHT}];
//    }
//    return _endlessScrollView;
//}

-(TFMoveView *)moveView{
    
    if (!_moveView) {
        _moveView = [[TFMoveView alloc] initWithFrame:CGRectMake(0, ADHEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-NaviHeight-44)];
        _moveView.delegate = self;
        
        
        // 初始化假数据
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++) {
            TFProjectSectionModel *model = [[TFProjectSectionModel alloc] init];
            model.name = [NSString stringWithFormat:@"研发%ld",i];
            
            NSMutableArray<TFProjectRowModel> *tasks = [NSMutableArray<TFProjectRowModel> array];
            for (NSInteger j = 0; j < 6; j ++) {
                TFProjectRowModel *task = [[TFProjectRowModel alloc] init];
                task.name = [NSString stringWithFormat:@"我是名字%ld",j];
                task.hidden = @"0";
                [tasks addObject:task];
            }
            model.tasks = tasks;
            [arr addObject:model];
            
            
            // 初始化移动View
            [self.moveView refreshMoveViewWithModels:arr withType:1];
        }
    }
    return _moveView;
}

-(YPTabBar *)tabBar{
    
    if (!_tabBar) {
        _tabBar = [[YPTabBar alloc] initWithFrame:(CGRect){0,ADHEIGHT,SCREEN_WIDTH,44}];
        [self.view addSubview:_tabBar];
        _tabBar.delegate = self;
        _tabBar.itemTitleColor = HexColor(0x909090);
        _tabBar.itemTitleSelectedColor = HexAColor(0x3689e9, 1);
        _tabBar.itemTitleFont = [UIFont systemFontOfSize:14];
        _tabBar.itemTitleSelectedFont = FONT(14);
        _tabBar.selectedItemIndex = 0 ;
        _tabBar.leftAndRightSpacing = 20;
        _tabBar.backgroundColor = WhiteColor;
        [_tabBar setScrollEnabledAndItemWidth:(SCREEN_WIDTH-40)/4];
        
        [_tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(42, (SCREEN_WIDTH-40)/8-10, 0, (SCREEN_WIDTH-40)/8-10) tapSwitchAnimated:NO];
        _tabBar.itemSelectedBgColor = HexAColor(0x3689e9, 1);
        
        // 刷新tabbar
        NSArray *arr = @[@"超期任务",@"今日任务",@"明日任务",@"以后任务"];
        NSMutableArray<YPTabItem *> *items = [NSMutableArray<YPTabItem *> array];
        for (NSInteger i = 0; i < arr.count; i++) {
            YPTabItem *item = [[YPTabItem alloc] init];
            item.title = arr[i];
            [items addObject:item];
        }
        self.tabBar.items = items;
        self.tabBar.selectedItemIndex = 0;
    }
    return _tabBar;
}

#pragma mark - YPTabBarDelegate
-(void)yp_tabBar:(YPTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index{
    
    
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
