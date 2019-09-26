//
//  StarSlider.m
//  StarSlider
//
//  Created by Eleven Chen on 15/7/17.
//  Copyright (c) 2015年 Eleven. All rights reserved.
//

#import "StarSlider.h"

#define OFF_ART     [UIImage imageNamed:@"星星-灰-1"]
// 黄星
#define ON_ART      [UIImage imageNamed:@"星星-大-1"]
#define HALF_ART	[UIImage imageNamed:@"星星-大-1"]

// 红星
#define RED_ON_ART      [UIImage imageNamed:@"星星-大-1"]
#define RED_HALF_ART	[UIImage imageNamed:@"星星-大-1"]

@interface StarSlider(){
    NSInteger _defalutValue;
}

@property (assign, nonatomic) CGFloat starWidth;
@property (nonatomic,weak) UIView *gesView;

@end

@implementation StarSlider

- (CGFloat) starWidth
{
    if (_isPublish) {
        return self.bounds.size.width / 8.0f;
    }
    return self.bounds.size.width / 7.0f;
}


- (void) awakeFromNib
{
    [super awakeFromNib];
    [self initViews];
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    
    return self;
}

- (void) initViews
{
    for (int i = 0; i < 5; i++) {
        UIImageView *view = [[UIImageView alloc] initWithImage:OFF_ART];
        [self addSubview:view];
    }
    _defalutValue = 0;
}

- (void) updateView
{
    if (_defalutValue > -1) {
        self.backgroundColor = [UIColor clearColor];
        __block float offsetCenter = self.starWidth;
        
        NSArray<UIImageView *> *images = self.subviews;
        
        [images enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger i, BOOL * _Nonnull stop) {
            imageView.frame = CGRectMake(0, 0, self.starWidth, self.starWidth);
            imageView.center = CGPointMake(offsetCenter, self.bounds.size.height/2);
            if (_isPublish) {
                offsetCenter += self.starWidth*1.5f;
            }else{
                offsetCenter += self.starWidth*1.2f;
            }
            if (i < (_defalutValue) / 2) {
                if(_isPublish){
                    imageView.image = ON_ART;
                }else{
                    imageView.image = RED_ON_ART;
                }
            }else{
                imageView.image = OFF_ART;
            }
            if (i == (_defalutValue - 1) / 2 && _defalutValue % 2) {
                if(_isPublish){
                    imageView.image = HALF_ART;
                }else{
                    imageView.image = RED_HALF_ART;
                }
            }
        }];
        _defalutValue = -1;
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self updateView];
}


- (void) updateValueAtPoint: (CGPoint) point
{
    NSInteger newValue = 0;
    UIImageView* changeView = nil;
    for (UIImageView* eatchItem in self.subviews) {
        // 灰色星
        if(eatchItem.frame.origin.x > point.x && eatchItem.center.x > point.x){
            eatchItem.image = OFF_ART;
        }else if(eatchItem.center.x <= point.x){ // 全星
            changeView = eatchItem;
            if(_isPublish){
                eatchItem.image = ON_ART;
            }else{
                eatchItem.image = RED_ON_ART;
            }
            newValue+=2 ;
        }else{ // 半星
            newValue++ ;
            if(_isPublish){
                eatchItem.image = HALF_ART;
            }else{
                eatchItem.image = RED_HALF_ART;
            }
        }
    }

    if (self.value != newValue) {
        if(newValue == 0){
            UIImageView *imageView = self.subviews[0] ;
            if(_isPublish){
                imageView.image = HALF_ART;
            }else{
                imageView.image = RED_HALF_ART;
            }
            newValue = 2 ; // 最少0分
        }
        _value = newValue;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        
        // Animation
        [UIView animateWithDuration:0.15f
                         animations:^{
                             changeView.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.1f
                                              animations:^{
                                                  changeView.transform = CGAffineTransformIdentity;
                                              } completion:nil];
                         }];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SureButtonCanClick" object:self];
   
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *
 */
-(void)setValue:(NSInteger)value{
   _defalutValue = value;
    [self layoutSubviews];
}

- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint point = [touch locationInView:self];
    [self sendActionsForControlEvents:UIControlEventTouchDown];
    [self updateValueAtPoint:point];
    return YES;
}

- (BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.frame, point)) {
        [self sendActionsForControlEvents:UIControlEventTouchDragInside];
    } else {
        [self sendActionsForControlEvents:UIControlEventTouchDragOutside];
    }
    [self updateValueAtPoint:point];
    return YES;
}

- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.frame, point)) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    } else {
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    }
}

- (void) cancelTrackingWithEvent:(UIEvent *)event
{
    [self sendActionsForControlEvents:UIControlEventTouchCancel];
}
@end
