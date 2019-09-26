//
//  TFLateEarlyItemCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/6.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFPCSettingDetailMocel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFLateEarlyItemCellDelegate <NSObject>

@optional
-(void)lateEarlyItemCellDidClickedSetting:(TFLateNigthWalk *)model;

@end

@interface TFLateEarlyItemCell : UITableViewCell

@property (nonatomic, weak) id <TFLateEarlyItemCellDelegate>delegate;

-(void)refreshLateEarlyItemCellWithModel:(TFLateNigthWalk *)mdoel;

+ (instancetype)lateEarlyItemCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
