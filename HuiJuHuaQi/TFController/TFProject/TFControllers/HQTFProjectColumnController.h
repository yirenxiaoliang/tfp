//
//  HQTFProjectColumnController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectTaskRowModel.h"

typedef enum {
    
    ColumnTypeAll,   // 全部
    ColumnTypeDoc,   // 文件
    ColumnTypeImage, // 图片
    ColumnTypeAudio  // 语音
    
}ColumnType;


@interface HQTFProjectColumnController : HQBaseViewController

/** ColumnType */
@property (nonatomic, assign) ColumnType type;

/** TFProjectTaskRowModel */
@property (nonatomic, strong) TFProjectTaskRowModel *projectTaskRow;

@end
