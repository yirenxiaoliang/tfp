//
//  HQReceiveMessageStatuesView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/11/29.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQReceiveMessageStatuesView.h"

@interface HQReceiveMessageStatuesView ()

/** 转圈 */
@property (nonatomic, strong) UIActivityIndicatorView *activity;
/** 文字 */
@property (nonatomic, strong) UILabel *wordLabel;


@end

@implementation HQReceiveMessageStatuesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChild];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupChild];
    }
    return self;
}

- (void)setupChild{
    
    self.color = BlackTextColor;
    self.activityType = UIActivityIndicatorViewStyleGray;
    
    self.activity = [[UIActivityIndicatorView alloc] init];
    self.activity.activityIndicatorViewStyle = self.activityType;
    self.activity.hidesWhenStopped = YES;
    [self addSubview:self.activity];
    
    self.wordLabel = [[UILabel alloc] init];
    self.wordLabel.font = FONT(20);
    self.wordLabel.textColor = self.color;
    [self addSubview:self.wordLabel];
    
//    self.backgroundColor = RedColor;
//    self.wordLabel.backgroundColor = GreenColor;
    
    self.activity.frame = CGRectMake(0, 0, 30, 44);
    self.wordLabel.frame = CGRectMake(0, 0, 66, 44);
    self.wordLabel.centerX = 100;
    
    self.wordLabel.hidden = YES;
    self.activity.hidden = YES;
}

- (void)setColor:(UIColor *)color{
    _color = color;
    
    self.wordLabel.textColor = color;
}

- (void)setActivityType:(UIActivityIndicatorViewStyle)activityType{
    _activityType = activityType;
    
    self.activity.activityIndicatorViewStyle = activityType;
}

- (void)setStyle:(HQReceiveMessageStatuesViewStyle)style{
    
    _style = style;
    
    self.wordLabel.hidden = NO;
    self.activity.hidden = NO;
    
    switch (style) {
        case HQReceiveMessageStatuesViewStyleNormal:
        {
            self.activity.hidden = YES;
            [self.activity stopAnimating];
            self.wordLabel.text = @"企信";
            self.wordLabel.textAlignment = NSTextAlignmentCenter;
            [self setNeedsLayout];
        }
            break;
        case HQReceiveMessageStatuesViewStyleNoConnect:
        {
            
            self.activity.hidden = YES;
            [self.activity stopAnimating];
            self.wordLabel.text = @"未连接";
            self.wordLabel.textAlignment = NSTextAlignmentCenter;
            [self setNeedsLayout];
        }
            break;
        case HQReceiveMessageStatuesViewStyleConnecting:
        {
            self.activity.hidden = NO ;
            [self.activity startAnimating];
            self.wordLabel.text = @"连接中...";
            self.wordLabel.textAlignment = NSTextAlignmentLeft;
            [self setNeedsLayout];
        }
            break;
        case HQReceiveMessageStatuesViewStyleReceiving:
        {
            self.activity.hidden = NO ;
            [self.activity startAnimating];
            self.wordLabel.text = @"收取中...";
            self.wordLabel.textAlignment = NSTextAlignmentLeft;
            [self setNeedsLayout];
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    switch (_style) {
        case HQReceiveMessageStatuesViewStyleNormal:
        {
            self.activity.frame = CGRectMake(0, 0, 30, 44);
            self.wordLabel.frame = CGRectMake(0, 0, 44, 44);
            self.wordLabel.centerX = 100;
        }
            break;
        case HQReceiveMessageStatuesViewStyleNoConnect:
        {
            
            self.activity.frame = CGRectMake(0, 0, 30, 44);
            self.wordLabel.frame = CGRectMake(0, 0, 64, 44);
            self.wordLabel.centerX = 100;
        }
            break;
        case HQReceiveMessageStatuesViewStyleConnecting:
        {
            self.activity.frame = CGRectMake(0, 0, 30, 44);
            self.wordLabel.frame = CGRectMake(44, 0, 84, 44);
            self.wordLabel.centerX = 100+15;
            self.activity.right = self.wordLabel.left;
        }
            break;
        case HQReceiveMessageStatuesViewStyleReceiving:
        {
            self.activity.frame = CGRectMake(0, 0, 30, 44);
            self.wordLabel.frame = CGRectMake(44, 0, 84, 44);
            self.wordLabel.centerX = 100+15;
            self.activity.right = self.wordLabel.left;
            
        }
            break;
            
        default:
            break;
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
