//
//  TFMutilStyleSelectPeopleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMutilStyleSelectPeopleController.h"
#import "TFContactsSelectPeopleController.h"
#import "TFAllSelectView.h"
#import "TFContactsDepartmentController.h"
#import "TFContactsRoleController.h"
#import "TFContactsDynamicParameterController.h"
#import "TFChangeHelper.h"
#import "TFParameterModel.h"

@interface TFMutilStyleSelectPeopleController ()<TFAllSelectViewDelegate,YPTabBarDelegate>

/** allSelectView */
@property (nonatomic, weak) TFAllSelectView *allSelectView ;

/** fourSelects */
@property (nonatomic, strong) NSMutableArray *fourSelects;

/** tableViewHeight */
@property (nonatomic, assign) CGFloat tableViewHeight;


@end

@implementation TFMutilStyleSelectPeopleController

-(NSMutableArray *)fourSelects{
    if (!_fourSelects) {
        _fourSelects = [NSMutableArray array];
        
        if (self.selectType > 0) {
            
            NSMutableArray *arr = [NSMutableArray array];
            for (HQEmployModel *model in self.defaultPoeples) {
                
                if ([model isKindOfClass:[HQEmployModel class]]) {
                    
                    [arr addObject:[TFChangeHelper hqEmployeeToTfEmployee:model]];
                }else{
                    [arr addObject:model];
                }
            }
            
            [_fourSelects addObject:@{@"type":@0,@"peoples":arr}];
            [_fourSelects addObject:@{@"type":@1}];
            [_fourSelects addObject:@{@"type":@2}];
            [_fourSelects addObject:@{@"type":@3}];
            
        }else{// 四种一起
            
            NSMutableArray *arr1 = [NSMutableArray array];
            NSMutableArray *arr2 = [NSMutableArray array];
            NSMutableArray *arr3 = [NSMutableArray array];
            NSMutableArray *arr4 = [NSMutableArray array];
            for (TFParameterModel *model in self.defaultPoeples) {
                if ([model.type isEqualToNumber:@0]) {
                    [arr2 addObject:model];
                }else if ([model.type isEqualToNumber:@1]){
                    [arr1 addObject:model];
                }else if ([model.type isEqualToNumber:@2]){
                    [arr3 addObject:model];
                }else if ([model.type isEqualToNumber:@3]){
                    [arr4 addObject:model];
                }
                
            }
            
            [_fourSelects addObject:@{@"type":@0,@"peoples":arr1}];
            [_fourSelects addObject:@{@"type":@1,@"peoples":arr2}];
            [_fourSelects addObject:@{@"type":@2,@"peoples":arr3}];
            [_fourSelects addObject:@{@"type":@3,@"peoples":arr4}];
            
        }
        
    }
    return _fourSelects;
}

-(void)didBack:(UIButton *)sender{
    [super didBack:sender];
    if (self.cancelAction) {
        self.cancelAction();
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - Navigation
- (void)setupNavigation{
    
     self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    
    self.navigationItem.title = @"选择人员";
}

- (void)sure{
    
    NSInteger num = 0;
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger i = 0;
    for (NSDictionary *dict in self.fourSelects) {
        
        if (i == 0) {
            
            NSArray *peoples = [dict valueForKey:@"peoples"];
            if (peoples) {
                for (TFEmployModel *em in peoples) {
                    
                    [arr addObject:[TFChangeHelper tfEmployeeToHqEmployee:em]];
                }
                num += peoples.count;
            }
        }else{
            
            NSArray *peoples = [dict valueForKey:@"peoples"];
            if (peoples) {
                
                [arr addObjectsFromArray:peoples];
                num += peoples.count;
            }
        }
        
        i ++;
    }
    
    if (num == 0) {
        [MBProgressHUD showError:@"请选择人员" toView:self.view];
        return;
    }
    UINavigationController *na = self.navigationController;
    NSArray *childs = na.childViewControllers;
    
    if (self.actionParameter) {
        self.actionParameter(arr);
        
        for (NSInteger i=0; i < childs.count; i ++) {
            UIViewController *vc = childs[i];
            if ([vc isKindOfClass:[self class]]) {
                
                [self.navigationController popToViewController:childs[i-1] animated:YES];
            }
        }
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    self.tableViewHeight = SCREEN_HEIGHT - NaviHeight - 44;
    [self setTabBarFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)
        contentViewFrame:CGRectMake(0, 44, SCREEN_WIDTH,self.tableViewHeight)];
    
    self.tabBar.itemTitleColor = ExtraLightBlackTextColor;
    self.tabBar.itemTitleSelectedColor = GreenColor;
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:16];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:18];
    self.tabBar.leftAndRightSpacing = 20;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = GreenColor;
    self.tabBar.delegate = self;
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(40, 0, 0, 0) tapSwitchAnimated:NO];
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:40];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    self.loadViewOfChildContollerWhileAppear = YES;
    self.interceptRightSlideGuetureInFirstPage = YES;
    
    [self.tabBar setScrollEnabledAndItemWidth:SCREEN_WIDTH/4 - 12];
    
    self.view.layer.masksToBounds = NO;
    
    [self setupAllSelectView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllSelectView:) name:SelectPeopleRefreshNotification object:nil];
    
    // 单控件
    if (self.selectType > 0) {
        self.tableViewHeight =  SCREEN_HEIGHT - NaviHeight;
        self.tabBar.selectedItemIndex = self.selectType - 1;
        self.contentScrollView.scrollEnabled = NO;
        self.tabBar.hidden = YES;
        self.contentViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, self.tableViewHeight);
    }
    
    // 单选
    if (self.isSingleSelect) {
        
        self.tableViewHeight += 49;
        self.allSelectView.hidden = YES;
    }
    
    [self initViewControllers];
}

