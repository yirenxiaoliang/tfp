//
//  TFApprovalDynamicModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/5/26.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseVoModel.h"
#import "TFFileModel.h"

@protocol TFApprovalDynamicModel 

@end

@interface TFApprovalDynamicModel : HQBaseVoModel

/** approveId */
@property (nonatomic, strong) NSNumber <Optional>*approveId;
/** 动态发布时间 */
@property (nonatomic, strong) NSNumber <Optional>*createTime;

/** 动态发布者 */
@property (nonatomic, strong) NSNumber <Optional>*employeeId;
/** 员工名 */
@property (nonatomic, copy) NSString <Optional>*employeeName;
/** 头像 */
@property (nonatomic, copy) NSString <Optional>*photograph;

/** 动态内容 */
@property (nonatomic, copy) NSString <Optional>*talkDatail;

/** 语音or图片地址 */
@property (nonatomic, copy) NSString <Optional>*fileUrl;
/** 语音or图片地址 */
@property (nonatomic, copy) NSString <Optional>*fileType;
/** 语音or图片地址 */
@property (nonatomic, copy) NSString <Optional>*fileName;
/** 语音or图片地址 */
@property (nonatomic, strong) NSNumber <Optional>*fileSize;

/** 语音时长 */
@property (nonatomic, assign) NSNumber <Optional>*voiceTime;



@end
