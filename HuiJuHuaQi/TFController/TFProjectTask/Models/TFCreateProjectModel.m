//
//  TFCreateProjectModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCreateProjectModel.h"

@implementation TFCreateProjectModel


-(instancetype)init{
    if (self = [super init]) {
        self.projectModel = [[TFProjectClassModel alloc] init];
    }
    return self;
}

-(NSMutableDictionary *)dict{
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    // 项目id
    if (self.projectId) {
        [data setObject:self.projectId forKey:@"id"];
    }
    // 项目名称
    [data setObject:TEXT(self.title) forKey:@"name"];
    // 负责人
    if (self.responsible) {
        [data setObject:self.responsible.id forKey:@"leader"];
    }
    // 开始时间
    if (self.startTime) {
        [data setObject:self.startTime forKey:@"startTime"];
    }
    // 截止时间
    if (self.endTime) {
        [data setObject:self.endTime forKey:@"endTime"];
    }
    // 可见范围
    [data setObject:@(self.visible) forKey:@"visualRange"];
    // 描述
    [data setObject:TEXT(self.descript) forKey:@"note"];
    // 模板
    if (self.projectModel) {
        [data setObject:self.projectModel.templateId forKey:@"tempId"];
    }
    // 项目进度类型
    if (self.project_progress_status) {
        [data setObject:self.project_progress_status forKey:@"progressStatus"];
    }
    // 手动项目进度
    if (self.project_progress_content) {
        [data setObject:self.project_progress_content forKey:@"progressContent"];
    }
    return data;
    
}


@end
