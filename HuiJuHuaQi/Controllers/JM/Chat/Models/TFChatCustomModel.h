//
//  TFChatCustomModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/7/6.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFFileModel.h"
#import "HQEmployModel.h"

@interface TFChatCustomModel : JSONModel


/** 类型 1110：任务，1111：文件库；1112：随手记，1113：审批，1114：日程，1115：公告，1116：投诉建议，1117：工作汇报，1118：订单，1119：考勤，1120：投票 */
@property (nonatomic, strong) NSNumber <Optional>*type;
/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** 名字 */
@property (nonatomic, copy) NSString <Optional>*title;
/** 创建时间 */
@property (nonatomic, strong) NSNumber <Optional>*createTime;

/** 员工id */
@property (nonatomic, strong) NSNumber <Optional>*employeeId;
/** 员工姓名 */
@property (nonatomic, copy) NSString <Optional>*employeeName;

/** 文档地址 */
@property (nonatomic, copy) NSString <Optional>*fileUrl;
/** 文件名 */
@property (nonatomic, copy) NSString <Optional>*fileName;
/** 文件大小 */
@property (nonatomic, strong) NSNumber <Optional>*fileSize;
/** 文件类型后缀 */
@property (nonatomic, strong) NSString <Optional>*fileType;


///** 创建人 */
//@property (nonatomic, strong) HQEmployModel <Optional>*creator;
///** 文件对象 */
//@property (nonatomic, strong) TFFileModel <Optional>*file;
@end
