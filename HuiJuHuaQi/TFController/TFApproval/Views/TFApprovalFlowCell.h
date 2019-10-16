//
//  TFApprovalFlowCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFApprovalFlowModel.h"

@protocol TFApprovalFlowCellDelegate <NSObject>

@optional
-(void)approvalFlowDidImageView:(UIImageView *)imageView;

@end

@interface TFApprovalFlowCell : HQBaseCell
@property (nonatomic, weak) id <TFApprovalFlowCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *topLineImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLineImage;
@property (weak, nonatomic) IBOutlet UIView *line;

+ (instancetype)approvalFlowCellWithTableView:(UITableView *)tableView;

- (void)refreshApprovalCellWithModel:(TFApprovalFlowModel *)mdoel;
+ (CGFloat)refreshApprovalCellHeightWithModel:(TFApprovalFlowModel *)mdoel;
    
@end
