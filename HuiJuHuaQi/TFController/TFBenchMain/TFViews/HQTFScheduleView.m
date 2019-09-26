//
//  HQTFScheduleView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFScheduleView.h"
#import "HQTFScrollView.h"
@interface HQTFScheduleView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;
@property (weak, nonatomic) IBOutlet UIView *lineBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineBottomHeight;
@property (weak, nonatomic) IBOutlet HQTFScrollView *scrollView;

@end

@implementation HQTFScheduleView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.lineView.backgroundColor = CellSeparatorColor;
    self.lineHeight.constant = 0.5;
    
    self.lineBottom.backgroundColor = CellSeparatorColor;
    self.lineBottomHeight.constant = 0.5;
    self.lineBottom.hidden = YES;
    
//    self.scrollView.backgroundColor = WhiteColor;
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    
//    CGFloat Top = 12;
//    CGFloat left = 12;
//    CGFloat buttonW = Long(200);
//    CGFloat buttomH = Long(75);
//    
//    self.scrollView.contentSize = CGSizeMake(left+ (buttonW +left) * 4, self.scrollView.height);
//    
//    for (NSInteger i = 0; i < 4; i ++) {
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.scrollView addSubview:button];
//        [button setBackgroundImage:[UIImage imageNamed:@"广告1"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"广告1"] forState:UIControlStateHighlighted];
//        button.frame = CGRectMake(left+ (buttonW +left) * i, Top, buttonW, buttomH);
//    }
    
}

+ (instancetype)scheduleView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFScheduleView" owner:self options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
