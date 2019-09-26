//
//  TFTaskDynamicItemModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/3.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQBaseVoModel.h"


@protocol TFTaskDynamicItemModel

@end

@interface TFTaskDynamicItemModel : HQBaseVoModel

/** 员工名 */
@property (nonatomic, copy) NSString <Optional>*employeeName;
/** 员工名 */
@property (nonatomic, copy) NSString <Optional>*position;
/** 头像 */
@property (nonatomic, copy) NSString <Optional>*photograph;
/** 创建人id */
@property (nonatomic, strong) NSNumber <Optional>*employeeId;
/** 内容 */
@property (nonatomic, copy) NSString <Optional>*commentContent;
/** 文件后缀 */
@property (nonatomic, copy) NSString <Optional>*fileType;
/** 文件名 */
@property (nonatomic, copy) NSString <Optional>*fileName;
/** 文件地址 */
@property (nonatomic, copy) NSString <Optional>*fileUrl;
/** 文件大小 */
@property (nonatomic, copy) NSString <Optional>*fileSize;
/** 创建时间 */
@property (nonatomic, strong) NSNumber <Optional>*createTime;
/** 语音时间 */
@property (nonatomic, strong) NSNumber <Optional>*voiceDuration;


@end
