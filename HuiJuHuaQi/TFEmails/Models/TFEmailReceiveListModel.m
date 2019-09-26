//
//  TFEmailReceiveListModel.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailReceiveListModel.h"

@implementation TFEmailReceiveListModel

-(instancetype)init{
    if (self = [super init]) {
        
        self.to_recipients = [NSMutableArray<TFEmailPersonModel> array];
        self.cc_recipients = [NSMutableArray<TFEmailPersonModel> array];
        self.bcc_recipients = [NSMutableArray<TFEmailPersonModel> array];
        self.attachments_name = [NSMutableArray<TFFileModel> array];
        self.showFile = @1;
    }
    
    return self;
}

@end
