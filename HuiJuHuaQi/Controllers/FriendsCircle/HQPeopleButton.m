//
//  HQPeopleButton.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/6/17.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQPeopleButton.h"

@implementation HQPeopleButton

-(void)awakeFromNib{
    [super awakeFromNib];
}

+ (instancetype)button{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HQPeopleButton" owner:nil options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
