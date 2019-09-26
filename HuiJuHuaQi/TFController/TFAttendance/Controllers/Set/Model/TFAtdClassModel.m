//
//  TFAtdClassModel.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAtdClassModel.h"

/**
 "total_working_hours" : "0",
 "time1_start" : "09:00",
 "time1_end" : "12:00",
 "time1_start_limit" : 2,
 "time1_end_limit" : 2,
 "time1_end_status" : "0",
 "rest1_start" : "",
 "rest1_end" : "",
 "time2_start" : "14:00",
 "time2_end" : "18:00",
 "time2_start_limit" : 2,
 "time2_end_limit" : 7,
 "time2_end_status" : "0",
 "time3_start" : "",
 "time3_end" : "",
 "time3_start_limit" : 0,
 "time3_end_limit" : 0
 "time3_end_status" : "0",
 */

@implementation TFAtdClassModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                      @"class_desc":@"classDesc",
                                                      @"class_type":@"classType",
                                                      @"time1_start":@"time1Start",
                                                      @"time1_end":@"time1End",
                                                      @"time1_start_limit":@"time1StartLimit",
                                                      @"time1_end_limit":@"time1EndLimit",
                                                      @"time1_end_status":@"time1EndStatus",
                                                      @"rest1_start":@"rest1Start",
                                                      @"rest1_end":@"rest1End",
                                                      @"time2_start":@"time2Start",
                                                      @"time2_end":@"time2End",
                                                      @"time2_start_limit":@"time2StartLimit",
                                                      @"time2_end_limit":@"time2EndLimit",
                                                      @"time2_end_status":@"time2EndStatus",
                                                      @"time3_start":@"time3Start",
                                                      @"time3_end":@"time3End",
                                                      @"time3_start_limit":@"time3StartLimit",
                                                      @"time3_end_limit":@"time3EndLimit",
                                                      @"time3_end_status":@"time3EndStatus"
                                                      }];
}


-(instancetype)init{
    if (self = [super init]) {
        self.time1StartLimit = @"0";
        self.time1EndLimit = @"0";
        self.time1EndStatus = @"0";
        self.time2StartLimit = @"0";
        self.time2EndLimit = @"0";
        self.time2EndStatus = @"0";
        self.time3StartLimit = @"0";
        self.time3EndLimit = @"0";
        self.time3EndStatus = @"0";
        self.totalWorkingHours = @"0";
        self.effectiveDate = @0;
    }
    return self;
}

-(NSString<Optional> *)classDesc{
    
    if (!IsStrEmpty(_classDesc)) {
        return _classDesc;
    }
    NSString *str = @"";
    if (!IsStrEmpty(self.time1Start) && !IsStrEmpty(self.time1End)) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@-%@;",self.time1Start,self.time1End]];
    }
    if (!IsStrEmpty(self.time2Start) && !IsStrEmpty(self.time2End)) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@-%@;",self.time2Start,self.time2End]];
    }
    if (!IsStrEmpty(self.time3Start) && !IsStrEmpty(self.time3End)) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@-%@;",self.time3Start,self.time3End]];
    }
    
    if (str.length > 0) {
        str = [str substringToIndex:str.length-1];
    }
    
    return str;
}




@end
