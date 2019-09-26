//
//  TFFileCModel+CoreDataProperties.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFileCModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TFFileCModel (CoreDataProperties)

+ (NSFetchRequest<TFFileCModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *fileName;
@property (nullable, nonatomic, copy) NSNumber *fileSize;
@property (nullable, nonatomic, copy) NSString *fileUrl;
@property (nullable, nonatomic, copy) NSString *fileType;
@property (nullable, nonatomic, copy) NSString *filePath;
@property (nullable, nonatomic, copy) NSString *fileId;

@end

NS_ASSUME_NONNULL_END
