//
//  HQTFTaskRowController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTaskRowController.h"
#import "HQMainSliderView.h"
#import "HQTFTaskRowTypeController.h"

@interface HQTFTaskRowController ()<YPTabBarDelegate>

/** HQMainSliderView */
@property (nonatomic, strong) HQMainSliderView *sliderView;


@end

@implementation HQTFTaskRowController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBar];
}

- (void)setupTabBar{
    
    [self setTabBarFrame:(CGRect){10,0,SCREEN_WIDTH-20,55}
        contentViewFrame:CGRectMake(0, 83, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 83-49)];
    self.tabBar.selectedItemIndex = 0;
    self.tabBar.itemTitleColor = ExtraLightBlackTextColor;
    self.tabBar.itemTitleSelectedColor = BlackTextColor;
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:16];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:17];
    self.tabBar.leftAndRightSpacing = 0;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = HexColor(0xEBEDF0, 1);
    self.tabBar.corner = YES;
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(8, 0, -8, 0) tapSwitchAnimated:YES];
    
    self.tabBar.itemSelectedBgImageView.layer.borderWidth = 0.5;
    self.tabBar.itemSelectedBgImageView.layer.borderColor = HexColor(0xd7dce0, 1).CGColor;
    
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    self.loadViewOfChildContollerWhileAppear = YES;
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    
    self.view.backgroundColor = WhiteColor;
    
    UIView *progessBg = [[UIView alloc] initWithFrame:(CGRect){0,45,SCREEN_WIDTH,38}];
    [self.view addSubview:progessBg];
    progessBg.backgroundColor =  HexColor(0xEBEDF0, 1);
    
    UIView *progressMax = [[UIView alloc] initWithFrame:(CGRect){20,0,SCREEN_WIDTH-20-65,8}];
    [progessBg addSubview:progressMax];
    progressMax.layer.cornerRadius = 4;
    progressMax.layer.masksToBounds = YES;
    progressMax.backgroundColor = HexColor(0xc8cfd8, 1);
    progressMax.centerY = progessBg.height/2;
    
    UIView *progressMin = [[UIView alloc] initWithFrame:(CGRect){20,0,100,8}];
    [progessBg addSubview:progressMin];
    progressMin.layer.cornerRadius = 4;
    progressMin.layer.masksToBounds = YES;
    progressMin.backgroundColor = GreenColor;
    progressMin.centerY = progessBg.height/2;
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:(CGRect){CGRectGetMaxX(progressMax.frame),0,SCREEN_WIDTH-CGRectGetMaxX(progressMax.frame),38}];
    [progessBg addSubview:numLabel];
    numLabel.attributedText = [self attributeStringWithFinishTask:5 withTotalTask:12];
    numLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [self initViewControllers];
    
    self.view.layer.masksToBounds = NO;
}

-(NSAttributedString *)attributeStringWithFinishTask:(NSInteger)finish withTotalTask:(NSInteger)total{
    
    NSString *totalString = [NSString stringWithFormat:@"%ld/%ld",finish,total];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:totalString];
    [string addAttribute:NSForegroundColorAttributeName value:GreenColor range:[totalString rangeOfString:[NSString stringWithFormat:@"%ld",finish]]];
    [string addAttribute:NSForegroundColorAttributeName value:LightGrayTextColor range:[totalString rangeOfString:[NSString stringWithFormat:@"/%ld",total]]];
    [string addAttribute:NSFontAttributeName value:FONT(12) range:(NSRange){0,totalString.length}];
    
    return string;
}

- (void)initViewControllers {
    HQTFTaskRowTypeController *controller1 = [[HQTFTaskRowTypeController alloc] init];
    controller1.yp_tabItemTitle = @"超期任务";
    
    HQTFTaskRowTypeController *controller2 = [[HQTFTaskRowTypeController alloc] init];
    controller2.yp_tabItemTitle = @"今日要做";
    
    HQTFTaskRowTypeController *controller3 = [[HQTFTaskRowTypeController alloc] init];
    controller3.yp_tabItemTitle = @"明日要做";
    
    HQTFTaskRowTypeController *controller4 = [[HQTFTaskRowTypeController alloc] init];
    controller4.yp_tabItemTitle = @"以后要做";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, nil];
}


#pragma mark - HQMainSliderView
- (void)setupMainSliderView{
    
    HQMainSliderView *view = [[HQMainSliderView alloc] initWithFrame:(CGRect){0,120,SCREEN_WIDTH,83}];
    view.tabBar.delegate = self;
    self.sliderView = view;
    [self.view addSubview:view];
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
