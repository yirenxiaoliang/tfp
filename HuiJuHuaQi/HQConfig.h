//
//  HQConfig.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/11.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#ifndef HQConfig_h
#define HQConfig_h

/**************    App地址   ***************/

//* 开发环境 
//#define TestFlag11

//* 180服务器
//#define TestFlag0

//* 181服务器
//#define TestFlag1

//* 183服务器
//#define TestFlag3

/* 186服务器 */
//#define TestFlag2

/** 曹建华 */
//#define TestFlag5

/** 莫帆 */
//#define TestFlag6

/** 徐兵 */
//#define TestFlag8

/** 张工 */
//#define TestFlag9

/** 罗军 */
//#define TestFlag10

/** 正式环境（外网） */
//#define DisFlag

/** Are you want to show name of controller ? */
#define repositoryLibrariesHidden 1
#define ShowNameOfController 0
#define CurrentTime @"2020-10-22 15:00"

/************************     接口头部    ***********************/

//开发环境
#ifdef TestFlag11

#define kEnvironment      @"9"
#define kBaseAPI      @"http://192.168.1.9:8090/"
#define ServerAdress  @"custom-gateway"
#define KIMServerAdress  [NSURL URLWithString:@"wss://192.168.1.168:9002"]
#define webViewDetailURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailDetail"]
#define webViewEditURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailEdit"]
#define CustomTable @"https://page.teamface.cn/#/tables"
#define CustomChart @"https://page.teamface.cn/#/echarts"

#endif


// 180服务器
#ifdef TestFlag0

#define kEnvironment      @"180"
#define kBaseAPI      @"http://192.168.1.180:8080/"
#define ServerAdress  @"custom-gateway"
#define KIMServerAdress  [NSURL URLWithString:@"wss://192.168.1.188:9003"]
#define webViewDetailURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailDetail"]
#define webViewEditURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailEdit"]
#define CustomTable @"https://page.teamface.cn/#/tables"
#define CustomChart @"https://page.teamface.cn/#/echarts"

#endif


// 181服务器
#ifdef TestFlag1

#define kEnvironment      @"181"
//#define kBaseAPI      @"http://192.168.1.181:8080/"
//#define ServerAdress  @"custom-gateway"
#define kBaseAPI      @"http://192.168.1.181:8093/"
#define ServerAdress  @"custom-gateway(New)"
#define KIMServerAdress  [NSURL URLWithString:@"wss://192.168.1.188:9004"]
#define webViewDetailURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailDetail"]
#define webViewEditURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailEdit"]
#define CustomTable @"https://page.teamface.cn/#/tables"
#define CustomChart @"https://page.teamface.cn/#/echarts"
//#define CustomChart @"http:192.168.1.145:8080/#/echarts"

#endif

// 183服务器
#ifdef TestFlag3

#define kEnvironment      @"183"
#define kBaseAPI      @"http://192.168.1.183:8081/"
#define ServerAdress  @"custom-gateway"
#define KIMServerAdress  [NSURL URLWithString:@"wss://192.168.1.188:9006"]
#define webViewDetailURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailDetail"]
#define webViewEditURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailEdit"]
#define CustomTable @"https://page.teamface.cn/#/tables"
#define CustomChart @"https://page.teamface.cn/#/echarts"

#endif

// 186服务器
#ifdef TestFlag2

#define kEnvironment      @"186"
#define kBaseAPI      @"http://192.168.1.186:8081/"
#define ServerAdress  @"custom-gateway"
#define KIMServerAdress  [NSURL URLWithString:@"wss://192.168.1.188:9005"]
//#define KIMServerAdress  [NSURL URLWithString:@"wss://push.teamface.cn"]
#define webViewDetailURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailDetail"]
#define webViewEditURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailEdit"]
#define CustomTable @"https://page.teamface.cn/#/tables"
#define CustomChart @"https://page.teamface.cn/#/echarts"

#endif


//曹建华本机
#ifdef TestFlag5

#define kEnvironment      @"202"
#define kBaseAPI      @"http://192.168.1.202:8080/"
#define ServerAdress  @"custom-gateway"
#define KIMServerAdress  [NSURL URLWithString:@"wss://192.168.1.188:9006"]
#define webViewDetailURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailDetail"]
#define webViewEditURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailEdit"]
#define CustomTable @"https://page.teamface.cn/#/tables"
#define CustomChart @"https://page.teamface.cn/#/echarts"

#endif


//莫帆本机
#ifdef TestFlag6

#define kEnvironment      @"58"
#define kBaseAPI      @"http://192.168.1.58:8281/"
#define ServerAdress  @"custom-gateway"
#define KIMServerAdress  [NSURL URLWithString:@"wss://192.168.1.168:9002"]
#define webViewDetailURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailDetail"]
#define webViewEditURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailEdit"]
#define CustomTable @"https://page.teamface.cn/#/tables"
#define CustomChart @"https://page.teamface.cn/#/echarts"

