//
//  TFApprovalMainController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFApprovalMainController.h"
#import "TFApprovalListController.h"
#import "TFTabBarView.h"
#import "TFFilterView.h"
#import "TFFilterModel.h"
#import "HQTFModelBenchController.h"
#import "TFCustomBL.h"
#import "TFModelEnterController.h"
#import "TFApprovalListItemModel.h"
#import "TFApprovalBarView.h"

@interface TFApprovalMainController ()<TFTabBarViewDelegate,TFFilterViewDelegate,HQBLDelegate,TFApprovalBarViewDelegate>
/** tabBarView */
@property (nonatomic, strong) TFTabBarView *tabBarView;


@property (nonatomic, strong) TFApprovalBarView *approvalBarView;

/** filterVeiw */
@property (nonatomic, strong) TFFilterView *filterVeiw;

/** show */
@property (nonatomic, assign) BOOL show;

/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;


/** arr0 */
@property (nonatomic, strong) NSMutableArray *arr0;
/** arr1 */
@property (nonatomic, strong) NSMutableArray *arr1;
/** arr2 */
@property (nonatomic, strong) NSMutableArray *arr2;
/** arr3 */
@property (nonatomic, strong) NSMutableArray *arr3;

/** index */
@property (nonatomic, assign) NSInteger index;

/** counts */
@property (nonatomic, strong) NSMutableArray<TFNumIndex> *counts;

/** selectApprovals */
@property (nonatomic, strong) NSMutableArray *selectApprovals;


@end

@implementation TFApprovalMainController

-(NSMutableArray *)selectApprovals{
    
    if (!_selectApprovals) {
        _selectApprovals = [NSMutableArray array];
    }
    return _selectApprovals;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.customBL requestApprovalCount];// 数量
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(NSMutableArray *)counts{
    if (!_counts) {
        _counts = [NSMutableArray<TFNumIndex> array];
    }
    return _counts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildVC];
//    [self setupTabBarView];
    [self setupApprovalBarView];
    [self setupNavi];
    [self setupFilterView];
    
    if (self.selectIndex) {
        self.approvalBarView.selectedIndex = [self.selectIndex integerValue];
        [self approvalBarViewDidClickWithIndex:[self.selectIndex integerValue]];
    }
    
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    UISwipeGestureRecognizer *sw1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    [self.view addGestureRecognizer:sw1];
    sw1.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *sw2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    [self.view addGestureRecognizer:sw2];
    sw2.direction = UISwipeGestureRecognizerDirectionRight;
}

-(void)swipeLeft{
    if (self.index < 3) {
        self.index ++;
        [self tabBarView:self.tabBarView didSelectIndex:self.index];
        self.approvalBarView.selectedIndex = self.index;
        self.enablePanGesture = NO;
    }
}
-(void)swipeRight{
    if (self.index > 0) {
        self.index --;
        [self tabBarView:self.tabBarView didSelectIndex:self.index];
        self.approvalBarView.selectedIndex = self.index;
        if (self.index == 0) {
            self.enablePanGesture = YES;
        }
    }
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customApprovalCount) {
        
        
        TFNumIndex *index = [[TFNumIndex alloc] init];
        index.type = @1;
        index.count = [resp.body valueForKey:@"treatCount"];
        [self.counts addObject:index];
        
        TFNumIndex *index1 = [[TFNumIndex alloc] init];
        index1.type = @3;
        index1.count = [resp.body valueForKey:@"copyCount"];
        [self.counts addObject:index1];
        
        [self.tabBarView refreshNumWithNumbers:self.counts];
        
        [self.approvalBarView refreshCopyApprovalNumber:[[resp.body valueForKey:@"copyCount"] integerValue]];
        [self.approvalBarView refreshWaitApprovalNumber:[[resp.body valueForKey:@"treatCount"] integerValue]];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}



#pragma mark - 初始化filterView
- (void)setupFilterView{
    
    TFFilterView *filterVeiw = [[TFFilterView alloc] initWithFrame:(CGRect){SCREEN_WIDTH,NaviHeight,SCREEN_WIDTH,SCREEN_HEIGHT-NaviHeight}];
    filterVeiw.tag = 0x1234554321;
    self.filterVeiw = filterVeiw;
    filterVeiw.delegate = self;
    
    
//    NSMutableArray *models = [NSMutableArray array];
//    for (NSInteger i = 0; i < 4; i ++) {
//
//        TFFilterModel *model = [[TFFilterModel alloc] init];
//        if (i == 0) {
//            model.type = @"personnel";
//            model.name = @"申请人";
//        }else if (i == 1){
//            model.type = @"datetime";
//            model.name = @"申请时间";
//        }else if (i == 2){
//            model.type = @"multi";
//            model.name = @"申请类型";
//        }else{
//            model.type = @"multi";
//            model.name = @"申请状态";
//        }
//        [models addObject:model];
//    }
//    filterVeiw.filters = models;
}

#pragma mark - TFFilterViewDelegate
-(void)filterViewDidClicked:(BOOL)show{
    
    [self filterClick];
    
}

