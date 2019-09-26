//
//  TFProjectShareSendModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/17.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFProjectShareSendModel : JSONModel

//{
//    "id":1,                                   //项目id
//    "title":项目管理规范,                     //分享标题
//    "content":基于项目管理规定,               //分享内容
//    "shareIds":1,2,3                         //分享人（逗号分隔）
//    "shareStatus": 1                         //所有人可见  0不可见 1可见
//    "submitStatus":0                         //提交知识库  0不提交 1提交
//}

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*title;

@property (nonatomic, copy) NSString <Optional>*content;

@property (nonatomic, copy) NSString <Optional>*shareIds;

@property (nonatomic, strong) NSNumber <Optional>*shareStatus;

@property (nonatomic, strong) NSNumber <Optional>*submitStatus;

@end
