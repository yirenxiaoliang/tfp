//
//  HQJPushHelper.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/12/2.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQJPushHelper.h"

@implementation HQJPushHelper



/**
 * @abstract 新用户注册
 *
 * @param username 用户名. 长度 4~128 位.
 *                 支持的字符: 字母,数字,下划线,英文减号,英文点,@邮件符号. 首字母只允许是字母或者数字.
 * @param password 用户密码. 长度 4~128 位.
 * @param handler  结果回调. 返回正常时 error 为 nil.
 */
+ (void)jMessageRegisterWithUsername:(NSString *)username
                            password:(NSString *)password
                   completionHandler:(void (^)(id resultObject, NSError *error))completionHandler{
    
    [JMSGUser registerWithUsername:username password:password completionHandler:^(id resultObject, NSError *error) {
        if (completionHandler) {
            completionHandler(resultObject,error);
        }
    }];
    
}


/**
 *  登录JMessage
 *
 *  @prama  userName  用户名
 *  @prama  password  密码
 *  @prama  (void (^)(id resultObject, NSError *error))completionHandler  执行后回调
 *
 */
+ (void)jMessageUserLoginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void (^)(id resultObject, NSError *error))completionHandler{
    
    [JMSGUser loginWithUsername:userName
                   password:password
              completionHandler:^(id resultObject, NSError *error) {
                  if (completionHandler) {
                      completionHandler(resultObject,error);
                  }
    }];
    
}
+ (void)jMessageUserLoginCompletionHandler:(void (^)(id resultObject, NSError *error))completionHandler{
    
//    HQLog(@"极光账户%@",UM.userLoginInfo.employee.imUsername);
//    HQLog(@"极光密码%@",UM.userLoginInfo.employee.imPassword);
//    
//    if (UM.userLoginInfo.employee.imUsername && UM.userLoginInfo.employee.imPassword) {// 登录极光聊天
//        
//        [HQJPushHelper jMessageUserLoginWithUserName:UM.userLoginInfo.employee.imUsername password:UM.userLoginInfo.employee.imPassword completionHandler:^(id resultObject, NSError *error) {
//            
//            if (error==nil) {
//                
//                HQLog(@"登录极光成功");
//            }
//            
//        }];
//        
//    }
    
}

/**
 *  退出JMessage
 *
 *  @prama  (void (^)(id resultObject, NSError *error))completionHandler  执行后回调
 *
 */
+ (void)jMessageLogout:(void (^)(id resultObject, NSError *error))completionHandler{
    
    [JMSGUser logout:^(id resultObject, NSError *error) {
        if (completionHandler) {
            completionHandler(resultObject,error);
        }
    }];
}



/**
 *  设置该用户Jpush 的标签、别名
 
 *  @prama   tags   标签集合
 tags:
 nil 此次调用不设置此值。
 空集合（[NSSet set]）表示取消之前的设置。
 集合成员类型要求为NSString类型
 每次调用至少设置一个 tag，覆盖之前的设置，不是新增。
 有效的标签组成：字母（区分大小写）、数字、下划线、汉字，特殊字符(v2.1.9支持)@!#$&*+=.|。
 限制：每个 tag 命名长度限制为 40 字节，最多支持设置 1000 个 tag，但总长度不得超过7K字节。（判断长度需采用UTF-8编码）
 单个设备最多支持设置 1000 个 tag。App 全局 tag 数量无限制。
 
 *  @prama   alias  别名
 alias:
 nil 此次调用不设置此值。
 空字符串 （@""）表示取消之前的设置。
 每次调用设置有效的别名，覆盖之前的设置。
 有效的别名组成：字母（区分大小写）、数字、下划线、汉字，特殊字符(v2.1.9支持)@!#$&*+=.|。
 限制：alias 命名长度限制为 40 字节。（判断长度需采用UTF-8编码）
 
 *  @prama   (void (^)(int iResCode, NSSet iTags, NSString iAlias))completionHandler
 
 completionHandler用于处理设置返回结果
 iResCode返回的结果状态码
 iTags和iAlias返回设置的tag和alias
 */
+ (void)jMessageSetTags:(NSSet *)tags alias:(NSString *)alias fetchCompletionHandle:(void (^)(int iResCode, NSSet *iTags, NSString *iAlias))completionHandler{
    
    [JPUSHService setTags:tags alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        
        if (completionHandler) {
            completionHandler(iResCode,iTags,iAlias);
        }
    }];
}

/*!
 * @abstract 更新用户信息接口
 *
 * @param parameter     新的属性值
 *        Birthday&&Gender 是NSNumber类型, Avatar NSData类型 其他 NSString
 * @param type          更新属性类型
 * @param handler       用户注册回调接口函数
 */
+ (void)jMessageUpdateMyInfoWithParameter:(id)parameter
                    userFieldType:(JMSGUserField)type
                completionHandler:(void (^)(id resultObject, NSError *error))completionHandler{
    [JMSGUser updateMyInfoWithParameter:parameter userFieldType:type completionHandler:^(id resultObject, NSError *error) {
      
        if (completionHandler) {
            completionHandler(resultObject,error);
        }
    }];
}

