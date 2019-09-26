//
//  TFBusinessCardView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFPersonInfoModel.h"

@interface TFBusinessCardView : UIView

+ (instancetype)businessCardView;
/** 刷新 */
-(void)refreshBusinessCardVeiwWithModel:(TFPersonInfoModel *)model;
@end
