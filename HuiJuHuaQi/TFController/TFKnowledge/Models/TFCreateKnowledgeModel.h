//
//  TFCreateKnowledgeModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFCustomerRowsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFCreateKnowledgeModel : JSONModel
/** 知识类型 0：新增 1：提问  2:回答 */
@property (nonatomic, assign) NSInteger type;
/** 标题 */
@property (nonatomic, copy) TFCustomerRowsModel *title;
/** 类型 */
@property (nonatomic, copy) TFCustomerRowsModel *content;
/** 自定义s */
@property (nonatomic, strong) NSMutableArray *customs;
/** 任务s */
@property (nonatomic, strong) NSMutableArray *tasks;
/** 审批s */
@property (nonatomic, strong) NSMutableArray *approvals;
/** 备忘录s */
@property (nonatomic, strong) NSMutableArray *notes;
/** 邮件s */
@property (nonatomic, strong) NSMutableArray *emails;

/** 分类 */
@property (nonatomic, strong) TFCustomerRowsModel *category;
/** 标签s */
@property (nonatomic, strong) TFCustomerRowsModel *labels;
/** 附件s */
@property (nonatomic, strong) TFCustomerRowsModel *files;


@end

NS_ASSUME_NONNULL_END
