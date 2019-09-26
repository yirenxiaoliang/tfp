//
//  TFConversationListCell.h
//  HuiJuHuaQi
//
//  Created by Mac mimi on 2019/7/31.
//  Copyright © 2019 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSliderCell.h"
#import "TFChatInfoListModel.h"
#import "TFFMDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFConversationListCell : TFSliderCell


@property(strong, nonatomic) NSString *conversationId;

/** 用于区分群 0：普通群，1：小秘书，2：公司总群 */
@property(assign, nonatomic) NSInteger type;

@property (weak, nonatomic)  UILabel *nickName;
@property (weak, nonatomic)  UIButton *headView;
@property (weak, nonatomic)  UILabel *message;
@property (weak, nonatomic)  UILabel *time;
@property (weak, nonatomic)  UILabel *messageNumberLabel;
@property (weak, nonatomic)  UIView *cellLine;
@property (weak, nonatomic)  UIImageView *topImage;

/** 刷新数据 */
- (void)refreshChatCellWithModel:(TFFMDBModel *)model;

+ (instancetype)conversationListCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
