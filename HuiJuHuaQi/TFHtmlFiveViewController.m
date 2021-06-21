//
//  TFHtmlFiveViewController.m
//  HuiJuHuaQi
//
//  Created by daidan on 2020/10/12.
//  Copyright © 2020 com.huijuhuaqi.com. All rights reserved.
//

#import "TFHtmlFiveViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "TFScanCodeController.h"
#import "TFMapController.h"
#import "StyleDIY.h"
#import "HQHelpDetailCtrl.h"
#import "WXApiObject.h"
#import "WXApi.h"

@interface TFHtmlFiveViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler,UIAlertViewDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) TFMapController *locationVc;

@end

@implementation TFHtmlFiveViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self registerNote];
    [self setupWebview];
    [self clearCookie];
    [self loginSuccess];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postWebSocket:) name:@"WebSocketNotification" object:nil];
}

/** 清除缓存 */
- (void)clearCookie{
    
    WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];

    [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]

    completionHandler:^(NSArray * __nonnull records) {

        for (WKWebsiteDataRecord *record in records){
            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes forDataRecords:@[record] completionHandler:^{
                
                HQLog(@"++++++++++++Cookies for %@ deleted successfully+++++++++++++",record.displayName);
                
            }];
        }
   }];
}

/** 注册通知 */
- (void)registerNote{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:NotificationLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)becomeActive{
    
    // 已经登录
    if ([UM.userLoginInfo.isLogin isEqualToString:@"1"] && [AppDelegate shareAppDelegate].runStatus) {
        
        [AppDelegate shareAppDelegate].runStatus = nil;
        
        
        // 测试穿透
        [self loginSuccess];
        
    }
    
}


/** 登录成功 */
- (void)loginSuccess{
    
    // 测试穿透
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cnknt.vicp.net:1112/wdist/index.html#/"]]]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://app.teamface.cn/webview/app.html#/"]]]];

    
    // 外网
    if ([[AppDelegate shareAppDelegate].urlEnvironment isEqualToString:@"teamface"]) {
        HQLog(@"===============%@------------------",[NSString stringWithFormat:@"https://app.teamface.cn/webview/app.html#/"]);
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://app.teamface.cn/webview/app.html#/"]]]];
        
    }else{// 内网
        HQLog(@"===============%@------------------",[NSString stringWithFormat:@"%@/webview/app.html#/",[AppDelegate shareAppDelegate].baseUrl]);
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/webview/app.html",[AppDelegate shareAppDelegate].baseUrl]]]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


/** 初始化webview */
-(void)setupWebview{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //        config.preferences = [[WKPreferences alloc] init];
    //        config.preferences.minimumFontSize = 10;
    //        config.preferences.javaScriptEnabled = YES;
    //        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.userContentController = [[WKUserContentController alloc] init];
    //        config.processPool = [[WKProcessPool alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, TopM + StatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - TopM - StatusBarHeight)
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
    self.webView.scrollView.bouncesZoom = NO;
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"iosPostMessage"];
    
//    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/wdist/h5.html#/",[AppDelegate shareAppDelegate].baseUrl]]]];
    HQLog(@"===============%@==================",[NSString stringWithFormat:@"%@/wdist/h5.html#/",[AppDelegate shareAppDelegate].baseUrl]);
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
    if ([message.name isEqualToString:@"iosPostMessage"]) {
        
        NSDictionary *dict = message.body;
        NSString *type = [dict valueForKey:@"type"];
        
        if ([type isEqualToString:@"logout"]) {// 退出登录
            [self getLogoutScript];
        }else if ([type isEqualToString:@"scan"]){// 扫一扫
            [self getScanScript];
        }else if ([type isEqualToString:@"getLocation"]){// 获取定位
            [self getLocationScript];
        }else if ([type isEqualToString:@"openNewUrl"]){// 打开下级界面
            [self getOpenNewUrlScript:dict];
        }else if ([type isEqualToString:@"callPhone"]){// 打开电话
            [self getCallPhoneScript:dict];
        }else if ([type isEqualToString:@"back"]){// 返回上级界面
            [self getBackScript];
        }else if ([type isEqualToString:@"miniProgram"]){// 打开Teamface小程序
            [self getMiniProgram];
        }
        
    }
}

/** 打开Teamface小程序 */
- (void)getMiniProgram{
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = @"gh_ac5b7922fd24";//拉起的小程序的username
    launchMiniProgramReq.path = @"/pages/index/index";//拉起小程序页面的可带参路径，不填默认拉起小程序首页
    launchMiniProgramReq.miniProgramType = 0;//拉起小程序的类型
    [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
        
        HQLog(@"打开Teamface小程序");
    }];
}


