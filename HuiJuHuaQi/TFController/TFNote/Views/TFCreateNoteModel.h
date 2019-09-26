//
//  TFCreateNoteModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFCreateNoteModel : JSONModel

/** 备忘录数组 */
@property (nonatomic, strong) NSArray *noteItems;

/** 第一张图URL */
@property (nonatomic, copy) NSString *firstUrl;

/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 提醒时间 */
@property (nonatomic, copy) NSString *remindTime;

/** 共享人 */
@property (nonatomic, strong) NSMutableArray *sharers;
/** 共享人Ids */
@property (nonatomic, copy) NSString *sharerIds;

/** 是否提醒自己 0：不提醒 1：提醒 */
@property (nonatomic, strong) NSNumber *remindStatus;

/** 关联 */
@property (nonatomic, strong) NSMutableArray *relations;


/** 地址 */
@property (nonatomic, strong) NSMutableArray *locations;

/** 是否是已删除的 */
@property (nonatomic, copy) NSString *del_status;

/** 创建人 */
@property (nonatomic, strong) NSNumber *create_by;

@property (nonatomic, strong) NSNumber *noteId;

/** 提交给后台的内容 */
@property (nonatomic, strong) NSMutableDictionary *dict;

/**  评论数量 */
@property (nonatomic, strong) NSNumber *commentsCount;

/** isEdit */
@property (nonatomic, assign) BOOL isEdit;


@end
