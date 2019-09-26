//
//  TFCreateNoteModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCreateNoteModel.h"
#import "TFNoteModel.h"
#import "TFLocationModel.h"

@implementation TFCreateNoteModel


-(BOOL)isEdit{
    
    BOOL edit = NO;
    
    if (self.noteItems.count > 1) {
        return YES;
    }else{
        if (self.firstUrl != nil && ![self.firstUrl isEqualToString:@""]) {
            return YES;
        }else{
            TFNoteModel *model = self.noteItems[0];
            
            if (model.check > 0 || model.num > 0 || self.title.length) {
                
                return YES;
            }
        }
    }
    
    return edit;
}


-(NSMutableDictionary *)dict{
    
    NSMutableDictionary *di = [NSMutableDictionary dictionary];
    
    // 拼接Data
    NSMutableArray *arr = [NSMutableArray array];
    for (TFNoteModel *model in self.noteItems) {
        
        NSMutableDictionary *text = [NSMutableDictionary dictionary];
        if (model.type == 0) {
            
            [text setValue:@(model.check) forKey:@"check"];
            [text setValue:TEXT([model.noteTextView.text stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]) forKey:@"content"];
            [text setValue:@(model.num) forKey:@"num"];
            [text setValue:@1 forKey:@"type"];
            
        }else{
            
            [text setValue:TEXT(model.fileUrl) forKey:@"content"];
            [text setValue:@2 forKey:@"type"];
        }
        
        [arr addObject:text];
    }
    
    [di setValue:arr forKey:@"content"];
    
    // 标题
    [di setObject:self.title forKey:@"title"];
    
    // 第一张图片
    if (self.firstUrl) {
        
        [di setObject:self.firstUrl forKey:@"picUrl"];
    }
    
    // 地址
    NSMutableArray *locas = [NSMutableArray array];
    for (TFLocationModel *model in self.locations) {
        
        NSMutableDictionary *lo = [NSMutableDictionary dictionary];
        
        [lo setObject:@(model.latitude) forKey:@"lat"];
        [lo setObject:@(model.longitude) forKey:@"lng"];
        [lo setObject:model.name forKey:@"name"];
        
        
        [lo setObject:[NSString stringWithFormat:@"%@",([model.detailAddress isEqualToString:@""] || model.detailAddress == nil)?model.totalAddress:model.detailAddress] forKey:@"address"];
        [locas addObject:lo];
    }
    [di setObject:locas forKey:@"location"];
    
    // 项目
//    [di setObject:self.relations?:@[] forKey:@"itemsArr"];
    [di setObject:@[] forKey:@"itemsArr"];
    
    // 分享人s
    [di setObject:TEXT(self.sharerIds) forKey:@"shareIds"];
    
    // 提醒时间
    long long time = [HQHelper changeTimeToTimeSp:self.remindTime formatStr:@"yyyy-MM-dd HH:mm"];
    
    [di setObject:@(time) forKey:@"remindTime"];
    
    // 提醒自己
    if (self.remindStatus) {
        
        [di setObject:self.remindStatus forKey:@"remindStatus"];
    }
    else {
    
        [di setObject:@0 forKey:@"remindStatus"];
    }
    
    
    return di;
}



-(NSString *)sharerIds{
    
    NSString *str = @"";
    
    for (HQEmployModel *model in self.sharers) {
        
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[model.id description]]];
    }
    
    if (str.length) {
        str = [str substringToIndex:str.length-1];
    }
    return str;
}


-(NSString *)title{
    
    NSString *str = @"";
    
    for (TFNoteModel *model in self.noteItems) {
        
        if (model.type == 0) {
            
            if (model.num > 0) {
                
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld.%@",model.num,model.noteTextView.text]];
            }else{
                str = [str stringByAppendingString:model.noteTextView.text];
            }
            
        }
    }
    
    if (str.length > 100) {
        str = [str substringToIndex:100];
    }
    
    return str;
}

-(NSString *)firstUrl{
    
    NSString *str = @"";
    
    for (TFNoteModel *model in self.noteItems) {
        
        if (model.type == 1) {
            
            str = model.fileUrl;
            break;
        }
    }
    
    return str;
    
}

@end