- (void)initViewControllers {
    
    TFContactsSelectPeopleController *controller1 = [[TFContactsSelectPeopleController alloc] init];
    controller1.mainType = self.selectType == 0 ? 1 : 0;
    controller1.fourSelects = self.fourSelects;
    controller1.yp_tabItemTitle = @"联系人";
    controller1.vcTag = 0x1111;
    controller1.isSingleSelect = self.isSingleSelect;
    controller1.tableViewHeight = self.tableViewHeight;
    controller1.noSelectPoeples = self.noSelectPoeples;
    controller1.dismiss = self.dismiss;
    controller1.actionParameter = ^(id parameter) {
        
        [self sure];
    };
    
    TFContactsDepartmentController *controller2 = [[TFContactsDepartmentController alloc] init];
    controller2.mainType =  self.selectType == 0 ? 1 : 0;
    controller2.type = 1;
    controller2.fourSelects = self.fourSelects;
    controller2.yp_tabItemTitle = @"部门";
    controller2.vcTag = 0x2222;
    controller2.isSingleSelect = self.isSingleSelect;
    controller2.tableViewHeight = self.tableViewHeight;
    controller2.actionParameter = ^(id parameter) {
        
        [self sure];
    };
    
    TFContactsRoleController *controller3 = [[TFContactsRoleController alloc] init];
    controller3.mainType =  self.selectType == 0 ? 1 : 0;
    controller3.yp_tabItemTitle = @"角色";
    controller3.type = 1;
    controller3.fourSelects = self.fourSelects;
    controller3.vcTag = 0x3333;
    controller3.isSingleSelect = self.isSingleSelect;
    controller3.tableViewHeight = self.tableViewHeight;
    controller3.actionParameter = ^(id parameter) {
        
        [self sure];
    };
    
    TFContactsDynamicParameterController *controller4 = [[TFContactsDynamicParameterController alloc] init];
    controller4.mainType =  self.selectType == 0 ? 1 : 0;
    controller4.type = 1;
    controller4.yp_tabItemTitle = @"动态参数";
    controller4.fourSelects = self.fourSelects;
    controller4.vcTag = 0x4444;
    controller4.isSingleSelect = self.isSingleSelect;
    controller4.tableViewHeight = self.tableViewHeight;
    controller4.bean = self.bean;
    controller4.actionParameter = ^(id parameter) {
        
        [self sure];
    };
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, nil];
}
#pragma mark - YPTabBarDelegate
-(void)yp_tabBar:(YPTabBar *)tabBar willSelectItemAtIndex:(NSUInteger)index{
    if (index == 1) {
        self.allSelectView.hidden = YES;
    }else{
        if (self.isSingleSelect) {
            self.allSelectView.hidden = YES;
        }else{
            self.allSelectView.hidden = NO;
        }
    }
}

- (void)setupAllSelectView{
    
    TFAllSelectView *allSelectView = [TFAllSelectView allSelectView];
    allSelectView.frame = CGRectMake(0, SCREEN_HEIGHT-NaviHeight-BottomHeight, SCREEN_WIDTH, TabBarHeight);
    [self.view addSubview:allSelectView];
    allSelectView.delegate = self;
    self.allSelectView = allSelectView;
    
}

#pragma mark - TFAllSelectViewDelegate
-(void)allSelectViewDidClickedAllSelectBtn:(UIButton *)selectBtn{
    
    NSDictionary *dict = @{
                           @"type":@(self.tabBar.selectedItemIndex),
                           @"selected":selectBtn.selected ? @1 : @0
                           };
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AllSelectPeopleNotification object:dict];
    
}

- (void)refreshAllSelectView:(NSNotification *)note{
    
    NSDictionary *dict = note.object;
    
    self.fourSelects[[[dict valueForKey:@"type"] integerValue]] = dict;
    
    
    NSInteger index = 0;
    for (NSDictionary *di in self.fourSelects) {
        NSArray *arr = [di valueForKey:@"peoples"];
        index += arr.count;
    }
    
    BOOL selected = NO;
    if ([[dict valueForKey:@"type"] integerValue] == 0) {// 联系人
        
        NSArray *peos = [dict valueForKey:@"peoples"];
        
        if ([[dict valueForKey:@"allCount"] integerValue] == peos.count) {
            selected = YES;
        }
    }else{// 部门
        NSNumber *obj = [dict valueForKey:@"selected"];
        
        selected = [obj isEqualToNumber:@1]?YES:NO;
    }
    
    self.allSelectView.allSelectBtn.selected = selected;
    self.allSelectView.numLabel.text = [NSString stringWithFormat:@"已选择：%ld",index];
}

/**
 *  ViewController被选中时调用此方法，此方法为回调方法
 */
- (void)didSelectViewControllerAtIndex:(NSUInteger)index{
    
    
    NSDictionary *dict = self.fourSelects[index];
    
    BOOL selected = NO;
    if ([[dict valueForKey:@"type"] integerValue] == 0) {// 联系人
        
        NSArray *peos = [dict valueForKey:@"peoples"];
        if (peos.count) {
            
            if ([[dict valueForKey:@"allCount"] integerValue] == peos.count) {
                selected = YES;
            }
        }
    }else{// 部门
        NSNumber *obj = [dict valueForKey:@"selected"];
        
        if (obj) {
            
            selected = [obj isEqualToNumber:@1]?YES:NO;
        }
    }
    
    self.allSelectView.allSelectBtn.selected = selected;
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
