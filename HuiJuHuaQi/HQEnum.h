//
//  HQEnum.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/11.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#ifndef HQEnum_h
#define HQEnum_h

typedef enum{
    TypeNormal,
    TypeOther
}Type;

typedef enum {
    ProjectSeeBoardTypeProject,
    ProjectSeeBoardTypeCrm
}ProjectSeeBoardType;

typedef enum {
    LocationTypeSelectLocation,// 选择位置
    LocationTypeLookLocation,  // 查看位置
    LocationTypeSearchLocation, // 搜索位置
    LocationTypeHideLocation // 隐形定位位置
    
}LocationType;

typedef enum {
    FileTypeImage  = 0,         // 图片
    FileTypeVideo  = 1,         // 视频
    FileTypeMusic = 2,         // 音乐
    FileTypeNotFile = 3,        // 非文件
}ChatFileType;

typedef enum {
    DateViewType_YearMonthDayHourMinute,         // 年月日时分
    DateViewType_YearMonthDay,         // 年月日
    DateViewType_YearMonth,         // 年月
    DateViewType_Year,         // 年
    DateViewType_HourMinuteSecond,         // 时分秒
    DateViewType_HourMinute,         // 时分
    DateViewType_Hour,         // 时
    
}DateViewType;

typedef enum {
    
    /******************  文件上传  ************************/
    HQCMD_uploadFile = 1,// 模块上传
    HQCMD_ImageFile, // 初始化
    HQCMD_ChatFile, // 初始化
    
    /******************  登录注册  ************************/
    HQCMD_userNewRegister,       // 新注册
    HQCMD_userRegister,          // 注册
    HQCMD_userLogin,             // 登录
    HQCMD_scanCodeSubmit,        // 扫码提交
    HQCMD_modifyPassWord,        // 修改密码
    HQCMD_verifyIsExist,         // 验证用户存在
    HQCMD_sendVerifyCode,        // 验证码
    HQCMD_verifyVerificationCode,// 验证验证码
    HQCMD_initData,              // 首次登陆初始化用户数据
    HQCMD_companyAdd,           //  完善企业信息/新建企业
    HQCMD_getCompanyAndEmploee,  //  登录之后或切换公司时获取公司、 ...
    HQCMD_setupCompanyInfo, // 初始化公司信息
    HQCMD_setupEmployeeInfo, // 初始化员工信息
    HQCMD_getCompanyList,  // 公司列表
    HQCMD_changeCompany, // 切换公司
    HQCMD_getEmployeeAndCompanyInfo, // 登陆后获取员工和公司
    HQCMD_getEmployeeInfo, // 获取员工详情
    HQCMD_queryEmployeeInfo, //员工详情
    HQCMD_empWhetherFabulous, //员工点赞
    
    /** ********************** 权限 *********************** */
    HQCMD_getEmployeeRole,     // 获取员工角色
    HQCMD_getRoleAuth,     // 获取角色权限
    HQCMD_getEmployeeModuleAuth, // 获取员工模块权限
    HQCMD_getModuleFunctionAuth, // 获取模块功能权限
    
    /*****************  自定义  ***********************/
    HQCMD_customLayout, // 获取自定义布局
    HQCMD_customTaskLayout,// 获取自定义任务布局
    HQCMD_saveTaskLayoutData,// 保存项目任务信息
    HQCMD_savePersonnelData,// 保存个人任务信息
    HQCMD_customApplicationList, // 获取自定义应用列表
    HQCMD_customApplicationOften, // 获取自定义应用列表
    HQCMD_customSave, // 自定义保存
    HQCMD_customDelete, // 自定义删除
    HQCMD_customEdit, // 自定义编辑
    HQCMD_customDetail, // 自定义详情
    HQCMD_customDataList, // 数据列表
    HQCMD_customChildMenuList,// 获取子菜单列表
    HQCMD_customRefernceSearch, // 关联搜索
    HQCMD_customChecking, // 查重
    HQCMD_customFilterFields, // 筛选条件
    HQCMD_customRefernceModule, // 关联模块
    HQCMD_customModuleAuth,// 模块功能
    HQCMD_customTransferPrincipal, // 转移负责人
    HQCMD_customShareList, // 共享设置列表
    HQCMD_customShareDelete, // 删除某个共享设置
    HQCMD_customShareSave, // 保存模块设置
    HQCMD_customShareEdit, // 编辑模块设置
    HQCMD_customModuleChangeList, // 模块转换列表
    HQCMD_customModuleChange,// 模块转换
    HQCMD_customCommentSave,// 评论
    HQCMD_customCommentList, // 评论列表
    HQCMD_customDynamicList, // 动态列表
    HQCMD_customApprovalList,// 审批列表
    HQCMD_getApprovalListWithBean,// 某模块下的审批数据
    HQCMD_customApprovalSearchMenu,// 筛选条件
    HQCMD_customApprovalWholeFlow,// 审批流程
    HQCMD_customApprovalPass,// 审批通过
    HQCMD_customApprovalReject,// 审批驳回
    HQCMD_customApprovalTransfer,// 审批转交
    HQCMD_customApprovalRevoke,// 审批撤销
    HQCMD_customApprovalCopy,// 审批抄送
    HQCMD_customApprovalUrge,// 审批催办
    HQCMD_customApprovalRead,// 已读
    HQCMD_customApprovalCount,// 数量
    HQCMD_customApprovalRejectType,// 驳回方式
    HQCMD_customApprovalPassType,// 通过方式
    HQCMD_customRemoveProcessApproval,// 删除审批
    HQCMD_CustomQueryApprovalData, //获取审批详情参数
    HQCMD_highseaTake,// 公海池领取
    HQCMD_highseaMove,// 公海池移动
    HQCMD_highseaBack,// 公海池退回
    HQCMD_highseaAllocate,// 公海池分配
    HQCMD_highseaList,// 公海池列表
    HQCMD_getReportList,// 统计列表
    HQCMD_getReportFilterFields,// 报表筛选字段
    HQCMD_getReportFilterFieldsWithReportId,// 报表筛选字段
    HQCMD_getReportDetail,// 报表详情
    HQCMD_getChartDetail,// 报表详情
    HQCMD_getReportLayoutDetail,// 报表布局详情
    HQCMD_getChartList,// 图标列表
    HQCMD_CustomApprovalCheckChooseNextApproval,//是否需要选择下一审批人（邮件）
    HQCMD_allApplications,// 获取应用
    HQCMD_allModules,// 获取应用下的模块
    HQCMD_saveOftenModule,// 保存常用模块
    HQCMD_moduleHaveAuth,// 某个模块是否有权限
    HQCMD_moduleHaveReadAuth,// 阅读权限
    HQCMD_customRangePeople,// 自定义人员选择范围
    HQCMD_customRangeDepartment,// 自定义部门选择范围
    HQCMD_quickAdd,// 快速新增
    HQCMD_createBarcode,// 生成条形码
    HQCMD_barcodeDetail,// 条形码详情
    HQCMD_barcodePicture,// 条形码图片
    HQCMD_getCustomConditionField,// 获取某模块数据条件字段列表
    HQCMD_getLinkageFieldList,// 条件字段value变更触发获取联动字段列表和value
    HQCMD_getSystemStableModule,// 获取系统固定模块
    HQCMD_getAutoMatchModuleList,// 获取自动匹配模块列表
    HQCMD_getAutoMatchModuleDataList,// 获取自动匹配模块数据列表
    HQCMD_getAutoMatchModuleRuleList,// 获取自动匹配模块规则列表
    HQCMD_getAutoMatchModuleRuleDataList,// 获取自动匹配模块规则下的数据列表
    HQCMD_getTabList,// 页签列表
    HQCMD_getTabDataList,// 获取页签下的数据列表
    HQCMD_getReferanceReflect,// 获取关联页签下新建获取关联映射字段值
    HQCMD_getWebLinkList,// 获取web链接列表
    HQCMD_workEnterShow,// 工作台显示模块
    HQCMD_workEnterAllModule,// 工作台所有模块
    HQCMD_subformRelation,// 子表关联
    HQCMD_resumeFile,// 简历解析
    HQCMD_checkApprovalTime,// 检查审批时间重合
    
    /*****************  公告  ***********************/
    
    
    /*****************  企信  ***********************/
    HQCMD_messageGetBasicGroup, // 公司总群和小秘书
    HQCMD_messageGetAssistList, // 助手列表
    HQCMD_messageGetAssistDetail, // 助手详情
    HQCMD_messageModifyHandle, //  更改助手处理状态
    HQCMD_messageModifyRead, // 更改助手已读状态
    HQCMD_messageModifyTop, // 置顶
    HQCMD_messageClearHandle, // 助手待处理数据的清空
    HQCMD_messageModifyAssistantSetData, //	修改助手设置
    HQCMD_messageGetEmployee, // 极光用户获取员工
    HQCMD_messageModToAllRead, // 未读页面数据全部变为已读
    HQCMD_messageGetAssistSetData, // 获取助手设置信息
    HQCMD_messageAddGroup, // 创建群组
    HQCMD_messageGroupList, // 群列表
    
    /*****************  企信  ***********************/
    
    HQCMD_getChatListInfo, //企信会话列表
    HQCMD_addGroupChat, //创建群聊
    HQCMD_addSingleChat, //单聊
    HQCMD_getAllGroupsInfo, //所有群组
    HQCMD_getSingleInfo, //单聊设置
    HQCMD_getGroupInfo, //群聊设置
    HQCMD_setTopChat, //置顶
    HQCMD_setNoBother, //免打扰
    HQCMD_quitChatGroup, //退群
    HQCMD_releaseGroup, //解散群
    HQCMD_pullPeople, //拉人
    HQCMD_kickPeople, //踢人
    HQCMD_hideSession, //删除列表数据
    HQCMD_getAssistantMessage, //小助手列表
    HQCMD_getAssistantInfo, //获取小助手设置相关信息
    HQCMD_findModuleList, //
    HQCMD_markAllRead, //全部标为已读
    HQCMD_modifyGroupInfo, //修改群信息
    HQCMD_imChatTransferGroup, //转让群主
    HQCMD_readMessage, //小助手读取
    HQCMD_markReadOption,//标记小助手已读未读
    HQCMD_getAuthByBean, //权限
    HQCMD_queryAidePower, //文件库助手权限
    HQCMD_getFuncAuthWithCommunal, //小助手列表权限判断
    HQCMD_HideSessionWithStatus,
    HQCMD_getAssistantMessageLimit,
    HQCMD_employeeFindEmployeeVague, //人员搜索
    
    /************************ 新文件库 ************************/
    HQCMD_queryfileCatalog, //菜单列表
    
    HQCMD_savaFileLibrary, //创建文件夹
    
    HQCMD_queryCompanyList, //根目录列表
    
    HQCMD_delFileLibrary, //删除文件／文件夹
    
    HQCMD_editFolder, //管理文件夹
    
    HQCMD_queryCompanyPartList, //子文件夹列表
    
    HQCMD_shiftFileLibrary, //移动文件夹
    
    HQCMD_queryFolderInitDetail, //获取根目录信息
    
    HQCMD_fileLibraryUpload, //文件库文件上传
    
    HQCMD_FileVersionUpload, //上传新版本
    
    HQCMD_queryManageById, //获取管理员列表
    
    HQCMD_savaManageStaff, //添加管理员
    
    HQCMD_fileDownload, //下载文件
    
    HQCMD_queryFileLibarayDetail, //文件详情
    
    HQCMD_queryDownLoadList, //下载记录
    
    HQCMD_queryVersionList, //历史版本
    
    HQCMD_shareFileLibaray, //共享
    
    HQCMD_cancelShare, //取消共享
    
    HQCMD_quitShare, //退出共享
    
    HQCMD_whetherFabulous, //点赞
    
    HQCMD_blurSearchFile, //搜索记录
    
    HQCMD_getBlurResultParentInfo, //搜索
    
    HQCMD_editRename, //重命名
    
    HQCMD_delManageStaff, //删除管理员
    
    HQCMD_savaMember, //添加成员
    
    HQCMD_delMember, //删除成员
    
    HQCMD_updateSetting, //成员权限
    
    HQCMD_copyFileLibrary, //复制文件
    
    HQCMD_downloadCompressedPicture, //缩略图
    
    HQCMD_downloadHistoryFile, //下载历史版本
    
    HQCMD_queryAppFileList, //应用文件夹根目录
    
    HQCMD_queryModuleFileList, //应用模块文件夹
    
    HQCMD_queryModulePartFileList, //应用模块下文件
    
    HQCMD_projectLibraryQueryProjectLibraryList, //项目文件项目列表
    
    HQCMD_fileAdministrator,// 文件库管理员
    
    /*****************  邮件  ***********************/
    HQCMD_mailOperationSend, //发送邮件
    
    HQCMD_queryPersonnelAccount, //获取个人有效账号
    
    HQCMD_queryMailList, //邮件列表
    
    HQCMD_markAllMailRead, // 全部标为已读
    
    HQCMD_markMailReadOrUnread, //标为未读
    
    HQCMD_mailContactQueryList, //最近联系人（邮件）
    
    HQCMD_mailCatalogQueryList, //邮件通讯录
    
    HQCMD_mailOperationQueryList, //获取邮件列表
    
    HQCMD_mailOperationQueryById, //邮件详情
    
    HQCMD_mailOperationSaveToDraft, //邮箱草稿
    
    HQCMD_mailOperationQueryUnreadNumsByBox, //不同邮箱未读数
    
    HQCMD_moduleEmailGetModuleEmails, //获取模块联系人
    
    HQCMD_moduleEmailGetModuleSubmenus, //
    HQCMD_customEmailList,// 自定义邮件列表
    
    HQCMD_mailOperationMailReply, //邮件回复
    
    HQCMD_mailOperationMailForward, //邮件转发
    
    HQCMD_moduleEmailGetEmailFromModuleDetail, //邮件模块选择
    
    HQCMD_mailOperationDeleteDraft, //删除草稿
    
    HQCMD_mailOperationClearMail, //彻底删除
    
    HQCMD_mailOperationMarkNotTrash, //标记不是垃圾邮件
    
    HQCMD_mailOperationEditDraft, //编辑草稿
    
    HQCMD_mailOperationManualSend, //手动发送
    
    HQCMD_mailOperationReceive, //收信
    
    /*****************  企业圈  ***********************/
    HQCMD_companyCircleAdd, // 添加一条企业圈动态
    HQCMD_companyCircleUp,  // 点赞
    HQCMD_companyCircleComment, // 评论
    HQCMD_companyCircleCommentDelete, // 评论删除
    HQCMD_companyCircleDelete, // 删除
    HQCMD_companyCircleList, // 列表
    
    
    
    /******************  项目   **************************/
    
    /** 项目分享 */
    HQCMD_projectShareControllerSave, //新增分享
    
    HQCMD_projectShareControllerEdit, //修改分享
    
    HQCMD_projectShareControllerDelete, //删除分享
    
    HQCMD_projectShareControllerEditRelevance, //关联变更
    
    HQCMD_projectShareControllerShareStick, //分享置顶
    
    HQCMD_projectShareControllerSharePraise, //分享点赞
    
    HQCMD_projectShareControllerQueryById, //分享详情
    
    HQCMD_projectShareControllerQueryList, //分享列表
    
    HQCMD_projectShareControllerQueryRelationList, //获取关联内容
    
    HQCMD_projectShareControllerSaveRelation, //分享关联内容
    
    HQCMD_projectShareControllerCancleRelation, //取消关联
    
    /** 项目文库 */
    HQCMD_projectLibraryQueryLibraryList, //文库列表
    
    HQCMD_projectLibraryQueryFileLibraryList, //文库任务列表
    
    HQCMD_projectLibraryQueryTaskLibraryList, //文库列表
    HQCMD_projectLibraryRootSearch, // 文库根目录搜索
    
    HQCMD_projectLibrarySavaLibrary, //添加文库文件夹
    
    HQCMD_projectLibraryEditLibrary, //修改文件夹
    
    HQCMD_projectLibraryDelLibrary, //删除文件夹
    
    HQCMD_projectLibrarySharLibrary, //共享文件夹
    
    HQCMD_commonFileProjectUpload, //上传文件
    
    HQCMD_commonFileProjectDownload, //下载文件
    HQCMD_FileProjectDownloadRecord, // 文件下载记录
    HQCMD_workBenchChangeAuth,// 工作台切换人员权限
    HQCMD_workBenchChangePeopleList,// 工作台切换人员列表
    
    /******************  新版项目接口  ************************/
    HQCMD_projectAllNode,// 项目所有节点
    HQCMD_projectTempAllNode,// 项目模板节点
    HQCMD_projectAddNode,// 新增节点
    HQCMD_projectUpdateNode,// 更新节点
    HQCMD_projectDeleteNode,// 删除节点
    HQCMD_projectAddTask,// 新增任务
    HQCMD_projectUpdateTask,// 编辑任务
    HQCMD_projectAddSubTask,// 新增子任务
    HQCMD_projectUpdateSubTask,// 编辑子任务
    HQCMD_projectCopyTask,// 复制任务
    HQCMD_projectMoveTask,// 移动任务
    HQCMD_projectGetSubTask,// 子任务详情
    HQCMD_taskHybirdDynamic,// 任务混合动态
    HQCMD_newPersonnelTaskList,// 个人任务列表
    HQCMD_newProjectTaskList,// 项目任务列表
    
    /******************  新成员  ************************/
    HQCMD_uploadDeviceToken, // 上传 DeviceToken
    HQCMD_employeeList, // 新员工列表
    HQCMD_companyFramework, // 组织架构
    HQCMD_modPassWrd, //修改密码
    HQCMD_updateEmployee,     // 修改员工
    HQCMD_employeeDetail,// 员工详情
    HQCMD_getRoleGroupList,// 获取角色组列表
    HQCMD_findByUserName,// 组织架构模糊查找
    HQCMD_getSharePersonalFields,// 动态参数
    HQCMD_getCompanySet,// 获取最近登录公司密码策略
    HQCMD_changeTelephone,// 更换手机号
    HQCMD_getBanner,// 获取banner
    HQCMD_getCardStyle,// 获取名片样式
    HQCMD_saveCardStyle,// 保存名片样式
    
    /*********************备忘录********************/
    HQCMD_getNoteList, // 列表
    HQCMD_createNote, // 新建备忘录
    HQCMD_updateNote, // 编辑备忘录
    HQCMD_getNoteDetail, // 备忘录详情
    HQCMD_memoDel, //备忘录删除
    HQCMD_getFirstFieldFromModule, //搜索要关联的模块数据
    HQCMD_findRelationList, //获取关联数据
    HQCMD_updateRelationById, //更新关联数据
    
    /*********************项目********************/
    HQCMD_createProject,   // 创建项目
    HQCMD_updateProject, // 设置项目
    HQCMD_getProjectList,// 项目列表
    HQCMD_getProjecDetail, // 项目详情
    HQCMD_changeProjectStatus, // 变更项目状态
    HQCMD_addProjectPeople,// 增加项目成员
    HQCMD_getProjectRoleList,// 获取项目角色列表
    HQCMD_updateProjectRole,// 修改项目角色
    HQCMD_deleteProjectPeople,// 删除项目成员
    HQCMD_getProjectPeople,// 获取项目成员列表
    HQCMD_getProjectLabel, // 获取项目标签
    HQCMD_getPersonnelLabel,// 获取个人标签
    HQCMD_repositoryLabel, // 获取标签库所有标签
    HQCMD_addProjectLabel, // 添加项目标签
    HQCMD_updateProjectStar,// 更新项目星标
    HQCMD_updateProjectProgress,// 更新项目进度
    
    HQCMD_createProjectSection,// 创建项目主节点
    HQCMD_updateProjectSection, // 更新项目主节点
    HQCMD_deleteProjectColumn, // 删除项目主节点
    
    HQCMD_createProjectSectionRows, // 创建项目分组任务列
    HQCMD_updateProjectSectionRows, // 更新项目分组任务列
    HQCMD_deleteProjectSection, // 删除项目子节点
    
    HQCMD_getProjectAllDot, // 获取项目所有节点
    HQCMD_getProjectColumn, // 获取项目主节点
    HQCMD_getProjectSection, // 获取项目子节点
    
    HQCMD_sortProjectColumn, // 项目主节点排序
    HQCMD_sortProjectSection,// 项目子节点排序
    HQCMD_addTaskQuote,// 添加项目任务引用
    
    HQCMD_createTask, // 创建任务
    HQCMD_createChildTask,// 创建子任务
    HQCMD_getTaskDetail, // 任务详情
    HQCMD_getChildTaskDetail,// 子任务详情
    HQCMD_dragTaskSort, // 拖拽任务排序
    HQCMD_getChildTaskList,// 任务的子任务
    HQCMD_getPersonnelChildTaskList,// 个人任务的子任务
    HQCMD_getTaskRelation,// 任务关联
    HQCMD_getTaskRelated,// 任务被关联
    HQCMD_addTaskRelation,// 任务添加关联任务
    HQCMD_quoteTaskRelation, // 任务关联引用
    HQCMD_cancelTaskRelation,// 取消任务关联
    HQCMD_cancelPersonnelTaskRelation,// 取消个人任务关联
    HQCMD_finishOrActiveTask,// 完成或激活任务
    HQCMD_finishOrActiveChildTask,// 完成或激活子任务
    HQCMD_finishOrActivePersonnelTask,// 完成或激活个人任务
    HQCMD_taskHeart,// 任务或子任务点赞或取消点赞
    HQCMD_personnelTaskHeart,// 个人任务点赞或取消点赞
    HQCMD_taskHeartPeople,// 点赞人员列表
    HQCMD_personnelTaskHeartPeople,// 个人任务点赞人列表
    HQCMD_taskHierarchy,// 任务等级
    HQCMD_taskVisible,// 任务协作人可见
    HQCMD_personnelTaskVisible,// 个人任务协作可见
    HQCMD_taskCheck,// 校验任务
    HQCMD_childTaskCheck,// 校验子任务
    HQCMD_taskMoveToOther,// 任务移动
    HQCMD_taskCopyToOther,// 复制任务
    HQCMD_deleteTask,// 删除任务
    HQCMD_deleteChildTask,// 删除子任务
    HQCMD_quoteTaskList,// 引用任务列表
    HQCMD_queryProjectTaskCondition,// 任务筛选自定义条件接口
    HQCMD_projectTaskFilter,// 任务筛选
    HQCMD_personnelTaskFilter,// 个人任务筛选
    HQCMD_personnelTaskDetail,// 个人任务详情
    HQCMD_personnelSubTaskDetail,// 个人任务子任务详情
    HQCMD_taskInProject,// 项目中的任务
    HQCMD_getProjectTaskCooperationPeopleList,// 项目任务协作人列表
    HQCMD_getProjectTaskRole,// 获取项目角色
    HQCMD_getPersonnelTaskCooperationPeopleList,// 个人任务协作人列表
    HQCMD_getPersonnelTaskRole,// 个人任务角色
    HQCMD_addProjectTaskCooperationPeople,// 添加项目任务协作人
    HQCMD_addPersonnelTaskCooperationPeople,// 添加个人任务协作人
    HQCMD_deleteProjectTaskCooperationPeople,// 删除项目任务协作人
    HQCMD_deletePersonnelTaskCooperationPeople,// 删除个人任务协作人
    HQCMD_createPersonnelSubTask,// 新增个人任务子任务
    HQCMD_personnelTaskQuotePersonnelTask,// 个人任务引用个人任务
    HQCMD_personnelTaskRelationList,// 个人任务关联列表
    HQCMD_personnelTaskByRelated,// 个人任务被关联
    HQCMD_personnelTaskEdit,// 编辑个人任务
    HQCMD_personnelSubTaskEdit,// 编辑个人任务子任务
    HQCMD_projectTaskEdit,// 编辑项目任务 or 项目任务子任务
    HQCMD_personnelTaskDelete,// 个人任务删除
    HQCMD_personnelSubTaskDelete,// 个人任务子任务删除
    HQCMD_getProjectTaskRemain,// 获取项目任务提醒
    HQCMD_saveProjectTaskRemain,// 保存项目任务提醒
    HQCMD_updateProjectTaskRemain,// 更新项目任务提醒
    HQCMD_getAllProject,// 所有项目
    HQCMD_getPersonnelTaskList,// 获取个人任务列表
    HQCMD_getProjectWorkflow,// 获取工作流
    HQCMD_projectWorkflowPreview,// 工作流预览
    HQCMD_getPersonnelTaskFilterCondition,// 获取个人任务筛选条件
    HQCMD_getMyselfCustomModule,// 自定义模块列表
    HQCMD_getWorkBenchList,// 获取工作台列表
    HQCMD_enterpriseWorkBenchFlow,// 获取企业工作流程
    HQCMD_moveTimeWorkBench,// 移动时间工作台数据
    HQCMD_moveEnterpriseWorkBench,// 移动企业工作台数据
    HQCMD_projectTemplateList,// 项目模板
    HQCMD_projectTemplatePreview,// 项目模板预览
    HQCMD_getProjectRoleAndAuth,// 获取项目角色及权限
    HQCMD_getProjectTaskRoleAuth,// 获取任务角色权限
    HQCMD_getProjectTaskSeeStatus,// 项目任务查看状态
    HQCMD_getPersonnelTaskSeeStatus,// 个人任务查看状态
    HQCMD_saveProjectTaskRepeat,// 保存项目任务重复
    HQCMD_updateProjectTaskRepeat,// 更新项目任务重复
    HQCMD_getProjectTaskRepeat,// 获取项目任务重复
    HQCMD_getPersonnelTaskRemind,// 获取个人任务提醒
    HQCMD_savePersonnelTaskRemind,// 保存个人任务提醒
    HQCMD_updatePersonnelTaskRemind,// 更新个人任务提醒
    HQCMD_getPersonnelTaskRepeat,// 获取个人任务重复
    HQCMD_savePersonnelTaskRepeat,// 保存个人任务重复
    HQCMD_updatePersonnelTaskRepeat,// 更新个人任务重复
    HQCMD_updateProjectTask,// 编辑项目任务
    HQCMD_updateProjectChildTask,// 编辑项目子任务
    HQCMD_getProjectFinishAndActiveAuth,// 项目任务完成及激活原因权限
    HQCMD_deleteProjectPeopleTransferTask,// 移出成员是否需要指定工作交接人
    HQCMD_boardCancelQuote,// 层级视图取消关联
    
#pragma mark ------------------------  考勤  ------------------------
    HQCMD_attendanceWaySave, //新增考勤方式
    
    HQCMD_attendanceWayFindList, //考勤方式列表
    
    HQCMD_attendanceWayUpdate, //修改考勤方式
    
    HQCMD_attendanceWayDel, //删除考勤方式
    
    HQCMD_attendanceWayFindDetail, //考勤方式详情
    
    HQCMD_attendanceClassSave, //新增班次管理
    
    HQCMD_attendanceClassFindList, //班次管理列表
    
    HQCMD_attendanceClassDel, //删除班次管理
    
    HQCMD_attendanceClassUpdate, //修改班次管理
    
    HQCMD_attendanceClassFindDetail, //班次管理详情
    
    HQCMD_attendanceScheduleSave, //新增考勤规则
    
    HQCMD_attendanceScheduleFindList, //考勤规则列表
    
    HQCMD_attendanceScheduleDel, //删除考勤规则
    
    HQCMD_attendanceScheduleUpdate, //修改考勤规则
    
    HQCMD_attendanceScheduleFindDetail, //考勤规则详情
    
    HQCMD_attendanceSettingSaveAdmin, //其他设置新增管理员
    
    HQCMD_attendanceSettingUpdate, //其他设置修改管理员
    
    HQCMD_attendanceSettingSaveRemind, //其他设置新增/修改打卡提醒
    
    HQCMD_attendanceSettingSaveCount, //其他设置新增/修改榜单设置
    
    HQCMD_attendanceSettingSaveLate, //其他设置新增/修改晚走晚到
    
    HQCMD_attendanceSettingSaveHommization, //其他设置新增/修改人性化班次
    
    HQCMD_attendanceSettingSaveAbsenteeism, //其他设置新增/修改旷工规则
    
    HQCMD_attendanceSettingFindDetail, //其他设置根据ID查询详情
    
    HQCMD_attendanceLateWork,// 晚走晚到
    
    HQCMD_attendanceManagementFindAppDetail, //排班详情查询
    
    HQCMD_attendanceScheduleFindScheduleList, //获取考勤组列表

    HQCMD_attendanceCycleFindDetail, //排班周期详情
    
    HQCMD_getTodayAttendanceInfo,// 获取当日考勤信息
    
    HQCMD_getTodayAttendanceRecord,// 获取当日打卡记录
    
    HQCMD_punchAttendance,// 打卡
    
    HQCMD_attendanceDayStatistics,// 日统计数据
    HQCMD_attendanceMonthStatistics,// 月统计数据
    HQCMD_myMonthStatistics,// 我的月统计数据
    HQCMD_attendanceEmployeeMonthStatistics,// 打卡月历
    HQCMD_attendanceEarlyRank,// 早到榜
    HQCMD_attendanceHardworkingRank,// 勤勉榜
    HQCMD_attendanceLateRank,// 迟到榜
    HQCMD_attendanceGroupList,// 考勤组列表
    HQCMD_attendancePunchPeoples,// 打卡人员列表
    HQCMD_attendancePunchStatusPeoples,// 打卡状态人员列表
    HQCMD_attendanceReferenceApprovalList,// 关联审批单列表
    HQCMD_attendanceReferenceApprovalDelete,// 关联审批单删除
    HQCMD_attendanceReferenceApprovalCreate,// 关联审批单创建
    HQCMD_attendanceReferenceApprovalUpdate,// 关联审批单修改
    HQCMD_attendanceReferenceApprovalDetail,// 关联审批单详情
    HQCMD_attendanceApprovalModuleList,// 关联审批模块
    HQCMD_attendanceApprovalModuleField,// 关联审批模块字段
    

#pragma mark - 知识库
    HQCMD_saveKnowledge,// 知识库保存
    HQCMD_updateKnowledge,// 知识更新
    HQCMD_deleteKnowledge,// 知识删除
    HQCMD_getKnowledgeDetail,// 知识详情
    HQCMD_getKnowledgeList,// 知识列表
    HQCMD_getKnowledgeCategoryAndLabel,// 知识分类及标签
    HQCMD_knowledgeLabel,// 标签
    HQCMD_sureLearnKnowledge,// 确认学习及取消
    HQCMD_learnAndReadKnowledgePeople,// 确认学习及阅读人数
    HQCMD_goodKnowledge,// 点赞知识
    HQCMD_goodKnowledgePeople,// 点赞知识人员
    HQCMD_collectKnowledge,// 收藏知识
    HQCMD_collectKnowledgePeople,// 收藏知识人员
    HQCMD_knowledgeVersion,// 知识版本
    HQCMD_getKnowledgeCategory,// 知识分类
    HQCMD_knowledgeMove,// 知识移动
    HQCMD_anwserSave,//  回答保存
    HQCMD_anwserUpdate,//  回答更新
    HQCMD_anwserDetail,//  回答详情
    HQCMD_anwserDelete,//  回答删除
    HQCMD_anwserList,//  提问回答列表
    HQCMD_knowledgeTop,// 知识和提问置顶
    HQCMD_anwserTop,//  回答置顶
    HQCMD_knowledgeReferances,// 知识引用列表
    HQCMD_inviteToAnswer,// 邀请回答
    HQCMD_changeItemToCard,// 将item转换为card

    HQCMD_getSectionTask = 10000,// 获取任务列中的任务
    HQCMD_getWorkBenchTimeData = 20000,// 获取时间工作台数据
    HQCMD_enterpriseWorkBenchFlowData = 30000,// 获取企业工作台数据
    
    HQCMD_nothing
}HQCMD;



