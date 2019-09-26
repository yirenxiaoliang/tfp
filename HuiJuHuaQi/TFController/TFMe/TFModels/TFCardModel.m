//
//  TFCardModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCardModel.h"

@implementation TFCardModel


-(id)copyWithZone:(NSZone *)zone{
  
    TFCardModel *model = [[TFCardModel alloc] init];
    model.choice_template = self.choice_template;
    model.hide_set = self.hide_set;
    model.card_template = self.card_template;
    
    return model;
}


-(id)mutableCopyWithZone:(NSZone *)zone{
    
    TFCardModel *model = [[TFCardModel alloc] init];
    model.choice_template = self.choice_template;
    model.hide_set = self.hide_set;
    model.card_template = self.card_template;
    
    return model;
}




@end
