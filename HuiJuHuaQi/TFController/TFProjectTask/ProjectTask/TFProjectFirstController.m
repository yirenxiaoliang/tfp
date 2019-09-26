//
//  TFProjectFirstController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectFirstController.h"
#import "TFProjectSecondController.h"
#import "TFCreateTaskController.h"
#import "TFColumnListController.h"
#import "TFProjectTaskBL.h"
#import "TFProjectColumnModel.h"
#import "HQTFNoContentView.h"
#import "YPTabBar.h"

@interface TFProjectFirstController ()<HQBLDelegate,YPTabBarDelegate>
/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** addButton */
@property (nonatomic, strong) UIButton *addButton;

/** columns */
@property (nonatomic, strong) NSArray *columns;

/** columnIndex */
@property (nonatomic, assign) NSInteger columnIndex;
/** sectionIndex */
@property (nonatomic, assign) NSInteger sectionIndex;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** tabBar */
@property (nonatomic, strong) YPTabBar *tabBar;

@end

@implementation TFProjectFirstController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.view.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}

-(UIButton *)addButton{
    if (!_addButton) {
        _addButton = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH-NaviHeight,SCREEN_HEIGHT-NaviHeight-BottomHeight-30-44,44,44} target:self action:@selector(addButtonClick)];
        [self.view addSubview:_addButton];
        [_addButton setImage:[UIImage imageNamed:@"projectAdd"] forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"projectAdd"] forState:UIControlStateHighlighted];
    }
    return _addButton;
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
        [_tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(42, 10, 0, 10) tapSwitchAnimated:NO];
        _tabBar.itemSelectedBgColor = HexAColor(0x3689e9, 1);
        
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [self.projectTaskBL requestGetProjectAllDotWithProjectId:self.projectId];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)setupChildVcWithColumn:(NSArray *)columns{
    
    
    // 刷新tabbar
    NSMutableArray<YPTabItem *> *items = [NSMutableArray<YPTabItem *> array];
    for (NSInteger i = 0; i < columns.count; i++) {
        YPTabItem *item = [[YPTabItem alloc] init];
        TFProjectColumnModel *model = columns[i];
        item.title = model.name;
        [items addObject:item];
    }
    
    [self initViewControllersWithColumn:columns];
    
    self.tabBar.items = items;
    self.tabBar.selectedItemIndex = 0;
    
    if (columns.count) {
        [self.noContentView removeFromSuperview];
        TFProjectColumnModel *model = columns[0];
        if (model.subnodeArr.count) {
            [self.view insertSubview:self.addButton atIndex:self.view.subviews.count-1];
        }
    }else{
        [self.addButton removeFromSuperview];
        [self.view insertSubview:self.noContentView atIndex:self.view.subviews.count-1];
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjectAllDot) {
        
        NSArray *columns = resp.body;
        self.columns = columns;
        
        [self setupChildVcWithColumn:columns];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

#pragma mark - YPTabBarDelegate
-(void)yp_tabBar:(YPTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index{
    
    self.columnIndex = index;
    
    for (TFProjectSecondController *vc in self.childViewControllers) {
        [vc.view removeFromSuperview];
    }
    
    TFProjectSecondController *vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(0, 44.5, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44-BottomHeight);
    [self.view addSubview:vc.view];
    
    
    TFProjectColumnModel *model = self.columns[index];
    if (model.subnodeArr.count) {
        [self.view insertSubview:self.addButton aboveSubview:vc.view];
    }else{
        [self.addButton removeFromSuperview];
    }
}

- (void)buttonClick{
    TFColumnListController *taskColumn = [[TFColumnListController alloc] init];
    taskColumn.columns = self.columns;
    taskColumn.projectId = self.projectId;
    taskColumn.refreshAction = ^{
      
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requestGetProjectAllDotWithProjectId:self.projectId];
        
    };
    [self.navigationController pushViewController:taskColumn animated:YES];
}

- (void)addButtonClick{
    TFCreateTaskController *createTask = [[TFCreateTaskController alloc] init];
    [self.navigationController pushViewController:createTask animated:YES];
}


- (void)initViewControllersWithColumn:(NSArray *)columns {
    
    for (TFProjectSecondController *vc in self.childViewControllers) {
        
        [vc removeFromParentViewController];
        [vc.view removeFromSuperview];
    }
    
    for (TFProjectColumnModel *model in columns) {

        TFProjectSecondController *controller = [[TFProjectSecondController alloc] init];
        controller.projectId = self.projectId;
        controller.projectColumnModel = model;
        controller.indexAction = ^(NSNumber *parameter) {

            self.sectionIndex = [parameter integerValue];

        };
        controller.refreshAction = ^{
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.projectTaskBL requestGetProjectAllDotWithProjectId:self.projectId];
            
        };
        [self addChildViewController:controller];
    }
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
