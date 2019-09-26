//
//  TFPunchCardController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFPunchCardController : HQBaseViewController

/** 用于自动打卡 */
@property (nonatomic, assign) BOOL isAuto;
/** 是否有数据 */
@property (nonatomic, assign) BOOL isData;
/** 打卡 */
- (void)punchCardClicked;
/** 获取数据 */
-(void)getData;
/** 停止定位 */
-(void)stopLocation;
/** 开启定位 */
-(void)startLocation;
/** 自动打卡回调 */
@property (nonatomic, copy) ActionHandler autoAction;

@end
