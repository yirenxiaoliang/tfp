//
//  TFAllPeopleView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/16.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAllPeopleView.h"

@interface TFAllPeopleView ()


@property (nonatomic, strong) NSMutableArray *views;

@end

@implementation TFAllPeopleView

-(NSMutableArray *)views{
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}

-(void)refreshAllPeopleViewWithPeoples:(NSArray *)peoples{
    
    for (UIView *view in self.views) {
        [view removeFromSuperview];
    }
    [self.views removeAllObjects];
    
    CGFloat width = 30;
    
    for (NSInteger i = 0; i < peoples.count + 1; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [self.views addObject:btn];
        btn.size = CGSizeMake(width, width);
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
        [btn setBackgroundImage:IMG(@"加人") forState:UIControlStateNormal];
        [btn setBackgroundColor:WhiteColor];
        btn.userInteractionEnabled = NO;
        btn.titleLabel.font = FONT(12);
        if (i != peoples.count) {
            HQEmployModel *model = peoples[i];
            [btn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image == nil) {
                    
                    [btn setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
                    [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
                    [btn setBackgroundColor:HeadBackground];
                }else{
                    
                    [btn setTitle:@"" forState:UIControlStateNormal];
                    [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
                    [btn setBackgroundColor:WhiteColor];
                }
                
            }];
        }
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = 30;
    NSInteger column =  (NSInteger)(self.width / (width + 10));
    
    for (NSInteger i = 0; i < self.views.count; i ++) {
        UIButton *btn = self.views[i];
        NSInteger row = i / column;
        NSInteger col = i % column;
        btn.origin = CGPointMake(col *(width + 10), row * (width + 10));
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
