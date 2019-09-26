//
//  HQBaseViewController.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/13.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//


#import "HQBaseViewController.h"

@implementation HQBaseViewController

- (id)init{
    self = [super init];
    if (self) {
        self.enablePanGesture = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //设置默认导航栏颜色、标题颜色
    [self setNavBarColor:HexAColor(0xffffff, 1) titleTextAttributes:@{NSForegroundColorAttributeName:BlackTextColor,NSFontAttributeName:BFONT(20)}
     ];
    
    self.view.backgroundColor = BackGroudColor;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,.5}];
    [self.view addSubview:view];
    view.backgroundColor = CellSeparatorColor;
    self.shadowLine = view;
    view.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)appActive{
    
    if (self.navigationController.childViewControllers.count > 1) {
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //第一层界面无返回按钮，且第一层时显示TABBAR，否则隐藏
    if (self.navigationController.viewControllers.count > 1) {
        self.tabBarController.tabBar.hidden = YES;
        [self setNavigationBar];
    }else {
        self.tabBarController.tabBar.hidden = NO;
    }
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
        
//        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexAColor(0xc8c8c8, 1) size:(CGSize){SCREEN_WIDTH,0.5}]];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){SCREEN_WIDTH,0.5}]];
        
    }
    [self.view insertSubview:self.shadowLine atIndex:self.view.subviews.count];
    
#ifdef DEBUG // 调试状态, 打开LOG功能
#if ShowNameOfController
    if ([KeyWindow viewWithTag:0x578]) {
        
        UILabel *label = [KeyWindow viewWithTag:0x578];
        label.text = NSStringFromClass([self findFatherVc:self].class);
    }else{
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){0,15+TopM,SCREEN_WIDTH,20}];
        [KeyWindow addSubview:label];
        label.font = FONT(14);
        label.backgroundColor = BackGroudColor;
        label.alpha = 0.5;
        label.tag = 0x578;
        label.text = NSStringFromClass([self findFatherVc:self].class);
        label.textAlignment = NSTextAlignmentCenter;
        
    }
#endif
#endif
    
}

-(UIViewController *)findFatherVc:(UIViewController *)vc{
    if (vc.parentViewController) {
        if ([vc.parentViewController isKindOfClass:[UINavigationController class]]) {
            return vc;
        }else{
            return [self findFatherVc:vc.parentViewController];
        }
    }else{
        return vc;
    }
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

#pragma mark - Custom Method
//设置导航栏颜色、标题属性
- (void)setNavBarColor:(UIColor*)bColor titleTextAttributes:(NSDictionary*)attribute
{
    //设置导航栏颜色
    self.navigationController.navigationBar.barTintColor = bColor;
    [self.navigationController.navigationBar setTitleTextAttributes:attribute];
    
    self.navigationController.navigationBar.shadowImage = [HQHelper createImageWithColor:ClearColor size:(CGSize){SCREEN_WIDTH,0.5}];
    [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xffffff, 1) size:(CGSize){SCREEN_WIDTH,NaviHeight}] forBarMetrics:0];
}

// 从导航栏底部布局视图
- (void)setFromNavBottomEdgeLayout
{
    if (IOS7_AND_LATER)
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}



#pragma mark - 设置导航栏
- (void)setNavigationBar {
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(didBack:) image:@"返回灰色" text:@"返回" textColor:GreenColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:BlackTextColor,NSFontAttributeName:BFONT(20)}];

}

