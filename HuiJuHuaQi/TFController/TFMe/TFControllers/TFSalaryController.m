//
//  TFSalaryController.m
//  HuiJuHuaQi
//
//  Created by daidan on 2020/1/2.
//  Copyright © 2020 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSalaryController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "TFRequest.h"

@interface TFSalaryController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler,UIAlertViewDelegate>

@property (nonatomic, strong) WKWebView *webView;
@end

@implementation TFSalaryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"薪酬";
    [self setupWebview];
}

-(void)setupWebview{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //        config.preferences = [[WKPreferences alloc] init];
    //        config.preferences.minimumFontSize = 10;
    //        config.preferences.javaScriptEnabled = YES;
    //        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.userContentController = [[WKUserContentController alloc] init];
    //        config.processPool = [[WKProcessPool alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomM)
                                      configuration:config];
    
    
    [self.view insertSubview:self.webView atIndex:0];
    //记得实现对应协议,不然方法不会实现.
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate =self;
//    self.webView.scrollView.scrollEnabled = NO;
//    self.webView.layer.cornerRadius = 4;
//    self.webView.layer.masksToBounds = YES;
//    self.webView.scalesPageToFit = YES;
    self.webView.multipleTouchEnabled = YES;
   self.webView.userInteractionEnabled = YES;
    self.webView.scrollView.scrollEnabled = YES;
    self.webView.scrollView.bounces = YES;
    self.webView.scrollView.bouncesZoom = YES;
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"iosPostMessage"];
    
//    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5URL(salaryUrl)]]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cnknt.vicp.net:88/#/salary"]]];
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
    
    HQLog(@"======我来了=============%@",message.body);
    HQLog(@"我的名字====%@",message.name);
    //找到对应js端的方法名,获取messge.body
//    if ([message.name isEqualToString:@"iosPostMessage"]) {
//
//        HQMainQueue(^{
//
//            NSDictionary *dict = message.body;
//
//
//        });
//    }
}
#pragma mark - 监听    =====WKWebView代理相关
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSString *jsMeta = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,initial-scale=1',); document.getElementsByTagName('head')[0].appendChild(meta);"];
                        
    [self.webView evaluateJavaScript:jsMeta completionHandler:^(id _Nullable x, NSError * _Nullable error) {

    }];
    
    
    NSMutableDictionary *domain = [NSMutableDictionary dictionary];
    NSString *pic = [[NSUserDefaults standardUserDefaults] valueForKey:UserPictureDomain];
    if (pic) {
        [domain setObject:pic forKey:@"domain"];
    }
    if (UM.userLoginInfo.token) {
        [domain setObject:UM.userLoginInfo.token forKey:@"token"];
    }
    
    NSString * jsStri  =[NSString stringWithFormat:@"getValHtml(%@)",[HQHelper dictionaryToJson:domain]];

    [self.webView evaluateJavaScript:jsStri completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //此处可以打印error.

        NSLog(@"result:%@  error:%@",result,error);
    }];
    
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
