//
//  TFProjectBoardController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectBoardController.h"
#import "TFProjectSectionModel.h"
#import "YPTabBar.h"
#import "TFProjectTaskBL.h"
#import "HQTFNoContentView.h"
#import "TFProjectBoardItemController.h"
#import "TFColumnListController.h"
#import "TFTaskColumnAddController.h"
#import "TFCreateTaskRowController.h"

@interface TFProjectBoardController ()<YPTabBarDelegate,HQBLDelegate,UIActionSheetDelegate>
/** tabBar */
@property (nonatomic, strong) YPTabBar *tabBar;
/** button */
@property (nonatomic, strong) UIButton *button;
/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** columns */
@property (nonatomic, strong) NSArray *columns;

/** columnIndex */
@property (nonatomic, assign) NSInteger columnIndex;
/** sectionIndex */
@property (nonatomic, assign) NSInteger sectionIndex;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** privilege */
@property (nonatomic, copy) NSString *privilege;

/** auths */
@property (nonatomic, strong) NSMutableArray *auths;


@end

@implementation TFProjectBoardController

-(NSMutableArray *)auths{
    if (!_auths) {
        _auths = [NSMutableArray array];
    }
    return _auths;
}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.view.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}

-(UIButton *)button{
    if (!_button) {
        
        UIButton *button = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH-40,0,40,43} target:self action:@selector(buttonClick)];
        button.backgroundColor = WhiteColor;
        [self.view insertSubview:button aboveSubview:_tabBar];
        [button setImage:[UIImage imageNamed:@"taskMenu"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"taskMenu"] forState:UIControlStateHighlighted];
        button.layer.shadowOffset = CGSizeMake(-20, 0);
        button.layer.shadowColor = CellSeparatorColor.CGColor;
        button.layer.shadowRadius = 10;
        button.layer.shadowOpacity = 0.5;
        _button = button;
        
        if ([self.projectModel.temp_id integerValue] > 0) {// 使用模板无法编辑 201910118
            button.hidden = YES;
        }
    }
    return _button;
}


-(YPTabBar *)tabBar{
    
    if (!_tabBar) {
        _tabBar = [[YPTabBar alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
        [self.view addSubview:_tabBar];
        _tabBar.delegate = self;
        _tabBar.itemTitleColor = HexColor(0x909090);
        _tabBar.itemTitleSelectedColor = HexAColor(0x3689e9, 1);
//        _tabBar.itemTitleSelectedColor = WhiteColor;
        _tabBar.itemTitleFont = [UIFont systemFontOfSize:14];
        _tabBar.itemTitleSelectedFont = FONT(14);
        _tabBar.selectedItemIndex = 0 ;
        _tabBar.leftAndRightSpacing = 10;
        _tabBar.rightSpacing = 40;
        _tabBar.backgroundColor = WhiteColor;
//        _tabBar.itemSelectedBgImageView.layer.cornerRadius = 12;
//        _tabBar.itemSelectedBgImageView.layer.masksToBounds = YES;
        [_tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:20];
//        [_tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(10, 3, 10,3) tapSwitchAnimated:NO];
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
    [self.projectTaskBL requestGetProjectAllDotWithProjectId:self.projectId];// 节点
    [self.projectTaskBL requestGetProjectRoleAndAuthWithProjectId:self.projectId employeeId:UM.userLoginInfo.employee.id];// 权限
    
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
    
    [self.view insertSubview:self.button aboveSubview:self.tabBar];
    if (columns.count) {
        [self.noContentView removeFromSuperview];
//        [self.view insertSubview:self.button aboveSubview:self.tabBar];
        
    }else{
//        [self.button removeFromSuperview];
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
    
    if (resp.cmdId == HQCMD_getProjectRoleAndAuth) {
        
        NSDictionary *dict = [resp.body valueForKey:@"priviledge"];
        self.privilege = [dict valueForKey:@"priviledge_ids"];
        
        if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"16,17,18,19"]) {
            
            self.button.hidden = YES;
            self.tabBar.rightSpacing = 10;
        }
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

#pragma mark - YPTabBarDelegate
-(void)yp_tabBar:(YPTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index{
    
    self.columnIndex = index;
    
    for (TFProjectBoardItemController *vc in self.childViewControllers) {
        [vc.view removeFromSuperview];
    }
    
    TFProjectBoardItemController *vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(0, 44.5, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44-BottomHeight);
    [self.view addSubview:vc.view];
    [vc refreshBoardViewData];
    
//    TFProjectColumnModel *model = self.columns[index];
//    if (model.subnodeArr.count) {
//        [self.view insertSubview:self.addButton aboveSubview:vc.view];
//    }else{
//        [self.addButton removeFromSuperview];
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ProjectRowTableViewHideNotification object:nil];
}

- (void)buttonClick{
    
    
    if (![self.projectModel.project_status isEqualToString:@"0"]) {
        if ([self.projectModel.project_status isEqualToString:@"1"]) {// 归档
            
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.projectModel.project_status isEqualToString:@"2"]) {// 暂停
            
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        return;
    }
    
    [self.auths removeAllObjects];
    if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"16"]) {
        [self.auths addObject:@"新增分组"];
    }
    if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"17"] ||
        [HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"18"] ||
        [HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"19"]) {
        [self.auths addObject:@"管理分组"];
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    sheet.tag = 0x333;
    for (NSString *str in self.auths) {
        [sheet addButtonWithTitle:str];
    }
    
    [sheet showInView:self.view];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ProjectRowTableViewHideNotification object:nil];
}


#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {// 取消
        return;
    }
    NSString *str = self.auths[buttonIndex-1];
    if ([str isEqualToString:@"新增分组"]) {
        
        TFCreateTaskRowController *tastRow = [[TFCreateTaskRowController alloc] init];
        tastRow.projectId = self.projectId;
        tastRow.refreshAction = ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.projectTaskBL requestGetProjectAllDotWithProjectId:self.projectId];
        };
        [self.navigationController pushViewController:tastRow animated:YES];
        
        
    }else if ([str isEqualToString:@"管理分组"]){
        
        TFColumnListController *taskColumn = [[TFColumnListController alloc] init];
        taskColumn.columns = self.columns;
        taskColumn.projectId = self.projectId;
        taskColumn.refreshAction = ^{
    
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.projectTaskBL requestGetProjectAllDotWithProjectId:self.projectId];
    
        };
        [self.navigationController pushViewController:taskColumn animated:YES];
    
    }
    
}

//- (void)addButtonClick{
//    TFCreateTaskController *createTask = [[TFCreateTaskController alloc] init];
//    [self.navigationController pushViewController:createTask animated:YES];
//}


- (void)initViewControllersWithColumn:(NSArray *)columns {
    
    for (TFProjectBoardItemController *vc in self.childViewControllers) {
        
        [vc removeFromParentViewController];
        [vc.view removeFromSuperview];
    }
    
    for (NSInteger tag = 0; tag < columns.count; tag ++) {
        TFProjectColumnModel *model = columns[tag];
        TFProjectBoardItemController *controller = [[TFProjectBoardItemController alloc] init];
        controller.vcTag = tag;
        controller.projectId = self.projectId;
        controller.projectColumnModel = model;
        controller.projectModel = self.projectModel;
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
