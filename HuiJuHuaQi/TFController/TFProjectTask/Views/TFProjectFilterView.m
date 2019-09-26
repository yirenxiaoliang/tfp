
//
//  TFProjectFilterView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectFilterView.h"
#import "HQTFSearchHeader.h"
#import "HQSelectTimeCell.h"
#import "TFFilterHeaderView.h"
#import "TFFilterModel.h"
#import "HQTFTwoLineCell.h"
#import "HQTFInputCell.h"
#import "TFMaxMinValueCell.h"
#import "HQAddressView.h"
#import "HQAreaManager.h"
#import "HQSelectTimeView.h"
#import "TFTwoBtnsView.h"
#import "TFChangeHelper.h"

#define MarginWidth 55


@interface TFProjectFilterView ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,TFFilterHeaderViewDelegate,TFMaxMinValueCellDelegate,HQTFInputCellDelegate,TFTwoBtnsViewDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** headerSearch */
@property (nonatomic, weak) HQTFSearchHeader *headerSearch;

/** HQAddressView */
@property (nonatomic, strong) HQAddressView *addressView;

/** customs */
@property (nonatomic, strong) NSMutableArray *customs;
/** roles */
@property (nonatomic, strong) NSMutableArray *roles;

/** times */
@property (nonatomic, strong) NSMutableArray *times;
/** items */
@property (nonatomic, strong) NSMutableArray *items;

/** sections */
@property (nonatomic, strong) NSMutableArray *sections;

/** HQAreaManager */
@property (nonatomic, strong) HQAreaManager *areaManager;

/** customOpen */
@property (nonatomic, assign) BOOL customOpen;


@end


@implementation TFProjectFilterView

-(HQAreaManager *)areaManager{
    if (!_areaManager) {
        _areaManager = [HQAreaManager defaultAreaManager];
    }
    return _areaManager;
}

-(HQAddressView *)addressView{
    if (!_addressView) {
        _addressView = [[HQAddressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    
    return _addressView;
}

-(NSMutableArray *)sections{
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

//-(NSMutableArray *)customs{
//
//    if (!_customs) {
//        _customs = [NSMutableArray array];
//        TFFilterModel *model = [[TFFilterModel alloc] init];
//        NSArray *names = @[@"创建时间",@"修改时间",@"模块分类",@"升序 ↑",@"降序 ↓"];
//        NSArray *values = @[@"create_time",@"modify_time",@"moduleType",@"asc",@"desc"];
//        NSMutableArray *arr = [NSMutableArray array];
//        for (NSInteger k = 0; k < names.count; k ++) {
//            TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
//            item.label = names[k];
//            item.value = values[k];
//            item.type = @0;
//            if (k == 0 || k == 3) {
//                item.selectState = @1;
//            }
//            [arr addObject:item];
//        }
//        model.name = @"自定义排序";
//        model.entrys = arr;
//        [_customs addObject:model];
//    }
//    return _customs;
//}

-(NSMutableArray *)customs{
    
    if (!_customs) {
        _customs = [NSMutableArray array];
        TFFilterModel *model = [[TFFilterModel alloc] init];
        NSArray *names = @[@"创建时间升序 ↑",@"创建时间降序 ↓",@"修改时间升序 ↑",@"修改时间降序 ↓"];
        NSArray *values = @[@"create_time:asc",@"create_time:desc",@"modify_time:asc",@"modify_time:desc"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger k = 0; k < names.count; k ++) {
            TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
            item.label = names[k];
            item.value = values[k];
            item.type = @0;
            [arr addObject:item];
        }
        model.name = @"自定义排序";
        model.entrys = arr;
        model.id = @"sortField";
        [_customs addObject:model];
    }
    return _customs;
}

-(NSMutableArray *)roles{
    
    if (!_roles) {
        _roles = [NSMutableArray array];
        TFFilterModel *model = [[TFFilterModel alloc] init];
        NSMutableArray *arr = [NSMutableArray array];
        NSArray *names = @[@"我负责的",@"我创建的",@"我参与的"];
        for (NSInteger k = 0; k < names.count; k ++) {
            TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
            item.label = names[k];
            item.type = @0;
            item.selectState = @0;
            item.value = [NSString stringWithFormat:@"%ld",(long)k];
            [arr addObject:item];
        }
        model.name = @"视图";
        model.id = @"queryType";
        model.entrys = arr;
        [_roles addObject:model];
        
    }
    return _roles;
}

-(NSMutableArray *)times{
    
    if (!_times) {
        _times = [NSMutableArray array];
        
        TFFilterModel *model = [[TFFilterModel alloc] init];
        NSMutableArray *arr = [NSMutableArray array];
        NSArray *names = @[@"超期未完成的",@"今日任务",@"明日任务",@"计划任务",@"已完成"];
        for (NSInteger k = 0; k < names.count; k ++) {
            TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
            item.label = names[k];
            item.type = @0;
            item.selectState = @0;
            item.value = [NSString stringWithFormat:@"%ld",k];
            [arr addObject:item];
        }
        model.open = @1;
        model.id = @"dateFormat";
        model.name = @"time";
        model.modelName = @"task";
        model.modelLabel = @"任务";
        model.type = @"picklist";
        model.entrys = arr;
        [_times addObject:model];
        
    }
    return _times;
}

-(void)setConditions:(NSMutableArray *)conditions{
    _conditions = conditions;
    
    [self.sections removeAllObjects];
    
    if (self.type == 1) {
        
        [self.sections addObject:[self taskWithCondition:conditions bean:@"project_custom" beanName:@"任务"]];
        
        NSMutableArray *items = [NSMutableArray array];
        for (NSArray *arr in self.sections) {
            [items addObjectsFromArray:arr];
        }
        self.items = items;
        
        [self.tableView reloadData];
        
        return;
    }
    
    for (NSDictionary *dict in conditions) {
        
        NSString *bean = [dict valueForKey:@"bean"];
        NSString *beanName = [dict valueForKey:@"beanName"];
        NSArray *cons = [dict valueForKey:@"condition"];
//        if (cons.count == 0) {
//            continue;
//        }
        
        if ([bean containsString:@"project_custom"]) {// 任务
            
            [self.sections addObject:[self taskWithCondition:cons bean:bean beanName:@"任务"]];
            
        }else if ([bean containsString:@"memo"]) {// 备忘录
            
            [self.sections addObject:[self memoWithCondition:cons]];
            
        }else if ([bean containsString:@"approval"]) {// 审批
            
            [self.sections addObject:[self approvalWithCondition:cons]];
            
        }else if ([bean containsString:@"bean"]) {// 自定义
            
            [self.sections addObject:[self customWithCondition:cons bean:bean beanName:beanName]];
        }
    }
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSArray *arr in self.sections) {
        [items addObjectsFromArray:arr];
    }
    self.items = items;
    
    [self.tableView reloadData];
    
}

/** 构造备忘录筛选项 */
- (NSArray *)memoWithCondition:(NSArray *)condition{
    NSMutableArray *items = [NSMutableArray array];
    
    for (NSDictionary *dict  in condition) {
        NSString *field = [dict valueForKey:@"field"];
        NSString *label = [dict valueForKey:@"label"];
        NSArray *member = [dict valueForKey:@"member"];
        
        if ([field isEqualToString:@"content"] || [field isEqualToString:@"remind_status"] || [field isEqualToString:@"del_status"] || [field isEqualToString:@"title"]) {
            
            TFFilterModel *model = [[TFFilterModel alloc] init];
            model.name = label;
            model.open = @0;
            model.type = @"text";
            model.id = field;
            model.modelName = @"memo";
            model.modelLabel = @"备忘录";
            
            NSArray *names = @[@"值",@"已填写",@"未填写"];
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSInteger k = 0; k < names.count; k ++) {
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                item.label = names[k];
                if (k > 0) {
                    item.type = @0;
                }else{
                    item.type = @1;
                }
                item.selectState = @0;
                [arr addObject:item];
            }
            model.entrys = arr;
            
            [items addObject:model];
            
        }
        else if ([field isEqualToString:@"remind_time"] || [field isEqualToString:@"create_time"] || [field isEqualToString:@"modify_time"]){
            
            TFFilterModel *model = [[TFFilterModel alloc] init];
            model.name = label;
            model.open = @0;
            model.type = @"datetime";
            model.id = field;
            model.modelName = @"memo";
            model.modelLabel = @"备忘录";
            
            NSArray *names = @[@"今天",@"昨天",@"过去7天",@"过去30天",@"本月",@"上月",@"本季度",@"上季度",@"开始时间",@"结束时间"];
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSInteger k = 0; k < names.count; k ++) {
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                item.label = names[k];
                item.type = @0;
                item.selectState = @0;
                
                if (k == names.count-2 || k == names.count - 1) {
                    item.type = @2;
                }
                
                [arr addObject:item];
            }
            model.entrys = arr;
            
            [items addObject:model];
            
        }
        else if ([field isEqualToString:@"create_by"] || [field isEqualToString:@"modify_by"]){
            
            TFFilterModel *model = [[TFFilterModel alloc] init];
            model.name = label;
            model.open = @0;
            model.type = @"personnel";
            model.id = field;
            model.modelName = @"memo";
            model.modelLabel = @"备忘录";
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dict in member) {
                
                TFEmployModel *emp = [[TFEmployModel alloc] initWithDictionary:dict error:nil];
                
                if (emp) {
                    
                    [arr addObject:[TFChangeHelper tfEmployeeToHqEmployee:emp]];
                }
            }
            HQEmployModel *ee = [[HQEmployModel alloc] init];
            ee.employee_name = @"请选择";
            [arr insertObject:ee atIndex:0];
            
            model.entrys = arr;
            
            [items addObject:model];
        }
        else if ([field isEqualToString:@"department"]){
            
            TFFilterModel *model = [[TFFilterModel alloc] init];
            model.name = label;
            model.open = @0;
            model.type = @"department";
            model.id = field;
            model.modelName = @"memo";
            model.modelLabel = @"备忘录";
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dict in member) {
                
                TFDepartmentModel *emp = [[TFDepartmentModel alloc] initWithDictionary:dict error:nil];
                
                if (emp) {
                    
                    [arr addObject:emp];
                }
            }
            TFDepartmentModel *ee = [[TFDepartmentModel alloc] init];
            ee.name = @"请选择";
            [arr insertObject:ee atIndex:0];
            
            model.entrys = arr;
            
            [items addObject:model];
        }
        else{
            
            TFFilterModel *model = [[TFFilterModel alloc] init];
            model.name = label;
            model.open = @0;
            model.type = @"text";
            model.id = field;
            model.modelName = @"memo";
            model.modelLabel = @"备忘录";
            
            NSArray *names = @[@"值",@"已填写",@"未填写"];
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSInteger k = 0; k < names.count; k ++) {
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                item.label = names[k];
                if (k > 0) {
                    item.type = @0;
                }else{
                    item.type = @1;
                }
                item.selectState = @0;
                [arr addObject:item];
            }
            model.entrys = arr;
            
            [items addObject:model];
            
        }
    }
    
    return items;
}

