//
//  HQTFCreatRowCollectionViewCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFCreatRowCollectionViewCell.h"


@interface HQTFCreatRowCollectionViewCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *creatBtn;
@property (weak, nonatomic) IBOutlet UIView *creatBg;
@property (weak, nonatomic) IBOutlet UIButton *coopCrm;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureTop;
@property (weak, nonatomic) IBOutlet UILabel *tipWord;

@end

@implementation HQTFCreatRowCollectionViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
 
    self.creatBtn.layer.cornerRadius = 5;
    self.creatBtn.layer.masksToBounds = YES;
    [self.creatBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
    [self.creatBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
    [self.creatBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateSelected];
    [self.creatBtn addTarget:self action:@selector(creatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.textView.placeholder = @"列表名称20字以内";
    self.textView.placeholderColor = NOSelectDateColor;
    self.textView.layer.cornerRadius = 3;
    self.textView.layer.masksToBounds = YES;
    self.textView.backgroundColor = WhiteColor;
    self.textView.layer.borderColor = GreenColor.CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.font = FONT(20);
    self.textView.textColor = BlackTextColor;
    self.textView.delegate = self;
    
    [self.coopCrm addTarget:self action:@selector(coopCrmClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
    [self.sureBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
    [self.sureBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
    [self.sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelBtn.layer.cornerRadius = 5;
    self.cancelBtn.layer.masksToBounds = YES;
    [self.cancelBtn setBackgroundImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateHighlighted];
    [self.cancelBtn setTitleColor:FinishedTextColor forState:UIControlStateHighlighted];
    [self.cancelBtn setTitleColor:FinishedTextColor forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.creatBg.backgroundColor = HexAColor(0xe7e7e7, 1);
    self.contentView.backgroundColor = HexAColor(0xe7e7e7, 1);
    self.backgroundColor = HexAColor(0xe7e7e7, 1);
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    
    self.creatBg.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped)];
    [self.creatBg addGestureRecognizer:tap];
    
    self.coopCrm.hidden = YES;
    self.sureTop.constant = -30;
    self.sureBtn.backgroundColor = ClearColor;
    self.cancelBtn.backgroundColor = ClearColor;
    self.tipWord.textColor = LightGrayTextColor;
}

- (void)taped{
    [self.textView resignFirstResponder];
}

- (void)creatBtnClick:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(creatRowCollectionViewCell:didCreateBtn:withBlock:)]) {
        
        [self.delegate creatRowCollectionViewCell:self didCreateBtn:button withBlock:^(BOOL open) {
           
            if (open) {
                
                self.creatBg.hidden = NO;
                self.textView.text = nil;
                [self.textView becomeFirstResponder];
            }
            
        }];
        
    }else{
        
        self.creatBg.hidden = NO;
        self.textView.text = nil;
        [self.textView becomeFirstResponder];
    }
    
}
- (void)sureBtnClick:(UIButton *)button{
    
    if (!self.textView.text || self.textView.text.length == 0) {
        [MBProgressHUD showError:@"请输入名称" toView:KeyWindow];
        return;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(creatRowCollectionViewCell:didSureBtnWithText:)]) {
        [self.delegate creatRowCollectionViewCell:self didSureBtnWithText:self.textView.text];
    }
}

- (void)cancelBtnClick:(UIButton *)button{
    self.textView.text = nil;
    [self.textView resignFirstResponder];
    self.creatBg.hidden = YES;
}

- (void)coopCrmClick:(UIButton *)button{
    
    button.selected = !button.selected;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > 20) {
        [MBProgressHUD showError:@"20字以内" toView:KeyWindow];
        self.textView.text = [textView.text substringToIndex:20];
    }
    
}


@end
