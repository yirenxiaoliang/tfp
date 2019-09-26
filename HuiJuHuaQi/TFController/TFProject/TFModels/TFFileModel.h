//
//  TFFileModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/31.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQBaseVoModel.h"

typedef enum {
    FileTypeImg,
    FileTypeVioce,
    FileTypeWord,
    FileTypeExcel,
    FileTypePDF,
    FileTypeOther
    
}FileType;

@protocol TFFileModel
@end

@interface TFFileModel : HQBaseVoModel

/** 所属记录id，可为项目、任务列表、任务、任务评论 */
@property (nonatomic, strong) NSNumber <Optional>*itemId;
/** 所属记录的类型：0项目、1任务列表、2任务、3合同、4任务评论 */
@property (nonatomic, strong) NSNumber <Optional>*itemType;


/** 文档地址 */
@property (nonatomic, copy) NSString <Optional>*fileUrl;
/** 文件名 */
@property (nonatomic, copy) NSString <Optional>*fileName;
/** 原始文件名 */
@property (nonatomic, copy) NSString <Optional>*originalFileName;
/** 文件大小 */
@property (nonatomic, strong) NSNumber <Optional>*fileSize;
/** 文件序列号 */
@property (nonatomic, strong) NSNumber <Optional>*serialNumber;
/** 文件类型后缀 */
@property (nonatomic, strong) NSString <Optional>*fileType;

/** 创建时间 */
@property (nonatomic, strong) NSNumber <Optional> *createTime;
/** 创建时间 */
@property (nonatomic, strong) NSNumber <Optional> *uploadTime;
/** 创建时间 */
@property (nonatomic, strong) NSNumber <Optional> *updateTime;


/** 员工状态 */
@property (nonatomic, strong) NSNumber <Optional>*employeeStatus;
/** 员工id */
@property (nonatomic, strong) NSNumber <Optional>*employeeId;
/** 头像 */
@property (nonatomic, strong) NSString <Optional>*photograph;
/** 员工名字 */
@property (nonatomic, strong) NSString <Optional>*employeeName;
/** 创建id */
@property (nonatomic, strong) NSNumber <Optional>*creatorId;
/** 创建人 */
@property (nonatomic, strong) NSString <Optional>*creatorName;
/** 公司id */
@property (nonatomic, strong) NSNumber <Optional>*companyId;
/** 项目id */
@property (nonatomic, strong) NSNumber <Optional>*projectId;
/** 任务id */
@property (nonatomic, strong) NSNumber <Optional>*taskId;


/** 语音地址 */
@property (nonatomic, copy) NSString <Ignore>*voicePath;
/** 语音时长 */
@property (nonatomic, assign) NSNumber <Ignore>*voiceDuration;
/** 文档data */
@property (nonatomic, copy) NSData <Ignore>*fileData;
/** 图片Image */
@property (nonatomic, strong) UIImage <Ignore>*image;

/* 文件位置 */
@property (nonatomic, assign) NSNumber <Optional>*location;

@property (nonatomic, copy) NSString <Optional>*fileSrc; //文件来源（上传新版本）

@property (nonatomic, strong) NSNumber <Optional>*version;

@property (nonatomic, assign) NSNumber <Optional>*dirId;//文件父id

@property (nonatomic, assign) NSNumber <Optional>*isPublic;//文件父权限

@property (nonatomic, assign) NSNumber <Optional>*calendarId;

//工作汇报编辑计划的附件
@property (nonatomic, copy) NSString <Optional>*attachmentUrl;

@property (nonatomic, strong) NSNumber <Optional>*voiceTime;

@end
