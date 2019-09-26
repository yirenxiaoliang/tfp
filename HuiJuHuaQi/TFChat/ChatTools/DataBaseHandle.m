//
//  DataBaseHandle.m
//  ChatTest
//
//  Created by Season on 2017/5/18.
//  Copyright © 2017年 Season. All rights reserved.
//

#import "DataBaseHandle.h"

@implementation DataBaseHandle



#pragma mark   ++++++++++++++++++++++++++ 聊天室 ++++++++++++++++++++++++++
#pragma mark 创建聊天室数据库
+ (void)creatwChatRoomWithData {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chat.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    // 建表，此处图片为blob类型，对应OC可传NSData类型
    [db executeUpdate:[NSString stringWithFormat:@"create table if not exists chat_table (chatId integer,senderName text,senderAvatarUrl text, senderID integer,receiverID integer, content text,fileType integer ,fileSuffix text,videoUrl text,clientTimes text,showTime integer,isRead integer,msgId text not null,readNumbers integer,rand integer, chatType integer,readPeoples text,voiceDuration integer,fileName text,fileSize integer,fileUrl text,fileId integer,atIds text,primary key(msgId))"]];
    
    // 执行插入操作
    [db close];
    
}

#pragma mark 插入聊天室数据库
+ (BOOL)addRecordWithContent:(TFFMDBModel *)model {
  
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chat.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    // 建表，此处图片为blob类型，对应OC可传NSData类型
    [db executeUpdate:[NSString stringWithFormat:@"create table if not exists chat_table (chatId integer,senderName text,senderAvatarUrl text, senderID integer,receiverID integer, content text,fileType integer ,fileSuffix text,videoUrl text,clientTimes text,showTime integer,isRead integer,msgId text not null,readNumbers integer,rand integer, chatType integer,readPeoples text,voiceDuration integer,fileName text,fileSize integer,fileUrl text,fileId integer,atIds text,primary key(msgId))"]];
    
    
    NSString *sql =@"INSERT INTO chat_table(chatId,senderName,senderAvatarUrl, senderID,receiverID, content, fileType,fileSuffix,videoUrl, clientTimes, showTime, isRead, msgId,readNumbers,rand,chatType,readPeoples,voiceDuration,fileName,fileSize,fileUrl,fileId,atIds) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.chatId, model.senderName,model.senderAvatarUrl, model.senderID,model.receiverID, model.content, model.chatFileType ,model.fileSuffix, model.videoUrl, model.clientTimes,model.showTime,model.isRead,model.msgId,model.readNumbers,model.RAND,model.chatType,@"",model.voiceDuration,model.fileName,model.fileSize,model.fileUrl,model.fileId,model.atIds];

    [db close];
    return bResult;
}

#pragma mark 聊天室最后一条信息时间戳数据
/** 查聊天室最后时间戳数据 */
+ (id)queryRecodeLastTime:(NSNumber *)chatId {
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chat.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    [db open];
    
    // 查询数据
    NSString *str = [NSString stringWithFormat:@"select * from chat_table where chatId = %@ order by clientTimes desc limit 1",chatId];
    
    FMResultSet *s = [db executeQuery:str];
    
    TFFMDBModel *model = [[TFFMDBModel alloc] init];
    
    while ([s next]) {
        // 遍历解析获取到的数据
        
        model.clientTimes = @([[s stringForColumn:@"clientTimes"] longLongValue]);
        model.chatId = @([s intForColumn:@"chatId"]);
        model.showTime = @([s intForColumn:@"showTime"]);
        model.msgId = [s stringForColumn:@"msgId"];
        model.content = [s stringForColumn:@"content"];
        model.chatFileType = @([s intForColumn:@"fileType"]);
        model.senderID = @([s intForColumn:@"senderID"]);
        model.fileSuffix = [s stringForColumn:@"fileSuffix"];
        model.senderName = [s stringForColumn:@"senderName"];
        model.senderAvatarUrl = [s stringForColumn:@"senderAvatarUrl"];
        model.isRead = @([s intForColumn:@"isRead"]);
        model.readNumbers = @([s intForColumn:@"readNumbers"]);
        model.RAND = @([s intForColumn:@"rand"]);
        model.receiverID = @([s intForColumn:@"receiverID"]);
        model.chatType = @([s intForColumn:@"chatType"]);
        model.readPeoples = [s stringForColumn:@"readPeoples"];
        model.voiceDuration = @([s intForColumn:@"voiceDuration"]);
        model.fileName = [s stringForColumn:@"fileName"];
        model.fileSize = @([s intForColumn:@"fileSize"]);
        model.fileType = [s stringForColumn:@"fileType"];
        model.fileUrl = [s stringForColumn:@"fileUrl"];
        model.videoUrl = [s stringForColumn:@"videoUrl"];
        model.fileId = @([s intForColumn:@"fileId"]);
        model.atIds = [s stringForColumn:@"atIds"];
    }
    
    [db close];
    return model;
    
}

#pragma mark 根据msgId查聊天室某条聊天记录
+ (id)queryChatRecordDataWithMsgId:(NSString *)msgId {
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chat.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    [db open];
    NSString *sql = [NSString stringWithFormat:@"select * from chat_table where msgId = %lld",[msgId  longLongValue]];
    // 查询数据
    FMResultSet *s = [db executeQuery:sql];
    
    TFFMDBModel *model = [[TFFMDBModel alloc] init];
    while ([s next]) {
        
        // 遍历解析获取到的数据
        model.chatId = @([s intForColumn:@"chatId"]);
        model.senderName = [s stringForColumn:@"senderName"];
        model.atIds = [s stringForColumn:@"atIds"];
        model.unreadMsgCount = @([s intForColumn:@"unreadMsgCount"]);
    }
    
    [db close];
    return model;
    
}

#pragma mark 分页查找聊天室数据
+ (id)queryChatRoomRecordPageWithChatId:(NSNumber *)chatId pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize {
    
    NSInteger size = [pageSize integerValue];
    NSInteger num = [pageNum integerValue];
    NSInteger page = size*(num-1);
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chat.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    [db open];
    
    NSMutableArray *records = [NSMutableArray array];
    
    // 查询数据
    FMResultSet *s = [db executeQuery:[NSString stringWithFormat:@"SELECT A.* FROM( SELECT * FROM chat_table WHERE chatId = %@ ORDER BY clientTimes DESC LIMIT %ld OFFSET %ld) A ORDER BY clientTimes",chatId,size,page]];
    
    while ([s next]) {
        // 遍历解析获取到的数据
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        model.senderID = @([s intForColumn:@"senderID"]);
        model.content = [s stringForColumn:@"content"];
        model.clientTimes = @([[s stringForColumn:@"clientTimes"] longLongValue]);
        model.chatFileType = @([s intForColumn:@"fileType"]);
        model.fileSuffix = [s stringForColumn:@"fileSuffix"];
        model.senderName = [s stringForColumn:@"senderName"];
        model.senderAvatarUrl = [s stringForColumn:@"senderAvatarUrl"];
        model.chatId = @([s intForColumn:@"chatId"]);
        model.showTime = @([s intForColumn:@"showTime"]);
        model.isRead = @([s intForColumn:@"isRead"]);
        model.readNumbers = @([s intForColumn:@"readNumbers"]);
        model.msgId = [s stringForColumn:@"msgId"];
        model.RAND = @([s intForColumn:@"rand"]);
        model.receiverID = @([s intForColumn:@"receiverID"]);
        model.chatType = @([s intForColumn:@"chatType"]);
        model.readPeoples = [s stringForColumn:@"readPeoples"];
        model.voiceDuration = @([s intForColumn:@"voiceDuration"]);
        model.fileName = [s stringForColumn:@"fileName"];
        model.fileSize = @([s intForColumn:@"fileSize"]);
        model.fileType = [s stringForColumn:@"fileType"];
        model.fileUrl = [s stringForColumn:@"fileUrl"];
        model.videoUrl = [s stringForColumn:@"videoUrl"];
        model.fileId = @([s intForColumn:@"fileId"]);
        model.atIds = [s stringForColumn:@"atIds"];
        
        [records addObject:model];
    }
    
    [db close];
    return records;
}

