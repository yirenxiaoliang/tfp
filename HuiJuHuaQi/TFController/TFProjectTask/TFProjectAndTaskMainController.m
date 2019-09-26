
//
//  TFProjectAndTaskMainController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectAndTaskMainController.h"
#import "TFProjectMainController.h"
#import "TFTaskMainController.h"
#import "TFProjectFilterView.h"
#import "TFCreateProjectController.h"
#import "TFProjectCustomSortController.h"
#import "TFAddTaskController.h"
#import "TFApprovalSearchView.h"
#import "TFProjectTaskBL.h"
#import "TFProjectDetailTabBarController.h"
#import "HQNotPassSubmitView.h"
#import "TFCustomBL.h"

@interface TFProjectAndTaskMainController ()<TFProjectFilterViewDelegate,UITextFieldDelegate,HQBLDelegate>
/** filterView */
@property (nonatomic, strong) TFProjectFilterView *filterView;

/** searchView */
@property (nonatomic, strong) TFApprovalSearchView *searchView;

/** projectIndex */
@property (nonatomic, strong) NSNumber *projectIndex;
/** projectIndex */
@property (nonatomic, strong) NSNumber *taskIndex;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;
/** 自定义请求 */
@property (nonatomic, strong) TFCustomBL *customBL;

@end

@implementation TFProjectAndTaskMainController

#pragma mark - 初始化filterView
- (void)setupFilterView{
    
    TFProjectFilterView *filterVeiw = [[TFProjectFilterView alloc] initWithFrame:(CGRect){SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
    filterVeiw.tag = 0x1234554321;
    self.filterView = filterVeiw;
    filterVeiw.type = 1;
    filterVeiw.delegate = self;
}
#pragma mark - TFProjectFilterViewDelegate
-(void)filterViewDidSureBtnWithDict:(NSDictionary *)dict{
    [self.filterView hideAnimation];
    
    NSMutableDictionary *dd = [NSMutableDictionary dictionary];
    if (dict) {
        [dd setObject:dict forKey:@"condition"];
    }
    [dd setObject:self.taskIndex forKey:@"type"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TaskSearchReturnNotification object:dd];
    
}



-(TFApprovalSearchView *)searchView{
    if (!_searchView) {
        
        _searchView = [TFApprovalSearchView approvalSearchView];
        _searchView.frame = (CGRect){SCREEN_WIDTH-60,0,0,46};
        _searchView.type = 1;
        _searchView.textFiled.returnKeyType = UIReturnKeySearch;
        _searchView.textFiled.delegate = self;
        _searchView.textFiled.placeholder = @"请输入搜索内容";
        _searchView.textFiled.backgroundColor = CellSeparatorColor;
        _searchView.searchBtn.hidden = YES;
        _searchView.backgroundColor = WhiteColor;
        
    }
    return _searchView;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ProjectSearchReturnNotification object:@{@"text":TEXT(textField.text),@"type":self.projectIndex}];
    return YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,1}];
//    [self.navigationController.navigationBar addSubview:lineView];
//    lineView.tag = 0x899;
//    lineView.backgroundColor = WhiteColor;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[self.navigationController.navigationBar viewWithTag:0x899] removeFromSuperview];
    [self cancel];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_savePersonnelData) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:TaskSearchReturnNotification object:@{@"type":self.taskIndex}];
    }
    if (resp.cmdId == HQCMD_getPersonnelTaskFilterCondition) {
        
        self.filterView.conditions = [resp.body valueForKey:@"condition"] ;
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    [self.projectTaskBL requsetGetPersonnelTaskFilterCondition];
    
    self.enablePanGesture = YES;

    [self setTabBarFrame:CGRectMake(0, 0, 60 * 2, 44)
        contentViewFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64)];
    
    [self.tabBar removeFromSuperview];
    self.navigationItem.titleView = self.tabBar;
    
    self.tabBar.itemTitleColor = HexColor(0x909090);
    self.tabBar.itemTitleSelectedColor = WhiteColor;
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:16];
    self.tabBar.itemTitleSelectedFont = FONT(16);
    self.tabBar.leftAndRightSpacing = 0;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = HexAColor(0x3689e9, 1);
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(9, 5, 9, 7) tapSwitchAnimated:NO];
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:40];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    self.loadViewOfChildContollerWhileAppear = YES;
    self.interceptRightSlideGuetureInFirstPage = NO;
    
    [self.tabBar setScrollEnabledAndItemWidth:60];
    self.tabBar.itemSelectedBgImageView.layer.masksToBounds = YES;
    self.tabBar.itemSelectedBgImageView.layer.cornerRadius = 13;
    
//    self.contentScrollView.scrollEnabled = NO;// 禁止滑动
    self.tabBar.delegate = self;
    [self initViewControllers];
    
    [self setupNavigation];
    
    [self setupFilterView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scroll) name:ProjectSearchScrollNotification object:nil];
}

