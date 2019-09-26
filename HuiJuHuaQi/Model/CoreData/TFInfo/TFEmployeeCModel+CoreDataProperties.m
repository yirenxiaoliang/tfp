//
//  TFEmployeeCModel+CoreDataProperties.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmployeeCModel+CoreDataProperties.h"

@implementation TFEmployeeCModel (CoreDataProperties)

+ (NSFetchRequest<TFEmployeeCModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TFEmployeeCModel"];
}

@dynamic employee_name;
@dynamic id;
@dynamic microblog_background;
@dynamic phone;
@dynamic picture;
@dynamic post_name;
@dynamic sex;
@dynamic sign;
@dynamic sign_id;
@dynamic role_id;
@dynamic mood;
@dynamic email;
@dynamic mobile_phone;
@dynamic region;
@dynamic birth;

@end
