//
//  TFPunchSuccessTipView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/20.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFPunchSuccessTipView : UIView

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

+(instancetype)punchSuccessTipView;

@end

NS_ASSUME_NONNULL_END