- (void)scroll{
    
    [self.searchView.textFiled resignFirstResponder];
    
}


- (void)setupNavigation {
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *item = [self itemWithTarget:self action:@selector(addClicked) image:@"加号" highlightImage:@"加号"];
    
    UIBarButtonItem *item1 = nil;
    
    if (self.tabBar.selectedItemIndex == 0) {
        
        item1 = [self itemWithTarget:self action:@selector(projectSearchClick) image:@"搜索project" highlightImage:@"搜索project"];
        self.navigationItem.rightBarButtonItems = @[item1,item];
    }else{
        item1 = [self itemWithTarget:self action:@selector(taskSearchClick) image:@"proFilter" highlightImage:@"proFilter"];
        self.navigationItem.rightBarButtonItems = @[];
    }
    
    self.navigationItem.titleView = self.tabBar;
    [self.searchView removeFromSuperview];
    [self.searchView resignFirstResponder];
    
}
#pragma mark - tabBarDelegate
-(void)yp_tabBar:(YPTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index{
    
    [super yp_tabBar:tabBar didSelectedItemAtIndex:index];
    [self setupNavigation];
}

- (void)addClicked{
    
    if (self.tabBar.selectedItemIndex == 0) {// 项目任务
        TFCreateProjectController *createPro = [[TFCreateProjectController alloc] init];
        createPro.type = 0;
        createPro.refreshAction = ^(NSDictionary *parameter) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if ([parameter valueForKey:@"id"]) {
                [dict setObject:[parameter valueForKey:@"id"] forKey:@"dataId"];
            }
            if (self.projectIndex) {
                [dict setObject:self.projectIndex forKey:@"type"];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:ProjectSearchReturnNotification object:dict];
            
            TFProjectModel *model = [[TFProjectModel alloc] init];
            model.id = [parameter valueForKey:@"id"];
            model.temp_id = [parameter valueForKey:@"temp_id"];
            
            TFProjectDetailTabBarController *detail = [[TFProjectDetailTabBarController alloc] init];
            detail.createPush = YES;
            detail.projectId = [parameter valueForKey:@"id"];
            detail.projectModel = model;
            detail.refresh = ^{
                
            };
            detail.deleteAction = ^{
                
            };
            [self.navigationController pushViewController:detail animated:YES];
        };
        [self.navigationController pushViewController:createPro animated:YES];
    }else{// 个人任务
//        TFAddTaskController *add = [[TFAddTaskController alloc] init];
//        add.type = 9;
//        add.bean = [NSString stringWithFormat:@"project_custom"];
//        add.tableViewHeight = SCREEN_HEIGHT-64;
//        add.refreshAction = ^{
//
//            [[NSNotificationCenter defaultCenter] postNotificationName:TaskSearchReturnNotification object:@{@"type":self.taskIndex}];
//        };
//        [self.navigationController pushViewController:add animated:YES];
        
        
        [HQNotPassSubmitView submitPlaceholderStr:@"请输入任务名称" title:nil maxCharNum:200 LeftTouched:^{
            
        } onRightTouched:^(NSDictionary *dict) {
            
            NSMutableDictionary *data = [NSMutableDictionary dictionary];
            if ([dict valueForKey:@"text"]) {
                [data setObject:[dict valueForKey:@"text"] forKey:@"name"];
                [data setObject:[dict valueForKey:@"text"] forKey:@"text_name"];
            }
            NSMutableDictionary *total = [NSMutableDictionary dictionary];
            [total setObject:data forKey:@"data"];
            [total setObject:@"project_custom" forKey:@"bean"];
            // 新建任务
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.customBL requestSavePersonnelDataWithData:total];
            
        }];
    }
}
- (void)taskSearchClick{
    
    [self.filterView showAnimation];
}

- (void)projectSearchClick{
    
    UINavigationItem *item1 = [self itemWithTarget:self action:@selector(cancel) text:@"取消" textColor:GrayTextColor];
    self.navigationItem.rightBarButtonItems = @[item1];
    
    [self.navigationController.navigationBar addSubview:self.searchView];
    self.searchView.frame = (CGRect){60,0,SCREEN_WIDTH-120,46};
    [self.searchView.textFiled becomeFirstResponder];
}

- (void)cancel{
    
    [self setupNavigation];
    [self.searchView removeFromSuperview];
}

- (void)initViewControllers {
    
    
    TFProjectMainController *controller1 = [[TFProjectMainController alloc] init];
    controller1.yp_tabItemTitle = @"项目";
    controller1.indexAction = ^(NSNumber *parameter) {
        self.projectIndex = parameter;
    };

    TFTaskMainController *controller2 = [[TFTaskMainController alloc] init];
    controller2.yp_tabItemTitle = @"任务";
    controller2.indexAction = ^(NSNumber *parameter) {
        self.taskIndex = parameter;
    };

    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, nil];
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
