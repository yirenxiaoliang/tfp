//
//  TFEndlessView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/17.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEndlessView.h"
#import "TFPageControl.h"
//#define LeftMargin 15
//#define TopMargin 10
//#define LayerCircle 4
//#define LeftMargin 0
//#define TopMargin 0
//#define LayerCircle 0


@interface TFEndlessView()<UIScrollViewDelegate,TFPageControlDelegate>

@property (nonatomic, strong) CADisplayLink *scrollTimer;                  ///< 定时器

/** second */
@property (nonatomic, assign) NSInteger second;

/** scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;

/** NSMutableArray *images */
@property (nonatomic, strong) NSMutableArray *images;

/** imageViews */
@property (nonatomic, strong) NSMutableArray *imageViews;

@property (nonatomic, assign) CGFloat LeftMargin;
@property (nonatomic, assign) CGFloat TopMargin;
@property (nonatomic, assign) CGFloat LayerCircle;


@property (nonatomic, strong) TFPageControl *pageControl;

@end

@implementation TFEndlessView

-(NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

-(void)setIsBorder:(BOOL)isBorder{
    _isBorder = isBorder;
    if (isBorder) {
        self.LeftMargin = 15;
        self.TopMargin = 10;
        self.LayerCircle = 4;
    }else{
        self.LeftMargin = 0;
        self.TopMargin = 0;
        self.LayerCircle = 0;
    }
    
    for (NSInteger i = 0; i < self.imageViews.count; i ++) {
        
        UIImageView *imageView = self.imageViews[i];
        imageView.frame = (CGRect){i*self.width + self.LeftMargin,0 + self.TopMargin,self.width - 2 * self.LeftMargin,self.height - 2 * self.TopMargin};
        imageView.layer.cornerRadius = self.LayerCircle;
    }
    self.pageControl.frame = (CGRect){0,self.height-self.TopMargin-15,self.width,15};
}

-(void)refreshEndlessViewWithImages:(NSArray *)images{
    
    if (images.count == 0) {
        UIImage *img = [UIImage imageNamed:@"Banner"];
        if (img) {
            images = [NSMutableArray arrayWithArray:@[img]];
        }
    }
    
    for (UIView *view in self.imageViews) {
        [view removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
    
    NSMutableArray *arr = [NSMutableArray array];
    if (images.count > 1) {
        [arr addObject:images.lastObject];
    }
    [arr addObjectsFromArray:images];
    if (images.count > 1) {
        [arr addObject:images.firstObject];
    }
    self.images = arr;
    
    for (NSInteger i = 0; i < arr.count; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){i*self.width + self.LeftMargin,0 + self.TopMargin,self.width - 2 * self.LeftMargin,self.height - 2 * self.TopMargin}];
        [self.scrollView addSubview:imageView];
        if ([arr[i] isKindOfClass:[NSString class]]) {
            [imageView sd_setImageWithURL:[HQHelper URLWithString:arr[i]] placeholderImage:[HQHelper createImageWithColor:WhiteColor]];
        }
        if ([arr[i] isKindOfClass:[UIImage class]]) {
            imageView.image = images[i];
        }
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.layer.cornerRadius = self.LayerCircle;
        imageView.layer.masksToBounds = YES;
        [self.imageViews addObject:imageView];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.imageViews.count * self.width, self.height);
    
    [self insertSubview:self.pageControl atIndex:self.subviews.count-1];
    if (self.images.count > 1) {
        [self.scrollView setContentOffset:(CGPoint){self.width,0} animated:NO];
        [self setupScrollTimer];
        self.pageControl.hidden = NO;
        self.pageControl.numberOfPages = self.images.count-2;
        self.pageControl.currentPage = 0;
    }else{
        self.pageControl.hidden = YES;
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        NSMutableArray *images = [NSMutableArray arrayWithArray:@[[UIImage imageNamed:@"Banner"]]];
        
//        NSMutableArray *images = [NSMutableArray arrayWithArray:@[[UIImage imageNamed:@"滚屏图3"],[UIImage imageNamed:@"滚屏图1"],[UIImage imageNamed:@"滚屏图2"],[UIImage imageNamed:@"滚屏图3"],[UIImage imageNamed:@"滚屏图1"]]];
        self.images = images;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        scrollView.layer.masksToBounds = NO;
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(images.count * self.width, self.height);
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = WhiteColor;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        for (NSInteger i = 0; i < images.count; i ++) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){i*self.width + self.LeftMargin,0 + self.TopMargin,self.width - 2 * self.LeftMargin,self.height - 2 * self.TopMargin}];
            [scrollView addSubview:imageView];
            imageView.image = images[i];
            imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.layer.cornerRadius = self.LayerCircle;
            imageView.layer.masksToBounds = YES;
            [self.imageViews addObject:imageView];
        }
        
        TFPageControl *pageControl = [[TFPageControl alloc] initWithFrame:(CGRect){0,self.height-self.TopMargin-15,self.width,15}];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        pageControl.index = 3;
        pageControl.backgroundColor = ClearColor;
        pageControl.delegate = self;
        
        if (self.images.count > 1) {

            [self.scrollView setContentOffset:(CGPoint){self.width,0} animated:NO];
            [self setupScrollTimer];
            self.pageControl.hidden = NO;
            pageControl.numberOfPages = self.images.count-2;
            pageControl.currentPage = 0;

        }else{
            self.pageControl.hidden = YES;
        }
        
        
    }
    return self;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //    HQLog(@"%s",__FUNCTION__);
    [self stopScrollTimer];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    //    HQLog(@"%s",__FUNCTION__);
    
    NSInteger page = (NSInteger)self.scrollView.contentOffset.x / self.width;
    
        HQLog(@"=====%ld======",page);
    
    if (page == self.images.count-1) {
        
        [self.scrollView setContentOffset:(CGPoint){self.width,0} animated:NO];
        self.pageControl.currentPage = 0;
    }else if (page == 0){
        
        [self.scrollView setContentOffset:(CGPoint){self.width*(self.images.count-2),0} animated:NO];
        
        self.pageControl.currentPage = self.images.count-2-1;
    }else{
        self.pageControl.currentPage = page-1;
    }
    
    if (self.images.count > 1) {
        [self setupScrollTimer];
    }
}


- (void)setupScrollTimer{
    if (!_scrollTimer) {
        _scrollTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(endlessScroll)];
        [_scrollTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopScrollTimer{
    if (_scrollTimer) {
        [_scrollTimer invalidate];
        _scrollTimer = nil;
        self.second = 0;
    }
}

- (void)endlessScroll{
    
    //    HQLog(@"endlessScroll");
    
    self.second += 1;
    
    if (self.second / 180 == 1) {
        
        self.second = 0;
        
        NSInteger page = (NSInteger)self.scrollView.contentOffset.x / self.width;
        
//        HQLog(@"=====%ld======",page);
        
        
        if (page == self.images.count-1) {
            
            [self.scrollView setContentOffset:(CGPoint){self.width,0} animated:NO];
            page = 1;
        }
        
        
        [self.scrollView setContentOffset:(CGPoint){self.width * (page + 1),0} animated:YES];
        if (page >= self.images.count-2) {

            self.pageControl.currentPage = 0;
        }else{
            self.pageControl.currentPage = page;
        }
    }
}

#pragma mark - TFPageControlDelegate
-(void)pageControlDidClickedWithIndex:(NSInteger)index{
    
    [self.scrollView setContentOffset:(CGPoint){self.width * (index + 1),0} animated:YES];
    [self stopScrollTimer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupScrollTimer];
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
