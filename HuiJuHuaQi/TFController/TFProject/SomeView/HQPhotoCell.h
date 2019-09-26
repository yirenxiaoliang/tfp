//
//  HQPhotoCell.h
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/10.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HQPhotoCellDelegate <NSObject>

@optional
- (void)photoCellMinusButtonClickedIndex:(NSInteger)index;

@end

@interface HQPhotoCell : UICollectionViewCell
/** 减号按钮 */
@property (weak, nonatomic) IBOutlet UIButton *minus;
/** 图片数量 */
@property (weak, nonatomic) IBOutlet UILabel *imageNum;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) id<HQPhotoCellDelegate> delegate;
@end
