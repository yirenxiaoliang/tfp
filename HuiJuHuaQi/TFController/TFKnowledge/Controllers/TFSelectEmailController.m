//
//  TFSelectEmailController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectEmailController.h"
#import "TFEmailItemController.h"

@interface TFSelectEmailController ()

@property (nonatomic, weak) UITableView *tableView ;
/** 是否为收件箱 */
@property (nonatomic, assign) BOOL isReceive;
@property (nonatomic, weak) UIButton *receiveButton;
@property (nonatomic, weak) UIButton *sendButton;


@property (nonatomic, strong) NSMutableArray *selects;

@end

@implementation TFSelectEmailController

- (NSMutableArray *)selects{
    if (!_selects) {
        _selects = [NSMutableArray array];
    }
    return _selects;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isReceive = YES;
    self.navigationItem.title = @"邮件";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    [self setupChild];
    [self changeItem];
}

-(void)sure{
    
    if (self.selects.count == 0) {
        [MBProgressHUD showError:@"请选择" toView:self.view];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:NO];
    if (self.selectParameter) {
        self.selectParameter(self.selects);
    }
}

-(void)changeItem{
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    [self.view addSubview:view];
    view.layer.borderColor = CellSeparatorColor.CGColor;
    view.layer.borderWidth = 0.5;
    view.backgroundColor = WhiteColor;
    
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:button];
        button.frame = CGRectMake(SCREEN_WIDTH/2 * i, 0, SCREEN_WIDTH / 2, 44);
        button.titleLabel.font = FONT(16);
        [button setTitleColor:GrayTextColor forState:UIControlStateNormal];
        [button setTitleColor:BlackTextColor forState:UIControlStateSelected];
        if (i == 0) {
            button.selected = YES;
            [button setTitle:@"收件箱" forState:UIControlStateNormal];
            [button setTitle:@"收件箱" forState:UIControlStateSelected];
            self.receiveButton = button;
        }else{
            [button setTitle:@"发件箱" forState:UIControlStateNormal];
            [button setTitle:@"收件箱" forState:UIControlStateSelected];
            self.sendButton = button;
        }
        button.tag = i;
        [button addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *sepLine = [[UIView alloc] initWithFrame:(CGRect){SCREEN_WIDTH/2,0,0.5,44}];
    [view addSubview:sepLine];
    sepLine.backgroundColor = CellSeparatorColor;
    
}
-(void)itemClicked:(UIButton *)button{
    
    self.isReceive = button.tag == 0 ? YES : NO;
    self.receiveButton.selected = self.isReceive;
    self.sendButton.selected = !self.isReceive;
    
    TFEmailItemController *email = self.childViewControllers[button.tag];
    [self.view insertSubview:email.view atIndex:self.view.subviews.count];
}

-(void)setupChild{
    
    TFEmailItemController *email1 = [[TFEmailItemController alloc] init];
    email1.type = 0;
    email1.selects = self.selects;
    email1.numParameter = ^(NSNumber *parameter) {
        
        [self.receiveButton setTitle:[NSString stringWithFormat:@"收件箱(%@)",parameter.description] forState:UIControlStateNormal];
        [self.receiveButton setTitle:[NSString stringWithFormat:@"收件箱(%@)",parameter.description] forState:UIControlStateSelected];
        
    };
    [self addChildViewController:email1];
    
    
    TFEmailItemController *email2 = [[TFEmailItemController alloc] init];
    email2.type = 1;
    email1.selects = self.selects;
    email2.numParameter = ^(NSNumber *parameter) {
        
        [self.sendButton setTitle:[NSString stringWithFormat:@"发件箱(%@)",parameter.description] forState:UIControlStateNormal];
        [self.sendButton setTitle:[NSString stringWithFormat:@"发件箱(%@)",parameter.description] forState:UIControlStateSelected];
    };
    [self addChildViewController:email2];
    
    email1.view.frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight - 44 - BottomM);
    [self.view addSubview:email1.view];
    
    email2.view.frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight - 44 - BottomM);
    [self.view insertSubview:email2.view belowSubview:email1.view];
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
