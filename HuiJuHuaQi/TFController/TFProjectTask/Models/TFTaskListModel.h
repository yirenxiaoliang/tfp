//
//  TFTaskListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFProjectRowModel.h"
#import "TFProjectRowFrameModel.h"

@interface TFTaskListModel : JSONModel

/** title */
@property (nonatomic, copy) NSString <Optional>*title;
/** projectId */
@property (nonatomic, copy) NSString <Optional>*projectId;
/** tasks */
@property (nonatomic, strong) NSMutableArray <Ignore>*tasks;
/** frames */
@property (nonatomic, strong) NSMutableArray <Ignore>*frames;
/** select */
@property (nonatomic, strong) NSNumber <Ignore>*select;


@end