#pragma mark 根据chatId查聊天室数据
+ (id)queryRecodeWithChatId:(NSNumber *)chatId {
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chat.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    [db open];
    
    NSMutableArray *records = [NSMutableArray array];
    
    // 查询数据
    FMResultSet *s = [db executeQuery:[NSString stringWithFormat:@"select * from chat_table where chatId = %@ order by clientTimes ASC",chatId]];
    
    while ([s next]) {
        // 遍历解析获取到的数据
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        model.senderID = @([s intForColumn:@"senderID"]);
        model.content = [s stringForColumn:@"content"];
        model.clientTimes = @([[s stringForColumn:@"clientTimes"] longLongValue]);
        model.chatFileType = @([s intForColumn:@"fileType"]);
        model.fileSuffix = [s stringForColumn:@"fileSuffix"];
        model.senderName = [s stringForColumn:@"senderName"];
        model.senderAvatarUrl = [s stringForColumn:@"senderAvatarUrl"];
        model.chatId = @([s intForColumn:@"chatId"]);
        model.showTime = @([s intForColumn:@"showTime"]);
        model.isRead = @([s intForColumn:@"isRead"]);
        model.readNumbers = @([s intForColumn:@"readNumbers"]);
        model.msgId = [s stringForColumn:@"msgId"];
        model.RAND = @([s intForColumn:@"rand"]);
        model.receiverID = @([s intForColumn:@"receiverID"]);
        model.chatType = @([s intForColumn:@"chatType"]);
        model.readPeoples = [s stringForColumn:@"readPeoples"];
        model.voiceDuration = @([s intForColumn:@"voiceDuration"]);
        model.fileName = [s stringForColumn:@"fileName"];
        model.fileSize = @([s intForColumn:@"fileSize"]);
        model.fileType = [s stringForColumn:@"fileType"];
        model.fileUrl = [s stringForColumn:@"fileUrl"];
        model.videoUrl = [s stringForColumn:@"videoUrl"];
        model.fileId = @([s intForColumn:@"fileId"]);
        model.atIds = [s stringForColumn:@"atIds"];
        
        [records addObject:model];
    }
    
    [db close];
    return records;
}

#pragma mark 查所有聊天室数据
+ (id)queryAllChatRoomRecodeData {
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chat.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    
    [db open];
    
    NSMutableArray *records = [NSMutableArray array];
    
    // 查询数据
    FMResultSet *s = [db executeQuery:[NSString stringWithFormat:@"select * from chat_table"]];
    
    while ([s next]) {
        
        // 遍历解析获取到的数据
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        model.senderID = @([s intForColumn:@"senderID"]);
        model.content = [s stringForColumn:@"content"];
        model.clientTimes = @([[s stringForColumn:@"clientTimes"] longLongValue]);
        model.chatFileType = @([s intForColumn:@"fileType"]);
        model.fileSuffix = [s stringForColumn:@"fileSuffix"];
        model.senderName = [s stringForColumn:@"senderName"];
        model.senderAvatarUrl = [s stringForColumn:@"senderAvatarUrl"];
        model.chatId = @([s intForColumn:@"chatId"]);
        model.showTime = @([s intForColumn:@"showTime"]);
        model.isRead = @([s intForColumn:@"isRead"]);
        model.readNumbers = @([s intForColumn:@"readNumbers"]);
        model.msgId = [s stringForColumn:@"msgId"];
        model.RAND = @([s intForColumn:@"rand"]);
        model.receiverID = @([s intForColumn:@"receiverID"]);
        model.chatType = @([s intForColumn:@"chatType"]);
        model.readPeoples = [s stringForColumn:@"readPeoples"];
        model.voiceDuration = @([s intForColumn:@"voiceDuration"]);
        model.fileName = [s stringForColumn:@"fileName"];
        model.fileSize = @([s intForColumn:@"fileSize"]);
        model.fileType = [s stringForColumn:@"fileType"];
        model.fileUrl = [s stringForColumn:@"fileUrl"];
        model.videoUrl = [s stringForColumn:@"videoUrl"];
        model.fileId = @([s intForColumn:@"fileId"]);
        model.atIds = [s stringForColumn:@"atIds"];
        
        [records addObject:model];
    }
    
    [db close];
    return records;
}

#pragma mark 根据内容查找聊天室数据(搜索)
+ (id)queryAllRecodeWithContent:(NSString *)content chatId:(NSNumber *)chatId {
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chat.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    
    HQLog(@"path002:%@",path);
    [db open];
    
    NSMutableArray *records = [NSMutableArray array];
    
    // 查询数据
    NSString *str = [NSString stringWithFormat:@"select * from chat_table where content like '%@%@%@' and chatId = %@",@"%",content,@"%",chatId];
    FMResultSet *s = [db executeQuery:str];
    
    while ([s next]) {
        
        // 遍历解析获取到的数据
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        model.senderID = @([s intForColumn:@"senderID"]);
        model.content = [s stringForColumn:@"content"];
        model.clientTimes = @([[s stringForColumn:@"clientTimes"] longLongValue]);
        model.chatFileType = @([s intForColumn:@"fileType"]);
        model.fileSuffix = [s stringForColumn:@"fileSuffix"];
        model.senderName = [s stringForColumn:@"senderName"];
        model.senderAvatarUrl = [s stringForColumn:@"senderAvatarUrl"];
        model.chatId = @([s intForColumn:@"chatId"]);
        model.showTime = @([s intForColumn:@"showTime"]);
        model.isRead = @([s intForColumn:@"isRead"]);
        model.readNumbers = @([s intForColumn:@"readNumbers"]);
        model.msgId = [s stringForColumn:@"msgId"];
        model.RAND = @([s intForColumn:@"rand"]);
        model.receiverID = @([s intForColumn:@"receiverID"]);
        model.chatType = @([s intForColumn:@"chatType"]);
        model.readPeoples = [s stringForColumn:@"readPeoples"];
        model.voiceDuration = @([s intForColumn:@"voiceDuration"]);
        model.fileName = [s stringForColumn:@"fileName"];
        model.fileSize = @([s intForColumn:@"fileSize"]);
        model.fileType = [s stringForColumn:@"fileType"];
        model.fileUrl = [s stringForColumn:@"fileUrl"];
        model.videoUrl = [s stringForColumn:@"videoUrl"];
        model.fileId = @([s intForColumn:@"fileId"]);
        model.atIds = [s stringForColumn:@"atIds"];
        
        [records addObject:model];
    }
    
    [db close];
    return records;
}