#endif


//张工本机
#ifdef TestFlag9

#define kEnvironment      @"172"
#define kBaseAPI      @"http://192.168.1.172:8080/"
#define ServerAdress  @"custom-gateway"
#define KIMServerAdress  [NSURL URLWithString:@"wss://192.168.1.168:9002"]
#define webViewDetailURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailDetail"]
#define webViewEditURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailEdit"]
#define CustomTable @"https://page.teamface.cn/#/tables"
#define CustomChart @"https://page.teamface.cn/#/echarts"

#endif


// 徐兵
#ifdef TestFlag8

#define kEnvironment      @"57"
#define kBaseAPI      @"http://192.168.1.57:8080/"
#define ServerAdress  @"custom-gateway"
#define KIMServerAdress  [NSURL URLWithString:@"wss://192.168.1.188:9006"]
#define webViewDetailURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailDetail"]
#define webViewEditURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailEdit"]
#define CustomTable @"https://page.teamface.cn/#/tables"
#define CustomChart @"https://page.teamface.cn/#/echarts"

#endif

// 罗军
#ifdef TestFlag10

#define kEnvironment      @"60"
#define kBaseAPI      @"http://192.168.1.60:8093/"
#define ServerAdress  @"custom-gateway(New)"
#define KIMServerAdress  [NSURL URLWithString:@"wss://192.168.1.168:9006"]
#define webViewDetailURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailDetail"]
#define webViewEditURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailEdit"]
#define CustomTable @"https://page.teamface.cn/#/tables"
#define CustomChart @"https://page.teamface.cn/#/echarts"

#endif


//正式环境
#ifdef DisFlag

#define kEnvironment      @"teamface"
#define kBaseAPI      @"https://file.teamface.cn/"
#define ServerAdress  @"custom-gateway"
#define KIMServerAdress  [NSURL URLWithString:@"wss://push.teamface.cn"]
#define webViewDetailURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailDetail"]
#define webViewEditURL [NSURL URLWithString:@"https://page.teamface.cn/#/emailEdit"]
#define CustomTable @"https://page.teamface.cn/#/tables"
#define CustomChart @"https://page.teamface.cn/#/echarts"

#endif


/**
 kUseScreenShotGesture为截图返回效果   0为关闭，1为打开
 （针对整个APP全局的）
 */
#pragma mark -------------------截图返回手势
#define kUseScreenShotGesture  0

//接口
#define kServerAddress [[NSUserDefaults standardUserDefaults] valueForKey:UserPictureDomain]?:[NSString stringWithFormat:@"%@%@",[AppDelegate shareAppDelegate].baseUrl,[AppDelegate shareAppDelegate].serverAddress]
//网络是否可达 监测地址
#define kNetMonitorAddress @"http://www.baidu.com"

/** App Store中应用的ID */
#define STORE_APPID @"1191390720"

/** 私钥 **/
#define Privatekey @"teamface2019team"  // TeamFace

#define CurrentKey [NSString stringWithFormat:@"Key%@%@%@",[AppDelegate shareAppDelegate].urlEnvironment,[UM.userLoginInfo.company.id description],[UM.userLoginInfo.employee.id description]]

/**************************    第三方key    **********************/
/**友盟分享APPKey**/
#define UmengAppkey @"5865b37582b63550140005a5"  // TeamFace

/**百度地图APPKey**/
#define BaiDuMapAppKey @"OX1DgGHI3kncAuUFryGXwGIiGWqN7WG2" // TeamFace

/** 高德地图 */
#define AMapKey @"91786defed1816b5f0dd096672731ff8"
//#define AMapKey @"803d22acd84afb9c096027bc09ee8886"

/** QQ */
//#define QQAppkey @"sj0l55afKP1ISPat"  // TeamFace
//#define QQAppId @"1105503846"  // TeamFace

/** WeChat */
#define WXAppSecret @"4468ea996f8d8ba440e5eb5938e82af7"  // TeamFace
#define WXAppId @"wx3b6eafad547be6b1"   // TeamFace

/** Bugly */
#define BUGLY_APP_ID @"c4f96a545b"

/** 分享回调 */
#define UMShareBackAddress @"http://hqmscloud.com"

#pragma mark +++++++++++++++++++++++++++ 企信 +++++++++++++++++++++++++++

//设备类型
#define iOSDevice 2

//单聊
#define singleChat 5
//群聊
#define groupChat 6

#define DeviceToken @"iOSPushDeviceToken"
//消息类型

#define ChatTypeWithText @1
#define ChatTypeWithImage @2
#define ChatTypeWithVoice @3
#define ChatTypeWithDocuments @4
#define ChatTypeWithVideo @5
#define ChatTypeWithTip @7

#endif /* HQConfig_h */



