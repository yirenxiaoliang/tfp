//
//  TFApprovalListCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFApprovalListItemModel.h"

@interface TFApprovalListCell : UITableViewCell

+ (instancetype)approvalListCellWithTableView:(UITableView *)tableView;

/** 刷新 */
- (void)refreshCellWithModel:(TFApprovalListItemModel *)model;

/** quote */
@property (nonatomic, assign) BOOL quote;


@end
