//
//  TFBarcodeInviteController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFBarcodeInviteController.h"
#import "TFBarcodeInviteView.h"
#import "HQTFUploadFileView.h"

@interface TFBarcodeInviteController ()
/** tableView */
@property (nonatomic, weak) UIScrollView *scrollView;


@end

@implementation TFBarcodeInviteController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WhiteColor,NSFontAttributeName:FONT(20)}];
    
    [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}]];
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"返回白色" highlightImage:@"返回白色"];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexAColor(0xc8c8c8, 1) size:(CGSize){SCREEN_WIDTH,0.5}]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:BlackTextColor,NSFontAttributeName:FONT(20)}];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScrollView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]];
    self.navigationItem.title = @"邀请成员";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(share) image:@"共享circle" highlightImage:@"共享circle"];
}

- (void)share{
    
    [HQTFUploadFileView showAlertView:@"分享到" withType:5 parameterAction:^(id parameter) {
        
        
    }];
}

- (void)setupScrollView{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 667-64);
    
    TFBarcodeInviteView *barcode = [TFBarcodeInviteView barcodeInviteView];
    barcode.frame = CGRectMake(18, 18, SCREEN_WIDTH-36, 526);
    [scrollView addSubview:barcode];
    
    UILabel *logoLabel = [[UILabel alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(barcode.frame)+20,SCREEN_WIDTH,20}];
    [scrollView addSubview:logoLabel];
    logoLabel.text = @"Teamface —— 让工作 - 连接一切！";
    logoLabel.font = FONT(16);
    logoLabel.textColor = WhiteColor;
    logoLabel.textAlignment = NSTextAlignmentCenter;
    
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
