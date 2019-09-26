//
//  HQConst.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/11.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#ifndef HQConst_h
#define HQConst_h


/*******************    编程时常用宏定义    ****************************/

#define SystemVersion ([UIDevice currentDevice].systemVersion.floatValue)
#define IOS5_AND_LATER (SystemVersion >= 5.0)
#define IOS6_AND_LATER (SystemVersion >= 6.0)
#define IOS7_AND_LATER (SystemVersion >= 7.0)
#define IOS8_AND_LATER (SystemVersion >= 8.0)
#define IOS9_AND_LATER (SystemVersion >= 9.0)
#define IOS10_AND_LATER (SystemVersion >= 10.0)

#define  Is_iPhone4S  ([[UIScreen mainScreen] bounds].size.width == 320 &&  [[UIScreen mainScreen] bounds].size.height == 480)
#define Is_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define iPhone35  ([[UIScreen mainScreen] bounds].size.width == 320 &&  [[UIScreen mainScreen] bounds].size.height == 480)
#define iPhone40  ([[UIScreen mainScreen] bounds].size.width == 320 &&  [[UIScreen mainScreen] bounds].size.height == 568)
#define iPhone47  ([[UIScreen mainScreen] bounds].size.width == 375 &&  [[UIScreen mainScreen] bounds].size.height == 667)
#define iPhone55  ([[UIScreen mainScreen] bounds].size.width == 414 &&  [[UIScreen mainScreen] bounds].size.height == 736)


#define KeyWindow   [UIApplication sharedApplication].keyWindow
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_FRAME  (CGRectMake(0, 0 ,SCREEN_WIDTH,SCREEN_HEIGHT))
#define APPDelegate         [AppDelegate appDelegate]
#define APP                 [UIApplication sharedApplication]

#define arrowsImageViewHeight 18    //跳转箭头的大小
#define spacingTableView      12    //TableView 边距
#define GroupChatNameViewHeight 20    //群聊名字高度

// iPhone X 宏定义
#define iPhoneX (SCREEN_HEIGHT > 736.f ? YES : NO)
#define StatusBarHeight 20.f
#define TabBarHeight 49.f
#define NavigationBarHeight 64.f
#define BottomM (iPhoneX ? 34.0 : 0.0)
#define TopM (iPhoneX ? 24.0 : 0.0)
#define NaviHeight (NavigationBarHeight + TopM)// 用于适配X
#define BottomHeight (TabBarHeight + BottomM)// 用于适配X

//RGB颜色
#define RGBColor(r, g, b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBAColor(r, g, b, a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//16进制颜色
#define HexAColor(hexValue, a) [UIColor colorWithRed:(((hexValue & 0xFF0000) >> 16))/255.0f green:(((hexValue & 0xFF00) >> 8))/255.0f blue:((hexValue & 0xFF))/255.0f alpha:a]

#define HexColor(hexValue) [UIColor colorWithRed:(((hexValue & 0xFF0000) >> 16))/255.0f green:(((hexValue & 0xFF00) >> 8))/255.0f blue:((hexValue & 0xFF))/255.0f alpha:1.0]

#define kUIColorFromRGB(hexValue) HexColor(hexValue)

/******/
//图片
#define IMG(str) [UIImage imageNamed:str]

#define CompanyCircleGoodWidth 75

#define PasswordMD5 @"hjhq2017Teamface"
#define CompanyTotalPeople @"CompanyTotalPeople"
#define CustomerSearchRecord @"CustomerSearchRecord"
#define ComponentsSeparated @"$%&**&%$"


//大量用到颜色
#define HeadBackground   GreenColor
#define GreenColor       HexAColor(0x3689E9, 1)        //主色调，蓝色
#define BackGroudColor   HexAColor(0xf2f2f2, 1)        //背景色
#define BlackTextColor   HexAColor(0x111111, 1)        //标题文字
#define LightBlackTextColor HexAColor(0x333333, 1)     //主要文字
#define ExtraLightBlackTextColor HexAColor(0x666666, 1)     //辅助文字
#define GrayTextColor    HexAColor(0x999999, 1)        //次级文字
#define LightGrayTextColor    HexAColor(0xa0a0a0, 1)   //提示文字
#define LightTextColor   HexAColor(0xa0a0a0, 1)        //亮灰色文字
#define WhiteColor       [UIColor whiteColor]         //白色
#define NaviItemColor    ExtraLightBlackTextColor        //导航栏item文字颜色
#define NaviItemSelectedColor    GreenColor        //导航栏item文字颜色
#define NavigationBarColor    WhiteColor        //导航栏背景颜色
#define CellSeparatorColor  HexAColor(0xd8d8d8, 1)     //cell分割线颜色
#define CellTitleNameColor  ExtraLightBlackTextColor     //cell的TitleName颜色
#define GrayGroundColor  HexAColor(0xc8c8c8, 1)     // 导航栏阴影颜色
#define PlacehoderColor  HexAColor(0xcacad0, 1)     // 提示文字颜色
#define HeadImageGroundColor HexAColor(0xebbbf9, 1) // 头像背景颜色
#define ClearColor [UIColor clearColor] // clearColor
#define BGCOLOR HexAColor(0xf2f2f2, 1)

#define CurrentMonthDateColor HexAColor(0x8c96ab, 1) //本月颜色
#define NOSelectDateColor HexAColor(0xcacad0, 1) //不可选颜色
#define FinishedTextColor HexAColor(0xa0a0ae, 1) // 完成文字颜色
#define PriorityUrgent HexAColor(0xffc057, 1) // 紧急颜色
#define PriorityVeryUrgent HexAColor(0xff6f00, 1) // 非常紧急颜色

#define RedColor         HexAColor(0xf5222d, 1)        //红色
#define LightRedColor    HexAColor(0xf47f7f, 1)        //浅红色
#define CellClickColor   HexAColor(0xdcdcdc, 1)        //Cell点击选中色

#define NineColor   HexAColor(0x999999, 1)        //Cell内容颜色
#define SixColor   HexAColor(0x666666, 1)
#define ThreeColor   HexAColor(0x333333, 1)
/** 请求地址 */
#define URL(name) [NSString stringWithFormat:@"%@%@",kServerAddress,name]
/** H5网页地址 */
#define H5URL(name) ([[AppDelegate shareAppDelegate].baseUrl isEqualToString:baseUrl]?[NSString stringWithFormat:@"%@/%@",H5Header,name]:[NSString stringWithFormat:@"%@/dist/H5.html%@",[AppDelegate shareAppDelegate].baseUrl,name])
//#define H5URL(name) ([[AppDelegate shareAppDelegate].baseUrl isEqualToString:baseUrl]?[NSString stringWithFormat:@"%@%@",H5Header,name]:[NSString stringWithFormat:@"%@%@",H5Header,name])
// 是否为空
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

// 字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) isEqualToString:@""]))
// 数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))
/**
 * 非空处理
 */
#define NULLABLE(value) (value != nil ? value : [NSNull null])

/**
 * 变成字符串
 */
#define TEXT(value) ([value isKindOfClass:[NSNull class]] || !value ) ? @"" : value

/**
 * 变成NSNumber
 */
#define NUMBER(value) ([value isKindOfClass:[NSNull class]] || !value ) ? @0 : value

// Font
#define FONT(x) [UIFont systemFontOfSize:x]
#define BFONT(x) [UIFont boldSystemFontOfSize:x]