/** 构造审批筛选项 */
- (NSArray *)approvalWithCondition:(NSArray *)condition{
    NSMutableArray *items = [NSMutableArray array];
    
    
    
    return items;
}

/** 构造自定义筛选项 */
- (NSArray *)customWithCondition:(NSArray *)condition bean:(NSString *)bean beanName:(NSString *)beanName{
    NSMutableArray *items = [NSMutableArray array];
    
    for (NSDictionary *dict in condition) {
        
        NSString *field = [dict valueForKey:@"field"];
        NSString *label = [dict valueForKey:@"label"];
        NSString *type = [dict valueForKey:@"type"];
        NSArray *member = [dict valueForKey:@"member"];
        NSArray *entity = [dict valueForKey:@"entity"];
        
        TFFilterModel *model = [[TFFilterModel alloc] init];
        model.name = label;
        model.open = @0;
        model.type = type;
        model.id = field;
        model.modelName = bean;
        model.modelLabel = beanName;

        if ([type isEqualToString:@"personnel"]) {

            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dict in member) {
                
                TFEmployModel *emp = [[TFEmployModel alloc] initWithDictionary:dict error:nil];
                
                if (emp) {
                    
                    [arr addObject:[TFChangeHelper tfEmployeeToHqEmployee:emp]];
                }
            }
            model.entrys = arr;
            
            HQEmployModel *ee = [[HQEmployModel alloc] init];
            ee.employee_name = @"请选择";
            [arr insertObject:ee atIndex:0];
            
            [items addObject:model];
            
        }else  if ([type isEqualToString:@"department"]) {
                
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *dict in member) {
                    
                    TFDepartmentModel *emp = [[TFDepartmentModel alloc] initWithDictionary:dict error:nil];
                    
                    if (emp) {
                        
                        [arr addObject:emp];
                    }
                }
                model.entrys = arr;
                
                TFDepartmentModel *ee = [[TFDepartmentModel alloc] init];
                ee.name = @"请选择";
                [arr insertObject:ee atIndex:0];
                
                [items addObject:model];
                
            }
        else if ([type isEqualToString:@"datetime"]) {

            NSArray *names = @[@"今天",@"昨天",@"过去7天",@"过去30天",@"本月",@"上月",@"本季度",@"上季度",@"开始时间",@"结束时间"];
            NSMutableArray *arr = [NSMutableArray array];

            for (NSInteger k = 0; k < names.count; k ++) {
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                item.label = names[k];
                item.type = @0;
                item.selectState = @0;

                if (k == names.count-2 || k == names.count - 1) {
                    item.type = @2;
                }

                [arr addObject:item];
            }
            model.entrys = arr;
            [items addObject:model];
        }

        else if ([model.type isEqualToString:@"number"]) {

            NSArray *names = @[@"值",@"已填写",@"未填写"];
            NSMutableArray *arr = [NSMutableArray array];

            for (NSInteger k = 0; k < names.count; k ++) {
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                item.label = names[k];
                item.type = @0;
                if (k == 0) {
                    item.type = @3;
                }
                item.selectState = @0;
                [arr addObject:item];
            }
            model.entrys = arr;
            [items addObject:model];
        }

        else if ([model.type isEqualToString:@"area"]) {

            NSArray *names = @[@"地区",@"已填写",@"未填写"];
            NSMutableArray *arr = [NSMutableArray array];

            for (NSInteger k = 0; k < names.count; k ++) {
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                item.label = names[k];
                item.type = @0;
                if (k == 0) {
                    item.type = @4;
                }
                item.selectState = @0;
                [arr addObject:item];
            }
            model.entrys = arr;
            [items addObject:model];
        }

        else if ([model.type isEqualToString:@"text"] || [model.type isEqualToString:@"textarea"] ||[model.type isEqualToString:@"email"] ||[model.type isEqualToString:@"phone"] ||[model.type isEqualToString:@"url"] ||[model.type isEqualToString:@"location"] ||[model.type isEqualToString:@"reference"]||[model.type isEqualToString:@"identifier"] || [model.type isEqualToString:@"serialnum"]||[model.type isEqualToString:@"functionformula"] || [model.type isEqualToString:@"citeformula"]||[model.type isEqualToString:@"subform"]||[model.type isEqualToString:@"attachment"] || [model.type isEqualToString:@"barcode"] || [model.type isEqualToString:@"multitext"]) {

            NSArray *names = @[@"输入关键字",@"已填写",@"未填写"];
            NSMutableArray *arr = [NSMutableArray array];

            for (NSInteger k = 0; k < names.count; k ++) {
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                item.label = names[k];
                item.type = @0;
                if (k == 0) {
                    item.type = @1;
                }
                item.selectState = @0;
                [arr addObject:item];
            }
            model.entrys = arr;
            [items addObject:model];
        }
        else if ([model.type isEqualToString:@"picklist"] || [field containsString:@"multi"]) {

            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dict in entity) {
                
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                item.label = [dict valueForKey:@"name"];
                item.value = [dict valueForKey:@"id"];
                item.color = [dict valueForKey:@"colour"];
                item.type = @0;
                item.selectState = @0;
                
                [arr addObject:item];
                
            }
            model.entrys = arr;
            
            [items addObject:model];
            
        }

        else{
            
            TFFilterModel *model = [[TFFilterModel alloc] init];
            model.name = label;
            model.open = @0;
            model.type = @"text";
            model.id = field;
            model.modelName = bean;
            model.modelLabel = beanName;
            
            NSArray *names = @[@"值",@"已填写",@"未填写"];
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSInteger k = 0; k < names.count; k ++) {
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                item.label = names[k];
                if (k > 0) {
                    item.type = @0;
                }else{
                    item.type = @1;
                }
                item.selectState = @0;
                [arr addObject:item];
            }
            model.entrys = arr;
            
            [items addObject:model];
            
        }
    }
    
    return items;
}