#pragma mark 更新聊天室消息状态 已读、未读、正在发送、发送失败
+ (BOOL)updateChatRoomReadStateWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chat.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE chat_table set isRead=? where msgId = %@",model.msgId] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.isRead];
    
    [db close];
    return bResult;
}

#pragma mark 更新某聊天室全部已读
+ (BOOL)updateChatListDataAllReadWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chat.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE chat_table set isRead=? where chatId = %@",model.chatId] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql,@"1"];
    
    [db close];
    return bResult;
}

#pragma mark 更新消息已读人员
+ (BOOL)updateChatRoomReadPeoplesWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chat.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE chat_table set readPeoples=? where msgId = %@",model.msgId] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.readPeoples];
    
    [db close];
    return bResult;
}

#pragma mark 更新消息已读人数
+ (BOOL)updateChatRoomReadNumbersWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chat.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE chat_table set readNumbers=? where chatId = %@ and msgId = %@",model.chatId,model.msgId] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.readNumbers];
    
    [db close];
    return bResult;
}

#pragma mark 根据msgId更新聊天
+ (BOOL)UPDATEChatRoomDataWithMsgId:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chat.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE chat_table set content=?, fileType=? where msgId = %@",model.msgId];
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql,model.content,model.chatFileType];
    
    [db close];
    return bResult;
}


#pragma mark 根据msgId删除聊天信息
+ (BOOL)deleteChatRoomDataWithMsgId:(NSString *)msgId {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chat.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"DELETE from chat_table where msgId = %@",msgId] ;
    
    //    NSString *str = [sql description];
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:[sql description]];
    
    [db close];
    return bResult;
}

#pragma mark 清除本地聊天信息
+ (BOOL)deleteChatRoomData {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chat.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"DELETE from chat_table"] ;
    
    //    NSString *str = [sql description];
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:[sql description]];
    
    [db close];
    return bResult;
}

#pragma mark   ++++++++++++++++++++++++++ 聊天会话列表 ++++++++++++++++++++++++++
#pragma mark 创建会话列表数据库
+ (void)createChatListWithData {
    
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    // 建表，此处图片为blob类型，对应OC可传NSData类型
    [db executeUpdate:[NSString stringWithFormat:@"create table if not exists chatList_table (chatId integer, oneselfIMID integer, companyId integer, targetId integer,receiverName text, chatType integer, content text, unreadMsgCount integer , draft text, avatarUrl text,clientTimes text,msgType integer, isHide integer,rand integer,noBother integer,isTop integer,groupPeoples text,uniId text,primary key(uniId))"]];
    
    
    [db close];
}

#pragma mark 插入会话列表数据库
+ (BOOL)addChatListWithData:(TFFMDBModel *)model {
    
//    model.isHide = @0;
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    // 建表，此处图片为blob类型，对应OC可传NSData类型
    [db executeUpdate:[NSString stringWithFormat:@"create table if not exists chatList_table (chatId integer, oneselfIMID integer, companyId integer, targetId integer,receiverName text, chatType integer, content text, unreadMsgCount integer , draft text, avatarUrl text,clientTimes text,msgType integer, isHide integer,rand integer,noBother integer, isTop integer,groupPeoples text,uniId text,primary key(uniId))"]];

    
    NSString *sql =@"INSERT INTO chatList_table(chatId, oneselfIMID, companyId, targetId, receiverName, chatType, content, unreadMsgCount, draft, avatarUrl, clientTimes, msgType, isHide, rand,noBother,isTop,groupPeoples,uniId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? , ? , ? , ? , ? , ? , ?)";


    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.chatId, UM.userLoginInfo.employee.sign_id,model.companyId,model.receiverID,model.receiverName,model.chatType, model.content, model.unreadMsgCount , model.draft,model.avatarUrl,model.clientTimes,model.chatFileType, model.isHide,model.RAND,model.noBother,model.isTop,model.groupPeoples,[NSString stringWithFormat:@"%@%@%@",model.companyId,UM.userLoginInfo.employee.sign_id,model.chatId]];
    
    [db close];
    return bResult;
}

#pragma mark 查询所有会话和小助手列表
+ (id)queryAllChatListData {
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chatList.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    
    HQLog(@"path003:%@",path);
    [db open];
    
    NSMutableArray *records = [NSMutableArray array];
    
    NSString *str = [NSString stringWithFormat:@"select * from (select distinct(t1.clientTimes),t1.chatId,t1.companyId,null applicationId, t1.chatType, t1.receiverName, t1.targetId, t1.content, t1.unreadMsgCount,t1.clientTimes,t1.avatarUrl,t1.msgType,t1.isTop,t1.noBother,t1.isHide,t1.oneselfIMID,t1.draft,null type , null showType , null iconUrl, null iconColor, null iconType from chatList_table t1 union all select distinct(t2.clientTimes),t2.chatId,t2.companyId,t2.applicationId, t2.chatType, t2.receiverName, NULL targetId, t2.content, t2.unreadMsgCount,t2.clientTimes,t2.avatarUrl,t2.msgType,t2.isTop,t2.noBother,t2.isHide, t2.oneselfIMID,NULL draft,t2.type, t2.showType , t2.iconUrl , t2.iconColor, t2.iconType from assistant_table t2) t3 where companyId = %@ and t3.oneselfIMID = %@ and t3.isHide =0 order by t3.isTop desc, t3.clientTimes desc",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.sign_id];
    
    FMResultSet *s = [db executeQuery:str];
    
    while ([s next]) {
        
        // 遍历解析获取到的数据
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        model.chatId = @([s intForColumn:@"chatId"]);
        model.companyId = @([s intForColumn:@"companyId"]);
        model.receiverID = @([s intForColumn:@"targetId"]);
        model.chatType = @([s intForColumn:@"chatType"]);
        model.content = [s stringForColumn:@"content"];
        model.unreadMsgCount = @([s intForColumn:@"unreadMsgCount"]);
        model.avatarUrl = [s stringForColumn:@"avatarUrl"];
        model.isHide = @([s intForColumn:@"isHide"]);
        model.clientTimes = @([[s stringForColumn:@"clientTimes"] longLongValue]);
        model.chatFileType = @([s intForColumn:@"msgType"]);
        model.receiverName = [s stringForColumn:@"receiverName"];
        model.isTop = @([s intForColumn:@"isTop"]);
        model.noBother = @([s intForColumn:@"noBother"]);
        model.type = [s stringForColumn:@"type"];
        model.draft = [s stringForColumn:@"draft"];
        model.showType = [s stringForColumn:@"showType"];
        model.application_id = @([s intForColumn:@"applicationId"]);
        model.icon_url = [s stringForColumn:@"iconUrl"];
        model.icon_color = [s stringForColumn:@"iconColor"];
        model.icon_type = [s stringForColumn:@"iconType"];
        
        [records addObject:model];
    }
    
    [db close];
    return records;
}

