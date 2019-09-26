//
//  HQTFInputCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFInputCell.h"

@interface HQTFInputCell ()


/** type */
@property (nonatomic, assign) NSInteger type;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldTrailW;

@end

@implementation HQTFInputCell


-(void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabel.textColor = ExtraLightBlackTextColor;
    self.textField.textColor = LightBlackTextColor;
    self.textField.secureTextEntry = YES;
    
    [self.textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.textField setAdjustsFontSizeToFitWidth:YES];
    
    [self.enterBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
    [self.enterBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    self.enterBtn.titleLabel.font = FONT(16);
    
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
    return cell;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
