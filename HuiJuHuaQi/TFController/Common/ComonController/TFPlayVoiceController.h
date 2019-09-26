//
//  TFPlayVoiceController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFFileModel.h"
@interface TFPlayVoiceController : HQBaseViewController

/** file */
@property (nonatomic, strong) TFFileModel *file;

/** isEmployee 默认为NO，无人，用于附件播放 ；YES有人，用于随手记快速发语音播放 */
@property (nonatomic, assign) BOOL isEmployee;


@end
