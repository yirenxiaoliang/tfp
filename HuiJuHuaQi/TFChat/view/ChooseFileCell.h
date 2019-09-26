//
//  ChooseFileCell.h
//  ChatTest
//
//  Created by 肖胜 on 2017/5/21.
//  Copyright © 2017年 Season. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface ChooseFileCell : UITableViewCell


/**
 选中图标
 */
@property(nonatomic,strong)UIImageView *selectedImage;


/**
 缩略图
 */
@property(nonatomic,strong)UIImageView *thumbImage;


/**
 文件名
 */
@property(nonatomic,strong)UILabel *nameLable;


/**
 文件大小
 */
@property(nonatomic,strong)UILabel *sizeLabel;


/**
 日期
 */
@property(nonatomic,strong)UILabel *datelabel;


/**
 PHAsset
 */
@property (nonatomic,strong)NSDictionary *asset;




- (void)setAsset:(NSDictionary *)asset IsSelected:(BOOL) isSelected;

- (void)setMusic:(NSDictionary *)music IsSelected:(BOOL) isSelected;

@property(nonatomic,strong)NSMutableDictionary *info;
@end
