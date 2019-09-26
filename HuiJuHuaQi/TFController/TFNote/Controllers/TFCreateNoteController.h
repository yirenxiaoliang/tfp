//
//  TFCreateNoteController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFCreateNoteController : HQBaseViewController

/** type 0:新建 1:详情 2:编辑 */
@property (nonatomic, assign) NSInteger type;

/** noteId */
@property (nonatomic, strong) NSNumber *noteId;

/** refreshAction */
@property (nonatomic, copy) ActionHandler refreshAction;

/** dataAction */
@property (nonatomic, copy) ActionParameter dataAction;

@end
