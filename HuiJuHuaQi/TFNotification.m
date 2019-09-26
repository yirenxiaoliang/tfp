//
//  TFNotification.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNotification.h"

@implementation TFNotification

/** 登录极光通知 */
NSString * const JPushLoginNotifition = @"JPushLoginNotifition";
/** 推出极光通知 */
NSString * const JPushLogoutNotifition = @"JPushLogoutNotifition";

/** 项目任务详情中点击输入框跳转 */
NSString * const TFProjectTaskInputJumpNotifition = @"TFProjectTaskInputJumpNotifition";

/** 动态下拉跳转 */
NSString * const TFProjectDynamicDownJumpNotifition = @"TFProjectDynamicDownJumpNotifition";

/** 正常状态 */
NSString * const TFProjectDynamicNormalpNotifition = @"TFProjectDynamicNormalpNotifition";

/** 任务详情中更多操作通知 */
NSString * const TaskDetailMoreHandleNotifition = @"TaskDetailMoreHandleNotifition";

/** 审批详情中更多操作通知 */
NSString * const ApprovalDetailMoreHandleNotifition = @"ApprovalDetailMoreHandleNotifition";

/** 任务动态中点击心按钮通知 */
NSString * const TaskDynamicClickedHeartNotifition = @"TaskDynamicClickedHeartNotifition";

/** 主页tableView滚动通知 */
NSString * const WorkBenchMainTableViewScrollNotifition = @"WorkBenchMainTableViewScrollNotifition";

/** 主页子tableView滚动通知 */
NSString * const WorkBenchChildTableViewScrollNotifition = @"WorkBenchChildTableViewScrollNotifition";

/* 删除任务通知 */
NSString * const DeleteProjetTaskNotifition = @"DeleteProjetTaskNotifition";

/* 任务详情点赞选中通知 */
NSString * const ProjetTaskHeartNotifition = @"ProjetTaskHeartNotifition";

/* 删除聊天回话通知 */
NSString * const DeleteChatConversationNotifition = @"DeleteChatConversationNotifition";

/* 退群通知 */
NSString * const QuitGroupConversationNotifition = @"QuitGroupConversationNotifition";

/* 随手记主界面创建笔记 */
NSString * const NoteMainInterfaceCreateNote = @"NoteMainInterfaceCreateNote";

/* 随手记列表刷新通知 */
NSString * const NoteListRefreshNotification = @"NoteListRefreshNotification";

/* 创建审批成功 */
NSString * const CreateApprovalSuccessNotifition = @"CreateApprovalSuccessNotifition";

/* 助手待处理消息清空 */
NSString * const AssistantMessageClearNotifitoin = @"AssistantMessageClearNotifitoin";

/** 免打扰通知 */
NSString * const IsDisturbNotifition = @"IsDisturbNotifition";


/** 极光用户登录成功通知 */
NSString * const JMessageUserLoginSuccessNotifition = @"JMessageUserLoginSuccessNotifition";

/** 通知会话列表刷新 */
NSString * const ConversationListRefreshWithNotification = @"ConversationListRefreshWithNotification";

/** socket账户登录成功 */
NSString * const TeamFaceSocketLoginSuccessNotification = @"TeamFaceSocketLoginSuccessNotification";

/** 通知会话列表刷新 */
NSString * const RefreshChatListWithNotification = @"RefreshChatListWithNotification";

/** 刷新聊天室 */
NSString * const RefreshChatRoomDataWithNotification = @"RefreshChatRoomDataWithNotification";

/** 单聊已读通知 */
NSString * const SingleChatReadNotification = @"SingleChatReadNotification";
/** 群聊已读通知 */
NSString * const GroupChatReadNotification = @"GroupChatReadNotification";
/** 单聊发送成功通知，收到ack */
NSString * const SingleChatSendSuccessNotification = @"SingleChatSendSuccessNotification";
/** 群聊发送成功通知，收到ack */
NSString * const GroupChatSendSuccessNotification = @"GroupChatSendSuccessNotification";
/** 撤销消息通知 */
NSString * const RevocationChatNotification = @"RevocationChatNotification";

/** 登录或切换公司后socket连接通知 */
NSString * const ChangeCompanySocketConnect = @"ChangeCompanySocketConnect";

/** 公司组织架构变化 */
NSString * const CompanyFrameworkChange = @"CompanyFrameworkChange";

/** 全选通知 */
NSString * const AllSelectPeopleNotification = @"AllSelectPeopleNotification";
/** 选人刷新通知 */
NSString * const SelectPeopleRefreshNotification = @"SelectPeopleRefreshNotification";

/** 新文件库 */
NSString *const FileLibraryRenameNotification = @"FileLibraryRenameNotification";


NSString *const MoveFileSuccessNotification = @"MoveFileSuccessNotification";

#pragma mark 小助手通知
/** 会话列表更新助手通知 */
NSString *const AssistantUnreadNotification = @"AssistantUnreadNotification";



NSString *const deleteCell = @"deleteCellNotification";
NSString *const addCell = @"addCellNotification";

/** 解散群通知 */
NSString *const ReleaseGroupNotification = @"ReleaseGroupNotification";

/** 修改群名称通知 */
NSString *const ModifyGroupNameNotification = @"ModifyGroupNameNotification";

/** 更新小助手列表数据通知 */
NSString *const UpdateAssistantListDataNotification = @"UpdateAssistantListDataNotification";

/** 项目任务移动 */
NSString * const ProjectTaskMoveNotification = @"ProjectTaskMoveNotification";

/** 项目搜索结束 */
NSString * const ProjectSearchReturnNotification = @"ProjectSearchReturnNotification";

/** 项目搜索后滚动 */
NSString * const ProjectSearchScrollNotification = @"ProjectSearchScrollNotification";

/** 任务筛选通知 */
NSString * const TaskSearchReturnNotification = @"TaskSearchReturnNotification";

/** 自定义详情高度通知 */
NSString * const CustomDetailHeightNotification = @"CustomDetailHeightNotification";

/** 项目任务筛选通知 */
NSString * const ProjectTaskFilterNotification = @"ProjectTaskFilterNotification";

/** 项目三级展开通知 */
NSString * const ProjectRowTableViewHideNotification = @"ProjectRowTableViewHideNotification";

@end
