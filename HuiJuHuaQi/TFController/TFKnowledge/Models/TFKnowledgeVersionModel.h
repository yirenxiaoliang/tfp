//
//  TFKnowledgeVersionModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFKnowledgeVersionModel

@end

@interface TFKnowledgeVersionModel : JSONModel

/**
 {
 "name" : "当前版本",
 "id" : 1,
 "content" : "<p>这些是在北京<\/p><p>这些是在你<\/p>"
 }
 */

/** id */
@property (nonatomic, strong) NSNumber<Optional> *id;
/** 名称 */
@property (nonatomic, copy) NSString <Optional> *name;
/** 内容 */
@property (nonatomic, copy) NSString <Optional>*content;
/** 选择 */
@property (nonatomic, copy) NSNumber <Ignore>*select;


@end

NS_ASSUME_NONNULL_END
