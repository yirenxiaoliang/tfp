//
//  TFDepartmentCModel+CoreDataProperties.m
//  
//
//  Created by HQ-20 on 2018/1/27.
//
//

#import "TFDepartmentCModel+CoreDataProperties.h"

@implementation TFDepartmentCModel (CoreDataProperties)

+ (NSFetchRequest<TFDepartmentCModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TFDepartmentCModel"];
}

@dynamic department_name;
@dynamic id;
@dynamic parent_id;
@dynamic status;
@dynamic is_main;

@end
