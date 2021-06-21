 //
//  AppDelegate.m
//  HuiJuHuaQi
//  11
//  Created by apple on 15/12/22.
//  Copyright  © 2015年 com.huijuhuaqi.com. All rights reserved.
//  做事之前先在脑子里预演

#import "AppDelegate.h"
#import "HQUserGuideView.h"
#import "IQKeyboardManager.h"
#import "AlertView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AdSupport/AdSupport.h>
#import "SDImageCache.h"

#import "HQTabBar.h"
#import "UITabBar+RedPoint.h"
#import "HQUserManager.h"
#import "HQBaseNavigationController.h"
/** JMessage 头文件 */
#import "JCHATFileManager.h"
#import "TFLoginBL.h"


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <Bugly/Bugly.h>

#import "HQTFLoginMainController.h"
#import "TFNewLoginController.h"

#import "JSHAREService.h"
#import "TFSocketManager.h"
#import "FileManager.h"
#import "TFChatBL.h"
#import "TFChatInfoListModel.h"
#import "TFRequest.h"
#import "FPSDisplay.h"
#import "TFHtmlFiveViewController.h"
#import "WXApi.h"

@interface AppDelegate () < HQBLDelegate, UIDocumentInteractionControllerDelegate,BuglyDelegate,WXApiDelegate>


@property (nonatomic, strong) NSDate *lastPlaySoundDate;   //记录上次响铃的声音

@property (nonatomic, assign) long long startTimeSp;  //点击通知栏启动应用时记录时间，5S内收到环信消息不弹窗

/** TFLoginBL */
@property (nonatomic, strong) TFLoginBL *loginBL;

@property (nonatomic, strong) TFSocketManager *socket;
@property (nonatomic, strong) TFChatBL *chatBL;

@end


@implementation AppDelegate
-(TFLoginBL *)loginBL{
    if (_loginBL == nil) {
        self.loginBL = [TFLoginBL build];
        self.loginBL.delegate = self;
    }
    return _loginBL;
}
-(TFChatBL *)chatBL{
    if (_chatBL == nil) {
        self.chatBL = [TFChatBL build];
        self.chatBL.delegate = self;
    }
    return _chatBL;
}

-(TFCompanyCircleController *)circleCtrl{
    if (!_circleCtrl) {
        _circleCtrl = [[TFCompanyCircleController alloc] init];
    }
    return _circleCtrl;
}

