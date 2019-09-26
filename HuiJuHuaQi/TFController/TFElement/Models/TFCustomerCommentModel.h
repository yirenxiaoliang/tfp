//
//  TFCustomerCommentModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/9.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFCustomerCommentModel 

@end

@interface TFCustomerCommentModel : JSONModel

/** 动态发布者 */
@property (nonatomic, strong) NSNumber <Optional>*employee_id;
/** 员工名 */
@property (nonatomic, copy) NSString <Optional>*employee_name;
/** 头像 */
@property (nonatomic, copy) NSString <Optional>*picture;

/** 动态类型 0:聊天 1：语音 2：图片 3：文件 */
@property (nonatomic, strong) NSNumber <Optional>*type;

/** 动态内容 */
@property (nonatomic, copy) NSString <Optional>*content;

/** 语音or图片地址 */
@property (nonatomic, strong) UIImage <Ignore>*image;
/** 语音or图片地址 */
@property (nonatomic, copy) NSString <Optional>*fileUrl;
/** 语音or图片地址 */
@property (nonatomic, copy) NSString <Optional>*fileType;
/** 语音or图片地址 */
@property (nonatomic, copy) NSString <Optional>*fileName;
/** 语音or图片地址 */
@property (nonatomic, strong) NSNumber <Optional>*fileSize;

/** 语音时长 */
@property (nonatomic, strong) NSNumber <Optional>*voiceTime;

/**
 "user_name": "3519572260323328",
 "information": "",
 "id": "3",
 "time": "1506076365549",
 "bean": "customer",
 "content": "几级了",
 "relation_id": "1" */

/** 名字 */
@property (nonatomic, copy) NSString <Optional>*information;
/** 名字 */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** 名字 */
@property (nonatomic, strong) NSNumber <Optional>*datetime_time;
/** 名字 */
@property (nonatomic, copy) NSString <Optional>*bean;
/** 名字 */
@property (nonatomic, strong) NSNumber <Optional>*relation_id;

/** show */
@property (nonatomic, strong) NSNumber <Ignore>*show;

@end
