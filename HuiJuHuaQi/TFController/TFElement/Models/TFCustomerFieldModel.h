//
//  TFCustomerFieldModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFNumberingModel.h"
#import "TFCustomerOptionModel.h"
#import "TFNormalPeopleModel.h"

@interface TFCustomerFieldModel : JSONModel<NSCoding,NSMutableCopying>

/**  "type": "int",
 "required": "true",
 "defaultValue": "0",
 "length": "1",
 "entrys": */
 @property (nonatomic, copy) NSString <Optional>*add;
 @property (nonatomic, copy) NSString <Optional>*adelete;
 @property (nonatomic, copy) NSString <Optional>*mustFill ;


/** 详情显示 */
@property (nonatomic, copy) NSString <Optional>*detailView;
/** 新增显示 0：不显示 1：显示 */
@property (nonatomic, copy) NSString <Optional>*addView;
/** 编辑显示 0：不显示 1：显示 */
@property (nonatomic, copy) NSString <Optional>*editView;
/** 选项字段控制是否隐藏 nil or 0 不隐藏， 1为隐藏 */
@property (nonatomic, copy) NSString <Ignore>*isOptionHidden;
/** 用于记录该组件隐藏是哪个组件控制的name */
@property (nonatomic, copy) NSString <Ignore>*optionHiddenName;
/** 省市区类型 0：省市区，1：省市，2：省，3：市，4：区 */
@property (nonatomic, copy) NSString <Optional>*areaType;
/** 字段控制(0都不选 1只读 2必填) */
@property (nonatomic, copy) NSString <Optional>*fieldControl;
/** 结构 0:上下 1:左右 */
@property (nonatomic, copy) NSString <Optional>*structure;
/** 默认值 */
@property (nonatomic, copy) NSString <Optional>*defaultValue;
/** 默认选项数组 */
@property (nonatomic, strong) NSArray <Optional,TFCustomerOptionModel>*defaultEntrys;
/** 默认值id */
@property (nonatomic, copy) NSString <Optional>*defaultValueId;
/** 默认值颜色 */
@property (nonatomic, copy) NSString <Optional>*defaultValueColor;
/** 提示框 */
@property (nonatomic, copy) NSString <Optional>*pointOut;
/** PC终端 */
@property (nonatomic, copy) NSString <Optional>*terminalPc;
/** APP终端 */
@property (nonatomic, copy) NSString <Optional>*terminalApp;
/** 去重 */
@property (nonatomic, copy) NSString <Optional>*repeatCheck;
/** 时间格式类型：yyyy-MM-dd */
@property (nonatomic, copy) NSString <Optional>*formatType;
/** 多级下拉级数  0：二级  1：三级 */
@property (nonatomic, copy) NSString <Optional>*selectType;
/** 条形码类型 0:自定义 1:国际 */
@property (nonatomic, copy) NSString <Optional>*codeType;
/** 条形码样式 */
@property (nonatomic, copy) NSString <Optional>*codeStyle;
/** 关联模块有条形码组件 */
@property (nonatomic, copy) NSString <Optional>*allowScan;

/**  1（省）、2（市）、 3（区） */
@property (nonatomic, copy) NSString <Optional>*commonlyArea;

/** defaultPersonnel */
@property (nonatomic, strong) NSArray <Optional,TFNormalPeopleModel>*defaultPersonnel;

/** defaultPersonnel */
@property (nonatomic, strong) NSArray <Optional,TFNormalPeopleModel>*defaultDepartment;

#pragma mark - 图片
/** 限制最大上传多少张图片 */
@property (nonatomic, copy) NSString <Optional>*maxCount;
/** 每张图片最大M，单位为M(兆) */
@property (nonatomic, copy) NSString <Optional>*maxSize;
/** 是否限制上传 */
@property (nonatomic, copy) NSString <Optional>*countLimit;

/** 图片尺寸大小 */
@property (nonatomic, copy) NSString <Optional>*imageSize;

/** 电话长度 */
@property (nonatomic, copy) NSString <Optional>*phoneLenth;
/** 电话类型 */
@property (nonatomic, copy) NSString <Optional>*phoneType;

#pragma mark - 公式
/** 数字类型：0数字、1整数、2百分比 */
@property (nonatomic, copy) NSString <Optional>*numberType;
/** 小数位：0~4位 */
@property (nonatomic, copy) NSString <Optional>*numberLenth;
/** 最小 */
@property (nonatomic, copy) NSString <Optional>*betweenMin;
/** 最大 */
@property (nonatomic, copy) NSString <Optional>*betweenMax;


/** 公式设置 */
@property (nonatomic, copy) NSString <Optional>*formula;
/** 新公式是否对旧数据重新计算 */
@property (nonatomic, copy) NSString <Optional>*formulaCalculates;
/** 公式小数位：0~4位 */
@property (nonatomic, copy) NSString <Optional>*decimalLen;


/** choosePersonnel */
@property (nonatomic, strong) NSArray<Optional,TFEmployModel> *choosePersonnel;


#pragma mark - 人员
/** 选择类型：0单选、1多选 */
@property (nonatomic, copy) NSString <Optional>*chooseType;
/** 可选范围(公司:gs_id、部门:bm_id、人员:ry_id) */
@property (nonatomic, copy) NSArray <Optional,TFNormalPeopleModel>*chooseRange;


/** 数字分割位数 '0':无分隔符，'1':千分位，'2':万分位 */
@property (nonatomic, copy) NSString <Optional>*numberDelimiter;
/** 子表单在无值及编辑状态时显示默认值与否 */
@property (nonatomic, copy) NSString <Optional>*editorShowDefault;

@end