#pragma mark 查询所有聊天列表不包括小助手
+ (id)queryAllChatListExceptAssistant {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chatList.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    [db open];
    
    NSMutableArray *records = [NSMutableArray array];
    
    // 查询数据(置顶、时间降序)
    NSString *str = [NSString stringWithFormat:@"SELECT DISTINCT(clientTimes), chatId, oneselfIMID, companyId, targetId, chatType, content, unreadMsgCount, draft, avatarUrl, isHide, clientTimes, msgType, receiverName, noBother, rand, isTop, groupPeoples FROM chatList_table WHERE companyId = %@ AND oneselfIMID = %@ ORDER BY isTop DESC, clientTimes DESC",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.sign_id];
    
    FMResultSet *s = [db executeQuery:str];
    
    while ([s next]) {
        
        // 遍历解析获取到的数据
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        model.chatId = @([s intForColumn:@"chatId"]);
        model.OneselfIMID = @([s intForColumn:@"oneselfIMID"]);
        model.companyId = @([s intForColumn:@"companyId"]);
        model.receiverID = @([s intForColumn:@"targetId"]);
        model.chatType = @([s intForColumn:@"chatType"]);
        model.content = [s stringForColumn:@"content"];
        model.unreadMsgCount = @([s intForColumn:@"unreadMsgCount"]);
        model.draft = [s stringForColumn:@"draft"];
        model.avatarUrl = [s stringForColumn:@"avatarUrl"];
        model.isHide = @([s intForColumn:@"isHide"]);
        model.clientTimes = @([[s stringForColumn:@"clientTimes"] longLongValue]);
        model.chatFileType = @([s intForColumn:@"msgType"]);
        model.receiverName = [s stringForColumn:@"receiverName"];
        model.noBother = @([s intForColumn:@"noBother"]);
        model.RAND = @([s intForColumn:@"rand"]);
        model.isTop = @([s intForColumn:@"isTop"]);
        model.groupPeoples = [s stringForColumn:@"groupPeoples"];
        
        [records addObject:model];
    }
    
    [db close];
    return records;
}



#pragma mark 联表查询(常用联系人)
+ (id)queryCommonlyContactsData {
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chatList.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    HQLog(@"path004:%@",path);
    [db open];
    
    NSMutableArray *records = [NSMutableArray array];
    
    // 查询数据()
    NSString *str = [NSString stringWithFormat:@"select * from (select  * from (SELECT targetId, receiverName, avatarUrl,clientTimes FROM call_table union all SELECT targetId, receiverName,avatarUrl, clientTimes FROM chatList_table where chatType = 2 and companyId = %@ and oneselfIMID = %@ ) order by clientTimes asc) group by targetId order by clientTimes desc limit 30",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.sign_id];
    
    FMResultSet *s = [db executeQuery:str];
    
    while ([s next]) {
        
        // 遍历解析获取到的数据
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        model.receiverID = @([s intForColumn:@"targetId"]);
        model.avatarUrl = [s stringForColumn:@"avatarUrl"];
        model.clientTimes = @([[s stringForColumn:@"clientTimes"] longLongValue]);
        model.receiverName = [s stringForColumn:@"receiverName"];
        
        [records addObject:model];
    }
    
    [db close];
    return records;
}

#pragma mark 根据chatId查会话列表数据
+ (id)queryChatListDataWithChatId:(NSNumber *)chatId {
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chatList.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    [db open];
    
    // 查询数据
    FMResultSet *s = [db executeQuery:[NSString stringWithFormat:@"select * from chatList_table where chatId = %@ and oneselfIMID = %@ and companyId = %@",chatId,UM.userLoginInfo.employee.sign_id, UM.userLoginInfo.company.id]];
    
    TFFMDBModel *model = [[TFFMDBModel alloc] init];
    while ([s next]) {
        
        // 遍历解析获取到的数据
        model.RAND = @([s intForColumn:@"rand"]);
        model.chatId = @([s intForColumn:@"chatId"]);
        model.senderID = @([s intForColumn:@"oneselfIMID"]);
        model.companyId = @([s intForColumn:@"companyId"]);
        model.receiverID = @([s intForColumn:@"targetId"]);
        model.chatType = @([s intForColumn:@"chatType"]);
        model.content = [s stringForColumn:@"content"];
        model.unreadMsgCount = @([s intForColumn:@"unreadMsgCount"]);
        model.draft = [s stringForColumn:@"draft"];
        model.avatarUrl = [s stringForColumn:@"avatarUrl"];
        model.isHide = @([s intForColumn:@"isHide"]);
        model.clientTimes = @([[s stringForColumn:@"clientTimes"] longLongValue]);
        model.chatFileType = @([s intForColumn:@"msgType"]);
        model.receiverName = [s stringForColumn:@"receiverName"];
        model.isTop = @([s intForColumn:@"isTop"]);
        model.groupPeoples = [s stringForColumn:@"groupPeoples"];
        model.noBother = @([s intForColumn:@"noBother"]);
    }
    
    [db close];
    return model;
}

#pragma mark 更新会话列表数据库
+ (BOOL)updateChatListWithData:(TFFMDBModel *)model {
    
    model.isHide = @0;
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE chatList_table set targetId=?, content=?, draft=?,clientTimes=?,msgType=?,isHide=?,unreadMsgCount=?,rand=? where chatId = %@ and oneselfIMID = %@ and companyId = %@",model.chatId,UM.userLoginInfo.employee.sign_id, UM.userLoginInfo.company.id];
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql,model.receiverID, model.content , model.draft,model.clientTimes,model.chatFileType, model.isHide,model.unreadMsgCount,model.RAND];
    
    [db close];
    return bResult;
}

#pragma mark 更新会话列表头像和名字数据库
+ (BOOL)updateChatPictureAndReceiverNameWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE chatList_table set receiverName=?, avatarUrl=?, isTop=?,chatType=? where chatId = %@ and oneselfIMID = %@ and companyId = %@",model.chatId,UM.userLoginInfo.employee.sign_id, UM.userLoginInfo.company.id] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.receiverName,model.avatarUrl,model.isTop,model.chatType];
    
    [db close];
    return bResult;
}

#pragma mark 更新会话是否隐藏
+ (BOOL)updateChatListIshideWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE chatList_table set isHide=? where chatId = %@ and oneselfIMID = %@ and companyId = %@",model.chatId,UM.userLoginInfo.employee.sign_id, UM.userLoginInfo.company.id];
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.isHide];
    
    [db close];
    return bResult;
}


