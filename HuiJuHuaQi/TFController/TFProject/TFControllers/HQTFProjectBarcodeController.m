//
//  HQTFProjectBarcodeController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/6.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProjectBarcodeController.h"

@interface HQTFProjectBarcodeController ()

@end

@implementation HQTFProjectBarcodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ExtraLightBlackTextColor;
    [self setupNavigation];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    btn.backgroundColor = RedColor;
    
    [self.view addSubview:btn];
    
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,100,SCREEN_WIDTH,200}];
    view.backgroundColor = WhiteColor;
    [self.view addSubview:view];
    
    
    CGRect rect = [self.view convertRect:btn.frame fromView:view];
    
}


#pragma mark - navi
- (void)setupNavigation{
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(menu) image:@"菜单" highlightImage:@"菜单"];
    
    self.navigationItem.title = @"二维码";
}

- (void)menu{
    
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
