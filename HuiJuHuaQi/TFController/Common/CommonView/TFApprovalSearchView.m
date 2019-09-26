//
//  TFApprovalSearchView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/19.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFApprovalSearchView.h"

@interface TFApprovalSearchView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeHead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusTrail;

@end

@implementation TFApprovalSearchView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.typeBtn addTarget:self action:@selector(typeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.statusBtn addTarget:self action:@selector(statusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBtn addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.textFiled.placeholder = @"搜索";
    
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索"]];
    leftView.contentMode = UIViewContentModeCenter;
    leftView.frame = CGRectMake(0, 0, 30, 30);
    self.textFiled.leftView = leftView;
    self.textFiled.leftViewMode = UITextFieldViewModeAlways;
    
    self.backgroundColor = ClearColor;
    self.searchBtn.layer.cornerRadius = 3;
    self.searchBtn.layer.masksToBounds = YES;
    self.searchBtn.backgroundColor = WhiteColor;
    self.textFiled.layer.cornerRadius = 3;
    self.textFiled.layer.masksToBounds = YES;
    self.textFiled.backgroundColor = WhiteColor;
    
    [self.textFiled addTarget:self action:@selector(textFiledTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardShow{
    
    if (self.textFiled.isFirstResponder) {
        
        self.searchBtn.hidden = YES;
    }
    
}
- (void)keyboardHide{
    
    if (!self.textFiled.isFirstResponder) {
        
        if (self.textFiled.text.length) {
            
            self.searchBtn.hidden = YES;
        }else{
            
            self.searchBtn.hidden = NO;
        }
    }
}

-(void)setType:(NSInteger)type{
    _type = type;
    
    if (type == 1) {
        self.typeW.constant = 0;
        self.typeHead.constant = 0;
        self.statusW.constant = 0;
        self.statusTrail.constant = 0;
        self.typeBtn.hidden = YES;
        self.statusBtn.hidden = YES;
    }else if (type == 2){
        
        self.typeW.constant = 0;
        self.typeHead.constant = 0;
        self.statusW.constant = 46;
        self.statusTrail.constant = 8;
        self.typeBtn.hidden = YES;
        self.statusBtn.hidden = NO;
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)typeBtnClicked{
    
    if ([self.delegate respondsToSelector:@selector(approvalSearchViewDidClickedTypeBtn)]) {
        [self.delegate approvalSearchViewDidClickedTypeBtn];
    }
    
}

- (void)statusBtnClicked{
    
    if ([self.delegate respondsToSelector:@selector(approvalSearchViewDidClickedStatusBtn)]) {
        [self.delegate approvalSearchViewDidClickedStatusBtn];
    }
}

- (void)searchBtnClicked{
    
    [self.textFiled becomeFirstResponder];
    
}

- (void)textFiledTextChange:(UITextField *)textField{
    
    if ([self.delegate respondsToSelector:@selector(approvalSearchViewTextChange:)]) {
        [self.delegate approvalSearchViewTextChange:textField];
    }
}

+ (instancetype)approvalSearchView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFApprovalSearchView" owner:self options:nil] lastObject];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
