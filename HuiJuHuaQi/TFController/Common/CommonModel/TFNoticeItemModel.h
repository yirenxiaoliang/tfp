//
//  TFNoticeItemModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/9.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFNoticeItemModel

@end

@interface TFNoticeItemModel : JSONModel

/**
 "noticeTypeId" : 3414521839992832,
 "openDate" : 1497240957084,
 "createrphotograph" : "http:\/\/192.168.1.172:9400\/1\/029abe8583ec9e\/userlogo.png",
 "id" : 3414523616083968,
 "createrId" : 3410722696364032,
 "title" : "法拉咖啡还是考虑对方",
 "createrName" : "李萌",
 "employeeId" : 3410722696364032 */

/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** 标题 */
@property (nonatomic, copy) NSString <Optional>*title;

/** 时间 */
@property (nonatomic, strong) NSNumber <Optional>*openDate;

/** 类型id */
@property (nonatomic, strong) NSNumber <Optional>*noticeTypeId;
/** 类型名 */
@property (nonatomic, copy) NSString <Optional>*noticetypeName;

/** 颜色 */
@property (nonatomic, copy) NSString <Optional>*color;
/** 颜色 */
@property (nonatomic, copy) NSString <Optional>*noticeColor;

/** 文件数量 */
@property (nonatomic, strong) NSNumber <Optional>*countAttachment;

/** 定期时间 */
@property (nonatomic, strong) NSNumber <Optional>*timingDate;

/** 已读数 */
@property (nonatomic, strong) NSNumber <Optional>*isRead;
/** 已读数 */
@property (nonatomic, strong) NSNumber <Optional>*countAlready;
/** 总数读数 */
@property (nonatomic, strong) NSNumber <Optional>*countAll;

/** 人id */
@property (nonatomic, strong) NSNumber <Optional>*employeeId;

/** 人 */
@property (nonatomic, copy) NSString <Optional>*createrName;

/** 头像 */
@property (nonatomic, copy) NSString <Optional>*createrphotograph;


@end
