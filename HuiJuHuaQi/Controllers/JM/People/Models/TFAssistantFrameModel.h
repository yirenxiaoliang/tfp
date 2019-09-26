//
//  TFAssistantFrameModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/26.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFAssistantModel.h"

@interface TFAssistantFrameModel : NSObject

/** TFAssistantModel */
@property (nonatomic, strong) TFAssistantModel *assistantModel;


/** 时间 */
@property (nonatomic, assign) CGRect timeLabelRect;
/** 头像 */
@property (nonatomic, assign) CGRect headBtnRect;
/** nameLabelRect */
@property (nonatomic, assign) CGRect nameLabelRect;
/** 已读 */
@property (nonatomic, assign) CGRect readViewRect;
/** 已读隐藏 */
@property (nonatomic, assign) BOOL readViewHidden;
/** descLabelRect */
@property (nonatomic, assign) CGRect descLabelRect;
/** 镖旗 */
@property (nonatomic, assign) CGRect flagBtnRect;
/** paopao */
@property (nonatomic, assign) CGRect paopaoViewRect;
/** contentLabelRect */
@property (nonatomic, assign) CGRect contentLabelRect;
/** people */
@property (nonatomic, assign) CGRect peopleLabelRect;
/** people隐藏 */
@property (nonatomic, assign) BOOL peopleLabelHidden;
/** endTime */
@property (nonatomic, assign) CGRect endTimeLabelRect;


/** cellHeight */
@property (nonatomic, assign) CGFloat cellHeight;


@end
