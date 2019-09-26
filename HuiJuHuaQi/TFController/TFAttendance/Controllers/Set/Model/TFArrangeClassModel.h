//
//  TFArrangeClassModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/7.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFAtdClassModel.h"
NS_ASSUME_NONNULL_BEGIN
/** {
 "attendance_month" : "2019-03",
 "classes_arr" : [
 {
 "class_desc" : "09:00-18:00",
 "name" : "BC-02",
 "id" : 14
 }
 ],
 "group_name" : "",
 "group_id" : ""
 } */


@interface TFArrangeClassModel : JSONModel

@property (nonatomic, copy) NSString <Optional>*attendance_month;
@property (nonatomic, copy) NSString <Optional>*group_name;
@property (nonatomic, copy) NSString <Optional>*group_id;

@property (nonatomic, strong) NSArray <TFAtdClassModel , Optional>*classes_arr;

@end

NS_ASSUME_NONNULL_END
