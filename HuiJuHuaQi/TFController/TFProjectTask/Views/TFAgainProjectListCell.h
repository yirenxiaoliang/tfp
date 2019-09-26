//
//  TFAgainProjectListCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/6.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFProjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFAgainProjectListCell : UITableViewCell

- (void)refreshAgainProjectListCellWithProjectModel:(TFProjectModel *)model;
+(instancetype)againProjectListCellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