-(void)filterViewDidSureBtnWithDict:(NSDictionary *)dict{
    
    [self filterClick];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ApprovalSearchList" object:@(self.index) userInfo:dict];
    
}



#pragma mark - 子控制器
- (void)setupChildVC{
    
    for (NSInteger i = 0; i < 4; i ++) {
        TFApprovalListController *vc = [[TFApprovalListController alloc] init];
        vc.type = @(i);
        if (self.type == 3) {
            vc.quote = YES;
        }
        if (self.type == 0) {
            vc.special = YES;
        }
        vc.view.frame = CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight);
        vc.allSelects = self.selectApprovals;

        
        vc.refreshAction = ^(id parameter) {
          
            if ([vc.type integerValue] == 0) {
                
                self.arr0 = parameter;
                self.filterVeiw.filters = self.arr0;
                
            }else if ([vc.type integerValue] == 1) {
                
                self.arr1 = parameter;
                self.filterVeiw.filters = self.arr1;
            }else if ([vc.type integerValue] == 2) {
                
                self.arr2 = parameter;
                self.filterVeiw.filters = self.arr2;
            }else{// 3
                
                self.arr3 = parameter;
                self.filterVeiw.filters = self.arr3;
            }
            
        };
        
        [self addChildViewController:vc];
    }
}

- (void)setupNavi{
    
    self.navigationItem.title = @"审批";
    
    if (self.type == 3) {
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GrayTextColor];
        
    }else if (self.type == 2) {
    
        UIBarButtonItem *item2 = [self itemWithTarget:self action:@selector(filterClick) image:@"状态" highlightImage:@"状态"];
        
        self.navigationItem.rightBarButtonItems = @[item2];
        
    }else{
        
        UIBarButtonItem *item1 = [self itemWithTarget:self action:@selector(addClick) image:@"添加项目" highlightImage:@"添加项目"];
        UIBarButtonItem *item2 = [self itemWithTarget:self action:@selector(filterClick) image:@"状态" highlightImage:@"状态"];
        
        self.navigationItem.rightBarButtonItems = @[item1,item2];
    }
    
}

- (void)sure{
    
    if (self.selectApprovals.count == 0) {
        
        [MBProgressHUD showError:@"请选择" toView:self.view];
        return;
    }
    
    if (self.parameterAction) {
        [self.navigationController popViewControllerAnimated:NO];
        self.parameterAction(self.selectApprovals);
    }
}


- (void)addClick{
//    HQTFModelBenchController *model = [[HQTFModelBenchController alloc] init];
//    model.type = 1;
//    [self.navigationController pushViewController:model animated:YES];
    
    TFModelEnterController *model = [[TFModelEnterController alloc] init];
    model.type = 2;
    [self.navigationController pushViewController:model animated:YES];
}
- (void)filterClick{
    
    if (!self.show) {
        self.show = YES;
        [KeyWindow addSubview:self.filterVeiw];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.filterVeiw.backgroundColor = RGBAColor(0, 0, 0, .5);
            self.filterVeiw.left = 0;
        }];
        
    }else{
        self.show = NO;
        [UIView animateWithDuration:0.25 animations:^{
            
            self.filterVeiw.left = SCREEN_WIDTH;
            self.filterVeiw.backgroundColor = RGBAColor(0, 0, 0, 0);
        } completion:^(BOOL finished) {
            
            [self.filterVeiw removeFromSuperview];
        }];
        
    }
}

#pragma mark - 初始化tabBarView
- (void)setupTabBarView{
    
    TFTabBarView *tabBarView = [[TFTabBarView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-NaviHeight-BottomHeight,SCREEN_WIDTH,TabBarHeight} withTitles:@[@"我发起的",@"待我审批",@"我已审批",@"抄送到我"]];
    [self.view addSubview:tabBarView];
    self.tabBarView = tabBarView;
    
    tabBarView.delegate = self;
    tabBarView.selectIndex = 0;
}

#pragma mark - TFTabBarViewDelegate
-(void)tabBarView:(TFTabBarView *)tabBarView didSelectIndex:(NSInteger)index{
    
    self.index = index;
    for (UIViewController *vc in self.childViewControllers) {
        
        [vc.view removeFromSuperview];
    }
    UIViewController *vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight);
    [self.view insertSubview:vc.view atIndex:0];
    
    if (index == 0) {
        
        self.filterVeiw.filters = self.arr0;
    }else if (index == 1){
        
        self.filterVeiw.filters =  self.arr1;
    }else if (index == 1){
        
        self.filterVeiw.filters =  self.arr2;
    }else{
        
        self.filterVeiw.filters =  self.arr3;
    }
    
}

-(void)setupApprovalBarView{
    TFApprovalBarView *approvalBarView = [[TFApprovalBarView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,65}];
    [self.view addSubview:approvalBarView];
    approvalBarView.delegate = self;
    self.approvalBarView = approvalBarView;
    [self approvalBarViewDidClickWithIndex:0];
}

-(void)approvalBarViewDidClickWithIndex:(NSInteger)index{
    [self tabBarView:self.tabBarView didSelectIndex:index];
    if (self.index > 0) {
        self.enablePanGesture = NO;
    }else{
        self.enablePanGesture = YES;
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
