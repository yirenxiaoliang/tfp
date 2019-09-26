//
//  TFFileCModel+CoreDataProperties.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFileCModel+CoreDataProperties.h"

@implementation TFFileCModel (CoreDataProperties)

+ (NSFetchRequest<TFFileCModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TFFileCModel"];
}

@dynamic fileName;
@dynamic fileSize;
@dynamic fileUrl;
@dynamic fileType;
@dynamic filePath;
@dynamic fileId;

@end
