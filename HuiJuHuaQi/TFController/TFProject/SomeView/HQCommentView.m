//
//  HQCommentView.m
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/15.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQCommentView.h"
#import "StarSlider.h"
#import "AppDelegate.h"
#import "HQStarTextView.h"

@interface HQCommentView ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet StarSlider *star;
@property (weak, nonatomic) IBOutlet HQStarTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *margin;
@property (weak, nonatomic) IBOutlet UIView *separactor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepaCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starLeadW;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) UIView *groudView;
/**
 * 左按钮被点击函数
 */
@property (nonatomic, strong) ActionHandler onLeftTouched;

/**
 * 右按钮被点击函数
 */
@property (nonatomic, strong) gradeAction onRightTouched;

/**
 * 关闭函数
 */
@property (nonatomic, strong) ActionHandler onDismiss;
@end

@implementation HQCommentView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.sepaCons.constant = 0.5;
    self.marginCons.constant = 0.5;
    self.title.textColor = BlackTextColor;
    self.title.font = FONT(17);
    self.separactor.backgroundColor = CellSeparatorColor;
    self.margin.backgroundColor = CellSeparatorColor;
    self.bgView.backgroundColor = WhiteColor;
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    [self.leftBtn  setTitleColor:GreenColor forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:GrayTextColor forState:UIControlStateDisabled];
    self.textView.placeholder = @"来点评一下吧";
    self.rightBtn.enabled = NO;
    self.frame = CGRectMake((SCREEN_WIDTH - 300) * 0.5, (SCREEN_HEIGHT - 265)/2, 300, 265);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureButton) name:@"SureButtonCanClick" object:nil];
    self.textView.delegate = self;
//    self.starLeadW.constant = Long(60);
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 100) {
        [MBProgressHUD showError:@"文字多于100字" toView:self];
        self.textView.text = [textView.text substringWithRange:NSMakeRange(0, 100)];
    }
}

- (void)sureButton{
    self.rightBtn.enabled = YES;
}

- (void)keyboardHide{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake((SCREEN_WIDTH - 300) * 0.5, (SCREEN_HEIGHT - 265)/2,  300, 265);
    }];
}
- (void)keyboardShow:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    HQLog(@"%@", dict);
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake((SCREEN_WIDTH - 300) * 0.5, (SCREEN_HEIGHT - rect.size.height  - 265) * 0.5,  300, 265);
    }];
}

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
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"value"] = @((self.star.value + 1)  / 2);
//    dict[@"text"] = self.textView.text;
    dict[@"text"] = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    HQLog(@"%@ %ld", self.textView.text, self.star.value);
    if (self.onRightTouched) self.onRightTouched(dict);
    [self dismiss];
}

- (void) dismiss {
    if (self.onDismiss) self.onDismiss();
//    [self removeFromSuperview];
}



/**
 * 评分
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) commentGradeWithLeftTouched:(ActionHandler)onLeftTouched
                      onRightTouched:(gradeAction)onRightTouched {
    
    // 当前窗体
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [[window viewWithTag:0x444] removeFromSuperview];
    
    // 背景mask窗体
    UIButton *bgView = [[UIButton alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    bgView.tag = 0x444;
    bgView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        bgView.alpha = 1;
    } completion:nil];
    
    
//    [bgView addTarget:self action:@selector(tapBgView:) forControlEvents:UIControlEventTouchDown];
    
    // 添加手势
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
//    [bgView addGestureRecognizer:tap];
    // 告警窗体
    HQCommentView *view = [[[NSBundle mainBundle] loadNibNamed:@"HQCommentView" owner:nil options:nil] firstObject];
    
    view.onLeftTouched = onLeftTouched;
    view.onRightTouched = onRightTouched;
    view.onDismiss = ^(void){
        
        [UIView animateWithDuration:0.25 animations:^{
            bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
    };
    view.tag = 0x445;
    [bgView addSubview:view];
    [window addSubview:bgView];
    
    // 显示窗体
    [window makeKeyAndVisible];
}

+ (void)tapBgView:(UIButton *)tap{
    
    
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [UIView animateWithDuration:0.25 animations:^{
        [window viewWithTag:0x444].alpha = 0;
    } completion:^(BOOL finished) {
        [[window viewWithTag:0x444] removeFromSuperview];
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
