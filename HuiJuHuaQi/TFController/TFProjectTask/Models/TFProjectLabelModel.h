//
//  TFProjectLabelModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/28.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFProjectLabelModel

@end

@interface TFProjectLabelModel : JSONModel

/** {
 "parent_id" : "",
 "id" : 1,
 "colour" : "",
 "name" : "牡丹",
 "childList" : [
 {
 "parent_id" : 1,
 "id" : 3,
 "colour" : "#ccc",
 "parent_name" : "牡丹",
 "name" : "哈哈哈",
 "sequence_no" : 1
 }
 ],
 "sequence_no" : ""
 } */

/** parent_id */
@property (nonatomic, strong) NSNumber <Optional>*parent_id;
/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** colour */
@property (nonatomic, copy) NSString <Optional>*colour;
/** parent_name */
@property (nonatomic, copy) NSString <Optional>*parent_name;
/** name */
@property (nonatomic, copy) NSString <Optional>*name;
/** sequence_no */
@property (nonatomic, strong) NSNumber <Optional>*sequence_no;

/** childList */
@property (nonatomic, strong) NSArray<TFProjectLabelModel,Optional> *childList;

/** select */
@property (nonatomic, strong) NSNumber <Ignore>*select;


@end
