//
//  HQRequestManagerDelegate.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/12.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HQEnum.h"

@class HQRequestManager;

@protocol HQRequestManagerDelegate <NSObject>


@optional
- (void)requestManager:(HQRequestManager *)manager sequenceID:(NSInteger)sid didCompleteWithProgress:(NSProgress *)progress cmdId:(HQCMD)cmdId;

- (void)requestManager:(HQRequestManager *)manager sequenceID:(NSInteger)sid didCompleteWithData:(id)data cmdId:(HQCMD)cmdId;

- (void)requestManager:(HQRequestManager *)manager sequenceID:(NSInteger)sid didErrorWithData:(id)data cmdId:(HQCMD)cmdId;


@end
