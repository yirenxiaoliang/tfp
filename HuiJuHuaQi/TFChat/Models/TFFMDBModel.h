//
//  TFFMDBModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/11/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFFMDBModel : JSONModel

/** 聊天id */
@property (nonatomic, strong) NSNumber <Optional>*chatId;
/** 视频路径 */
@property (nonatomic, copy) NSString <Optional>*videoUrl;
/** 聊天内容 */
@property (nonatomic, copy) NSString <Optional>*content;
/** 小助手最后一条推送内容 */
@property (nonatomic, copy) NSString <Optional>*latest_push_content;
/** 消息类型 1文本,2图片,3语音,4文件,5小视频,6位置,7提醒 */
@property (nonatomic, strong) NSNumber <Optional>*chatFileType;
//公司id
@property (nonatomic, strong) NSNumber <Optional>*companyId;
//发送者名字
@property (nonatomic, copy) NSString <Optional>*senderName;
//发送者头像
@property (nonatomic, copy) NSString <Optional>*senderAvatarUrl;
@property (nonatomic, copy) NSString <Optional>*avatarUrl;
//消息未读数
@property (nonatomic, strong) NSNumber <Optional>*unreadMsgCount;
//草稿
@property (nonatomic, copy) NSString <Optional>*draft;
//chatType聊天类型 1群聊:2:单聊
@property (nonatomic, strong) NSNumber <Optional>*chatType;
//隐藏状态
@property (nonatomic, strong) NSNumber <Optional>*isHide;
//接受者
@property (nonatomic, copy) NSString <Optional>*receiverName;
//是否显示时间 0：不显示 1：显示
@property (nonatomic, strong) NSNumber <Optional>*showTime;
//文件后缀
@property (nonatomic, copy) NSString <Optional>*fileSuffix;
//消息是否已读 0:未读 1:已读 2:正在发送 3:发送失败
@property (nonatomic, strong) NSNumber <Optional>*isRead;

/** 由时间戳和随机数拼接，用于区分聊天室具体哪条消息 */
@property (nonatomic, copy) NSString <Optional>*msgId;
/** 已读人员 */
@property (nonatomic, copy) NSString *readPeoples;
//群聊已读人数
@property (nonatomic, strong) NSNumber <Optional>*readNumbers;
//语音时长
@property (nonatomic, strong) NSNumber <Optional>*voiceDuration;
//是否置顶 0:不置顶 1:置顶
@property (nonatomic, strong) NSNumber <Optional>*isTop;
//群成员
@property (nonatomic, copy) NSString *groupPeoples;
/** 助手类型 1:应用小助手 2:企信小助手 3:审批小助手 4:文件库小助手 */
@property (nonatomic, copy) NSString *type;



/** 聊天文件 */
@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy) NSString *fileUrl;

@property (nonatomic, copy) NSString *fileType;

@property (nonatomic, strong) NSNumber *fileSize;

@property (nonatomic, strong) NSNumber *fileId;

/** mark 1:群解散  2:退群 3:创建会话 4:改变内容 5:删除应用 6:小助手推送（有可能小助手第一次来，此时列表还没小助手）*/
@property (nonatomic, strong) NSNumber <Optional>*mark;

/** 小助手字段 */
@property (nonatomic, copy) NSString *assistantName;

/** 免打扰 */
@property (nonatomic, strong) NSNumber <Optional>*noBother;

//小助手应用id
@property (nonatomic, strong) NSNumber *application_id;

@property (nonatomic, strong) NSNumber *create_time;
@property (nonatomic, strong) NSNumber *datetime_create_time;

/**小助手是否只查看未读*/
@property (nonatomic, copy) NSString <Optional>*showType;
//被@人的id
@property (nonatomic, copy) NSString *atIds;

//08.02增加
/** 自定义小助手图标和背景颜色 */
@property (nonatomic, copy) NSString *icon_color;
@property (nonatomic, copy) NSString *icon_url;
/** 0:本地图标 1：网络图标 */
@property (nonatomic, copy) NSString *icon_type;

             /***************头信息***************/
/** 服务器时间 */
@property (nonatomic, strong) NSNumber <Optional>*ServerTimes;

/** 客户端时间 */
@property (nonatomic, strong) NSNumber <Optional>*clientTimes;
/** 小助手最后一条推送时间 */
@property (nonatomic, strong) NSNumber <Optional>*latest_push_time;

/** 发送者 */
@property (nonatomic, strong) NSNumber <Optional>*senderID;

/** 接收者 */
@property (nonatomic, strong) NSNumber <Optional>*receiverID;

/** RAND */
@property (nonatomic, strong) NSNumber <Optional>*RAND;

/** 版本号 */
@property (nonatomic, strong) NSNumber <Optional>*ucVer;

/** 命令类型 */
@property (nonatomic, strong) NSNumber <Optional>*usCmdID;

/** 设备类型 */
@property (nonatomic, strong) NSNumber <Optional>*ucDeviceType;

/**  */
@property (nonatomic, strong) NSNumber <Optional>*ucFlag;

/** 自己id */
@property (nonatomic, strong) NSNumber <Optional>*OneselfIMID;

#pragma mark 小助手新增缓存字段（2018.06.22）

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, strong) NSNumber <Optional>*assistantId;
@property (nonatomic, strong) NSNumber <Optional>*dataId;
@property (nonatomic, strong) NSNumber <Optional>*myId;
@property (nonatomic, copy) NSString <Optional>*pushContent;
@property (nonatomic, copy) NSString <Optional>*beanName;
@property (nonatomic, copy) NSString <Optional>*beanNameChinese;
@property (nonatomic, copy) NSString <Optional>*oneRowValue;
@property (nonatomic, copy) NSString <Optional>*twoRowValue;
@property (nonatomic, copy) NSString <Optional>*threeRowValue;
@property (nonatomic, copy) NSString <Optional>*readStatus;

@property (nonatomic, copy) NSString <Optional>*icon;
@property (nonatomic, strong) NSNumber <Optional>*style;

//审批小助手独有
@property (nonatomic, copy) NSString <Optional>*param_fields;

@property (nonatomic, copy) NSString <Optional>*application_name;

@property (nonatomic, strong) NSValue <Ignore>*size;

@end