/*!
 * @abstract 获取用户本身个人信息接口
 *
 * @return 当前登陆账号个人信息
 */
+ (JMSGUser *)jMessageMyInfo{
    
    return [JMSGUser myInfo];
}


/*!
 * @abstract 获取头像缩略图文件数据
 *
 * @param handler 结果回调。回调参数:
 *
 * - data 头像数据;
 * - objectId 用户username;
 * - error 不为nil表示出错;
 *
 * 如果 error 为 ni, data 也为 nil, 表示没有头像数据.
 *
 * @discussion 需要展示缩略图时使用。
 * 如果本地已经有文件，则会返回本地，否则会从服务器上下载。
 */
+ (void)jMessageThumbAvatarData:(void (^)(NSData *data, NSString *objectId, NSError *error))handler{
    
    JMSGUser *user = [JMSGUser myInfo];
    
    [user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        
        if (handler) {
            handler(data,objectId,error);
        }
        
    }];
}

/*!
 * @abstract 获取头像大图文件数据
 *
 * @param handler 结果回调。回调参数:
 *
 * - data 头像数据;
 * - objectId 用户username;
 * - error 不为nil表示出错;
 *
 * 如果 error 为 ni, data 也为 nil, 表示没有头像数据.
 *
 * @discussion 需要展示大图图时使用
 * 如果本地已经有文件，则会返回本地，否则会从服务器上下载。
 */
+ (void)jMessageLargeAvatarData:(void (^)(NSData *data, NSString *objectId, NSError *error))handler{
    
    JMSGUser *user = [JMSGUser myInfo];
    
    [user largeAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        
        if (handler) {
            handler(data,objectId,error);
        }
    }];
}

/*!
 * @abstract 用户展示名
 *
 * @discussion 如果 nickname 存在则返回 nickname，否则返回 username
 */
+ (NSString *)jMessageDisplayName{
    
    JMSGUser *user = [JMSGUser myInfo];
    
    return [user displayName];
}

/*!
 * @abstract 创建单聊会话
 *
 * @param username 单聊对象 username
 * @param handler 结果回调。正常返回时 resultObject 类型为 JMSGConversation。
 *
 * @discussion 如果会话已经存在，则直接返回。如果不存在则创建。
 * 创建会话时如果发现该 username 的信息本地还没有，则需要从服务器上拉取。
 * 服务器端如果找不到该 username，或者某种原因查找失败，则创建会话失败。
 */
+ (void)createSingleConversationWithUsername:(NSString *)username completionHandler:(void (^)(id resultObject, NSError *error))completionHandler{
    [JMSGConversation createSingleConversationWithUsername:username appKey:JMESSAGE_APPKEY completionHandler:^(id resultObject, NSError *error) {
        
        if (completionHandler) {
            completionHandler(resultObject,error);
        }
        
    }];
}

/*!
 * @abstract 创建群聊会话
 *
 * @param groupId 群聊群组ID。由创建群组时返回。
 * @param handler 结果回调。正常返回时 resultObject 类型为 JMSGConversation。
 *
 * @discussion 如果会话已经存在，则直接返回。如果不存在则创建。
 * 创建会话时如果发现该 groupId 的信息本地还没有，则需要从服务器端上拉取。
 * 如果从服务器上获取 groupId 的信息不存在或者失败，则创建会话失败。
 */
+ (void)createGroupConversationWithGroupId:(NSString *)groupId
                         completionHandler:(void (^__nullable)(id __nullable resultObject, NSError *__nullable error))completionHandler{
    
    [JMSGConversation createGroupConversationWithGroupId:groupId completionHandler:^(id resultObject, NSError *error) {
        if (completionHandler) {
            completionHandler(resultObject,error);
        }
    }];
}

/*!
 * @abstract 创建群组
 *
 * @param groupName 群组名称
 * @param groupDesc 群组描述信息
 * @param usernameArray 初始成员列表。NSArray 里的类型是 NSString
 * @param handler 结果回调。正常返回 resultObject 的类型是 JMSGGroup。
 *
 * @discussion 向服务器端提交创建群组请求，返回生成后的群组对象.
 * 返回群组对象, 群组ID是App 需要关注的, 是后续各种群组维护的基础.
 */
+ (void)createGroupWithName:(NSString *__nullable)groupName
                       desc:(NSString *__nullable)groupDesc
                memberArray:(NSArray  *__nullable)usernameArray
          completionHandler:(void (^__nullable)(id __nullable resultObject, NSError *__nullable error))completionHandler{
    
    [JMSGGroup createGroupWithName:groupName
                              desc:groupDesc
                       memberArray:usernameArray
                 completionHandler:^(id resultObject, NSError *error) {
                     
                     if (completionHandler) {
                         completionHandler(resultObject,error);
                     }
                     
                 }];
}



@end
