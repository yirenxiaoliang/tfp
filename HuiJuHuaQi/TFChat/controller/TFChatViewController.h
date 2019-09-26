//
//  ViewController.h
//  ChatTest
//
//  Created by Season on 2017/5/15.
//  Copyright © 2017年 Season. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCell.h"
#import "HQBaseViewController.h"

@interface TFChatViewController : HQBaseViewController

/**
 聊天类型 2:单聊 1:群聊
 */
@property(nonatomic,assign)NSInteger cmdType;

/**
 聊天id
 */
@property(nonatomic,strong)NSNumber *chatId;

/**
 聊天对象id
 */
@property (nonatomic, assign) int64_t receiveId;

/**
 其他模块文件发送到聊天
 */
@property (nonatomic, assign) BOOL isSendFromFileLib;

/** 转发 */
@property (nonatomic, assign) BOOL isTransitive;

/** 直接发送的文件信息 */
@property (nonatomic, strong) TFFileModel *fileModel;

/**  */
@property (nonatomic, strong) TFFMDBModel *dbModel;

/** 是否创建群 0:不是 1:是 */
@property (nonatomic, assign) NSInteger isCreateGroup;

/** 建群提示信息 */
@property (nonatomic, copy) NSString *tipContent;

/** 草稿 */
@property (nonatomic, copy) NSString *draft;

/**
 文字表情输入框
 */
@property(nonatomic,strong)UITextView *inputTV;

/**
 名称
 */
@property (nonatomic, copy) NSString *naviTitle;


/** 头像 */
@property (nonatomic, copy) NSString *picture;

/**
 消息记录数组
 */
@property(nonatomic,strong)NSMutableArray *chatRecords;

/**
 消息中所有图片
 */
@property(nonatomic,strong)NSMutableArray *images;


/**
 消息列表控件
 */
@property(nonatomic,strong)UITableView *messagesTable;


/**
 “+”展示更多操作按钮
 */
@property(nonatomic,strong)UIButton *moreBtn;

/**
 语音录制按钮
 */
@property(nonatomic,strong)UIButton *voiceBtn;

/**
 长按录制按钮
 */
@property(nonatomic,strong)UIButton *recordingBtn;
//消息未读数
@property (nonatomic, strong) NSNumber <Optional>*unreadMsgCount;

@end

