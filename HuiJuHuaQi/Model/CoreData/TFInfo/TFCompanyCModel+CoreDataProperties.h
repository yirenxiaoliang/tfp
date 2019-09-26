//
//  TFCompanyCModel+CoreDataProperties.h
//  
//
//  Created by 尹明亮 on 2019/6/24.
//
//

#import "TFCompanyCModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TFCompanyCModel (CoreDataProperties)

+ (NSFetchRequest<TFCompanyCModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *company_name;
@property (nullable, nonatomic, copy) NSNumber *id;
@property (nullable, nonatomic, copy) NSString *logo;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *website;
@property (nullable, nonatomic, copy) NSString *local_im_address;

@end

NS_ASSUME_NONNULL_END
