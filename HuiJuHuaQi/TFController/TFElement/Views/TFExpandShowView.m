//
//  TFExpandShowView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/9.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFExpandShowView.h"

@interface TFExpandShowView()
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *questionImage;

@property (nonatomic, assign) NSInteger index;

@end

@implementation TFExpandShowView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.arrowImage.image = IMG(@"下一级浅灰");
    self.arrowImage.contentMode = UIViewContentModeCenter;
    self.titleLabel.text = @"扩展链接";
    self.titleLabel.textColor = BlackTextColor;
    self.questionImage.image = IMG(@"question");
    self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, M_PI_2);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}

-(void)tap{
    if (self.index == 0) {
        self.index = 1;
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform,  M_PI);
        }];
    }else{
        self.index = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, M_PI);
        }];
    }
    if ([self.delegate respondsToSelector:@selector(expandShowViewDidClicked)]) {
        [self.delegate expandShowViewDidClicked];
    }
}

+ (instancetype)expandShowView{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFExpandShowView" owner:self options:nil] lastObject];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
