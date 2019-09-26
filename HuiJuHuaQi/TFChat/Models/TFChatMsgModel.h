//
//  TFChatMsgModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/11/30.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFChatMsgModel : JSONModel

//{
//    "type":1,
//    "fileUrl":"图片,文件,语音等url",
//    "fileName":"文件名字",
//    "fileSize":"1234324",
//    "fileType":"avi",
//    "atList":[
//    {"id":65465972946524654,"name":"被@人的名字"}
//              
//              ],
//    "msg":"这是文本消息体",
//    "longitude":"经度",
//    "latitude":"纬度",
//    "duration":34524352,
//    "location":"地址",
//    "videoUrl":"视频网络路径",
//    "chatId":"会话id"

//"senderName":"发送人的名字",
//"senderAvatar":"发送人的头像地址",
//}

@property (nonatomic, strong) NSNumber <Optional>*type;

@property (nonatomic, copy) NSString <Optional>*fileUrl;

@property (nonatomic, copy) NSString <Optional>*videoUrl;

@property (nonatomic, copy) NSString <Optional>*fileName;

@property (nonatomic, strong) NSNumber <Optional>*fileSize;

@property (nonatomic, copy) NSString <Optional>*fileType;

@property (nonatomic, strong) NSNumber <Optional>*fileId;

@property (nonatomic, copy) NSString <Optional>*msg;

@property (nonatomic, copy) NSString <Optional>*longitude;

@property (nonatomic, copy) NSString <Optional>*latitude;

@property (nonatomic, strong) NSNumber <Optional>*duration;

@property (nonatomic, strong) NSNumber <Optional>*chatId;

@property (nonatomic, copy) NSString <Optional>*senderName;

@property (nonatomic, copy) NSString <Optional>*senderAvatar;

@property (nonatomic, copy) NSString <Optional>*avatar;

@property (nonatomic, strong) NSArray <Optional>*atList;

//拉取历史记录消息体
@property (nonatomic, strong) NSNumber <Optional>*timeSp;

@property (nonatomic, strong) NSNumber <Optional>*count;

@property (nonatomic, strong) NSNumber <Optional>*MsgType;

@property (nonatomic, strong) NSNumber <Optional>*SumCount;

@property (nonatomic, strong) NSNumber <Optional>*NowCount;

//被@人的id字符串
@property (nonatomic, copy) NSString <Ignore>*atIds;

@end
