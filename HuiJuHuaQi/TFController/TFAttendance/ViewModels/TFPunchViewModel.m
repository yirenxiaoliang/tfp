//
//  TFPunchViewModel.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/5.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPunchViewModel.h"
#import "TFRequest.h"
#import "TFPutchRecordModel.h"
#import "TFPluginModel.h"

@interface TFPunchViewModel ()

@property (nonatomic, assign) long long attendanceDate;

@property (nonatomic, strong) TFRequest *request;

@end


@implementation TFPunchViewModel


-(TFRequest *)request{
    if (!_request) {
        _request = [TFRequest sharedManager];
    }
    return _request;
}

/** 开启插件 */
- (RACCommand *)pluginCommand {
    
    if (!_pluginCommand) {
        
        @weakify(self);
        _pluginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *dict) {
            
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                @strongify(self);
                HQLog(@"请求URL:%@==参数:%@",URL(@"/attendanceSetting/openOrClose"),dict);
                [self.request requestPOST:URL(@"/attendanceSetting/openOrClose")
                                     body:dict
                                progress:nil
                                 success:^(NSDictionary *response) {
                                     HQLog(@"请求URL:%@===Success:%@",URL(@"/attendanceSetting/openOrClose"),[HQHelper dictionaryToJson:response]);
                                     
                                     [subscriber sendNext:response];
                                     [subscriber sendCompleted];
                                 }
                                 failure:^(NSError *error) {
                                     HQLog(@"请求URL:%@===Error:%@",URL(@"/attendanceSetting/openOrClose"),error);
                                     [subscriber sendError:error];
                                 }];
                return nil;
            }];
        }];
    }
    
    return _pluginCommand;
}

/** 插件列表 */
- (RACCommand *)quickCommand {
    
    if (!_quickCommand) {
        
        @weakify(self);
        _quickCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *dict) {
            
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                @strongify(self);
                HQLog(@"请求URL:%@==参数:%@",URL(@"/attendanceSetting/findPluginList"),dict);
                [self.request requestGET:URL(@"/attendanceSetting/findPluginList")
                              parameters:dict
                                progress:nil
                                 success:^(NSDictionary *response) {
                                     HQLog(@"请求URL:%@===Success:%@",URL(@"/attendanceSetting/findPluginList"),[HQHelper dictionaryToJson:response]);
                                     NSDictionary *ddd = response[kData];
                                     NSArray *arr = [ddd valueForKey:@"dataList"];
                                     // 数据处理
                                     NSMutableArray *models = [NSMutableArray array];
                                     for (NSDictionary *dict in arr) {
                                         TFPluginModel *model = [[TFPluginModel alloc] initWithDictionary:dict error:nil];
                                         if (model) {
                                             [models addObject:model];
                                         }
                                     }
                                     [subscriber sendNext:models];
                                     [subscriber sendCompleted];
                                 }
                                 failure:^(NSError *error) {
                                     HQLog(@"请求URL:%@===Error:%@",URL(@"/attendanceSetting/findPluginList"),error);
                                     [subscriber sendError:error];
                                 }];
                return nil;
            }];
        }];
    }
    
    return _quickCommand;
}


/** 数据初始化 */
- (RACCommand *)dataCommand {
    
    if (!_dataCommand) {
        
        @weakify(self);
        _dataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (input) {
                self.attendanceDate = [input longLongValue];
                [dict setObject:input forKey:@"attendanceDate"];
            }
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                @strongify(self);
                HQLog(@"请求URL:%@==参数:%@",URL(@"/attendanceClock/findUserAttendanceGroup"),dict);
                [self.request requestGET:URL(@"/attendanceClock/findUserAttendanceGroup")
                              parameters:dict
                                progress:nil
                                 success:^(NSDictionary *response) {
                                     HQLog(@"请求URL:%@===Success:%@",URL(@"/attendanceClock/findUserAttendanceGroup"),[HQHelper dictionaryToJson:response]);
                                     NSDictionary *ddd = response[kData];
                                     NSError *ee;
                                     TFPutchCardModel *model = [[TFPutchCardModel alloc] initWithDictionary:ddd error:&ee];
                                     if (ee) {
                                         HQLog(@"error:%@",ee);
                                     }
                                     self.cardModel = model;
                                     [self handData];
                                     [subscriber sendNext:response];
                                     [subscriber sendCompleted];
                                 }
                                 failure:^(NSError *error) {
                                     HQLog(@"请求URL:%@===Error:%@",URL(@"/attendanceClock/findUserAttendanceGroup"),error);
                                     [subscriber sendError:error];
                                 }];
                return nil;
            }];
        }];
    }
    
    return _dataCommand;
}

