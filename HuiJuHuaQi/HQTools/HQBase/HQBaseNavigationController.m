//
//  HQBaseNavigationController.m
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/5.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseNavigationController.h"
#import "HQBaseViewController.h"
#import "TFProjectBenchController.h"

// 打开边界多少距离才触发pop
#define DISTANCE_TO_POP 80

@interface HQBaseNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation HQBaseNavigationController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.arrayScreenshot = [NSMutableArray array];
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        self.arrayScreenshot = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
//    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[HQBaseNavigationController class],[UINavigationController class]]];
    
//    [self.navigationBar setBackgroundImage:[HQHelper createImageWithColor:RedColor size:(CGSize){SCREEN_WIDTH,64}] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
//    
//    [HQHelper createImageWithColor:RedColor size:(CGSize){SCREEN_WIDTH,64}];
    
    
//    [self setValue:bar forKeyPath:@"navigationBar"];
    
    
//    self.navigationBar.translucent = NO;
//    
//    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    
//    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
//    
//    [self fillNavigationBar:HexColor(0xfafbfc, 1)];
//    
//    // 添加导航栏分割线
//    UIView *lineView = [[UIView alloc] init] ;
//    lineView.frame =CGRectMake(0, 44.0f, SCREEN_WIDTH, 0.5) ;
//    lineView.backgroundColor = HexColor(0xd9d9d9, 1) ;
//    lineView.tag = 0x123;
//    [self.navigationBar addSubview:lineView] ;
    
    //屏蔽系统的手势
#if kUseScreenShotGesture
    self.interactivePopGestureRecognizer.enabled = NO;
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _panGesture.delegate = self;
    [self.view addGestureRecognizer:_panGesture];
#else
    [self fullScreenPop];
#endif
    
//    [self configNavigationBar];
    
}
/** 全屏优化返回 */
- (void)fullScreenPop{
    //  这句很核心 稍后讲解
    id target = self.interactivePopGestureRecognizer.delegate;
    //  这句很核心 稍后讲解
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    //  获取添加系统边缘触发手势的View
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    
    //  创建pan手势 作用范围是全屏
    UIPanGestureRecognizer * fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    fullScreenGes.delegate = self;
    [targetView addGestureRecognizer:fullScreenGes];
    
    // 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:NO];
    
}
//  防止导航控制器只有一个rootViewcontroller时触发手势
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    //解决与左滑手势冲突
//    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
//    if (translation.x <= 0) {
//        return NO;
//    }
//    return self.childViewControllers.count == 1 ? NO : YES;
//}


//-(void)configNavigationBar{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    NSDictionary *attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,nil];
//    self.navigationBar.titleTextAttributes = attributeDic;
//    self.navigationBar.translucent = YES;
//    [UINavigationBar appearance].barTintColor = [UIColor orangeColor];
//    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
//}
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
   
    
#if kUseScreenShotGesture
    if (gestureRecognizer.view == self.view) {
        HQBaseViewController *topView = (HQBaseViewController *)self.topViewController;
        
        if (!topView.enablePanGesture)
            return NO;
        else
        {
            CGPoint translate = [gestureRecognizer translationInView:self.view];
//            HQLog(@"=======%@========",NSStringFromCGPoint(translate));
            
            BOOL possible = translate.x != 0 && fabs(translate.y) == 0;
            if (possible)
                return YES;
            else
                return NO;
            return YES;
        }
    }
    return NO;
#else
    
    HQBaseViewController *topView = (HQBaseViewController *)self.topViewController;
    
//    if ([topView isKindOfClass:[TFProjectBenchController class]]) {
//        return YES;
//    }
    
    if (!topView.enablePanGesture){
        return NO;
    }
    //解决与左滑手势冲突
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    return self.childViewControllers.count == 1 ? NO : YES;
    
