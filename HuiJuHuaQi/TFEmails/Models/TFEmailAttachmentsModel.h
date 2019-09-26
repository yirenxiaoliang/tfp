//
//  TFEmailAttachmentsModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFEmailAttachmentsModel @end

@interface TFEmailAttachmentsModel : JSONModel

//{
//    "fileName":"123.jpg",
//    "fileType":"jpg",
//    "fileSize":"123456",
//    "fileUrl":"http://123/123.jpg"
//}


@property (nonatomic, copy) NSString <Optional>*fileName;

@property (nonatomic, strong) NSNumber <Optional>*fileSize;

@property (nonatomic, copy) NSString <Optional>*fileType;

@property (nonatomic, copy) NSString <Optional>*fileUrl;

@end
