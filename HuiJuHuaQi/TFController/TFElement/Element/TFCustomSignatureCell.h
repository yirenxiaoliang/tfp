//
//  TFCustomSignatureCell.h
//  HuiJuHuaQi
//
//  Created by daidan on 2019/10/16.
//  Copyright © 2019 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFCustomerRowsModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFCustomSignatureCellDelegate <NSObject>

@optional
-(void)signatureClickedWithView:(UIView *)imageView;

@end

@interface TFCustomSignatureCell : HQBaseCell
@property (nonatomic, strong) TFCustomerRowsModel *model;

/** 展示样式 YES：编辑样式  NO: 详情样式 */
@property (nonatomic, assign) BOOL showEdit;
+(instancetype)customSignatureCellWithTableView:(UITableView *)tableView;
@property (nonatomic, weak) id <TFCustomSignatureCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
