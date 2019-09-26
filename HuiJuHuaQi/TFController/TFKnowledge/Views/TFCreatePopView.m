//
//  TFCreatePopView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/4.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCreatePopView.h"

@interface TFCreatePopView ()
@property (weak, nonatomic) IBOutlet UIButton *knowledgeBtn;
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;

@property (nonatomic, copy) void (^knowledgeAction)(void) ;
@property (nonatomic, copy) void (^questionAction)(void) ;

@end

@implementation TFCreatePopView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.anchorPoint = CGPointMake(1, 0.8);
    self.backgroundColor = ClearColor;
}
- (IBAction)knowledgeClicked:(id)sender {
    [self dissmiss];
    if (self.knowledgeAction) {
        self.knowledgeAction();
    }
}
- (IBAction)questionClicked:(id)sender {
    [self dissmiss];
    if (self.questionAction) {
        self.questionAction();
    }
}

-(void)dissmiss{
    [TFCreatePopView tapBgView:nil];
}

+(TFCreatePopView *)popViewWithPoint:(CGPoint)point knowledge:(void (^)(void))knowledge question:(void (^)(void))quetion{
    
//    UIView *bgView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
//    bgView.tag = 0x9544;
//    [KeyWindow addSubview:bgView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
//    [bgView addGestureRecognizer:tap];
    
    TFCreatePopView *popView = [TFCreatePopView createPopview];
    popView.frame = CGRectMake(point.x - 132, point.y - 100, 132, 100);
    [KeyWindow addSubview:popView];
    popView.tag = 0x9511;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 0.25;
    animation.repeatCount = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [popView.layer addAnimation:animation forKey:@"ABC"];
    
    popView.knowledgeAction = knowledge;
    popView.questionAction = quetion;
    
    return popView;
}

+(void)tapBgView:(UITapGestureRecognizer *)tap{
    
//    [[KeyWindow viewWithTag:0x9544] removeFromSuperview];
    
    TFCreatePopView *popView = [KeyWindow viewWithTag:0x9511];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @1;
    animation.toValue = @0;
    animation.duration = 0.25;
    animation.repeatCount = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [popView.layer addAnimation:animation forKey:@"ABC"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [popView removeFromSuperview];
    });
    
}


+(instancetype)createPopview{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFCreatePopView" owner:self options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
