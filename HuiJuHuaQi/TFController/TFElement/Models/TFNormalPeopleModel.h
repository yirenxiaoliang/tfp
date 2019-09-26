//
//  TFNormalPeopleModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQEmployModel.h"

@protocol TFNormalPeopleModel 

@end


@interface TFNormalPeopleModel : JSONModel
/**
 "checked" : true,
 "id" : 1,
 "picture" : "http:\/\/192.168.1.58:8281\/custom-gateway\/common\/file\/imageDownload?bean=company&fileName=company\/1513935949635.ab0ca502f12ae618be567da104fbab84.jpg",
 "type" : 1,
 "text" : "李萌" */

/** checked */
@property (nonatomic, strong) NSNumber <Optional>*checked;
/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** picture */
@property (nonatomic, copy) NSString <Optional>*picture;
/** type 0部门 1成员 2角色 3动态参数   */
@property (nonatomic, strong) NSNumber <Optional>*type;
/** name */
@property (nonatomic, copy) NSString <Optional>*name;
/** value */
@property (nonatomic, copy) NSString <Optional>*value;


@end
