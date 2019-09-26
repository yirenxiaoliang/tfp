//
//  TFBurWindowView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/28.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFBurWindowView.h"
#import "TFModelView.h"

#define MaxWidth (SCREEN_WIDTH-120)
#define Margin (10)
#define TopHeight (40)


@interface TFBurWindowView ()<UIScrollViewDelegate,TFModelViewDelegate>

/** scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;

/** pageControl */
@property (nonatomic, weak) UIPageControl *pageControl;

/** items */
@property (nonatomic, strong) NSMutableArray *items;

/** titleLabel */
@property (nonatomic, weak) UILabel *titleLabel;

/** rect */
@property (nonatomic, assign) CGRect rect;

/** application */
@property (nonatomic, strong) TFApplicationModel *application;

@end


@implementation TFBurWindowView

-(NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = HexAColor(0x000000, 0.5);
        
//        UIToolbar *blurEffectView = [[UIToolbar alloc] initWithFrame:self.bounds];
//        blurEffectView.barStyle = UIBarStyleDefault;
//        blurEffectView.backgroundColor = ClearColor;
//        [self insertSubview:blurEffectView atIndex:0];
        
        UIScrollView *view = [[UIScrollView alloc] initWithFrame:(CGRect){0,0,MaxWidth+2*Margin,MaxWidth+2*Margin + TopHeight}];
        [self addSubview:view];
        view.center = CGPointMake(self.width/2, self.height/2);
        view.backgroundColor = HexColor(0xe6e6e6);
        view.layer.cornerRadius = 13;
        view.layer.masksToBounds = YES;
        view.pagingEnabled = YES;
        view.showsVerticalScrollIndicator = NO;
        view.showsHorizontalScrollIndicator = NO;
        view.delegate = self;
        self.scrollView = view;
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(view.frame)-17,self.width,20}];
        [self addSubview:pageControl];
        pageControl.numberOfPages = 2;
        pageControl.currentPage = 0;
        pageControl.pageIndicatorTintColor = LightGrayTextColor;
        pageControl.currentPageIndicatorTintColor = WhiteColor;
        [pageControl addTarget:self action:@selector(dotClicked:) forControlEvents:UIControlEventValueChanged];
        self.pageControl = pageControl;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:(CGRect){CGRectGetMinX(view.frame) + 15,CGRectGetMinY(view.frame) + 10,MaxWidth - 30,TopHeight}];
        [self addSubview:titleLabel];
        titleLabel.textColor = BlackTextColor;
        titleLabel.font = FONT(17);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        titleLabel.text = @"";
        self.titleLabel = titleLabel;
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
//        [self addSubview:button];
//        button.frame = CGRectMake(100, 100, 100, 100);
//        [button addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addClick)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)addClick{

    [self hideAnimationRect:_rect];
    
}

- (void)dotClicked:(UIPageControl *)pageControl{
    
    NSInteger current = pageControl.currentPage;
    
    [self.scrollView setContentOffset:(CGPoint){MaxWidth * current , 0} animated:YES];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger current = scrollView.contentOffset.x / MaxWidth ;
    
    self.pageControl.currentPage = current;
    
}

/** 刷新 */
- (void)refreshItemWithApplication:(TFApplicationModel *)application rect:(CGRect)rect type:(NSInteger)type oftenApplication:(TFApplicationModel *)oftenApplication{
    
    _rect = rect;
    self.application = application;
    self.titleLabel.text = application.name?:application.chinese_name;
    
    for (TFModelView *view  in self.items) {
        
        [view removeFromSuperview];
        
    }
    [self.items removeAllObjects];
    
    NSInteger page = ((self.application.modules.count + 8) / 9);
    
    self.pageControl.numberOfPages = page;
    if (page < 2) {
        self.pageControl.hidden = YES;
    }else{
        self.pageControl.hidden = NO;
    }
    
    self.scrollView.contentSize = CGSizeMake((MaxWidth + 2*Margin) * page, (MaxWidth + 2*Margin) + TopHeight);
    
    for (NSInteger i = 0; i < application.modules.count; i++) {
        
        CGFloat X = Margin + (i % 3) * MaxWidth/3 + (i / 9) * (MaxWidth+2*Margin);
        CGFloat Y = Margin + ((i % 9) / 3) * MaxWidth/3  + TopHeight;
        TFModelView *view = [TFModelView modelView];
        view.frame = (CGRect){X,Y,MaxWidth/3,MaxWidth/3};
        [self.scrollView addSubview:view];
        [self.items addObject:view];
        view.delegate = self;
        
        TFModuleModel *model = application.modules[i];
        
        if (oftenApplication) {
            
            if (type == 0) {
                [view refreshViewWithModule:model type:0];
            }else{
                
                BOOL have = NO;
                for (TFModuleModel *often in oftenApplication.modules) {
                    
                    if ([often.english_name isEqualToString:model.english_name]) {
                        have = YES;
                        break;
                    }
                }
                if (have) {
                    
                    [view refreshViewWithModule:model type:2];
                }else{
                    
                    [view refreshViewWithModule:model type:1];
                }
            }
        }else{
            [view refreshViewWithModule:model type:type];
        }
    }
    
    [self showAnimationRect:rect];
    
}

