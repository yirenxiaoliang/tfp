//
//  TFColorItemView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFColorItemView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *colorImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
+(instancetype)colorItemView;
@end

NS_ASSUME_NONNULL_END
