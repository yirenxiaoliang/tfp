//
//  TFSendView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/31.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSendView.h"
#import "TFSendModel.h"

@interface TFSendView ()

@property (weak, nonatomic) IBOutlet UIView *titleBg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *peopleBtn;
@property (weak, nonatomic) IBOutlet UIView *sepeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepeViewH;
@property (weak, nonatomic) IBOutlet UIView *peopleBg;
@property (weak, nonatomic) IBOutlet UILabel *peopleName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *peopleHeight;
@property (weak, nonatomic) IBOutlet UIView *contentBg;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBgHeight;

@property (weak, nonatomic) IBOutlet UIView *timeBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeBgHeight;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *textBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textHeight;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *sepeVerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepeVerViewW;
@property (weak, nonatomic) IBOutlet UIView *btnBg;

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

/** TFSendModel */
@property (nonatomic, strong) TFSendModel *model;

@end

@implementation TFSendView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.titleBg.backgroundColor = ClearColor;
    self.peopleBg.backgroundColor = ClearColor;
    self.contentBg.backgroundColor = ClearColor;
    self.timeBg.backgroundColor = ClearColor;
    self.textBg.backgroundColor = ClearColor;
    self.btnBg.backgroundColor = ClearColor;
    
    self.titleLabel.textColor = BlackTextColor;
    self.titleLabel.font = FONT(18);
    self.peopleName.font = FONT(18);
    self.peopleName.textColor = BlackTextColor;
    self.peopleBtn.layer.cornerRadius = 2;
    self.peopleBtn.layer.masksToBounds = YES;
    
    self.contentLabel.textColor = ExtraLightBlackTextColor;
    self.contentLabel.font = FONT(14);
//    self.contentLabel.backgroundColor = RedColor;
    
    self.passwordLabel.font = FONT(14);
    self.endTimeLabel.font = FONT(14);
    
    [self.cancelBtn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
    [self.sureBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
    self.cancelBtn.titleLabel.font =FONT(20);
    self.sureBtn.titleLabel.font = FONT(20);
    
    self.sepeView.backgroundColor = CellSeparatorColor;
    self.sepeVerView.backgroundColor = CellSeparatorColor;
    self.sepeViewH.constant = 0.5;
    self.sepeVerViewW.constant = 0.5;
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    self.btnBg.layer.borderColor = CellSeparatorColor.CGColor;
    self.btnBg.layer.borderWidth = 0.5;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    [self.textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventValueChanged];
    
}


- (void)keyboardShow:(NSNotification *)notification{
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    HQLog(@"%f",animationTime);
    
    [UIView animateWithDuration:animationTime animations:^{
        
        self.bottom = SCREEN_HEIGHT - keyBoardFrame.size.height - 20;
    }];

    
}

- (void)keyboardHide:(NSNotification *)notification{
    
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        
        self.centerY = SCREEN_HEIGHT/2;
    }];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

/**
 * 左按钮处理
 */
- (IBAction)cancelClicked:(UIButton *)sender {
    
    if (self.onLeftTouched) self.onLeftTouched();
    [self dismiss];
}

/**
  * 右按钮处理
  */
- (IBAction)sureClicked:(UIButton *)sender {
    
    self.model.inputText = self.textField.text;
    if (self.onRightTouched) self.onRightTouched(self.model);
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
                people:(HQEmployModel *)people
               content:(NSString *)content
              password:(NSString *)password
               endTime:(NSString *)endTime
            placehoder:(NSString *)placehoder
         onLeftTouched:(ActionHandler)onLeftTouched
        onRightTouched:(ActionParameter)onRightTouched{
    
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
    TFSendView *view = [[[NSBundle mainBundle] loadNibNamed:@"TFSendView" owner:nil options:nil] firstObject];
  
    view.onLeftTouched = onLeftTouched;
    view.onRightTouched = onRightTouched;
    view.onDismiss = ^(void) {
        
        [UIView animateWithDuration:0.25 animations:^{
            bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
    };
    view.model = [[TFSendModel alloc] init];
    view.model.content = content;
    view.model.password = password;
    view.model.endTime = endTime;
    view.model.people = people;
    
    view.titleLabel.text = title;
    view.contentLabel.text = content;
    
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){Long(325-45),MAXFLOAT} titleStr:content];
    
    view.contentBgHeight.constant = size.height + 14;
    
    
    if (people && ![people.employeeName isEqualToString:@""]) {
        
        view.peopleName.text = people.employeeName;
        [view.peopleBtn sd_setImageWithURL:[HQHelper URLWithString:people.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
        [view.peopleBtn sd_setImageWithURL:[HQHelper URLWithString:people.photograph] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
    }else{
        
        view.peopleBg.hidden = YES;
        view.peopleHeight.constant = 0;
    }
    
    if ((password && ![password isEqualToString:@""]) && (endTime && ![endTime isEqualToString:@""])) {
        
        view.passwordLabel.attributedText = [TFSendView attributeStringWithTitle:@"访问密码：" withContent:password];
        
        view.endTimeLabel.attributedText = [TFSendView attributeStringWithTitle:@"有效期至：" withContent:endTime];
    }else{
        
        view.timeBg.hidden = YES;
        view.timeBgHeight.constant = 0;
        
    }
    if (placehoder && ![placehoder isEqualToString:@""]) {
        
        view.textField.placeholder = placehoder;
    }else{
        view.textBg.hidden = YES;
        view.textHeight.constant = 0;
    }
    
    CGFloat height = 50;
    
    if (people) {
        height += 45;
    }
    
    if (content) {
        height += (size.height + 14);
    }
    
    if (password && endTime) {
        
        height += 45;
    }
    
    if (placehoder) {
        height += 70;
    }
    height += 70;
    
    view.frame = CGRectMake((SCREEN_WIDTH - Long(325))/2, (SCREEN_HEIGHT - height)/2, Long(325), height);
    
    view.tag = 0x445;
    
    [bgView addSubview:view];
    
    [UIView animateWithDuration:0.25 animations:^{
        bgView.alpha = 1;
    }];
    
    
    [window addSubview:bgView];
    
    // 显示窗体
    [window makeKeyAndVisible];
}

+(NSAttributedString *)attributeStringWithTitle:(NSString *)title withContent:(NSString *)content{
    
    NSString *totalString = [NSString stringWithFormat:@"%@%@",title,content];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:totalString];
    [string addAttribute:NSForegroundColorAttributeName value:ExtraLightBlackTextColor range:[totalString rangeOfString:title]];
    [string addAttribute:NSForegroundColorAttributeName value:FinishedTextColor range:[totalString rangeOfString:content]];
    [string addAttribute:NSFontAttributeName value:FONT(14) range:(NSRange){0,totalString.length}];
    
    return string;
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