/** 打卡初始化 */
- (RACCommand *)punchCommand {
    
    if (!_punchCommand) {
        
        @weakify(self);
        _punchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *input) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:input];
            
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                @strongify(self);
                HQLog(@"请求URL:%@==参数:%@",URL(@"/attendanceClock/punchClock"),dict);
                [self.request requestPOST:URL(@"/attendanceClock/punchClock")
                                     body:dict
                                 progress:^(NSProgress *progress) {
                                     
                                 }
                                  success:^(NSDictionary *response) {
                                      HQLog(@"请求URL:%@===Success:%@",URL(@"/attendanceClock/punchClock"),[HQHelper dictionaryToJson:response]);
                                      [subscriber sendNext:response];
                                      [subscriber sendCompleted];
                                      
                                  } failure:^(NSError *error) {
                                      HQLog(@"请求URL:%@===Error:%@",URL(@"/attendanceClock/punchClock"),error);
                                      [subscriber sendError:error];
                                      
                                  }];
                return nil;
            }];
        }];
    }
    
    return _punchCommand;
}

/** 请求完处理数据 */
-(void)handData{
    TFPutchCardModel *model = self.cardModel;
    // 没有考勤组信息
    // 现在无考勤信息可能是没有设置考勤规则，或者是休息日，应休息日要返回考勤休息规则
    if (!model.id) {// 没有考勤信息
        self.cardModel.record_list = @[].mutableCopy;
        self.currentRecord = [[TFPutchRecordModel alloc] init];
        self.currentRecord.id = @(-1);// -1说明没有考勤规则
        self.currentRecord.freedom = @"1";
        self.currentRecord.isPunch = @"0";
        
        NSMutableArray<TFPutchRecordModel,Optional> *recordList = [NSMutableArray<TFPutchRecordModel,Optional> array];
        for (TFPutchRecordModel *mm in model.clock_record_list) {
            mm.freedom = @"1";
            mm.finish = @"1";
            [recordList addObject:mm];
        }
        self.cardModel.record_list = recordList;
        
        if (model.clock_record_list.count % 2 == 0) {// 偶数上班
            self.currentRecord.punchcard_type = @"1";
        }else{
            self.currentRecord.punchcard_type = @"2";
        }
        
        if (self.location) {
            NSString *str = [NSString stringWithFormat:@"%@%@%@%@",TEXT(self.location.province),TEXT(self.location.city),TEXT(self.location.district),TEXT(self.location.address)];
            self.currentRecord.punchcard_address = IsStrEmpty(str)?self.location.totalAddress:str;
            self.currentRecord.punchcard_name = IsStrEmpty(str)?self.location.totalAddress:str;
            self.currentRecord.is_way = @"0";
            self. currentRecord.isPunch = @"1";
        }else {
            NSDictionary *wifiDict = [HQHelper getCurrentWiFiInfo];
            if (wifiDict) {
//                NSString *mac = [wifiDict valueForKey:@"MacAddress"];
                NSString *name = [wifiDict valueForKey:@"WiFiName"];
                self.currentRecord.punchcard_address = name;
                self.currentRecord.punchcard_name = name;
                self.currentRecord.is_way = @"1";
                self.currentRecord.isPunch = @"2";
            }
        }
        return;
        
    }
    else if ([model.class_info.id isEqualToNumber:@0]){// 有规则，但是没考勤组信息，说明今日休息
        
        self.cardModel.record_list = @[].mutableCopy;
        self.currentRecord = [[TFPutchRecordModel alloc] init];
        self.currentRecord.id = @(0);// 0说明休息
        self.currentRecord.freedom = @"1";
        self.currentRecord.isPunch = @"0";
        
        NSMutableArray<TFPutchRecordModel,Optional> *recordList = [NSMutableArray<TFPutchRecordModel,Optional> array];
        for (TFPutchRecordModel *mm in model.clock_record_list) {
            mm.freedom = @"1";
            mm.finish = @"1";
            [recordList addObject:mm];
        }
        self.cardModel.record_list = recordList;
        
        if (model.clock_record_list.count % 2 == 0) {// 偶数上班
            self.currentRecord.punchcard_type = @"1";
        }else{
            self.currentRecord.punchcard_type = @"2";
        }
        
        // 进入打卡地址
        // 怎么计算两个经纬度点之间的距离
        for (TFAtdWatDataListModel *address in model.attendance_address) {
            if (address.location.count && self.location) {// 有地址才可比较
                TFAtdLocationModel *loca = address.location.firstObject;
                double x1 = [loca.lat doubleValue];
                double y1 = [loca.lng doubleValue];
                double x2 = self.location.latitude;
                double y2 = self.location.longitude;
                double range = getDistance(x1, y1, x2, y2);
                if ([address.effective_range doubleValue] > range) {
                    self.currentRecord.punchcard_address = address.address;
                    self.currentRecord.punchcard_name = address.name;
                    self.currentRecord.is_way = @"0";
                   self. currentRecord.isPunch = @"1";
                }
            }
        }
        // 进入WiFi范围
        if (!self.currentRecord.punchcard_address) {// 无考勤地址，才判定WiFi
            for (TFAtdWatDataListModel *wifi in self.cardModel.attendance_wifi) {
                NSDictionary *wifiDict = [HQHelper getCurrentWiFiInfo];
                if (wifiDict) {
                    NSString *mac = [wifiDict valueForKey:@"MacAddress"];
                    if ([[mac lowercaseString] isEqualToString:[wifi.address lowercaseString]]) {
                        self.currentRecord.punchcard_address = wifi.name;
                        self.currentRecord.punchcard_name = wifi.name;
                        self.currentRecord.is_way = @"1";
                        self.currentRecord.isPunch = @"2";
                    }
                }
            }
        }
        
        // 考勤地址及WiFi都没有，再看能不能外勤打卡
        if (IsStrEmpty(self.currentRecord.punchcard_address)) {
            if ([model.outworker_status isEqualToString:@"1"]) {// 可以外勤打卡
                self.currentRecord.isPunch = @"3";// 可以外勤打卡
                self.currentRecord.punchcard_address = self.location.totalAddress;
            }
        }
        
        return;
    }
    
    /** 构造考勤记录列表 */
    NSInteger type = [model.attendance_type integerValue];
    if ((type == 0 || type == 1) && model.class_info.id) {// 固定班次、排班制需构造列表，且有排班
        TFAtdClassModel *clas = model.class_info;
        NSMutableArray<TFPutchRecordModel,Optional> *recordList = [NSMutableArray<TFPutchRecordModel,Optional> array];
        if ([clas.classType isEqualToString:@"1"]) {// 一次上下班
            
            for (NSInteger i = 0; i < 2; i++) {
                TFPutchRecordModel *record = [[TFPutchRecordModel alloc] init];
                record.recordIndex = [NSString stringWithFormat:@"%ld",i + 1];
                if (i == 0) {
                    record.punchcard_type = @"1";// 上班
                    record.expect_punchcard_time = clas.time1Start;
                    record.punchcard_status = @"0";
                    record.punchcard_key = @"time1_start";
                    record.timeLimit = clas.time1StartLimit;
                }else{
                    record.punchcard_type = @"2";// 下班
                    record.expect_punchcard_time = clas.time1End;
                    record.punchcard_status = @"0";
                    record.punchcard_key = @"time1_end";
                    record.timeLimit = clas.time1EndLimit;
                }
                
                [recordList addObject:record];
            }
            
        }
        else if ([clas.classType isEqualToString:@"2"]){// 二次上下班
            
            for (NSInteger i = 0; i < 4; i++) {
                TFPutchRecordModel *record = [[TFPutchRecordModel alloc] init];
                record.recordIndex = [NSString stringWithFormat:@"%ld",i + 1];
                if (i == 0) {
                    record.punchcard_type = @"1";// 上班
                    record.expect_punchcard_time = clas.time1Start;
                    record.punchcard_status = @"0";
                    record.punchcard_key = @"time1_start";
                    record.timeLimit = clas.time1StartLimit;
                }else if (i == 1) {
                    record.punchcard_type = @"2";// 下班
                    record.expect_punchcard_time = clas.time1End;
                    record.punchcard_status = @"0";
                    record.punchcard_key = @"time1_end";
                    record.timeLimit = clas.time1EndLimit;
                }else if (i == 2) {
                    record.punchcard_type = @"1";// 上班
                    record.expect_punchcard_time = clas.time2Start;
                    record.punchcard_status = @"0";
                    record.punchcard_key = @"time2_start";
                    record.timeLimit = clas.time2StartLimit;
                }else{
                    record.punchcard_type = @"2";// 下班
                    record.expect_punchcard_time = clas.time2End;
                    record.punchcard_status = @"0";
                    record.punchcard_key = @"time2_end";
                    record.timeLimit = clas.time2EndLimit;
                }
                [recordList addObject:record];
            }
        }
        else if ([clas.classType isEqualToString:@"3"]){// 三次上下班
            
            for (NSInteger i = 0; i < 6; i++) {
                TFPutchRecordModel *record = [[TFPutchRecordModel alloc] init];
                record.recordIndex = [NSString stringWithFormat:@"%ld",i + 1];
                if (i == 0) {
                    record.punchcard_type = @"1";// 上班
                    record.expect_punchcard_time = clas.time1Start;
                    record.punchcard_status = @"0";
                    record.punchcard_key = @"time1_start";
                    record.timeLimit = clas.time1StartLimit;
                }else if (i == 1) {
                    record.punchcard_type = @"2";// 下班
                    record.expect_punchcard_time = clas.time1End;
                    record.punchcard_status = @"0";
                    record.punchcard_key = @"time1_end";
                    record.timeLimit = clas.time1EndLimit;
                }else if (i == 2) {
                    record.punchcard_type = @"1";// 上班
                    record.expect_punchcard_time = clas.time2Start;
                    record.punchcard_status = @"0";
                    record.punchcard_key = @"time2_start";
                    record.timeLimit = clas.time2StartLimit;
                }else if (i == 3) {
                    record.punchcard_type = @"2";// 下班
                    record.expect_punchcard_time = clas.time2End;
                    record.punchcard_status = @"0";
                    record.punchcard_key = @"time2_end";
                    record.timeLimit = clas.time2EndLimit;
                }else if (i == 4) {
                    record.punchcard_type = @"1";// 上班
                    record.expect_punchcard_time = clas.time3Start;
                    record.punchcard_status = @"0";
                    record.punchcard_key = @"time3_start";
                    record.timeLimit = clas.time3StartLimit;
                }else{
                    record.punchcard_type = @"2";// 下班
                    record.expect_punchcard_time = clas.time3End;
                    record.punchcard_status = @"0";
                    record.punchcard_key = @"time3_end";
                    record.timeLimit = clas.time3EndLimit;
                }
                [recordList addObject:record];
            }
        }
        self.cardModel.record_list = recordList;
        
    }
    else{// 自由班次，或无排班
        
        
        NSMutableArray<TFPutchRecordModel,Optional> *recordList = [NSMutableArray<TFPutchRecordModel,Optional> array];
        for (TFPutchRecordModel *mm in model.clock_record_list) {
            mm.freedom = @"1";
            mm.finish = @"1";
            [recordList addObject:mm];
        }
        self.cardModel.record_list = recordList;
        
        TFPutchRecordModel *currentRecord = [[TFPutchRecordModel alloc] init];
        currentRecord.freedom = @"1";
        currentRecord.isPunch = @"0";
        if (model.clock_record_list.count % 2 == 0) {// 偶数上班
            currentRecord.punchcard_type = @"1";
        }else{
            currentRecord.punchcard_type = @"2";
        }
        // 进入打卡地址
        // 怎么计算两个经纬度点之间的距离
        for (TFAtdWatDataListModel *address in model.attendance_address) {
            if (address.location.count && self.location) {// 有地址才可比较
                TFAtdLocationModel *loca = address.location.firstObject;
                double x1 = [loca.lat doubleValue];
                double y1 = [loca.lng doubleValue];
                double x2 = self.location.latitude;
                double y2 = self.location.longitude;
                double range = getDistance(x1, y1, x2, y2);
                if ([address.effective_range doubleValue] > range) {
                    currentRecord.punchcard_address = address.address;
                    currentRecord.punchcard_name = address.name;
                    currentRecord.is_way = @"0";
                    currentRecord.isPunch = @"1";
                }
            }
        }
        // 进入WiFi范围
        if (!currentRecord.punchcard_address) {// 无考勤地址，才判定WiFi
            for (TFAtdWatDataListModel *wifi in self.cardModel.attendance_wifi) {
                NSDictionary *wifiDict = [HQHelper getCurrentWiFiInfo];
                if (wifiDict) {
                    NSString *mac = [wifiDict valueForKey:@"MacAddress"];
                    if ([[mac lowercaseString] isEqualToString:[wifi.address lowercaseString]]) {
                        currentRecord.punchcard_address = wifi.name;
                        currentRecord.punchcard_name = wifi.name;
                        currentRecord.is_way = @"1";
                        currentRecord.isPunch = @"2";
                    }
                }
            }
        }
        
        // 考勤地址及WiFi都没有，再看能不能外勤打卡
        if (IsStrEmpty(currentRecord.punchcard_address)) {
            if ([model.outworker_status isEqualToString:@"1"]) {// 可以外勤打卡
                currentRecord.isPunch = @"3";// 可以外勤打卡
                currentRecord.punchcard_address = self.location.totalAddress;
            }
        }
        
        self.currentRecord = currentRecord;
        
    }
    
    // 将打卡真实记录放入构造的打卡的列表里面
    if ((type == 0 || type == 1) && model.class_info.id) {// 固定班次、排班制需构造列表
        TFPutchRecordModel *lastFinish = nil;
        for (NSInteger i = 0; i < model.clock_record_list.count; i++) {
            TFPutchRecordModel *rr = model.clock_record_list[i];
            if (i < self.cardModel.record_list.count) {
                TFPutchRecordModel *reRR = self.cardModel.record_list[i];
                reRR.id = rr.id;
                reRR.real_punchcard_time = rr.real_punchcard_time;
                reRR.punchcard_result = rr.punchcard_result;
                reRR.punchcard_status = rr.punchcard_status;
                reRR.is_way = rr.is_way;
                reRR.is_outworker = rr.is_outworker;
                reRR.punchcard_address = rr.punchcard_address;
                reRR.punchcard_type = rr.punchcard_type;
                reRR.finish = @"1";
                reRR.data_id = rr.data_id;
                reRR.bean_name = rr.bean_name;
                reRR.module_id = rr.module_id;
                reRR.remark = rr.remark;
                reRR.photo = rr.photo;
                if ([reRR.punchcard_type isEqualToString:@"2"]) {// 下班可更新打卡
                    
                    if ([[HQHelper nsdateToTime:self.attendanceDate formatStr:@"yyyy-MM-dd"] isEqualToString:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"]]) {// 今天
                        lastFinish = reRR;
                    }
                }
            }
        }
        lastFinish.change = @"1";// 修改最后一个下班打卡的更新（多班次时可能不在末尾）
        
        // 今日
        // 现在打什么卡？
        TFPutchRecordModel *currentRecord = nil;
        for (TFPutchRecordModel *mo in self.cardModel.record_list) {
            if ([mo.punchcard_status isEqualToString:@"0"]) {// 未打卡状态
                currentRecord = [[TFPutchRecordModel alloc] init];
                currentRecord.isPunch = @"0";
                currentRecord.id = mo.id;
                currentRecord.expect_punchcard_time = mo.expect_punchcard_time;
                currentRecord.real_punchcard_time = mo.real_punchcard_time;
                currentRecord.punchcard_type = mo.punchcard_type;
                currentRecord.punchcard_key = mo.punchcard_key;
                currentRecord.punchcard_result = mo.punchcard_result;
                currentRecord.punchcard_status = mo.punchcard_status;
                currentRecord.punchcard_address = mo.punchcard_address;
                currentRecord.punchcard_name = mo.punchcard_name;
                currentRecord.is_outworker = mo.is_outworker;
                currentRecord.is_way = mo.is_way;
                currentRecord.recordIndex = mo.recordIndex;
                currentRecord.finish = mo.finish;
                currentRecord.timeLimit = mo.timeLimit;
                currentRecord.remark = mo.remark;
                currentRecord.photo = mo.photo;
                break;
            }
        }
        self.currentRecord = currentRecord;
        // 最后一个已打卡下班后下个上班不能打卡才行
        if ([currentRecord.recordIndex integerValue] - [lastFinish.recordIndex integerValue] > 1) {
            lastFinish.change = @"0";
        }
        
        
//        // 能不能打卡：若当前未打卡的节点超出限制，那么当前节点不能打卡，进行下节点尝试打卡
//        NSString *limit = currentRecord.timeLimit;
//        if ([currentRecord.punchcard_type isEqualToString:@"1"]) {// 上班
//            if (IsStrEmpty(limit)) {// 不限制
//                //   .... < time < 下班
//
//            }else{
//                //  限制 < time < 下班
//
//            }
//        } else if ([currentRecord.punchcard_type isEqualToString:@"2"]) {// 下班
//            if (IsStrEmpty(limit)) {// 不限制
//                //   上班 < time < ...
//
//            }else{
//                //   上班 < time < 限制
//
//            }
//        }
        
        if (currentRecord) {// 存在
            // 进入打卡地址
            // 怎么计算两个经纬度点之间的距离
            for (TFAtdWatDataListModel *address in model.attendance_address) {
                if (address.location.count && self.location) {// 有地址才可比较
                    TFAtdLocationModel *loca = address.location.firstObject;
                    double x1 = [loca.lat doubleValue];
                    double y1 = [loca.lng doubleValue];
                    double x2 = self.location.latitude;
                    double y2 = self.location.longitude;
                    double range = getDistance(x1, y1, x2, y2);
                    if ([address.effective_range doubleValue] > range) {
                        currentRecord.punchcard_address = address.address;
                        currentRecord.punchcard_name = address.name;
                        currentRecord.is_way = @"0";
                        currentRecord.isPunch = @"1";
                    }
                }
            }
            // 进入WiFi范围
            if (!currentRecord.punchcard_address) {// 无考勤地址，才判定WiFi
                for (TFAtdWatDataListModel *wifi in self.cardModel.attendance_wifi) {
                    NSDictionary *wifiDict = [HQHelper getCurrentWiFiInfo];
                    if (wifiDict) {
                        NSString *mac = [wifiDict valueForKey:@"MacAddress"];
                        if ([[mac lowercaseString] isEqualToString:[wifi.address lowercaseString]]) {
                            currentRecord.punchcard_address = wifi.name;
                            currentRecord.punchcard_name = wifi.name;
                            currentRecord.is_way = @"1";
                            currentRecord.isPunch = @"2";
                        }
                    }
                }
            }
            
            // 考勤地址及WiFi都没有，再看能不能外勤打卡
            if (IsStrEmpty(currentRecord.punchcard_address)) {
                if ([model.outworker_status isEqualToString:@"1"]) {// 可以外勤打卡
                    if (self.location && !IsStrEmpty(self.location.totalAddress)) {
                        currentRecord.isPunch = @"3";// 可以外勤打卡
                        currentRecord.punchcard_address = self.location.totalAddress;
                    }
                }
            }
            
            // 能打卡会是什么状态
            long long now = [HQHelper getNowTimeSp];
            // 获取年月日str
            NSString *yearStr = [HQHelper nsdateToTime:now formatStr:@"yyyy-MM-dd"];
            // 开始打卡时间str
            NSString *startStr = [NSString stringWithFormat:@"%@ %@",yearStr,currentRecord.expect_punchcard_time];
            /** 获取期望打卡时间 */
            long long start = [HQHelper changeTimeToTimeSp:startStr formatStr:@"yyyy-MM-dd HH:mm"];
            
            /** 打卡状态，0:未打卡,1:正常,2:迟到,3:早退,4:旷工,5:缺卡 */
            if ([currentRecord.punchcard_type isEqualToString:@"1"]) {// 上班
                if (now < start) {// 正常
                    currentRecord.punchcard_status = @"1";
                }else{// 迟到
                    currentRecord.punchcard_status = @"2";
                }
            }
            if ([currentRecord.punchcard_type isEqualToString:@"2"]) {// 上班
                if (now > start) {// 正常
                    currentRecord.punchcard_status = @"1";
                }else{// 早退
                    currentRecord.punchcard_status = @"3";
                }
            }
        }
       
        NSInteger have = 0;
        for (TFPutchRecordModel *re in self.cardModel.record_list) {
            if (![re.punchcard_status isEqualToString:@"1"]) {
                have = 1;
                break;
            }
        }
        self.tatol_status = have;
    }
    
    
}

-(void)setLocation:(TFLocationModel *)location{
    _location = location;
    if (self.cardModel) {
        [self handData];
        // 再将信号传出去
        self.refreshSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [subscriber sendNext:@"refresh"];
            
            return [RACDisposable disposableWithBlock:^{
            }];
        }];
    }
}

