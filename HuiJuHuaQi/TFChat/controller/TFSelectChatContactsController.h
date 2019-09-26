//
//  TFSelectChatContactsController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFSelectChatContactsController : HQBaseViewController

/** type 0:子控制器 1：独立控制器*/
@property (nonatomic, assign) NSInteger type;

/** fourSelects */
@property (nonatomic, strong) NSMutableArray *fourSelects;

/** actionParameter */
@property (nonatomic, copy) ActionParameter actionParameter;

/** actionParameter */
@property (nonatomic, copy) ActionParameter refresh;

/** isSingleSelect 是否单选 NO:默认为多选 YES:单选  */
@property (nonatomic, assign) BOOL isSingleSelect;

/** tableViewHeight */
@property (nonatomic, assign) CGFloat tableViewHeight;

/** 不可选中人员 */
@property (nonatomic, strong) NSArray *noSelectPoeples;



/** 其他模块发送文件到聊天 */
@property (nonatomic, strong) TFFileModel *fileModel;
/** 转发 */
@property (nonatomic, assign) BOOL isTrans;
@property (nonatomic, assign) BOOL isSendFromFileLib;
/** 直接发送 */
@property (nonatomic, assign) BOOL isSend;

@end
