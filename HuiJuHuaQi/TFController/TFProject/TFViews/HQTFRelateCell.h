//
//  HQTFRelateCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "HQCustomerModel.h"
#import "TFLocationModel.h"

@protocol HQTFRelateCellDelegate <NSObject>

@optional
- (void)clickedChangeBtn;
- (void)clickedEditBtn;

@end

@interface HQTFRelateCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UIButton *enterImage;

/** 进入图片 */
@property (nonatomic, copy) NSString *enterImg;

+ (HQTFRelateCell *)relateCellWithTableView:(UITableView *)tableView;

/** type 0: 为两行文字 1: 为一行文字*/
- (void)refreshCellWithModel:(HQCustomerModel *)model withType:(NSInteger)type;

/**  当前公司 */
- (void)refreshCellWithCompany:(NSString *)company withType:(NSInteger)type;
/** 地址 */
- (void)refreshCellWithLocation:(TFLocationModel *)model withType:(NSInteger)type;

/** delegate */
@property (nonatomic, weak) id<HQTFRelateCellDelegate>delegate;
@end
