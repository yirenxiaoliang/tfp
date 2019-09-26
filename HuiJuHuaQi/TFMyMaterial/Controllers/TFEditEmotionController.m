//
//  TFEditEmotionController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/5/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEditEmotionController.h"

#define rowCounts 8
@interface TFEditEmotionController ()

@property (nonatomic, strong) UIView *emoView;

@property (nonatomic, strong) NSString *kString;

@end

@implementation TFEditEmotionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"心情符号";
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor = WhiteColor;
    [self.view addSubview:view];
    
    self.emoView = view;
    
    //宽高
    CGFloat emoWH = SCREEN_WIDTH/rowCounts;
    
    //Y
    CGFloat btnY = 0;
    
    
    for (int i=0; i<72; i++) {
        
        //取余
        CGFloat rowN = i%rowCounts;
        
        CGFloat btnX = 0;
        
        if (rowN == 0) {
            
            btnY = btnY+emoWH;
            
            btnX = 0;
        }
        else {
        
            btnX = rowN*emoWH;
        }
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        
        but.tag = i+1;
        NSString *emoName = [NSString stringWithFormat:@"%d",i+1];
        [but setImage:IMG(emoName) forState:UIControlStateNormal];
        but.contentMode = UIViewContentModeScaleAspectFit;
        but.frame = CGRectMake(btnX, btnY, emoWH, emoWH);
        
        [but addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.emoView addSubview:but];
    }
    
    
}

- (void)buttonClicked:(UIButton *)button {

    
    // 读取并加载对照表
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LiuqsEmotions" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
//    NSString *objectEightId = @"";
//    NSDictionary *userDic = @{@"1":@"qwwr",@"2":@"qwrewr",@"3":@"已知道的value",@"4":@"adasfsgf"};
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        HQLog(@"key = %@ and obj = %@", key, obj);
        if ([obj isEqualToString: [NSString stringWithFormat:@"%ld",button.tag]]) {
            self.kString = key;
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            [dic setObject:@(button.tag) forKey:@"image"];
            [dic setObject:self.kString forKey:@"emotion"];
            
            if (self.refresh) {
                
                self.refresh(dic);
                
            }
            HQLog(@"----------%@",self.kString);
            
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }];
    
}

@end
