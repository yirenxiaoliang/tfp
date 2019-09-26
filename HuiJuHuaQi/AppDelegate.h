//
//  AppDelegate.h
//  HuiJuHuaQi
//  11
//  Created by apple on 15/12/22.
//  Copyright © 2015年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "HQBaseTabBarViewController.h"
#import "TFCompanyCircleController.h"
#if kUseScreenShotGesture
#import "ScreenShotView.h"
#endif

/** 极光宏 */
//#define JMESSAGE_APPKEY @"cf224eb57dede16976d8d72b" // 华企秘书
#define JMESSAGE_APPKEY @"16d95c5556bcde11277431dc" // TeamFace

#define CHANNEL @"Publish channel"
#define kBADGE @"badge"
#if DEBUG
static BOOL isProduction = NO;
#else
static BOOL isProduction = YES;
#endif

#define SaveInputUrlRecordKey @"SaveInputUrlRecordKey"// 当前选择或输入记录URL
#define SaveUrlRecordKey @"SaveUrlRecordKey"// 输入记录数组
#define SaveIPAddressKey @"SaveIPAddressKey"// 登录成功后的IP
#define SaveServerAddressKey @"SaveServerAddressKey"// 登录成功后的Server
#define SaveIMAddressKey @"SaveIMAddressKey"// 登录成功后的IM
#define SaveEnvironmentAddressKey @"SaveEnvironmentAddressKey"// 登录成功后的Environment

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HQBaseTabBarViewController *tabCtrl;
/** 同事圈控制器 */
@property (nonatomic, strong) TFCompanyCircleController *circleCtrl;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#if kUseScreenShotGesture
@property (nonatomic, strong) ScreenShotView *screenshotView;
#endif

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (AppDelegate* )shareAppDelegate;

/** 接口IP地址 */
@property (nonatomic, copy) NSString *baseUrl;
/** 服务器地址 */
@property (nonatomic, copy) NSString *serverAddress;
/** IM地址 */
@property (nonatomic, copy) NSString *iMAddress;
/** 环境 */
@property (nonatomic, copy) NSString *urlEnvironment;
/** 重置URL */
-(void)resetUrlData;


@end

