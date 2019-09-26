//
//  MessageCell.h
//  ChatTest
//
//  Created by Season on 2017/5/16.
//  Copyright © 2017年 Season. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#import "TFFMDBModel.h"

@protocol MessageCellDelegate <NSObject>

@optional
- (void)revokeMessage:(TFFMDBModel *)model;

- (void)copyMessage:(YYLabel *)lab;

- (void)transitiveMessage:(TFFMDBModel *)model;

/** 查看已读人员 */
- (void)readedPeoples:(TFFMDBModel *)model;

- (void)longPressAT:(TFFMDBModel *)model;

- (void)playVoice:(TFFMDBModel *)model imageView:(UIImageView *)imageView;

//图片点击
- (void)previewImg:(UIImageView *)imageView model:(TFFMDBModel *)model;

//头像点击
- (void)headImgClicked:(TFFMDBModel *)model;

//重发
- (void)reSendMessage:(TFFMDBModel *)model;

//打开文件
- (void)chatFileClicked:(TFFMDBModel *)model;

@end

@interface MessageCell : UITableViewCell

+ (instancetype)messageCellWithTableView:(UITableView *)tableView;

/**
 时间
 */
@property (nonatomic, retain)UILabel *labelTime;


/**
 名字
 */
@property(nonatomic,strong)UILabel *userName;


/**
 单元格size，适应不同类型的内容
 */
@property(nonatomic,strong)NSDictionary *size;


/**
 图片控件
 */
@property(nonatomic,strong)UIImageView *photo;

@property(nonatomic,strong)UIImageView *preView;

/** 消息类型 */
@property (nonatomic, strong) NSNumber *chatFileType;

/** 气泡 */
@property (nonatomic, strong) UIImageView *boxImage;


//- (void)setContent:(NSAttributedString *)content;
- (void)refreshCell:(TFFMDBModel *)model;
+ (CGFloat)refreshHeightCellWithModel:(TFFMDBModel *)model;

@property (nonatomic, weak) id<MessageCellDelegate> delegate;

@end
