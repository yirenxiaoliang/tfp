//
//  TFEmailNameView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/9/21.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailNameView.h"
#import "TFEmailPersonModel.h"
#import "TFTextField.h"
#define Margin 8
#define Height 22
#define FieldMinW 60

@interface TFEmailNameView ()<UITextFieldDelegate,TFTextFieldDelegate>

/** 输入框 */
@property (nonatomic, weak) TFTextField *textField;

/** peoples */
@property (nonatomic, strong) NSMutableArray *peoples;

@end

@implementation TFEmailNameView

-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        TFTextField *textField = [[TFTextField alloc] init];
        [self addSubview:textField];
        self.textField = textField;
        textField.tf_delegate = self;
        [textField setAdjustsFontSizeToFitWidth:YES];
        textField.returnKeyType = UIReturnKeyDone;
        textField.secureTextEntry = NO;
        textField.font = FONT(14);
        textField.placeholder = @"请输入";
        textField.delegate = self;
        self.backgroundColor = WhiteColor;
        [textField addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEnd];
    }
    return self;
}

-(void)endEdit:(UITextField *)textField{
    
    if (textField.text.length > 0) {
        if (![HQHelper checkEmail:textField.text]) {
            textField.text = @"";
            [MBProgressHUD showError:@"邮箱格式不正确" toView:KeyWindow];
        }else{
            [self textFieldShouldReturn:textField];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    if (textField.text.length > 0) {
        
        if (![HQHelper checkEmail:textField.text]) {
            [MBProgressHUD showError:@"邮箱格式不正确" toView:KeyWindow];
            return NO;
        }
        
        NSString *txt = textField.text;
        
        [self addOnePeopleWithTxt:txt];
        
        [self setNeedsLayout];
        
        self.textField.text = @"";
    }
    
    return YES;
}


/** 输入的时候添加一个人 */
- (void)addOnePeopleWithTxt:(NSString *)txt{
    
    TFEmailPersonModel *model = [[TFEmailPersonModel alloc] init];
    model.mail_account = txt;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    [button setTitle:txt forState:UIControlStateNormal];
    [button setTitle:txt forState:UIControlStateHighlighted];
    [button setTitle:txt forState:UIControlStateSelected];
    [button setTitleColor:GreenColor forState:UIControlStateNormal];
    [button setTitleColor:GreenColor forState:UIControlStateHighlighted];
    [button setTitleColor:WhiteColor forState:UIControlStateSelected];
    [button setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateSelected];
    [button setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forState:UIControlStateHighlighted];
    
    button.layer.cornerRadius = 11;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = FONT(14);
    model.button = button;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = self.peoples.count;
    
    [self.peoples addObject:model];
    
}

/** 输入的时候添加一个人 */
- (void)addOnePeopleWithModel:(TFEmailPersonModel *)model{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSString *str = @"";
    if (model.employee_name && model.mail_account && ![model.employee_name isEqualToString:@""] && ![model.mail_account isEqualToString:@""]) {
        str = [NSString stringWithFormat:@"%@%@",model.employee_name,model.mail_account];
    }else if (model.employee_name && ![model.employee_name isEqualToString:@""]){
        str = model.employee_name;
    }else if (model.mail_account && ![model.mail_account isEqualToString:@""]){
        str = model.mail_account;
    }
    
    [self addSubview:button];
    [button setTitle:str forState:UIControlStateNormal];
    [button setTitle:str forState:UIControlStateHighlighted];
    [button setTitle:str forState:UIControlStateSelected];
    [button setTitleColor:GreenColor forState:UIControlStateNormal];
    [button setTitleColor:GreenColor forState:UIControlStateHighlighted];
    [button setTitleColor:WhiteColor forState:UIControlStateSelected];
    [button setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateSelected];
    [button setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forState:UIControlStateHighlighted];
    
    button.layer.cornerRadius = 11;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = FONT(14);
    model.button = button;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = self.peoples.count;
    
    [self.peoples addObject:model];
    
}


-(void)tfTextFieldDeleteBackward:(TFTextField *)textField{
    
    if (!self.textField.hasText) {
       
        [self deleteItem];
    }
}

-(void)deleteItem{
    
    BOOL have = NO;
    for (TFEmailPersonModel *model in self.peoples) {
        
        if (model.button.selected) {
            have = YES;
            [model.button removeFromSuperview];
            [self.peoples removeObject:model];
            break;
        }
    }
    
    if (have == NO) {
        TFEmailPersonModel *model = self.peoples.lastObject;
        if (model) {
            model.button.selected = YES;
        }
    }
    [self setNeedsLayout];
}

- (void)buttonClicked:(UIButton *)button{
    
    if (button.selected) {
//        button.selected = NO;
        [self deleteItem];
    }else{
        
        for (TFEmailPersonModel *model in self.peoples) {
            model.button.selected = NO;
        }
        button.selected = YES;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.peoples.count == 0) {
        
        self.textField.frame = CGRectMake(0, 0, self.width, Height);
        
    }else{
        
        CGFloat X = 0;
        CGFloat Y = 0;
        for (NSInteger i = 0; i < self.peoples.count; i++) {
            TFEmailPersonModel *model = self.peoples[i];
            NSString *name = model.mail_account?:model.employee_name;
            CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:name];
            CGFloat labelWidth = size.width + 10 > self.width ? self.width : size.width + 10;
            
            if (X + labelWidth + Margin <= self.width) {// 同行
                
                model.button.frame = CGRectMake(X, Y, labelWidth, Height);
                X += (labelWidth + Margin);
                
            }else{// 换行
                
                Y += (Height + Margin);
                X = 0;
                model.button.frame = CGRectMake(X, Y, labelWidth, Height);
                X += (labelWidth + Margin);
            }
            
            if (i == self.peoples.count-1) {
                
                if (CGRectGetMaxX(model.button.frame) + Margin + FieldMinW <= self.width) {
                    
                    self.textField.frame = CGRectMake(CGRectGetMaxX(model.button.frame) + Margin, CGRectGetMinY(model.button.frame), self.width - (CGRectGetMaxX(model.button.frame) + Margin), Height);
                    
                }else{
                    
                    self.textField.frame = CGRectMake(0, CGRectGetMaxY(model.button.frame) + Margin, self.width, Height);
                }
            }
        }
    }
    
    self.height = CGRectGetMaxY(self.textField.frame);
    if (self.peoples.count) {
        self.textField.placeholder = @"";
    }else{
        self.textField.placeholder = @"请输入";
    }
    
    //刷新高度代理
    if ([self.delegate respondsToSelector:@selector(editViewHeight:type:)]) {
        
        [self.delegate editViewHeight:self.height+28 type:self.type];
    }
    
    //传值代理
    
    if ([self.delegate respondsToSelector:@selector(editViewTextWithArray:type:)]) {
        
        [self.delegate editViewTextWithArray:self.peoples type:self.type];
    }
}


/** 选择来的人添加人员 */
-(void)addPeoples:(NSArray *)peoples{
    
    for (TFEmailPersonModel *txt in peoples) {
        
        [self addOnePeopleWithModel:txt];
        
    }
    
    [self setNeedsLayout];
    
    self.textField.text = @"";
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
