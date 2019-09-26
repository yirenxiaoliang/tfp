//
//  HQTFCreatProjectModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFCreatProjectModel.h"

@implementation HQTFCreatProjectModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.employeeIds = [NSMutableArray array];
    }
    return self;
}


+ (HQTFCreatProjectModel *)changeProjectItemToCreatProjectModelWithProjectItem:(TFProjectItem *)projectItem{
    
    HQTFCreatProjectModel *model = [[HQTFCreatProjectModel alloc] init];
    model.id = projectItem.id;
    model.isPublic = projectItem.isPublic;
    model.projectName = projectItem.projectName;
    model.descript = projectItem.descript;
    model.categoryId = projectItem.categoryId;
    model.categoryName = projectItem.categoryName;
    model.endTime = projectItem.endTime;
    model.isMark = [projectItem.projectCollectId integerValue];
    model.projectStatus = projectItem.projectStatus;
    model.permission = projectItem.permission;
    model.isOverdue = projectItem.isOverdue;
    
    /** 项目状态: 0=进行中(进行中，超期);1=已完成;2=暂停;3=已删除 */
    if ([projectItem.projectStatus isEqualToNumber:@0]) {
        
        if (!projectItem.isOverdue) {
            
            if (projectItem.endTime) {
                
                if ([HQHelper getNowTimeSp] > [projectItem.endTime longLongValue]) {
                    model.isOverdue = @1;
                }else{
                    model.isOverdue = @0;
                }
            }else{
                model.isOverdue = @0;
            }
            
        }
        
    }
    
    return model;
}

@end