/** 构造任务筛选项 */
- (NSArray *)taskWithCondition:(NSArray *)condition bean:(NSString *)bean beanName:(NSString *)beanName{
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.times];
    
    for (TFFilterModel *mo in items) {
        mo.modelName = bean;
        mo.modelLabel = beanName;
    }
    
    for (NSDictionary *dict  in condition) {
        NSString *field = [dict valueForKey:@"field"];
        NSString *label = [dict valueForKey:@"label"];
        NSArray *member = [dict valueForKey:@"member"];
        NSArray *entity = [dict valueForKey:@"entity"];
        
        if ([field isEqualToString:@"content"] || [field isEqualToString:@"remind_status"] || [field isEqualToString:@"title"] || [field containsString:@"text"]) {
            
            TFFilterModel *model = [[TFFilterModel alloc] init];
            model.name = label;
            model.open = @0;
            model.type = @"text";
            model.id = field;
            model.modelName = bean;
            model.modelLabel = beanName;
            
            NSArray *names = @[@"值",@"已填写",@"未填写"];
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSInteger k = 0; k < names.count; k ++) {
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                item.label = names[k];
                if (k > 0) {
                    item.type = @0;
                }else{
                    item.type = @1;
                }
                item.selectState = @0;
                [arr addObject:item];
            }
            model.entrys = arr;
            
            [items addObject:model];
            
        }
        else if ([field containsString:@"datetime"] || [field isEqualToString:@"time"]){
            
            TFFilterModel *model = [[TFFilterModel alloc] init];
            model.name = label;
            model.open = @0;
            model.type = @"datetime";
            model.id = field;
            model.modelName = bean;
            model.modelLabel = beanName;
            
            NSArray *names = @[@"今天",@"昨天",@"过去7天",@"过去30天",@"本月",@"上月",@"本季度",@"上季度",@"开始时间",@"结束时间"];
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSInteger k = 0; k < names.count; k ++) {
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                item.label = names[k];
                item.type = @0;
                item.selectState = @0;
                
                if (k == names.count-2 || k == names.count - 1) {
                    item.type = @2;
                }
                
                [arr addObject:item];
            }
            model.entrys = arr;
            
            [items addObject:model];
            
        }
        else if ([field containsString:@"personnel"]){
            
            TFFilterModel *model = [[TFFilterModel alloc] init];
            model.name = label;
            model.open = @0;
            model.type = @"personnel";
            model.id = field;
            model.modelName = bean;
            model.modelLabel = beanName;
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dict in member) {
                
                TFEmployModel *emp = [[TFEmployModel alloc] initWithDictionary:dict error:nil];
                
                if (emp) {
                    
                    [arr addObject:[TFChangeHelper tfEmployeeToHqEmployee:emp]];
                }
            }
            
            HQEmployModel *ee = [[HQEmployModel alloc] init];
            ee.employee_name = @"请选择";
            [arr insertObject:ee atIndex:0];
            
            model.entrys = arr;
            
            [items addObject:model];
            
        }
        else if ([field containsString:@"department"]){
            
            TFFilterModel *model = [[TFFilterModel alloc] init];
            model.name = label;
            model.open = @0;
            model.type = @"personnel";
            model.id = field;
            model.modelName = bean;
            model.modelLabel = beanName;
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dict in member) {
                
                TFDepartmentModel *emp = [[TFDepartmentModel alloc] initWithDictionary:dict error:nil];
                
                if (emp) {
                    
                    [arr addObject:emp];
                }
            }
            
            TFDepartmentModel *ee = [[TFDepartmentModel alloc] init];
            ee.name = @"请选择";
            [arr insertObject:ee atIndex:0];
            
            model.entrys = arr;
            
            [items addObject:model];
            
        }
        else if ([field containsString:@"tag"] || [field containsString:@"picklist"] || [field containsString:@"multi"]){
            
            TFFilterModel *model = [[TFFilterModel alloc] init];
            model.name = label;
            model.open = @0;
            model.type = @"picklist";
            model.id = field;
            model.modelName = bean;
            model.modelLabel = beanName;
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dict in entity) {
                
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                if ([dict valueForKey:@"value"]) {
                    item.label = [dict valueForKey:@"label"];
                    item.value = [dict valueForKey:@"value"];
                    item.color = [dict valueForKey:@"color"];
                }else if ([dict valueForKey:@"id"]) {
                    item.label = [dict valueForKey:@"name"];
                    item.value = [dict valueForKey:@"id"];
                    item.color = [dict valueForKey:@"colour"];
                }
                item.type = @0;
                item.selectState = @0;

                [arr addObject:item];
                
            }
            model.entrys = arr;
            
            [items addObject:model];
            
        }else if ([field containsString:@"number"]) {
            
            TFFilterModel *model = [[TFFilterModel alloc] init];
            model.name = label;
            model.open = @0;
            model.type = @"number";
            model.id = field;
            model.modelName = bean;
            model.modelLabel = beanName;
            NSArray *names = @[@"值",@"已填写",@"未填写"];
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSInteger k = 0; k < names.count; k ++) {
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                item.label = names[k];
                item.type = @0;
                if (k == 0) {
                    item.type = @3;
                }
                item.selectState = @0;
                [arr addObject:item];
            }
            model.entrys = arr;
            [items addObject:model];
        }
        else{
            
            TFFilterModel *model = [[TFFilterModel alloc] init];
            model.name = label;
            model.open = @0;
            model.type = @"text";
            model.id = field;
            model.modelName = bean;
            model.modelLabel = beanName;
            
            NSArray *names = @[@"值",@"已填写",@"未填写"];
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSInteger k = 0; k < names.count; k ++) {
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                item.label = names[k];
                if (k > 0) {
                    item.type = @0;
                }else{
                    item.type = @1;
                }
                item.selectState = @0;
                [arr addObject:item];
            }
            model.entrys = arr;
            
            [items addObject:model];
            
        }
        
    }
    
    return items;
}


//-(NSMutableArray *)conditions{
//
//    if (!_conditions) {
//        _conditions = [NSMutableArray array];
//
//            NSArray *types = @[@"text",@"textarea",@"area",@"location",@"phone",@"email",@"url",@"picklist",@"personnel",@"datetime",@"number"];
//            for (NSInteger i = 0; i < types.count; i ++) {
//
//                TFFilterModel *model = [[TFFilterModel alloc] init];
//                model.name = types[i];
//                model.open = @0;
//                model.type = types[i];
//                model.id = types[i];
//
//                if ([model.type isEqualToString:@"personnel"]) {
//
//                    NSMutableArray *arr = [NSMutableArray array];
//                    for (NSInteger j = 0; j < 3; j ++) {
//
//                        HQEmployModel *emp = [[HQEmployModel alloc] init];
//
//                        emp.employeeName = @"张三";
//                        emp.selectState = @0;
//
//                        [arr addObject:emp];
//                    }
//                    model.entrys = arr;
//                }
//                if ([model.type isEqualToString:@"datetime"]) {
//
//                    NSArray *names = @[@"今天",@"昨天",@"过去7天",@"过去30天",@"本月",@"上月",@"本季度",@"上季度",@"开始时间",@"结束时间"];
//                    NSMutableArray *arr = [NSMutableArray array];
//
//                    for (NSInteger k = 0; k < names.count; k ++) {
//                        TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
//                        item.label = names[k];
//                        item.type = @0;
//                        item.selectState = @0;
//
//                        if (k == names.count-2 || k == names.count - 1) {
//                            item.type = @2;
//                        }
//
//                        [arr addObject:item];
//                    }
//                    model.entrys = arr;
//                }
//
//                if ([model.type isEqualToString:@"number"]) {
//
//                    NSArray *names = @[@"值",@"已填写",@"未填写"];
//                    NSMutableArray *arr = [NSMutableArray array];
//
//                    for (NSInteger k = 0; k < names.count; k ++) {
//                        TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
//                        item.label = names[k];
//                        item.type = @0;
//                        if (k == 0) {
//                            item.type = @3;
//                        }
//                        item.selectState = @0;
//                        [arr addObject:item];
//                    }
//                    model.entrys = arr;
//                }
//
//                if ([model.type isEqualToString:@"area"]) {
//
//                    NSArray *names = @[@"地区",@"已填写",@"未填写"];
//                    NSMutableArray *arr = [NSMutableArray array];
//
//                    for (NSInteger k = 0; k < names.count; k ++) {
//                        TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
//                        item.label = names[k];
//                        item.type = @0;
//                        if (k == 0) {
//                            item.type = @4;
//                        }
//                        item.selectState = @0;
//                        [arr addObject:item];
//                    }
//                    model.entrys = arr;
//                }
//
//                if ([model.type isEqualToString:@"text"] || [model.type isEqualToString:@"textarea"] ||[model.type isEqualToString:@"email"] ||[model.type isEqualToString:@"phone"] ||[model.type isEqualToString:@"url"] ||[model.type isEqualToString:@"location"]) {
//
//                    NSArray *names = @[@"输入关键字",@"已填写",@"未填写"];
//                    NSMutableArray *arr = [NSMutableArray array];
//
//                    for (NSInteger k = 0; k < names.count; k ++) {
//                        TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
//                        item.label = names[k];
//                        item.type = @0;
//                        if (k == 0) {
//                            item.type = @1;
//                        }
//                        item.selectState = @0;
//                        [arr addObject:item];
//                    }
//                    model.entrys = arr;
//                }
//                if ([model.type isEqualToString:@"picklist"]) {
//
//
//                    NSArray *names = @[@"选项一",@"选项二",@"选项三"];
//                    NSMutableArray *arr = [NSMutableArray array];
//
//                    for (NSInteger k = 0; k < names.count; k ++) {
//                        TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
//                        item.label = names[k];
//                        item.type = @0;
//                        item.selectState = @0;
//
//
//                        [arr addObject:item];
//                    }
//                    model.entrys = arr;
//
//                }
//
//                [_conditions addObject:model];
//            }
//
//    }
//    return _conditions;
//}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupChild];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChild];
    }
    return self;
}