/** 退出登录 */
- (void)getLogoutScript{
    
    [UM loginOutAction];
}

/** 扫一扫 */
- (void)getScanScript{
    
    TFScanCodeController *scan = [[TFScanCodeController alloc] init];
    scan.style = [StyleDIY weixinStyle];
    scan.isOpenInterestRect = YES;
    scan.libraryType = SLT_ZXing;
    scan.scanCodeType = SCT_QRCode;
    //镜头拉远拉近功能
    scan.isVideoZoom = YES;
    scan.isNeedScanImage = YES;
    scan.scanAction = ^(NSString *parameter) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (parameter) {
            [dict setObject:parameter forKey:@"code"];
        }
        [self postScanScript:dict];
        
    };
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:scan];
    navi.modalPresentationStyle = UIModalPresentationFullScreen;

    [self presentViewController:navi animated:YES completion:nil];
}


/** 获取定位 */
- (void)getLocationScript{
    kWEAKSELF
    TFMapController *locationVc = [[TFMapController alloc] initWithType:LocationTypeHideLocation];
    locationVc.type = LocationTypeHideLocation;
    locationVc.keyword = @"";
    locationVc.locationAction = ^(TFLocationModel *parameter){
        
        NSMutableDictionary *otherDict = [NSMutableDictionary dictionary];
        
        if (parameter.city) {
            [otherDict setObject:parameter.city forKey:@"city"];
        }
        if (parameter.name) {
            [otherDict setObject:parameter.name forKey:@"name"];
        }
        if (parameter.province) {
            [otherDict setObject:parameter.province forKey:@"province"];
        }
        if (parameter.district) {
            [otherDict setObject:parameter.district forKey:@"district"];
        }
        [otherDict setObject:@(parameter.longitude) forKey:@"longitude"];
        [otherDict setObject:@(parameter.latitude) forKey:@"latitude"];
        [otherDict setObject:[NSString stringWithFormat:@"%@#%@#%@",parameter.province,parameter.city,parameter.district] forKey:@"area"];
        
        NSString *totalAddress = [NSString stringWithFormat:@"%@%@%@%@",parameter.province,parameter.city,parameter.district,parameter.address];
        [otherDict setObject:totalAddress forKey:@"address"];
        
        // 传递定位信息
        [weakSelf postLocationScript:otherDict];
    };
    
    [self addChildViewController:locationVc];
}

/** 打开新界面 */
- (void)getOpenNewUrlScript:(NSDictionary *)dict{
    HQHelpDetailCtrl *view = [[HQHelpDetailCtrl alloc] init];
    view.htmlUrl = [dict valueForKey:@"url"];
    [self.navigationController pushViewController:view animated:YES];
}
/** 打开电话 */
- (void)getCallPhoneScript:(NSDictionary *)dict{
    
    NSString *tel = [dict valueForKey:@"phoneNumber"];
    
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",tel];
    
    UIWebView *callWebview = [[UIWebView alloc]init];
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
    [self.view addSubview:callWebview];
}

/** 返回上级界面 */
- (void)getBackScript{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 监听    =====WKWebView代理相关
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSString *jsMeta = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,initial-scale=1,minimum-scale=1.0, maximum-scale=1.0, user-scalable=no',); document.getElementsByTagName('head')[0].appendChild(meta);"];
                        
    [self.webView evaluateJavaScript:jsMeta completionHandler:^(id _Nullable x, NSError * _Nullable error) {

    }];
    
    // 执行登录传值
    [self postLoginScript];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:PushNotificationData];
    
    if (str && ![str isEqualToString:@""]) {
        
        NSMutableDictionary *domain = [NSMutableDictionary dictionary];
        NSString *pic = [[NSUserDefaults standardUserDefaults] valueForKey:UserPictureDomain];
        if (pic) {
            [domain setObject:pic forKey:@"domain"];
        }
        if (UM.userLoginInfo.token) {
            [domain setObject:@"jumpPage" forKey:@"type"];
        }
        NSDictionary *obj = [HQHelper dictionaryWithJsonString:str];
        if (obj) {
            [domain setObject:obj forKey:@"html"];
        }
        NSString *jsonStr = [HQHelper dictionaryToJson:domain];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self handleJavaScript:jsonStr];
        });
    }
}

