//
//  TFTCustomSubformHeaderCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/22.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFCustomerRowsModel.h"

@protocol TFTCustomSubformHeaderCellDelegate <NSObject>

@optional
-(void)customSubformHeaderCellClickedAddWithModel:(TFCustomerRowsModel *)model;
-(void)customSubformHeaderCellClickedScanWithModel:(TFCustomerRowsModel *)model;

@end

@interface TFTCustomSubformHeaderCell : UITableViewCell

/** 必填控制 */
@property (nonatomic, copy) NSString *fieldControl;
/** 标题 */
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) TFCustomerRowsModel *model;

/** 展示样式 YES：编辑样式  NO: 详情样式 */
@property (nonatomic, assign) BOOL showEdit;

@property (nonatomic, weak) id <TFTCustomSubformHeaderCellDelegate>delegate;

/** 创建cell */
+(instancetype)customSubformHeaderCellWithTableView:(UITableView *)tableView;

/** cell高度 */
+(CGFloat)refreshCustomSubformHeaderCellHeightWithModel:(TFCustomerRowsModel *)model;
@end
