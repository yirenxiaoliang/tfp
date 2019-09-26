//
//  TFTaskDetailCheckCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/16.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFTaskDetailCheckCellDelegate <NSObject>

@optional
-(void)taskDetailCheckCellHandleSwicth:(UISwitch *)switchBtn;

@end

@interface TFTaskDetailCheckCell : HQBaseCell

@property (nonatomic, weak) id <TFTaskDetailCheckCellDelegate>delegate;

+(instancetype)taskDetailCheckCellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign) BOOL check;

@end

NS_ASSUME_NONNULL_END
