//
//  HQBenchMainfaceModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/7/15.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBenchMainfaceModel.h"
#import "HQRootModel.h"

@implementation HQBenchMainfaceModel


- (void)encodeWithCoder:(NSCoder *)encoder{
    
    [encoder encodeObject:self.allItems forKey:@"allItems"];
    [encoder encodeObject:self.nowItems forKey:@"nowItems"];
    [encoder encodeObject:self.employID forKey:@"employID"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder{
    
    if (self = [super init]) {
        self.allItems = [decoder decodeObjectForKey:@"allItems"];
        self.nowItems = [decoder decodeObjectForKey:@"nowItems"];
        self.employID = [decoder decodeObjectForKey:@"employID"];
    }
    return self;
}


/** *******************************固定工作台*************************** */
/** 归档 */
+ (void)benchMainfaceArchiveWithModel:(HQBenchMainfaceModel *)model{
    
    if (!model) {
        return;
    }
    
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.model", model.employID]];
    
    //2.将自定义的对象保存到文件中
    [NSKeyedArchiver archiveRootObject:model toFile:path];
    
}


/** 解档 */
+ (instancetype)benchMainfaceUnarchiveWithEmployID:(NSNumber *)employID{
    
    if (!employID) {
        return nil;
    }
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.model", employID]];
    
    
    id model = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    
    if (model) {
        
        return model;
        
    }else{
        
        return [self setupData];
    }
    
}


#pragma 初始化数据
+ (instancetype)setupData{
    
    NSArray *name = @[@"考勤中心",@"审批中心",@"任务中心",@"项目协同",@"日程中心",@"工作报告",@"投诉建议",@"CRM",@"收藏夹",@"更多"];
    NSArray *image = @[@"考勤中心",@"审批中心",@"任务中心",@"项目协同",@"日程中心",@"工作报告",@"投诉建议",@"CRM",@"收藏夹",@"更多功能"];
    NSMutableArray *dataAll = [NSMutableArray array];
    
    for (NSInteger i = 0; i < name.count; i++) {
        HQRootModel *model = [[HQRootModel alloc] init];
        model.name = name[i];
        model.image = image[i];
        model.markNum = 0;
        model.OutDate = NO;
        model.backColor = NO;
        model.deleteShow = NO;
        model.functionModelType = (FunctionModelType)(i + 1);
        
        [dataAll addObject:model];
    }
    
    //    HQBenchMainfaceModel *mainface = [HQBenchMainfaceModel benchMainfaceUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
    
    //    if (!mainface) {
    HQBenchMainfaceModel *mainface = [[HQBenchMainfaceModel alloc] init];
    mainface.allItems = dataAll;
    mainface.employID = [HQHelper getCurrentLoginEmployee].id;
    mainface.nowItems = dataAll;
    [HQBenchMainfaceModel benchMainfaceArchiveWithModel:mainface];
    //    }
    return mainface;
}


/** *******************************滑动工作台*************************** */
/** 归档 */
+ (void)workDeskArchiveWithModel:(HQBenchMainfaceModel *)model{
    
    if (!model) {
        return;
    }
    
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@workDesk.model", model.employID]];
    
    //2.将自定义的对象保存到文件中
    [NSKeyedArchiver archiveRootObject:model toFile:path];
    
}


/** 解档 */
+ (instancetype)workDeskUnarchiveWithEmployID:(NSNumber *)employID{
    
    if (!employID) {
        return nil;
    }
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@workDesk.model", employID]];
    
    
    id model = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    
    if (model) {
        
        return model;
        
    }else{
        
        return [self setupWorkDeskData];
    }
    
}


#pragma 初始化WorkDesk数据
+ (instancetype)setupWorkDeskData{
    
    NSArray *name = @[@"考勤",@"报告",@"任务",@"项目",@"CRM",@"审批",@"日程",@"公告",@"紧急事务",@"投诉建议"];
    NSArray *image = @[@"考勤",@"日报",@"任务",@"项目",@"CRMwork",@"审批",@"日程",@"公告",@"紧急事务",@"投诉建议work"];
    NSMutableArray *dataAll = [NSMutableArray array];
    
    for (NSInteger i = 0; i < name.count; i++) {
        HQRootModel *model = [[HQRootModel alloc] init];
        model.name = name[i];
        model.image = image[i];
        model.markNum = 0;
        model.OutDate = NO;
        model.backColor = NO;
        model.deleteShow = NO;
        
        if (i == 0) {
            model.functionModelType = FunctionModelTypeSubscribe;
        }else if (i == 1) {
            model.functionModelType = FunctionModelTypeReport;
        }else if (i == 2) {
            model.functionModelType = FunctionModelTypeTask;
        }else if (i == 3) {
            model.functionModelType = FunctionModelTypePrejectPartner;
        }else if (i == 4) {
            model.functionModelType = FunctionModelTypeCrm;
        }else if (i == 5) {
            model.functionModelType = FunctionModelTypeApproval;
        }else if (i == 6) {
            model.functionModelType = FunctionModelTypeSchedule;
        }else if (i == 7) {
            model.functionModelType = FunctionModelTypeNotice;
        }else if (i == 8) {
            model.functionModelType = FunctionModelTypeUrgent;
        }else{
            model.functionModelType = FunctionModelTypeAdvice;
        }
        
        [dataAll addObject:model];
    }
    
    
    HQBenchMainfaceModel *mainface = [[HQBenchMainfaceModel alloc] init];
    mainface.allItems = dataAll;
    mainface.employID = [HQHelper getCurrentLoginEmployee].id;
    mainface.nowItems = dataAll;
    [HQBenchMainfaceModel workDeskArchiveWithModel:mainface];
    
    return mainface;
}

/** *******************************模块管管（我的应用）*************************** */

/** 归档 */
+ (void)modelManageArchiveWithModel:(HQBenchMainfaceModel *)model{
    
    if (!model) {
        return;
    }
    
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@modelManage.model", NUMBER(model.employID)]];
    
    //2.将自定义的对象保存到文件中
    [NSKeyedArchiver archiveRootObject:model toFile:path];
    
}


/** 解档 */
+ (instancetype)modelManageUnarchiveWithEmployID:(NSNumber *)employID{
    
    //    if (!employID) {
    ////        return nil;
    //
    //        return [self setupModelManageData];
    //    }
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@modelManage.model", NUMBER(employID)]];
    
    
    id model = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    
    if (model) {
        
        return model;
        
    }else{
        
        return [self setupModelManageData];
    }
    
}


#pragma 初始化ModelManage数据
+ (instancetype)setupModelManageData{
    
    NSArray *name = @[@"项目",@"日程",@"随手记",@"文件库",@"审批",@"工作汇报",@"公告",@"通讯录",@"同事圈",@"投诉建议"];
    NSArray *image = @[@"项目",@"日程",@"随手记",@"文件库",@"审批",@"工作汇报",@"公告",@"通讯录",@"企业圈",@"投诉建议"];
    NSMutableArray *dataAll = [NSMutableArray array];
    
    for (NSInteger i = 0; i < name.count; i++) {
        HQRootModel *model = [[HQRootModel alloc] init];
        model.name = name[i];
        model.image = image[i];
        model.markNum = 0;
        model.OutDate = NO;
        model.backColor = NO;
        model.deleteShow = NO;
        
        if (i == 0) {
            model.functionModelType = FunctionModelTypePrejectPartner;
        }else if (i == 1) {
            model.functionModelType = FunctionModelTypeSchedule;
        }else if (i == 2) {
            model.functionModelType = FunctionModelTypeNote;
        }else if (i == 3) {
            model.functionModelType = FunctionModelTypeFile;
        }else if (i == 4) {
            model.functionModelType = FunctionModelTypeApproval;
        }else if (i == 5) {
            model.functionModelType = FunctionModelTypeReport;
        }else if (i == 6) {
            model.functionModelType = FunctionModelTypeNotice;
        }else if (i == 7) {
            model.functionModelType = FunctionModelTypeContact;
        }else if (i == 8) {
            model.functionModelType = FunctionModelTypeCircle;
        }else if (i == 9){
            model.functionModelType = FunctionModelTypeAdvice;
        }
        
        [dataAll addObject:model];
    }
    
    
    HQBenchMainfaceModel *mainface = [[HQBenchMainfaceModel alloc] init];
    mainface.allItems = dataAll;
    mainface.employID = [HQHelper getCurrentLoginEmployee].id;
    mainface.nowItems = dataAll;
    [HQBenchMainfaceModel modelManageArchiveWithModel:mainface];
    
    return mainface;
}

/** *******************************第三方应用*************************** */
/** 归档 */
+ (void)thirdAppArchiveWithModel:(HQBenchMainfaceModel *)model{
    
    if (!model) {
        return;
    }
    
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@thirdApp.model", model.employID]];
    
    //2.将自定义的对象保存到文件中
    [NSKeyedArchiver archiveRootObject:model toFile:path];
    
}


/** 解档 */
+ (instancetype)thirdAppUnarchiveWithEmployID:(NSNumber *)employID{
    
    if (!employID) {
        //        return nil;
        
        return [self setupThirdAppData];
    }
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@thirdApp.model", employID]];
    
    
    id model = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    
    if (model) {
        
        return model;
        
    }else{
        
        return [self setupThirdAppData];
    }
    
}


#pragma 初始化ModelManage数据
+ (instancetype)setupThirdAppData{
    
    NSArray *name = @[@"课程",@"机票",@"视频",@"火车票",@"天气",@"地图",@"购物"];
    NSArray *image = @[@"课程",@"机票",@"视频",@"火车票",@"天气",@"地图",@"购物"];
    NSMutableArray *dataAll = [NSMutableArray array];
    
    for (NSInteger i = 0; i < name.count; i++) {
        HQRootModel *model = [[HQRootModel alloc] init];
        model.name = name[i];
        model.image = image[i];
        model.markNum = 0;
        model.OutDate = NO;
        model.backColor = NO;
        model.deleteShow = NO;
        
        if (i == 0) {
            model.functionModelType = FunctionModelTypeCourse;
        }else if (i == 1) {
            model.functionModelType = FunctionModelTypePlane;
        }else if (i == 2) {
            model.functionModelType = FunctionModelTypeVideo;
        }else if (i == 3) {
            model.functionModelType = FunctionModelTypeTrain;
        }else if (i == 4) {
            model.functionModelType = FunctionModelTypeWeather;
        }else if (i == 5) {
            model.functionModelType = FunctionModelTypeMap;
        }else if (i == 6) {
            model.functionModelType = FunctionModelTypeShopping;
        }
        
        [dataAll addObject:model];
    }
    
    
    HQBenchMainfaceModel *mainface = [[HQBenchMainfaceModel alloc] init];
    mainface.allItems = dataAll;
    mainface.employID = [HQHelper getCurrentLoginEmployee].id;
    mainface.nowItems = dataAll;
    [HQBenchMainfaceModel thirdAppArchiveWithModel:mainface];
    
    return mainface;
}


/** *******************************所有审批类型*************************** */
/** 归档 */
+ (void)approvalTypeArchiveWithModel:(HQBenchMainfaceModel *)model{
    
    if (!model) {
        return;
    }
    
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@approvalType.model", model.employID]];
    
    //2.将自定义的对象保存到文件中
    [NSKeyedArchiver archiveRootObject:model toFile:path];
    
}


/** 解档 */
+ (instancetype)approvalTypeUnarchiveWithEmployID:(NSNumber *)employID{
    
    if (!employID) {
        //        return nil;
        
        return [self setupApprovalTypeData];
    }
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@approvalType.model", employID]];
    
    
    id model = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    
    if (model) {
        
        return model;
        
    }else{
        
        return [self setupApprovalTypeData];
    }
    
}


#pragma 初始化ModelManage数据
+ (instancetype)setupApprovalTypeData{
    
    NSArray *name = @[@"通用审批",@"请假",@"加班",@"出差",@"外出",@"补签卡",@"报销",@"销假",@"招聘审请",@"人事调动",@"物品申领"];
    NSArray *image = @[@"通用",@"请假",@"加班",@"出差",@"外出",@"补签卡",@"报销",@"销假",@"招聘",@"人事调动",@"物品申领"];
    NSMutableArray *dataAll = [NSMutableArray array];
    
    for (NSInteger i = 0; i < name.count; i++) {
        HQRootModel *model = [[HQRootModel alloc] init];
        model.name = name[i];
        model.image = image[i];
        model.markNum = 0;
        model.OutDate = NO;
        model.backColor = NO;
        model.deleteShow = NO;
        
        model.functionModelType = (FunctionModelType)(FunctionModelTypeAll + i);
        
        [dataAll addObject:model];
    }
    
    
    HQBenchMainfaceModel *mainface = [[HQBenchMainfaceModel alloc] init];
    mainface.allItems = dataAll;
    mainface.employID = [HQHelper getCurrentLoginEmployee].id;
    mainface.nowItems = dataAll;
    [HQBenchMainfaceModel approvalTypeArchiveWithModel:mainface];
    
    return mainface;
}

/** *******************************最近使用审批类型*************************** */
/** 归档 */
+ (void)nowApprovalTypeArchiveWithModel:(HQBenchMainfaceModel *)model{
    
    if (!model) {
        return;
    }
    
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@nowApprovalType.model", model.employID]];
    
    //2.将自定义的对象保存到文件中
    [NSKeyedArchiver archiveRootObject:model toFile:path];
    
}


/** 解档 */
+ (instancetype)nowApprovalTypeUnarchiveWithEmployID:(NSNumber *)employID{
    
    if (!employID) {
        //        return nil;
        
        return [self setupNowApprovalTypeData];
    }
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@nowApprovalType.model", employID]];
    
    
    id model = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    
    if (model) {
        
        return model;
        
    }else{
        
        return [self setupNowApprovalTypeData];
    }
    
}


#pragma 初始化ModelManage数据
+ (instancetype)setupNowApprovalTypeData{
    
    NSArray *name = @[];
    NSArray *image = @[];
    NSMutableArray *dataAll = [NSMutableArray array];
    
    for (NSInteger i = 0; i < name.count; i++) {
        HQRootModel *model = [[HQRootModel alloc] init];
        model.name = name[i];
        model.image = image[i];
        model.markNum = 0;
        model.OutDate = NO;
        model.backColor = NO;
        model.deleteShow = NO;
        
        model.functionModelType = (FunctionModelType)(FunctionModelTypeAll + i);
        
        [dataAll addObject:model];
    }
    
    
    HQBenchMainfaceModel *mainface = [[HQBenchMainfaceModel alloc] init];
    mainface.allItems = dataAll;
    mainface.employID = [HQHelper getCurrentLoginEmployee].id;
    mainface.nowItems = dataAll;
    [HQBenchMainfaceModel nowApprovalTypeArchiveWithModel:mainface];
    
    return mainface;
}



/** *******************************销售应用*************************** */
/** 归档 */
+ (void)sellArchiveWithModel:(HQBenchMainfaceModel *)model{
    
    if (!model) {
        return;
    }
    
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@sell.model", model.employID]];
    
    //2.将自定义的对象保存到文件中
    [NSKeyedArchiver archiveRootObject:model toFile:path];

}
/** 解档 */
+ (instancetype)sellUnarchiveWithEmployID:(NSNumber *)employID{
   
    if (!employID) {
        //        return nil;
        
        return [self setupSellData];
    }
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@sell.model", employID]];
    
    
    id model = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    
//    if (model) {
//        
//        return model;
//        
//    }else{
    
        return [self setupSellData];
//    }

}

+ (instancetype)setupSellData{
    
    NSArray *name = @[@"市场活动",@"客户",@"报价",@"订单",@"合同",@"回款",@"发票"];
    NSArray *image = @[@"市场活动",@"客户",@"报价",@"订单",@"合同",@"回款",@"发票"];
    NSMutableArray *dataAll = [NSMutableArray array];
    
    for (NSInteger i = 0; i < name.count; i++) {
        HQRootModel *model = [[HQRootModel alloc] init];
        model.name = name[i];
        model.image = image[i];
        model.markNum = 0;
        model.OutDate = NO;
        model.backColor = NO;
        model.deleteShow = NO;
        
        model.functionModelType = (FunctionModelType)(FunctionModelTypeSellStart + 1 + i);
        
        [dataAll addObject:model];
    }
    
    
    HQBenchMainfaceModel *mainface = [[HQBenchMainfaceModel alloc] init];
    mainface.allItems = dataAll;
    mainface.employID = [HQHelper getCurrentLoginEmployee].id;
    mainface.nowItems = dataAll;
    [HQBenchMainfaceModel sellArchiveWithModel:mainface];
    
    return mainface;
}



/** *******************************商品应用*************************** */
/** 归档 */
+ (void)goodsArchiveWithModel:(HQBenchMainfaceModel *)model{
    
    if (!model) {
        return;
    }
    
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@goods.model", model.employID]];
    
    //2.将自定义的对象保存到文件中
    [NSKeyedArchiver archiveRootObject:model toFile:path];
}

/** 解档 */
+ (instancetype)goodsUnarchiveWithEmployID:(NSNumber *)employID{
    
    if (!employID) {
        //        return nil;
        
        return [self setupGoodsData];
    }
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@goods.model", employID]];
    
    
    id model = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    
//    if (model) {
//        
//        return model;
//        
//    }else{
    
        return [self setupGoodsData];
//    }
}

+ (instancetype)setupGoodsData{
    
    NSArray *name = @[@"商品"];
    NSArray *image = @[@"商品"];
    NSMutableArray *dataAll = [NSMutableArray array];
    
    for (NSInteger i = 0; i < name.count; i++) {
        HQRootModel *model = [[HQRootModel alloc] init];
        model.name = name[i];
        model.image = image[i];
        model.markNum = 0;
        model.OutDate = NO;
        model.backColor = NO;
        model.deleteShow = NO;
        
        model.functionModelType = (FunctionModelType)(FunctionModelTypeGoods);
        
        [dataAll addObject:model];
    }
    
    
    HQBenchMainfaceModel *mainface = [[HQBenchMainfaceModel alloc] init];
    mainface.allItems = dataAll;
    mainface.employID = [HQHelper getCurrentLoginEmployee].id;
    mainface.nowItems = dataAll;
    [HQBenchMainfaceModel goodsArchiveWithModel:mainface];
    
    return mainface;
}


@end