- (id)titleItemWithTitle:(NSString *)title color:(UIColor *)color imageName:(NSString *)imageName withTarget:(id)target action:(SEL)action{
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH-120,44}];
    
    UILabel *btn = [[UILabel alloc] init];
    btn.lineBreakMode = NSLineBreakByTruncatingTail;
    btn.textColor = color;
    btn.textAlignment = NSTextAlignmentLeft;
    btn.text = title;
    btn.font = BFONT(20);
    btn.userInteractionEnabled = YES;
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH-100, 44);
    btn.backgroundColor = ClearColor;
    [view addSubview:btn];
    
    CGSize size = [HQHelper sizeWithFont:BFONT(20) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:title];
    if (size.width > SCREEN_WIDTH-120) {
        btn.width = SCREEN_WIDTH-120;
    }else{
        btn.width = size.width;
    }
    if (imageName && ![imageName isEqualToString:@""]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){CGRectGetMaxX(btn.frame),0,30,44}];
        [view addSubview:imageView];
        imageView.image = IMG(imageName);
        imageView.contentMode = UIViewContentModeCenter;
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [imageView addGestureRecognizer:tap];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [btn addGestureRecognizer:tap];
    
    return [[UIBarButtonItem alloc] initWithCustomView:view];
}

//  创建一个item
- (id)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highlightImage:(NSString *)highlightImage {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //设置按钮图片
    HQLog(@"%@",image);
    //    btn.frame = CGRectMake(0, 20, 49, 49);
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
    //设置按钮尺寸
    btn.size = CGSizeMake(30, 44);
    btn.imageView.contentMode = UIViewContentModeCenter;
    btn.contentMode = UIViewContentModeCenter;
    btn.backgroundColor = ClearColor;
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}


- (id)itemWithTarget:(id)target action:(SEL)action text:(NSString *)text textColor:(UIColor *)textColor
{
    
    CGSize size = [HQHelper sizeWithFont:FONT(17) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:text];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, size.width + 10, 44);
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    btn.titleLabel.font = FONT(17);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}


- (id)itemWithTarget:(id)target action:(SEL)action text:(NSString *)text
{
    return [self itemWithTarget:target
                         action:action
                           text:text
                      textColor:ExtraLightBlackTextColor];
}
- (id)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image text:(NSString *)text textColor:(UIColor *)color{
    
    UIButton *btn = [HQHelper buttonWithFrame:CGRectMake(0, 0, 0, 0) normalImageStr:image highImageStr:image target:target action:action];
    btn.titleLabel.font = BFONT(17);
    
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateHighlighted];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    //设置按钮尺寸
    btn.size = CGSizeMake(btn.currentImage.size.width + 18* text.length,44);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (id)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image text:(NSString *)text
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 18*text.length, 44);
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    btn.titleLabel.font = FONT(17);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //设置按钮尺寸
    btn.size = CGSizeMake(btn.currentImage.size.width + 18 * text.length,44);
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}


- (id)itemWithTarget:(id)target action:(SEL)action rightimage:(NSString *)image lefttext:(NSString *)text
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 18*text.length, 44);
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    btn.titleLabel.font = FONT(17);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片文字位置
    CGFloat imageWidth = btn.imageView.bounds.size.width;
    CGFloat labelWidth = btn.titleLabel.bounds.size.width;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth)];
    //设置按钮尺寸
    btn.size = CGSizeMake(btn.currentImage.size.width + 17 * text.length ,44);
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}




#pragma mark - 返回上一页
- (void)didBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}







#pragma mark - 各种公共方法
- (UIView *)creatTableViewFootViewWithNum:(NSInteger)number
{
    return [self creatTableViewFootViewWithNum:number title:@"暂无数据"];
}



- (UIView *)creatTableViewFootViewWithNum:(NSInteger)number title:(NSString *)title
{
    if (number != 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无内容"]];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView.frame = CGRectMake((SCREEN_WIDTH-95)/2, (200-95)/2, 95, 95);
    UILabel *lable = [[UILabel alloc] initWithFrame:(CGRect){(SCREEN_WIDTH-140)/2,imageView.bottom,140,35}];
    lable.font = FONT(17);
    lable.textColor = GrayTextColor;
    lable.text = title;
    lable.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:imageView];
    [view addSubview:lable];
    
    return view;
}



@end
