//
//  TFMustPutchCardCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/7.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFAtdClassModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TFMustPutchCardCell;
@protocol TFMustPutchCardCellDelegate <NSObject>

@optional
-(void)mustPutchCardCellDidDelete:(TFMustPutchCardCell *)cell;

@end

@interface TFMustPutchCardCell : UITableViewCell


@property (nonatomic, weak) id <TFMustPutchCardCellDelegate>delegate;

-(void)refreshCellWithModel:(TFAtdClassModel *)model;
+(CGFloat)refreshCellHeightModel:(TFAtdClassModel *)model;
+(instancetype)mustPutchCardCellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
