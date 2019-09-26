//
//  TFCompanyCModel+CoreDataProperties.m
//  
//
//  Created by 尹明亮 on 2019/6/24.
//
//

#import "TFCompanyCModel+CoreDataProperties.h"

@implementation TFCompanyCModel (CoreDataProperties)

+ (NSFetchRequest<TFCompanyCModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"TFCompanyCModel"];
}

@dynamic address;
@dynamic company_name;
@dynamic id;
@dynamic logo;
@dynamic phone;
@dynamic status;
@dynamic website;
@dynamic local_im_address;

@end