/** 重置URL */
-(void)resetUrlData{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *key = [userDefault valueForKey:SaveIPAddressKey];
    if (IsStrEmpty(key)) {// 空值，默认为外网
        NSString *url = [userDefault valueForKey:SaveInputUrlRecordKey];
        if (IsStrEmpty(url)) {
            self.baseUrl = baseUrl;
            self.serverAddress = serverAddress;
            self.iMAddress = imServerAddress;
            self.urlEnvironment = environment;
        }else{
            self.baseUrl = url;
            self.serverAddress = serverAddress;
            self.urlEnvironment = environmentInput;
        }
    }else{
        self.baseUrl = key;
        self.serverAddress = [userDefault valueForKey:SaveServerAddressKey];
        self.iMAddress = [userDefault valueForKey:SaveIMAddressKey];
        self.urlEnvironment = [userDefault valueForKey:SaveEnvironmentAddressKey];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // test first git
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) { //iOS8
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else { // iOS7
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeNewsstandContentAvailability | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert];
    }
    
    
    // 截屏View（用于右滑返回）
//#if kUseScreenShotGesture
//    self.screenshotView = [[ScreenShotView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
//    [self.window insertSubview:self.screenshotView atIndex:0];
//    self.screenshotView.hidden = YES;
//#endif
    [self.window makeKeyAndVisible];
    
//    HQGlobalQueue(^{
        // 录音
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        //高德地图
//        [AMapServices sharedServices].apiKey = AMapKey;
        //键盘
//        IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//        manager.enable = YES;
//        manager.shouldResignOnTouchOutside = YES;
//        manager.shouldToolbarUsesTextFieldTintColor = YES;
//        manager.enableAutoToolbar = NO;
        // 图片缓存
//        [SDImageCache sharedImageCache].maxCacheSize = 1024*1024*8;
//    });
    
    /** 监听登录、退出通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:NotificationLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess) name:NotificationLogoutSuccess object:nil];
    /** 公司组织架构变化通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(companyFrameworkChange) name:CompanyFrameworkChange object:nil];
    
    
//    HQGlobalQueue(^{
//        
//        [DataBaseHandle creatwChatRoomWithData]; //聊天室数据库
//        [DataBaseHandle createChatListWithData]; //会话列表数据库
//        [DataBaseHandle createAssistantListTable]; //会话列表小助手数据库
//        [DataBaseHandle createSubAssistantDataListTable]; //小助手列表数据库
//        TFFMDBModel *model = [[TFFMDBModel alloc] init];
//        
//        [DataBaseHandle createCallWithData:model];
//    });
    
    // 控制器根控制器
    [self loginSuccess:nil];
    
    
    // 分享
//    HQGlobalQueue(^{

        // Bugly
//        [self setupBugly];
        // 分享
//        [self setupShare];
//    });
    
    
    // 错误打印
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    // 创建文件夹,用于存放缓存数据文件
    [FileManager createDir:[FileManager dirCache] DirStr:@"HomeDataCache"];
    HQLog(@"沙盒路径:%@", NSHomeDirectory());
//#ifdef DEBUG
//#if ShowNameOfController
//    [FPSDisplay shareFPSDisplay];
//#endif
//#endif
    
    self.runStatus = @1;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // 根据远程通知通过UIApplicationLaunchOptionsRemoteNotificationKey打开的情况来进行
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        
        //app关闭时，收到推送
        NSString *jsonStr = [HQHelper dictionaryToJson:launchOptions[@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
        [[NSUserDefaults standardUserDefaults] setObject:jsonStr forKey:PushNotificationData];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    }
    
//    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
//        NSLog(@"WeChatSDK: %@", log);
//    }];

    // 向微信注册ID
    [WXApi registerApp:WXAppId universalLink:@"https://file.teamface.cn"];
    
//    [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
//        NSLog(@"%@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion);
//    }];
    return YES;
}


/** 闪退等错误打印 */
void uncaughtExceptionHandler(NSException *exception) {
    
    //打印错误信息：
    HQLog(@"exception:@%@ \n call stack info :@%@", exception, [exception callStackSymbols]);
}

- (void)setupShare{
    JSHARELaunchConfig *config = [[JSHARELaunchConfig alloc] init];
    config.appKey = @"16d95c5556bcde11277431dc";
    config.WeChatAppId = WXAppId;
    config.WeChatAppSecret = WXAppSecret;
    [JSHAREService setupWithConfig:config];
    [JSHAREService setDebug:NO];
}

#pragma mark - 初始化Bugly
- (void)setupBugly {
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
    #if DEBUG
    config.debugMode = YES;
    #endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    //    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = YES;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    config.delegate = self;
    
    config.consolelogEnable = NO;
    config.viewControllerTrackingEnable = NO;
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User:@%@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
}

#pragma mark - BuglyDelegate
- (NSString *)attachmentForException:(NSException *)exception {
    HQLog(@"(%@:%d) %s %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__,exception);
    
    return @"This is an attachment";
}

/** 登录成功 */
- (void)loginSuccess:(NSNotification *)note{
    
    if (!self.htmlFiveNaviCtrl) {
        TFHtmlFiveViewController *htmlFiveCtrl = [[TFHtmlFiveViewController alloc] init];
        TFHtmlFiveNavigationController *htmlFiveNaviCtrl = [[TFHtmlFiveNavigationController alloc] initWithRootViewController:htmlFiveCtrl];
        self.window.rootViewController  = htmlFiveNaviCtrl;
        self.htmlFiveNaviCtrl = htmlFiveNaviCtrl;
    }else{
        [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
        self.window.rootViewController  = self.htmlFiveNaviCtrl;
    }
    
    
//    if (!self.tabCtrl) {
//        HQBaseTabBarViewController *tabCtrl = [[HQBaseTabBarViewController alloc] init];
//        self.window.rootViewController  = tabCtrl;
//        self.tabCtrl = tabCtrl;
//
//    }else{
//        // 根控制器
//        [self appPopToRootCtrlWithAnimated:NO];
//        self.tabCtrl.selectedIndex = 0;
//        self.window.rootViewController  = self.tabCtrl;
//    }

    if (note.object) {
        
//        self.socket = [TFSocketManager sharedInstance];
//        [self.socket socketClose];// 关闭（一切置为起点）
//        [self.socket socketOpenIsReconnect:NO];//打开soket
        
        // 登录成功了才保存访问IP
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setValue:self.baseUrl forKey:SaveIPAddressKey];
        [userDefault setValue:self.serverAddress forKey:SaveServerAddressKey];
        [userDefault setValue:self.urlEnvironment forKey:SaveEnvironmentAddressKey];
        [userDefault removeObjectForKey:SaveInputUrlRecordKey];
        [userDefault synchronize];
        
        [self.loginBL requestUploadDeviceToken];
//        [self.chatBL requestGetChatListInfoData];
    }

}
/** 退出登陆成功 */
- (void)logoutSuccess{
    
    HQTFLoginMainController *TF = [[HQTFLoginMainController alloc] init];
//    TFNewLoginController *TF = [[TFNewLoginController alloc] init];
    HQBaseNavigationController *navi = [[HQBaseNavigationController alloc] initWithRootViewController:TF];
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.window.rootViewController presentViewController:navi animated:NO completion:nil];
    
}
/** 公司组织架构变化 */
-(void)companyFrameworkChange{
    
    if (UM.userLoginInfo.token) {
        [self.loginBL requestEmployeeList];
    }
}

#pragma mark - 从其它应用跳转过来的
- (BOOL)application:(UIApplication *)application
  continueUserActivity:(NSUserActivity *)userActivity
   restorationHandler:(nonnull void (^)  (NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    
    return [WXApi handleOpenUniversalLink:userActivity
                             delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    NSString *urlStr = url.absoluteString;
    //wiget 传递数据
    if ([urlStr isEqualToString:@"TeamFaceWidgetOne://"]) {
        
        self.tabCtrl.selectedIndex = 1;
        
        [self performSelector:@selector(delayDidWiget) withObject:self afterDelay:0.5];
        
    }else{ // 其他APP（如QQ、微信等第三方授权

        return [WXApi handleOpenURL:url delegate:self];
    }
    
//    if(0) {
//
//        //        其他APP（如QQ、微信等
//        if (url.absoluteString.length > 0) {
//
//            // 由其他APP发过来的文件
//            UIDocumentInteractionController *ctrl = [UIDocumentInteractionController  interactionControllerWithURL:url];
//            ctrl.delegate = self;
//            [ctrl presentPreviewAnimated:YES];
//        }
//    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *urlStr = url.absoluteString;
    //wiget 传递数据
    if ([urlStr isEqualToString:@"TeamFaceWidgetOne://"]) {
        
        self.tabCtrl.selectedIndex = 1;
        
        [self performSelector:@selector(delayDidWiget) withObject:self afterDelay:0.5];
        
    }else{ // 其他APP（如QQ、微信等第三方授权
        
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    NSString *urlStr = url.absoluteString;
    //wiget 传递数据
    if ([urlStr isEqualToString:@"TeamFaceWidgetOne://"]) {
        
        self.tabCtrl.selectedIndex = 1;
        
        [self performSelector:@selector(delayDidWiget) withObject:self afterDelay:0.5];
        
    }else{ // 其他APP（如QQ、微信等第三方授权
        
        return [WXApi handleOpenURL:url delegate:self];
//        [JSHAREService handleOpenUrl:url];
    }
    
    return YES;
}

//-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler NS_AVAILABLE_IOS(8_0); {
//
//        // Demo处理Universallink的示例代码
//        if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
//
////             NSURL *url = userActivity.webpageURL;
//             
//        }
//        return YES;
//}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    HQLog(@"deviceToken:%@",deviceToken);
    // dc2883f9587b10a637cedce1ea9becd2848d1fc45d5dad07c923a4538a546c11
    // 95bd9d9a9588e0ddfee67b78689cb14a1f1988faa97dce912faf2c2da9eddf76
    
//    NSString *str = [[deviceToken description] stringByReplacingOccurrencesOfString:@" " withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
    if (!deviceToken || ![deviceToken isKindOfClass:[NSData class]] || deviceToken.length==0) {
            return;
        }
    NSString *(^getDeviceToken)(void) = ^() {
        if (IOS13_AND_LATER) {
            const unsigned char *dataBuffer = (const unsigned char *)deviceToken.bytes;
            NSMutableString *myToken  = [NSMutableString stringWithCapacity:(deviceToken.length * 2)];
            for (int i = 0; i < deviceToken.length; i++) {
                [myToken appendFormat:@"%02x", dataBuffer[i]];
            }
            return (NSString *)[myToken copy];
        } else {
            NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
            NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:characterSet];
            return [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
    };
    NSString *myToken = getDeviceToken();
    HQLog(@"deviceToken=====%@", myToken);

    [[NSUserDefaults standardUserDefaults] setObject:myToken forKey:DeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    UITextView *view = [[UITextView alloc] initWithFrame:(CGRect){0,20,SCREEN_WIDTH,90}];
//    view.text = myToken;
//    [KeyWindow addSubview:view];
    
}


// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    HQLog(@"deviceTokenError:%@",error);
    
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 处理推送消息
    
    HQLog(@"iOS6及以下系统，收到通知:%@", userInfo);
    
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    HQLog(@"iOS7及以上系统，收到通知:%@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WebSocketNotification" object:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    HQLog(@"iOS10及以上系统，收到通知:%@", response.notification);
    
    NSString *userAction = response.actionIdentifier;
   // 点击通知打开
   if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
       HQLog(@"User opened the notification.");
       // 处理iOS 10通知，并上报通知打开回执
       
       UNNotification *notification = response.notification;
       UNNotificationRequest *request = notification.request;
       UNNotificationContent *content = request.content;
       NSDictionary *userInfo = content.userInfo;
       [[NSNotificationCenter defaultCenter] postNotificationName:@"WebSocketNotification" object:userInfo];
   }
    
}
/**
 *  App处于前台时收到通知(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    HQLog(@"Receive a notification in foregound.");
    
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WebSocketNotification" object:userInfo];
    
    // 通知不弹出
    completionHandler(UNNotificationPresentationOptionNone);
}

/** 点击通知返回APP */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    HQLog(@"收到通知");
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
//    [self.socket socketClose];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


// App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate:@when the user quits.
    
//    [self.socket socketClose];
    
//    [self resetApplicationBadge];
}

- (void)resetApplicationBadge {
    HQLog(@"Action - resetApplicationBadge");
    
    if ([UM.userLoginInfo.isLogin isEqualToString:@"1"]) {
        
        NSInteger badge = [[[NSUserDefaults standardUserDefaults] objectForKey:kBADGE] integerValue];
        if (badge > 99) {
            badge = 99;
        }
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
    }else{
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    
    
}
// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
//    [application cancelAllLocalNotifications];
//    [application setApplicationIconBadgeNumber:0];
    long long sp = [HQHelper getNowTimeSp];
    [[NSUserDefaults standardUserDefaults] setObject:@(sp) forKey:EnterForegroundNowTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // 重置URL
    [self resetUrlData];
    
    if (UM.userLoginInfo == nil) {
        UM.userLoginInfo = [[CDM fetchCurrentEmployeeData] firstObject];
    }
    
    if (![UM.userLoginInfo.isLogin isEqualToString:@"1"]) {
        
        [self logoutSuccess];
        
    }else{
        
//        self.socket = [TFSocketManager sharedInstance];
//        [self.socket socketOpenIsReconnect:NO];//打开soket
//        [self.chatBL requestGetChatListInfoData];
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];
    });
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_uploadDeviceToken) {
        
        HQLog(@"uploadDeviceToken success!");
    }
    if (resp.cmdId == HQCMD_getChatListInfo) {
        
        /** 角标未读数 */
        NSInteger numbers = 0;
        for (TFChatInfoListModel *fm in resp.body) {
            
            numbers += [fm.unread_nums integerValue];
        }
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:numbers];
        
        if (numbers > 99) {
            
            numbers = 99;
        }
        
        if (numbers > 0) {
            
            UITabBarItem * itemBadges = [self.tabCtrl.tabBar.items objectAtIndex:1];
            itemBadges.badgeValue=[NSString stringWithFormat:@"%ld",(long)numbers];
            
        }else{
            UITabBarItem * itemBadges = [self.tabCtrl.tabBar.items objectAtIndex:1];
            itemBadges.badgeValue=nil;
        }
        
    }
}

