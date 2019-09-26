//
//  DataBaseHandle.h
//  ChatTest
//
//  Created by Season on 2017/5/18.
//  Copyright © 2017年 Season. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "TFAssistantPushModel.h"

#import "TFFMDBModel.h"

@interface DataBaseHandle : NSObject

#pragma mark   ++++++++++++++++++++++++++ 聊天室 ++++++++++++++++++++++++++
#pragma mark 创建聊天室数据库
+ (void)creatwChatRoomWithData;

#pragma mark 插入聊天室数据库
+ (BOOL)addRecordWithContent:(TFFMDBModel *)model;

#pragma mark 聊天室最后一条信息时间戳数据
/** 查聊天室最后时间戳数据 */
+ (id)queryRecodeLastTime:(NSNumber *)chatId;

#pragma mark 根据msgId查聊天室某条聊天记录
+ (id)queryChatRecordDataWithMsgId:(NSString *)msgId;

#pragma mark 分页查找聊天室数据
+ (id)queryChatRoomRecordPageWithChatId:(NSNumber *)chatId pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize;

#pragma mark 根据chatId查聊天室数据
+ (id)queryRecodeWithChatId:(NSNumber *)chatId;

#pragma mark 查所有聊天室数据
+ (id)queryAllChatRoomRecodeData;

#pragma mark 根据内容查找聊天室数据(搜索)
+ (id)queryAllRecodeWithContent:(NSString *)content chatId:(NSNumber *)chatId;

#pragma mark 更新聊天室消息状态 已读、未读、正在发送、发送失败
+ (BOOL)updateChatRoomReadStateWithData:(TFFMDBModel *)model;
#pragma mark 更新某聊天室全部已读
+ (BOOL)updateChatListDataAllReadWithData:(TFFMDBModel *)model;

#pragma mark 更新消息已读人员
+ (BOOL)updateChatRoomReadPeoplesWithData:(TFFMDBModel *)model;

#pragma mark 更新消息已读人数
+ (BOOL)updateChatRoomReadNumbersWithData:(TFFMDBModel *)model;

#pragma mark 根据msgId删除聊天
+ (BOOL)UPDATEChatRoomDataWithMsgId:(TFFMDBModel *)model;

#pragma mark 根据msgId删除聊天信息
+ (BOOL)deleteChatRoomDataWithMsgId:(NSString *)msgId;

#pragma mark 清除本地聊天信息
+ (BOOL)deleteChatRoomData;

#pragma mark   ++++++++++++++++++++++++++ 会话列表 ++++++++++++++++++++++++++
#pragma mark 创建会话列表数据库
+ (void)createChatListWithData;

#pragma mark 插入会话列表数据库
+ (BOOL)addChatListWithData:(TFFMDBModel *)model;

#pragma mark 查询所有会话和小助手列表
+ (id)queryAllChatListData;

#pragma mark 查询所有聊天列表不包括小助手
+ (id)queryAllChatListExceptAssistant;

#pragma mark 联表查询(常用联系人)
+ (id)queryCommonlyContactsData;

#pragma mark 根据chatId查会话列表数据
+ (id)queryChatListDataWithChatId:(NSNumber *)chatId;

#pragma mark 更新会话列表数据库
+ (BOOL)updateChatListWithData:(TFFMDBModel *)model;

#pragma mark 更新会话列表头像和名字数据库
+ (BOOL)updateChatPictureAndReceiverNameWithData:(TFFMDBModel *)model;

#pragma mark 更新会话是否隐藏
+ (BOOL)updateChatListIshideWithData:(TFFMDBModel *)model;

#pragma mark 删除应用小助手会话
+ (BOOL)deleteAssistantListWithAssistantId:(NSNumber *)assistantId;
#pragma mark 删除聊天室的对应助手的数据
+ (BOOL)deleteChatListWithAssistantId:(NSNumber *)assistantId;


#pragma mark 更新已读未读数
+ (BOOL)updateChatListUnReadMsgNumberWithData:(TFFMDBModel *)model;

#pragma mark 更新列表数据置顶
+ (BOOL)updateChatListIsTopWithData:(TFFMDBModel *)model;

