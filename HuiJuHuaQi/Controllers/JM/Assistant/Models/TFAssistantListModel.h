//
//  TFAssistantListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/7/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseListModel.h"
#import "TFAssistantModel.h"


@interface TFAssistantListModel : HQBaseListModel

/** list */
@property (nonatomic, strong) NSArray <Optional,TFAssistantModel>*list;

@end
