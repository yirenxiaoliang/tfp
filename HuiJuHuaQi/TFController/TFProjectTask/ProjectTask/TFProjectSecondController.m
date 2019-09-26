//
//  TFProjectSecondController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectSecondController.h"
#import "YPTabBar.h"
#import "TFMoveView.h"
#import "TFProjectSectionModel.h"
#import "TFSectionListController.h"

@interface TFProjectSecondController ()<YPTabBarDelegate,TFMoveViewDelegate>
/** tabBar */
@property (nonatomic, strong) YPTabBar *tabBar;
/** moveView */
@property (nonatomic, strong) TFMoveView *moveView;
/** moving */
@property (nonatomic, assign) BOOL moving;

/** sectionIndex */
@property (nonatomic, assign) NSInteger sectionIndex;


@end

@implementation TFProjectSecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

-(YPTabBar *)tabBar{
    
    if (!_tabBar) {
        _tabBar = [[YPTabBar alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
        [self.view addSubview:_tabBar];
        _tabBar.delegate = self;
        _tabBar.itemTitleColor = HexColor(0x909090);
        _tabBar.itemTitleSelectedColor = HexAColor(0x3689e9, 1);
        _tabBar.itemTitleFont = [UIFont systemFontOfSize:14];
        _tabBar.itemTitleSelectedFont = FONT(14);
        _tabBar.selectedItemIndex = 0 ;
        _tabBar.leftAndRightSpacing = 10;
        _tabBar.rightSpacing = 40;
        _tabBar.backgroundColor = WhiteColor;
        [_tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:20];
        
        UIButton *button = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH-40,0,40,43} target:self action:@selector(buttonClick)];
        button.backgroundColor = WhiteColor;
        [self.view insertSubview:button aboveSubview:_tabBar];
        [button setImage:[UIImage imageNamed:@"taskMenu"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"taskMenu"] forState:UIControlStateHighlighted];
        button.layer.shadowOffset = CGSizeMake(-20, -5);
        button.layer.shadowColor = CellSeparatorColor.CGColor;
        button.layer.shadowRadius = 10;
        button.layer.shadowOpacity = 0.5;
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,0.5}];
        [self.view addSubview:lineView];
        lineView.backgroundColor = CellSeparatorColor;
        
    }
    return _tabBar;
}

- (void)buttonClick{
    TFSectionListController *taskColumn = [[TFSectionListController alloc] init];
    taskColumn.projectId = self.projectId;
    taskColumn.projectColumnModel = self.projectColumnModel;
    taskColumn.refreshAction = ^{
        
        if (self.refreshAction) {
            self.refreshAction();
        }
    };
    [self.navigationController pushViewController:taskColumn animated:YES];
}

-(TFMoveView *)moveView{
    
    if (!_moveView) {
        _moveView = [[TFMoveView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44-44-BottomHeight)];
        _moveView.delegate = self;
        [self.view insertSubview:_moveView atIndex:0];
    }
    return _moveView;
}

#pragma mark - YPTabBarDelegate
-(void)yp_tabBar:(YPTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index{
    
    if (self.moving)return;
    
    self.moveView.selectPage = index;
    
    self.sectionIndex = index;
    
    if (self.indexAction) {
        self.indexAction(@(index));
    }
    
}

#pragma mark - TFMoveViewDelegate
-(void)moveView:(TFMoveView *)moveView changePage:(NSInteger)page{

    self.tabBar.selectedItemIndex = page;
}

-(void)moveViewWillMoing{
    self.moving = YES;
}

-(void)moveView:(TFMoveView *)moveView dataChanged:(NSArray *)models destinationIndex:(NSInteger)destinationIndex{

    self.moving = NO;
}

- (void)setupViews{
    
//    // 初始化假数据
//    NSMutableArray *arr = [NSMutableArray array];
//    for (NSInteger i = 0; i < 4; i++) {
//        TFProjectSectionModel *model = [[TFProjectSectionModel alloc] init];
//        model.title = [NSString stringWithFormat:@"研发%ld",i];
//        
//        NSMutableArray<TFProjectRowModel> *tasks = [NSMutableArray<TFProjectRowModel> array];
//        for (NSInteger j = 0; j < 10; j ++) {
//            TFProjectRowModel *task = [[TFProjectRowModel alloc] init];
//            task.name = [NSString stringWithFormat:@"我是名字%ld",j];
//            task.hidden = @"0";
//            [tasks addObject:task];
//        }
//        model.tasks = tasks;
//        [arr addObject:model];
//    }
    
    // 刷新tabbar
    NSMutableArray<YPTabItem *> *items = [NSMutableArray<YPTabItem *> array];
    for (NSInteger i = 0; i < self.projectColumnModel.subnodeArr.count; i++) {
        YPTabItem *item = [[YPTabItem alloc] init];
        TFProjectSectionModel *model = self.projectColumnModel.subnodeArr[i];
        item.title = model.name;
        [items addObject:item];
    }
    self.tabBar.items = items;
    self.tabBar.selectedItemIndex = 0;
    
    // 初始化移动View
    [self.moveView refreshMoveViewWithModels:self.projectColumnModel.subnodeArr withType:0];
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
