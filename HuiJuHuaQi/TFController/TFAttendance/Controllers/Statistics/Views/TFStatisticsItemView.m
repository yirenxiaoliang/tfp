//
//  TFStatisticsItemView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFStatisticsItemView.h"



@implementation TFStatisticsItemView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.nameLabel.textColor = ExtraLightBlackTextColor;
    self.nameLabel.font = FONT(14);
    
    self.numLabel.textColor = BlackTextColor;
    self.numLabel.font = FONT(22);
    
    self.layer.borderColor = CellSeparatorColor.CGColor;
    self.layer.borderWidth = 0.5;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
    [self addGestureRecognizer:tap];
}

-(void)tapClicked:(UITapGestureRecognizer *)tap{
    
    if ([self.delegate respondsToSelector:@selector(statisticsItemViewClicked:)]) {
        [self.delegate statisticsItemViewClicked:self];
    }
}

+(instancetype)statisticsItemView{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFStatisticsItemView" owner:self options:nil] lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
