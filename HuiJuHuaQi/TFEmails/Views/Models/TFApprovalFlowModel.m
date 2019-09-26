//
//  TFApprovalFlowModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFApprovalFlowModel.h"

@implementation TFApprovalFlowModel


/** task_status_id // -1已提交 0待审批 1审批中 2审批通过 3审批驳回 4已撤销 5已转交*/
-(NSNumber<Ignore> *)selfColor{
    
    NSNumber *selfC = nil;
    
    if ([self.task_status_id isEqualToString:@"-1"]) {
        selfC = @1;
    }else if ([self.task_status_id isEqualToString:@"0"]) {
        selfC = @3;
    }else if ([self.task_status_id isEqualToString:@"1"]) {
        selfC = @3;
    }else if ([self.task_status_id isEqualToString:@"2"]) {
        selfC = @1;
    }else if ([self.task_status_id isEqualToString:@"3"]) {
        selfC = @2;
    }else if ([self.task_status_id isEqualToString:@"4"]) {
        selfC = @0;
    }else if ([self.task_status_id isEqualToString:@"5"]) {
        selfC = @1;
    }else if ([self.task_status_id isEqualToString:@"5"]) {
        selfC = @3;
    }
    
    return selfC;
}


@end
