//
//  TFEmailsEditCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailsEditCell.h"

@interface TFEmailsEditCell ()<UITextFieldDelegate,TFEmailsEditViewDelegate>



@end

@implementation TFEmailsEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.requireLab = [UILabel initCustom:CGRectZero title:@"*" titleColor:kUIColorFromRGB(0xF42F2F) titleFont:14 bgColor:ClearColor];
        
        
        
        [self addSubview:self.requireLab];
        
        [self.requireLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@7);
            make.top.equalTo(@15);
            make.width.equalTo(@8);
            make.height.equalTo(@20);
            
        }];
        
        
        self.titleLab = [UILabel initCustom:CGRectZero title:@"收件人" titleColor:kUIColorFromRGB(0x2D2D00) titleFont:14 bgColor:ClearColor];
        
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:self.titleLab];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.requireLab.mas_right).offset(0);
            make.top.equalTo(@15);
            make.width.equalTo(@50);
            make.height.equalTo(@20);
            
        }];
        
        
        
        
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addBtn.frame = CGRectZero;
        
        [self.addBtn setImage:IMG(@"添加收件人") forState:UIControlStateNormal];
        
        [self addSubview:self.addBtn];
        
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(@(-14));
            make.bottom.equalTo(@(-14));
            make.width.height.equalTo(@22);
            
        }];
        
        self.editView = [[TFEmailsEditView alloc] initWithFrame:CGRectZero];
        
        self.editView.delegate = self;
        
        [self.contentView addSubview:self.editView];
        
        [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.titleLab.mas_right).offset(10);
            make.right.equalTo(self.addBtn.mas_left).offset(-10);
            make.top.equalTo(@15);
            make.height.greaterThanOrEqualTo(@22);
            
        }];
        
        
//        self.textField = [[UITextField alloc] init];
//        self.textField.frame = CGRectZero;
//        self.textField.delegate = self;
//        self.textField.textColor = LightBlackTextColor;
//        self.textField.secureTextEntry = YES;
//        
////        [self.textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
//        [self.textField setAdjustsFontSizeToFitWidth:YES];
//        self.textField.returnKeyType = UIReturnKeyDone;
//        self.textField.secureTextEntry = NO;
//        
//        [self addSubview:self.textField];
//        
//        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.equalTo(self.titleLab.mas_right).offset(10);
//            make.right.equalTo(@46);
//            make.top.equalTo(@15);
//            make.height.equalTo(@22);
//            
//        }];

        
    }
    
    return self;
    
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//
//    if ([self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
//        
//        [self.editView textFieldShouldReturn:textField];
//    }
//
////    [self.editView textFieldShouldReturn:textField];
//    
//    return YES;
//}

- (void)editViewHeight:(float)height {

    if ([self.delegate respondsToSelector:@selector(editCellHeight:)]) {
        
        [self.editView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.titleLab.mas_right).offset(10);
            make.right.equalTo(self.addBtn.mas_left).offset(-10);
            make.top.equalTo(@15);
            make.height.greaterThanOrEqualTo(@(height));
            
        }];
        
        [self.delegate editCellHeight:height];
    }
}

+ (instancetype)emailsEditCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFEmailsEditCell";
    TFEmailsEditCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFEmailsEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    return cell;
    
}

@end