//加载图片宏
#define LoadImage(ptr) (ptr?[UIImage imageNamed:ptr]:nil)

/** iPhone6长度适配各机型 */
#define Long(x)   ((x)*SCREEN_WIDTH/375.0)

/** 用于替代图片的字符串 */
#define PlaceholderHeadImage [UIImage imageNamed:@"头像40"]
#define PlaceholderBackgroundImage [UIImage imageNamed:@"头像40"]
#define ChatDefaultHeadImage @"头像40"

/** 文件没加载完显示的默认图标 */
#define DefaultFileImage [UIImage imageNamed:@"jpg"]

/** weak self */
#define kWEAKSELF __weak __typeof(self)weakSelf = self;
#define kSTRONGSELF  __strong __typeof(weakSelf)strongSelf = weakSelf;

/** 主线程 */
#define HQMainQueue(block) dispatch_async(dispatch_get_main_queue(), block)

/** 子线程 */
#define HQGlobalQueue(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

//文字
#define UserPictureDomain   @"UserPictureDomain"
#define UserLoginTelephone   @"UserLoginTelephone"
#define LoginState      @"loginState"
#define kPassWord       @"passWord"
#define LoadTitle       @"加载中..."
#define RequestSuccess  @"发送成功"
#define ShowUrgentState @"ShowUrgentState"
#define CompanyCircleNOReadMessageNum  @"CompanyCircleNOReadMessageNum"


#define NotificationLoginSuccess   @"notificationLoginSuccess"    //登录
#define NotificationLogoutSuccess  @"notificationLogoutSuccess"   //退出

#define IsDelegate(delegate,method) delegate != nil && [delegate respondsToSelector:@selector(method)]


#define kMyResponse @"response"
#define kCode       @"code"
#define kDescribe   @"describe"
#define kData       @"data"

#define MutilFileStart 100000

/** 非Wi-Fi环境上传/下载大于10M的文件时将不再显示流量提醒 */
#define DataFlowRemain @"DataFlowRemain"
#define MaxFileSize (10)



/***************************     接口API    **************************/

/******************  上传文件  ************************/
/** 应用模块文件上传 */
#define UploadFile @"/common/file/applyFileUpload"
/** 公司初始化头像上传 */
#define ImageUpload @"/common/file/imageUpload"
/** 聊天文件 */
#define ChatFile @"/common/file/upload"

/******************  新登录注册  ************************/
/** 新注册 */
#define UserNewRegister @"/user/userRegister"
/** 手机注册 */
#define UserRegister @"/user/register"
/** 手机登录 */
#define UserLogin  @"/user/login"
/** 获取验证码 */
#define SendVerifyCode @"/user/sendSmsCode"
/** 验证验证码 */
#define VerifyVerificationCode @"/user/verifySmsCode"
/** 扫码提交 */
#define ScanCodeSubmit @"/user/valiLogin"
/** 修改密码 */
#define ModifyPassWord @"/user/modifyPwd"
/** 初始化公司信息 */
#define SetupCompanyInfo @"/user/perfectInfo"
/** 初始化个人信息 */
#define SetupEmployeeInfo @"/user/personalInfo"
/** 公司列表 */
#define GetCompanyList @"/user/companyList"
/** 切换公司 */
#define ChangeCompany @"/user/companyLogin"
/** 登录后获取员工和公司信息 */
#define GetEmployeeAndCompanyInfo @"/user/queryInfo"
/** 获取员工详情 */
#define GetEmployeeInfo @"/employee/getEmployeeDetail"


/******************  权限   **************************/
/** 获取员工角色 */
#define GetEmployeeRole @"/auth/getRoleByUser"
/** 获取角色权限 */
#define GetRoleAuth @"/auth/getAuthByRole"
/** 获取员工模块权限 */
#define GetEmployeeModuleAuth  @"/auth/getModuleAuthByUser"
/** 获取模块功能权限 */
#define GetModuleFunctionAuth  @"/auth/getFuncAuthByModule"


