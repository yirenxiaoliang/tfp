//
//  HQTFModelCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/15.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "HQRootModel.h"
#import "TFApplicationModel.h"
@class HQTFModelCell;
@protocol HQTFModelCellDelegate <NSObject>
@optional
-(void)modelCell:(HQTFModelCell *)modelCell didSelectItem:(HQRootModel *)model;
-(void)modelCell:(HQTFModelCell *)modelCell didSelectModule:(TFModuleModel *)model;
-(void)modelCell:(HQTFModelCell *)modelCell didSelectModule:(TFModuleModel *)model contentView:(id)view;

@end

@interface HQTFModelCell : HQBaseCell


/** 操控modelType  0:我的应用  1:第三方应用 2：常用审批 3：全部审批 4：销售应用 5：商品应用 */
@property (nonatomic, assign) NSInteger modelType;

/** 操控cellType */
@property (nonatomic, assign) NSInteger cellType;

+ (HQTFModelCell *)modelCellWithTableView:(UITableView *)tableView;


+(CGFloat)refreshModelCellHeightWithModelType:(NSInteger)modelType;

/** delegate */
@property (nonatomic, weak) id <HQTFModelCellDelegate>delegate;

/** 刷新自定义模块 */
-(void)refreshModelCellWithModel:(TFApplicationModel *)model;
+(CGFloat)refreshModelCellHeightWithModel:(TFApplicationModel *)model;


@end