#pragma mark 更新已读未读数
+ (BOOL)updateChatListUnReadMsgNumberWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE chatList_table set unreadMsgCount=? where chatId = %@ and oneselfIMID = %@ and companyId = %@",model.chatId,UM.userLoginInfo.employee.sign_id, UM.userLoginInfo.company.id] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.unreadMsgCount];
    
    [db close];
    return bResult;
}

#pragma mark 更新列表数据置顶
+ (BOOL)updateChatListIsTopWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE chatList_table set isTop=? where chatId = %@ and oneselfIMID = %@ and companyId = %@",model.chatId,UM.userLoginInfo.employee.sign_id, UM.userLoginInfo.company.id] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.isTop];
    
    [db close];
    return bResult;
}

#pragma mark 更新单聊/群聊数据免打扰
+ (BOOL)updateChatListNoBotherWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE chatList_table set noBother=? where chatId = %@ and oneselfIMID = %@ and companyId = %@",model.chatId,UM.userLoginInfo.employee.sign_id, UM.userLoginInfo.company.id] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.noBother];
    
    [db close];
    return bResult;
}

#pragma mark 更新小助手数据免打扰
+ (BOOL)updateAssistantNoBotherWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE assistant_table set noBother=? where chatId = %@ and oneselfIMID = %@ and companyId = %@",model.chatId,UM.userLoginInfo.employee.sign_id, UM.userLoginInfo.company.id] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.noBother];
    
    [db close];
    return bResult;
}

#pragma mark 更新群成员
+ (BOOL)updateChatListGroupPeoplesWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE chatList_table set groupPeoples=? where chatId = %@ and oneselfIMID = %@ and companyId = %@",model.chatId,UM.userLoginInfo.employee.sign_id, UM.userLoginInfo.company.id] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.groupPeoples];
    
    [db close];
    return bResult;
}

#pragma mark 根据chatId删除会话列表
+ (BOOL)deleteChatListDataWithChatId:(NSNumber *)chatId {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"DELETE from chatList_table where chatId = %@ and oneselfIMID = %@ and companyId = %@",chatId,UM.userLoginInfo.employee.sign_id, UM.userLoginInfo.company.id] ;
    
//    NSString *str = [sql description];

    // 执行插入操作
    BOOL bResult = [db executeUpdate:[sql description]];
    
    [db close];
    return bResult;
}

#pragma mark 查会话列表所有群数据
+ (id)queryChatListAllGroupWithKeyword:(NSString *)keyword {
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chatList.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    [db open];
    
    // 查询数据
    NSString *str = [NSString stringWithFormat:@"select * from chatList_table where (chatType = 1 or chatType = 10) and receiverName like '%@%@%@' and oneselfIMID = %@ and companyId = %@",@"%",keyword,@"%",UM.userLoginInfo.employee.sign_id, UM.userLoginInfo.company.id];
    
    FMResultSet *s = [db executeQuery:str];
    
    NSMutableArray *records = [NSMutableArray array];
    
    while ([s next]) {
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        // 遍历解析获取到的数据
        model.RAND = @([s intForColumn:@"rand"]);
        model.chatId = @([s intForColumn:@"chatId"]);
        model.senderID = @([s intForColumn:@"oneselfIMID"]);
        model.companyId = @([s intForColumn:@"companyId"]);
        model.receiverID = @([s intForColumn:@"targetId"]);
        model.chatType = @([s intForColumn:@"chatType"]);
        model.content = [s stringForColumn:@"content"];
        model.unreadMsgCount = @([s intForColumn:@"unreadMsgCount"]);
        model.draft = [s stringForColumn:@"draft"];
        model.avatarUrl = [s stringForColumn:@"avatarUrl"];
        model.isHide = @([s intForColumn:@"isHide"]);
        model.clientTimes = @([[s stringForColumn:@"clientTimes"] longLongValue]);
        model.chatFileType = @([s intForColumn:@"msgType"]);
        model.receiverName = [s stringForColumn:@"receiverName"];
        model.isTop = @([s intForColumn:@"isTop"]);
        model.groupPeoples = [s stringForColumn:@"groupPeoples"];
        model.noBother = @([s intForColumn:@"noBother"]);
        
        [records addObject:model];
    }
    
    [db close];
    return records;
}

#pragma mark ++++++++++++++++++++++++++ 会话列表小助手 ++++++++++++++++++++++++++
#pragma mark 创建小助手数据库表
+ (void)createAssistantListTable {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    // 建表，此处图片为blob类型，对应OC可传NSData类型
    [db executeUpdate:[NSString stringWithFormat:@"create table if not exists assistant_table (chatId integer , companyId integer, oneselfIMID integer, chatType integer,receiverName text,content text, clientTimes text, isHide integer, applicationId integer,unreadMsgCount integer, noBother integer, isTop integer, createTime text,avatarUrl text,msgType integer,type integer ,showType text , iconUrl text , iconColor text ,iconType text,uniId text,primary key(uniId))"]];
    
    
    [db close];
}

#pragma mark 插入数据到小助手数据库
+ (BOOL)insertDataIntoAssistantTable:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    // 建表，此处图片为blob类型，对应OC可传NSData类型
    [db executeUpdate:[NSString stringWithFormat:@"create table if not exists assistant_table (chatId integer , companyId integer, oneselfIMID integer, chatType integer,receiverName text,content text, clientTimes text, isHide integer, applicationId integer,unreadMsgCount integer, noBother integer, isTop integer, createTime text,avatarUrl text, msgType integer,type integer, showType text , iconUrl text , iconColor text ,iconType text,uniId text,primary key(uniId))"]];
    
    
    NSString *sql =@"INSERT INTO assistant_table(chatId , companyId, oneselfIMID , chatType ,receiverName ,content , clientTimes , isHide , applicationId ,unreadMsgCount , noBother , isTop , createTime ,avatarUrl ,msgType, type, showType , iconUrl , iconColor ,iconType ,uniId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ,?,?,?,?,?,?,?,?,?)";
    
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.chatId, UM.userLoginInfo.company.id, UM.userLoginInfo.employee.sign_id, model.chatType,model.assistantName,model.latest_push_content,model.latest_push_time, model.isHide, model.application_id ,model.unreadMsgCount, model.noBother,model.isTop,model.create_time,model.avatarUrl,@1,model.type, model.showType , model.icon_url , model.icon_color , model.icon_type,[NSString stringWithFormat:@"%@%@%@",model.companyId,UM.userLoginInfo.employee.sign_id,model.chatId]];
    
    [db close];
    return bResult;
}

