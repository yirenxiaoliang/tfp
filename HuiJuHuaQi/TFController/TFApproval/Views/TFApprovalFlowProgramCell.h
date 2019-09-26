//
//  TFApprovalFlowProgramCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFApprovalFlowProgramCell : HQBaseCell

+ (TFApprovalFlowProgramCell *)approvalFlowProgramCellWithTableView:(UITableView *)tableView;

- (void)refreshApprovalFlowProgramCellWithModels:(NSArray *)models;

- (void)refreshApprovalFlowProgramCellWithModels:(NSArray *)models haveHead:(BOOL)haveHead;

+ (CGFloat)refreshApprovalFlowProgramCellHeightWithModels:(NSArray *)models;
+ (CGFloat)refreshApprovalFlowProgramCellHeightWithModels:(NSArray *)models haveHead:(BOOL)haveHead;
@end
