//
//  TFBenchMainController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/16.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFBenchMainController.h"
#import "TFProjectBenchController.h"
#import "TFEnterpriseFlowController.h"
#import "TFModelEnterController.h"
#import "HQTFSelectCompanyController.h"
#import "PopoverView.h"
#import "TFProjectTaskBL.h"

@interface TFBenchMainController ()<HQBLDelegate>

/** titleView */
@property (nonatomic, weak) UIButton *titleView;
/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

@end

@implementation TFBenchMainController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationItem.title = UM.userLoginInfo.company.company_name;
    
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    
//    [self.titleView setTitle:UM.userLoginInfo.company.company_name forState:UIControlStateNormal];
//    [self.titleView setTitle:UM.userLoginInfo.company.company_name forState:UIControlStateHighlighted];
   
    self.navigationItem.leftBarButtonItem = [self titleItemWithTitle:UM.userLoginInfo.company.company_name color:BlackTextColor imageName:nil withTarget:self action:@selector(changeCompany)];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [self.projectTaskBL requestGetWorkBenchList];
    
    TFProjectBenchController *bench = [[TFProjectBenchController alloc] init];
    
    TFEnterpriseFlowController *task = [[TFEnterpriseFlowController alloc] init];
    
    [self addChildViewController:bench];
    [self addChildViewController:task];
    
    bench.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomHeight);
    [self.view addSubview:bench.view];
    
    UINavigationItem *item2 = [self itemWithTarget:self action:@selector(leftClicked) image:@"工作台-更多应用" highlightImage:@"工作台-更多应用"];
    UINavigationItem *item1 = [self itemWithTarget:self action:@selector(rightClicked) image:@"工作台-切换" highlightImage:@"工作台-切换"];
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    self.navigationItem.title = @"";
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getWorkBenchList) {
        
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}





- (void)leftClicked{
    TFModelEnterController *model = [[TFModelEnterController alloc] init];
    [self.navigationController pushViewController:model animated:YES];
}
- (void)rightClicked{
    PopoverView *popView = [[PopoverView alloc] initWithPoint:(CGPoint){SCREEN_WIDTH-10,64} titles:@[@"时间工作台",@"企业工作流"] images:nil];
    popView.selectRowAtIndex = ^(NSInteger index) {
      
        for (UIViewController *vc in self.childViewControllers) {
            [vc.view removeFromSuperview];
        }
        
        UIViewController *vc = self.childViewControllers[index];
        vc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomHeight);
        [self.view addSubview:vc.view];
        
    };
    [popView show];
}
- (void)changeCompany{
    
    HQTFSelectCompanyController *select = [[HQTFSelectCompanyController alloc] init];
    [self.navigationController pushViewController:select animated:YES];
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
