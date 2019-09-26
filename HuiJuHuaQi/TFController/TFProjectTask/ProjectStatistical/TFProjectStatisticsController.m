//
//  TFProjectStatisticsController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectStatisticsController.h"
#import "HQTFNoContentView.h"

@interface TFProjectStatisticsController ()

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;
@end

@implementation TFProjectStatisticsController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.view.height-Long(150))/2 - 40,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
    }
    return _noContentView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
    [self.view addSubview:self.noContentView];
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
