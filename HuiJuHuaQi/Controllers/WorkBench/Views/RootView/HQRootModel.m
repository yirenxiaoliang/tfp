//
//  HQRootModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/6/29.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQRootModel.h"

@implementation HQRootModel

- (NSString *)description{
    
    return [NSString stringWithFormat:@"%@-----%@-----%ld-----%d-----%d-----%d-----%ld", self.name, self.image, self.markNum, self.OutDate, self.backColor, self.deleteShow, self.functionModelType];
}


- (void)encodeWithCoder:(NSCoder *)encoder{
    
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeInteger:self.markNum forKey:@"markNum"];
    [encoder encodeBool:self.OutDate forKey:@"OutDate"];
    [encoder encodeBool:self.backColor forKey:@"backColor"];
    [encoder encodeBool:self.deleteShow forKey:@"deleteShow"];
    [encoder encodeInteger:self.functionModelType forKey:@"functionModelType"];
    [encoder encodeObject:self.modelId forKey:@"modelId"];
    
}

- (instancetype)initWithCoder:(NSCoder *)decoder{
    
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.image = [decoder decodeObjectForKey:@"image"];
        self.markNum = [decoder decodeIntegerForKey:@"markNum"];
        self.OutDate = [decoder decodeBoolForKey:@"OutDate"];
        self.backColor = [decoder decodeBoolForKey:@"backColor"];
        self.deleteShow = [decoder decodeBoolForKey:@"deleteShow"];
        self.functionModelType = [decoder decodeIntegerForKey:@"functionModelType"];
        self.modelId = [decoder decodeObjectForKey:@"modelId"];
        
    }
    return self;
}


@end
