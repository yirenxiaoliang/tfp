//
//  HQNotPassSubmitView.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/7/4.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTwoLableSubmitView.h"
#import "AppDelegate.h"
#import "HQWorkDetailTextView.h"

@interface HQTwoLableSubmitView () <UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UIView *contentView;


@property (strong, nonatomic) IBOutlet UIView *topView;


@property (strong, nonatomic) IBOutlet UIImageView *topImgView;


@property (strong, nonatomic) IBOutlet HQWorkDetailTextView *contentTextView;
@property (weak, nonatomic) IBOutlet HQWorkDetailTextView *secondContentTV;
@property (weak, nonatomic) IBOutlet UILabel *secondTitle;


@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;


@property (strong, nonatomic) IBOutlet UIButton *sureBtn;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineXLayout;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineYLayout;

@property (weak, nonatomic) IBOutlet UILabel *title;

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


@implementation HQTwoLableSubmitView


- (void)awakeFromNib
{
    
    [super awakeFromNib];
    
    
    self.frame = CGRectMake(30, (SCREEN_HEIGHT - 255)/2, SCREEN_WIDTH - 60, 260);
    
    
    _lineXLayout.constant = 0.5;
    _lineYLayout.constant = 0.5;
    
    self.topView.layer.cornerRadius  = self.topView.width / 2;
    self.topView.layer.masksToBounds = YES;
    self.topImgView.layer.cornerRadius  = self.topImgView.width / 2;
    self.topImgView.layer.masksToBounds = YES;
    self.topView.hidden = YES;
    
    self.contentView.layer.cornerRadius  = 5;
    self.contentView.layer.masksToBounds = YES;
    
    self.contentTextView.delegate = self;
    
    [self insertSubview:self.topView aboveSubview:self.contentView];
    
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
        self.frame = CGRectMake(30, (SCREEN_HEIGHT - 255)/2, SCREEN_WIDTH - 60, 260);
    }];
}

- (void)keyboardShow:(NSNotification *)niti{
    
    
    CGRect frame = [niti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(30, frame.origin.y - 255 - 20, SCREEN_WIDTH - 60, 260);
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
    dict[@"text2"] = self.contentTextView.text;
    dict[@"text1"] = self.secondContentTV.text;
    HQLog(@"%@", self.contentTextView.text);
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
    }completion:^(BOOL finished) {
        [bgView removeFromSuperview];
    }];
}


/**
 * 提交文字
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void)submitPlaceholderStr:(NSString *)placeholderStr secondPlaceholder:(NSString *)secondPlaceholder
                       title:(NSString *)title secondTitle:(NSString *)secondTitle
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
    HQTwoLableSubmitView *view = [[[NSBundle mainBundle] loadNibNamed:@"HQTwoLableSubmitView" owner:nil options:nil] firstObject];
    view.contentTextView.placeholder = placeholderStr;
    view.contentTextView.maxCharNum = maxCharNum;
//    _returnMoneytextView.layer.backgroundColor = [[UIColor clearColor] CGColor];
//    _returnMoneytextView.layer.borderColor = [[UIColor redColor]CGColor];
//    _returnMoneytextView.layer.borderWidth = 1.0;
//    [_returnMoneytextView.layer setMasksToBounds:YES];
    view.contentTextView.layer.borderColor = [GrayTextColor CGColor];
    view.contentTextView.layer.borderWidth = 1.0;
    view.contentTextView.layer.cornerRadius = 2.0;
    view.contentTextView.layer.masksToBounds = YES;
    /** 07.27 */
    view.contentTextView.keyboardType = UIKeyboardTypeNumberPad;
    
    view.secondContentTV.placeholder = secondPlaceholder;
    view.secondContentTV.maxCharNum = maxCharNum;
    //    _returnMoneytextView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    //    _returnMoneytextView.layer.borderColor = [[UIColor redColor]CGColor];
    //    _returnMoneytextView.layer.borderWidth = 1.0;
    //    [_returnMoneytextView.layer setMasksToBounds:YES];
    view.secondContentTV.layer.borderColor = [GrayTextColor CGColor];
    view.secondContentTV.layer.borderWidth = 1.0;
    view.secondContentTV.layer.cornerRadius = 2.0;
    view.secondContentTV.layer.masksToBounds = YES;
    /** 07.27 */
    view.secondContentTV.keyboardType = UIKeyboardTypeNumberPad;
    
    view.onLeftTouched = onLeftTouched;
    view.onRightTouched = onRightTouched;
    view.title.text = title;
    view.title.font = FONT(16);
    view.title.textColor = kUIColorFromRGB(0x333333);
    view.title.textAlignment = NSTextAlignmentLeft;
    
    view.secondTitle.text = secondTitle;
    view.secondTitle.font = FONT(16);
    view.secondTitle.textColor = kUIColorFromRGB(0x333333);
    view.secondTitle.textAlignment = NSTextAlignmentLeft;
    
    view.onDismiss = ^(void){
        [UIView animateWithDuration:0.25 animations:^{
            bgView.alpha = 0;
        }completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
    };
    view.tag = 0x445;
    [bgView addSubview:view];
    [window addSubview:bgView];
    
    // 显示窗体
    [window makeKeyAndVisible];
}


@end