#pragma mark 更新列表数据免打扰
+ (BOOL)updateChatListNoBotherWithData:(TFFMDBModel *)model;
#pragma mark 更新小助手数据免打扰
+ (BOOL)updateAssistantNoBotherWithData:(TFFMDBModel *)model;

#pragma mark 更新群成员
+ (BOOL)updateChatListGroupPeoplesWithData:(TFFMDBModel *)model;

#pragma mark 根据chatId删除会话列表
+ (BOOL)deleteChatListDataWithChatId:(NSNumber *)chatId;

#pragma mark 查会话列表所有群数据
+ (id)queryChatListAllGroupWithKeyword:(NSString *)keyword;


#pragma mark ++++++++++++++++++++++++++ 小助手 ++++++++++++++++++++++++++
#pragma mark 创建小助手数据库表
+ (void)createAssistantListTable;

#pragma mark 插入数据到小助手数据库
+ (BOOL)insertDataIntoAssistantTable:(TFFMDBModel *)model;

#pragma mark 查询所有小助手
+ (id)queryAllAssistantListData;

#pragma mark 查询未隐藏小助手
+ (id)queryIsNotHidenAssistantListData;

#pragma mark 查询小助手数据
+ (id)queryAssistantListDataWithChatId:(NSNumber *)chatId;

#pragma mark 更新小助手
+ (BOOL)updateAssistantListDataWithModel:(TFFMDBModel *)model;

#pragma mark 更新小助手未读数
+ (BOOL)updateAssistantListUnReadWithData:(TFFMDBModel *)model;

#pragma mark 设置小助手置顶
+ (BOOL)updateAssistantListIsTopWithData:(TFFMDBModel *)model;

#pragma mark 设置小助手是否只看未读
+ (BOOL)updateAssistantListShowTypeWithData:(TFFMDBModel *)model;

#pragma mark 更新应用小助手图标、颜色、名称
+ (BOOL)updateAssistantListIconAndNameWithData:(TFFMDBModel *)model;

#pragma mark 设置小助手隐藏
+ (BOOL)updateAssistantListIsHideWithData:(TFFMDBModel *)model;

#pragma mark ++++++++++++++++++++++++++ 小助手列表 ++++++++++++++++++++++++++
#pragma mark 创建小助手列表数据库表
+ (void)createSubAssistantDataListTable;

#pragma mark 插入数据到小助手列表数据库
+ (BOOL)insertIntoAssistantDataListTable:(TFFMDBModel *)model;

#pragma mark 查询对应小助手列表数据 (分页查询)
+ (id)queryAssistantDataListWithAssistantId:(NSNumber *)assistantId beanName:(NSString *)beanName pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize showType:(NSString *)showType;

#pragma mark 查询小助手列表内容数据 (搜索)
+ (id)queryAssistantDataListWithKeywordForSearch:(NSString *)keyword assistantId:(NSNumber *)assistantId;

#pragma mark 小助手最新一条数据时间戳
/** 查小助手最新一条数据时间戳 */
+ (id)queryAssistantDataListLastTime:(NSNumber *)assistantId;

#pragma mark 小助手最旧一条数据时间戳
+ (id)queryAssistantDataListFirstTime:(NSNumber *)assistantId;

#pragma mark 更新小助手列表数据已读未读状态
+ (BOOL)updateAssistantListDataIsReadWithData:(TFAssistantPushModel *)model;

#pragma mark 更新小助手列表数据全部已读
+ (BOOL)updateAssistantListDataAllReadWithData:(TFFMDBModel *)model;

#pragma mark 更新小助手列表图标和模块名称
+ (BOOL)updateAssistantListModuleIconWithData:(TFFMDBModel *)model;

#pragma mark 清除本地小助手列表的表数据
+ (BOOL)deleteAssistantListDataWithAssistantId:(NSNumber *)assistantId;

#pragma mark 清除本账号所有本地小助手列表的表数据
+ (BOOL)deletePersonAssistantListAllData;

#pragma mark ++++++++++++++++++++++++++ 常用联系人 ++++++++++++++++++++++++++
#pragma mark 创建常用联系人表
+ (void)createCallWithData:(TFFMDBModel *)model;


@end