typedef enum {
    
    HQRESCode_UNKNOWN       = -5,       //未知错误
    HQRESCode_NETERROR      = -4,       //网络错误（http协议返回的错误）
    HQRESCode_UNCONNECT     = -3,       //服务端不可达
    HQRESCode_UNREACHABLE   = -2,       //无网络
    HQRESCode_TIMEOUT       = -1,       //超时
    HQRESCode_SUCCESS      = 0000,
    HQRESCode_DATAFORMAT_ERR   = 0001,
    HQRESCode_USER_NOTEXISTED  = 0003,
    HQRESCode_PWD_ERR          = 0004,
    HQRESCode_SYS_ERR          = 9999,  //未知错误
    HQRESCode_Success          = 1001,  //成功
    
    /** 临时响应:表示临时响应并需要请求者继续执行操作的状态代码。 */
    HQRESCode_ProvisionalResponse00       = 100,// 继续
    HQRESCode_ProvisionalResponse01       = 101,// 切换协议
    
    /** 成功:表示成功处理了请求的状态代码。 */
    HQRESCode_Success00       = 200,// 成功
    HQRESCode_Success01       = 201,// 已创建
    HQRESCode_Success02       = 202,// 已接受
    HQRESCode_Success03       = 203,// 非授权信息
    HQRESCode_Success04       = 204,// 无内容
    HQRESCode_Success05       = 205,// 重置内容
    HQRESCode_Success06       = 206,// 部分内容
    
    /** 重定向:表示要完成请求，需要进一步操作。 通常，这些状态代码用来重定向。*/
    HQRESCode_Redirect00       = 300,// 多种选择
    HQRESCode_Redirect01       = 301,// 永久移动
    HQRESCode_Redirect02       = 302,// 临时移动
    HQRESCode_Redirect03       = 303,// 查看其它位置
    HQRESCode_Redirect04       = 304,// 未修改
    HQRESCode_Redirect05       = 305,// 使用代理
    HQRESCode_Redirect07       = 307,// 临时重定向
    
    /** 请求错误:这些状态代码表示请求可能出错，妨碍了服务器的处理。 */
    HQRESCode_RequestError00       = 400,// 请求错误
    HQRESCode_RequestError01       = 401,// 未授权
    HQRESCode_RequestError03       = 403,// 禁止
    HQRESCode_RequestError04       = 404,// 未找到
    HQRESCode_RequestError05       = 405,// 方法禁用
    HQRESCode_RequestError06       = 406,// 不接受
    HQRESCode_RequestError07       = 407,// 需要代理授权
    HQRESCode_RequestError08       = 408,// 请求超时
    HQRESCode_RequestError09       = 409,// 冲突
    HQRESCode_RequestError10       = 410,// 已删除
    HQRESCode_RequestError11       = 411,// 需要有效长度
    HQRESCode_RequestError12       = 412,// 未满足前提条件
    HQRESCode_RequestError13       = 413,// 请求实体过大
    HQRESCode_RequestError14       = 414,// 请求的URL过长
    HQRESCode_RequestError15       = 415,// 不支持的媒体类型
    HQRESCode_RequestError16       = 416,// 请求范围不符合要求
    HQRESCode_RequestError17       = 417,// 未满足期望值
    HQRESCode_RequestError28       = 428,// 要求先决条件
    HQRESCode_RequestError29       = 429,// 太多请求
    HQRESCode_RequestError31       = 431,// 请求头字段太大
    
    /** 服务器内部错误:这些状态代码表示服务器在尝试处理请求时发生内部错误。 这些错误可能是服务器本身的错误，而不是请求出错。 */
    HQRESCode_ServerError00       = 500,// 服务器内部错误
    HQRESCode_ServerError01       = 501,// 尚未实施
    HQRESCode_ServerError02       = 502,// 错误网关
    HQRESCode_ServerError03       = 503,// 服务不可用
    HQRESCode_ServerError04       = 504,// 网关超时
    HQRESCode_ServerError05       = 505,// HTTP版本不受支持
    HQRESCode_ServerError11       = 511,// 要求网络认证
    
    
    
}HQRESCode;



