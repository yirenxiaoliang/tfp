//
//  FileCell.h
//  ChatTest
//
//  Created by 肖胜 on 2017/5/20.
//  Copyright © 2017年 Season. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface MessageFileCell : UITableViewCell

/**
 图片
 */
@property(nonatomic,strong)UIImageView *photo;


/**
 气泡框
 */
@property(nonatomic,strong)UIImageView *boxImage;


/**
 头像
 */
@property(nonatomic,strong)UIImageView *headImage;


/**
 文件大小标签
 */
@property(nonatomic,strong)UILabel *sizeLabel;


/**
 文件名标签
 */
@property(nonatomic,strong)UILabel *nameLabel;


/**
 进度条
 */
@property(nonatomic,strong)UIProgressView *progressView;

/**
 cell尺寸
 */
@property(nonatomic,strong)NSDictionary *size;


@property(nonatomic,copy)void(^fileReviewBlock)(ChatFileType fileType,id file);

/**
 内容填充

 @param content 内容
 @param type 文件类型
 */
- (void)fillWithContent:(NSDictionary *)content Type:(ChatFileType)type;


@end
