//
//  TFProjectMemberListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/12.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseListModel.h"
#import "HQEmployModel.h"

@interface TFProjectMemberListModel : HQBaseListModel

/** list */
@property (nonatomic, strong) NSArray <HQEmployModel,Optional>*list;


@end