/** 判断打卡位置正常？ */
-(BOOL)judgeLocationIsTure{
    
    BOOL isTure = NO;// 用来记录是否满足条件
    // 进入打卡地址
    // 怎么计算两个经纬度点之间的距离
    for (TFAtdWatDataListModel *address in self.cardModel.attendance_address) {
        if (address.location.count && self.location) {// 有地址才可比较
            TFAtdLocationModel *loca = address.location.firstObject;
            double x1 = [loca.lat doubleValue];
            double y1 = [loca.lng doubleValue];
            double x2 = self.location.latitude;
            double y2 = self.location.longitude;
            double range = getDistance(x1, y1, x2, y2);
            if ([address.effective_range doubleValue] > range) {
                self.currentRecord.punchcard_address = address.address;
                self.currentRecord.punchcard_name = address.name;
                self.currentRecord.is_way = @"0";
                self.currentRecord.isPunch = @"1";
                isTure = YES;
            }
        }
    }
    // 进入WiFi范围
    if (!self.currentRecord.punchcard_address) {// 无考勤地址，才判定WiFi
        for (TFAtdWatDataListModel *wifi in self.cardModel.attendance_wifi) {
            NSDictionary *wifiDict = [HQHelper getCurrentWiFiInfo];
            if (wifiDict) {
                NSString *mac = [wifiDict valueForKey:@"MacAddress"];
                if ([[mac lowercaseString] isEqualToString:[wifi.address lowercaseString]]) {
                    self.currentRecord.punchcard_address = wifi.name;
                    self.currentRecord.punchcard_name = wifi.name;
                    self.currentRecord.is_way = @"1";
                    self.currentRecord.isPunch = @"2";
                    isTure = YES;
                }
            }
        }
    }
    
    // 考勤地址及WiFi都没有，再看能不能外勤打卡
    if (IsStrEmpty(self.currentRecord.punchcard_address)) {
        if ([self.cardModel.outworker_status isEqualToString:@"1"]) {// 可以外勤打卡
            if (self.location && !IsStrEmpty(self.location.totalAddress)) {
                self.currentRecord.isPunch = @"3";// 可以外勤打卡
                self.currentRecord.punchcard_address = self.location.totalAddress;
                isTure = YES;
            }
        }
    }
    return isTure;
}


double rad(double d){
    return d * M_PI / 180.0;
}
double getDistance(double lat1, double lng1, double lat2,
                   double lng2) {
    double R = 6378.137;
    double radLat1 = rad(lat1);
    double radLat2 = rad(lat2);
    double a = radLat1 - radLat2;
    double b = rad(lng1) - rad(lng2);
    double s = 2 * asin(sqrt(pow(sin(a / 2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(b / 2), 2)));
    s = s * R;
    s = round(s * 10000.0) / 10000.0;
    s = s * 1000.0;
    return s;
}


@end