//
typedef enum {
    
    HQAttendanceState_add   = 1,      //标识考勤组新增
    HQAttendanceState_edite    ,      //标识考勤组修改
    HQAttendanceState_createCustomer, //标识新增客户
    HQAttendanceState_editeCustomer,  //标识修改客户
    HQAttendanceState_addShedule      //标识新建日程
    
}HQAttendanceState;



//签卡说明界面
typedef enum
{
    HQAttendanceDescriptionType_goOut = 0,  //外出签卡
    HQAttendanceDescriptionType_goOutEdite, //编辑外出
    HQAttendanceDescriptionType_signIn,     //签到
    HQAttendanceDescriptionType_signOut,    //签退

    HQAttendanceDescriptionType_writeWorkReport,// 报告
    HQAttendanceDescriptionType_advice,// 建议
    HQAttendanceDescriptionType_notice,// 通知

    HQScheduceDescriptionType_onRoad,       //在路上
    HQSenderFriendCricleType_friendCricle,  //发布企业圈
    HQSenderFriendCricleType_forum,  //论坛
    HQAttendanceDescriptionType_report,    //外勤报告
    
}HQAttendanceDescriptionType;

/** 选人类型 */
typedef enum {
    
    ChoicePeopleTypeProjectTaskListPrincipal,
    ChoicePeopleTypeCreateProjectPrincipal,
    ChoicePeopleTypeCreateTaskExcutor,
    ChoicePeopleTypeCreateTaskcollaborator,
    ChoicePeopleTypeSelectPeople
    
}ChoicePeopleType;

/** 助手类型 */
typedef enum {
    AssistantTypeTask = 110,  // 任务
    AssistantTypeSchedule, // 日程
    AssistantTypeNote, // 随手记
    AssistantTypeFile, // 文件库
    AssistantTypeApproval, // 审批
    AssistantTypeNotice, // 公告
    AssistantTypeAdvice, // 投诉建议
    AssistantTypeReport // 工作汇报
    
}AssistantType;


typedef enum {
    
    NoteListTypeNew,
    NoteListTypeAll,
    NoteListTypeCoop,
    NoteListTypeDownload,
    NoteListTypeDelete,
    NoteListTypeNotebook,
    NoteListTypeNoteCoopEdit,
    NoteListTypeNoteDownloadEdit,
    NoteListTypeNoteDeleteEdit,
    NoteListTypeNoteDeleteNotebook
    
}NoteListType;

#endif /* HQEnum_h */




