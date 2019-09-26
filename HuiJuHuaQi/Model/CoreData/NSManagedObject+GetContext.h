//
//  NSManagedObject+GetContext.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/22.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (GetContext)

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
