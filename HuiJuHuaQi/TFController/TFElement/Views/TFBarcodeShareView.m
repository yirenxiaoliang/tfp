//
//  TFBarcodeShareView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/9.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFBarcodeShareView.h"

@interface TFBarcodeShareView ()

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation TFBarcodeShareView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = WhiteColor;
        self.tag = 0x2222;
        CGFloat width = 0;
        if (self.height-120 > self.width) {
            width = self.width - 60;
        }else{
            width = self.height - 120 - 60;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){(self.width-width)/2,0,width,width}];
        [self addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = WhiteColor;
        imageView.center = CGPointMake(self.width/2, self.height/2);
        self.imageView = imageView;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:(CGRect){0,imageView.top-60,self.width,60}];
        [self addSubview:titleLabel];
        titleLabel.textColor = LightBlackTextColor;
        titleLabel.font = FONT(16);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = titleLabel;
        
        UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
        share.frame = CGRectMake(0, 0, 200, 60);
        share.centerX = self.width/2;
        share.top = imageView.bottom;
        [share setImage:IMG(@"share") forState:UIControlStateNormal];
        [share setImage:IMG(@"share") forState:UIControlStateHighlighted];
        [share setTitle:@" 分享至微信" forState:UIControlStateNormal];
        [share setTitle:@" 分享至微信" forState:UIControlStateHighlighted];
        [share setTitleColor:GreenColor forState:UIControlStateNormal];
        [share setTitleColor:GreenColor forState:UIControlStateHighlighted];
        [share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:share];
    }
    return self;
}

-(void)share{
    if ([self.delegate respondsToSelector:@selector(barcodeShareViewShareWithBarcode:)]) {
        [self.delegate barcodeShareViewShareWithBarcode:self.barcode];
    }
}

-(void)setBarcode:(NSString *)barcode{
    _barcode = barcode;
    
    self.imageView.image = [HQHelper creatBarcodeWithString:barcode withImgWidth:self.imageView.width];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
