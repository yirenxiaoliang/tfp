//
//  TFRequest.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFRequest : NSObject

/** 单例 */
+ (TFRequest *)sharedManager;
/** 销毁单例 */
+(void)dellocManager;
/** GET请求 */
-(void)requestGET:(NSString *)URLString
       parameters:(id)parameters
         progress:(void (^)(NSProgress *progress))downloadProgress
          success:(void (^)(id response))success
          failure:(void (^)(NSError * error))failure;

/** POST请求 走参数 */
-(void)requestPOST:(NSString *)URLString
        parameters:(id)parameters
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure;

/** POST请求 走body */
-(void)requestPOST:(NSString *)URLString
              body:(id)body
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure;

/**
 *  上传文件
 *  @param URLString 请求地址
 *  @param parameters 参数
 *  @param images 图片s(数组中放的为image)
 *  @param audios 音频s(数组中放的为audio路径)
 *  @param videos 视频s(数组中放的为video路径)
 *  @param files 文件s(数组中放的为文件路径)
 */
-(void)requestPOST:(NSString *)URLString
        parameters:(id)parameters
            images:(NSArray *)images
            audios:(NSArray *)audios
            videos:(NSArray *)videos
            files:(NSArray *)files
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure;

@end
