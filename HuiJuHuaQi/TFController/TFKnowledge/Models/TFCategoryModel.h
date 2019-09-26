//
//  TFCategoryModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"


NS_ASSUME_NONNULL_BEGIN

@protocol TFCategoryModel

@end

@interface TFCategoryModel : JSONModel

/** {
 "name": "书籍",
 "id": 1,
 "labels": [
 {
 "name": "鹿茸",
 "classification_id": 1,
 "id": 7
 },
 {
 "name": "田七",
 "classification_id": 1,
 "id": 9
 },
 {
 "name": "人参",
 "classification_id": 1,
 "id": 1
 },
 {
 "name": "貂皮",
 "classification_id": 1,
 "id": 8
 }
 ]
 } */
/** 名称 */
@property (nonatomic, copy) NSString <Optional>*name;
/** id */
@property (nonatomic, strong) NSNumber  <Optional>*id;
/**分类Id */
@property (nonatomic, strong) NSNumber  <Optional>*classification_id;
/**分类标签 */
@property (nonatomic, strong) NSArray  <TFCategoryModel,Optional>*labels;


@property (nonatomic, strong) NSNumber  <Ignore>*select;
@property (nonatomic, strong) NSNumber  <Ignore>*show;












@end

NS_ASSUME_NONNULL_END
