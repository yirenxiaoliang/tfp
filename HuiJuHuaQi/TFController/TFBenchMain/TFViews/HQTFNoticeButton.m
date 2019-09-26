//
//  HQTFNoticeButton.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFNoticeButton.h"

@interface HQTFNoticeButton ()
@property (weak, nonatomic) IBOutlet UIImageView *redPoint;

@end

@implementation HQTFNoticeButton


-(void)awakeFromNib{
    [super awakeFromNib];
    [self.redPoint setImage:[HQHelper createImageWithColor:RedColor]];
    self.redPoint.layer.masksToBounds = YES;
    self.redPoint.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor clearColor];
    self.size = CGSizeMake(40, 40);
    
    [self setImage:[UIImage imageNamed:@"通知白色"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"通知白色"] forState:UIControlStateHighlighted];
}

+ (instancetype)noticeButton
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFNoticeButton" owner:self options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
