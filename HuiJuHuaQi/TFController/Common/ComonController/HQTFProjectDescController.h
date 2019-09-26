//
//  HQTFProjectDescController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"


@interface HQTFProjectDescController : HQBaseViewController

/** 控制器类型  0: 项目编辑名称  1：项目编辑描述  2：新建分类 3:任务名称 4:任务描述 5:创建群 6:笔记本重命名 7:文件库添加描述 // 建议不用type 用naviTitle、sectionTitle、placehoder初始化UI内容  */
@property (nonatomic, assign) NSInteger type;



/** 值 */
@property (nonatomic, copy) Action descAction;
/** 初始值 */
@property (nonatomic, copy) NSString *descString;
/** 导航栏title */
@property (nonatomic, copy) NSString *naviTitle;
/** section标题 */
@property (nonatomic, copy) NSString *sectionTitle;
/** placehoder */
@property (nonatomic, copy) NSString *placehoder;

/** 用于转审 */
@property (nonatomic, assign) BOOL isApproval;
/** 审批返回值 */
@property (nonatomic, copy) ActionParameter parameterAction;

/** 字数限制 */
@property (nonatomic, assign) NSInteger wordNum;

/** 必要性 */
@property (nonatomic, assign) BOOL isNoNecessary;


@end
