//
//  TFCustomDetailItemView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/12.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomDetailItemView.h"

@interface TFCustomDetailItemView ()

@end

@implementation TFCustomDetailItemView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *label1 = [HQHelper labelWithFrame:(CGRect){0,0,0,0} text:@"" textColor:LightBlackTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
        [self addSubview:label1];
        self.nameLabel = label1;
        
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.mas_left).with.offset(8);
            make.right.equalTo(self.mas_right).with.offset(-8);
            make.height.equalTo(@20);
            make.centerY.equalTo(self.mas_centerY).with.offset(-10);
            
        }];
        
        UILabel *label2 = [HQHelper labelWithFrame:(CGRect){0,0,0,0} text:@"" textColor:GrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
        [self addSubview:label2];
        self.numLabel = label2;
        
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@20);
            make.centerY.equalTo(self.mas_centerY).with.offset(10);
            
        }];
    }
    return self;
}

+(instancetype)customDetailItemView{
    TFCustomDetailItemView *view = [[TFCustomDetailItemView alloc] initWithFrame:(CGRect){0,0,150,64}];
    view.backgroundColor = WhiteColor;
    return view;
}

-(void)setType:(NSInteger)type{
    _type = type;
    if (type == 0) {
        
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.mas_centerY).with.offset(-10);
            
        }];
        
        
        self.numLabel.hidden = NO;
        [self.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.mas_centerY).with.offset(10);
            
        }];
    } else {
        self.numLabel.hidden = YES;
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.mas_centerY).with.offset(0);
            
        }];
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
