//
//  HQTFProjectCollectionView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProjectCollectionView.h"

@interface HQTFProjectCollectionView ()

@end


@implementation HQTFProjectCollectionView


@dynamic delegate;

/**
 *  重写此方法，在需要的时候，拦截UIPanGestureRecognizer
 */
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    // 计算可能切换到的index
    NSInteger currentIndex = self.contentOffset.x / self.frame.size.width;
    NSInteger targetIndex = currentIndex;
    CGPoint translation = [gestureRecognizer translationInView:self];
    if (translation.x > 0) {
        targetIndex = currentIndex - 1;
    } else {
        targetIndex = currentIndex + 1;
    }
    
    // 第一页往右滑动
    if (targetIndex < 0) {
        return NO;
    }
    
    // 最后一页往左滑动
    NSUInteger numberOfPage = self.contentSize.width / self.frame.size.width;
    if (targetIndex >= numberOfPage) {
        return NO;
    }
    
    
    // 其他情况
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:shouldScrollToPageIndex:)]) {
        
        return [self.delegate collectionView:self shouldScrollToPageIndex:targetIndex];
    }
    
    return YES;
}



- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
//        [self addGesture];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    
    self = [super initWithCoder:coder];
    if (self) {
//        [self addGesture];
    }
    return self;
}


/**
 *  添加一个自定义的滑动手势
 */
- (void)addGesture{
    UILongPressGestureRecognizer *swipe = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(swipePressed:)];
    
    [self addGestureRecognizer:swipe];
}
/**
 *  监听手势的改变
 */
- (void)swipePressed:(UISwipeGestureRecognizer *)swipe{
    
    if (swipe.state == UIGestureRecognizerStateBegan) {
        [self gestureBegan:swipe];
    }
    if (swipe.state == UIGestureRecognizerStateChanged) {
        [self gestureChange:swipe];
    }
    if (swipe.state == UIGestureRecognizerStateCancelled ||
        swipe.state == UIGestureRecognizerStateEnded){
        [self gestureEndOrCancle:swipe];
    }
}


/**
 *  手势开始
 */
- (void)gestureBegan:(UISwipeGestureRecognizer *)swipe{
    
    UIView *view  = swipe.view;
    
    CGPoint point = [swipe locationOfTouch:0 inView:view];
}
/**
 *  手势拖动
 */
- (void)gestureChange:(UISwipeGestureRecognizer *)swipe{
   
}

/**
 *  手势取消或者结束
 */
- (void)gestureEndOrCancle:(UISwipeGestureRecognizer *)swipe{
   
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
