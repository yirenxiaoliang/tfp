//
//  HQTFUploadController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/30.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFFileModel.h"

/** 1：项目，2：随手记，3：文件库，4：企信，5日程，6：成员和登录，7：公告，8：审批，9：工作汇报，10投诉建议 */
typedef enum {
    UploadModelProject=1,  // 项目模块
    UploadModelSchedule=5, // 日程模块
    UploadModelFileLibray=3, //文件库模块
    UploadModelApprove=8, //审批模块
    UploadModelNotice=7, //通知模块
    UploadModelNote=2, //随手记模块
    UploadModelWorkReport=9, //工作汇报模块
    
}UploadModel;

typedef enum {
    UploadFileTypeVoice,  // 语音
    UploadFileTypeCamara,  // 拍照
    UploadFileTypeAblum,  // 相册
    UploadFileTypeFile  // 文件库
    
}UploadFileType;

@interface HQTFUploadController : HQBaseViewController


/** 初始化控制器
 *
 *  @prama files 已上传的文件数组
 *  @prama uploadModel 上传文件的模块
 *  @prama type  根据模块初始选择哪种上传  0:语音 1:拍照 2:相册
 */

-(instancetype)initWithFiles:(NSArray<TFFileModel>*)files withUploadModel:(UploadModel)uploadModel withType:(UploadFileType)type;

-(instancetype)initWithFiles:(NSArray<TFFileModel> *)files withUploadModel:(UploadModel)uploadModel withType:(UploadFileType)type projectId:(NSNumber *)projectId taskId:(NSNumber *)taskId;

/** 值 */
@property (nonatomic, copy) ActionParameter actionParameter;

//是否限制选择图片数量
@property (nonatomic, assign) BOOL isLimit;

@property (nonatomic, assign) NSInteger diskId;

@property (nonatomic, strong) NSNumber *scheduleDetailId;

@end
