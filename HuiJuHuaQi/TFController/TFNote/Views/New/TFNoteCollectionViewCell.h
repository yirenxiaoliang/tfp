//
//  TFNoteCollectionViewCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFNoteCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *picImgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIImageView *buttonOne;

@property (weak, nonatomic) IBOutlet UIImageView *buttonTwo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgLableCons;

@end
