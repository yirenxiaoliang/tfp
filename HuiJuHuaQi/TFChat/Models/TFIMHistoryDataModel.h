//
//  TFIMHistoryDataModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFIMHistoryDataModel : JSONModel

//{"senderName":"cyl","chatId":38,"msg":"A","type":1,"senderAvatar":""}

@property (nonatomic, copy) NSString <Optional>*senderName;

@property (nonatomic, strong) NSNumber <Optional>*chatId;

@property (nonatomic, copy) NSString <Optional>*msg;

@property (nonatomic, strong) NSNumber <Optional>*type;

@property (nonatomic, copy) NSString <Optional>*senderAvatar;

@end
