//
//  ImageCollectionCell.h
//  ChatTest
//
//  Created by Season on 2017/5/19.
//  Copyright © 2017年 Season. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ImageCollectionCell : UICollectionViewCell


/**
 缩略图
 */
@property(nonatomic, strong)UIImageView *photo;


/**
 选中按钮
 */
@property(nonatomic, strong)UIButton *selectedBtn;


/**
 设置图片和选中状态
 
 @param image 图片
 @param isSelected 是否选中
 */
- (void)setImage:(PHAsset *)image IsSelected:(BOOL) isSelected;
@end
