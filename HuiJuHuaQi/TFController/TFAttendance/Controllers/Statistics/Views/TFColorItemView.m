//
//  TFColorItemView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFColorItemView.h"

@interface TFColorItemView ()



@end


@implementation TFColorItemView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.colorImage.layer.cornerRadius = 2;
    self.colorImage.layer.masksToBounds = YES;
    self.nameLabel.textColor = ExtraLightBlackTextColor;
    self.nameLabel.font = FONT(12);
    
}
+(instancetype)colorItemView{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFColorItemView" owner:self options:nil] lastObject];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
