//
//  TFCRMDynamicCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/9/6.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFCustomerCommentModel.h"

@interface TFCRMDynamicCell : HQBaseCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;


- (void)configCRMDynamicCellWithTableView:(NSArray *)model;
+ (instancetype)CRMDynamicCellWithTableView:(UITableView *)tableView;

+ (CGFloat)refreshDynamicHeightWithModel:(NSString*)content;

/** 刷新cell */
-(void)refreshCellWithModel:(TFCustomerCommentModel *)model;


@end