/******************  自定义  ************************/
/** 获取布局 */
#define CustomLayout @"/layout/getEnableLayout"
/** 获取任务布局 */
#define CustomTaskLayout @"/projectLayout/getAllLayout"
/** 保存项目任务信息 */
#define SaveTaskLayoutData @"/projectLayoutOperation/save"
/** 保存个人任务信息 */
#define SavePersonnelData @"/personelTask/save"
/** 获取应用列表 */
#define CustomApplicationList @"/module/findAllModuleList"
/** 常用应用编辑 */
#define CustomApplicationOften @"/applicationModuleUsed/update"
/** 新增保存数据 */
#define CustomSave @"/moduleOperation/saveData"
/** 删除 */
#define CustomDelete @"/moduleOperation/deleteData"
/** 编辑 */
#define CustomEdit @"/moduleOperation/updateData"
/** 详情 */
#define CustomDetail @"/moduleOperation/findDataDetail"
/** 业务数据列表 */
#define CustomDataList @"/moduleOperation/findDataList"
/** 获取子菜单模块列表 */
#define CustomChildMenuList @"/submenu/getSubmenusForPC"
/** 关联搜索 */
#define CustomRefernceSearch @"/moduleOperation/findRelationDataList"
/** 查重 */
#define CustomChecking @"/moduleOperation/getRecheckingFields"
/** 筛选条件 */
#define CustomFilterFields @"/moduleOperation/findFilterFields"
/** 关联模块 */
#define CustomRefernceModule @"/moduleOperation/findDataRelation"
/** 模块功能 */
#define CustomModuleAuth @"/moduleDataAuth/getFuncAuthByModule"
/** 转移负责人 */
#define CustomTransferPrincipal @"/moduleOperation/transfor"
/** 共享设置列表 */
#define CustomShareList @"/moduleSingleShare/getSingles"
/** 删除某个共享设置 */
#define CustomShareDelete @"/moduleSingleShare/del"
/** 保存共享 */
#define CustomShareSave @"/moduleSingleShare/save"
/** 编辑共享 */
#define CustomShareEdit @"/moduleSingleShare/update"
/** 模块转换列表 */
#define CustomModuleChangeList @"/fieldTransform/getFieldTransformationsForMobile"
/** 模块转换 */
#define CustomModuleChange @"/moduleOperation/transformation"
/** 评论保存 */
#define CustomCommentSave @"/common/savaCommonComment"
/** 评论列表 */
#define CustomCommentList @"/common/queryCommentDetail"
/** 动态列表 */
#define CustomDynamicList @"/common/queryAppDynamicList"
/** 审批列表 */
#define CustomApprovalList @"/approval/queryApprovalList"
/** 某模块下的审批数据 */
#define GetApprovalListWithBean @"/approval/queryProjectApprovaList"
/** 审批筛选条件 */
#define CustomApprovalSearchMenu @"/approval/querySearchMenu"
/** 完整审批流 */
#define CustomApprovalWholeFlow @"/workflow/getProcessWholeFlow"
/** 审批通过 */
#define CustomApprovalPass @"/workflow/pass"
/** 审批驳回 */
#define CustomApprovalReject @"/workflow/reject"
/** 审批转交 */
#define CustomApprovalTransfer @"/workflow/transfer"
/** 审批撤销 */
#define CustomApprovalRevoke @"/workflow/revoke"
/** 审批抄送 */
#define CustomApprovalCopy @"/workflow/ccTo"
/** 审批催办 */
#define CustomApprovalUrge @"/workflow/urgeTo"
/** 已读 */
#define CustomApprovalRead @"/approval/approvalRead"
/** 数量 */
#define CustomApprovalCount @"/approval/queryApprovalCount"
/** 驳回方式 */
#define CustomApprovalRejectType @"/workflow/getRejectType"
/** 通过方式 */
#define CustomApprovalPassType @"/workflow/getPassType"
/** 审批删除 */
#define CustomRemoveProcessApproval @"/workflow/removeProcessApproval"
/** 获取审批详情参数 */
#define CustomQueryApprovalData @"/approval/queryApprovalData"
/** 公海池领取 */
#define CustomHighseaTake @"/moduleOperation/take"
/** 公海池移动 */
#define CustomHighseaMove @"/moduleOperation/moveData2OtherSeapool"
/** 公海池退回 */
#define CustomHighseaBack @"/moduleOperation/returnBack"
/** 公海池分配 */
#define CustomHighseaAllocate @"/moduleOperation/allocate"
/** 公海池列表 */
#define CustomHighseaList @"/seapool/getSeapools"
/** 统计列表 */
#define GetReportList @"/report/getReportList"
/** 统计筛选列表 */
#define GetReportFilterFields @"/report/getFilterFields"
/** 统计筛选列表 */
#define GetReportFilterFieldsWithReportId @"/report/getReportFilterFields"
/** 报表详情 */
#define GetReportDetail @"/report/getReportDataDetail"
/** 仪表详情 */
#define GetChartDetail @"/instrumentPanel/getLayout"
/** 报表布局详情 */
#define GetReportLayoutDetail @"/report/getReportLayoutDetail"
/** 图标列表 */
#define GetChartList @"/instrumentPanel/findAll"
/** 是否需要选择下一审批人（邮件） */
#define CustomApprovalCheckChooseNextApproval @"/workflow/checkChooseNextApproval"
/** 所有应用 */
#define AllApplications @"/module/findPcAllModuleList"
/** 应用下的模块 */
#define AllModules @"/module/findModuleListByAuth"
/** 常用应用 */
#define SaveOftenModule @"/applicationModuleUsed/save"
/** 模块新建权限 */
#define ModuleHaveAuth @"/applicationModuleUsed/queryModuleAuth"
/** 模块阅读权限 */
//#define ModuleHaveReadAuth @"/moduleDataAuth/getAuthByModule"
#define ModuleHaveReadAuth @"/moduleDataAuth/getFuncAuthWithCommunal"
/** 自定义人员选择范围 */
#define CustomRangePeople @"/employee/queryRangeEmployeeList"
/** 快速新增 */
#define QuickAdd @"/module/queryModuleStatistics"
/** 生成条形码 */
#define CreateBarcode @"/barcode/createBarcode"
/** 条形码详情 */
#define BarcodeDetail @"/barcode/findDetailByBarcode"
/** 条形码图片 */
#define BarcodePicture @"/barcode/getBarcodeMsg"
/** 获取某模块数据条件字段列表 */
#define GetCustomConditionField @"/layout/getLinkageFieldsForCustom"
/** 条件字段value变更触发获取联动字段列表和value */
//#define GetLinkageFieldList @"/aggregationLinkage/findAggregationDataLinkageList"
#define GetLinkageFieldList @"/aggregationLinkage/getLinkageData"
/** 获取系统固定模块 */
#define GetSystemStableModule @"/moduleManagement/findModuleList"
/** 获取自动匹配模块列表 */
#define GetAutoMatchModuleList @"/automatch/findAllModule"
/** 获取自动匹配模块数据列表 */
#define GetAutoMatchModuleDataList @"/automatch/findAutoList"
/**  获取自动匹配模块规则列表 */
#define GetAutoMatchModuleRuleList @"/automatch/findAutoByBean"
/**  获取自动匹配模块规则下的数据列表 */
#define GetAutoMatchModuleRuleDataList @"/automatch/findIndividuationList"
/** 获取页签列表 */
#define GetTabList @"/tab/findTabList"
/** 获取页签下的数据列表 */
#define GetTabDataList @"/tab/findListById"
/** 获取关联页签下新建获取关联映射字段值 */
#define GetReferanceReflect @"/tab/findReferenceMapping"
/** 获取web链接列表 */
#define GetWebLinkList @"/webform/getWebformListForAdd"
/** 显示模块 */
#define WorkEnterShow @"/applicationModuleUsed/getCommonModules"
/** 所有模块 */
#define WorkEnterAllModule @"/applicationModuleUsed/findAllModule"
/** 子表关联 */
#define SubformRelation @"/fieldRelyon/findSubRelationDataList"
/** 简历解析 */
#define ResumeFile @"/layoutResume/singleResumeUpload"
/** 检查审批时间 */
#define CheckApprovalTime @"/approval/checkAttendanceRelevanceTime"

/******************  公告  ************************/


/******************  企业圈  ************************/
/** 企业圈添加一条动态 */
#define CompanyCircleAdd @"/imCircle/add"
/** 企业圈的点赞 */
#define CompanyCircleUp @"/imCircle/up"
/** 企业圈的评论 */
#define CompanyCircleComment @"/imCircle/comment"
/** 删除企业圈 */
#define CompanyCircleDelete @"/imCircle/delete"
/** 删除评论 */
#define CompanyCircleCommentDelete @"/imCircle/comment/delete"
/** 列表 */
#define CompanyCircleList @"/imCircle/list"


/******************  企信  ************************/
/** 总群和小秘书 */
#define MessageGetBasicGroup @"/iMessage/getBasicGroup"
/** 获取助手列表 */
#define MessageGetAssistList @"/iMessage/getAssistList"
/** 获取助手详情 */
#define MessageGetAssistDetail @"/iMessage/getTaskDetail"
/**  更改助手处理状态 */
#define MessageModifyHandle @"/iMessage/modHandle"
/** 更改助手已读状态 */
#define MessageModifyRead @"/iMessage/modRead"
/** 助手置顶 */
#define MessageModifyTop @"/iMessage/modAssistTop"
/** 助手待处理数据的清空 */
#define MessageClearHandle @"/iMessage/cleanHandle"
/** 修改助手设置 */
#define MessageModifyAssistantSetData @"/iMessage/modAssistSetData"
/** 极光用户获取员工信息 */
#define MessageGetEmployee @"/iMessage/getImUser"

/** 未读页面数据全部变为已读 */
#define MessageModToAllRead @"/iMessage/modToAllRead"
/** 获取助手设置信息 */
#define MessageGetAssistSetData @"/iMessage/getAssistSetData"
/** 新建群 */
#define MessageAddGroup @"/iMessage/addGroup"
/** 群列表 */
#define MessageGroupList @"/iMessage/getGroups"


/******************  新企信  ************************/

