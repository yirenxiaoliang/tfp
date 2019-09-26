//
//  JCHATChatTableViewCell.h
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
// TODO: 改成nib

#import <UIKit/UIKit.h>
//#import "JChatConstants.h"
#import "TFChatInfoListModel.h"
#import "TFFMDBModel.h"

@interface JCHATConversationListCell : UITableViewCell
@property(strong, nonatomic) NSString *conversationId;

/** 用于区分群 0：普通群，1：小秘书，2：公司总群 */
@property(assign, nonatomic) NSInteger type;

@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIButton *headView;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *messageNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *cellLine;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;

- (void)setCellDataWithConversation:(JMSGConversation *)conversation;

//刷新助手
- (void)refreshChatCellWithDatas:(NSArray *)datas;
//刷新数据
- (void)refreshChatCellWithModel:(TFFMDBModel *)model;

@end
