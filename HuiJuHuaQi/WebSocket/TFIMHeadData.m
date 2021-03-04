//
//  TFIMHeadData.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFIMHeadData.h"

//void ParseCMDHead(char *pSer,IM_CMD_HEADER &CmdHead)
//{
//    memcpy((char*)&CmdHead,pSer,sizeof(IM_CMD_HEADER));
//}

@implementation TFIMHeadData


-(instancetype)init{
    if (self = [super init]) {
        
        self.clientTimes = [[NSDate date] timeIntervalSince1970]*1000;
        self.RAND = ABS(arc4random()%10000);
        
    }
    return self;
}

-(NSData *)data{
    
    int64_t OneselfIMID = self.OneselfIMID;
    uint16_t usCmdID = self.usCmdID;
    uint8_t ucVer = self.ucVer;
//    uint8_t ucDeviceType = self.ucDeviceType;
    uint8_t ucDeviceType = iOSDevice;
    uint8_t ucFlag = self.ucFlag;
    int64_t ServerTimes = self.ServerTimes;
    int64_t senderID = self.senderID;
    int64_t receiverID = self.receiverID;
    int64_t clientTimes = self.clientTimes;
    uint32_t RAND = self.RAND;
    
    NSMutableData *data = [NSMutableData dataWithBytes:&OneselfIMID length:sizeof(OneselfIMID)];
    
    [data appendBytes:&usCmdID length:sizeof(usCmdID)];
    
    [data appendBytes:&ucVer length:sizeof(ucVer)];
    
    [data appendBytes:&ucDeviceType length:sizeof(ucDeviceType)];
    
    [data appendBytes:&ucFlag length:sizeof(ucFlag)];
    
    [data appendBytes:&ServerTimes length:sizeof(ServerTimes)];
    
    [data appendBytes:&senderID length:sizeof(senderID)];
    
    [data appendBytes:&receiverID length:sizeof(receiverID)];
    
    [data appendBytes:&clientTimes length:sizeof(clientTimes)];
    
    [data appendBytes:&RAND length:sizeof(RAND)];
    
    return data;
}


+ (TFIMHeadData *)headerWithData:(NSData *)data{

    if (data.length == 0) {
        
        NSLog(@"空数据！");
        
        return nil;
    }
    else {
    
        TFIMHeadData *head = [[TFIMHeadData alloc] init];
        
        int64_t OneselfIMID;
        uint16_t usCmdID;
        uint8_t ucVer;
        uint8_t ucDeviceType;
        uint8_t ucFlag;
        int64_t ServerTimes;
        uint64_t senderID;
        uint64_t receiverID;
        int64_t clientTimes;
        uint32_t RAND;
        
        NSArray *headRange = @[@0,@(8),@(2),@(1),@(1),@(1),@(8),@(8),@(8),@(8),@(4)];
        
        NSInteger location = 0;
        NSInteger length = 0;
        
        location += [headRange[0] integerValue];
        length = [headRange[1] integerValue];
        [data getBytes:&OneselfIMID range:(NSRange){location,length}];
        
        location += [headRange[1] integerValue];
        length = [headRange[2] integerValue];
        [data getBytes:&usCmdID range:(NSRange){location,length}];
        
        location += [headRange[2] integerValue];
        length = [headRange[3] integerValue];
        [data getBytes:&ucVer range:(NSRange){location,length}];
        
        location += [headRange[3] integerValue];
        length = [headRange[4] integerValue];
        [data getBytes:&ucDeviceType range:(NSRange){location,length}];
        
        location += [headRange[4] integerValue];
        length = [headRange[5] integerValue];
        [data getBytes:&ucFlag range:(NSRange){location,length}];
        
        location += [headRange[5] integerValue];
        length = [headRange[6] integerValue];
        [data getBytes:&ServerTimes range:(NSRange){location,length}];
        
        location += [headRange[6] integerValue];
        length = [headRange[7] integerValue];
        [data getBytes:&senderID range:(NSRange){location,length}];
        
        location += [headRange[7] integerValue];
        length = [headRange[8] integerValue];
        [data getBytes:&receiverID range:(NSRange){location,length}];
        
        location += [headRange[8] integerValue];
        length = [headRange[9] integerValue];
        [data getBytes:&clientTimes range:(NSRange){location,length}];
        
        location += [headRange[9] integerValue];
        length = [headRange[10] integerValue];
        [data getBytes:&RAND range:(NSRange){location,length}];
        
        head.OneselfIMID = OneselfIMID;
        head.usCmdID = usCmdID;
        head.ucVer = ucVer;
//        head.ucDeviceType = ucDeviceType;
        head.ucDeviceType = iOSDevice;
        head.ucFlag = ucFlag;
        head.ServerTimes = ServerTimes;
        head.senderID = senderID;
        head.receiverID = receiverID;
        head.clientTimes = clientTimes;
        head.RAND = RAND;
        
        return head;

    }
    
}






@end
