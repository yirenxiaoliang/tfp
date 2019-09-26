//
//  TFUserLoginCModel+CoreDataProperties.m
//  
//
//  Created by HQ-20 on 2018/1/18.
//
//

#import "TFUserLoginCModel+CoreDataProperties.h"

@implementation TFUserLoginCModel (CoreDataProperties)

+ (NSFetchRequest<TFUserLoginCModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TFUserLoginCModel"];
}

@dynamic isLogin;
@dynamic token;
@dynamic company;
@dynamic departments;
@dynamic employee;
@dynamic employees;

@end