- (void)setupChild{
    
    UIView *bgview = [[UIView alloc] initWithFrame:(CGRect){0,0,MarginWidth,SCREEN_HEIGHT}];
    [self addSubview:bgview];
    
//    HQTFSearchHeader *headerSearch = [[HQTFSearchHeader alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH-MarginWidth,64}];
//    headerSearch.frame = CGRectMake(0, 0, SCREEN_WIDTH-MarginWidth, 64);
////    headerSearch.textField.returnKeyType = UIReturnKeySearch;
//    headerSearch.delegate = self;
//    self.headerSearch = headerSearch;
//    self.headerSearch.type = SearchHeaderTypeSearch;
//    self.headerSearch.textField.backgroundColor = BackGroudColor;
//    self.headerSearch.image.backgroundColor = BackGroudColor;
    
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){MarginWidth,0,SCREEN_WIDTH-MarginWidth,64}];
    view.backgroundColor = WhiteColor;
//    [view addSubview:headerSearch];
    view.layer.masksToBounds = YES;
    [self addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){0,20,SCREEN_WIDTH-MarginWidth,44}];
    label.text = @"筛选";
    label.font = BFONT(20);
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){0,63.5,SCREEN_WIDTH-MarginWidth,0.5}];
    [view addSubview:line];
    line.backgroundColor = LightGrayTextColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView)];
    [bgview addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [bgview addGestureRecognizer:pan];
    
    [self setupTableView];
    
    self.backgroundColor = RGBAColor(0, 0, 0, 0);
    self.layer.masksToBounds = NO;
    
    NSMutableArray <TFTwoBtnsModel>*arr = [NSMutableArray<TFTwoBtnsModel> array];
    for (NSInteger i = 0; i < 2; i++) {
        TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
        model.font = FONT(14);
        model.color = GreenColor;
        if (0 == i) {
            model.title = @"重置";
        }else{
            model.title = @"确定";
        }
        [arr addObject:model];
    }
    TFTwoBtnsView *bottomView = [[TFTwoBtnsView alloc] initWithFrame:(CGRect){MarginWidth,SCREEN_HEIGHT-49,SCREEN_WIDTH-MarginWidth,49} withModels:arr];
    bottomView.delegate = self;
    [self addSubview:bottomView];
}

#pragma mark - TFTwoBtnsViewDelegate
-(void)twoBtnsView:(TFTwoBtnsView *)twoBtnsView didSelectIndex:(NSInteger)index{
    
    if (index == 0) {
//
//        for (TFFilterModel *model in self.customs) {
//            for (NSInteger i = 0; i<model.entrys.count; i++) {
//                TFFilterItemModel *item = model.entrys[i];
//                if (i == 1) {
//                    item.selectState = @1;
//                }else{
//                    item.selectState = @0;
//                }
//                item.content = nil;
//                item.maxValue = nil;
//                item.minValue = nil;
//                item.timeSp = @0;
//            }
//        }
//
//        for (TFFilterItemModel *item in self.roles) {
//            item.selectState = @0;
//            item.content = nil;
//            item.maxValue = nil;
//            item.minValue = nil;
//            item.timeSp = @0;
//        }
        self.customs = nil;
        self.roles = nil;
        
        for (TFFilterModel *model in self.items) {
            
            for (TFFilterItemModel *item in model.entrys) {
                if ([item isKindOfClass:[TFFilterItemModel class]]) {
                    
                    item.selectState = @0;
                    item.content = nil;
                    item.maxValue = nil;
                    item.minValue = nil;
                    item.timeSp = @0;
                }
                if ([item isKindOfClass:[TFEmployModel class]] || [item isKindOfClass:[HQEmployModel class]]) {
                    
                    item.selectState = @0;
                }
            }
        }
        [self.tableView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(filterViewDidSureBtnWithDict:)]) {
            [self.delegate filterViewDidSureBtnWithDict:nil];
        }
        
    }else{
        
        // 获取搜索条件
        [self handleData];
        
    }
    
}

/** 获取搜索条件 */
- (void)handleData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (TFFilterModel *model in self.customs) {// 自定义排序
        for (TFFilterItemModel *item in model.entrys) {
            if ([item.selectState isEqualToNumber:@1]) {
                [dict setObject:item.value forKey:model.id];
                break;
            }
        }
    }
    
    if (self.type == 0) {
        
        for (TFFilterModel *model in self.roles) {// 视图
            for (TFFilterItemModel *item in model.entrys) {
                if ([item.selectState isEqualToNumber:@1]) {
                    [dict setObject:item.value forKey:model.id];
                    break;
                }
            }
        }
    }
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    for (NSArray *arr in self.sections) {
        
        for (TFFilterModel *model in arr) {
            
            if ([model.type isEqualToString:@"text"] || [model.type isEqualToString:@"textarea"] ||[model.type isEqualToString:@"email"] ||[model.type isEqualToString:@"phone"] ||[model.type isEqualToString:@"url"] ||[model.type isEqualToString:@"location"] ||[model.type isEqualToString:@"reference"]||[model.type isEqualToString:@"identifier"] || [model.type isEqualToString:@"serialnum"]||[model.type isEqualToString:@"functionformula"] || [model.type isEqualToString:@"citeformula"]||[model.type isEqualToString:@"subform"]||[model.type isEqualToString:@"attachment"]||[model.type isEqualToString:@"seniorformula"]) {
                
                NSString *str = @"";
                for (TFFilterItemModel *item in model.entrys) {
                    
                    
                    if (item.content && ![item.content isEqualToString:@""]) {
                        str = item.content;
                    }
                    if ([item.label isEqualToString:@"已填写"] && [item.selectState isEqualToNumber:@1]) {
                        str = @"ISNOTNULL";
                    }
                    
                    if ([item.label isEqualToString:@"未填写"] && [item.selectState isEqualToNumber:@1]) {
                        str = @"ISNULL";
                    }
                    
                }
                if (![str isEqualToString:@""]) {
                    [data setObject:str forKey:model.id];
                }
                
            }
            
            if ([model.type isEqualToString:@"personnel"]) {
                
                NSString *str = @"";
                for (HQEmployModel *item in model.entrys) {
                    if ([item.selectState isEqualToNumber:@1]) {
                        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[item.id description]]];
                    }
                }
                
                if (str.length) {
                    [data setObject:[str substringToIndex:str.length-1] forKey:model.id];
                }
                
            }
            
            if ([model.type isEqualToString:@"picklist"] || [model.type isEqualToString:@"multi"]) {
                
                NSString *str = @"";
                for (TFFilterItemModel *item in model.entrys) {
                    if ([item.selectState isEqualToNumber:@1]) {
                        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[item.value description]]];
                    }
                }
                if (str.length) {
                    if ([model.name isEqualToString:@"time"]) {
                        [dict setObject:[str substringToIndex:str.length-1] forKey:model.id];
                    }else{
                        [data setObject:[str substringToIndex:str.length-1] forKey:model.id];
                    }
                }
            }
            
            if ([model.type isEqualToString:@"number"]) {
                
                NSMutableDictionary *valueDict = [NSMutableDictionary dictionary];
                NSString *str = @"";
                for (TFFilterItemModel *item in model.entrys) {
                    
                    if (item.minValue && ![item.minValue isEqualToString:@""]) {
                        
                        [valueDict setObject:item.minValue forKey:@"minValue"];
                    }
                    if (item.maxValue && ![item.maxValue isEqualToString:@""]) {
                        
                        [valueDict setObject:item.maxValue forKey:@"maxValue"];
                    }
                    if ([item.label isEqualToString:@"已填写"] && [item.selectState isEqualToNumber:@1]) {
                        str = @"ISNOTNULL";
                    }
                    
                    if ([item.label isEqualToString:@"未填写"] && [item.selectState isEqualToNumber:@1]) {
                        str = @"ISNULL";
                    }
                    
                }
                if (valueDict.allValues.count) {
                    
                    [data setObject:valueDict forKey:model.id];
                    
                }else{
                    
                    if (![str isEqualToString:@""]) {
                        [data setObject:str forKey:model.id];
                    }
                }
                
            }
            
            if ([model.type isEqualToString:@"datetime"]) {
                
                NSMutableDictionary *time = [NSMutableDictionary dictionary];
                for (NSInteger i = 0; i < model.entrys.count; i ++) {
                    
                    TFFilterItemModel *item = model.entrys[i];
                    
                    if ([item.type isEqualToNumber:@0]) {// 选item
                        
                        if ([item.selectState isEqualToNumber:@1]) {// 选中
                            // 时间转化
                            [data setObject:[HQHelper timePeriodWithIndex:i] forKey:model.id];
                            break;
                        }
                    }
                    
                    if ([item.type isEqualToNumber:@2]) {// 选时间
                        
                        if (item.timeSp && ![item.timeSp isEqualToNumber:@0]) {
                            
                            if (i == 8) {
                                [time setObject:item.timeSp forKey:@"startTime"];
                                [data setObject:time forKey:model.id];
                            }
                            if (i == 9) {
                                [time setObject:item.timeSp forKey:@"endTime"];
                                [data setObject:time forKey:model.id];
                            }
                        }
                    }
                }
            }
            if (data.allKeys.count) {
                [dict setObject:data forKey:@"queryWhere"];
            }
            
            if (dict.allKeys.count > 0) {
                [dict setObject:model.modelName forKey:@"bean"];
            }
        }
        
        if (self.type == 0) {
            if (dict.allKeys.count > 1) {
                break;
            }
        }
    }
    
    
    if ([self.delegate respondsToSelector:@selector(filterViewDidSureBtnWithDict:)]) {
        [self.delegate filterViewDidSureBtnWithDict:dict];
    }
}