// 申请处理时间
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    [self saveContext];
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDImageCache sharedImageCache] clearMemory];
    
    [[SDWebImageManager sharedManager] cancelAll];
}




- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self.window.rootViewController;
}

//可选的2个代理方法 （主要是调整预览视图弹出时候的动画效果，如果不实现，视图从底部推出）
- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
{
    return self.window.rootViewController.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    return self.window.rootViewController.view.frame;
}




- (void)delayDidWiget
{
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.HuiJuHuaQi.TeamFace"];
    
    NSDictionary *dic = [shared objectForKey:@"callback"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadJumpVC" object:dic userInfo:nil];
}



#pragma mark - Application's Documents directory
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    
    NSURL *url=[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                       inDomains:NSUserDomainMask] lastObject];
    HQLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    return url;
}


/**  保留一个弹框 */
- (void)windowSubviewsSaveOne{
    
    for (UIView *view in self.window.subviews) {// 删除子控件
        
        if ([view isKindOfClass:[AlertView class]]) {// 只出现一个弹框
            [view removeFromSuperview];
        }
    }
    
}




/**
 *  回到根视图
 */
- (void)appPopToRootCtrlWithAnimated:(BOOL)animated
{
    for (UINavigationController *navCtrl in self.tabCtrl.childViewControllers) {
        if (navCtrl.viewControllers.count > 1) {
            [navCtrl popToRootViewControllerAnimated:NO];
        }
    }
    
    [self.tabCtrl dismissViewControllerAnimated:NO completion:nil];
}



//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        
        result = nextResponder;
    } else{
        
        result = window.rootViewController;
    }

    return result;
}



//弹出对应模态视图
- (void)appPresentedCtrl:(UIViewController *)viewCtrl
{
    if (self.tabCtrl.presentedViewController) {
        [self.tabCtrl.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    UIViewController *viewVC = [self getCurrentVC];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewCtrl];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [viewVC presentViewController:nav animated:YES completion:nil];
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            HQLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        else
            HQLog(@"数据成功插入");
    }
}


#pragma mark - Core Data stack
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HuiJuHuaQi" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}



// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    //链接数据库，备数据存储
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HuiJuHuaQi.sqlite"];
    HQLog(@"%@",storeURL);
    
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption, nil];
    //持久化存储调度器由托管对象模型初始化
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    //设置数据存储方式为SQLITE
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:options
                                                           error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        HQLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

+ (AppDelegate* )shareAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}


@end