/** 执行登录传值 */
- (void)postLoginScript{
    
    NSMutableDictionary *domain = [NSMutableDictionary dictionary];
    NSString *pic = [[NSUserDefaults standardUserDefaults] valueForKey:UserPictureDomain];
    if (pic) {
        [domain setObject:pic forKey:@"domain"];
    }
    if (UM.userLoginInfo.token) {
        [domain setObject:UM.userLoginInfo.token forKey:@"token"];
        [domain setObject:@"login" forKey:@"type"];
    }

    NSString * jsStri  =[NSString stringWithFormat:@"getValHtml(%@)",[HQHelper dictionaryToJson:domain]];

    [self.webView evaluateJavaScript:jsStri completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //此处可以打印error.

        NSLog(@"result:%@  error:%@",result,error);
    }];
}


/** 执行扫一扫传值 */
- (void)postScanScript:(NSDictionary *)dict{
    
    NSMutableDictionary *domain = [NSMutableDictionary dictionary];
    NSString *pic = [[NSUserDefaults standardUserDefaults] valueForKey:UserPictureDomain];
    if (pic) {
        [domain setObject:pic forKey:@"domain"];
    }
    if (UM.userLoginInfo.token) {
        [domain setObject:@"scan" forKey:@"type"];
    }
    if (dict) {
        [domain setObject:dict forKey:@"html"];
    }

    NSString * jsStri  =[NSString stringWithFormat:@"getValHtml(%@)",[HQHelper dictionaryToJson:domain]];

    [self.webView evaluateJavaScript:jsStri completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //此处可以打印error.

        NSLog(@"result:%@  error:%@",result,error);
    }];
}

/** 执行获取定位传值 */
- (void)postLocationScript:(NSDictionary *)dict{
    
    NSMutableDictionary *domain = [NSMutableDictionary dictionary];
    NSString *pic = [[NSUserDefaults standardUserDefaults] valueForKey:UserPictureDomain];
    if (pic) {
        [domain setObject:pic forKey:@"domain"];
    }
    if (UM.userLoginInfo.token) {
        [domain setObject:@"getLocation" forKey:@"type"];
    }
    if (dict) {
        [domain setObject:dict forKey:@"html"];
    }
    
    NSString * jsStri  =[NSString stringWithFormat:@"getValHtml(%@)",[HQHelper dictionaryToJson:domain]];

    [self.webView evaluateJavaScript:jsStri completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //此处可以打印error.

        NSLog(@"result:%@  error:%@",result,error);
    }];
}

/** 推送传值 */
- (void)postWebSocket:(NSNotification *)noti{
    
    NSMutableDictionary *domain = [NSMutableDictionary dictionary];
    NSString *pic = [[NSUserDefaults standardUserDefaults] valueForKey:UserPictureDomain];
    if (pic) {
        [domain setObject:pic forKey:@"domain"];
    }
    
    long long sp2 = [HQHelper getNowTimeSp];
    long long sp1 = [[[NSUserDefaults standardUserDefaults] objectForKey:EnterForegroundNowTime] longLongValue];
    if (sp2 - sp1 < 2000) {// 毫秒，后台刚进入前台
        if (UM.userLoginInfo.token) {
            [domain setObject:@"jumpPage" forKey:@"type"];
        }
    }else{// 一直在前台（很早就进入了）
        if (UM.userLoginInfo.token) {
            [domain setObject:@"webSocket" forKey:@"type"];
        }
    }
    
    if (noti) {
        [domain setObject:noti.object forKey:@"html"];
    }
    NSString *jsonStr = [HQHelper dictionaryToJson:domain];
    
    [self handleJavaScript:jsonStr];
    
}

/** 执行jsStri */
- (void)handleJavaScript:(NSString *)jsonStr{
    
    NSString * jsStri  =[NSString stringWithFormat:@"getValHtml(%@)",jsonStr];
    
    [self.webView evaluateJavaScript:jsStri completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //此处可以打印error.
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:PushNotificationData];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        HQLog(@"result:%@  error:%@",result,error);
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
