//
//  TFChartStatisticsController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChartStatisticsController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "LBKeyChainTool.h"
#import "NSString+AES.h"

@interface TFChartStatisticsController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic,strong) WKWebView *webView;
/** htmlUrl */
@property (nonatomic, copy) NSString *htmlUrl;


@end

@implementation TFChartStatisticsController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enablePanGesture = YES;
    
//    self.navigationItem.leftBarButtonItem = [self titleItemWithTitle:@"数据报表" color:BlackTextColor imageName:nil withTarget:nil action:nil];
//    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.title = @"数据报表";
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.userContentController = [[WKUserContentController alloc] init];
    config.processPool = [[WKProcessPool alloc] init];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomM)
                                      configuration:config];
    
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate =self;
    self.webView.backgroundColor = BackGroudColor;
    
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"closeLoading"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"iosFullScreen"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"iosExitFullScreen"];
    
    [self.view addSubview:self.webView];
    
    self.htmlUrl = [NSString stringWithFormat:@"%@",H5URL(customChart)];
//    self.htmlUrl = [NSString stringWithFormat:@"http://192.168.1.145:8787/#/echarts"];
//    self.htmlUrl = [NSString stringWithFormat:@"https://page.teamface.cn/#/echarts"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.htmlUrl]]];
    
    
    // app 活跃通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:ChangeCompanySocketConnect object:nil];
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

- (void)applicationDidBecomeActive{
    
    if ([UM.userLoginInfo.isLogin isEqualToString:@"1"]) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:UM.userLoginInfo.token forKey:@"TOKEN"];
        [dict setObject:@(2) forKey:@"FLAG"];
        NSString *sign = [NSString stringWithFormat:@"%lld,%@,2,%u",[HQHelper getNowTimeSp],[LBKeyChainTool getUUIDStr],arc4random_uniform(100)];
        NSString *signSecret = [sign aes128Encrypt:Privatekey];
        signSecret = [signSecret stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        signSecret = [signSecret stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        [dict setObject:signSecret forKey:@"SIGN"];
        
        [self.webView evaluateJavaScript:[NSString stringWithFormat:@"getToken(%@)",[HQHelper dictionaryToJson:dict]] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            HQLog(@"error:%@",error);
        }];
    }
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

#pragma mark - WKScriptMessageHandler
//实现js注入方法的协议方法
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:@"closeLoading"]) {// 加载完毕
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    //找到对应js端的方法名,获取messge.body
    if ([message.name isEqualToString:@"iosFullScreen"]) {// 进入全屏
        
        [self.webView removeFromSuperview];
        [KeyWindow addSubview:self.webView];
        self.navigationItem.leftBarButtonItem = nil;
        [UIView animateWithDuration:0.25 animations:^{
            
            self.webView.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.webView.frame = CGRectMake(0, BottomM, SCREEN_WIDTH, SCREEN_HEIGHT-BottomM-TopM);
        }completion:^(BOOL finished) {
            
            // 刷新
//            [self.webView evaluateJavaScript:[NSString stringWithFormat:@"refresh()"] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//                //此处可以打印error.
//
//            }];
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }];
        
    }
    if ([message.name isEqualToString:@"iosExitFullScreen"]) {// 退出全屏
        
        [self.webView removeFromSuperview];
        [self.view addSubview:self.webView];
//        self.navigationItem.leftBarButtonItem = [self titleItemWithTitle:@"数据报表" color:BlackTextColor imageName:nil withTarget:nil action:nil];
        [UIView animateWithDuration:0.25 animations:^{
            
            self.webView.transform = CGAffineTransformIdentity;
            self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomM);
        }completion:^(BOOL finished) {
            
            // 刷新
//            [self.webView evaluateJavaScript:[NSString stringWithFormat:@"refresh()"] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//                //此处可以打印error.
//
//            }];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }];
        
    }
}

#pragma mark - 监听WKWebView代理相关关
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {// 页面加载完了，可以在此向H5传值
    
    [self applicationDidBecomeActive];
    
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{// 网页加载失败
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,60}];
    [view addSubview:label];
    label.center = view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"客..客..客官，网..网..网页丢..丢了！！！";
    
    
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
