//
//  TodayViewController.m
//  HuiQiWiget
//
//  Created by HQ-20 on 16/6/6.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "HQWigetButton.h"

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, (self.view.bounds.size.width - 14) / 5 );
//    NSArray *images = @[@"应用图标",@"发企业圈-1",@"拍照签卡-1",@"发起聊天-1",@"紧急事务-1"];
//    NSArray *names = @[@"",@"发同事圈",@"签卡",@"聊天",@"紧急事务"];
//    for (NSInteger i = 0; i < 5; i ++) {
//        UIButton *btn = nil;
//        if (i == 0) {
//            btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.layer.cornerRadius = 20;
//            btn.layer.masksToBounds = YES;
//        }else{
//            btn = [HQWigetButton buttonWithType:UIButtonTypeCustom];
//        }
//        btn.imageView.contentMode = UIViewContentModeCenter;
//        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        btn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateHighlighted];
//        CGFloat btnX = ((self.view.bounds.size.width -20) / 5) * i;
//        CGFloat btnY = 20;
//        CGFloat btnW = (self.view.bounds.size.width  -20) / 5;
//        CGFloat btnH = btnW;
//        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
//        [self.view addSubview:btn];
//        if (i > 0) {
//            [btn setTitle:names[i] forState:UIControlStateNormal];
//            [btn setTitle:names[i] forState:UIControlStateHighlighted];
////            [btn  setImageEdgeInsets:UIEdgeInsetsMake( -(self.view.bounds.size.width) / 10 , 0, 0, 0)];
////            [btn setTitleEdgeInsets:UIEdgeInsetsMake((self.view.bounds.size.width ) / 10 , -(self.view.bounds.size.width) / 10, 0, 0)];
//        }
//        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
//        //        [btn addGestureRecognizer:tap];
//        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
//
//        btn.tag = 100 + i;
//    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){0,0,self.view.bounds.size.width-40,30}];
    [self.view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake((self.view.bounds.size.width -20)/2, (self.view.bounds.size.width -20) / 10 + 20);
    label.textColor = [UIColor blackColor];
    label.text = @"暂无内容 ^_^";
    
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    
    completionHandler(NCUpdateResultNewData);
}

- (void)btnClick:(UIButton *)button{
    
//    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.HuiJuHuaQi.TeamFace"];
//    [shared setObject:@{@"message":[NSString stringWithFormat:@"%ld",button.tag - 100]} forKey:@"callback"];
//
//    [shared synchronize];
//
//    [self.extensionContext openURL:[NSURL URLWithString:@"TeamFaceWidgetOne://"] completionHandler:^(BOOL success) {
//
//    }];
}


// 一般默认的View是从图标的右边开始的...如果你想变换,就要实现这个方法
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
