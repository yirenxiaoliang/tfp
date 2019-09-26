//
//  HQResponseEntity.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/12.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseEntity.h"
#import "HQEnum.h"

@interface HQResponseEntity : HQBaseEntity


#pragma mark - Header
@property (nonatomic, assign) HQCMD cmdId;    //命令字
@property (nonatomic, assign) NSInteger sid;    //网络请求序列号

@property (nonatomic, assign) HQRESCode errorCode;       //错误码
@property (nonatomic, strong) NSString *errorDescription;   //错误描述信息

//#pragma mark - Header extend
@property (nonatomic, assign) BOOL isRefresh;   //是否下拉刷新    YES-下拉刷新，NO-上拉加载更多
//@property (nonatomic, assign) NSInteger totalCount; //总数

#pragma mark - Body
@property (nonatomic, strong) id body;
#pragma mark - data(接口返回的json)
@property (nonatomic, strong) id data;

/** progress */
@property (nonatomic, strong) NSProgress *progress;

//生成MEResponse回调值对象
+ (HQResponseEntity*)responseFromCmdId:(HQCMD)cmdId
                                    sid:(NSInteger)sid
                                   body:(id)body;
//生成MEResponse回调值对象
+ (HQResponseEntity*)responseFromCmdId:(HQCMD)cmdId
                                   sid:(NSInteger)sid
                                  body:(id)body
                                  data:(id)data;

+ (HQResponseEntity*)responseFromCmdId:(HQCMD)cmdId
                                    sid:(NSInteger)sid
                                   body:(id)body
                              errorCode:(HQRESCode)code
                               errorDes:(NSString*)errorDes;


+ (HQResponseEntity*)responseFromCmdId:(HQCMD)cmdId
                                   sid:(NSInteger)sid
                              progress:(NSProgress *)progress;

@end
