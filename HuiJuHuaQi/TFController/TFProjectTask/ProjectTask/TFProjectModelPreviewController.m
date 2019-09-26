//
//  TFProjectModelPreviewController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectModelPreviewController.h"
#import "YPTabBar.h"
#import "TFProjectTaskBL.h"
#import "TFProjectColumnModel.h"
#import "TFProjectTemplatePreviewItemController.h"

@interface TFProjectModelPreviewController ()<YPTabBarDelegate,HQBLDelegate>
/** tabBar */
@property (nonatomic, strong) YPTabBar *tabBar;
/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** columns */
@property (nonatomic, strong) NSArray *columns;
@end

@implementation TFProjectModelPreviewController

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
        [_tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(42, 10, 0,10) tapSwitchAnimated:NO];
        self.tabBar.itemSelectedBgColor = HexAColor(0x3689e9, 1);
        
        UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,0.5}];
        [self.view addSubview:lineView];
        lineView.backgroundColor = CellSeparatorColor;
        
    }
    return _tabBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enablePanGesture = NO;
    self.view.backgroundColor = WhiteColor;
    self.view.layer.masksToBounds = YES;
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [self.projectTaskBL requestGetProjectTemplatePreviewWithTemplateId:self.templateId];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.navigationItem.title = @"项目模板";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    if (self.sureAction) {
        [self.navigationController popViewControllerAnimated:NO];
        self.sureAction();
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_projectTemplatePreview) {
        
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
    
}

- (void)initViewControllersWithColumn:(NSArray *)columns {
    
    for (TFProjectTemplatePreviewItemController *vc in self.childViewControllers) {
        
        [vc removeFromParentViewController];
        [vc.view removeFromSuperview];
    }
    
    for (NSInteger tag = 0; tag < columns.count; tag ++) {
        TFProjectColumnModel *model = columns[tag];
        TFProjectTemplatePreviewItemController *controller = [[TFProjectTemplatePreviewItemController alloc] init];
        controller.vcTag = tag;
        controller.projectColumnModel = model;
        [self addChildViewController:controller];
    }
}

#pragma mark - YPTabBarDelegate
-(void)yp_tabBar:(YPTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index{
    
    for (TFProjectTemplatePreviewItemController *vc in self.childViewControllers) {
        [vc.view removeFromSuperview];
    }
    
    TFProjectTemplatePreviewItemController *vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(0, 44.5, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44-BottomHeight);
    [self.view addSubview:vc.view];
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
