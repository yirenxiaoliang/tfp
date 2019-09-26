//
//  HQResponseEntity.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/12.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQResponseEntity.h"

@implementation HQResponseEntity

//生成MEResponse回调值对象
+ (HQResponseEntity*)responseFromCmdId:(HQCMD)cmdId
                                    sid:(NSInteger)sid
                                   body:(id)body
{
    HQResponseEntity *resp = [HQResponseEntity entity];
    resp.cmdId = cmdId;
    resp.sid = sid;
    resp.body = body;
    return resp;
}

//生成MEResponse回调值对象
+ (HQResponseEntity*)responseFromCmdId:(HQCMD)cmdId
                                   sid:(NSInteger)sid
                                  body:(id)body
                                  data:(id)data
{
    HQResponseEntity *resp = [HQResponseEntity entity];
    resp.cmdId = cmdId;
    resp.sid = sid;
    resp.body = body;
    resp.data = data;
    return resp;
}

+ (HQResponseEntity*)responseFromCmdId:(HQCMD)cmdId
                                    sid:(NSInteger)sid
                                   body:(id)body
                              errorCode:(HQRESCode)code
                               errorDes:(NSString*)errorDes
{
    HQResponseEntity *resp = [HQResponseEntity entity];
    resp.cmdId = cmdId;
    resp.sid = sid;
    resp.body = body;
    resp.errorCode = code;
    resp.errorDescription = errorDes;
    return resp;
}

+ (HQResponseEntity*)responseFromCmdId:(HQCMD)cmdId
                                   sid:(NSInteger)sid
                              progress:(NSProgress *)progress{
    
    HQResponseEntity *resp = [HQResponseEntity entity];
    resp.cmdId = cmdId;
    resp.sid = sid;
    resp.progress = progress;
    return resp;
}

@end
