//
//  HQBaseBL.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/12.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseBL.h"

@implementation HQBaseBL


//构造一个子类对象
+ (id)build
{
    id obj = [[[self class] alloc] init];
    return obj;
}

- (void)dealloc{
    //    BLog(@"%@", self);
    
    //移除所有的网络请求任务
    for (HQRequestItem *item in _tasks) {
        item.delegate = nil;
        item.willRequestBlk = nil;
    }
    [_tasks removeAllObjects];
}

- (id)init{
    self = [super init];
    if (self) {
        //        self.reqInfoQueue = [[NSMutableDictionary alloc] init];
        
        self.tasks = [NSMutableArray array];
    }
    return self;
}

//- (NSDictionary*)baseRequestBag{
//    return @{
//             @"TOKEN":@""};
//}

//转换成服务器指定格式数据
- (NSDictionary *)toDestinationJson:(NSDictionary *)dictionary{
    
    //基础公共数据包
    NSDictionary *baseBag;
    
    NSMutableDictionary *finalBag = [NSMutableDictionary dictionaryWithDictionary:baseBag];
    if (dictionary && dictionary.count>0) {
        [finalBag addEntriesFromDictionary:dictionary];
    }
    
    NSData * jsonData=  [NSJSONSerialization dataWithJSONObject:finalBag options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    //    NSDictionary * desDict = @{@"json_class": jsonString};
    NSDictionary * desDict = @{@"JSON_CLASS": jsonString};
    return desDict;
}


////转换成服务器指定格式数据
//- (NSDictionary *)convertToDestinationJson:(NSDictionary *)dictionary{
//    //基础公共数据包
//    NSDictionary *baseBag = [self baseRequestBag];
//
//
//    NSMutableDictionary *finalBag = [NSMutableDictionary dictionaryWithDictionary:baseBag];
//    if (dictionary && dictionary.count>0) {
//        [finalBag addEntriesFromDictionary:dictionary];
//    }
//
//    NSArray *array = [finalBag allKeys];
//    NSMutableString *source = [NSMutableString stringWithString:@"{"];
//    for (int i = 0; i< array.count; i++) {
//        NSString *key = [array objectAtIndex:i];
//        NSString *value = [finalBag objectForKey:key];
//        HQLog(@"%@,%@",key,value);
//        if ([value isKindOfClass:[NSString class]]) {
//            [source appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",",key,value]];
//        }else{
//            [source appendString:[NSString stringWithFormat:@"\"%@\":%@,",key,value]];
//        }
//    }
//    NSString *temp = [source substringToIndex:([source length] -1)];
//    NSString *strl = [NSString stringWithFormat:@"%@%@",temp,@"}"];
//    HQLog(@"source %@",strl);
//    NSDictionary *desDict = @{@"json":strl};
//    return desDict;
//}



//如果字典中包有respData的KEY，把该值返回
- (id)checkData:(id)data;
{
    
    if (!data) {
        return nil;
    }
    
    if (![data isKindOfClass:[NSDictionary class]]) {
        
        return data;
    }
    
    NSDictionary *dic = data;
    
    if ([dic.allKeys containsObject:kData]) {
        
        data = dic[kData];
    }
    
    return data;
}



////从网络请求信息队列中 移除网络请求序列号为sid的任务信息
//- (void)removeRequestInfoBySid:(NSInteger)sid
//{
//    NSNumber *sidNumber = [NSNumber numberWithInteger:sid];
//    if ([[self.reqInfoQueue allKeys] containsObject:sidNumber]) {
//        [self.reqInfoQueue removeObjectForKey:sidNumber];
//    }
//}

/**
 *  获取错误码
 *
 *  @param respBag 服务器回包
 *
 *  @return 错误码
 */
- (HQRESCode)getResCodeFromRespBag:(id)respBag
{
    if (respBag && [respBag isKindOfClass:[NSDictionary class]]) {
        if ([[respBag[kCode] description] isEqualToString:@"common.sucess"] || [[respBag[kCode] description] isEqualToString:@"1001"]) {
            return HQRESCode_Success;
        }
    }
    return HQRESCode_UNKNOWN;
}

/**
 *  获取错误消息
 *
 *  @param respBag 服务器回包
 *
 *  @return 错误信息
 */
- (NSString *)getMessFromRespBag:(id)respBag
{
    NSString *errorDesc = nil;
    if (respBag && [respBag isKindOfClass:[NSDictionary class]]) {
        errorDesc = respBag[kCode];
    }
    if (errorDesc || [errorDesc isEqualToString:@""]) {
        errorDesc = @"未知错误!";
    }
    return errorDesc;
}

//- (NSString*)urlFromCmd:(HQCMD)cmd testParam:(NSString *)testParam
//{
//
//    return [NSString stringWithFormat:@"%@?testParam=%@", [self urlFromCmd:cmd], testParam];
//}

//- (NSString*)urlFromCmd:(HQCMD)cmd moduleType:(NSInteger)moduleType
//{
//    
//    return [NSString stringWithFormat:@"%@?moduleType=%d", [self urlFromCmd:cmd], (int)moduleType];
//}
//
//- (NSString*)urlFromCmd:(HQCMD)cmd pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize
//{HQCMD_getCommonCommentList
//    
//    return [NSString stringWithFormat:@"%@/%d/%d", [self urlFromCmd:cmd], (int)pageNum, (int)pageSize];
//}


- (NSString*)urlFromCmd:(HQCMD)cmd
{
    
    NSString *pathURL = nil;
    
    if (cmd == HQCMD_getSectionTask) {// 获取任务列中的数据
        pathURL = GetSectionTask;
    }else if (cmd == HQCMD_getWorkBenchTimeData){// 获取时间工作台数据
        pathURL = GetWorkBenchTimeData;
    }else if (cmd == HQCMD_enterpriseWorkBenchFlowData){// 获取企业工作台数据
        pathURL = EnterpriseWorkBenchFlowData;
    }
    
    switch (cmd) {
            
        
            /******************  上传文件  ************************/
        case HQCMD_uploadFile:    // 上传文件流
            pathURL = UploadFile;
            break;
        case HQCMD_ImageFile:    // 上传文件流
            pathURL = ImageUpload;
            break;
        case HQCMD_ChatFile:    // 上传文件流
            pathURL = ChatFile;
            break;
            
            /******************  新登录注册  ************************/
        case HQCMD_userNewRegister:      // 用户新注册
            pathURL = UserNewRegister;
            break;
        case HQCMD_userRegister:      // 用户注册
            pathURL = UserRegister;
            break;
        case HQCMD_userLogin:     // 用户登录
            pathURL = UserLogin;
            break;
        case HQCMD_sendVerifyCode:        //验证码
            pathURL = SendVerifyCode;
            break;
        case HQCMD_verifyVerificationCode:        //验证验证码
            pathURL = VerifyVerificationCode;
            break;
        case HQCMD_scanCodeSubmit:        //扫码提交
            pathURL = ScanCodeSubmit;
            break;
        case HQCMD_modifyPassWord:        //忘记密码
            pathURL = ModifyPassWord;
            break;
        case HQCMD_setupCompanyInfo:        // 初始化企业信息
            pathURL = SetupCompanyInfo;
            break;
        case HQCMD_setupEmployeeInfo:        // 初始化个人信息
            pathURL = SetupEmployeeInfo;
            break;
        case HQCMD_getCompanyList:        // 公司列表
            pathURL = GetCompanyList;
            break;
        case HQCMD_changeCompany:        // 切换公司
            pathURL = ChangeCompany;
            break;
        case HQCMD_getEmployeeAndCompanyInfo:        // 登录后获取员工和公司信息
            pathURL = GetEmployeeAndCompanyInfo;
            break;
        case HQCMD_getEmployeeInfo:        // 登录后获取员工和公司信息
            pathURL = GetEmployeeInfo;
            break;
            
            
            
            /******************  权限   **************************/
            
        case HQCMD_getEmployeeRole:          // 获取角色权限
            pathURL = GetEmployeeRole;
            break;
        case HQCMD_getRoleAuth:          // 获取角色权限
            pathURL = GetRoleAuth;
            break;
        case HQCMD_getEmployeeModuleAuth:      // 获取员工模块权限
            pathURL = GetEmployeeModuleAuth;
            break;
        case HQCMD_getModuleFunctionAuth:      // 获取模块功能权限
            pathURL = GetModuleFunctionAuth;
            break;
            
            
            /******************  自定义   **************************/
            
        case HQCMD_customLayout:      // 获取布局
            pathURL = CustomLayout;
            break;
        case HQCMD_customTaskLayout:      // 获取任务布局
            pathURL = CustomTaskLayout;
            break;
        case HQCMD_saveTaskLayoutData:      // 保存项目任务信息
            pathURL = SaveTaskLayoutData;
            break;
        case HQCMD_savePersonnelData:      // 保存个人任务信息
            pathURL = SavePersonnelData;
            break;
        case HQCMD_customApplicationList:      // 获取自定义应用列表
            pathURL = CustomApplicationList;
            break;
        case HQCMD_customApplicationOften:      // 编辑常用应用列表
            pathURL = CustomApplicationOften;
            break;
        case HQCMD_customSave:      // 自定义保存
            pathURL = CustomSave;
            break;
        case HQCMD_customDelete:      // 自定义删除
            pathURL = CustomDelete;
            break;
        case HQCMD_customEdit:      // 自定义编辑
            pathURL = CustomEdit;
            break;
        case HQCMD_customDetail:      // 自定义详情
            pathURL = CustomDetail;
            break;
        case HQCMD_customDataList:      // 业务数据列表
            pathURL = CustomDataList;
            break;
        case HQCMD_customChildMenuList:      // 获取子菜单列表
            pathURL = CustomChildMenuList;
            break;
        case HQCMD_customRefernceSearch:      // 关联搜索
            pathURL = CustomRefernceSearch;
            break;
        case HQCMD_customChecking:      // 查重
            pathURL = CustomChecking;
            break;
        case HQCMD_customFilterFields:      // 筛选条件
            pathURL = CustomFilterFields;
            break;
        case HQCMD_customRefernceModule:      // 关联模块
            pathURL = CustomRefernceModule;
            break;
        case HQCMD_customModuleAuth:      // 模块功能
            pathURL = CustomModuleAuth;
            break;
        case HQCMD_customTransferPrincipal:      // 转移负责人
            pathURL = CustomTransferPrincipal;
            break;
        case HQCMD_customShareList:      // 共享设置列表
            pathURL = CustomShareList;
            break;
        case HQCMD_customShareDelete:      // 删除某个共享设置
            pathURL = CustomShareDelete;
            break;
        case HQCMD_customShareSave:      // 删除某个共享设置
            pathURL = CustomShareSave;
            break;
        case HQCMD_customShareEdit:      // 编辑设置
            pathURL = CustomShareEdit;
            break;
        case HQCMD_customModuleChangeList:      // 模块交换列表
            pathURL = CustomModuleChangeList;
            break;
        case HQCMD_customModuleChange:      // 模块交换
            pathURL = CustomModuleChange;
            break;
        case HQCMD_customCommentSave:      // 评论保存
            pathURL = CustomCommentSave;
            break;
        case HQCMD_customCommentList:      // 评论列表
            pathURL = CustomCommentList;
            break;
        case HQCMD_customDynamicList:      // 动态列表
            pathURL = CustomDynamicList;
            break;
        case HQCMD_customApprovalList:      // 审批列表
            pathURL = CustomApprovalList;
            break;
        case HQCMD_getApprovalListWithBean:      // 某模块下审批列表
            pathURL = GetApprovalListWithBean;
            break;
        case HQCMD_customApprovalSearchMenu:      // 审批筛选菜单
            pathURL = CustomApprovalSearchMenu;
            break;
        case HQCMD_customApprovalWholeFlow:      // 审批流程
            pathURL = CustomApprovalWholeFlow;
            break;
        case HQCMD_customApprovalPass:      // 审批通过
            pathURL = CustomApprovalPass;
            break;
        case HQCMD_customApprovalReject:      // 审批驳回
            pathURL = CustomApprovalReject;
            break;
        case HQCMD_customApprovalTransfer:      // 审批转交
            pathURL = CustomApprovalTransfer;
            break;
        case HQCMD_customApprovalRevoke:      // 审批撤销
            pathURL = CustomApprovalRevoke;
            break;
        case HQCMD_customApprovalCopy:      // 审批抄送
            pathURL = CustomApprovalCopy;
            break;
        case HQCMD_customApprovalUrge:      // 审批催办
            pathURL = CustomApprovalUrge;
            break;
        case HQCMD_customApprovalRead:      // 审批已读
            pathURL = CustomApprovalRead;
            break;
        case HQCMD_customApprovalCount:      // 审批数量
            pathURL = CustomApprovalCount;
            break;
        case HQCMD_customApprovalRejectType:      // 审批驳回方式
            pathURL = CustomApprovalRejectType;
            break;
        case HQCMD_customApprovalPassType:      // 审批驳回方式
            pathURL = CustomApprovalPassType;
            break;
        case HQCMD_customRemoveProcessApproval:      // 审批删除
            pathURL = CustomRemoveProcessApproval;
            break;
        case HQCMD_CustomQueryApprovalData:      // 获取审批详情参数
            pathURL = CustomQueryApprovalData;
            break;
            
        case HQCMD_highseaTake:      // 公海池领取
            pathURL = CustomHighseaTake;
            break;
        case HQCMD_highseaMove:      // 公海池移动
            pathURL = CustomHighseaMove;
            break;
        case HQCMD_highseaBack:      // 公海池退回
            pathURL = CustomHighseaBack;
            break;
        case HQCMD_highseaAllocate:      // 公海池分配
            pathURL = CustomHighseaAllocate;
            break;
        case HQCMD_highseaList:      // 公海池列表
            pathURL = CustomHighseaList;
            break;
        case HQCMD_getReportList:      // 统计列表
            pathURL = GetReportList;
            break;
        case HQCMD_getReportFilterFields:    // 统计筛选字段
            pathURL = GetReportFilterFields;
            break;
        case HQCMD_getReportFilterFieldsWithReportId:    // 统计筛选字段
            pathURL = GetReportFilterFieldsWithReportId;
            break;
        case HQCMD_getReportDetail:    // 报表详情
            pathURL = GetReportDetail;
            break;
        case HQCMD_getChartDetail:    // 报表详情
            pathURL = GetChartDetail;
            break;
        case HQCMD_getReportLayoutDetail:    // 报表布局详情
            pathURL = GetReportLayoutDetail;
            break;
        case HQCMD_getChartList:    // 图表列表
            pathURL = GetChartList;
            break;
            
        case HQCMD_CustomApprovalCheckChooseNextApproval:    // 是否需要选择下一审批人（邮件）
            pathURL = CustomApprovalCheckChooseNextApproval;
            break;
        case HQCMD_allApplications:    // 所有应用
            pathURL = AllApplications;
            break;
        case HQCMD_allModules:    // 应用下的模块
            pathURL = AllModules;
            break;
        case HQCMD_saveOftenModule:    // 保存常用模块
            pathURL = SaveOftenModule;
            break;
        case HQCMD_moduleHaveAuth:    // 模块是否有新建权限
            pathURL = ModuleHaveAuth;
            break;
        case HQCMD_moduleHaveReadAuth:    // 模块是否有阅读权限
            pathURL = ModuleHaveReadAuth;
            break;
        case HQCMD_customRangePeople:    // 自定义人员选择范围
            pathURL = CustomRangePeople;
            break;
        case HQCMD_customRangeDepartment:    // 自定义人员选择范围
            pathURL = CustomRangeDepartment;
            break;
        case HQCMD_quickAdd:    // 快速新增
            pathURL = QuickAdd;
            break;
        case HQCMD_createBarcode:    // 生成条形码
            pathURL = CreateBarcode;
            break;
        case HQCMD_barcodeDetail:    // 条形码详情
            pathURL = BarcodeDetail;
            break;
        case HQCMD_barcodePicture:    // 条形码图片
            pathURL = BarcodePicture;
            break;
        case HQCMD_getCustomConditionField:    // 获取某模块数据条件字段列表
            pathURL = GetCustomConditionField;
            break;
        case HQCMD_getLinkageFieldList:    // 条件字段value变更触发获取联动字段列表和value
            pathURL = GetLinkageFieldList;
            break;
        case HQCMD_getSystemStableModule:    // 获取系统固定模块
            pathURL = GetSystemStableModule;
            break;
        case HQCMD_getAutoMatchModuleList:    // 获取自动匹配模块列表
            pathURL = GetAutoMatchModuleList;
            break;
        case HQCMD_getAutoMatchModuleDataList:    // 获取自动匹配模块数据列表
            pathURL = GetAutoMatchModuleDataList;
            break;
        case HQCMD_getAutoMatchModuleRuleList:    // 获取自动匹配模块规则列表
            pathURL = GetAutoMatchModuleRuleList;
            break;
        case HQCMD_getAutoMatchModuleRuleDataList:    // 获取自动匹配模块规则下的数据列表
            pathURL = GetAutoMatchModuleRuleDataList;
            break;
        case HQCMD_getTabList:    // 获取页签列表
            pathURL = GetTabList;
            break;
        case HQCMD_getTabDataList:    // 获取页签下的数据列表
            pathURL = GetTabDataList;
            break;
        case HQCMD_getReferanceReflect:   // 获取关联页签下新建获取关联映射字段值
            pathURL = GetReferanceReflect;
            break;
        case HQCMD_getWebLinkList:   // 获取web链接列表
            pathURL = GetWebLinkList;
            break;
        case HQCMD_workEnterShow:   // 获取显示模块
            pathURL = WorkEnterShow;
            break;
        case HQCMD_workEnterAllModule:   // 获取所有模块
            pathURL = WorkEnterAllModule;
            break;
        case HQCMD_subformRelation:   // 子表关联
            pathURL = SubformRelation;
            break;
        case HQCMD_resumeFile:   // 简历解析
            pathURL = ResumeFile;
            break;
        case HQCMD_checkApprovalTime:// 检查审批时间重合
            pathURL = CheckApprovalTime;
            break;
            
            
            
            /******************  企业圈   **************************/
        case HQCMD_companyCircleAdd:   // 添加一条企业圈动态
            pathURL = CompanyCircleAdd;
            break;
        case HQCMD_companyCircleUp:   // 企业圈的点赞
            pathURL = CompanyCircleUp;
            break;
        case HQCMD_companyCircleComment:   // 企业圈的评论
            pathURL = CompanyCircleComment;
            break;
        case HQCMD_companyCircleDelete:   // 删除企业圈
            pathURL = CompanyCircleDelete;
            break;
        case HQCMD_companyCircleCommentDelete:   // 删除评论
            pathURL = CompanyCircleCommentDelete;
            break;
        case HQCMD_companyCircleList:   // 列表
            pathURL = CompanyCircleList;
            break;
            
            
            /******************  企信   **************************/
            
        case HQCMD_messageGetBasicGroup:   // 公司总群和小秘书
            pathURL = MessageGetBasicGroup;
            break;
        case HQCMD_messageGetAssistList:   // 助手列表
            pathURL = MessageGetAssistList;
            break;
        case HQCMD_messageGetAssistDetail:   // 助手详情
            pathURL = MessageGetAssistDetail;
            break;
        case HQCMD_messageModifyHandle:   // 助手处理状态
            pathURL = MessageModifyHandle;
            break;
        case HQCMD_messageModifyRead:   // 助手已读状态
            pathURL = MessageModifyRead;
            break;
        case HQCMD_messageModifyTop:   // 助手置顶
            pathURL = MessageModifyTop;
            break;
        case HQCMD_messageClearHandle:   // 助手待处理数据的清空
            pathURL = MessageClearHandle;
            break;
        case HQCMD_messageModifyAssistantSetData:   // 	修改助手设置
            pathURL = MessageModifyAssistantSetData;
            break;
        case HQCMD_messageGetEmployee:   // 极光用户获取员工信息
            pathURL = MessageGetEmployee;
            break;
        case HQCMD_messageModToAllRead:   // 未读页面数据全部变为已读
            pathURL = MessageModToAllRead;
            break;
        case HQCMD_messageGetAssistSetData:   // 获取助手设置信息
            pathURL = MessageGetAssistSetData;
            break;
        case HQCMD_messageAddGroup:   // 新建群组
            pathURL = MessageAddGroup;
            break;
        case HQCMD_messageGroupList:   // 群组list
            pathURL = MessageGroupList;
            break;
            
            
            
            /** -----------新员工列表---------- */
        case HQCMD_employeeList:      // 员工列表
            pathURL = EmployeeList;
            break;
        case HQCMD_companyFramework:      // 组织架构
            pathURL = CompanyFramework;
            break;
        case HQCMD_updateEmployee:    // 修改员工
            pathURL = UpdateEmployee;
            break;
        case HQCMD_modPassWrd:    // 修改密码
            pathURL = modPassWrd;
            break;
        case HQCMD_employeeDetail:    // 员工详情
            pathURL = EmployeeDetail;
            break;
        case HQCMD_getRoleGroupList:    // 角色组列表
            pathURL = GetRoleGroupList;
            break;
        case HQCMD_findByUserName:    // 组织架构模糊查找
            pathURL = FindByUserName;
            break;
        case HQCMD_getSharePersonalFields:    // 分享人员动态参数
            pathURL = GetSharePersonalFields;
            break;
        case HQCMD_queryEmployeeInfo:    // 员工信息
            pathURL = queryEmployeeInfo;
            break;
        case HQCMD_empWhetherFabulous:    // 员工点赞
            pathURL = empWhetherFabulous;
            break;
        case HQCMD_getCompanySet:    // 获取最近登录公司密码策略
            pathURL = GetCompanySet;
            break;
        case HQCMD_changeTelephone:    // 更换手机号
            pathURL = ChangeTelephone;
            break;
        case HQCMD_getBanner:    // 获取banner
            pathURL = GetBanner;
            break;
        case HQCMD_getCardStyle:    // 获取名片样式
            pathURL = GetCardStyle;
            break;
        case HQCMD_saveCardStyle:    // 保存名片样式
            pathURL = SaveCardStyle;
            break;
            
            /******************  新企信   **************************/
        case HQCMD_getChatListInfo:
            pathURL = getChatListInfo;
            break;
            
        case HQCMD_addGroupChat:
            pathURL = addGroupChat;
            break;
            
        case HQCMD_addSingleChat:
            pathURL = addSingleChat;
            break;
            
        case HQCMD_getAllGroupsInfo:
            pathURL = getAllGroupsInfo;
            break;
            
        case HQCMD_getSingleInfo:
            pathURL = getSingleInfo;
            break;
            
        case HQCMD_getGroupInfo:
            pathURL = getGroupInfo;
            break;
            
        case HQCMD_setTopChat:
            pathURL = setTopChat;
            break;
            
        case HQCMD_setNoBother:
            pathURL = setNoBother;
            break;
            
        case HQCMD_quitChatGroup:
            pathURL = quitChatGroup;
            break;
            
        case HQCMD_releaseGroup:
            pathURL = releaseGroup;
            break;
            
        case HQCMD_pullPeople:
            pathURL = pullPeople;
            break;
            
        case HQCMD_kickPeople:
            pathURL = kickPeople;
            break;
            
        case HQCMD_hideSession:
            pathURL = hideSession;
            break;
            
        case HQCMD_imChatTransferGroup:
            pathURL = imChatTransferGroup;
            break;
            
        case HQCMD_getAssistantMessage:
            pathURL = getAssistantMessage;
            break;
            
        case HQCMD_getAssistantInfo:
            pathURL = getAssisstantInfo;
            break;
            
        case HQCMD_findModuleList:
            pathURL = findModuleList;
            break;
            
        case HQCMD_markAllRead:
            pathURL = markAllRead;
            break;
            
        case HQCMD_modifyGroupInfo:
            pathURL = modifyGroupInfo;
            break;
            
        case HQCMD_readMessage:
            pathURL = readMessage;
            break;
            
        case HQCMD_markReadOption:
            pathURL = markReadOption;
            break;
            
        case HQCMD_getAuthByBean:
            pathURL = getAuthByBean;
            break;
            
        case HQCMD_queryAidePower:
            pathURL = queryAidePower;
            break;
            
        case HQCMD_getFuncAuthWithCommunal:
            pathURL = getFuncAuthWithCommunal;
            break;
            
        case HQCMD_HideSessionWithStatus:
            pathURL = HideSessionWithStatus;
            break;
            
        case HQCMD_getAssistantMessageLimit:
            pathURL = getAssistantMessageLimit;
            break;
            
        case HQCMD_employeeFindEmployeeVague:
            pathURL = employeeFindEmployeeVague;
            break;
            
            /********************* 新文件库 *********************/
        case HQCMD_queryfileCatalog:
            pathURL = queryfileCatalog;
            break;
            
        case HQCMD_savaFileLibrary:
            pathURL = savaFileLibrary;
            break;
            
        case HQCMD_queryCompanyList:
            pathURL = queryCompanyList;
            break;
            
        case HQCMD_delFileLibrary:
            pathURL = delFileLibrary;
            break;
            
        case HQCMD_editFolder:
            pathURL = editFolder;
            break;
            
        case HQCMD_queryCompanyPartList:
            pathURL = queryCompanyPartList;
            break;
            
        case HQCMD_shiftFileLibrary:
            pathURL = shiftFileLibrary;
            break;
            
        case HQCMD_queryFolderInitDetail:
            pathURL = queryFolderInitDetail;
            break;
            
        case HQCMD_fileLibraryUpload:
            pathURL = fileLibraryUpload;
            break;
            
        case HQCMD_queryManageById:
            pathURL = queryManageById;
            break;
            
        case HQCMD_savaManageStaff:
            pathURL = savaManageStaff;
            break;
            
        case HQCMD_fileDownload:
            pathURL = fileDownload;
            break;
            
        case HQCMD_queryFileLibarayDetail:
            pathURL = queryFileLibarayDetail;
            break;
            
        case HQCMD_queryDownLoadList:
            pathURL = queryDownLoadList;
            break;
            
        case HQCMD_queryVersionList:
            pathURL = queryVersionList;
            break;
            
        case HQCMD_shareFileLibaray:
            pathURL = shareFileLibaray;
            break;
            
        case HQCMD_cancelShare:
            pathURL = cancelShare;
            break;
            
        case HQCMD_quitShare:
            pathURL = quitShare;
            break;
            
        case HQCMD_whetherFabulous:
            pathURL = whetherFabulous;
            break;
            
        case HQCMD_FileVersionUpload:
            pathURL = FileVersionUpload;
            break;
            
        case HQCMD_blurSearchFile:
            pathURL = blurSearchFile;
            break;
            
        case HQCMD_getBlurResultParentInfo:
            pathURL = getBlurResultParentInfo;
            break;
            
        case HQCMD_editRename:
            pathURL = editRename;
            break;
            
        case HQCMD_delManageStaff:
            pathURL = delManageStaff;
            break;
            
        case HQCMD_savaMember:
            pathURL = savaMember;
            break;
            
        case HQCMD_delMember:
            pathURL = delMember;
            break;
            
        case HQCMD_updateSetting:
            pathURL = updateSetting;
            break;
            
        case HQCMD_copyFileLibrary:
            pathURL = copyFileLibrary;
            break;
            
        case HQCMD_downloadCompressedPicture:
            pathURL = downloadCompressedPicture;
            break;
            
        case HQCMD_downloadHistoryFile:
            pathURL = downloadHistoryFile;
            break;
            
        case HQCMD_queryAppFileList:
            pathURL = queryAppFileList;
            break;
            
        case HQCMD_queryModuleFileList:
            pathURL = queryModuleFileList;
            break;
            
        case HQCMD_queryModulePartFileList:
            pathURL = queryModulePartFileList;
            break;
            
        case HQCMD_projectLibraryQueryProjectLibraryList:
            pathURL = projectLibraryQueryProjectLibraryList;
            break;
        case HQCMD_fileAdministrator:
            pathURL = FileAdministrator;
            break;
            
            /********************* 邮件 *********************/
        case HQCMD_mailOperationSend:
            pathURL = mailOperationSend;
            break;
            
        case HQCMD_mailOperationManualSend:
            pathURL = mailOperationManualSend;
            break;
            
        case HQCMD_queryPersonnelAccount:
            pathURL = queryPersonnelAccount;
            break;
            
        case HQCMD_queryMailList:
            pathURL = queryMailList;
            break;
            
        case HQCMD_markAllMailRead:
            pathURL = markAllMailRead;
            break;
            
        case HQCMD_markMailReadOrUnread:
            pathURL = markMailReadOrUnread;
            break;
            
        case HQCMD_mailContactQueryList:
            pathURL = mailContactQueryList;
            break;
            
        case HQCMD_mailCatalogQueryList:
            pathURL = mailCatalogQueryList;
            break;
            
        case HQCMD_mailOperationQueryList:
            pathURL = mailOperationQueryList;
            break;
            
        case HQCMD_mailOperationQueryById:
            pathURL = mailOperationQueryById;
            break;
            
        case HQCMD_mailOperationSaveToDraft:
            pathURL = mailOperationSaveToDraft;
            break;
            
        case HQCMD_mailOperationQueryUnreadNumsByBox:
            pathURL = mailOperationQueryUnreadNumsByBox;
            break;
            
        case HQCMD_moduleEmailGetModuleEmails:
            pathURL = moduleEmailGetModuleEmails;
            break;
            
        case HQCMD_moduleEmailGetModuleSubmenus:
            pathURL = moduleEmailGetModuleSubmenus;
            break;
            
        case HQCMD_customEmailList:
            pathURL = CustomEmailList;
            break;
            
        case HQCMD_mailOperationMailReply:
            pathURL = mailOperationMailReply;
            break;
            
        case HQCMD_mailOperationMailForward:
            pathURL = mailOperationMailForward;
            break;
            
        case HQCMD_moduleEmailGetEmailFromModuleDetail:
            pathURL = moduleEmailGetEmailFromModuleDetail;
            break;
            
        case HQCMD_mailOperationDeleteDraft:
            pathURL = mailOperationDeleteDraft;
            break;
            
        case HQCMD_mailOperationClearMail:
            pathURL = mailOperationClearMail;
            break;
            
        case HQCMD_mailOperationMarkNotTrash:
            pathURL = mailOperationMarkNotTrash;
            break;
            
        case HQCMD_mailOperationEditDraft:
            pathURL = mailOperationEditDraft;
            break;
            
        case HQCMD_mailOperationReceive:
            pathURL = mailOperationReceive;
            break;
            
            /** 备忘录 */
        case HQCMD_createNote:// 创建
            pathURL = CreateNote;
            break;
        case HQCMD_updateNote:// 编辑
            pathURL = UpdateNote;
            break;
        case HQCMD_getNoteDetail:// 详情
            pathURL = GetNoteDetail;
            break;
        case HQCMD_getNoteList:// 列表
            pathURL = GetNoteList;
            break;
        case HQCMD_memoDel:// 删除
            pathURL = memoDel;
            break;
        case HQCMD_getFirstFieldFromModule:// 搜索
            pathURL = getFirstFieldFromModule;
            break;
            
        case HQCMD_findRelationList:// 关联
            pathURL = findRelationList;
            break;
            
        case HQCMD_updateRelationById:// 关联
            pathURL = updateRelationById;
            break;

            
            
            /************ 项目 ************/
        case HQCMD_createProject:// 创建项目
            pathURL = CreateProject;
            break;
        case HQCMD_updateProject:// 设置项目
            pathURL = UpdateProject;
            break;
        case HQCMD_getProjectList:// 项目列表
            pathURL = GetProjectList;
            break;
        case HQCMD_getProjecDetail:// 项目详情
            pathURL = GetProjectDetail;
            break;
        case HQCMD_changeProjectStatus:// 变更项目状态
            pathURL = ChangeProjectStatus;
            break;
        case HQCMD_getProjectPeople:// 增加项目成员
            pathURL = GetProjectPeople;
            break;
        case HQCMD_addProjectPeople:// 增加项目成员
            pathURL = AddProjectPeople;
            break;
        case HQCMD_getProjectRoleList:// 获取项目角色列表
            pathURL = GetProjectRoleList;
            break;
        case HQCMD_updateProjectRole:// 修改项目角色
            pathURL = UpdateProjectRole;
            break;
        case HQCMD_deleteProjectPeople:// 删除项目成员
            pathURL = DeleteProjectPeople;
            break;
        case HQCMD_getProjectLabel:// 获取项目标签
            pathURL = GetProjectLabel;
            break;
        case HQCMD_getPersonnelLabel:// 获取个人标签
            pathURL = GetPersonnelLabel;
            break;
        case HQCMD_repositoryLabel:// 获取标签库
            pathURL = RepositoryLabel;
            break;
        case HQCMD_addProjectLabel:// 增加or删除项目标签
            pathURL = AddProjectLabel;
            break;
        case HQCMD_updateProjectStar:// 更新项目星标
            pathURL = UpdateProjectStar;
            break;
        case HQCMD_updateProjectProgress:// 更新项目进度
            pathURL = UpdateProjectProgress;
            break;


        case HQCMD_createProjectSection:// 创建项目分组
            pathURL = CreateProjectSection;
            break;
        case HQCMD_updateProjectSection:// 更新项目分组
            pathURL = UpdateProjectSection;
            break;
        case HQCMD_createProjectSectionRows:// 创建项目分组任务列
            pathURL = CreateProjectSectionRows;
            break;
        case HQCMD_updateProjectSectionRows:// 创建项目分组任务列
            pathURL = UpdateProjectSectionRows;
            break;
        case HQCMD_getProjectAllDot:// 获取项目所有节点
            pathURL = GetProjectAllDot;
            break;
        case HQCMD_getProjectColumn:// 获取项目主节点
            pathURL = GetProjectColumn;
            break;
        case HQCMD_getProjectSection:// 获取项目子节点
            pathURL = GetProjectSection;
            break;
        case HQCMD_deleteProjectColumn:// 删除项目主节点
            pathURL = DeleteProjectColumn;
            break;
        case HQCMD_deleteProjectSection:// 删除项目子节点
            pathURL = DeleteProjectSection;
            break;
        case HQCMD_sortProjectColumn:// 项目主节点排序
            pathURL = SortProjectColumn;
            break;
        case HQCMD_sortProjectSection:// 项目子节点排序
            pathURL = SortProjectSection;
            break;
        case HQCMD_addTaskQuote:// 添加引用
            pathURL = AddTaskQuote;
            break;
        case HQCMD_createTask:// 创建任务
            pathURL = CreateTask;
            break;
        case HQCMD_createChildTask:// 创建子任务
            pathURL = CreateChildTask;
            break;
        case HQCMD_getTaskDetail:// 任务详情
            pathURL = GetTaskDetail;
            break;
        case HQCMD_getChildTaskDetail:// 子任务详情
            pathURL = GetChildTaskDetail;
            break;
        case HQCMD_getChildTaskList:// 任务的子任务
            pathURL = GetChildTaskList;
            break;
        case HQCMD_getPersonnelChildTaskList:// 个人任务的子任务
            pathURL = GetPersonnelChildTaskList;
            break;
        case HQCMD_getTaskRelation:// 任务的关联
            pathURL = GetTaskRelation;
            break;
        case HQCMD_getTaskRelated:// 任务的被关联
            pathURL = GetTaskRelated;
            break;
        case HQCMD_addTaskRelation:// 添加任务关联的任务
            pathURL = AddTaskRelation;
            break;
        case HQCMD_quoteTaskRelation:// 任务关联引用
            pathURL = QuoteTaskRelation;
            break;
        case HQCMD_cancelTaskRelation:// 取消关联
            pathURL = CancelTaskRelation;
            break;
        case HQCMD_cancelPersonnelTaskRelation:// 取消个人关联
            pathURL = CancelPersonnelTaskRelation;
            break;
        case HQCMD_dragTaskSort:// 拖拽任务排序
            pathURL = DragTaskSort;
            break;
        case HQCMD_finishOrActiveTask:// 完成或激活任务
            pathURL = FinishOrActiveTask;
            break;
        case HQCMD_finishOrActiveChildTask:// 完成或激活子任务
            pathURL = FinishOrActiveChildTask;
            break;
        case HQCMD_finishOrActivePersonnelTask:// 完成或激活个人任务
            pathURL = FinishOrActivePersonnelTask;
            break;
        case HQCMD_taskHeart:// 任务或子任务点赞或取消点赞
            pathURL = TaskHeart;
            break;
        case HQCMD_personnelTaskHeart:// 个人任务或子任务点赞或取消点赞
            pathURL = PersonnelTaskHeart;
            break;
        case HQCMD_taskHeartPeople:// 任务或子任务点赞人员列表
            pathURL = TaskHeartPeople;
            break;
        case HQCMD_personnelTaskHeartPeople:// 个人任务或子任务点赞人员列表
            pathURL = PersonnelTaskHeartPeople;
            break;
        case HQCMD_taskHierarchy:// 任务层级
            pathURL = Taskhierarchy;
            break;
        case HQCMD_taskVisible:// 任务协作人可见
            pathURL = TaskVisible;
            break;
        case HQCMD_personnelTaskVisible:// 个人任务协作人可见
            pathURL = PersonnelTaskVisible;
            break;
        case HQCMD_taskCheck:// 任务校验
            pathURL = TaskCheck;
            break;
        case HQCMD_childTaskCheck:// 任务校验
            pathURL = ChildTaskCheck;
            break;
        case HQCMD_taskMoveToOther:// 任务移动
            pathURL = ProjectMoveTask;
            break;
        case HQCMD_taskCopyToOther:// 复制移动
            pathURL = TaskCopyToOther;
            break;
        case HQCMD_deleteTask:// 任务删除
            pathURL = DeleteTask;
            break;
        case HQCMD_deleteChildTask:// 子任务删除
            pathURL = DeleteChildTask;
            break;
        case HQCMD_quoteTaskList:// 任务引用列表
            pathURL = QuoteTaskList;
            break;
        case HQCMD_queryProjectTaskCondition:// 任务筛选自定义条件
            pathURL = QueryProjectTaskCondition;
            break;
        case HQCMD_projectTaskFilter:// 任务筛选
            pathURL = ProjectTaskFilter;
            break;
        case HQCMD_personnelTaskFilter:// 个人任务筛选
            pathURL = PersonnelTaskFilter;
            break;
        case HQCMD_personnelTaskDetail:// 个人任务详情
            pathURL = PersonnelTaskDetail;
            break;
        case HQCMD_personnelSubTaskDetail:// 个人任务子任务详情
            pathURL = PersonnelSubTaskDetail;
            break;
        case HQCMD_taskInProject:// 项目中的任务
            pathURL = TaskInProject;
            break;
        case HQCMD_getProjectTaskCooperationPeopleList:// 项目任务协作人列表
            pathURL = GetProjectTaskCooperationPeopleList;
            break;
        case HQCMD_getProjectTaskRole:// 项目任务角色
            pathURL = GetProjectTaskCooperationPeopleList;
            break;
        case HQCMD_getPersonnelTaskCooperationPeopleList:// 个人任务协作人列表
            pathURL = GetPersonnelTaskCooperationPeopleList;
            break;
        case HQCMD_getPersonnelTaskRole:// 个人任务角色
            pathURL = GetPersonnelTaskRole;
            break;
        case HQCMD_addProjectTaskCooperationPeople:// 添加项目任务协作人
            pathURL = AddProjectTaskCooperationPeople;
            break;
        case HQCMD_addPersonnelTaskCooperationPeople:// 添加个人任务协作人
            pathURL = AddPersonnelTaskCooperationPeople;
            break;
        case HQCMD_deleteProjectTaskCooperationPeople:// 删除项目任务协作人
            pathURL = DeleteProjectTaskCooperationPeople;
            break;
        case HQCMD_deletePersonnelTaskCooperationPeople:// 删除个人任务协作人
            pathURL = DeletePersonnelTaskCooperationPeople;
            break;
        case HQCMD_createPersonnelSubTask:// 新建个人任务子任务
            pathURL = CreatePersonnelSubTask;
            break;
        case HQCMD_personnelTaskQuotePersonnelTask:// 个人任务引用个人任务
            pathURL = PersonnelTaskQuotePersonnelTask;
            break;
        case HQCMD_personnelTaskRelationList:// 个人任务关联列表
            pathURL = PersonnelTaskRelationList;
            break;
        case HQCMD_personnelTaskByRelated:// 个人任务被关联列表
            pathURL = PersonnelTaskByRelated;
            break;
        case HQCMD_personnelTaskEdit:// 个人任务编辑
            pathURL = PersonnelTaskEdit;
            break;
        case HQCMD_personnelSubTaskEdit:// 个人任务子任务编辑
            pathURL = PersonnelSubTaskEdit;
            break;
        case HQCMD_projectTaskEdit:// 项目任务任务编辑
            pathURL = ProjectTaskEdit;
            break;
        case HQCMD_personnelTaskDelete:// 个人任务删除
            pathURL = PersonnelTaskDelete;
            break;
        case HQCMD_personnelSubTaskDelete:// 个人任务子任务删除
            pathURL = PersonnelSubTaskDelete;
            break;
        case HQCMD_getProjectTaskRemain:// 获取项目任务提醒
            pathURL = GetProjectTaskRemain;
            break;
        case HQCMD_saveProjectTaskRemain:// 保存项目任务提醒
            pathURL = SaveProjectTaskRemain;
            break;
        case HQCMD_updateProjectTaskRemain:// 更新项目任务提醒
            pathURL = UpdateProjectTaskRemain;
            break;
        case HQCMD_getAllProject:// 获取所有项目
            pathURL = GetAllProject;
            break;
        case HQCMD_getPersonnelTaskList:// 获取个人任务列表
            pathURL = GetPersonnelTaskList;
            break;
        case HQCMD_getProjectWorkflow:// 获取工作流
            pathURL = GetProjectWorkflow;
            break;
        case HQCMD_projectWorkflowPreview:// 工作流预览
            pathURL = ProjectWorkflowPreview;
            break;
        case HQCMD_getPersonnelTaskFilterCondition:// 获取个人任务筛选条件
            pathURL = GetPersonnelTaskFilterCondition;
            break;
        case HQCMD_getMyselfCustomModule:// 获取自定义模块
            pathURL = GetMyselfCustomModule;
            break;
        case HQCMD_getWorkBenchList:// 获取工作台列表
            pathURL = GetWorkBenchList;
            break;
        case HQCMD_enterpriseWorkBenchFlow:// 获取企业工作流程
            pathURL = EnterpriseWorkBenchFlow;
            break;
        case HQCMD_moveTimeWorkBench:// 移动时间工作台数据
            pathURL = MoveTimeWorkBench;
            break;
        case HQCMD_moveEnterpriseWorkBench:// 移动企业工作台数据
            pathURL = MoveEnterpriseWorkBench;
            break;
        case HQCMD_projectTemplateList:// 项目模板列表
            pathURL = ProjectTemplateList;
            break;
        case HQCMD_projectTemplatePreview:// 项目模板预览
            pathURL = ProjectTemplatePreview;
            break;
        case HQCMD_getProjectRoleAndAuth:// 项目角色及权限
            pathURL = GetProjectRoleAndAuth;
            break;
        case HQCMD_getProjectTaskRoleAuth:// 项目任务角色权限
            pathURL = GetProjectTaskRoleAuth;
            break;
        case HQCMD_getProjectTaskSeeStatus:// 项目任务查看状态
            pathURL = GetProjectTaskSeeStatus;
            break;
        case HQCMD_getPersonnelTaskSeeStatus:// 个人任务查看状态
            pathURL = GetPersonnelTaskSeeStatus;
            break;
        case HQCMD_saveProjectTaskRepeat:// 保存项目任务重复
            pathURL = SaveProjectTaskRepeat;
            break;
        case HQCMD_updateProjectTaskRepeat:// 更新项目任务重复
            pathURL = UpdateProjectTaskRepeat;
            break;
        case HQCMD_getProjectTaskRepeat:// 获取项目任务重复
            pathURL = GetProjectTaskRepeat;
            break;
        case HQCMD_getPersonnelTaskRemind:// 获取个人任务提醒
            pathURL = GetPersonnelTaskRemind;
            break;
        case HQCMD_savePersonnelTaskRemind:// 获取个人任务提醒
            pathURL = SavePersonnelTaskRemind;
            break;
        case HQCMD_updatePersonnelTaskRemind:// 获取个人任务提醒
            pathURL = UpdatePersonnelTaskRemind;
            break;
        case HQCMD_getPersonnelTaskRepeat:// 获取个人任务重复
            pathURL = GetPersonnelTaskRepeat;
            break;
        case HQCMD_savePersonnelTaskRepeat:// 保存个人任务重复
            pathURL = SavePersonnelTaskRepeat;
            break;
        case HQCMD_updatePersonnelTaskRepeat:// 更新个人任务重复
            pathURL = UpdatePersonnelTaskRepeat;
            break;
        case HQCMD_updateProjectTask:// 编辑项目任务
            pathURL = UpdateProjectTask;
            break;
        case HQCMD_updateProjectChildTask:// 编辑项目子任务
            pathURL = UpdateProjectChildTask;
            break;
        case HQCMD_getProjectFinishAndActiveAuth:// 项目任务完成及激活权限
            pathURL = GetProjectFinishAndActiveAuth;
            break;
        case HQCMD_deleteProjectPeopleTransferTask:// 移出成员是否需要指定工作交接人
            pathURL = DeleteProjectPeopleTransferTask;
            break;
        case HQCMD_boardCancelQuote:// 层级视图取消关联
            pathURL = BoardCancelQuote;
            break;
            
            
            
            
            /**          项目分享            */
        case HQCMD_projectShareControllerSave:// 新增分享
            pathURL = projectShareControllerSave;
            break;
            
        case HQCMD_projectShareControllerEdit:// 修改分享
            pathURL = projectShareControllerEdit;
            break;
        
        case HQCMD_projectShareControllerDelete:// 删除分享
            pathURL = projectShareControllerDelete;
            break;
            
        case HQCMD_projectShareControllerEditRelevance:// 关联变更
            pathURL = projectShareControllerEditRelevance;
            break;
        
        case HQCMD_projectShareControllerShareStick:// 分享置顶
            pathURL = projectShareControllerShareStick;
            break;
        
        case HQCMD_projectShareControllerSharePraise:// 分享点赞
            pathURL = projectShareControllerSharePraise;
            break;
        
        case HQCMD_projectShareControllerQueryById:// 分享详情
            pathURL = projectShareControllerQueryById;
            break;
        
        case HQCMD_projectShareControllerQueryList:// 分享列表
            pathURL = projectShareControllerQueryList;
            break;
            
        case HQCMD_projectShareControllerQueryRelationList:// 获取关联内容
            pathURL = projectShareControllerQueryRelationList;
            break;
            
        case HQCMD_projectShareControllerSaveRelation:// 获取关联内容
            pathURL = projectShareControllerSaveRelation;
            break;
            
        case HQCMD_projectShareControllerCancleRelation:// 取消关联内容
            pathURL = projectShareControllerCancleRelation;
            break;
            
            /**          项目文库            */
        case HQCMD_projectLibraryQueryLibraryList:// 文库列表
            pathURL = projectLibraryQueryLibraryList;
            break;
        
        case HQCMD_projectLibraryQueryFileLibraryList:
            pathURL = projectLibraryQueryFileLibraryList;
            break;
            
        case HQCMD_projectLibraryQueryTaskLibraryList:
            pathURL = projectLibraryQueryTaskLibraryList;
            break;
        case HQCMD_projectLibraryRootSearch:
            pathURL = projectLibraryRootSearch;
            break;
        
        case HQCMD_projectLibrarySavaLibrary:
            pathURL = projectLibrarySavaLibrary;
            break;
        
        case HQCMD_projectLibraryEditLibrary:
            pathURL = projectLibraryEditLibrary;
            break;
            
        case HQCMD_projectLibraryDelLibrary:
            pathURL = projectLibraryDelLibrary;
            break;
        
        case HQCMD_projectLibrarySharLibrary:
            pathURL = projectLibrarySharLibrary;
            break;
            
        case HQCMD_commonFileProjectUpload:
            pathURL = commonFileProjectUpload;
            break;
        
        case HQCMD_commonFileProjectDownload:
            pathURL = commonFileProjectDownload;
            break;
        case HQCMD_FileProjectDownloadRecord:
            pathURL = FileProjectDownloadRecord;
            break;
        case HQCMD_workBenchChangeAuth:
            pathURL = WorkBenchChangeAuth;
            break;
        case HQCMD_workBenchChangePeopleList:
            pathURL = WorkBenchChangePeopleList;
            break;
#pragma mark  ----------------  新版项目接口  ----------------
        case HQCMD_projectAllNode:
            pathURL = ProjectAllNode;
            break;
        case HQCMD_projectTempAllNode:
            pathURL = ProjectTempAllNode;
            break;
        case HQCMD_projectAddNode:
            pathURL = ProjectAddNode;
            break;
        case HQCMD_projectUpdateNode:
            pathURL = ProjectUpdateNode;
            break;
        case HQCMD_projectDeleteNode:
            pathURL = ProjectDeleteNode;
            break;
        case HQCMD_projectAddTask:
            pathURL = ProjectAddTask;
            break;
        case HQCMD_projectUpdateTask:
            pathURL = ProjectUpdateTask;
            break;
        case HQCMD_projectAddSubTask:
            pathURL = ProjectAddSubTask;
            break;
        case HQCMD_projectUpdateSubTask:
            pathURL = ProjectUpdateSubTask;
            break;
        case HQCMD_projectCopyTask:
            pathURL = ProjectCopyTask;
            break;
        case HQCMD_projectMoveTask:
            pathURL = ProjectMoveTask;
            break;
        case HQCMD_projectGetSubTask:
            pathURL = ProjectGetSubTask;
            break;
        case HQCMD_taskHybirdDynamic:
            pathURL = TaskHybirdDynamic;
            break;
        case HQCMD_newPersonnelTaskList:
            pathURL = NewPersonnelTaskList;
            break;
        case HQCMD_newProjectTaskList:
            pathURL = NewProjectTaskList;
            break;
            
#pragma mark  ----------------  考勤  ----------------
        case HQCMD_attendanceWaySave:
            pathURL = attendanceWaySave;
            break;
        
        case HQCMD_attendanceWayFindList:
            pathURL = attendanceWayFindList;
            break;
            
        case HQCMD_attendanceWayUpdate:
            pathURL = attendanceWayUpdate;
            break;
        
        case HQCMD_attendanceWayDel:
            pathURL = attendanceWayDel;
            break;
            
        case HQCMD_attendanceWayFindDetail:
            pathURL = attendanceWayFindDetail;
            break;
            
        case HQCMD_attendanceClassSave:
            pathURL = attendanceClassSave;
            break;
        
        case HQCMD_attendanceClassFindList:
            pathURL = attendanceClassFindList;
            break;
        
        case HQCMD_attendanceClassDel:
            pathURL = attendanceClassDel;
            break;
            
        case HQCMD_attendanceClassUpdate:
            pathURL = attendanceClassUpdate;
            break;
            
        case HQCMD_attendanceClassFindDetail:
            pathURL = attendanceClassFindDetail;
            break;
            
        case HQCMD_attendanceScheduleSave:
            pathURL = attendanceScheduleSave;
            break;
            
        case HQCMD_attendanceScheduleFindList:
            pathURL = attendanceScheduleFindList;
            break;
        
        case HQCMD_attendanceScheduleDel:
            pathURL = attendanceScheduleDel;
            break;
        
        case HQCMD_attendanceScheduleUpdate:
            pathURL = attendanceScheduleUpdate;
            break;
            
        case HQCMD_attendanceScheduleFindDetail:
            pathURL = attendanceScheduleFindDetail;
            break;
            
        case HQCMD_attendanceSettingSaveAdmin:
            pathURL = attendanceSettingSaveAdmin;
            break;
            
        case HQCMD_attendanceSettingUpdate:
            pathURL = attendanceSettingUpdate;
            break;
            
        case HQCMD_attendanceSettingSaveRemind:
            pathURL = attendanceSettingSaveRemind;
            break;
            
        case HQCMD_attendanceSettingSaveCount:
            pathURL = attendanceSettingSaveCount;
            break;
            
        case HQCMD_attendanceSettingSaveLate:
            pathURL = attendanceSettingSaveLate;
            break;
            
        case HQCMD_attendanceSettingSaveHommization:
            pathURL = attendanceSettingSaveHommization;
            break;
            
        case HQCMD_attendanceSettingSaveAbsenteeism:
            pathURL = attendanceSettingSaveAbsenteeism;
            break;
            
        case HQCMD_attendanceLateWork:
            pathURL = attendanceLateWork;
            break;
            
        case HQCMD_attendanceSettingFindDetail:
            pathURL = attendanceSettingFindDetail;
            break;
            
        case HQCMD_attendanceManagementFindAppDetail:
            pathURL = attendanceManagementFindAppDetail;
            break;
            
        case HQCMD_attendanceScheduleFindScheduleList:
            pathURL = attendanceScheduleFindScheduleList;
            break;
            
        case HQCMD_attendanceCycleFindDetail:
            pathURL = attendanceCycleFindDetail;
            break;
            
        case HQCMD_getTodayAttendanceInfo:
            pathURL = GetTodayAttendanceInfo;
            break;

        case HQCMD_getTodayAttendanceRecord:
            pathURL = GetTodayAttendanceRecord;
            break;
            
        case HQCMD_punchAttendance:
            pathURL = PunchAttendance;
            break;
            
        case HQCMD_attendanceDayStatistics:
            pathURL = AttendanceDayStatistics;
            break;
        case HQCMD_attendanceMonthStatistics:
            pathURL = AttendanceMonthStatistics;
            break;
        case HQCMD_myMonthStatistics:
            pathURL = MyMonthStatistics;
            break;
        case HQCMD_attendanceEmployeeMonthStatistics:
            pathURL = AttendanceEmployeeMonthStatistics;
            break;
        case HQCMD_attendanceEarlyRank:
            pathURL = AttendanceEarlyRank;
            break;
        case HQCMD_attendanceHardworkingRank:
            pathURL = AttendanceHardworkingRank;
            break;
        case HQCMD_attendanceLateRank:
            pathURL = AttendanceLateRank;
            break;
        case HQCMD_attendanceGroupList:
            pathURL = AttendanceGroupList;
            break;
        case HQCMD_attendancePunchPeoples:
            pathURL = AttendancePunchPeoples;
            break;
        case HQCMD_attendancePunchStatusPeoples:
            pathURL = AttendancePunchStatusPeoples;
            break;
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
            break;
#pragma mark --------------  知识库 -----------------
        case HQCMD_saveKnowledge:
            pathURL = SaveKnowledge;
            break;
        case HQCMD_deleteKnowledge:
            pathURL = DeleteKnowledge;
            break;
        case HQCMD_updateKnowledge:
            pathURL = UpdateKnowledge;
            break;
        case HQCMD_getKnowledgeDetail:
            pathURL = GetKnowledgeDetail;
            break;
        case HQCMD_getKnowledgeList:
            pathURL = GetKnowledgeList;
            break;
        case HQCMD_getKnowledgeCategoryAndLabel:
            pathURL = GetKnowledgeCategoryAndLabel;
            break;
        case HQCMD_knowledgeLabel:
            pathURL = KnowledgeLabel;
            break;
        case HQCMD_sureLearnKnowledge:
            pathURL = SureLearnKnowledge;
            break;
        case HQCMD_learnAndReadKnowledgePeople:
            pathURL = LearnAndReadKnowledgePeople;
            break;
        case HQCMD_goodKnowledge:
            pathURL = GoodKnowledge;
            break;
        case HQCMD_goodKnowledgePeople:
            pathURL = GoodKnowledgePeople;
            break;
        case HQCMD_collectKnowledge:
            pathURL = CollectKnowledge;
            break;
        case HQCMD_collectKnowledgePeople:
            pathURL = CollectKnowledgePeople;
            break;
        case HQCMD_knowledgeVersion:
            pathURL = KnowledgeVersion;
            break;
        case HQCMD_getKnowledgeCategory:
            pathURL = GetKnowledgeCategory;
            break;
        case HQCMD_knowledgeMove:
            pathURL = KnowledgeMove;
            break;
        case HQCMD_anwserSave:
            pathURL = AnwserSave;
            break;
        case HQCMD_anwserUpdate:
            pathURL = AnwserUpdate;
            break;
        case HQCMD_anwserDelete:
            pathURL = AnwserDelete;
            break;
        case HQCMD_anwserDetail:
            pathURL = AnwserDetail;
            break;
        case HQCMD_anwserList:
            pathURL = AnwserList;
            break;
        case HQCMD_knowledgeTop:
            pathURL = KnowledgeTop;
            break;
        case HQCMD_anwserTop:
            pathURL = AnwserTop;
            break;
        case HQCMD_knowledgeReferances:
            pathURL = KnowledgeReferances;
            break;
        case HQCMD_inviteToAnswer:
            pathURL = InviteToAnswer;
            break;
        case HQCMD_changeItemToCard:
            pathURL = ChangeItemToCard;
            break;
            
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@%@%@",[AppDelegate shareAppDelegate].baseUrl,[AppDelegate shareAppDelegate].serverAddress, pathURL];
}

/** 初始化上传
 *
 *  @param bean
 */
- (void)imageFileWithImages:(NSArray *)imgDatas withVioces:(NSArray*)vedioDatas{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [self urlFromCmd:HQCMD_ImageFile];
    
    
    HQRequestItem *requestItem = [RM uploadPicToURL:url requestParam:params imgDatas:imgDatas audioDatas:vedioDatas videoDatas:nil cmdId:HQCMD_ImageFile delegate:self startBlock:^(HQCMD cmd, NSInteger sid) {
        
    }];
    
    [self.tasks addObject:requestItem];
}

/** 聊天文件
 *
 *  @param bean
 */
- (void)chatFileWithImages:(NSArray *)imgDatas withVioces:(NSArray*)vedioDatas bean:(NSString *)bean{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (bean) {
        [params setObject:bean forKey:@"bean"];
    }
    
    NSString *url = [self urlFromCmd:HQCMD_ChatFile];
    
    
    HQRequestItem *requestItem = [RM uploadPicToURL:url requestParam:params imgDatas:imgDatas audioDatas:vedioDatas videoDatas:nil cmdId:HQCMD_ChatFile delegate:self startBlock:^(HQCMD cmd, NSInteger sid) {
        
    }];
    
    [self.tasks addObject:requestItem];
}

/** 项目文库上传
 *
 *  @param bean
 */
- (void)projectFileWithImages:(NSArray *)imgDatas bean:(NSString *)bean fileId:(NSNumber *)fileId projectId:(NSNumber *)projectId  {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (bean) {
        [params setObject:bean forKey:@"bean"];
    }
    if (fileId) {
        [params setObject:fileId forKey:@"id"];
    }
    if (projectId) {
        [params setObject:projectId forKey:@"project_id"];
    }
    
    NSString *url = [self urlFromCmd:HQCMD_commonFileProjectUpload];
    
    
    HQRequestItem *requestItem = [RM uploadPicToURL:url requestParam:params imgDatas:imgDatas audioDatas:nil videoDatas:nil cmdId:HQCMD_commonFileProjectUpload delegate:self startBlock:^(HQCMD cmd, NSInteger sid) {
        
    }];
    
    [self.tasks addObject:requestItem];
}


/** 上传文件   */
- (void)uploadFileWithImages:(NSArray *)imgDatas withAudios:(NSArray*)audioDatas bean:(NSString *)bean{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (bean) {
        [params setObject:bean forKey:@"bean"];
    }
    
    NSString *url = [self urlFromCmd:HQCMD_uploadFile];
    
    
    HQRequestItem *requestItem = [RM uploadPicToURL:url requestParam:params imgDatas:imgDatas audioDatas:audioDatas videoDatas:nil cmdId:HQCMD_uploadFile delegate:self startBlock:^(HQCMD cmd, NSInteger sid) {
        
    }];
    
    [self.tasks addObject:requestItem];
    
}

/** 上传文件   */
- (void)uploadFileWithImages:(NSArray *)imgDatas withAudios:(NSArray*)audioDatas withVideo:(NSArray*)videoDatas bean:(NSString *)bean{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (bean) {
        [params setObject:bean forKey:@"bean"];
    }
    
    NSString *url = [self urlFromCmd:HQCMD_ChatFile];
    
    
    HQRequestItem *requestItem = [RM uploadPicToURL:url requestParam:params imgDatas:imgDatas audioDatas:audioDatas videoDatas:videoDatas cmdId:HQCMD_ChatFile delegate:self startBlock:^(HQCMD cmd, NSInteger sid) {
        
    }];
    
    [self.tasks addObject:requestItem];
    
}


/** 多线程多文件上传
 *
 *  @param bean
 *  @param cmdId 请写大于100000以上
 */
- (void)uploadMutilFileWithImages:(NSArray *)imgDatas cmdId:(NSInteger)cmdId bean:(NSString *)bean{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (bean) {
        [params setObject:bean forKey:@"bean"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",[AppDelegate shareAppDelegate].baseUrl,[AppDelegate shareAppDelegate].serverAddress, ChatFile];
    
    
    HQRequestItem *requestItem = [RM uploadPicToURL:url requestParam:params imgDatas:imgDatas audioDatas:@[] videoDatas:@[] cmdId:(HQCMD)cmdId delegate:self startBlock:^(HQCMD cmd, NSInteger sid) {
        
    }];
    
    [self.tasks addObject:requestItem];
}


//通用业务错误处理
- (BOOL)requestManager:(HQRequestManager*)requestManager commonData:(id)data sequenceID:(NSInteger)sid cmdId:(HQCMD)cmdId{

    
    if (![data isKindOfClass:[NSDictionary class]]) {
        
        return YES;
    }
    
    if (data) {
        
        NSDictionary *dic = data[kMyResponse];
        if (!dic) {
            dic = data;
        }
        NSString *code = [dic[kCode] description];
        
        if ([code isEqualToString:@"common.sucess"] || [code isEqualToString:@"1001"]) {// 成功code
            return YES;
        }
    }
    //通用错误处理
    [self requestManager:requestManager sequenceID:sid didErrorWithData:data cmdId:cmdId];
    
    return NO;
    
}


//移除sid对应的网络请求任务
- (void)removeTaskBySid:(NSInteger)sid{
    
    HQRequestItem *removeItem = nil;
    for (HQRequestItem *item in _tasks) {
        if (item.sid == sid) {
            removeItem = item;
            removeItem.delegate = nil;
            removeItem.willRequestBlk = nil;
            break;
        }
    }
    if (removeItem) {
        [_tasks removeObject:removeItem];
    }
}

#pragma mark - Response （ 失败代码回调 ）
- (void)requestManager:(HQRequestManager *)manager sequenceID:(NSInteger)sid didErrorWithData:(id)data cmdId:(HQCMD)cmdId{
    //区分网络错误 和 业务错误
    HQRESCode code = HQRESCode_UNKNOWN;
    NSString *errorDesc = nil;
    if (data) {
        if ([data isKindOfClass:[NSError class]]) {
            NSError *error = (NSError *)data;
            //网络错误
            code = HQRESCode_NETERROR;
            NSString *str = error.userInfo[@"NSLocalizedDescription"];
            NSArray *arr = [str componentsSeparatedByString:@"。"];
            errorDesc = arr[0];
        }else{
            //业务错误
            NSDictionary *dic = data[kMyResponse];
            if (!dic) {
                dic = data;
            }
            code = HQRESCode_NETERROR;
            errorDesc = dic[kDescribe];
            if (!errorDesc || [errorDesc isKindOfClass:[NSNull class]]) {
                errorDesc = [NSString stringWithFormat:@"数据异常"];
            }
        }
        HQLog(@"error des: %@",errorDesc);
        if ([errorDesc isEqualToString:@"请求过于频繁"]) {
            errorDesc = nil;
        }
    }
    HQResponseEntity *resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data errorCode:code errorDes:errorDesc];
    [self failedCallbackWithResponse:resp];
}


#pragma mark - Response （ 成功代码回调 ）
- (void)requestManager:(HQRequestManager *)manager sequenceID:(NSInteger)sid didCompleteWithData:(id)data cmdId:(HQCMD)cmdId{
    
    HQResponseEntity *resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
    [self succeedCallbackWithResponse:resp];
    
}

#pragma mark - (进度回调)
- (void)requestManager:(HQRequestManager *)manager sequenceID:(NSInteger)sid didCompleteWithProgress:(NSProgress *)progress cmdId:(HQCMD)cmdId{
    
    HQResponseEntity *resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid progress:progress];
    [self progressCallbackWithResponse:resp];
}

#pragma mark ------------回调（子类没有实现，默认调用父类的回调）-----------
- (void)progressCallbackWithResponse:(HQResponseEntity*)resp{
    
    if (IsDelegate(self.delegate, progressHandle:response:))
    {
        [self.delegate progressHandle:self response:resp];
    }
}

//成功代理回调 (默认为父类实现，子类可扩展)
- (void)succeedCallbackWithResponse:(HQResponseEntity*)resp
{
    [self removeTaskBySid:resp.sid];
    
    if (IsDelegate(self.delegate, finishedHandle:response:))
    {
        [self.delegate finishedHandle:self response:resp];
    }
}

//失败代理回调 (默认为父类实现，子类可扩展)
- (void)failedCallbackWithResponse:(HQResponseEntity*)resp
{
    [self removeTaskBySid:resp.sid];
    
    if (IsDelegate(self.delegate, failedHandle:response:))
    {
        [self.delegate failedHandle:self response:resp];
    }
}





@end
