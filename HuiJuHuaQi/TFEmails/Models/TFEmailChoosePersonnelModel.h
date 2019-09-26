//
//  TFEmailChoosePersonnelModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFEmailChoosePersonnelModel @end

@interface TFEmailChoosePersonnelModel : JSONModel

//{
//    　　　　　　　　"leader":"0",
//    　　　　　　　　"mood":"",
//    　　　　　　　　"is_enable":"1",
//    　　　　　　　　"personnel_create_by":"",
//    　　　　　　　　"sex":"",
//    　　　　　　　　"sign":"",
//    　　　　　　　　"birth":"",
//    　　　　　　　　"employee_name":"李萌",
//    　　　　　　　　"del_status":"0",
//    　　　　　　　　"picture":"http://192.168.1.9:8080/custom-gateway/common/file/download?bean=user&fileName=1/user/1520474520827.20141016153644_i3Ajf.gif",
//    　　　　　　　　"microblog_background":"",
//    　　　　　　　　"datetime_create_time":"",
//    　　　　　　　　"post_id":1,
//    　　　　　　　　"phone":"17198669671",
//    　　　　　　　　"role_id":3,
//    　　　　　　　　"mobile_phone":"",
//    　　　　　　　　"id":2,
//    　　　　　　　　"region":"",
//    　　　　　　　　"email":"",
//    　　　　　　　　"account":"17198669671",
//    　　　　　　　　"status":"0"
//    　　　　　　},

@property (nonatomic, strong) NSNumber <Optional>*leader;

@property (nonatomic, strong) NSNumber <Optional>*mood;

@property (nonatomic, strong) NSNumber <Optional>*is_enable;

@property (nonatomic, copy) NSString <Optional>*personnel_create_by;

@property (nonatomic, copy) NSString <Optional>*employee_name;

@property (nonatomic, strong) NSNumber <Optional>*del_status;

@property (nonatomic, copy) NSString <Optional>*picture;

@property (nonatomic, strong) NSNumber <Optional>*datetime_create_time;

@property (nonatomic, strong) NSNumber <Optional>*post_id;

@property (nonatomic, copy) NSString <Optional>*phone;

@property (nonatomic, strong) NSNumber <Optional>*role_id;

@property (nonatomic, copy) NSString <Optional>*mobile_phone;

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, strong) NSNumber <Optional>*email;

@property (nonatomic, copy) NSString <Optional>*account;

@property (nonatomic, strong) NSNumber <Optional>*status;

@end