/** 获取会话列表 */
#define getChatListInfo @"/imChat/getListInfo"
/** 创建群聊 */
#define addGroupChat @"/imChat/addGroupChat"
/** 创建单聊 */
#define addSingleChat @"/imChat/addSingleChat"
/** 获取所有群组 */
#define getAllGroupsInfo @"/imChat/getAllGroupsInfo"
/** 单聊设置 */
#define getSingleInfo @"/imChat/getSingleInfo"
/** 群聊设置 */
#define getGroupInfo @"/imChat/getGroupInfo"
/** 置顶 */
#define setTopChat @"/imChat/setTop"
/** 免打扰 */
#define setNoBother @"/imChat/noBother"
/** 退群 */
#define quitChatGroup @"/imChat/quitGroup"
/** 解散群 */
#define releaseGroup @"/imChat/releaseGroup"
/** 拉人 */
#define pullPeople @"/imChat/pullPeople"
/** 踢人 */
#define kickPeople @"/imChat/kickPeople"
/** 删除会话列表 */
#define hideSession @"/imChat/hideSession"
/** 修改群信息 */
#define modifyGroupInfo @"/imChat/modifyGroupInfo"
/** 转让群主 */
#define imChatTransferGroup @"/imChat/transferGroup"
/** 人员搜索 */
#define employeeFindEmployeeVague @"/employee/findEmployeeVague"

/******* 小助手 *******/
/** 小助手列表 */
#define getAssistantMessage @"/imChat/getAssistantMessage"

/** 获取小助手设置相关信息 */
#define getAssisstantInfo @"/imChat/getAssisstantInfo"

#define findModuleList @"/module/findModuleList"

#define markAllRead @"/imChat/markAllRead"

#define readMessage @"/imChat/readMessage"

/** 标记小助手已读未读 */
#define markReadOption @"/imChat/markReadOption"

#define getAuthByBean @"/moduleDataAuth/getAuthByBean"

//小助手文件库权限
#define queryAidePower @"/fileLibrary/queryAidePower"

//小助手列表权限判断
#define getFuncAuthWithCommunal @"/moduleDataAuth/getFuncAuthWithCommunal"

//小助手隐藏状态更改
#define HideSessionWithStatus @"/imChat/hideSessionWithStatus"
//小助手历史数据
#define getAssistantMessageLimit @"/imChat/getAssistantMessageLimit"

/*************************新文件库***************************/

/** 菜单列表 */
#define queryfileCatalog @"/fileLibrary/queryfileCatalog"

/** 新增文件夹 */
#define savaFileLibrary @"/fileLibrary/savaFileLibrary"

/** 根列表 */
#define queryCompanyList @"/fileLibrary/queryFileList"

/** 删除文件夹 */
#define delFileLibrary @"/fileLibrary/delFileLibrary"

/** 编辑文件夹 */
#define editFolder @"/fileLibrary/editFolder"

/** 子级列表 */
#define queryCompanyPartList @"/fileLibrary/queryFilePartList"

/** 移动文件夹 */
#define shiftFileLibrary @"/fileLibrary/shiftFileLibrary"

/** 获取跟目录信息 */
#define queryFolderInitDetail @"/fileLibrary/queryFolderInitDetail"

/** 文件库文件上传 */
#define fileLibraryUpload @"/common/file/fileLibraryUpload"

/** 上传新版本 */
#define FileVersionUpload @"/common/file/fileVersionUpload"

/** 获取管理员列表 */
#define queryManageById @"/fileLibrary/queryManageById"

/** 添加管理员 */
#define savaManageStaff @"/fileLibrary/savaManageStaff"

/** 文件下载 */
#define fileDownload @"/library/file/download"

/** 下载历史版本 */
#define downloadHistoryFile @"/library/file/downloadHistoryFile"

/** 文件详情 */
#define queryFileLibarayDetail @"/fileLibrary/queryFileLibarayDetail"

/** 下载记录 */
#define queryDownLoadList   @"/fileLibrary/queryDownLoadList"

/** 历史版本 */
#define queryVersionList @"/fileLibrary/queryVersionList"

/** 共享 */
#define shareFileLibaray @"/fileLibrary/shareFileLibaray"

/** 取消共享 */
#define cancelShare @"/fileLibrary/cancelShare"

/** 退出共享 */
#define quitShare @"/fileLibrary/quitShare"

/** 点赞 */
#define whetherFabulous @"/fileLibrary/whetherFabulous"

/** 查询搜索记录 */
#define blurSearchFile @"/fileLibrary/blurSearchFile"

/** 搜索 */
#define getBlurResultParentInfo @"/fileLibrary/getBlurResultParentInfo"

/** 文件重命名 */
#define editRename @"/fileLibrary/editRename"

/** 删除管理员 */
#define delManageStaff @"/fileLibrary/delManageStaff"

/** 添加成员 */
#define savaMember @"/fileLibrary/savaMember"

/** 删除成员 */
#define delMember @"/fileLibrary/delMember"

/** 成员权限 */
#define updateSetting @"/fileLibrary/updateSetting"

/** 复制文件 */
#define copyFileLibrary @"/fileLibrary/copyFileLibrary"

/** 缩略图 */
#define downloadCompressedPicture @"/library/file/downloadCompressedPicture"

/** 应用文件夹根目录 */
#define queryAppFileList @"/fileLibrary/queryAppFileList"

/** 应用模块文件夹 */
#define queryModuleFileList @"/fileLibrary/queryModuleFileList"

/** 应用模块下文件 */
#define queryModulePartFileList @"/fileLibrary/queryModulePartFileList"

/** 项目文件项目列表 */
#define projectLibraryQueryProjectLibraryList @"/projectLibrary/queryProjectLibraryList"
/** 文件库管理员 */
#define FileAdministrator @"/fileLibrary/isFilelibraryAdministrator"

/** ----------------- 邮件 ---------------------- */
//邮件发送
#define mailOperationSend @"/mailOperation/send"

//获取个人有效账号
#define queryPersonnelAccount @"/mailAccount/queryPersonnelAccount"

//邮件列表
#define queryMailList @"/mailAccount/queryList"

//全部标为已读
#define markAllMailRead @"/mailOperation/markAllRead"

//标为已读
#define markMailReadOrUnread @"/mailOperation/markMailReadOrUnread"

//获取邮件联系人列表
#define mailCatalogQueryList @"/mailCatalog/queryList"

//最近联系人（邮件）
#define mailContactQueryList @"/mailContact/queryList"

//获取邮件列表
#define mailOperationQueryList @"/mailOperation/queryList"

//邮件详情
#define mailOperationQueryById @"/mailOperation/queryById"

//保存草稿
#define mailOperationSaveToDraft @"/mailOperation/saveToDraft"

//不同邮箱未读数
#define mailOperationQueryUnreadNumsByBox @"/mailOperation/queryUnreadNumsByBox"

//获取模块联系人
#define moduleEmailGetModuleEmails @"/moduleEmail/getModuleEmails"

//
#define moduleEmailGetModuleSubmenus @"/moduleEmail/getModuleSubmenus"

/** 自定义邮件列表 */
#define CustomEmailList @"/mailOperation/queryMailListByAccount"

//邮件回复
#define mailOperationMailReply @"/mailOperation/mailReply"

//邮件转发
#define mailOperationMailForward @"/mailOperation/mailForward"

//邮件模块选择
#define moduleEmailGetEmailFromModuleDetail @"/moduleEmail/getEmailFromModuleDetail"

//草稿箱删除
//#define mailOperationDeleteDraft @"/mailOperation/deleteDraft"
#define mailOperationDeleteDraft @"/mailOperation/clearMail"

//彻底删除
#define mailOperationClearMail @"/mailOperation/clearMail"

//标记不是垃圾邮件
#define mailOperationMarkNotTrash @"/mailOperation/markNotTrash"

//编辑草稿
#define mailOperationEditDraft @"/mailOperation/editDraft"

