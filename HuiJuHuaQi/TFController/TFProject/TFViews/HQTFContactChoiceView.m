//
//  HQTFContactChoiceView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFContactChoiceView.h"
#import "AlertView.h"

@interface HQTFContactChoiceView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *companyBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verW;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *horView;
@property (weak, nonatomic) IBOutlet UIView *verView;

/** 标记选择了公司成员 还是 客户联系人 */
@property (nonatomic, assign) NSInteger company;


/**
 * 左按钮被点击函数
 */
@property (nonatomic, strong) ActionHandler onLeftTouched;

/**
 * 右按钮被点击函数
 */
@property (nonatomic, strong) ActionParameter onRightTouched;

/**
 * 关闭函数
 */
@property (nonatomic, strong) ActionHandler onDismiss;








@end

@implementation HQTFContactChoiceView


-(void)awakeFromNib{
    [super awakeFromNib];
    self.company = -1;
    self.sureBtn.enabled = NO;
    self.horView.backgroundColor = CellSeparatorColor;
    self.verView.backgroundColor = CellSeparatorColor;
    
    self.titleLabel.textColor = BlackTextColor;
    
    [self.companyBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    [self.companyBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateHighlighted];
    [self.contactBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    [self.contactBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateHighlighted];
    
    self.horH.constant = 0.5;
    self.verW.constant = 0.5;
    
    [self.cancelBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:LightGrayTextColor forState:UIControlStateHighlighted];
    
    [self.sureBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
    [self.sureBtn setTitleColor:LightGrayTextColor forState:UIControlStateDisabled];
    
    
    
    // 设置圆角
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.frame = CGRectMake((SCREEN_WIDTH - Long(320))/2, (SCREEN_HEIGHT - Long(200))/2, Long(320), Long(200));
    
}

- (IBAction)leftButtonTouched:(id)sender {
    if (self.onLeftTouched) self.onLeftTouched();
    [self dismiss];
    
}
- (IBAction)rightButtonTouched:(id)sender {
    if (self.onRightTouched) self.onRightTouched(@(self.company));
    [self dismiss];
}
- (IBAction)companyClick:(UIButton *)sender {
    
    self.company = 0;
    self.sureBtn.enabled = YES;
    
    self.contactBtn.selected = NO;
    sender.selected = YES;
    
}
- (IBAction)contactClick:(UIButton *)sender {
    
    self.company = 1;
    self.sureBtn.enabled = YES;
    
    self.companyBtn.selected = NO;
    sender.selected = YES;
}

- (void) dismiss {
    if (self.onDismiss) self.onDismiss();
    //    [self removeFromSuperview];
}

/**
 * 提示框
 * @param title 标题
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) showContactChoiceView:(NSString *)title
                 onLeftTouched:(ActionHandler)onLeftTouched
                onRightTouched:(ActionParameter)onRightTouched {
    
    // 当前窗体
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [[window viewWithTag:0x1234554321] removeFromSuperview];
    
    // 背景mask窗体
    UIButton *bgView = [[UIButton alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    bgView.tag = 0x1234554321;
    [bgView addTarget:self action:@selector(tapBgView:) forControlEvents:UIControlEventTouchDown];
    bgView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        bgView.alpha = 1;
    }];
    
    // 告警窗体
    HQTFContactChoiceView *view = [[[NSBundle mainBundle] loadNibNamed:@"HQTFContactChoiceView" owner:nil options:nil] firstObject];
    
    view.onLeftTouched = onLeftTouched;
    view.onRightTouched = onRightTouched;
    view.onDismiss = ^(void) {
        
        [UIView animateWithDuration:0.25 animations:^{
            bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
    };
    view.titleLabel.text = title;
    view.tag = 0x445;
    
    [bgView addSubview:view];
    [window addSubview:bgView];
    
    
    // 显示窗体
    [window makeKeyAndVisible];
}



+ (void)tapBgView:(UIButton *)tap{
    
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    [UIView animateWithDuration:0.25 animations:^{
        [window viewWithTag:0x1234554321].alpha = 0;
    } completion:^(BOOL finished) {
        [[window viewWithTag:0x1234554321] removeFromSuperview];
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
