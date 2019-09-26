//
//  HQRequestItem.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/12.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQRequestItem.h"


@interface HQRequestItem ()

@property (nonatomic, strong) NSTimer *timeoutTimer;

@end


@implementation HQRequestItem



- (id)initWithUrl:(NSString*)url
           method:(NSString*)method
            cmdId:(HQCMD)cmd
              sid:(NSInteger)sid
     requestParam:(id)param
          imgData:(NSArray *)imgDatas
        audioData:(NSArray *)audioDatas
        videoData:(NSArray *)videoDatas
         delegate:(id<HQRequestManagerDelegate>)delegate
   willRequestBlk:(WillRequestBlk)blk
{
    self = [super init];
    if (self) {
        self.cmdId = cmd;
        self.sid = sid;
        self.url = url;
        self.method = method;
        self.requestParam = param;
        self.imgDatas = imgDatas;
        self.audioDatas = audioDatas;
        self.videoDatas = videoDatas;
        self.delegate = delegate;
        
        if (blk) {
            self.willRequestBlk = blk;
        }
    }
    return self;
}


- (NSString*)description{
    @try {
        return [NSString stringWithFormat:@"URL:%@, CMD:%ld, Sid:%ld, Method:%@, Param: %@, Delegate:%@", _url, (long)_cmdId, (long)_sid, _method, [HQHelper dictionaryToJson:_requestParam], _delegate];
    }
    @catch (NSException *exception) {
        HQLog(@"%@",exception);
    }
    @finally {
        
    }
}


@end
