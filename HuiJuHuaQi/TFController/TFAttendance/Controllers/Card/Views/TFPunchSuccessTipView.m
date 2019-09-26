

//
//  TFPunchSuccessTipView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/20.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPunchSuccessTipView.h"

@interface TFPunchSuccessTipView ()

@end

@implementation TFPunchSuccessTipView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = ClearColor;
}

+(instancetype)punchSuccessTipView{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFPunchSuccessTipView" owner:self options:nil] lastObject];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
