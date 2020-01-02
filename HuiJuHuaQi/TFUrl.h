//
//  TFUrl.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#ifndef TFUrl_h
#define TFUrl_h

/** 外网 */
static NSString *baseUrl = @"https://file.teamface.cn";
/** 外网环境 */
static NSString *environment = @"teamface";

/** 181 */
static NSString *baseUrl181 = @"http://192.168.1.181:8093";
/** 181环境 */
static NSString *environment181 = @"181";

/** 183 */
static NSString *baseUrl183 = @"http://192.168.1.183:8081";
/** 183环境 */
static NSString *environment183 = @"183";

/** 186 */
static NSString *baseUrl186 = @"http://192.168.1.186:8081";
/** 186环境 */
static NSString *environment186 = @"186";

/** 曹建华 */
static NSString *baseUrl202 = @"http://192.168.1.202:8080";
/** 202环境 */
static NSString *environment202 = @"202";

/** 张志华 */
static NSString *baseUrl172 = @"http://192.168.1.172:8080";
/** 172环境 */
static NSString *environment172 = @"172";

/** 徐冰 */
static NSString *baseUrl57 = @"http://192.168.1.57:8080";
/** 57环境 */
static NSString *environment57 = @"57";

/** 罗军 */
static NSString *baseUrl60 = @"http://192.168.1.60:8083";
/** 60环境 */
static NSString *environment60 = @"60";

/** 输入的环境 */
static NSString *environmentInput = @"1111";

/** 服务器地址 */
static NSString *serverAddress = @"/custom-gateway";
/** 服务器地址(new) */
static NSString *serverAddressNew = @"/custom-gateway";

/** IM地址 */
static NSString *imServerAddress = @"wss://push.teamface.cn";
/** IM地址9002 */
static NSString *imServerAddress9002 = @"wss://192.168.1.168:9002";
/** IM地址9005 */
static NSString *imServerAddress9005 = @"wss://192.168.1.168:9005";
/** IM地址9006 */
static NSString *imServerAddress9006 = @"wss://192.168.1.168:9006";

/** H5Header */
static NSString *H5Header = @"https://page.teamface.cn";

/** 编辑器详情 */
//static NSString *editorDetailURL = @"https://page.teamface.cn/#/emailDetail";
static NSString *editorDetailURL = @"#/emailDetail";
//static NSString *editorDetailURL = @"http://192.168.1.145:8787/dist/H5.html#/emailDetail";

/** 编辑器编辑 */
//static NSString *editorEditURL = @"https://page.teamface.cn/#/emailEdit";
static NSString *editorEditURL = @"#/emailEdit";
//static NSString *editorEditURL = @"http://192.168.1.8:9999/#/emailEdit";

/** 数据报表 */
//static NSString *customTable = @"https://page.teamface.cn/#/tables";
static NSString *customTable = @"#/tables";
/** 数据报表 */
//static NSString *customChart = @"https://page.teamface.cn/#/echarts";
static NSString *customChart = @"#/echarts";

/** 思维导图H5地址 */
//static NSString *thinkUrl = @"https://page.teamface.cn/#/hierarchyPreview";
static NSString *thinkUrl = @"#/hierarchyPreview";
//static NSString *thinkUrl = @"http://192.168.1.145:8787/#/hierarchyPreview";
static NSString *salaryUrl = @"#/salary";


#endif /* TFUrl_h */
