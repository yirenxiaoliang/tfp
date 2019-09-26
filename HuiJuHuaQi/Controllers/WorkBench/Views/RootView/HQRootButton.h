//
//  HQRootButton.h
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/17.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQRootModel.h"

@interface HQRootButton : UIButton
/** 按钮上方提示 */
@property (weak, nonatomic) IBOutlet UILabel *tipLable;
/** 创建button */
+ (instancetype)rootButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipWidth;

@property (nonatomic , strong)HQRootModel *rootModel;

/** 图片的比例 默认为0.6 从0--0.6*/
@property (nonatomic, assign) CGFloat scale;
/** 文字距离顶部比例 默认0.6  从0.6--底部 */
@property (nonatomic, assign) CGFloat wordScale;


@end
