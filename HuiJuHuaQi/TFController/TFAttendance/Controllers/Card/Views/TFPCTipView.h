//
//  TFPCTipView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFPutchRecordModel.h"

@protocol TFPCTipViewDelegate <NSObject>
@optional
- (void)knowClicked;

@end

@interface TFPCTipView : UIView

@property (nonatomic, weak) id <TFPCTipViewDelegate>delegate;

/** 打卡提示 */
-(void)refreshTipViewWithModel:(TFPutchRecordModel *)model;

@end