#pragma mark - TFModelViewDelegate
-(void)didClickedHandleBtnWithModelView:(TFModelView *)modelView module:(TFModuleModel *)module{
    
    if (modelView.handleBtn.selected) {
        
        [modelView refreshViewWithModule:module type:2];
    }else{
        [modelView refreshViewWithModule:module type:1];
    }
    
    if ([self.delegate respondsToSelector:@selector(burWindowViewDidClickedAddModule:)]) {
        [self.delegate burWindowViewDidClickedAddModule:module];
    }
}

-(void)didClickedmodelView:(TFModelView *)modelView application:(TFApplicationModel *)application module:(TFModuleModel *)module{
    
    if ([self.delegate respondsToSelector:@selector(burWindowViewDidClickedModelView:module:)]) {
        [self.delegate burWindowViewDidClickedModelView:modelView module:module];
    }
}


-(void)showAnimationRect:(CGRect)rect{
    
    self.alpha = 0;
    self.titleLabel.hidden = YES;
    self.pageControl.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }completion:^(BOOL finished) {
        self.titleLabel.hidden = NO;
        
        NSInteger page = ((self.application.modules.count + 8) / 9);
        
        self.pageControl.numberOfPages = page;
        if (page < 2) {
            self.pageControl.hidden = YES;
        }else{
            self.pageControl.hidden = NO;
        }
    }];
    
    
    NSMutableArray *animations = [NSMutableArray array];
    // 动画组
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position";
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height/2)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.width/2, self.height/2)];
    [animations addObject:animation];
//    [self.scrollView.layer addAnimation:animation forKey:@"ddddd"];
    
    
    CGFloat scale = rect.size.width / (MaxWidth + 2*Margin);
    CABasicAnimation *animation1 = [CABasicAnimation animation];
    animation1.keyPath = @"transform.scale";
    animation1.fromValue = @(scale);
    animation1.toValue = @(1);
    [animations addObject:animation1];
    
    animGroup.removedOnCompletion = NO;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.duration = 0.3;
    animGroup.animations = animations;
    
    // 添加动画
    [self.scrollView.layer addAnimation:animGroup forKey:@"eeeee"];
}

-(void)hide{
    if (self.alpha == 0) {
        return;
    }
    [self hideAnimationRect:_rect];
}

-(void)hideAnimationRect:(CGRect)rect{
    
    self.alpha = 1;
    self.titleLabel.hidden = YES;
//    self.pageControl.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }];
    
    
    NSMutableArray *animations = [NSMutableArray array];
    // 动画组
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position";
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height/2)];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.width/2, self.height/2)];
    [animations addObject:animation];
    //    [self.scrollView.layer addAnimation:animation forKey:@"ddddd"];
    
    
    CGFloat scale = rect.size.width / (MaxWidth + 2*Margin);
    CABasicAnimation *animation1 = [CABasicAnimation animation];
    animation1.keyPath = @"transform.scale";
    animation1.toValue = @(scale);
    animation1.fromValue = @(1);
    [animations addObject:animation1];
    
    animGroup.removedOnCompletion = NO;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.duration = 0.3;
    animGroup.animations = animations;
    
    // 添加动画
    [self.scrollView.layer addAnimation:animGroup forKey:@"eeeee"];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
