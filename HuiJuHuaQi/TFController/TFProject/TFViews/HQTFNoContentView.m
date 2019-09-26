//
//  HQTFNoContentView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFNoContentView.h"

@interface HQTFNoContentView()

/** imageView */
@property (nonatomic, weak) UIImageView *imageView;
/** button */
@property (nonatomic, weak) UIButton *button;
/** tipWord */
@property (nonatomic, weak) UILabel *tipWord;
/** indicator */
@property (nonatomic, weak) UIActivityIndicatorView *indicator;

@end

@implementation HQTFNoContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self setup];
    }
    return self;
}

- (void)setup{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,Long(300)}];
    imageView.image = [UIImage imageNamed:@"无项目"];
    [self addSubview:imageView];
    imageView.contentMode = UIViewContentModeCenter;
    self.imageView = imageView;
    
    
    
    UILabel *titleLabel = [HQHelper labelWithFrame:(CGRect){0,CGRectGetMaxY(imageView.frame)+Long(22),SCREEN_WIDTH,22} text:@"无内容" textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(16)];
    titleLabel.numberOfLines = 0;
    [self addSubview:titleLabel];
    self.tipWord = titleLabel;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:indicator];
    self.indicator = indicator;
    indicator.hidden = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    button.frame = CGRectMake(0, 0, SCREEN_WIDTH-54, 50);
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
//    button.layer.borderColor = GreenColor.CGColor;
//    button.layer.borderWidth = 0.5;
    [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    
//    [button setTitleColor:GreenColor forState:UIControlStateNormal];
//    [button setTitleColor:GreenColor forState:UIControlStateHighlighted];
    [button setTitleColor:kUIColorFromRGB(0x3689E9) forState:UIControlStateNormal];
    [button setTitleColor:kUIColorFromRGB(0x3689E9) forState:UIControlStateHighlighted];
    
    self.button = button;
    [button addTarget:self action:@selector(addClicked) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setTipText:(NSString *)tipText{
    
    _tipText = tipText;
    
    self.tipWord.text = tipText;
    
}


+ (HQTFNoContentView *)noContentView{
    
    HQTFNoContentView *noContent = [[HQTFNoContentView alloc] init];
    
    return noContent;
}


- (void)addClicked{
    
    if ([self.delegate respondsToSelector:@selector(noContentViewDidClickedButton)]) {
        [self.delegate noContentViewDidClickedButton];
    }
}

- (void)setupImageViewRect:(CGRect)imgRect imgImage:(NSString *)imgImage buttonImage:(NSString *)btnImage buttonWord:(NSString *)btnWord withTipWord:(NSString *)tipWord{
    
    self.button.hidden = NO;
    
    self.imageView.frame = imgRect;
    self.imageView.image = [UIImage imageNamed:imgImage];
    
    self.tipWord.frame = (CGRect){0,CGRectGetMaxY(self.imageView.frame)+Long(22),SCREEN_WIDTH,22};
    self.tipWord.text = tipWord;
    
    self.button.frame = CGRectMake(27, CGRectGetMaxY(self.tipWord.frame)+20, SCREEN_WIDTH-54, 50);
    
    [self.button setImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:btnImage] forState:UIControlStateHighlighted];
    
    [self.button setTitle:btnWord forState:UIControlStateNormal];
    [self.button setTitle:btnWord forState:UIControlStateHighlighted];
}

- (void)setupImageViewRect:(CGRect)imgRect imgImage:(NSString *)imgImage buttonWord:(NSString *)btnWord withTipWord:(NSString *)tipWord{
    
    self.button.hidden = NO;
    
    self.imageView.frame = imgRect;
    self.imageView.image = [UIImage imageNamed:imgImage];
    
    self.tipWord.frame = (CGRect){0,CGRectGetMaxY(self.imageView.frame)+Long(22),SCREEN_WIDTH,70};
    self.tipWord.text = tipWord;
    self.tipWord.textColor = SixColor;
    
    self.button.frame = CGRectMake(27, CGRectGetMaxY(self.tipWord.frame)+10, SCREEN_WIDTH-54, 50);
    
    [self.button setTitle:btnWord forState:UIControlStateNormal];
    [self.button setTitle:btnWord forState:UIControlStateHighlighted];
    self.button.backgroundColor = GreenColor;
    [self.button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.button setTitleColor:WhiteColor forState:UIControlStateHighlighted];
}

- (void)setupImageViewRect:(CGRect)imgRect imgImage:(NSString *)imgImage withTipWord:(NSString *)tipWord{
    
    self.button.hidden = YES;
    
    self.imageView.frame = imgRect;
    self.tipWord.frame = (CGRect){imgRect.origin.x,CGRectGetMaxY(self.imageView.frame)+Long(22),imgRect.size.width,50};
    self.imageView.image = [UIImage imageNamed:imgImage];
    self.indicator.hidden = YES;
    self.tipWord.text = tipWord;
}

/** 无按钮有转圈 loadTip : NO 无转圈, YES 有转圈 */
- (void)setupImageViewRect:(CGRect)imgRect imgImage:(NSString *)imgImage withTipWord:(NSString *)tipWord loadTip:(BOOL)loadTip{
    
    self.button.hidden = YES;
    self.indicator.hidden = !loadTip;
    if (loadTip) {
        [self.indicator startAnimating];
    }else{
        [self.indicator stopAnimating];
    }
    self.imageView.frame = imgRect;
    self.tipWord.frame = (CGRect){imgRect.origin.x+(loadTip?15:0),CGRectGetMaxY(self.imageView.frame)+Long(22),imgRect.size.width,30};
    self.indicator.frame = CGRectMake(imgRect.size.width/2-20, CGRectGetMinY(self.tipWord.frame), loadTip?30:0, loadTip?30:0);
    self.imageView.image = [UIImage imageNamed:imgImage];
//    self.tipWord.backgroundColor = RedColor;
    self.tipWord.text = tipWord;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
