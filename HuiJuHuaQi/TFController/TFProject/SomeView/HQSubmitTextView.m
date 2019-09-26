//
//  HQSubmitTextView.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/4/18.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQSubmitTextView.h"
#import "AppDelegate.h"
#import "HQWorkDetailTextView.h"


@interface HQSubmitTextView () <UITextViewDelegate>



@property (strong, nonatomic) IBOutlet UIView *contentView;


@property (strong, nonatomic) IBOutlet UIView *topView;


@property (strong, nonatomic) IBOutlet UIImageView *topImgView;


@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


@property (strong, nonatomic) IBOutlet HQWorkDetailTextView *contentTextView;


@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;


@property (strong, nonatomic) IBOutlet UIButton *sureBtn;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineXLayout;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineYLayout;


- (IBAction)cancelAction:(id)sender;


- (IBAction)sureAction:(id)sender;



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


@implementation HQSubmitTextView

- (void)awakeFromNib
{
    
    [super awakeFromNib];
    
    
    self.frame = CGRectMake(30, (SCREEN_HEIGHT - 265)/2, SCREEN_WIDTH - 60, 265);
    
    
    _lineXLayout.constant = 0.5;
    _lineYLayout.constant = 0.5;
    
    self.topView.layer.cornerRadius  = self.topView.width / 2;
    self.topView.layer.masksToBounds = YES;
    self.topView.backgroundColor = GreenColor;
    [self.topImgView setImage:[UIImage imageNamed:@"light_img"]];
    
    self.contentView.layer.cornerRadius  = 5;
    self.contentView.layer.masksToBounds = YES;
    
    self.contentTextView.delegate = self;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureButton) name:@"SureButtonCanClick" object:nil];
    
}


- (void)textViewDidChange:(UITextView *)textView{
    
    
    HQWorkDetailTextView *workDetailTextView = (HQWorkDetailTextView *)textView;
    NSInteger maxNum = 200;
    if (workDetailTextView.maxCharNum > 0) {
        maxNum = workDetailTextView.maxCharNum;
    }else if (workDetailTextView.maxTextNum > 0) {
        maxNum = workDetailTextView.maxTextNum;
    }
    
    
    if (![HQHelper textIsLegitimateWithStr:textView.text]) {
        
        [MBProgressHUD showError:@"请勿输入非法字符" toView:self];
        self.contentTextView.text = [textView.text substringWithRange:NSMakeRange(0, self.contentTextView.text.length-2)];
    }
    
    
    if ([HQHelper charNumber:textView.text] > maxNum) {
        NSString *errorStr = [NSString stringWithFormat:@"文字多于%d个字符", (int)maxNum];
        [MBProgressHUD showError:errorStr toView:self];
        self.contentTextView.text = [HQHelper returnCharLengthStr:textView.text withMaxNum:maxNum];
    }
}


- (void)sureButton{
    
    self.sureBtn.enabled = YES;
}

- (void)keyboardHide{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(30, (SCREEN_HEIGHT - 265)/2, SCREEN_WIDTH - 60, 265);
    }];
}

- (void)keyboardShow:(NSNotification *)niti{
    
    
    CGRect frame = [niti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(30, frame.origin.y - 265 - 20, SCREEN_WIDTH - 60, 265);
    }];
}



- (IBAction)cancelAction:(id)sender
{
    if (self.onLeftTouched) self.onLeftTouched();
    [self dismiss];
}

- (IBAction)sureAction:(id)sender
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"text"] = self.contentTextView.text;
    HQLog(@"%@", self.contentTextView.text);
    
//    if (self.contentTextView.text.length == 0) {
//        [MBProgressHUD showError:@"文字不能为空" toView:KeyWindow];
//        return;
//    }
    if (self.onRightTouched) self.onRightTouched(dict);
    [self dismiss];
}



- (void) dismiss {
    if (self.onDismiss) self.onDismiss();
//    [self removeFromSuperview];
}


+ (void)didBgViewAction:(UITapGestureRecognizer *)tap{
    
    UIView *bgView = tap.view;
    
    [UIView animateWithDuration:0.25 animations:^{
        bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
    }];
    
    
    
    //    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    //    [[window viewWithTag:0x444] removeFromSuperview];
    
    
}

/**
 * 提交文字
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void)submitTitlWithTitle:(NSString *)titleStr
                      text:(NSString *)text
             placeholderStr:(NSString *)placeholderStr
                LeftTouched:(ActionHandler)onLeftTouched
             onRightTouched:(gradeAction)onRightTouched
{
    
    [self submitTitlWithTitle:titleStr
                         text:text
               placeholderStr:placeholderStr
                   maxCharNum:200
                  LeftTouched:onLeftTouched
               onRightTouched:onRightTouched];
}



/**
 * 提交文字
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void)submitTitlWithTitle:(NSString *)titleStr
             placeholderStr:(NSString *)placeholderStr
                LeftTouched:(ActionHandler)onLeftTouched
             onRightTouched:(gradeAction)onRightTouched
{
    [self submitTitlWithTitle:titleStr text:nil placeholderStr:placeholderStr LeftTouched:onLeftTouched onRightTouched:onRightTouched];
}



/**
 * 提交文字
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 * @param maxCharNum  最大字符数
 */
+ (void)submitTitlWithTitle:(NSString *)titleStr
                       text:(NSString *)text
             placeholderStr:(NSString *)placeholderStr
                 maxCharNum:(NSInteger)maxCharNum
                LeftTouched:(ActionHandler)onLeftTouched
             onRightTouched:(gradeAction)onRightTouched
{
    // 当前窗体
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [[window viewWithTag:0x444] removeFromSuperview];
    
    // 背景mask窗体
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    bgView.tag = 0x444;
    bgView.alpha = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        bgView.alpha = 1;
    }];
    
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewAction:)];
//    [bgView addGestureRecognizer:tap];
    
    // 告警窗体
    HQSubmitTextView *view = [[[NSBundle mainBundle] loadNibNamed:@"HQSubmitTextView" owner:nil options:nil] firstObject];
    
    view.titleLabel.text = titleStr;
    view.contentTextView.placeholder = placeholderStr;
    view.contentTextView.text = text;
    view.contentTextView.maxCharNum = maxCharNum;
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
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:(CGRect){bgView.centerX,0, 74,74 }];
    image.centerX = bgView.centerX - 30;
    [image setImage:[UIImage imageNamed:@"灯泡"]];
    image.backgroundColor = RGBColor(0x00, 0xbb, 0x9d);
    image.contentMode = UIViewContentModeCenter;
    image.layer.cornerRadius = image.width * 0.5;
    image.layer.masksToBounds = YES;
    [view addSubview:image];
    
    // 显示窗体
    [window makeKeyAndVisible];
}





@end
