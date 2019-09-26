//
//  TFDepartmentModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/30.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFEmployModel.h"

@protocol TFDepartmentModel

@end

@interface TFDepartmentModel : JSONModel
/**{
    "count": 2,
    "checked": false,
    "childList": [
                  {
                      "count": 0,
                      "checked": false,
                      "childList": [],
                      "id": "4",
                      "text": "java开发",
                      "parentId": "1",
                      "users": []
                  }
                  ],
    "id": "1",
    "text": "研发部门",
    "parentId": "3",
    "users": [
              {
                  "count": 0,
                  "checked": false,
                  "id": "1",
                  "text": "陈三"
              },
              {
                  "count": 0,
                  "checked": false,
                  "id": "4",
                  "text": "周杰伦"
              }
              ]
}
*/


/** 部门人数 */
@property (nonatomic, strong) NSNumber <Optional>*count;

/** 公司人数 */
@property (nonatomic, strong) NSNumber <Optional>*company_count;

/** 部门id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** 部门名字 */
@property (nonatomic, copy) NSString <Optional>*name;
/** 父部门 */
@property (nonatomic, copy) NSString <Optional>*parentId;
/** 部门人员列表 */
@property (nonatomic, strong) NSArray <TFEmployModel,Optional>*users;
/** 子部门列表 */
@property (nonatomic, strong) NSArray <TFDepartmentModel,Optional>*childList;

/** value */
@property (nonatomic, copy) NSString <Optional>*value;

/** 部门层级 */
@property (nonatomic, strong) NSNumber <Ignore>*level;
/** 部门选中 0:未选中 1:选中 2:固定选中 */
@property (nonatomic, strong) NSNumber <Ignore>*select;
/** 部门展开 */
@property (nonatomic, strong) NSNumber <Ignore>*open;
/** 区别离职人员 */
@property (nonatomic, strong) NSNumber <Optional>*type;
/** 名字宽度 */
@property (nonatomic, strong) NSNumber <Ignore>*width;
/** 名字高度 */
@property (nonatomic, strong) NSNumber <Ignore>*height;


@end
