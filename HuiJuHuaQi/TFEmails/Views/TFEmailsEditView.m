//
//  TFEmailsEditView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailsEditView.h"
#import "TFTextField.h"
#import "TFEmailPersonModel.h"

#define Margin 5

@interface TFEmailsEditView ()<UITextFieldDelegate,TFTextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *textFields;

//输入框的值
@property (nonatomic, strong) NSMutableArray *texts;

@property (nonatomic, strong) TFEmailPersonModel *personModel;

@property (nonatomic, strong) UITextField *startField;

@property (nonatomic, strong) UITextField *endField;

@property (nonatomic, assign) BOOL isHand;
@property (nonatomic, assign) BOOL isSame;

@end

@implementation TFEmailsEditView

-(NSMutableArray *)textFields{
    if (!_textFields) {
        _textFields = [NSMutableArray array];
    }
    return _textFields;
}

-(NSMutableArray *)texts{
    if (!_texts) {
        _texts = [NSMutableArray array];
    }
    return _texts;
}

- (TFEmailPersonModel *)personModel {

    if (!_personModel) {
        
        _personModel = [[TFEmailPersonModel alloc] init];
    }
    return _personModel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self=[super initWithFrame:frame]) {
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    TFTextField *textField = [[TFTextField alloc] initWithFrame:(CGRect){0,10,self.width,30}];
    
    textField.tf_delegate = self;
    textField.delegate = self;
    textField.textColor = LightBlackTextColor;
    textField.secureTextEntry = YES;
    
    [ textField setAdjustsFontSizeToFitWidth:YES];
    textField.returnKeyType = UIReturnKeyDone;
    textField.secureTextEntry = NO;
    textField.font = FONT(14);
    textField.placeholder = @"请输入";
    [self addSubview: textField];
    
//    textField.backgroundColor = GreenColor;
    [self.textFields addObject:textField];
}

/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    self.recordField = textField;
    return YES;
    
}
*/
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.startField = textField;
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if ([textField isEqual:self.recordField]) {
//        return ;
//    }
    if (textField.text.length == 0) {
        return;
    }
    //正则校验
    BOOL isEmail = [HQHelper validateEmail:textField.text];
    
    if (isEmail) {
        
        textField.textColor = GreenColor;
    }
    else {
        
        textField.textColor = RedColor;
    }
    
    if (!self.name) {
        
        self.name = @"";
    }
    
    if (!self.isSelect) {
        
        TFEmailPersonModel *model = [[TFEmailPersonModel alloc] init];
        model.mail_account = textField.text;
        model.employee_name = @"";
        
        BOOL have = NO;
        for (NSInteger i = 0; i < self.textFields.count-1;i++) {
            TFTextField *account = self.textFields[i];
            account.text = [account.text stringByReplacingOccurrencesOfString:@"、" withString:@""];
            if ([account.text isEqualToString:model.mail_account]) {
                
                have = YES;
                break;
            }
        }
        if (!have) {
            
            [self.texts addObject:model];
            
            
        }
        else {
            
            if (self.textFields.count>1) {
                
                
                textField.text = @"";
            }
            
        }
        
//        textField.text = [NSString stringWithFormat:@"%@、",textField.text];
    }
    else {
        
                self.isSelect = NO;
        
                TFEmailPersonModel *model = [[TFEmailPersonModel alloc] init];
                model.mail_account = textField.text;
                model.employee_name = self.name;
                [self.texts addObject:model];
        
                textField.text = [NSString stringWithFormat:@"%@%@",self.name,textField.text];
        
    }
//        textField.text = [textField.text substringToIndex:textField.text.length - 1];
//        textField.text = [NSString stringWithFormat:@"%@、",textField.text];

    self.isHand = YES;
    [self createTextField:nil];
//    [textField resignFirstResponder];
//    [self setNeedsLayout];
    
}

- (void)tfTextFieldDeleteBackward:(TFTextField *)textField {

    NSLog(@"删除...");
    
//    if (textField.text.length >0) {
//        
//        NSString *str = [textField.text substringToIndex:1];
//        if (![str isEqualToString:@" "]) {
//            
//            textField.text = [@" " stringByAppendingString:textField.text];
//        }
//    }

    if (![textField.text isEqualToString:@""]) { //非选择，正在输入删除不执行下面代码
        
        return;
    }
    
    if (self.textFields.count <= 1) {
        
        return;
    }
    
    [self.textFields[self.textFields.count-2] removeFromSuperview];
    
    [self.textFields removeObjectAtIndex:self.textFields.count-2];
    
    if (self.texts.count >= 1) {
        
        [self.texts removeObjectAtIndex:self.texts.count-1];
    }
    
    
    
    [self setNeedsLayout];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.text.length == 0) {
        return NO;
    }
    
    //清空之前存在的数据
//    [self.texts removeAllObjects];
    
    
    HQLog(@"------------textField------------%@",textField.text);
    

    
    
    //正则校验
//    BOOL isEmail = [HQHelper validateEmail:textField.text];
//
//    if (isEmail) {
//
//        textField.textColor = GreenColor;
//    }
//    else {
//
//        textField.textColor = RedColor;
//    }
    