//手动发送
#define mailOperationManualSend @"/mailOperation/manualSend";

//收信
#define mailOperationReceive @"/mailOperation/receive"

/** -----------------备忘录---------------------- */
/** 创建备忘录 */
#define CreateNote @"/memo/save"
/** 编辑备忘录 */
#define UpdateNote @"/memo/update"
/** 备忘录详情 */
#define GetNoteDetail @"/memo/findMemoDetail"
/** 列表 */
#define GetNoteList @"/memo/findMemoList"

/** 删除 */
#define memoDel @"/memo/del"

/** 搜索要关联的模块数据 */
#define getFirstFieldFromModule @"/moduleOperation/getFirstFieldFromModule"

/** 获取关联数据 */
#define findRelationList @"/memo/findRelationList"
/** 更新关联数据 */
#define updateRelationById @"/memo/updateRelationById"

/** -----------------新项目---------------------- */

/**  -----------项目分享 */
//新增分享
#define projectShareControllerSave @"/projectShareController/save"

//修改分享
#define projectShareControllerEdit @"/projectShareController/edit"

//删除分享
#define projectShareControllerDelete @"/projectShareController/delete"

//关联变更
#define projectShareControllerEditRelevance @"/projectShareController/editRelevance"

//分享置顶
#define projectShareControllerShareStick @"/projectShareController/shareStick"

//分享点赞
#define projectShareControllerSharePraise @"/projectShareController/sharePraise"

//分享详情
#define projectShareControllerQueryById @"/projectShareController/queryById"

//分享列表
#define projectShareControllerQueryList @"/projectShareController/queryList"

//获取关联内容
#define projectShareControllerQueryRelationList @"/projectShareController/queryRelationList"

//分享关联内容
#define projectShareControllerSaveRelation @"/projectShareController/saveRelation"

//取消关联
#define projectShareControllerCancleRelation @"/projectShareController/cancleRelation"

/**  -----------项目文库 */
//文库列表
#define projectLibraryQueryLibraryList @"/projectLibrary/queryLibraryList"

//文库任务列表
#define projectLibraryQueryFileLibraryList @"/projectLibrary/queryFileLibraryList"

//文库列表
#define projectLibraryQueryTaskLibraryList @"/projectLibrary/queryTaskLibraryList"
// 文库根目录搜索
#define projectLibraryRootSearch @"/projectLibrary/searchTaskLibraryList"

//添加文库文件夹
#define projectLibrarySavaLibrary @"/projectLibrary/savaFileLibrary"

//修改文件夹
#define projectLibraryEditLibrary @"/projectLibrary/editLibrary"

//删除文件夹
#define projectLibraryDelLibrary @"/projectLibrary/delLibrary"

//共享文件夹
#define projectLibrarySharLibrary @"/projectLibrary/sharLibrary"

//上传文件
#define commonFileProjectUpload @"/common/file/projectPersonalUpload"

//下载文件
#define commonFileProjectDownload @"/common/file/projectDownload"

/** 文件下载l记录 */
#define FileProjectDownloadRecord @"/projectLibrary/queryDownLoadList"

/** 工作台改变人员权限 */
#define WorkBenchChangeAuth @"/projectTaskWorkbench/changeEmployeePrivilege"

/** 工作台切换人员列表 */
#define WorkBenchChangePeopleList @"/projectTaskWorkbench/employeeList"

