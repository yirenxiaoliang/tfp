//
//  TFWebLinkModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/29.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFLinkModel

@end

@interface TFLinkModel : JSONModel

@property (nonatomic, copy) NSString <Optional>*name;
@property (nonatomic, copy) NSString <Optional>*url;

@end

@interface TFWebLinkModel : JSONModel


/** {
 "modifyTime" : 1542686171204,
 "id" : "5bf3861b76d6c01604d4b94d",
 "externalLink" : "http:\/\/192.168.1.49:8123\/#\/http:\/\/192.168.1.63:8080\/#\/sZrpKWsOo.http:\/\/192.168.1.63:8080\/#\/sZrpKWsOo.2.2.bean1542685152713.2",
 "modifyBy" : {
 "id" : "5",
 "picture" : "http:\/\/192.168.1.183:8081\/custom-gateway\/common\/file\/imageDownload?bean=company&fileName=1540350101843\/blob&fileSize=4160",
 "employee_name" : "徐兵"
 },
 "title" : "新增用户表单",
 "expandLink" : [
 
 ],
 "publish" : "1",
 "accessPassword" : "",
 "accessAuth" : "1"
 } */

@property (nonatomic, strong) NSNumber <Optional>*modifyTime;
@property (nonatomic, copy) NSString <Optional>*id;
@property (nonatomic, copy) NSString <Optional>*externalLink;
@property (nonatomic, copy) NSString <Optional>*signInLink;
@property (nonatomic, strong) TFEmployModel <Optional>*modifyBy;
@property (nonatomic, copy) NSString <Optional>*title;
@property (nonatomic, copy) NSString <Optional>*publish;
@property (nonatomic, copy) NSString <Optional>*accessPassword;
@property (nonatomic, copy) NSString <Optional>*accessAuth;
@property (nonatomic, strong) NSArray <Optional,TFLinkModel>*expandLink;
@property (nonatomic, copy) NSString <Optional>*shareTitle;
@property (nonatomic, copy) NSString <Optional>*shareDescription;
@property (nonatomic, strong) NSNumber <Ignore>*select;

@end

NS_ASSUME_NONNULL_END
