//
//  TFScanCodeController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "LBXScanViewController.h"

@interface TFScanCodeController : LBXScanViewController

/** 增加拉近/远视频界面 */
@property (nonatomic, assign) BOOL isVideoZoom;

/** 扫码值 */
@property (nonatomic, copy) ActionParameter scanAction;

/** 扫码详情 */
@property (nonatomic, copy) ActionParameter detailAction;

@end
