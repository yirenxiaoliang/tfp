//
//  TFEmailsDetailHeadCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFEmailReceiveListModel.h"

@protocol TFEmailsDetailHeadCellDelegate <NSObject>

@optional

- (void)hideEmailDetailHeadInfo;

@end

@interface TFEmailsDetailHeadCell : HQBaseCell

@property (nonatomic, assign) BOOL ishide;

+ (instancetype)emailsDetailHeadCellWithTableView:(UITableView *)tableView;

- (void)refreshEmailHeadViewWithModel:(TFEmailReceiveListModel *)model;

+ (CGFloat)refreshEmailsDetailHeadHeightWithModel:(TFEmailReceiveListModel *)model;

@property (nonatomic, weak) id <TFEmailsDetailHeadCellDelegate>delegate;

@end