#pragma mark - HQTFSearchHeaderDelegate
-(void)searchHeaderTextChange:(UITextField *)textField{
    
}

- (void)tapBgView{
    
//    if ([self.delegate respondsToSelector:@selector(filterViewDidClicked:)]) {
//        [self.delegate filterViewDidClicked:NO];
//    }
    [self hideAnimation];
}

- (void)showAnimation{
    
    [KeyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.backgroundColor = RGBAColor(0, 0, 0, .5);
        self.left = 0;
    }];
    
}

- (void)hideAnimation{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.left = SCREEN_WIDTH;
        self.backgroundColor = RGBAColor(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:pan.view];
    
    //    HQLog(@"=%@=",NSStringFromCGPoint(point));
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.left = point.x;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.left += point.x-self.left;
            
            if (self.left <= 0) {
                self.left = 0.0;
            }else if (self.left >= SCREEN_WIDTH){
                self.left = SCREEN_WIDTH;
            }
            
            CGFloat alpha = self.left/(SCREEN_WIDTH-MarginWidth);
            HQLog(@"=======%f=====",0.5-0.5*alpha);
            
            self.backgroundColor = RGBAColor(0, 0, 0, 0.5-0.5*alpha);
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (self.left > MarginWidth) {
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.backgroundColor = RGBAColor(0, 0, 0, 0);
                    self.left = SCREEN_WIDTH;
                }completion:^(BOOL finished) {
                    
                    [self tapBgView];
                }];
            }else{
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.backgroundColor = RGBAColor(0, 0, 0, 0.5);
                    self.left = 0;
                }];
            }
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(MarginWidth, NaviHeight, SCREEN_WIDTH-MarginWidth, SCREEN_HEIGHT-NaviHeight-BottomHeight) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2 + self.items.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        TFFilterModel *model = self.customs[0];
        if ([model.open isEqualToNumber:@1]) {
            return model.entrys.count;
        }else{
            return 0;
        }
    }else if (section == 1){
        TFFilterModel *model = self.roles[0];
        if ([model.open isEqualToNumber:@1]) {
            return model.entrys.count;
        }else{
            return 0;
        }
    }else{
        
        TFFilterModel *model = self.items[section-2];
        if ([model.open isEqualToNumber:@1]) {
            return model.entrys.count + 1;
        }else{
            return 1;
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        TFFilterModel *model = self.customs[0];
        TFFilterItemModel *item = model.entrys[indexPath.row];
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = item.label;
        cell.titltW.constant = self.width - 60;
        cell.backgroundColor = WhiteColor;
        cell.time.textColor = BlackTextColor;
        cell.time.text = @"";
        if ([item.selectState isEqualToNumber:@1]) {
            [cell.arrow setImage:[UIImage imageNamed:@"signSelect"]];
            cell.timeTitle.textColor = GreenColor;
        }else{
            [cell.arrow setImage:[UIImage imageNamed:@"sign"]];
            cell.timeTitle.textColor = LightBlackTextColor;
        }
        cell.topLine.hidden = YES;
//        if (indexPath.row == 2 || indexPath.row == model.entrys.count-1) {
//            cell.bottomLine.hidden = NO;
//        }else{
//            cell.bottomLine.hidden = YES;
//        }
        return cell;
        
    }else if (indexPath.section == 1){
        
        TFFilterModel *model = self.roles[0];
        TFFilterItemModel *item = model.entrys[indexPath.row];
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = item.label;
        cell.titltW.constant = self.width - 60;
        cell.backgroundColor = WhiteColor;
        cell.time.textColor = BlackTextColor;;
        cell.time.text = @"";
        if ([item.selectState isEqualToNumber:@1]) {
            [cell.arrow setImage:[UIImage imageNamed:@"signSelect"]];
            cell.timeTitle.textColor = GreenColor;
        }else{
            [cell.arrow setImage:[UIImage imageNamed:@"sign"]];
            cell.timeTitle.textColor = LightBlackTextColor;
        }
        cell.topLine.hidden = YES;
//        if (indexPath.row == 2) {
//            cell.bottomLine.hidden = NO;
//        }else{
//            cell.bottomLine.hidden = YES;
//        }
        return cell;
        
    }
//    else if (indexPath.section == 2){
//
//        TFFilterItemModel *item = self.times[indexPath.row];
//
//        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
//        cell.timeTitle.text = item.label;
//        cell.titltW.constant = self.width - 60;
//        cell.backgroundColor = WhiteColor;
//        cell.time.textColor = BlackTextColor;;
//        cell.time.text = @"";
//        cell.timeTitle.textColor = LightBlackTextColor;
//        if ([item.selectState isEqualToNumber:@1]) {
//            [cell.arrow setImage:[UIImage imageNamed:@"signSelect"]];
//        }else{
//            [cell.arrow setImage:[UIImage imageNamed:@"sign"]];
//        }
//        cell.topLine.hidden = YES;
//        cell.bottomLine.hidden = YES;
//        return cell;
//
//    }
    else{
        TFFilterModel *model = self.items[indexPath.section-2];
        
        if (indexPath.row == 0) {
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = model.name;
            cell.titltW.constant = self.width - 60;
            cell.backgroundColor = WhiteColor;
            cell.time.textColor = BlackTextColor;;
            cell.time.text = @"";
            cell.timeTitle.textColor = LightBlackTextColor;
            if ([model.open isEqualToNumber:@1]) {
                [cell.arrow setImage:[UIImage imageNamed:@"展开"]];
            }else{
                [cell.arrow setImage:[UIImage imageNamed:@"下拉"]];
            }
            cell.topLine.hidden = YES;
            cell.bottomLine.hidden = YES;
            
            return cell;
        }else{
            
            if ([model.type isEqualToString:@"personnel"]) {
                
                if (indexPath.row == 1) {
                    HQEmployModel *emp = model.entrys[indexPath.row - 1];
                    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                    cell.timeTitle.text = emp.employee_name;
                    cell.titltW.constant = SCREEN_WIDTH-MarginWidth-60;
                    cell.backgroundColor = WhiteColor;
                    cell.time.textColor = ExtraLightBlackTextColor;
                    cell.time.text = @"";
                    cell.timeTitle.textColor = ExtraLightBlackTextColor;
                    [cell.arrow setImage:[UIImage imageNamed:@"下一级浅灰"]];
//                    [self hiddenToplineForCell:cell indexPath:indexPath];
                    return cell;
                }else{
                
                    HQEmployModel *emp = model.entrys[indexPath.row - 1];
                    
                    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
                    [cell.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:emp.picture] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage options:0];
                    
                    cell.titleImage.layer.cornerRadius = 15;
                    cell.titleImage.layer.masksToBounds = YES;
                    cell.titleImageWidth = 30;
                    cell.titleImageLeftW.constant = 10;
                    cell.enterImgTrailW.constant = -13;
                    cell.type = TwoLineCellTypeOne;
                    cell.topLabel.text = emp.employeeName;
                    cell.topLabel.textColor = ExtraLightBlackTextColor;
                    cell.backgroundColor = WhiteColor;
                    if ([emp.selectState isEqualToNumber:@1]) {
                        
                        [cell.enterImage setImage:[UIImage imageNamed:@"signSelect"] forState:UIControlStateNormal];
                    }else{
                        
                        [cell.enterImage setImage:[UIImage imageNamed:@"sign"] forState:UIControlStateNormal];
                    }
                    cell.topLine.hidden = YES;
                    if (model.entrys.count == indexPath.row) {
                        cell.bottomLine.hidden = NO;
                    }else{
                        cell.bottomLine.hidden = YES;
                    }
                    
                    return cell;
                }
                
            }
            else if ([model.type isEqualToString:@"department"]){
                
                if (indexPath.row == 1) {
                    TFDepartmentModel *emp = model.entrys[indexPath.row - 1];
                    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                    cell.timeTitle.text = emp.name;
                    cell.titltW.constant = SCREEN_WIDTH-MarginWidth-60;
                    cell.backgroundColor = WhiteColor;
                    cell.time.textColor = ExtraLightBlackTextColor;
                    cell.time.text = @"";
                    cell.timeTitle.textColor = ExtraLightBlackTextColor;
                    [cell.arrow setImage:[UIImage imageNamed:@"下一级浅灰"]];
//                    [self hiddenToplineForCell:cell indexPath:indexPath];
                    return cell;
                }else{
                    TFDepartmentModel *emp = model.entrys[indexPath.row - 1];
                    
                    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
                    
                    [cell.titleImage setBackgroundImage:IMG(@"部门") forState:UIControlStateNormal];
                    
                    cell.enterImgTrailW.constant = -18;
                    cell.titleImage.layer.cornerRadius = 15;
                    cell.titleImage.layer.masksToBounds = YES;
                    cell.titleImageWidth = 30;
                    cell.type = TwoLineCellTypeOne;
                    cell.topLabel.text = emp.name;
                    cell.topLabel.textColor = ExtraLightBlackTextColor;
                    cell.backgroundColor = WhiteColor;
                    if ([emp.select isEqualToNumber:@1]) {
                        
                        [cell.enterImage setImage:[UIImage imageNamed:@"filterMulti"] forState:UIControlStateNormal];
                    }else{
                        
                        [cell.enterImage setImage:[UIImage imageNamed:@"filterNo"] forState:UIControlStateNormal];
                    }
//                    [self hiddenToplineForCell:cell indexPath:indexPath];
                    return cell;
                    
                }
                
            }
            else if ([model.type isEqualToString:@"text"] || [model.type isEqualToString:@"textarea"] ||[model.type isEqualToString:@"email"] ||[model.type isEqualToString:@"phone"] ||[model.type isEqualToString:@"url"] ||[model.type isEqualToString:@"location"] ||[model.type isEqualToString:@"reference"]||[model.type isEqualToString:@"identifier"] || [model.type isEqualToString:@"serialnum"]||[model.type isEqualToString:@"functionformula"] || [model.type isEqualToString:@"citeformula"]||[model.type isEqualToString:@"subform"]||[model.type isEqualToString:@"attachment"]||[model.type isEqualToString:@"seniorformula"]) {
                
                
                TFFilterItemModel *item = model.entrys[indexPath.row-1];
                
                if ([item.type isEqualToNumber:@0]) {
                    
                    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                    cell.timeTitle.text = [NSString stringWithFormat:@"   %@",item.label];
                    cell.titltW.constant = self.width - 60;
                    cell.backgroundColor = WhiteColor;
                    cell.time.textColor = BlackTextColor;;
                    cell.time.text = @"";
                    cell.timeTitle.textColor = ExtraLightBlackTextColor;
                    if ([item.selectState isEqualToNumber:@1]) {
                        [cell.arrow setImage:[UIImage imageNamed:@"signSelect"]];
                    }else{
                        [cell.arrow setImage:[UIImage imageNamed:@"sign"]];
                    }
                    cell.topLine.hidden = YES;
                    if (model.entrys.count == indexPath.row) {
                        cell.bottomLine.hidden = NO;
                    }else{
                        cell.bottomLine.hidden = YES;
                    }
                    return cell;
                    
                }else if ([item.type isEqualToNumber:@1]) {
                    
                    HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
                    [cell refreshInputCellWithType:0];
                    cell.inputLeftW.constant = 10;
                    cell.titleLabel.text = @"";
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:GrayTextColor,NSFontAttributeName:FONT(14)}];
                    cell.textField.attributedPlaceholder = str;
                    cell.textField.borderStyle = UITextBorderStyleRoundedRect;
                    cell.backgroundColor = WhiteColor;
                    cell.titleLabel.textColor = WhiteColor;
                    cell.textField.tag = indexPath.section * 0x222 + indexPath.row-1;
                    cell.delegate = self;
                    cell.textField.text = item.content;
                    cell.topLine.hidden = YES;
                    cell.bottomLine.hidden = YES;
                    return cell;
                    
                }
                
            }else if ([model.type isEqualToString:@"picklist"] || [model.type isEqualToString:@"multi"]){
                TFFilterItemModel *item = model.entrys[indexPath.row-1];
                
                if ([item.type isEqualToNumber:@0]) {
                    
                    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                    cell.timeTitle.text = [NSString stringWithFormat:@"   %@",item.label];
                    cell.titltW.constant = self.width - 60;
                    cell.backgroundColor = WhiteColor;
                    cell.time.textColor = BlackTextColor;;
                    cell.time.text = @"";
                    cell.timeTitle.textColor = ExtraLightBlackTextColor;
                    if ([item.selectState isEqualToNumber:@1]) {
                        [cell.arrow setImage:[UIImage imageNamed:@"signSelect"]];
                    }else{
                        [cell.arrow setImage:[UIImage imageNamed:@"sign"]];
                    }
                    cell.topLine.hidden = YES;
                    if (model.entrys.count == indexPath.row) {
                        cell.bottomLine.hidden = NO;
                    }else{
                        cell.bottomLine.hidden = YES;
                    }
                    return cell;
                    
                }
                
                
            }else if ([model.type isEqualToString:@"datetime"]){
                
                
                TFFilterItemModel *item = model.entrys[indexPath.row-1];
                
                if ([item.type isEqualToNumber:@0]) {
                    
                    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                    cell.timeTitle.text = [NSString stringWithFormat:@"   %@",item.label];
                    cell.titltW.constant = self.width - 60;
                    cell.backgroundColor = WhiteColor;
                    cell.time.textColor = BlackTextColor;;
                    cell.time.text = @"";
                    cell.timeTitle.textColor = ExtraLightBlackTextColor;
                    if ([item.selectState isEqualToNumber:@1]) {
                        [cell.arrow setImage:[UIImage imageNamed:@"signSelect"]];
                    }else{
                        [cell.arrow setImage:[UIImage imageNamed:@"sign"]];
                    }
                    cell.topLine.hidden = YES;
                    cell.bottomLine.hidden = YES;
                    return cell;
                    
                }else if ([item.type isEqualToNumber:@2]){
                    
                    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                    cell.timeTitle.text = [NSString stringWithFormat:@"   %@",item.label];
                    cell.titltW.constant = self.width - 60;
                    cell.backgroundColor = WhiteColor;
                    cell.timeTitle.textColor = ExtraLightBlackTextColor;
                    cell.time.textColor = BlackTextColor;
                    if (!item.timeSp || [item.timeSp isEqualToNumber:@0]) {
                        
                        cell.time.text = @"年-月-日";
                    }else{
                        cell.time.text = [HQHelper nsdateToTime:[item.timeSp longLongValue] formatStr:@"yyyy年MM月dd日"];
                    }
                    if ([item.selectState isEqualToNumber:@1]) {
                        [cell.arrow setImage:nil];
                    }else{
                        [cell.arrow setImage:nil];
                    }
                    cell.topLine.hidden = YES;
                    if (model.entrys.count == indexPath.row) {
                        cell.bottomLine.hidden = NO;
                    }else{
                        cell.bottomLine.hidden = YES;
                    }
                    return cell;
                }
                
            }else if ([model.type isEqualToString:@"number"]){
                
                TFFilterItemModel *item = model.entrys[indexPath.row-1];
                if ([item.type isEqualToNumber:@0]) {
                    
                    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                    cell.timeTitle.text = [NSString stringWithFormat:@"   %@",item.label];
                    cell.titltW.constant = self.width - 60;
                    cell.backgroundColor = WhiteColor;
                    cell.time.textColor = BlackTextColor;;
                    cell.time.text = @"";
                    cell.timeTitle.textColor = ExtraLightBlackTextColor;
                    if ([item.selectState isEqualToNumber:@1]) {
                        [cell.arrow setImage:[UIImage imageNamed:@"signSelect"]];
                    }else{
                        [cell.arrow setImage:[UIImage imageNamed:@"sign"]];
                    }
                    cell.topLine.hidden = YES;
                    if (model.entrys.count == indexPath.row) {
                        cell.bottomLine.hidden = NO;
                    }else{
                        cell.bottomLine.hidden = YES;
                    }
                    return cell;
                    
                }else if ([item.type isEqualToNumber:@3]){
                    
                    TFMaxMinValueCell *cell = [TFMaxMinValueCell maxMinValueCellWithTableView:tableView];
                    cell.delegate = self;
                    cell.tag = indexPath.section * 0x555 + indexPath.row-1;
                    cell.topLine.hidden = YES;
                    cell.bottomLine.hidden = YES;
                    return cell;
                }
                
            }else if ([model.type isEqualToString:@"area"]){
                
                TFFilterItemModel *item = model.entrys[indexPath.row-1];
                if ([item.type isEqualToNumber:@0]) {
                    
                    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                    cell.timeTitle.text = [NSString stringWithFormat:@"   %@",item.label];
                    cell.titltW.constant = self.width - 60;
                    cell.backgroundColor = WhiteColor;
                    cell.time.textColor = BlackTextColor;;
                    cell.time.text = @"";
                    cell.timeTitle.textColor = ExtraLightBlackTextColor;
                    if ([item.selectState isEqualToNumber:@1]) {
                        [cell.arrow setImage:[UIImage imageNamed:@"signSelect"]];
                    }else{
                        [cell.arrow setImage:[UIImage imageNamed:@"sign"]];
                    }
                    cell.topLine.hidden = YES;
                    if (model.entrys.count == indexPath.row) {
                        cell.bottomLine.hidden = NO;
                    }else{
                        cell.bottomLine.hidden = YES;
                    }
                    return cell;
                    
                }else if ([item.type isEqualToNumber:@4]){
                    
                    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                    cell.timeTitle.text = [NSString stringWithFormat:@"   %@",item.label];
                    cell.titltW.constant = self.width - 60;
                    cell.backgroundColor = WhiteColor;
                    cell.timeTitle.textColor = ExtraLightBlackTextColor;
                    cell.time.textColor = BlackTextColor;
                    if (!item.content || [item.content isEqualToString:@""]) {
                        cell.time.text = @"";
                    }else{
                        cell.time.text = [self.areaManager regionWithRegionData:item.content];
                    }
                    [cell.arrow setImage:[UIImage imageNamed:@"下一级浅灰"]];
                    
                    cell.topLine.hidden = YES;
                    cell.bottomLine.hidden = YES;
                    return cell;
                }
                
            }
            
            static NSString *ID = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            
            cell.textLabel.text = @"";
            return cell;
        }
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    if (indexPath.section > 1) {
        
        TFFilterModel *model = self.items[indexPath.section-2];
        if (indexPath.row == 0) {
            model.open = [model.open isEqualToNumber:@1] ? @0 : @1;
            
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            if ([model.type isEqualToString:@"personnel"]) {
                
                if (indexPath.row == 1) {
                    
                    if ([self.delegate respondsToSelector:@selector(filterViewDidSelectPeopleWithPeoples:model:)]) {
                        NSMutableArray *arrff = [NSMutableArray arrayWithArray:model.entrys];
                        if (arrff.count) {
                            [arrff removeObjectAtIndex:0];
                        }
                        [self.delegate filterViewDidSelectPeopleWithPeoples:arrff model:model];
                    }
                }else{
                    HQEmployModel *emp = model.entrys[indexPath.row - 1];
                    emp.selectState = [emp.selectState isEqualToNumber:@1]?@0:@1;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            else if ([model.type isEqualToString:@"department"]) {
                
                if (indexPath.row == 1) {
                    // 此处跳转选部门控件
                    if ([self.delegate respondsToSelector:@selector(filterViewDidSelectDepartmentWithDepartments:model:)]) {
                        NSMutableArray *arrff = [NSMutableArray arrayWithArray:model.entrys];
                        if (arrff.count) {
                            [arrff removeObjectAtIndex:0];
                        }
                        [self.delegate filterViewDidSelectDepartmentWithDepartments:arrff model:model];
                    }
                    
                }else{
                    
                    TFDepartmentModel *emp = model.entrys[indexPath.row - 1];
                    emp.select = [emp.select isEqualToNumber:@1]?@0:@1;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }
            else{
                
                __block TFFilterItemModel *item = model.entrys[indexPath.row - 1];
                
                if ([model.type isEqualToString:@"text"] || [model.type isEqualToString:@"textarea"] ||[model.type isEqualToString:@"email"] ||[model.type isEqualToString:@"phone"] ||[model.type isEqualToString:@"url"] ||[model.type isEqualToString:@"location"]||[model.type isEqualToString:@"number"]) {
                    
                    
                    
                    if ([item.type isEqualToNumber:@0]) {
                        
                        
                        BOOL haveTime = NO;
                        for (TFFilterItemModel *secItem in model.entrys) {
                            if ([secItem.type isEqualToNumber:@1]) {
                                if (secItem.content && ![secItem.content isEqualToString:@""]) {
                                    haveTime = YES;
                                    break;
                                }
                            }
                        }
                        
                        if (haveTime) {
                            
                            for (TFFilterItemModel *secItem in model.entrys) {
                                secItem.content = @"";
                                secItem.selectState = @0;
                            }
                        }
                        
                        item.selectState = [item.selectState isEqualToNumber:@1]?@0:@1;
                        
                        NSInteger index = 0;
                        for (TFFilterItemModel *secItem in model.entrys) {
                            
                            if ([secItem.selectState isEqualToNumber:@1]) {
                                index ++;
                            }
                        }
                        
                        if (index >= 2) {// 单选处理
                            for (TFFilterItemModel *secItem in model.entrys) {
                                secItem.content = @"";
                                secItem.selectState = @0;
                            }
                            item.selectState = @1;
                        }
                        
                        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                        
                    }
                    
                }
                
                if ([model.type isEqualToString:@"picklist"] || [model.type isEqualToString:@"personnel"]) {
                    
                    if ([item.type isEqualToNumber:@0]) {
                        
                        item.selectState = [item.selectState isEqualToNumber:@1]?@0:@1;
                       
                        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }
                
                if ([model.type isEqualToString:@"datetime"]) {
                    
                    
                    if ([item.type isEqualToNumber:@0]) {
                        
                        BOOL haveTime = NO;
                        for (TFFilterItemModel *secItem in model.entrys) {
                            if ([secItem.type isEqualToNumber:@2]) {
                                if (secItem.timeSp && ![secItem.timeSp isEqualToNumber:@0]) {
                                    haveTime = YES;
                                    break;
                                }
                            }
                        }
                        
                        if (haveTime) {
                            
                            for (TFFilterItemModel *secItem in model.entrys) {
                                secItem.selectState = @0;
                                secItem.timeSp = @0;
                            }
                        }
                        item.selectState = [item.selectState isEqualToNumber:@1]?@0:@1;
                        
                        
                        NSInteger index = 0;
                        for (TFFilterItemModel *secItem in model.entrys) {
                            
                            if ([secItem.selectState isEqualToNumber:@1]) {
                                index ++;
                            }
                        }
                        
                        if (index >= 2) {// 单选处理
                            for (TFFilterItemModel *secItem in model.entrys) {
                                secItem.content = @"";
                                secItem.selectState = @0;
                            }
                            item.selectState = @1;
                        }
                        
                        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    }
                    
                    if ([item.type isEqualToNumber:@2]) {
                        
                        for (TFFilterItemModel *secItem in model.entrys) {// 选择时间时，取消时间点选择
                            secItem.selectState = @0;
                        }
                        
                        [HQSelectTimeView selectTimeViewWithType:SelectTimeViewType_YearMonthDay timeSp:(!item.timeSp || [item.timeSp isEqualToNumber:@0])?[HQHelper getNowTimeSp]:[item.timeSp longLongValue] LeftTouched:^{
                            
                        } onRightTouched:^(NSString *time) {
                            
                            item.timeSp = [NSNumber numberWithLongLong:[HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd"]];
                            
                            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                            
                        }];
                    }
                }
                
                if ([model.type isEqualToString:@"area"]) {
                    
                    
                    if ([item.type isEqualToNumber:@0]) {
                        
                        BOOL haveTime = NO;
                        for (TFFilterItemModel *secItem in model.entrys) {
                            if ([secItem.type isEqualToNumber:@4]) {
                                if (secItem.content && ![secItem.content isEqualToString:@""]) {
                                    haveTime = YES;
                                    break;
                                }
                            }
                        }
                        
                        if (haveTime) {
                            
                            for (TFFilterItemModel *secItem in model.entrys) {
                                secItem.content = @"";
                                secItem.selectState = @0;
                            }
                        }
                        
                        item.selectState = [item.selectState isEqualToNumber:@1]?@0:@1;
                        
                        
                        NSInteger index = 0;
                        for (TFFilterItemModel *secItem in model.entrys) {
                            
                            if ([secItem.selectState isEqualToNumber:@1]) {
                                index ++;
                            }
                        }
                        
                        if (index >= 2) {// 单选处理
                            for (TFFilterItemModel *secItem in model.entrys) {
                                secItem.content = @"";
                                secItem.maxValue = @"";
                                secItem.minValue = @"";
                                secItem.selectState = @0;
                            }
                            item.selectState = @1;
                        }
                        
                        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    }
                    
                    if ([item.type isEqualToNumber:@4]) {
                        
                        for (TFFilterItemModel *secItem in model.entrys) {// 选择时间时，取消时间点选择
                            secItem.selectState = @0;
                        }
                        
                        
                        __weak TFProjectFilterView *this = self;
                        [self insertSubview:self.addressView aboveSubview:self.tableView];
                        [self.addressView showView];
                        self.addressView.sureAddressBlock = ^(id result) {
                            
                            
                            item.content = result[@"id"];
                            
                            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                            [this.addressView cancelView];
                            [this.addressView removeFromSuperview];
                        };
                    }
                    
                    
                }
                
            }
            
        }
    }else if (indexPath.section == 0){
        
        
//        TFFilterModel *model = self.customs[0];
//        TFFilterItemModel *item = model.entrys[indexPath.row];
//
//        if (indexPath.row < 3) {
//
//            for (NSInteger i = 0; i < 3; i ++) {
//                TFFilterItemModel *ii = model.entrys[i];
//                ii.selectState = @0;
//            }
//
//        }else{
//
//            for (NSInteger i = 3; i < 5; i ++) {
//                TFFilterItemModel *ii = model.entrys[i];
//                ii.selectState = @0;
//            }
//
//        }
//        item.selectState = @1;
        
        TFFilterModel *model = self.customs[0];
        for (NSInteger i = 0; i < model.entrys.count; i ++) {
            TFFilterItemModel *ii = model.entrys[i];
            ii.selectState = @0;
        }
        TFFilterItemModel *item = model.entrys[indexPath.row];
        item.selectState = @1;
        
        
    }else if (indexPath.section == 1){
        
//        for (NSInteger i = 0; i < self.roles.count; i ++) {
//            TFFilterItemModel *ii = self.roles[i];
//            ii.selectState = @0;
//        }
//
//        TFFilterItemModel *model = self.roles[indexPath.row];
//        model.selectState = @1;
        
        TFFilterModel *model = self.roles[0];
        for (NSInteger i = 0; i < model.entrys.count; i ++) {
            TFFilterItemModel *ii = model.entrys[i];
            ii.selectState = @0;
        }
        TFFilterItemModel *item = model.entrys[indexPath.row];
        item.selectState = @1;
        
    }
//    else{
//
//        for (NSInteger i = 0; i < self.times.count; i ++) {
//            TFFilterItemModel *ii = self.times[i];
//            ii.selectState = @0;
//        }
//
//        TFFilterItemModel *model = self.times[indexPath.row];
//        model.selectState = @1;
//
//    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 44;
    }else if (indexPath.section == 1) {
        if (self.type == 1) {
            return 0;
        }
        return 44;
    }else{
        TFFilterModel *model = self.items[indexPath.section - 2];
        if ([model.modelOpen isEqualToNumber:@1]) {
            if ([model.name isEqualToString:@"time"]) {
                if (indexPath.row == 0) {
                    return 0;
                }
            }
            return 44;
        }else{
            return 0;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0){
        return 44;
    }else if (section == 1){
        if (self.type == 1) {
            if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                return 0.5;
            }
            return 0;
        }
        return 44;
    }else{
        
        NSInteger height = 0;
        
        NSMutableArray *nums = [NSMutableArray array];
        NSInteger ii = 0;
        for (NSInteger i = 0;i < self.sections.count; i++) {
            NSArray *arr = self.sections[i];
            ii += arr.count;
            [nums addObject:[NSNumber numberWithInteger:ii]];
        }
        
        for (NSNumber *num in nums) {
            if (section-2 == 0 || section-2 == [num integerValue]) {
                height = 44;
            }
        }
        if (height == 0) {
            
            if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                return 0.5;
            }
            return 0;
        }
        return height;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0){
        return 8;
    }else if (section == 1){
        if (self.type == 1) {
            if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                return 0.5;
            }
            return 0;
        }
        return 8;
    }else{
        
//        NSInteger height = 0;
//
//        NSMutableArray *nums = [NSMutableArray array];
//        NSInteger ii = 0;
//        for (NSInteger i = 0;i < self.sections.count; i++) {
//            NSArray *arr = self.sections[i];
//            ii += arr.count;
//            [nums addObject:[NSNumber numberWithInteger:ii]];
//        }
//
//        for (NSNumber *num in nums) {
//            if (section-2 == [num integerValue]) {
//                height = 8;
//            }
//        }
//
//        return height;
        
        
        BOOL have = NO;
        
        NSMutableArray *nums = [NSMutableArray array];
        NSInteger ii = 0;
        for (NSInteger i = 0;i < self.sections.count; i++) {
            NSArray *arr = self.sections[i];
            ii += arr.count;
            [nums addObject:[NSNumber numberWithInteger:ii]];
        }
        
        for (NSNumber *num in nums) {
            if (section-2 == [num integerValue]-1) {
                have = YES;
            }
        }
        
        if (have) {
            return 8;
        }else{
            if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                return 0.5;
            }
            return 0;
        }
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    if (section == 0) {
        TFFilterHeaderView *view = [[TFFilterHeaderView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH-MarginWidth,44}];
        view.title.text = @"自定义排序";
        view.tag = 0x111;
        view.delegate = self;
        TFFilterModel *model = self.customs[0];
        if ([model.open isEqualToNumber:@1]) {
            view.selected = YES;
        }else{
            view.selected = NO;
        }
        return view;
    } else if (section == 1){
        
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor clearColor];
//        return view;
        if (self.type == 1) {
            
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            return view;
        }
        TFFilterHeaderView *view = [[TFFilterHeaderView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH-MarginWidth,44}];
        view.title.text = @"视图";
        view.tag = 0x222;
        view.delegate = self;
        TFFilterModel *model = self.roles[0];
        if ([model.open isEqualToNumber:@1]) {
            view.selected = YES;
        }else{
            view.selected = NO;
        }
        return view;
        
    }
//    else if (section == 2){
//
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor clearColor];
//        return view;
//
//    }
    else{
        
        BOOL have = NO;
        
        NSMutableArray *nums = [NSMutableArray array];
        NSInteger ii = 0;
        for (NSInteger i = 0;i < self.sections.count; i++) {
            NSArray *arr = self.sections[i];
            ii += arr.count;
            [nums addObject:[NSNumber numberWithInteger:ii]];
        }
        
        for (NSNumber *num in nums) {
            if (section-2 == 0 || section-2 == [num integerValue]) {
                have = YES;
            }
        }
        
        if (have) {
            
            TFFilterModel *model = self.items[section-2];
            
            TFFilterHeaderView *view = [[TFFilterHeaderView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH-MarginWidth,44}];
            view.title.text = model.modelLabel;
            view.delegate = self;
            view.tag = 0x35*section;
            view.selected = [model.modelOpen isEqualToNumber:@1]?YES:NO;
            return view;
            
        }else{
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            return view;
            
        }
        
        
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - TFFilterHeaderViewDelegate
-(void)filterHeaderViewDidClicked:(TFFilterHeaderView *)filterHeaderView{
    
    if (filterHeaderView.tag == 0x111) {
        TFFilterModel *model = self.customs[0];
        model.open = [model.open isEqualToNumber:@1] ? @0 : @1;
        
        [self.tableView reloadData];
    }
    else if (filterHeaderView.tag == 0x222) {
        TFFilterModel *model = self.roles[0];
        model.open = [model.open isEqualToNumber:@1] ? @0 : @1;
        
        [self.tableView reloadData];
    }
    else{
        NSInteger tag = filterHeaderView.tag;
        NSInteger section =  tag / 0x35;
        
        TFFilterModel *model = self.items[section-2];
        model.modelOpen = [model.modelOpen isEqualToNumber:@1]?@0:@1;
        
        for (TFFilterModel *f in self.items) {
            
            if ([f.modelName isEqualToString:model.modelName]) {
                f.modelOpen = model.modelOpen;
            }
        }
        
        [self.tableView reloadData];
    }
}

#pragma mark - TFMaxMinValueCellDelegate
-(void)maxMinValueCell:(TFMaxMinValueCell *)maxMinValueCell withTextField:(UITextField *)textField{
    
    NSInteger section = maxMinValueCell.tag / 0x555;
    NSInteger row = maxMinValueCell.tag % 0x555;
    
    TFFilterModel *model = self.conditions[section];
    
    TFFilterItemModel *item = model.entrys[row];
    
    if (textField.tag == 0x111) {
        
        item.minValue = textField.text;
    }
    
    if (textField.tag == 0x222) {
        
        item.maxValue = textField.text;
    }
    
}

#pragma mark - HQTFInputCellDelegate
-(void)inputCellWithTextField:(UITextField *)textField{
    
    NSInteger section = textField.tag / 0x222;
    NSInteger row = textField.tag % 0x222;
    
    TFFilterModel *model = self.items[section-2];
    
    TFFilterItemModel *item = model.entrys[row];
    item.content = textField.text;
    
    BOOL have = NO;
    for (TFFilterItemModel *item in model.entrys) {
        
        if ([item.selectState isEqualToNumber:@1]) {
            item.selectState = @0;
            have = YES;
        }
        
    }
    
    if (have) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.entrys.count inSection:section],[NSIndexPath indexPathForRow:model.entrys.count-1 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

-(void)refresh{
    [self.tableView reloadData];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