#pragma mark 查询所有小助手
+ (id)queryAllAssistantListData {
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chatList.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    [db open];
    
    // 查询数据
    FMResultSet *s = [db executeQuery:[NSString stringWithFormat:@"select * from assistant_table where companyId = %@ and oneselfIMID = %@ ORDER BY clientTimes DESC",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.sign_id]];
    
    NSMutableArray *assistants = [NSMutableArray array];
    
    
    while ([s next]) {
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        // 遍历解析获取到的数据
        model.chatId = @([s intForColumn:@"chatId"]);
        model.companyId = @([s intForColumn:@"companyId"]);
        model.OneselfIMID = @([s intForColumn:@"oneselfIMID"]);
        model.chatType = @([s intForColumn:@"chatType"]);
        model.content = [s stringForColumn:@"content"];
        model.unreadMsgCount = @([s intForColumn:@"unreadMsgCount"]);
        model.noBother = @([s intForColumn:@"noBother"]);
        model.avatarUrl = [s stringForColumn:@"avatarUrl"];
        model.isHide = @([s intForColumn:@"isHide"]);
        model.clientTimes = @([[s stringForColumn:@"clientTimes"] longLongValue]);
        model.application_id = @([s intForColumn:@"applicationId"]);
        model.receiverName = [s stringForColumn:@"receiverName"];
        model.isTop = @([s intForColumn:@"isTop"]);
        model.create_time = @([s intForColumn:@"createTime"]);
        model.chatFileType = @([s intForColumn:@"msgType"]);
        model.type = [s stringForColumn:@"type"];
        model.showType = [s stringForColumn:@"showType"];
        model.icon_url = [s stringForColumn:@"iconUrl"];
        model.icon_color = [s stringForColumn:@"iconColor"];
        model.icon_type = [s stringForColumn:@"iconType"];
        
        [assistants addObject:model];
    }
    
    [db close];
    return assistants;
    
}

#pragma mark 查询未隐藏小助手
+ (id)queryIsNotHidenAssistantListData {
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chatList.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    [db open];
    
    // 查询数据
    FMResultSet *s = [db executeQuery:@"select * from assistant_table WHERE isHide = 0 and companyId = %@ and oneselfIMID = %@",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.sign_id];
    
    NSMutableArray *assistants = [NSMutableArray array];
    
    while ([s next]) {
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        // 遍历解析获取到的数据
        model.chatId = @([s intForColumn:@"chatId"]);
        model.companyId = @([s intForColumn:@"companyId"]);
        model.chatType = @([s intForColumn:@"chatType"]);
        model.content = [s stringForColumn:@"content"];
        model.unreadMsgCount = @([s intForColumn:@"unreadMsgCount"]);
        model.noBother = @([s intForColumn:@"noBother"]);
        model.avatarUrl = [s stringForColumn:@"avatarUrl"];
        model.isHide = @([s intForColumn:@"isHide"]);
        model.clientTimes = @([[s stringForColumn:@"clientTimes"] longLongValue]);
        model.application_id = @([s intForColumn:@"applicationId"]);
        model.receiverName = [s stringForColumn:@"receiverName"];
        model.isTop = @([s intForColumn:@"isTop"]);
        model.create_time = @([s intForColumn:@"createTime"]);
        model.chatFileType = @([s intForColumn:@"msgType"]);
        model.type = [s stringForColumn:@"type"];
        model.showType = [s stringForColumn:@"showType"];
        model.icon_url = [s stringForColumn:@"iconUrl"];
        model.icon_color = [s stringForColumn:@"iconColor"];
        model.icon_type = [s stringForColumn:@"iconType"];
        
        [assistants addObject:model];
    }
    
    [db close];
    return assistants;
    
}

#pragma mark 查询小助手数据
+ (id)queryAssistantListDataWithChatId:(NSNumber *)chatId {
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chatList.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    [db open];
    
    // 查询数据
    FMResultSet *s = [db executeQuery:[NSString stringWithFormat:@"select * from assistant_table where chatId = %@ and companyId = %@ and oneselfIMID = %@ ",chatId,UM.userLoginInfo.company.id,UM.userLoginInfo.employee.sign_id]];
    
    TFFMDBModel *model = [[TFFMDBModel alloc] init];
    while ([s next]) {
        
        // 遍历解析获取到的数据
        model.chatId = @([s intForColumn:@"chatId"]);
        model.companyId = @([s intForColumn:@"companyId"]);
        model.chatType = @([s intForColumn:@"chatType"]);
        model.content = [s stringForColumn:@"content"];
        model.unreadMsgCount = @([s intForColumn:@"unreadMsgCount"]);
        model.noBother = @([s intForColumn:@"noBother"]);
        model.avatarUrl = [s stringForColumn:@"avatarUrl"];
        model.isHide = @([s intForColumn:@"isHide"]);
        model.clientTimes = @([[s stringForColumn:@"clientTimes"] longLongValue]);
        model.application_id = @([s intForColumn:@"applicationId"]);
        model.receiverName = [s stringForColumn:@"receiverName"];
        model.isTop = @([s intForColumn:@"isTop"]);
        model.create_time = @([s intForColumn:@"createTime"]);
        model.chatFileType = @([s intForColumn:@"msgType"]);
        model.type = [s stringForColumn:@"type"];
        model.showType = [s stringForColumn:@"showType"];
        model.icon_url = [s stringForColumn:@"iconUrl"];
        model.icon_color = [s stringForColumn:@"iconColor"];
        model.icon_type = [s stringForColumn:@"iconType"];
        
        
    }
    
    [db close];
    return model;
    
}

#pragma mark 更新小助手
+ (BOOL)updateAssistantListDataWithModel:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE assistant_table set isHide=?, content=?, clientTimes=?, unreadMsgCount=?, isTop=?, iconUrl=? where chatId = %@ and companyId = %@ and oneselfIMID = %@",model.chatId,UM.userLoginInfo.company.id,UM.userLoginInfo.employee.sign_id] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.isHide,model.latest_push_content,model.latest_push_time, model.unreadMsgCount,model.isTop,model.icon_url];
    
    [db close];
    return bResult;
}

#pragma mark 更新小助手未读数
+ (BOOL)updateAssistantListUnReadWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
//    companyId integer, oneselfIMID integer
    NSString *sql = [NSString stringWithFormat:@"UPDATE assistant_table set unreadMsgCount=? where chatId = %@ and companyId = %@ and oneselfIMID = %@",model.chatId, UM.userLoginInfo.company.id, UM.userLoginInfo.employee.sign_id];
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.unreadMsgCount];
    
    [db close];
    return bResult;
}

#pragma mark 设置小助手置顶
+ (BOOL)updateAssistantListIsTopWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE assistant_table set isTop=? where chatId = %@ and companyId = %@ and oneselfIMID = %@",model.chatId, UM.userLoginInfo.company.id, UM.userLoginInfo.employee.sign_id] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.isTop];
    
    [db close];
    return bResult;
}

#pragma mark 设置小助手是否只看未读
+ (BOOL)updateAssistantListShowTypeWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE assistant_table set showType=? where chatId = %@ and companyId = %@ and oneselfIMID = %@",model.chatId,UM.userLoginInfo.company.id, UM.userLoginInfo.employee.sign_id] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.showType];
    
    [db close];
    return bResult;
}

#pragma mark 更新应用小助手图标、颜色、名称
+ (BOOL)updateAssistantListIconAndNameWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE assistant_table set iconUrl = ?,iconColor = ?, iconType = ?, receiverName = ? where chatId = %@ and companyId = %@ and oneselfIMID = %@",model.chatId,UM.userLoginInfo.company.id, UM.userLoginInfo.employee.sign_id] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.icon_url,model.icon_color,model.icon_type,model.application_name];
    
    [db close];
    return bResult;
}

