//
//  HQTFSearchHeader.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/16.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFSearchHeader.h"

@interface HQTFSearchHeader ()


@end

@implementation HQTFSearchHeader


+ (instancetype)searchHeader{
    
    HQTFSearchHeader *head = [[HQTFSearchHeader alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,64}];
    
    return head;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChild];
    }
    return self;
}

- (void)setupChild{
    UITextField *textField = [[UITextField alloc] initWithFrame:(CGRect){32,27,self.width-47 - 54,30}];
    [self addSubview:textField];
     UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索"]];
    image.contentMode = UIViewContentModeCenter;
    image.frame = CGRectMake(15, 27, 30, 30);
    image.layer.cornerRadius = 4;
    image.layer.masksToBounds = YES;
    image.backgroundColor = BackGroudColor;
    [self addSubview:image];
    self.image = image;
    
    textField.leftView = [[UIImageView alloc] initWithImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){20,20}]];
    textField.layer.cornerRadius = 4;
    textField.layer.masksToBounds = YES;
    textField.font = FONT(14);
    textField.adjustsFontSizeToFitWidth = YES;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.placeholder = @" 搜索";
    textField.clearsOnBeginEditing = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = WhiteColor;
    self.textField = textField;
    [textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [textField addTarget:self action:@selector(textFieldEnd:) forControlEvents:UIControlEventEditingDidEnd];
  
    
    UIButton *cancel = [HQHelper buttonWithFrame:(CGRect){self.width -15-44,27,44,30} target:self action:@selector(cancelClicked)];
    [cancel setTitleColor:GreenColor forState:UIControlStateNormal];
    [cancel setTitleColor:GreenColor forState:UIControlStateHighlighted];
    [cancel setTitle:@"取消" forState:UIControlStateHighlighted];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [self addSubview:cancel];
    self.rightBtn = cancel;
    
    
    UIButton *leftBtn = [HQHelper buttonWithFrame:(CGRect){15,27,44,30} target:self action:@selector(leftBtnClicked)];
    [leftBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [leftBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
    [leftBtn setTitle:@"" forState:UIControlStateHighlighted];
    [leftBtn setTitle:@"" forState:UIControlStateNormal];
    [self addSubview:leftBtn];
    self.leftBtn = leftBtn;
    
    
    UIButton *button = [HQHelper buttonWithFrame:(CGRect){15,27,self.width-30,30} normalImageStr:@"搜索" highImageStr:@"搜索" target:self action:@selector(buttonClicked)];
    button.titleLabel.font = FONT(16);
    [self addSubview:button];
    [button setTitle:@" 搜索" forState:UIControlStateNormal];
    [button setTitle:@" 搜索" forState:UIControlStateHighlighted];
    [button setTitleColor:GrayTextColor forState:UIControlStateNormal];
    [button setTitleColor:GrayTextColor forState:UIControlStateHighlighted];
    button.backgroundColor = WhiteColor;
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    self.button = button;
    
}

- (void)textFieldChange:(UITextField *)textField{
    
    
    if ([self.delegate respondsToSelector:@selector(searchHeaderTextChange:)]) {
        [self.delegate searchHeaderTextChange:textField];
    }
}

-(void)textFieldEnd:(UITextField *)textField{
    if (self.type == SearchHeaderTypeSearch && textField.text.length == 0) {
        
        self.button.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
                                 self.button.width = self.width-30;
                             }];
    }
    if ([self.delegate respondsToSelector:@selector(searchHeaderTextEditEnd:)]) {
        [self.delegate searchHeaderTextEditEnd:textField];
    }
    
}

- (void)cancelClicked{
    
    if ([self.delegate respondsToSelector:@selector(searchHeaderCancelClicked)]) {
        [self.delegate searchHeaderCancelClicked];
    }
    
    if ([self.delegate respondsToSelector:@selector(searchHeaderRightBtnClicked)]) {
        [self.delegate searchHeaderRightBtnClicked];
    }
}
- (void)leftBtnClicked{
    
    if ([self.delegate respondsToSelector:@selector(searchHeaderleftBtnClicked)]) {
        [self.delegate searchHeaderleftBtnClicked];
    }
    
}


- (void)buttonClicked{
    
    if (self.type == SearchHeaderTypeSearch) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.button.width = 0;
            
        } completion:^(BOOL finished) {
            self.button.hidden = YES;
            [self.textField becomeFirstResponder];
        }];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(searchHeaderClicked)]) {
        [self.delegate searchHeaderClicked];
    }
    
//    self.type = SearchHeaderTypeMove;
}

- (void)setType:(SearchHeaderType)type{
    _type = type;
    
    switch (type) {
        case SearchHeaderTypeNormal:
        {
            self.button.hidden = NO;
//            [self.textField resignFirstResponder];
            self.backgroundColor = [UIColor clearColor];
            self.textField.backgroundColor = WhiteColor;
//            self.layer.borderColor = [UIColor clearColor].CGColor;
//            self.layer.borderWidth = 0;
//            [UIView animateWithDuration:0.25 animations:^{
//                
//                self.height = 46;
//                self.button.frame = CGRectMake(15, 8, SCREEN_WIDTH-30, 30);
//                self.textField.frame = CGRectMake(15, 8, SCREEN_WIDTH-30, 30);
//                
//            }];
        }
            break;
        case SearchHeaderTypeMove:
        {
            self.button.hidden = YES;
            self.backgroundColor = WhiteColor;
            self.textField.backgroundColor = BackGroudColor;
            self.leftBtn.hidden = YES;
            [self.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"取消" forState:UIControlStateHighlighted];
            self.textField.frame = CGRectMake(32, 27, self.width-47 - 54, 30 );
            self.image.frame = CGRectMake(20, 27, 30, 30);
//            self.layer.borderColor = CellSeparatorColor.CGColor;
//            self.layer.borderWidth = 0.5;
//            [UIView animateWithDuration:0.25 animations:^{
//                
//                self.height = 64;
//                self.button.frame = CGRectMake(15, 28, SCREEN_WIDTH-30, 30);
//                self.textField.frame = CGRectMake(15, 28, SCREEN_WIDTH-30, 30);
//                
//            } completion:^(BOOL finished) {
//                
//                [self.textField becomeFirstResponder];
//            }];
//            [self.textField becomeFirstResponder];
        }
            break;
            
        case SearchHeaderTypeTwoBtn:
        {
            self.button.hidden = YES;
            self.backgroundColor = WhiteColor;
            self.textField.backgroundColor = BackGroudColor;
            self.leftBtn.hidden = NO;
            [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
            [self.leftBtn setTitle:@"取消" forState:UIControlStateHighlighted];
            [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"确定" forState:UIControlStateHighlighted];
            self.image.frame = CGRectMake(62, 27, 30, 30);
            self.textField.frame = CGRectMake(74, 27, self.width-2*74, 30 );
        }
            break;
        case SearchHeaderTypeSearch:
        {
            self.button.hidden = YES;
//            self.button.backgroundColor = BackGroudColor;
            self.backgroundColor = [UIColor clearColor];
            self.textField.backgroundColor = WhiteColor;
            self.image.backgroundColor = WhiteColor;
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = YES;
            self.textField.frame = CGRectMake(27, 27, self.width-42, 30 );
            self.image.frame = CGRectMake(15, 27, 30, 30);
        }
            break;
            
        default:
            break;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
