//
//  TFSelectDateView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/5.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectDateView.h"
#import "HQSelectTimeView.h"
#import "TFDateView.h"

@interface TFSelectDateView ()<TFDateViewDelegate>

/** type */
@property (nonatomic, assign) DateViewType type;
/** timeSp */
@property (nonatomic, assign) long long timeSp;

/**  右按钮被点击函数  */
@property (nonatomic, strong) Action onRightTouched;
/** 关闭函数 */
@property (nonatomic, strong) ActionHandler onDismiss;

/** 确定后返回的选中时间字符串 */
@property (nonatomic , copy) NSString *selectedDate;
@end

@implementation TFSelectDateView


-(instancetype)initWithFrame:(CGRect)frame withType:(DateViewType)type timeSp:(long long)timeSp{
    if (self = [super initWithFrame:frame]) {
        
        [self setupChildWithType:type timeSp:timeSp];
        
        self.type = type;
        self.timeSp = timeSp;
        
    }
    return self;
}


- (void)setupChildWithType:(DateViewType)type timeSp:(long long)timeSp{
    
    self.backgroundColor = WhiteColor;
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,self.width,40}];
    [self addSubview:view];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:clearButton];
    [clearButton setTitle:@"取消" forState:UIControlStateNormal];
    [clearButton setTitle:@"取消" forState:UIControlStateHighlighted];
    clearButton.frame = CGRectMake(0, 0, 60, 40);
    [clearButton setTitleColor:GreenColor forState:UIControlStateNormal];
    [clearButton setTitleColor:GreenColor forState:UIControlStateHighlighted];
    clearButton.titleLabel.font = BFONT(14);
    [clearButton addTarget:self action:@selector(clearClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,200,40}];
    [view addSubview:label];
    label.text = @"请选择日期";
    label.font = BFONT(14);
    label.textColor = BlackTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake(view.width/2, view.height/2);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:button];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitle:@"确定" forState:UIControlStateHighlighted];
    button.frame = CGRectMake(self.width-60, 0, 60, 40);
    [button setTitleColor:GreenColor forState:UIControlStateNormal];
    [button setTitleColor:GreenColor forState:UIControlStateHighlighted];
    button.titleLabel.font = BFONT(14);
    [button addTarget:self action:@selector(sureClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    TFDateView *dateView = [TFDateView selectDateViewWithFrame:(CGRect){0,40,self.width,Long(200)} type:type timeSp:timeSp];
    dateView.delegate = self;
    dateView.timeSp = timeSp;
    [self addSubview:dateView];
}

- (void)clearClicked:(UIButton *)button{
    
    [self dismiss];
//    if (self.onRightTouched) self.onRightTouched(@"");
}

#pragma mark - TFDateViewDelegate
-(void)dateView:(TFDateView *)dateView selectDate:(NSString *)selectDate{
    
    self.selectedDate = selectDate;
}

- (void) dismiss {
    if (self.onDismiss) self.onDismiss();
}

- (void)sureClicked:(UIButton *)button{
    
    [self dismiss];
    if (self.onRightTouched) self.onRightTouched(self.selectedDate);
}

/**
 * 时间选择
 *
 * @param dateType 时间选择器类型
 * @param timeSp   开始时间
 * @param onRightTouched 右按钮被点击
 */
+ (void) selectDateViewWithType:(DateViewType)type
                         timeSp:(long long)timeSp
                 onRightTouched:(Action)onRightTouched{
    
    // 当前窗体
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [[window viewWithTag:0x98765] removeFromSuperview];
    
    // 背景mask窗体
    UIButton *bgView = [[UIButton alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    bgView.tag = 0x98765;
    [bgView addTarget:self action:@selector(tapBgView:) forControlEvents:UIControlEventTouchDown];
    bgView.alpha = 0;
    
    // 告警窗体
    TFSelectDateView *view = [[TFSelectDateView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-(55+Long(200)),SCREEN_WIDTH,55+Long(200)} withType:type timeSp:timeSp];
    view.type = type;
    view.timeSp = timeSp;
    view.onRightTouched = onRightTouched;
    __weak UIView *weakView = view;
    view.onDismiss = ^(void){
        [UIView animateWithDuration:0.35 animations:^{
            weakView.y = SCREEN_HEIGHT;
            bgView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
        
    };
    view.tag = 0x11111;
    [bgView addSubview:view];
    [window addSubview:bgView];
    
    // 动画显示
    [UIView animateWithDuration:0.35 animations:^{
        view.y = SCREEN_HEIGHT -(55+Long(200));
        bgView.alpha = 1;
        
    }];
    // 显示窗体
    [window makeKeyAndVisible];

}

+ (void)tapBgView:(UIButton *)tap{
    
    
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    [UIView animateWithDuration:0.35 animations:^{
        [window viewWithTag: 0x11111].y = SCREEN_HEIGHT;
        [window viewWithTag:0x98765].alpha = 0;
        
    } completion:^(BOOL finished) {
        [[window viewWithTag:0x98765] removeFromSuperview];
    }];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
