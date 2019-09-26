//
//  TFNoteImageView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/22.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteImageView.h"

@interface TFNoteImageView ()


@end

@implementation TFNoteImageView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        self.imageView = imageView;
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.userInteractionEnabled = YES;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-20);
            make.bottom.equalTo(self).offset(-10);
            
        }];
        
        UITextView *textView = [[UITextView alloc] init];
        [self addSubview:textView];
        self.textView = textView;
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.height.equalTo(@30);
            make.left.equalTo(imageView.mas_right);
            make.bottom.equalTo(imageView.mas_bottom);
            make.right.equalTo(self);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked:)];
        [self addGestureRecognizer:tap];
    }
    return  self;
    
}
- (void)clicked:(UITapGestureRecognizer *)tap{
    
    [self.textView becomeFirstResponder];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
