//
//  TFPCBottomView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFPutchRecordModel.h"

@protocol TFPCBottomViewDelegate <NSObject>
@optional
- (void)punchCardClicked;
- (void)punchCardTipLocationClicked:(TFPutchRecordModel *)model;

@end


@interface TFPCBottomView : UIView

@property (nonatomic, strong) UIImageView *tipImg;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, weak) id <TFPCBottomViewDelegate>delegate;

- (void)refreshPCTimeWithModel:(TFPutchRecordModel *)model;

@end
