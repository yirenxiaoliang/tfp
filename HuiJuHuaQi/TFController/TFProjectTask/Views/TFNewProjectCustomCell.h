//
//  TFNewProjectCustomCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/28.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFProjectRowFrameModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TFNewProjectCustomCell;
@protocol TFNewProjectCustomCellDelegate <NSObject>

@optional
-(void)newProjectCustomCellDidClickedClearBtn:(TFNewProjectCustomCell *)cell;

@end

@interface TFNewProjectCustomCell : UITableViewCell

+(instancetype)newProjectCustomCellWithTableView:(UITableView *)tableView;

/** frameModel */
@property (nonatomic, strong) TFProjectRowFrameModel *frameModel;

@property (nonatomic, assign) NSInteger knowledge;
@property (nonatomic, assign) BOOL edit;

@property (nonatomic, weak) UIImageView *selectImage;

@property (nonatomic, weak) id <TFNewProjectCustomCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