#endif
    
}
///此方法可以解决滑动的冲突，
///举个栗子：侧滑返回和UIScrollView的本身滑动冲突了。再举个栗子：tableviewCell身上自带的系统删除，筛选界面展开的左滑事件有冲突
///下面详细解释此方法:
///同一个view上如果作用了两个相同类型的手势，那么系统默认只会响应一个，why？因为系统是SB，系统还没有这么智能的知道你想怎么样，他不会知道手势冲突的时候让那个接受手势，剩下的就是程序员的工作了，我们可以在此方法中判断，机制的做出明确的处理，该方法返回YES时，意味着所有相同类型的手势辨认都会得到处理。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")]|| [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPagingSwipeGestureRecognizer")]) //
    {
        
        UIView *aView = otherGestureRecognizer.view;
        
//        HQLog(@"%ld",aView.tag);
//        if (aView.tag == 0x7788) {
//            return NO;
//        }
        
        if ([aView isKindOfClass:[UIScrollView class]]) {
            UIScrollView *sv = (UIScrollView *)aView;
            if (sv.contentOffset.x==0) {
                return YES;
            }
        }
        return NO;
    }
    
    return YES;
}
#if kUseScreenShotGesture

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController *rootVC = appdelegate.window.rootViewController;
    UIViewController *presentedVC = rootVC.presentedViewController;
    if (self.viewControllers.count == 1)
    {
        return;
    }
    if (panGesture.state == UIGestureRecognizerStateBegan)
    {
        appdelegate.screenshotView.hidden = NO;
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point_inView = [panGesture translationInView:self.view];
        if (point_inView.x >= 10)
        {
            rootVC.view.transform = CGAffineTransformMakeTranslation(point_inView.x - 10, 0);
            presentedVC.view.transform = CGAffineTransformMakeTranslation(point_inView.x - 10, 0);
        }
        
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint point_inView = [panGesture translationInView:self.view];
        if (point_inView.x >= DISTANCE_TO_POP)
        {
            [UIView animateWithDuration:0.3 animations:^{
                rootVC.view.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH, 0);
                presentedVC.view.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH, 0);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                rootVC.view.transform = CGAffineTransformIdentity;
                presentedVC.view.transform = CGAffineTransformIdentity;
                appdelegate.screenshotView.hidden = YES;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                rootVC.view.transform = CGAffineTransformIdentity;
                presentedVC.view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                appdelegate.screenshotView.hidden = YES;
            }];
        }
    }
    
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSArray *arr = [super popToViewController:viewController animated:animated];
    
    if (self.arrayScreenshot.count > arr.count)
    {
        for (int i = 0; i < arr.count; i++) {
            [self.arrayScreenshot removeLastObject];
        }
    }
    return arr;
}

#endif



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count == 0){
        return [super pushViewController:viewController animated:animated];
    }else if (self.viewControllers.count>=1) {
        viewController.hidesBottomBarWhenPushed = YES;//隐藏二级页面的tabbar
    }
#if kUseScreenShotGesture
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(appdelegate.window.frame.size.width, appdelegate.window.frame.size.height), YES, 0);
    [appdelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.arrayScreenshot addObject:viewImage];
    appdelegate.screenshotView.imgView.image = viewImage;
#endif
    [super pushViewController:viewController animated:animated];
}

-(void)popController{
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
#if kUseScreenShotGesture
    appdelegate.screenshotView.hidden = NO;
#endif
    UIViewController *rootVC = appdelegate.window.rootViewController;
    UIViewController *presentedVC = rootVC.presentedViewController;
    
    [UIView animateWithDuration:0.35 animations:^{
        rootVC.view.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH, 0);
        presentedVC.view.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        [self popViewControllerAnimated:NO];
        rootVC.view.transform = CGAffineTransformIdentity;
        presentedVC.view.transform = CGAffineTransformIdentity;
#if kUseScreenShotGesture
        appdelegate.screenshotView.hidden = YES;
#endif
    }];
    
//    [self popControllerWithWidth:0];
}

- (void)popControllerWithWidth:(CGFloat)width{
    
    __block CGFloat add = width;
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
#if kUseScreenShotGesture
    appdelegate.screenshotView.hidden = NO;
#endif
    UIViewController *rootVC = appdelegate.window.rootViewController;
    UIViewController *presentedVC = rootVC.presentedViewController;
    
    [UIView animateWithDuration:0.000375/50 animations:^{
        rootVC.view.transform = CGAffineTransformMakeTranslation(rootVC.view.transform.tx + 20>= SCREEN_WIDTH?SCREEN_WIDTH:rootVC.view.transform.tx + 20, 0);
        presentedVC.view.transform = CGAffineTransformMakeTranslation(presentedVC.view.transform.tx + 20>=SCREEN_WIDTH?SCREEN_WIDTH:presentedVC.view.transform.tx + 20, 0);
    } completion:^(BOOL finished) {
        add += 20;
        if (width >= SCREEN_WIDTH) {
            
            [self popViewControllerAnimated:NO];
            rootVC.view.transform = CGAffineTransformIdentity;
            presentedVC.view.transform = CGAffineTransformIdentity;
#if kUseScreenShotGesture
            appdelegate.screenshotView.hidden = YES;
#endif

        }else{
            [self popControllerWithWidth:add];
        }
    
    }];
    
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
#if kUseScreenShotGesture
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.arrayScreenshot removeLastObject];
    UIImage *image = [self.arrayScreenshot lastObject];
    if (image)
        appdelegate.screenshotView.imgView.image = image;
#endif
    
    UIViewController *v = [super popViewControllerAnimated:animated];
    return v;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
#if kUseScreenShotGesture
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.arrayScreenshot.count > 2)
    {
        [self.arrayScreenshot removeObjectsInRange:NSMakeRange(1, self.arrayScreenshot.count - 1)];
    }
    UIImage *image = [self.arrayScreenshot lastObject];
    if (image)
        appdelegate.screenshotView.imgView.image = image;
#endif
    return [super popToRootViewControllerAnimated:animated];
}


-(void)fillNavigationBar:(UIColor *)color
{
    for (UIView *view in self.navigationBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            if ([view isKindOfClass:[UIView class]]) {
                view.backgroundColor = color;
                break;
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
