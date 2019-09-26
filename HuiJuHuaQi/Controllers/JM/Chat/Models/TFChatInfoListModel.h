//
//  TFChatInfoListCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/4.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

#import "TFFMDBModel.h"

@protocol TFChatInfoListModel @end

@interface TFChatInfoListModel : JSONModel

//{
//"id": "esdf45312",                      //群组id
//"name": "群组名",                       //群组名
//"notice ": "群公告",                    //群组公告
//"peoples ": "1，2",                     //群成员，字符串以,分隔
//"create_time": "1432165464"，           //创建群时间
//"update_time": "1432165464"，           //置顶群时间
//"principal": "1"，                      //负责人ID
//"type": "1"，                           //群类型(0;总群，1:创建群)
//"top_status": "1"，                     //置顶状态(0：未置顶，1：置顶)
//"no_bother": "1"，                      //免打扰状态(0：未设置，1：免打扰)
//"is_hide": "1"，                        //列表显示状态(0：未隐藏，1：隐藏)=
//"chat_type" : 1                         //1:群聊 2:单聊
//}

//{
//    "is_hide" : "0",
//    "update_time" : 1512373726996,
//    "top_status" : "0",
//    "id" : 3,
//    "no_bother" : "0",
//    "picture" : "null",
//    "chat_type" : 2,
//    "receiver_id" : 14,
//    "employee_name" : "王克栋"
//},

//{
//    "is_hide" : "1",
//    "update_time" : 1515826627931,
//    "top_status" : "1",
//    "unread_nums" : 9,
//    "id" : 80,
//    "no_bother" : "0",
//    "application_id" : 1,
//    "create_time" : 1515808780579,
//    "type" : 1,
//    "chat_type" : 3,
//    "name" : "客户"
//},

@property (nonatomic, strong) NSNumber <Optional>*principal;

/** 管理员 */
@property (nonatomic, copy) NSString <Optional>*principal_name;

@property (nonatomic, copy) NSString <Optional>*name;

@property (nonatomic, copy) NSString <Optional>*is_hide;

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*notice;

@property (nonatomic, copy) NSString <Optional>*no_bother;

@property (nonatomic, copy) NSString <Optional>*peoples;

@property (nonatomic, copy) NSString <Optional>*type;

@property (nonatomic, copy) NSString <Optional>*top_status;

@property (nonatomic, strong) NSNumber <Optional>*create_time;

@property (nonatomic, strong) NSNumber <Optional>*update_time;
/** 最后推送时间 */
@property (nonatomic, copy) NSString <Optional>*latest_push_time;

@property (nonatomic, strong) NSNumber <Optional>*chat_type;

@property (nonatomic, copy) NSString <Optional>*picture;

@property (nonatomic, strong) NSNumber <Optional>*receiver_id;

@property (nonatomic, copy) NSString <Optional>*employee_name;

//小助手应用id
@property (nonatomic, strong) NSNumber <Optional>*application_id;

@property (nonatomic, copy) NSString <Optional>*application_icon;

/** 小助手未读数 */
@property (nonatomic, strong) NSNumber <Optional>*unread_nums;

////查看推送消息的type(0:查看全部，1：查看未读)
@property (nonatomic, copy) NSString <Optional>*show_type;

/** 小助手最后一条推送消息 */
@property (nonatomic, copy) NSString <Optional>*latest_push_content;

/** 自定义小助手图标和背景颜色 */
@property (nonatomic, copy) NSString <Optional>*icon_color;
@property (nonatomic, copy) NSString <Optional>*icon_url;
/** 0:本地图标 1：网络图标 */
@property (nonatomic, copy) NSString <Optional>*icon_type;


- (TFFMDBModel *)chatListModel;

@end

