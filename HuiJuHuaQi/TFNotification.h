//
//  TFNotification.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFNotification : NSObject

/** 登录极光通知 */
extern NSString * const JPushLoginNotifition;
/** 推出极光通知 */
extern NSString * const JPushLogoutNotifition;


/** 项目任务详情中点击输入框跳转 */
extern NSString * const TFProjectTaskInputJumpNotifition;

/** 动态下拉跳转 */
extern NSString * const TFProjectDynamicDownJumpNotifition;

/** 正常状态 */
extern NSString * const TFProjectDynamicNormalpNotifition;

/** 任务详情中更多操作通知 */
extern NSString * const TaskDetailMoreHandleNotifition;

/** 审批详情中更多操作通知 */
extern NSString * const ApprovalDetailMoreHandleNotifition;

/** 任务动态中点击心按钮通知 */
extern NSString * const TaskDynamicClickedHeartNotifition;

/** 主页tableView滚动通知 */
extern NSString * const WorkBenchMainTableViewScrollNotifition;

/** 主页子tableView滚动通知 */
extern NSString * const WorkBenchChildTableViewScrollNotifition;

/* 删除任务通知 */
extern NSString * const DeleteProjetTaskNotifition;

/* 任务详情点赞选中通知 */
extern NSString * const ProjetTaskHeartNotifition;

/* 删除聊天回话通知 */
extern NSString * const DeleteChatConversationNotifition;

/* 退群通知 */
extern NSString * const QuitGroupConversationNotifition;

/* 随手记主界面创建笔记 */
extern NSString * const NoteMainInterfaceCreateNote;

/* 随手记列表刷新通知 */
extern NSString * const NoteListRefreshNotification;

/* 创建审批成功 */
extern NSString * const CreateApprovalSuccessNotifition;

/* 助手待处理消息清空 */
extern NSString * const AssistantMessageClearNotifitoin;

/** 免打扰通知 */
extern NSString * const IsDisturbNotifition;

/** 极光用户登录成功通知 */
extern NSString * const JMessageUserLoginSuccessNotifition;

/** 通知会话列表刷新 */
extern NSString * const ConversationListRefreshWithNotification;

/** socket账户登录成功 */
extern NSString * const TeamFaceSocketLoginSuccessNotification;

extern NSString * const RefreshChatListWithNotification;

extern NSString * const RefreshChatRoomDataWithNotification;

/** 单聊已读通知 */
extern NSString * const SingleChatReadNotification;
/** 群聊已读通知 */
extern NSString * const GroupChatReadNotification;
/** 单聊发送成功通知，收到ack */
extern NSString * const SingleChatSendSuccessNotification;
/** 群聊发送成功通知，收到ack */
extern NSString * const GroupChatSendSuccessNotification;
/** 撤销消息通知 */
extern NSString * const RevocationChatNotification;

/** 登录或切换公司后socket连接通知 */
extern NSString * const ChangeCompanySocketConnect;
/** 公司组织架构变化 */
extern NSString * const CompanyFrameworkChange;


/** 全选通知 */
extern NSString * const AllSelectPeopleNotification;
/** 选人刷新通知 */
extern NSString * const SelectPeopleRefreshNotification;

/** 新文件库 */
extern NSString * const FileLibraryRenameNotification;

extern NSString * const MoveFileSuccessNotification;

#pragma mark 小助手
/** 会话列表更新助手通知 */
extern NSString * const AssistantUnreadNotification;

extern NSString *const deleteCell ;
extern NSString *const addCell ;

/** 解散群通知 */
extern NSString * const ReleaseGroupNotification;

/** 修改群名称通知 */
extern NSString * const ModifyGroupNameNotification;

/** 更新小助手列表数据通知 */
extern NSString * const UpdateAssistantListDataNotification;

/** 项目任务移动 */
extern NSString * const ProjectTaskMoveNotification;

/** 项目搜索结束 */
extern NSString * const ProjectSearchReturnNotification;

/** 项目搜索后滚动 */
extern NSString * const ProjectSearchScrollNotification;

/** 任务筛选通知 */
extern NSString * const TaskSearchReturnNotification;

/** 自定义详情高度通知 */
extern NSString * const CustomDetailHeightNotification;

/** 项目任务筛选通知 */
extern NSString * const ProjectTaskFilterNotification;

/** 项目三级展开通知 */
extern NSString * const ProjectRowTableViewHideNotification;

@end