//    if (!self.name) {
//
//        self.name = @"";
//    }
    
//    if (!self.isSelect) {
//
//        TFEmailPersonModel *model = [[TFEmailPersonModel alloc] init];
//        model.mail_account = textField.text;
//        model.employee_name = @"";
//
//        BOOL have = NO;
//        for (NSInteger i = 0; i < self.textFields.count-1;i++) {
//            TFTextField *account = self.textFields[i];
//            account.text = [account.text stringByReplacingOccurrencesOfString:@"、" withString:@""];
//            if ([account.text isEqualToString:model.mail_account]) {
//
//                have = YES;
//                break;
//            }
//        }
//        if (!have) {
//
//            [self.texts addObject:model];
//
//
//        }
//        else {
//
//            if (self.textFields.count>1) {
//
//
//                textField.text = @"";
//                return YES;
//            }
//
//        }
//
//        textField.text = [NSString stringWithFormat:@"%@、",textField.text];
//
//    }
//    else {
//
//        self.isSelect = NO;
//
//        TFEmailPersonModel *model = [[TFEmailPersonModel alloc] init];
//        model.mail_account = textField.text;
//        model.employee_name = self.name;
//        [self.texts addObject:model];
//
//        textField.text = [NSString stringWithFormat:@"%@%@、",self.name,textField.text];
//    }
    
//    textField.text = [textField.text substringToIndex:textField.text.length - 1];
    
    self.isSame = YES;
    [textField resignFirstResponder];
    [self createTextField:nil];
    
    [self setNeedsLayout];
    
    return YES;
}

- (void)createTextField:(NSString *)text {
    
    TFTextField *textField = [[TFTextField alloc] initWithFrame:(CGRect){0,10,self.width,30}];
    textField.tf_delegate = self;
    textField.frame = CGRectZero;
    textField.delegate = self;
    textField.textColor = LightBlackTextColor;
    textField.secureTextEntry = YES;
    textField.font = FONT(14);
    
    
    
    [ textField setAdjustsFontSizeToFitWidth:YES];
    textField.returnKeyType = UIReturnKeyDone;
    textField.secureTextEntry = NO;
    
    [self addSubview: textField];
    if (self.isHand) {
        
         [textField resignFirstResponder];
    }
    else {
        
         [textField resignFirstResponder];
    }
//    [textField becomeFirstResponder];
    [self.textFields addObject:textField];
    
    if (self.isSelect) {
        
        textField.text = text;
        
//        [self textFieldShouldReturn:textField];
        [self textFieldDidEndEditing:textField];
    }
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    CGFloat X = 0;
    CGFloat Y = 10;
    
    for (TFTextField *textField in self.textFields) {
        
        textField.userInteractionEnabled = NO;
        CGSize size = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){self.width,30} titleStr:textField.text];
        
//        if (size.width > 200) {
//            size = CGSizeMake(200, 30);
//        }
        
        
        if (X + size.width + Margin <= self.width) {// 同行
            
            textField.frame = CGRectMake(X, Y, size.width, 30);
            X += (size.width + Margin);
            
        }else{// 换行
            
            if (self.width - X - size.width > 60) {
                
                textField.frame = CGRectMake(X, Y, self.width-X, 30);
                
            }else{
                
                Y += (30 + Margin);
                X = 0;
                textField.frame = CGRectMake(X, Y, size.width, 30);
                X += (size.width + Margin);
            }
            
        }
        
        textField.textAlignment = NSTextAlignmentCenter;
//        textField.backgroundColor = RedColor;
        textField.layer.cornerRadius = 15;
        textField.layer.masksToBounds = YES;
        
        if (self.textFields.lastObject == textField) {
            
            if (X > self.width-40) {
                
                Y += (30 + Margin);
                X = 0;
            }
            
            textField.textAlignment = NSTextAlignmentLeft;
//            textField.backgroundColor = GreenColor;
            textField.frame = CGRectMake(X, Y, self.width-X, 30);
            textField.layer.cornerRadius = 0;
//            textField.layer.masksToBounds = YES;
            
        }
        
    }

    //刷新高度代理
    if ([self.delegate respondsToSelector:@selector(editViewHeight:type:)]) {
        
        [self.delegate editViewHeight:Y+40 type:self.type];
    }
    
    //传值代理
    
    if ([self.delegate respondsToSelector:@selector(editViewTextWithArray:type:)]) {
        
        [self.delegate editViewTextWithArray:self.texts type:self.type];
    }
    
    TFTextField *textField = self.textFields.lastObject;
    self.endField = textField;
    textField.userInteractionEnabled = YES;
    
    if (self.isSame) {
        
        [self.endField becomeFirstResponder];
    }
    else {
        
        if (self.startField) {
            
            if (self.endField != self.startField) {
                [self.startField becomeFirstResponder];
            }else{
                [textField becomeFirstResponder];
            }
        }else{
            [textField becomeFirstResponder];
        }
    }
    
}

@end
