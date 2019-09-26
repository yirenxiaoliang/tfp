//
//  TFDepartmentCModel+CoreDataProperties.h
//  
//
//  Created by HQ-20 on 2018/1/27.
//
//

#import "TFDepartmentCModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TFDepartmentCModel (CoreDataProperties)

+ (NSFetchRequest<TFDepartmentCModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *department_name;
@property (nullable, nonatomic, copy) NSNumber *id;
@property (nullable, nonatomic, copy) NSString *parent_id;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *is_main;

@end

NS_ASSUME_NONNULL_END
