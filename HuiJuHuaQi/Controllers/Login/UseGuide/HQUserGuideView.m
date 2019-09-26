//
//  HQUserGuideView.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/21.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQUserGuideView.h"
#import "HQUserGuidePageControl.h"

#define UserGuideImageCount 4   //引导页三张图片

@interface HQUserGuideView ()<UIScrollViewDelegate>
@property (nonatomic, strong) HQUserGuidePageControl *pageControl;
@property (nonatomic,strong)  UIScrollView  *scrollView;
@end


@implementation HQUserGuideView


- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 1.引导页添加UISrollView
        [self setupScrollView];
        
        // 2.引导页添加pageControl
        [self setupPageControl];
    }
    
    return self;
}



/**
 *  引导页添加UISrollView
 */
- (void)setupScrollView
{

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = self.bounds;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    
    NSArray *titles   = @[@"考勤", @"审批", @"任务", @"项目"];
    NSArray *contents = @[@"让打卡更用趣", @"让流程更便捷", @"让工作更简单", @"让管理更轻松"];
    
    for (int i = 0; i < UserGuideImageCount; i++) {
        
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        view.backgroundColor = WhiteColor;
        [self.scrollView addSubview:view];
        
        
        CGFloat imgTop;
        if (iPhone35) {
            
            imgTop = 60;
        }else if (iPhone40) {
        
            imgTop = Long(126);
        }else if (iPhone47) {
        
            imgTop = Long(126);
        }else {
        
            imgTop = Long(126);
        }
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, imgTop, SCREEN_WIDTH, Long(243));
        NSString *name = [NSString stringWithFormat:@"引导%d", i];
        imageView.image = [UIImage imageNamed:name];
        [view addSubview:imageView];
        
        
        UILabel *titleLabel = [HQHelper labelWithFrame:CGRectMake(0, imageView.bottom+30, SCREEN_WIDTH, 22)
                                                  text:titles[i]
                                             textColor:LightBlackTextColor
                                         textAlignment:NSTextAlignmentCenter
                                                  font:FONT(22)];
        [view addSubview:titleLabel];
        
        
        UILabel *contentLabel = [HQHelper labelWithFrame:CGRectMake(0, titleLabel.bottom+20, SCREEN_WIDTH, 15)
                                                    text:contents[i]
                                               textColor:LightBlackTextColor
                                           textAlignment:NSTextAlignmentCenter
                                                    font:FONT(15)];
        [view addSubview:contentLabel];
    }
    
    
    [self addStartButton];
    
    // 3.设置其他属性
    self.scrollView.contentSize = CGSizeMake(UserGuideImageCount * SCREEN_WIDTH, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
}


/**
 *  添加pageControl
 */
- (void)setupPageControl
{
    
    // 1.添加圆点
    self.pageControl = [[HQUserGuidePageControl alloc] init];
//    self.pageControl.backgroundColor = [UIColor orangeColor];
    self.pageControl.numberOfPages = UserGuideImageCount;
    self.pageControl.frame = CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 30);
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
    
    // 2.设置圆点的颜色
    self.pageControl.currentPageIndicatorTintColor = LightGrayTextColor;    // 当前页的小圆点颜色
    self.pageControl.pageIndicatorTintColor = CellClickColor; // 非当前页的小圆点颜色
    
    [self performSelector:@selector(scrollViewDidScroll:) withObject:nil afterDelay:0.25];
}



- (void)addStartButton
{
    // 1.添加开始按钮
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(3*SCREEN_WIDTH + SCREEN_WIDTH/2 - 62, 0.825*SCREEN_HEIGHT, 133, 33);
    startButton.layer.cornerRadius = startButton.height / 2;
    startButton.layer.masksToBounds = YES;
    startButton.layer.borderColor = GrayTextColor.CGColor;
    startButton.layer.borderWidth = 1.5;
    startButton.titleLabel.font = FONT(15);
    [startButton setTitle:@"立 即 体 验" forState:UIControlStateNormal];
    [startButton setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
    [startButton setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
    [startButton addTarget:self action:@selector(startMainVC) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:startButton];
}


/**
 *  点击进入
 */
- (void)startMainVC
{
    NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:versionStr];
    
    [self removeFromSuperview];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获得页码
    CGFloat doublePage = scrollView.contentOffset.x / scrollView.width;
    int intPage = (int)(doublePage + 0.5);
    
    // 设置页码
    self.pageControl.currentPage = intPage;
}



//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    // 获得页码
//    CGFloat doublePage = scrollView.contentOffset.x / scrollView.width;
//    int intPage = (int)(doublePage + 0.5);
//    
//    // 设置页码
//    self.pageControl.currentPage = intPage;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