/** -----------------项目---------------------- */
/** 创建项目 */
#define CreateProject @"/projectController/save"
/** 设置项目 */
#define UpdateProject @"/projectSettingController/saveInformation"
/** 获取项目列表 */
#define GetProjectList @"/projectController/queryAllList"
/** 项目详情 */
#define GetProjectDetail @"/projectSettingController/queryById"
/** 变更项目状态 */
#define ChangeProjectStatus @"/projectSettingController/editStatus"
/** 获取项目成员列表 */
#define GetProjectPeople @"/projectMemberController/queryList"
/** 添加项目成员 */
#define AddProjectPeople @"/projectMemberController/save"
/** 删除项目成员 */
#define DeleteProjectPeople @"/projectMemberController/delete"
/** 获取项目标签 */
#define GetProjectLabel @"/projectSettingController/queryLabelsList"
/** 获取个人标签 */
#define GetPersonnelLabel @"/projectManagementTagController/queryList"
/** 获取标签库 */
#define RepositoryLabel @"/projectManagementTagController/queryAllTagList"
/** 增加or删除项目标签 */
#define AddProjectLabel @"/projectSettingController/editLabels"
/** 更新项目星标 */
#define UpdateProjectStar @"/projectController/updateProjectAsterisk"
/** 更新项目进度 */
#define UpdateProjectProgress @"/projectSettingController/editProgress"
/** 获取项目角色列表 */
#define GetProjectRoleList @"/projectManagementRoleController/queryList"
/** 修改项目角色 */
#define UpdateProjectRole @"/projectMemberController/update"
/** 创建项目分组 */
#define CreateProjectSection @"/projectController/saveMainNode"
/** 更新项目分组 */
#define UpdateProjectSection @"/projectController/editMainNode"
/** 创建项目分组任务列 */
#define CreateProjectSectionRows @"/projectController/saveSubNode"
/** 更新项目分组任务列 */
#define UpdateProjectSectionRows @"/projectController/editSubNode"
/** 获取项目所有节点 */
#define GetProjectAllDot @"/projectController/queryAllNode"
/** 获取项目主节点 */
#define GetProjectColumn @"/projectController/queryMainNode"
/** 获取项目子节点 */
#define GetProjectSection @"/projectController/querySubNode"
/** 删除项目主节点 */
#define DeleteProjectColumn @"/projectController/deleteMainNode"
/** 删除项目子节点 */
#define DeleteProjectSection @"/projectController/deleteSubNode"
/** 项目主节点排序 */
#define SortProjectColumn @"/projectController/sortMainNode"
/** 项目子节点排序 */
#define SortProjectSection @"/projectController/sortSubNode"
/** 获取任务列中的任务 */
#define GetSectionTask @"/projectTaskController/queryWebList"
/** 添加项目引用 */
#define AddTaskQuote @"/projectTaskController/quote"
/** 创建任务 */
#define CreateTask @"/projectTaskController/save"
/** 创建子任务 */
#define CreateChildTask @"/projectTaskController/saveSub"
/** 任务详情 */
#define GetTaskDetail @"/projectTaskController/queryById"
/** 子任务详情 */
#define GetChildTaskDetail @"/projectTaskController/querySubById"
/** 子任务列表 */
#define GetChildTaskList @"/projectTaskController/querySubList"
/** 个人任务子任务列表 */
#define GetPersonnelChildTaskList @"/personelTask/querySubTaskByTaskId"
/** 任务关联 */
#define GetTaskRelation @"/projectTaskController/queryRelationList"
/** 任务被关联 */
#define GetTaskRelated @"/projectTaskController/queryByRelationList"
/** 任务添加关联任务 */
#define AddTaskRelation @"/projectTaskController/saveRelation"
/** 任务关联引用 */
#define QuoteTaskRelation @"/projectTaskController/quoteRelation"
/** 取消任务关联 */
#define CancelTaskRelation @"/projectTaskController/cancleRelation"
/** 取消个人任务关联 */
#define CancelPersonnelTaskRelation @"/personelTaskAssociates/deleteData"
/** 拖拽任务排序 */
#define DragTaskSort @"/projectTaskController/sort"
/** 完成或激活任务 */
#define FinishOrActiveTask @"/projectTaskController/updateStatus"
/** 完成或激活子任务 */
#define FinishOrActiveChildTask @"/projectTaskController/updateSubStatus"
/** 完成或激活个人任务 */
#define FinishOrActivePersonnelTask @"/personelTask/updateForFinish"
/** 任务或子任务点赞或取消点赞 */
#define TaskHeart @"/projectShareController/sharePraise"
/** 个人任务或子任务点赞或取消点赞 */
#define PersonnelTaskHeart @"/personelTaskPraiseRecord/saveData"
/** 任务or子任务点赞列表 */
#define TaskHeartPeople @"/projectShareController/praiseQueryList"
/** 个人任务or子任务点赞列表 */
#define PersonnelTaskHeartPeople @"/personelTaskPraiseRecord/getPraisePerson"
/** 任务层级 */
#define Taskhierarchy @"/projectTaskController/queryByHierarchy"
/** 任务协作人可见 */
#define TaskVisible @"/projectTaskController/update"
/** 个人任务协作人可见 */
#define PersonnelTaskVisible @"/personelTaskMember/updateTask"
/** 校验任务 */
#define TaskCheck @"/projectTaskController/updatePassedStatus"
/** 校验子任务 */
#define ChildTaskCheck @"/projectTaskController/updateSubPassedStatus"
/** 移动任务 */
#define TaskMoveToOther @"/projectTaskController/updateTaskSubNode"
/** 复制任务 */
#define TaskCopyToOther @"/projectTaskController/copyTask"
/** 删除任务 */
#define DeleteTask @"/projectTaskController/delete"
/** 删除子任务 */
#define DeleteChildTask @"/projectTaskController/deleteSub"
/** 引用任务列表 */
#define QuoteTaskList @"/projectTaskController/queryQuoteTask"
/** 任务筛选自定义条件 */
#define QueryProjectTaskCondition @"/projectTaskController/queryProjectTaskConditions"
/** 任务筛选 */
#define ProjectTaskFilter @"/projectTaskController/queryProjectTaskListByCondition"
/** 个人任务筛选 */
#define PersonnelTaskFilter @"/personelTask/queryTaskListByCondition"
/** 个人任务详情 */
#define PersonnelTaskDetail @"/personelTask/getDataDetail"
/** 个人任务子任务详情 */
#define PersonnelSubTaskDetail @"/personelSubTask/getDataDetail"
/** 项目中的任务 */
#define TaskInProject @"/personelTask/findTaskListByProjectId"
/** 项目任务协作人列表 */
#define GetProjectTaskCooperationPeopleList @"/projectMemberController/queryTaskList"
/** 个人任务协作人列表 */
#define GetPersonnelTaskCooperationPeopleList @"/personelTaskMember/queryMembersTaskId"
/** 个人任务角色 */
#define GetPersonnelTaskRole @"/personelTaskMember/getTaskRoleFromPersonelTask"
/** 添加项目任务协作人 */
#define AddProjectTaskCooperationPeople @"/projectMemberController/saveTaskMember"
/** 添加个人任务协作人 */
#define AddPersonnelTaskCooperationPeople @"/personelTaskMember/saveData"
/** 删除项目任务协作人 */
#define DeleteProjectTaskCooperationPeople @"/projectMemberController/deleteTaskMember"
/** 删除个人任务协作人 */
#define DeletePersonnelTaskCooperationPeople @"/personelTaskMember/deleteData"
/** 新建个人任务子任务 */
#define CreatePersonnelSubTask @"/personelSubTask/saveData"
/** 个人任务引用个人任务 */
#define PersonnelTaskQuotePersonnelTask @"/personelTaskAssociates/saveData"
/** 个人任务关联列表 */
#define PersonnelTaskRelationList @"/personelTaskAssociates/queryTaskAssociatesByTaskIdAndType"
/** 个人任务被关联 */
#define PersonnelTaskByRelated @"/personelTaskAssociates/queryBeTaskAssociatesByTaskIdAndType"
/** 编辑个人任务 */
#define PersonnelTaskEdit @"/personelTask/update"
/** 编辑个人任务子任务 */
#define PersonnelSubTaskEdit @"/personelSubTask/update"
/** 编辑项目任务/子任务 */
#define ProjectTaskEdit @"/projectLayoutOperation/edit"
/** 个人任务删除 */
#define PersonnelTaskDelete @"/personelTask/deleteData"
/** 个人任务子任务删除 */
#define PersonnelSubTaskDelete @"/personelSubTask/deleteData"
/** 获取项目任务提醒 */
#define GetProjectTaskRemain @"/projectTaskRemind/getTaskRemindList"
/** 保存项目任务提醒 */
#define SaveProjectTaskRemain @"/projectTaskRemind/saveData"
/** 更新项目任务提醒 */
#define UpdateProjectTaskRemain @"/projectTaskRemind/updateData"
/** 获取所有项目 */
#define GetAllProject @"/projectController/queryAllWebList"
/** 获取个人任务 */
#define GetPersonnelTaskList @"/personelTask/queryTaskList"
/** 获取工作流 */
#define GetProjectWorkflow @"/projectWorkflow/queryDataList"
/** 工作流预览 */
#define ProjectWorkflowPreview @"/projectWorkflow/queryNodesNameById"
/** 获取个人任务筛选 */
#define GetPersonnelTaskFilterCondition @"/personelTask/findPersonelTaskConditions"
/** 自定义模块列表 */
#define GetMyselfCustomModule @"/personelTask/findAllModuleListByAuth"
/** 获取工作台列表 */
#define GetWorkBenchList @"/projectWorkbenchController/queryListByFilterAuth"
/** 获取时间工作流数据 */
//#define GetWorkBenchTimeData @"/projectTaskWorkbench/queryTimeWorkbenchWebList"
#define GetWorkBenchTimeData @"/projectTaskWorkbench/queryTaskWorkbenchList"
/** 获取企业工作流程 */
#define EnterpriseWorkBenchFlow @"/projectWorkbenchController/queryWorkflowListBy"
/** 获取企业工作台数据 */
#define EnterpriseWorkBenchFlowData @"/projectTaskWorkbench/queryFlowWorkbenchWebList"
/** 移动时间工作台数据 */
#define MoveTimeWorkBench @"/projectTaskWorkbench/moveTimeWorkbench"
/** 移动企业工作台数据 */
#define MoveEnterpriseWorkBench @"/projectTaskWorkbench/moveFlowWorkbench"
/** 项目模板列表 */
#define ProjectTemplateList @"/projectTemplateController/queryProjectTemplateList"
/** 项目模板预览 */
#define ProjectTemplatePreview @"/projectTemplateController/queryAllNode"
/** 项目角色及权限 */
#define GetProjectRoleAndAuth @"/projectMemberController/queryManagementRoleInfo"
/** 项目任务角色权限 */
#define GetProjectTaskRoleAuth @"/projectSettingController/queryTaskAuthList"
/** 项目任务查看状态 */
#define GetProjectTaskSeeStatus @"/projectTaskController/queryTaskViewStatus"
/** 个人任务查看状态 */
#define GetPersonnelTaskSeeStatus @"/personelTaskMember/queryTaskViewStatus"
/** 保存项目任务重复 */
#define SaveProjectTaskRepeat @"/projectTaskRepeat/saveData"
/** 更新项目任务重复 */
#define UpdateProjectTaskRepeat @"/projectTaskRepeat/updateData"
/** 获取项目任务重复 */
#define GetProjectTaskRepeat @"/projectTaskRepeat/getTaskRepeatList"
/** 获取个人任务提醒 */
#define GetPersonnelTaskRemind @"/personelTaskRemind/getTaskRemindList"
/** 保存个人任务提醒 */
#define SavePersonnelTaskRemind @"/personelTaskRemind/saveData"
/** 更新个人任务提醒 */
#define UpdatePersonnelTaskRemind @"/personelTaskRemind/updateData"
/** 获取个人任务重复 */
#define GetPersonnelTaskRepeat @"/personelTaskRepeat/getTaskRepeatList"
/** 保存个人任务重复 */
#define SavePersonnelTaskRepeat @"/personelTaskRepeat/saveData"
/** 更新个人任务重复 */
#define UpdatePersonnelTaskRepeat @"/personelTaskRepeat/updateData"
/** 编辑项目任务 */
#define UpdateProjectTask @"/projectTaskController/updateTask"
/** 编辑项目子任务 */
#define UpdateProjectChildTask @"/projectTaskController/updateSub"
/** 项目任务完成及激活权限 */
#define GetProjectFinishAndActiveAuth @"/projectTaskController/queryCompleteTaskAuth"
/** 移出成员是否需要指定工作交接人 */
#define DeleteProjectPeopleTransferTask @"/projectMemberController/replacer"
/** 层级视图取消关联 */
#define BoardCancelQuote @"/projectTaskController/cancleQuote"

