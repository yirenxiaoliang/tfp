//
//  TFFileDetailController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFFileDetailModel.h"
#import "TFProjectFileModel.h"

@interface TFFileDetailController : HQBaseViewController

@property (nonatomic, strong) NSNumber *fileId;

@property (nonatomic,strong) NSMutableArray *pathArr;

/** 根目录 1：公司文件 2：应用文件 3：个人文件 4：我共享的 5：与我共享的 6：项目文件 */
@property (nonatomic, assign) NSInteger style;

@property (nonatomic, copy) NSString *naviTitle;

/** 是否是图片 0:不是 1:图片 2：音频 */
@property (nonatomic, assign) NSInteger isImg;

/** 从哪进来 0:文件库 1:聊天文件 2:邮件附件 3:项目文库 */
@property (nonatomic, assign) NSInteger whereFrom;

@property (nonatomic, strong) TFFileDetailModel *detailModel;

@property (nonatomic, strong) TFFolderListModel *basics;

@property (nonatomic, copy) NSString *fileUrl;

@property (nonatomic, copy) ActionHandler refreshAction;

                      /** 项目文库 */
@property (nonatomic, strong) NSNumber *projectId;

/** 权限 */
@property (nonatomic, copy) NSString *privilege;
@property (nonatomic, copy) NSString *library_type;

// @进来的没权限
@property (nonatomic, assign) BOOL noAuth;


@end