#pragma mark 设置小助手隐藏
+ (BOOL)updateAssistantListIsHideWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE assistant_table set isHide=? where chatId = %@ and companyId = %@ and oneselfIMID = %@",model.chatId, UM.userLoginInfo.company.id, UM.userLoginInfo.employee.sign_id] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.isHide];
    
    [db close];
    return bResult;
}

#pragma mark 删除应用小助手会话
+ (BOOL)deleteAssistantListWithAssistantId:(NSNumber *)assistantId {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"delete from assistant_table where companyId = %@ and oneselfIMID = %@ and chatId = %@",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.sign_id,assistantId] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql];
    
    
    NSString *sql1 = [NSString stringWithFormat:@"delete from chatList_table where companyId = %@ and oneselfIMID = %@ and chatId = %@",[UM.userLoginInfo.company.id description],[UM.userLoginInfo.employee.sign_id description],[assistantId description]] ;
    
    // 执行插入操作
    [db executeUpdate:sql1];
    
    [db close];
    return bResult;
}

#pragma mark 删除聊天室的对应助手的数据
+ (BOOL)deleteChatListWithAssistantId:(NSNumber *)assistantId {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"delete from chatList_table where companyId = %@ and oneselfIMID = %@ and chatId = %@",[UM.userLoginInfo.company.id description],[UM.userLoginInfo.employee.sign_id description],[assistantId description]] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    return bResult;
}


#pragma mark ++++++++++++++++++++++++++ 小助手列表 ++++++++++++++++++++++++++
#pragma mark 创建小助手列表数据库表
+ (void)createSubAssistantDataListTable {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    // 建表，此处图片为blob类型，对应OC可传NSData类型
    [db executeUpdate:[NSString stringWithFormat:@"create table if not exists assistantList_table (id integer , companyId integer, assistantId integer,myId integer,dataId integer, type text, pushContent text,beanName text, beanNameChinese text, oneRowValue text,twoRowValue text,threeRowValue text, createTime text,readStatus text,assistantName text,icon text,style integer, param_fields text,iconUrl text,iconColor text,iconType text)"]];
    
    [db close];
}


#pragma mark 插入数据到小助手列表数据库
+ (BOOL)insertIntoAssistantDataListTable:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    // 建表，此处图片为blob类型，对应OC可传NSData类型
    [db executeUpdate:[NSString stringWithFormat:@"create table if not exists assistantList_table (id integer , companyId integer, assistantId integer,myId integer,dataId integer, type text, pushContent text,beanName text, beanNameChinese text, oneRowValue text,twoRowValue text,threeRowValue text, createTime text,readStatus text,assistantName text,icon text,style integer, param_fields text,iconUrl text,iconColor text,iconType text)"]];
    
    
    NSString *sql =@"INSERT INTO assistantList_table(id, companyId, assistantId, myId, dataId, type, pushContent, beanName , beanNameChinese , oneRowValue ,twoRowValue ,threeRowValue , createTime ,readStatus ,assistantName ,icon ,style, param_fields,iconUrl,iconColor,iconType) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ,?, ?, ?, ?, ?, ? ,?, ?, ?)";
    
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.id, UM.userLoginInfo.company.id,model.assistantId,model.myId,model.dataId,model.type, model.pushContent, model.beanName ,model.beanNameChinese, model.oneRowValue,model.twoRowValue,model.threeRowValue,model.create_time,model.readStatus,model.assistantName,model.icon,model.style,model.param_fields,model.icon_url,model.icon_color,model.icon_type];
    
    [db close];
    return bResult;
}


#pragma mark 查询对应小助手列表数据 (分页查询)
+ (id)queryAssistantDataListWithAssistantId:(NSNumber *)assistantId beanName:(NSString *)beanName pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize showType:(NSString *)showType {

    NSInteger size = [pageSize integerValue];
    NSInteger num = [pageNum integerValue];
    NSInteger page = size*(num-1);
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chatList.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    [db open];
    
    // 查询数据
//    FMResultSet *s = [db executeQuery:@"select * from assistantList_table where companyId = %@ and myId = %@ and assistantId = %@",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.id,assistantId];
    
    FMResultSet *s;
    if ([showType isEqualToString:@"1"]) {
//        SELECT DISTINCT(clientTimes), chatId, oneselfIMID, companyId, targetId, chatType, content, unreadMsgCount, draft, avatarUrl, isHide, clientTimes, msgType, receiverName, noBother, rand, isTop, groupPeoples FROM chatList_table WHERE companyId = %@ AND oneselfIMID = %@ ORDER BY isTop DESC, clientTimes DESC
        NSString *sql = [NSString stringWithFormat:@"select DISTINCT(createTime),id, companyId, assistantId, myId, dataId, type, pushContent, beanName , beanNameChinese , oneRowValue ,twoRowValue ,threeRowValue , createTime ,readStatus ,assistantName ,icon ,style, param_fields,iconUrl,iconColor,iconType from assistantList_table where companyId = %@ and myId = %@ and assistantId = %@ and readStatus = %@ ORDER BY createTime DESC LIMIT %ld OFFSET %ld",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.id,assistantId,@"0",size,page];
        
        s = [db executeQuery:sql];
    }
    else {
        
        if ([beanName isEqualToString:@""] || beanName == nil) {
            NSString *sql = [NSString stringWithFormat:@"select * from assistantList_table where companyId = %@ and myId = %@ and assistantId = %@ ORDER BY createTime DESC LIMIT %ld OFFSET %ld",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.id,assistantId,size,page];
            s = [db executeQuery:sql];
        }
        else {
            NSString *sql = [NSString stringWithFormat:@"select * from assistantList_table where companyId = %@ and myId = %@ and assistantId = %@ and beanName = %@ ORDER BY createTime DESC LIMIT %ld OFFSET %ld",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.id,assistantId,[NSString stringWithFormat:@"'%@'",beanName],size,page];
            s = [db executeQuery:sql];
        }
    }
    
    NSMutableArray *assistants = [NSMutableArray array];
    
    while ([s next]) {
//        id, companyId, assistantId, myId, dataId, type, pushContent, beanName , beanNameChinese , oneRowValue ,twoRowValue ,threeRowValue , createTime ,readStatus ,assistantName ,icon ,style
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        // 遍历解析获取到的数据
        model.id = @([s intForColumn:@"id"]);
        model.companyId = @([s intForColumn:@"companyId"]);
        model.assistantId = @([s intForColumn:@"assistantId"]);
        model.myId = @([s intForColumn:@"myId"]);
        model.dataId = @([s intForColumn:@"dataId"]);
        model.type = [s stringForColumn:@"type"];
        model.pushContent = [s stringForColumn:@"pushContent"];
        model.beanName = [s stringForColumn:@"beanName"];
        model.beanNameChinese = [s stringForColumn:@"beanNameChinese"];
        model.oneRowValue = [s stringForColumn:@"oneRowValue"];
        model.twoRowValue = [s stringForColumn:@"twoRowValue"];
        model.threeRowValue = [s stringForColumn:@"threeRowValue"];
        model.create_time = @([[s stringForColumn:@"createTime"] longLongValue]);
        model.readStatus = [s stringForColumn:@"readStatus"];
        model.assistantName = [s stringForColumn:@"assistantName"];
        model.icon = [s stringForColumn:@"icon"];
        model.style = @([s intForColumn:@"style"]);
        model.param_fields = [s stringForColumn:@"param_fields"];
        model.icon_url = [s stringForColumn:@"iconUrl"];
        model.icon_color = [s stringForColumn:@"iconColor"];
        model.icon_type = [s stringForColumn:@"iconType"];
        
        [assistants addObject:model];
    }
    
    [db close];
    return assistants;
    
}