/** -----------------新员工列表---------------------- */
/** 项目所有节点 */
#define ProjectAllNode @"/projectController/queryAllNode"
/**项目模板节点 */
#define ProjectTempAllNode @"/projectTemplateController/queryAllNode"
/** 新增节点 */
#define ProjectAddNode @"/projectNodeController/saveNode"
/** 更新节点 */
#define ProjectUpdateNode @"/projectNodeController/updateNode"
/** 删除节点 */
#define ProjectDeleteNode @"/projectNodeController/deleteNode"
/** 新增任务 */
#define ProjectAddTask @"/projectTaskController/saveTask"
/** 编辑任务 */
#define ProjectUpdateTask @"/projectTaskController/updateTask"
/** 新增子任务 */
#define ProjectAddSubTask @"/projectTaskController/saveSub"
/** 编辑子任务 */
#define ProjectUpdateSubTask @"/projectTaskController/updateSub"
/** 复制任务 */
#define ProjectCopyTask @"/projectTaskController/copyTask"
/** 移动任务 */
#define ProjectMoveTask @"/projectTaskController/moveTask"
/** 子任务列表 */
#define ProjectGetSubTask @"/projectTaskController/querySubList"
/** 任务混合动态 */
#define TaskHybirdDynamic @"/projectTaskController/queryTaskDynamicList"
/** 个人任务列表 */
#define NewPersonnelTaskList @"/projectTaskController/queryPersonelTaskList"
/** 项目任务列表 */
#define NewProjectTaskList @"/projectTaskController/queryProjectTaskList"

/** -----------------新员工列表---------------------- */
/** 员工列表 */
#define EmployeeList @"/employee/selectEmployeeList"
/** 修改员工 */
#define UpdateEmployee @"/employee/editEmployeeDetail"

/** 组织架构 */
#define CompanyFramework @"/user/findUsersByCompany"
/** 修改密码 */
#define modPassWrd @"/user/editPassWord"
/** 员工详情 */
#define EmployeeDetail @"/employee/queryEmployeeInfo"
//#define EmployeeDetail @"/user/queryInfo"
/** 角色组列表 */
#define GetRoleGroupList @"/moduleDataAuth/getRoleGroupList"
/** 组织架构模糊查找 */
#define FindByUserName @"/user/findByUserName"
/** 动态参数 */
#define GetSharePersonalFields @"/layout/getSharePersonalFields"

/** 新增员工 */
#define AddEmployee @"/employee/savaEmployee"
/** 新增职位 */
#define AddPosition @"/employee/savaPost"
/** 修改职位 */
#define UpdatePosition @"/employee/editEmployee"
/** 职位列表 */
#define GetPositionList @"/employee/queryPost"
/** 新增部门 */
#define AddDepartment @"/employee/savaDepartment"
/** 修改部门 */
#define UpdateDepartment @"/employee/editDepartment"
/** 删除部门 */
#define DeleteDepartment @"/employee/delDepartment"
/** 部门列表 */
#define DepartmentList @"/employee/findCompanyDepartment"
/** 批量调整人员部门 */
#define BetchAdjustDepartment @"/employee/betchEditDepartment"

/** 员工信息 */
#define queryEmployeeInfo @"/employee/queryEmployeeInfo"

/** 点赞 */
#define empWhetherFabulous @"/employee/whetherFabulous"

/** 获取最近登录公司密码策略 */
#define GetCompanySet @"/user/getCompanySet"

/** 更换手机号 */
#define ChangeTelephone @"/user/modifyPhone"

/** 获取banner */
#define GetBanner @"/user/queryCompanyBanner"

/** 获取名片样式 */
#define GetCardStyle @"/employee/queryEmployeeCard"

/** 保存名片样式 */
#define SaveCardStyle @"/employee/savaCardInfo"

#pragma mark ++++++++++++++++考勤+++++++++++++++
                         /**                   考勤方式                 */
/** 新增考勤方式 */
#define attendanceWaySave @"/attendanceWay/save"
/** 考勤方式列表 */
#define attendanceWayFindList @"/attendanceWay/findWebList"
/** 修改考勤方式 */
#define attendanceWayUpdate @"/attendanceWay/update"
/** 删除考勤方式 */
#define attendanceWayDel @"/attendanceWay/del"
/** 考勤方式详情 */
#define attendanceWayFindDetail   @"/attendanceWay/findDetail"

                         /**                   班次管理                  */
/** 新增班次管理 */
#define attendanceClassSave @"/attendanceClass/save"
/** 班次管理列表 */
#define attendanceClassFindList @"/attendanceClass/findWebList"
/** 删除班次管理 */
#define attendanceClassDel @"/attendanceClass/del"
/** 修改班次管理 */
#define attendanceClassUpdate    @"/attendanceClass/update"
/** 班次管理详情 */
#define attendanceClassFindDetail @"/attendanceClass/findDetail"

                         /**                   打卡规则                  */
/** 新增考勤规则 */
#define attendanceScheduleSave @"/attendanceGroup/save"
/** 考勤规则列表 */
#define attendanceScheduleFindList @"/attendanceGroup/findWebList1"
/** 删除考勤规则 */
#define attendanceScheduleDel @"/attendanceGroup/del"
/** 修改考勤规则 */
#define attendanceScheduleUpdate @"/attendanceGroup/update"
/** 考勤规则详情 */
#define attendanceScheduleFindDetail @"/attendanceGroup/findDetail"

                         /**                   其他设置                  */
