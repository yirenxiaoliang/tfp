//
//  TFApprovalItemView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/10/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFApprovalItemView.h"


@interface TFApprovalItemView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberW;

@end

@implementation TFApprovalItemView


- (void)awakeFromNib{
    [super awakeFromNib];
    self.nameLabel.textColor = LightBlackTextColor;
    self.nameLabel.font = FONT(14);
    self.numberLabel.layer.cornerRadius = 7;
    self.numberLabel.layer.masksToBounds = YES;
    self.numberLabel.backgroundColor = RedColor;
    self.numberLabel.textColor = WhiteColor;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.font = FONT(10);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    [self addGestureRecognizer:tap];
}

-(void)viewClicked:(UITapGestureRecognizer *)tap{
    
    if ([self.delegate respondsToSelector:@selector(approvalItemViewClicked:)]) {
        [self.delegate approvalItemViewClicked:self];
    }
}


-(void)setName:(NSString *)name{
    _name = name;
    self.nameLabel.text = name;
}

-(void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}

-(void)setSelectedImage:(UIImage *)selectedImage{
    _selectedImage = selectedImage;
}

-(void)setNumber:(NSInteger)number{
    _number = number;
    if (number <= 0) {
        self.numberLabel.hidden = YES;
    }else{
        self.numberLabel.hidden = NO;
    }
    if (number > 100) {
        self.numberLabel.text = [NSString stringWithFormat:@" 99+ "];
    }else{
        self.numberLabel.text = [NSString stringWithFormat:@" %ld ",number];
    }
    CGSize size = [HQHelper sizeWithFont:FONT(10) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:self.numberLabel.text];
    if (size.width < 14) {
        self.numberW.constant = 14;
    }else{
        self.numberW.constant = size.width;
    }
}

-(void)setState:(BOOL)state{
    _state = state;
    
    if (state) {
        self.nameLabel.textColor = GreenColor;
        self.imageView.image = self.selectedImage;
    }else{
        self.nameLabel.textColor = LightBlackTextColor;
        self.imageView.image = self.image;
    }
    
}

+(instancetype)approvalItemView{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFApprovalItemView" owner:self options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
