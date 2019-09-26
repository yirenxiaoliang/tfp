//
//  HQTFInputCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFInputCell.h"

@interface HQTFInputCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldCenter;

/** type */
@property (nonatomic, assign) NSInteger type;


@end

@implementation HQTFInputCell


-(void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabel.font = FONT(14);
    self.titleLabel.textColor = CellTitleNameColor;
    self.textField.textColor = LightBlackTextColor;
    self.textField.secureTextEntry = YES;
    
    [self.textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.textField setAdjustsFontSizeToFitWidth:YES];
    
    [self.enterBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
    [self.enterBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    self.enterBtn.titleLabel.font = FONT(16);
    self.requireLabel.hidden = YES;
    self.layer.masksToBounds = YES;
    
    self.enterBtn.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UIView *borderView = [[UIView alloc] init];
    [self.contentView insertSubview:borderView atIndex:0];
    borderView.layer.borderColor = CellClickColor.CGColor;
    borderView.layer.borderWidth = 0.5;
    self.borderView = borderView;
    borderView.hidden = YES;
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(95);
        make.top.equalTo(self.contentView).with.offset(15);
        make.bottom.equalTo(self.contentView).with.offset(-15);
        make.right.equalTo(self.contentView).with.offset(-15);
    }];
    
    self.textField.keyboardType = UIKeyboardTypeDefault;
    self.textField.secureTextEntry = NO;
    
}
- (IBAction)showNum:(UIButton *)sender {
    
    
    if (self.type == 1) {
        
        sender.selected = !sender.selected;
        
        self.textField.keyboardType = UIKeyboardTypeEmailAddress;
        self.textField.secureTextEntry = !sender.selected;
    }
    
    if (self.type != 1) {
        
        if ([self.delegate respondsToSelector:@selector(inputCellDidClickedEnterBtn:)]) {
            [self.delegate inputCellDidClickedEnterBtn:sender];
        }
    }
    
}


/** type 0:无进入按钮，1：进入按钮为图片 2：进入按钮为文字 */
- (void)refreshInputCellWithType:(NSInteger)type{
    
    self.type = type;
    
    switch (type) {
        case 0:
        {
            self.enterBtn.hidden = YES;
            self.textFieldTrailW.constant = 15;
            self.textField.secureTextEntry = NO;
            self.textField.keyboardType = UIKeyboardTypeDefault;
        }
            break;
        case 1:
        {
            self.enterBtn.hidden = NO;
            [self.enterBtn setImage:[UIImage imageNamed:@"不显示数字"] forState:UIControlStateNormal];
            [self.enterBtn setImage:[UIImage imageNamed:@"显示数字"] forState:UIControlStateSelected];
            [self.enterBtn setBackgroundImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){44,44}] forState:UIControlStateNormal];
            [self.enterBtn setBackgroundImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){44,44}] forState:UIControlStateHighlighted];
            [self.enterBtn setTitle:@"" forState:UIControlStateNormal];
            [self.enterBtn setTitle:@"" forState:UIControlStateHighlighted];
            self.textFieldTrailW.constant = 50;
            self.textField.secureTextEntry = YES;
            self.textField.keyboardType = UIKeyboardTypeEmailAddress;
        }
            break;
        case 2:
        {
            self.enterBtn.hidden = NO;
            [self.enterBtn setImage:nil forState:UIControlStateNormal];
            [self.enterBtn setImage:nil forState:UIControlStateSelected];
            [self.enterBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.enterBtn setTitle:@"获取验证码" forState:UIControlStateHighlighted];
            self.textFieldTrailW.constant = 120;
            self.textField.secureTextEntry = NO;
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case 3:
        {
            self.enterBtn.hidden = NO;
            [self.enterBtn setImage:[UIImage imageNamed:@"添加内容"] forState:UIControlStateNormal];
            [self.enterBtn setImage:[UIImage imageNamed:@"添加内容"] forState:UIControlStateSelected];
            
            [self.enterBtn setBackgroundImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){44,44}] forState:UIControlStateNormal];
            [self.enterBtn setBackgroundImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){44,44}] forState:UIControlStateHighlighted];
            [self.enterBtn setTitle:@"" forState:UIControlStateNormal];
            [self.enterBtn setTitle:@"" forState:UIControlStateHighlighted];
            self.textFieldTrailW.constant = 50;
            self.textField.keyboardType = UIKeyboardTypeDefault;
            self.textField.secureTextEntry = NO;
        }
            break;
            
        default:
            break;
    }
    
}

- (void)textChange:(UITextField *)textField{
    
    
    if ([self.delegate respondsToSelector:@selector(inputCellWithTextField:)]) {
        [self.delegate inputCellWithTextField:textField];
    }
    
}


+ (instancetype)inputCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFInputCell" owner:self options:nil] lastObject];
}

+ (HQTFInputCell *)inputCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFInputCell";
    HQTFInputCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self inputCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topLine.hidden = YES;
    cell.layer.masksToBounds = YES;
    return cell;
}


-(void)setIsHideBtn:(BOOL)isHideBtn{
    _isHideBtn = isHideBtn;
    
    if (isHideBtn) {
        self.enterBtn.hidden = YES;
        self.textFieldTrailW.constant = 0;
        
        [self.borderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-15);
        }];
    }else{
        
        self.enterBtn.hidden = NO;
        self.textFieldTrailW.constant = 36;
        
        [self.borderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-44);
        }];
    }
    
}

-(void)setStructure:(NSString *)structure{
    
    _structure = structure;
    
    if ([structure isEqualToString:@"0"]) {
        
        self.titleLabelCenter.constant = -12;
        
        self.inputLeftW.constant = 7;
        self.textFieldCenter.constant = 12;
        self.titleW.constant = SCREEN_WIDTH-30;
        
        [self.borderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(10);
            make.top.equalTo(self.contentView).with.offset(32);
            make.bottom.equalTo(self.contentView).with.offset(-15);
        }];
        
    }else{
        
        self.titleLabelCenter.constant = 0;
        
        self.titleW.constant = 90;
        self.inputLeftW.constant = 95;
        self.textFieldCenter.constant = 0;
        
        [self.borderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(95);
            make.top.equalTo(self.contentView).with.offset(15);
            make.bottom.equalTo(self.contentView).with.offset(-15);
        }];
    }
    
}

-(void)setFieldControl:(NSString *)fieldControl{
    _fieldControl = fieldControl;
    
    if ([fieldControl isEqualToString:@"2"]) {
        self.requireLabel.hidden = NO;
    }else{
        self.requireLabel.hidden = YES;
        
    }
    
}

double hypot(double x, double y) {
    return sqrt(x * x + y * y);
}

double distance(double wd1, double jd1, double wd2, double jd2) {// 根据经纬度坐标计算实际距离
    double x, y, out;
    double PI = 3.1415926535898;
    double R = 6.371229 * 1e6;
    x = (jd2 - jd1) * PI * R * cos( ( (wd1 + wd2) / 2) * PI / 180) / 180;
    y = (wd2 - wd1) * PI * R / 180;
    out = hypot(x, y);
    
    return out;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
