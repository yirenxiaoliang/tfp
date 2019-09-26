//
//  TFModuleModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/8.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFModuleModel.h"

@implementation TFModuleModel


-(id)copyWithZone:(NSZone *)zone{
    
    TFModuleModel *model = [TFModuleModel allocWithZone:zone];
    
    model.chinese_name = self.chinese_name;
    model.create_by = self.create_by;
    model.modify_time = self.modify_time;
    model.icon = self.icon;
    model.topper = self.topper;
    model.del_status = self.del_status;
    model.id = self.id;
    model.modify_by = self.modify_by;
    model.application_id = self.application_id;
    model.english_name = self.english_name;
    
    return model;
}


-(id)mutableCopyWithZone:(NSZone *)zone{
    
    TFModuleModel *model = [TFModuleModel allocWithZone:zone];
    
    model.chinese_name = self.chinese_name;
    model.create_by = self.create_by;
    model.modify_time = self.modify_time;
    model.icon = self.icon;
    model.topper = self.topper;
    model.del_status = self.del_status;
    model.id = self.id;
    model.modify_by = self.modify_by;
    model.application_id = self.application_id;
    model.english_name = self.english_name;
    
    return model;
}


@end
