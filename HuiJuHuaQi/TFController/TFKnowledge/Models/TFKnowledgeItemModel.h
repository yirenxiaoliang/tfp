//
//  TFKnowledgeItemModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFKnowledgeItemModel 

@end

@interface TFKnowledgeItemModel : JSONModel

/** "create_time": 1545210780177,
 "praiseCount": 0,
 "label_ids": [
 {
 "name": "大头鱼",
 "id": 2
 },
 {
 "name": "金枪鱼",
 "id": 1
 }
 ],
 "modify_time": "",
 "del_status": "0",
 "modify_by": "",
 "type_status": "0",
 "title": "世界在深圳",
 "readCount": 0,
 "content": "你在哪里测试的",
 "relation_id": 1,
 "create_by": "1",
 "collectionCount": 0,
 "classification_id": "海鲜",
 "id": 2,
 "bean": "bean1539743117977" */

/** 分类名称 */
@property (nonatomic, copy) NSString<Optional> *classification_name;
/** 分类id */
@property (nonatomic, copy) NSString<Optional> *classification_id;
/** 标题 */
@property (nonatomic, copy) NSString<Optional> *title;
/** 内容or描述 */
@property (nonatomic, copy) NSString<Optional> *content;
/** 内容or描述 */
@property (nonatomic, copy) NSString<Ignore> *contentSimple;
/** 0:知识 1:提问 2:回答 */
@property (nonatomic, copy) NSString<Optional> *type_status;
/** 置顶 */
@property (nonatomic, strong) NSNumber<Optional> *top;
/** ID */
@property (nonatomic, strong) NSNumber<Optional> *id;
/** 点赞数 */
@property (nonatomic, strong) NSNumber<Optional> *praisecount;
/** 是否点赞 */
@property (nonatomic, strong) NSNumber<Optional> *alreadyprasing;
/** 学习数 */
@property (nonatomic, strong) NSNumber<Optional> *studycount;
/** 是否学习 */
@property (nonatomic, strong) NSNumber<Optional> *alreadystudying;
/** 收藏数 */
@property (nonatomic, strong) NSNumber<Optional> *collectioncount;
/** 是否收藏 */
@property (nonatomic, strong) NSNumber<Optional> *alreadycollecting;
/** 阅读数 */
@property (nonatomic, strong) NSNumber<Optional> *readcount;
/** 创建时间 */
@property (nonatomic, strong) NSNumber<Optional> *create_time;
/** 创建人 */
@property (nonatomic, strong) TFEmployModel<Optional> *create_by;
/** 标签 */
@property (nonatomic, strong) NSArray <Optional,TFCategoryModel>*label_ids;
/** 附件 */
@property (nonatomic, strong) NSArray <Optional,TFFileModel>*repository_lib_attachment;
/** 回答的附件 */
@property (nonatomic, strong) NSArray <Optional,TFFileModel>*repository_answer_attachment;
/** 富文本中的图片 */
@property (nonatomic, strong) NSArray <Ignore,TFFileModel>*files;
/** 分类管理员 */
@property (nonatomic, strong) NSArray <Optional,TFEmployModel>*allot_manager;

@property (nonatomic, copy) NSString <Optional>*video;

@end

NS_ASSUME_NONNULL_END
