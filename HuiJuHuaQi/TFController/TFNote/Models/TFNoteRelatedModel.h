//
//  TFNoteRelatedModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/29.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFNoteRelatedModel : JSONModel

//{
//    "id": 1,
//    "status": "0", 0新增 1删除
//    "beanArr":[
//               {
//                   "bean": "bean1534928172882",
//                   "ids": "2,3,4"
//               }
//               .......
//               ]
//}
@property (nonatomic, strong) NSNumber *id;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) NSMutableArray *beanArr;

@end
