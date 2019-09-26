//
//  HQBaseBL.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/12.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "HQBLDelegate.h"
#import "HQRequestManager.h"
#import "HQEnum.h"
#import "HQConst.h"
#import "HQConfig.h"
#import "HQResponseEntity.h"


#define RM [HQRequestManager sharedManager]




@interface HQBaseBL : NSObject<HQRequestManagerDelegate>


@property (nonatomic, assign) id<HQBLDelegate> delegate;


@property (nonatomic, strong) NSMutableArray *tasks;

//构造一个子类对象
+ (id)build;

/**
 *  获取错误码
 *
 *  @param respBag 服务器回包
 *
 *  @return 错误码
 */
- (HQRESCode)getResCodeFromRespBag:(id)respBag;

/**
 *  获取错误消息
 *
 *  @param respBag 服务器回包
 *
 *  @return 错误信息
 */
- (NSString *)getMessFromRespBag:(id)respBag;

//转换成服务器指定格式数据
- (NSDictionary *)toDestinationJson:(NSDictionary *)dictionary;


//如果字典中包有respData的KEY，把该值返回
- (id)checkData:(id)data;


- (NSString*)urlFromCmd:(HQCMD)cmd;

//通用业务错误处理 (YES - 业务请求成功， NO - 业务请求失败)
- (BOOL)requestManager:(HQRequestManager*)requestManager commonData:(id)data sequenceID:(NSInteger)sid cmdId:(HQCMD)cmdId;

//- (NSDictionary*)packCommonBag;

/** 进度回调 */
- (void)progressCallbackWithResponse:(HQResponseEntity*)resp;

//成功代理回调
- (void)succeedCallbackWithResponse:(HQResponseEntity*)resp;

//失败代理回调 (默认为父类实现，子类可扩展)
- (void)failedCallbackWithResponse:(HQResponseEntity*)resp;


/** 初始化上传
 *
 *  @param bean
 */
- (void)imageFileWithImages:(NSArray *)imgDatas withVioces:(NSArray*)vedioDatas;
/** 聊天文件
 *
 *  @param bean
 */
- (void)chatFileWithImages:(NSArray *)imgDatas withVioces:(NSArray*)vedioDatas bean:(NSString *)bean;

/** 项目文库上传
 *
 *  @param bean
 */
- (void)projectFileWithImages:(NSArray *)imgDatas bean:(NSString *)bean fileId:(NSNumber *)fileId projectId:(NSNumber *)projectId;

/** 上传文件
 *
 *  @param bean
 */
- (void)uploadFileWithImages:(NSArray *)imgDatas withAudios:(NSArray*)audioDatas bean:(NSString *)bean;

/** 上传文件   */
- (void)uploadFileWithImages:(NSArray *)imgDatas withAudios:(NSArray*)audioDatas withVideo:(NSArray*)videoDatas bean:(NSString *)bean;

/** 多线程多文件上传
 *
 *  @param bean
 *  @param cmdId 请写大于100000以上
 */
- (void)uploadMutilFileWithImages:(NSArray *)imgDatas cmdId:(NSInteger)cmdId bean:(NSString *)bean;




@end
