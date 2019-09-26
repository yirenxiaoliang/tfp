//
//  HQTFLabelButton.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFLabelButton.h"

@interface HQTFLabelButton ()
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIImageView *whiteImage;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation HQTFLabelButton


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 2;
//    self.layer.masksToBounds = YES;
    
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    [self addTarget:self action:@selector(labelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelBtnClick)];
    [self addGestureRecognizer:tap];
    
    self.type = LabelButtonTypeNormal;
}

+ (instancetype)labelButton{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFLabelButton" owner:self options:nil] lastObject];
    
}

-(void)setText:(NSString *)text{
    _text = text;
    
    self.label.text = text;
}

- (void)deleteBtnClick{
    
    [self labelBtnClick];
}

-(void)setScene:(NSInteger)scene{
    
    _scene = scene;
}

- (void)labelBtnClick{
    
    
    self.selected = !self.selected;
    
    if ([self.delegate respondsToSelector:@selector(labelButtonSelectIndex:withSelect: block:)]) {
        
    [self.delegate labelButtonSelectIndex:self.tag - 0x123 withSelect:self.selected block:^(BOOL selected){
        
        self.selected = selected;
        
        if (self.scene == 0) {
            
            if (self.selected) {
                self.type = LabelButtonTypeSelect;
            }else{
                self.type = LabelButtonTypeNormal;
            }
            
        }else if (self.scene == 1) {
            
            if (self.selected) {
                self.type = LabelButtonTypeDelete;
            }else{
                self.type = LabelButtonTypeNormal;
            }
            
        }else if (self.scene == 2) {
            
            if (self.selected) {
                self.type = LabelButtonTypeColor;
            }else{
                self.type = LabelButtonTypeNormal;
            }
            
        }
        
    }];
}
    
}

-(void)setType:(LabelButtonType)type{
    
    _type = type;
    
    switch (type) {
        case LabelButtonTypeNormal:
        {
            self.whiteImage.hidden = YES;
            self.label.hidden = NO;
            self.deleteBtn.hidden = YES;
        }
            break;
        case LabelButtonTypeSelect:
        {
            self.deleteBtn.hidden = NO;
            self.whiteImage.hidden = YES;
            self.label.hidden = NO;
            [self.deleteBtn setImage:[UIImage imageNamed:@"选择标签"] forState:UIControlStateNormal];
            [self.deleteBtn setImage:[UIImage imageNamed:@"选择标签"] forState:UIControlStateHighlighted];
        }
            break;
        case LabelButtonTypeDelete:
        {
            self.deleteBtn.hidden = NO;
            self.whiteImage.hidden = YES;
            self.label.hidden = NO;
//            [self.deleteBtn setImage:[UIImage imageNamed:@"删除Label"] forState:UIControlStateNormal];
//            [self.deleteBtn setImage:[UIImage imageNamed:@"删除Label"] forState:UIControlStateHighlighted];
        }
            break;
            
        case LabelButtonTypeColor:
        {
            self.deleteBtn.hidden = YES;
            self.whiteImage.hidden = NO;
            self.label.hidden = YES;
            
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
