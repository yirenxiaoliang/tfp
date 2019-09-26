//
//  AlertView.m
//  WeiYP
//
//  Created by erisenxu on 15/11/13.
//  Copyright © 2015年 tencent. All rights reserved.
//

#import "AlertView.h"
#import "AppDelegate.h"

@interface AlertView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIView *hBorder;
@property (weak, nonatomic) IBOutlet UIView *vBorder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hBorderHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vBorderHeight;


@property (weak, nonatomic) IBOutlet UIButton *rightButton;

- (IBAction)leftButtonTouched:(id)sender;
- (IBAction)rightButtonTouched:(id)sender;

/**
 * 左按钮被点击函数
 */
@property (nonatomic, strong) ActionHandler onLeftTouched;

/**
 * 右按钮被点击函数
 */
@property (nonatomic, strong) ActionHandler onRightTouched;

/**
 * 关闭函数
 */
@property (nonatomic, strong) ActionHandler onDismiss;

@end

@implementation AlertView

/**
 * 加载nib后初始化数据
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    self.hBorderHeight.constant = 0.5;
    self.vBorderHeight.constant = 0.5;
    self.titleLabel.font = FONT(20);
    self.titleLabel.textColor = BlackTextColor;
    
    self.infoLabel.font = FONT(16);
    self.infoLabel.textColor = ExtraLightBlackTextColor;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.numberOfLines = 0;
    
    [self.leftButton setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.rightButton setTitleColor:GreenColor forState:UIControlStateNormal];
    
    self.backgroundColor = WhiteColor;
    
    self.hBorder.backgroundColor = CellSeparatorColor;
    self.vBorder.backgroundColor = CellSeparatorColor;
    
    self.leftButton.titleLabel.font = FONT(20);
    self.rightButton.titleLabel.font = FONT(20);
    
    // 设置圆角
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.frame = CGRectMake((SCREEN_WIDTH - Long(320))/2, (SCREEN_HEIGHT - Long(200))/2, Long(320), Long(200));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/**
 * 左按钮处理
 */
- (IBAction)leftButtonTouched:(id)sender {
    if (self.onLeftTouched) self.onLeftTouched();
    [self dismiss];
}

/**
 * 右按钮处理
 */
- (IBAction)rightButtonTouched:(id)sender {
    if (self.onRightTouched) self.onRightTouched();
    [self dismiss];
}

- (void) dismiss {
    if (self.onDismiss) self.onDismiss();
//    [self removeFromSuperview];
}

/**
 * 提示框
 * @param title 标题
 * @param msg 内容
 * @param leftTitle 左按钮标题
 * @param rightTitle 右按钮标题
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) showAlertView:(NSString *)title
                   msg:(NSString *)msg
             leftTitle:(NSString *)leftTitle
            rightTitle:(NSString *)rightTitle
         onLeftTouched:(ActionHandler)onLeftTouched
        onRightTouched:(ActionHandler)onRightTouched {
    
    
    
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

    // 告警窗体
    AlertView *view = [[[NSBundle mainBundle] loadNibNamed:@"AlertView" owner:nil options:nil] firstObject];
    leftTitle = [leftTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!leftTitle || [@"" isEqualToString:leftTitle]) {
        view.leftButton.hidden = YES;
        view.vBorder.hidden = YES;
        view.leftConstraint.constant = -275;
    }
    rightTitle = [rightTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!rightTitle || [@"" isEqualToString:rightTitle]) {
        return;
    }
    view.onLeftTouched = onLeftTouched;
    view.onRightTouched = onRightTouched;
    view.onDismiss = ^(void) {
        
        [UIView animateWithDuration:0.25 animations:^{
            bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
    };
    if ([msg isEqualToString:@""]) {
        
        view.frame = CGRectMake((SCREEN_WIDTH - Long(320))/2, (SCREEN_HEIGHT - Long(200))/2, Long(320), Long(150));
    }
    view.titleLabel.text = title;
    view.infoLabel.text = msg;
    view.tag = 0x445;
    [view.leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [view.rightButton setTitle:rightTitle forState:UIControlStateNormal];
    [bgView addSubview:view];
    
    [UIView animateWithDuration:0.25 animations:^{
        bgView.alpha = 1;
    }];
    // 添加手势
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
//    [bgView addGestureRecognizer:tap];
    
//    UIImageView *image = [[UIImageView alloc] initWithFrame:(CGRect){(SCREEN_WIDTH - 74) * 0.5,SCREEN_HEIGHT * 0.5 - 85 - 37, 74,74 }];
//    [image setImage:[UIImage imageNamed:@"灯泡"]];
//    image.backgroundColor = RGBColor(0x00, 0xbb, 0x9d);
//    image.contentMode = UIViewContentModeCenter;
//    image.layer.cornerRadius = image.width * 0.5;
//    image.layer.masksToBounds = YES;
//    [bgView addSubview:image];
    
    [window addSubview:bgView];
    
    // 显示窗体
    [window makeKeyAndVisible];
}

/**
 * 提示框
 * @param msg 内容
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) showAlertView:(NSString *)msg
         onLeftTouched:(ActionHandler)onLeftTouched
        onRightTouched:(ActionHandler)onRightTouched {
    [AlertView showAlertView:@"提示" msg:msg leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:onLeftTouched onRightTouched:onRightTouched];
}


+ (void)tapBgView:(UIButton *)tap{
    
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    [UIView animateWithDuration:0.25 animations:^{
        [window viewWithTag:0x1234554321].alpha = 0;
    } completion:^(BOOL finished) {
        [[window viewWithTag:0x1234554321] removeFromSuperview];
    }];
}


/**
 *  移除背景点击事件
 */
+ (void)removeBgBtnActionWithAlerView
{
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    UIButton *bgBtn = (UIButton *)[window viewWithTag:0x1234554321];
    [bgBtn removeTarget:self action:@selector(tapBgView:) forControlEvents:UIControlEventTouchDown];
    [bgBtn addTarget:self    action:@selector(tapRemoveBgView:) forControlEvents:UIControlEventTouchDown];
}

+ (void)tapRemoveBgView:(UIButton *)tap
{
    HQLog(@"不干事");
}


//+ (void)tapBgView:(UITapGestureRecognizer *)tap{
//    
//    UIView *bgView = tap.view;
//    
//    [bgView removeFromSuperview];
//    
//    //    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
//    //    [[window viewWithTag:0x444] removeFromSuperview];
//    
//    
//}
@end