/** 其他设置新增新增管理员 */
#define attendanceSettingSaveAdmin @"/attendanceSetting/saveAdmin"
/** 其他设置修改管理员 */
#define attendanceSettingUpdate @"/attendanceSetting/update"
/** 其他设置新增/修改打卡提醒 */
#define attendanceSettingSaveRemind @"/attendanceSetting/saveRemind"
/** 其他设置新增/修改榜单设置 */
#define attendanceSettingSaveCount @"/attendanceSetting/saveCount"
/** 其他设置新增/修改晚走晚到 */
#define attendanceSettingSaveLate @"/attendanceSetting/saveLate"
/** 其他设置新增/修改人性化班次 */
#define attendanceSettingSaveHommization @"/attendanceSetting/saveHommization"
/** 其他设置新增/修改旷工规则 */
#define attendanceSettingSaveAbsenteeism @"/attendanceSetting/saveAbsenteeism"
/** 其他设置根据ID查询详情 */
#define attendanceSettingFindDetail @"/attendanceSetting/findDetail"
/** 晚走晚到 */
#define attendanceLateWork @"/attendanceSetting/saveLate"
                        /**                   排班详情                  */
/** 排班详情查询 */
#define attendanceManagementFindAppDetail  @"/attendanceManagement/findAppDetail"
/** 获取考勤组列表 */
#define attendanceScheduleFindScheduleList @"/attendanceSchedule/findScheduleList"
/** 排班周期详情 */
#define attendanceCycleFindDetail @"/attendanceCycle/findDetail"

                      /**             打卡                 */
/** 获取当日考勤信息 */
#define GetTodayAttendanceInfo @"/attendanceClock/getUserAttendanceGroup"
/** 获取当日打卡记录 */
#define GetTodayAttendanceRecord @"/attendanceClock/queryAttendanceRecord"
/** 打卡 */
#define PunchAttendance @"/attendanceClock/punchClock"

                /**                 统计                    */
/** 日统计 */
#define AttendanceDayStatistics @"/attendanceReport/appDaydataList"
/** 月统计 */
#define AttendanceMonthStatistics @"/attendanceReport/getAppMonthDataByAuth"
/** 我的月统计 */
#define MyMonthStatistics @"/attendanceReport/getAppMonthDataBySelf"
/** 打卡月历 */
#define AttendanceEmployeeMonthStatistics @"/attendanceReport/getAppMonthDataBySelfForCalendar"
/** 早到榜 */
#define AttendanceEarlyRank @"/attendanceReport/earlyArrivalList"
/** 勤勉榜 */
#define AttendanceHardworkingRank @"/attendanceReport/diligentList"
/** 迟到榜 */
#define AttendanceLateRank @"/attendanceReport/lateList"
/** 获取榜单考勤组 */
#define AttendanceGroupList @"/attendanceReport/queryGroupList"
/** 打卡人员列表 */
#define AttendancePunchPeoples @"/attendanceRecord/punchcardList"
/** 打卡状态人员列表 */
#define AttendancePunchStatusPeoples @"/attendanceRecord/statusList"
/** 关联审批单 */
#define AttendanceReferenceApprovalList @"/attendanceRelevanceApprove/findList"
/** 审批单详情 */
#define AttendanceReferenceApprovalDetail @"/attendanceRelevanceApprove/findDetail"
/** 关联审批创建 */
#define AttendanceReferenceApprovalCreate @"/attendanceRelevanceApprove/save"
/** 关联审批编辑 */
#define AttendanceReferenceApprovalUpdate @"/attendanceRelevanceApprove/update"
/** 关联审批删除 */
#define AttendanceReferenceApprovalDelete @"/attendanceRelevanceApprove/del"
/** 审批模块列表 */
#define AttendanceApprovalModuleList @"/attendanceRelevanceApprove/findApproveList"
/** 审批模块字段 */
#define ttendanceApprovalModuleField @"/layout/getFieldsByModule"


/**
 case HQCMD_attendanceReferenceApprovalList:
 pathURL = AttendanceReferenceApprovalList;
 break;
 case HQCMD_attendanceReferenceApprovalDetail:
 pathURL = AttendanceReferenceApprovalDetail;
 break;
 case HQCMD_attendanceReferenceApprovalCreate:
 pathURL = AttendanceReferenceApprovalCreate;
 break;
 case HQCMD_attendanceReferenceApprovalUpdate:
 pathURL = AttendanceReferenceApprovalUpdate;
 break;
 case HQCMD_attendanceReferenceApprovalDelete:
 pathURL = AttendanceReferenceApprovalDelete;
 break;
 case HQCMD_attendanceApprovalModuleList:
 pathURL = AttendanceApprovalModuleList;
 break;
 case HQCMD_attendanceApprovalModuleField:
 pathURL = ttendanceApprovalModuleField;
 break; */

/** 保存知识 */
#define SaveKnowledge @"/repositoryLibraries/save"
/** 删除知识 */
#define DeleteKnowledge @"/repositoryLibraries/del"
/** 更新知识 */
#define UpdateKnowledge @"/repositoryLibraries/update"
/** 知识详情 */
#define GetKnowledgeDetail @"/repositoryLibraries/getDataDetail"

/** 知识列表 */
#define GetKnowledgeList @"/repositoryLibraries/queryRepositoryLibrariesList"
/** 知识分类及标签 */
#define GetKnowledgeCategoryAndLabel @"/repositoryLibraries/getRepositoryClassificationList"
/** 标签 */
#define KnowledgeLabel @"/repositoryLabel/getRepositoryLabelList"
/** 确认学习知识 */
#define SureLearnKnowledge @"/repositoryLibraries/updateLearning"
/** 学习知识人员 */
#define  LearnAndReadKnowledgePeople @"/repositoryLibraries/getReadLearningPersons"
/** 点赞知识 */
#define  GoodKnowledge @"/repositoryLibraries/updatePraise"
/** 点赞知识人员 */
#define  GoodKnowledgePeople @"/repositoryLibraries/getPraisePersons"
/** 收藏知识 */
#define  CollectKnowledge @"/repositoryLibraries/updateCollection"
/** 收藏知识人员 */
#define  CollectKnowledgePeople @"/repositoryLibraries/getCollectionPersons"
/** 知识版本 */
#define  KnowledgeVersion @"/repositoryLibraries/getRepositoryVersions"
/** 知识分类 */
#define GetKnowledgeCategory @"/repositoryClassification/getRepositoryClassificationList"
/** 知识移动 */
#define KnowledgeMove @"/repositoryLibraries/updateMove"
/** 保存回答 */
#define AnwserSave @"/repositoryAnswer/save"
/** 修改回答 */
#define AnwserUpdate @"/repositoryAnswer/update"
/** 修改回答 */
#define AnwserDelete @"/repositoryAnswer/del"
/** 回答详情 */
#define AnwserDetail @"/repositoryAnswer/getDataDetail"
/** 某提问的回答列表 */
#define AnwserList @"/repositoryAnswer/getRepositoryAnswerList"
/** 知识和提问置顶 */
#define KnowledgeTop @"/repositoryLibraries/topSetting"
/** 回答置顶 */
#define AnwserTop @"/repositoryAnswer/updatePlacedAtTheTop"
/** 知识引用列表 */
#define KnowledgeReferances @"/repositoryLibrariesAssociates/queryAssociatesByRepositoryId"
/** 邀请回答*/
#define InviteToAnswer @"/repositoryLibraries/updateInvitePersonsToAnswer"
/** 将item装换为card */
#define ChangeItemToCard @"/projectTaskController/queryTaskInfoByIds"


#endif /* HQConst_h */





























