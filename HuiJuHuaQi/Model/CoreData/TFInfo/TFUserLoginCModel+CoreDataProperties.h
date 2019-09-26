//
//  TFUserLoginCModel+CoreDataProperties.h
//  
//
//  Created by HQ-20 on 2018/1/18.
//
//

#import "TFUserLoginCModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TFUserLoginCModel (CoreDataProperties)

+ (NSFetchRequest<TFUserLoginCModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *isLogin;
@property (nullable, nonatomic, copy) NSString *token;
@property (nullable, nonatomic, retain) TFCompanyCModel *company;
@property (nullable, nonatomic, retain) NSSet<TFDepartmentCModel *> *departments;
@property (nullable, nonatomic, retain) TFEmployeeCModel *employee;
@property (nullable, nonatomic, retain) NSSet<TFEmployeeCModel *> *employees;

@end

@interface TFUserLoginCModel (CoreDataGeneratedAccessors)

- (void)addDepartmentsObject:(TFDepartmentCModel *)value;
- (void)removeDepartmentsObject:(TFDepartmentCModel *)value;
- (void)addDepartments:(NSSet<TFDepartmentCModel *> *)values;
- (void)removeDepartments:(NSSet<TFDepartmentCModel *> *)values;

- (void)addEmployeesObject:(TFEmployeeCModel *)value;
- (void)removeEmployeesObject:(TFEmployeeCModel *)value;
- (void)addEmployees:(NSSet<TFEmployeeCModel *> *)values;
- (void)removeEmployees:(NSSet<TFEmployeeCModel *> *)values;

@end

NS_ASSUME_NONNULL_END
