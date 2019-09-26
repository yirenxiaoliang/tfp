//
//  TFSelectDayController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectDayController.h"
#import "TFTaskRepeatController.h"

@interface TFSelectDayController ()

/** weeks */
@property (nonatomic, strong) NSMutableArray *weeks;

/** buttons */
@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation TFSelectDayController

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(NSMutableArray *)weeks{
    if (!_weeks) {
        _weeks = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 31; i ++) {
            TFDateModel *model = [[TFDateModel alloc] init];
            model.name = [NSString stringWithFormat:@"%ld",i+1];
            model.tag = i;
            model.select = @0;
            [_weeks addObject:model];
        }
        
        for (TFDateModel *mo1 in self.selects) {
            
            for (TFDateModel *mo2 in _weeks) {
                
                if (mo1.tag == mo2.tag) {
                    
                    mo2.select = @1;
                    break;
                }
                
            }
        }
    }
    return _weeks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupChildView];
}

- (void)setupChildView{
    
    for (NSInteger i = 0; i < self.weeks.count; i ++) {
        TFDateModel *model = self.weeks[i];
        
        CGFloat X = i % 7 *(SCREEN_WIDTH/7);
        CGFloat Y = i / 7 *(SCREEN_WIDTH/7) + 20;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:button];
        button.layer.borderColor = CellSeparatorColor.CGColor;
        button.layer.borderWidth = 0.5;
        button.frame = CGRectMake(X, Y, (SCREEN_WIDTH/7), (SCREEN_WIDTH/7));
        
        if ([model.select isEqualToNumber:@1]) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
        button.tag = i;
        button.backgroundColor = WhiteColor;
        [button setTitle:model.name forState:UIControlStateNormal];
        [button setTitle:model.name forState:UIControlStateHighlighted];
        [button setTitle:model.name forState:UIControlStateSelected];
        
        [button setTitleColor:BlackTextColor forState:UIControlStateNormal];
        [button setTitleColor:WhiteColor forState:UIControlStateHighlighted];
        [button setTitleColor:WhiteColor forState:UIControlStateSelected];
        
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"选中点"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"选中点"] forState:UIControlStateSelected];
        
        button.imageView.contentMode = UIViewContentModeScaleToFill;
        button.contentMode = UIViewContentModeScaleToFill;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.buttons addObject:button];
    }
    
}

- (void)buttonClicked:(UIButton *)button{
    
    button.selected = !button.selected;
    NSInteger tag = button.tag;
    
    TFDateModel *model = self.weeks[tag];
    if (button.selected) {
        model.select = @1;
    }else{
        model.select = @0;
    }
}


- (void)setupNavi{
    
    self.navigationItem.title = @"选择重复日期";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (TFDateModel *model in self.weeks) {
        
        if ([model.select isEqualToNumber:@1]) {
            
            [arr addObject:model];
        }
    }
    
    if (arr.count == 0) {
        
        [MBProgressHUD showError:@"请选择日期" toView:self.view];
        return;
    }
    
    if (self.parameterAction) {
        self.parameterAction(arr);
        [self.navigationController popViewControllerAnimated:YES];
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
