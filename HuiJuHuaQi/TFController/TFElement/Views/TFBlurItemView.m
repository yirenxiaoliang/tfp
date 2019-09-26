
//
//  TFBlurItemView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/29.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFBlurItemView.h"

@interface TFBlurItemView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation TFBlurItemView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = ClearColor;
    
    self.imageView.layer.cornerRadius = 10;
    self.imageView.layer.masksToBounds = YES;
    
    self.nameLabel.textColor = LightGrayTextColor;
    self.nameLabel.font = FONT(12);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.numberOfLines = 0;
    
    
}

+(instancetype)blurItemView{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFBlurItemView" owner:self options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