#pragma mark 查询小助手列表内容数据 (搜索)
+ (id)queryAssistantDataListWithKeywordForSearch:(NSString *)keyword assistantId:(NSNumber *)assistantId {
 
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chatList.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    [db open];
    
    // 查询数据
    FMResultSet *s = [db executeQuery:[NSString stringWithFormat:@"select * from assistantList_table where (pushContent LIKE '%@%@%@' or oneRowValue LIKE '%@%@%@' or twoRowValue LIKE '%@%@%@' or threeRowValue LIKE '%@%@%@') and companyId = %@ and myId = %@ and assistantId = %@",@"%",keyword,@"%",@"%",keyword,@"%",@"%",keyword,@"%",@"%",keyword,@"%",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.id,assistantId]];
    NSMutableArray *assistants = [NSMutableArray array];
    
    while ([s next]) {
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        // 遍历解析获取到的数据
        model.id = @([s intForColumn:@"id"]);
        model.companyId = @([s intForColumn:@"companyId"]);
        model.assistantId = @([s intForColumn:@"assistantId"]);
        model.myId = @([s intForColumn:@"myId"]);
        model.dataId = @([s intForColumn:@"dataId"]);
        model.type = [s stringForColumn:@"type"];
        model.pushContent = [s stringForColumn:@"pushContent"];
        model.beanName = [s stringForColumn:@"beanName"];
        model.beanNameChinese = [s stringForColumn:@"beanNameChinese"];
        model.oneRowValue = [s stringForColumn:@"oneRowValue"];
        model.twoRowValue = [s stringForColumn:@"twoRowValue"];
        model.threeRowValue = [s stringForColumn:@"threeRowValue"];
        model.create_time = @([[s stringForColumn:@"createTime"] longLongValue]);
        model.readStatus = [s stringForColumn:@"readStatus"];
        model.assistantName = [s stringForColumn:@"assistantName"];
        model.icon = [s stringForColumn:@"icon"];
        model.style = @([s intForColumn:@"style"]);
        model.param_fields = [s stringForColumn:@"param_fields"];
        model.icon_url = [s stringForColumn:@"iconUrl"];
        model.icon_color = [s stringForColumn:@"iconColor"];
        model.icon_type = [s stringForColumn:@"iconType"];
        
        [assistants addObject:model];
    }
    
    [db close];
    return assistants;
    
}

#pragma mark 小助手最新一条数据时间戳
/** 查小助手最新一条数据时间戳 */
+ (id)queryAssistantDataListLastTime:(NSNumber *)assistantId {
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chatList.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    [db open];
    
    // 查询数据
    NSString *str = [NSString stringWithFormat:@"select * from assistantList_table where companyId = %@ and myId = %@ and assistantId = %@ order by createTime desc limit 1",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.id,assistantId];
    
    FMResultSet *s = [db executeQuery:str];
    
    TFFMDBModel *model = [[TFFMDBModel alloc] init];
    
    while ([s next]) {
        // 遍历解析获取到的数据
        
        model.create_time = @([[s stringForColumn:@"createTime"] longLongValue]);

    }
    
    [db close];
    return model;
    
}

#pragma mark 小助手最旧一条数据时间戳
+ (id)queryAssistantDataListFirstTime:(NSNumber *)assistantId {
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"chatList.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    [db open];
    
    // 查询数据
    NSString *str = [NSString stringWithFormat:@"select * from assistantList_table where companyId = %@ and myId = %@ and assistantId = %@ order by createTime ASC limit 1",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.id,assistantId];
    
    FMResultSet *s = [db executeQuery:str];
    
    TFFMDBModel *model = [[TFFMDBModel alloc] init];
    
    while ([s next]) {
        // 遍历解析获取到的数据
        
        model.create_time = @([[s stringForColumn:@"createTime"] longLongValue]);
        
    }
    
    [db close];
    return model;
    
}

#pragma mark 更新小助手列表数据已读未读状态
+ (BOOL)updateAssistantListDataIsReadWithData:(TFAssistantPushModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE assistantList_table set readStatus=? where companyId = %@ and myId = %@ and id = %@",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.id,model.data_id] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.push_content];
    
    [db close];
    return bResult;
}

#pragma mark 更新小助手列表数据全部已读
+ (BOOL)updateAssistantListDataAllReadWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE assistantList_table set readStatus=? where companyId = %@ and myId = %@ and assistantId = %@ ",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.id,model.assistantId] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, @"1"];
    
    [db close];
    return bResult;
}


#pragma mark 更新小助手列表模块图标和模块名称
+ (BOOL)updateAssistantListModuleIconWithData:(TFFMDBModel *)model {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE assistantList_table set iconUrl=?,iconColor = ?, iconType = ?,beanNameChinese = ? where companyId = %@ and myId = %@ and assistantId = %@ ",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.id,model.assistantId] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql, model.icon_url,model.icon_color,model.icon_type,model.beanNameChinese];
    
    [db close];
    return bResult;
}


#pragma mark 清除本地小助手列表的表数据
+ (BOOL)deleteAssistantListDataWithAssistantId:(NSNumber *)assistantId {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"delete from assistantList_table where companyId = %@ and myId = %@ and assistantId = %@",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.id,assistantId] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    return bResult;
}

#pragma mark 清除本账号所有本地小助手列表的表数据
+ (BOOL)deletePersonAssistantListAllData {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    // 打开
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"delete from assistantList_table where companyId = %@ and myId = %@ ",UM.userLoginInfo.company.id,UM.userLoginInfo.employee.id] ;
    
    // 执行插入操作
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    return bResult;
}


#pragma mark ++++++++++++++++++++++++++ 常用联系人 ++++++++++++++++++++++++++
#pragma mark 创建常用联系人表
+ (void)createCallWithData:(TFFMDBModel *)model {
    
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatList.db"];
    // 创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    HQLog(@"path005:%@",path);
    // 打开
    [db open];
    
    // 建表，此处图片为blob类型，对应OC可传NSData类型
    [db executeUpdate:[NSString stringWithFormat:@"create table if not exists call_table (targetId integer, receiverName text, avatarUrl text,clientTimes text)"]];
    
    [db close];
}

@end
