//
//  TFPunchCardHeader.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/22.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TFPunchCardHeaderDelegate <NSObject>

@optional
-(void)punchCardHeaderClickedPosition;

@end

@interface TFPunchCardHeader : UIView


@property (nonatomic, weak) id <TFPunchCardHeaderDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

+(instancetype)punchCardHeader;

@end

NS_ASSUME_NONNULL_END
