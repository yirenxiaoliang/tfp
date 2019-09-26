//
//  HQRequestItem.h
//  HuiJuHuaQi
//  111
//  Created by XieLB on 16/1/12.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "HQRequestManagerDelegate.h"

//开始请求
typedef void (^WillRequestBlk)(HQCMD cmd, NSInteger sid);

@interface HQRequestItem : NSObject

//请求序列号
@property (nonatomic, assign) NSInteger sid;

//请求命令类型
@property (nonatomic, assign) HQCMD cmdId;

//请求方法
@property (nonatomic, strong) NSString *method;

//请求地址
@property (nonatomic, strong) NSString *url;

//请求参数
@property (nonatomic, strong) id requestParam;

//图像数据
@property (nonatomic, strong) NSArray *imgDatas;

//录音数据
@property (nonatomic, strong) NSArray *audioDatas;
//视频数据
@property (nonatomic, strong) NSArray *videoDatas;

//是否正在执行
@property (nonatomic, assign) BOOL isExecuting;

//block
@property (nonatomic, copy) WillRequestBlk willRequestBlk;

// delegate
@property (nonatomic, assign) id <HQRequestManagerDelegate> delegate;


- (id)initWithUrl:(NSString*)url
           method:(NSString*)method
            cmdId:(HQCMD)cmd
              sid:(NSInteger)sid
     requestParam:(id)param
          imgData:(NSArray *)imgDatas
        audioData:(NSArray *)audioDatas
        videoData:(NSArray *)videoDatas
         delegate:(id<HQRequestManagerDelegate>)delegate
   willRequestBlk:(WillRequestBlk)blk;


 

@end
