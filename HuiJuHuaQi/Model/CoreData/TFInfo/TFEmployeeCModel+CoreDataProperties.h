//
//  TFEmployeeCModel+CoreDataProperties.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmployeeCModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TFEmployeeCModel (CoreDataProperties)

+ (NSFetchRequest<TFEmployeeCModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *employee_name;
@property (nullable, nonatomic, copy) NSNumber *id;
@property (nullable, nonatomic, copy) NSString *microblog_background;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSString *picture;
@property (nullable, nonatomic, copy) NSString *post_name;
@property (nullable, nonatomic, copy) NSString *sex;
@property (nullable, nonatomic, copy) NSString *sign;
@property (nullable, nonatomic, copy) NSNumber *sign_id;
@property (nullable, nonatomic, copy) NSNumber *role_id;
@property (nullable, nonatomic, copy) NSString *mood;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *mobile_phone;
@property (nullable, nonatomic, copy) NSString *region;
@property (nullable, nonatomic, copy) NSString *birth;

@end

NS_ASSUME_NONNULL_END
