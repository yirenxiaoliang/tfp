//
//  TFEnterCustomCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/22.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFEnterCustomCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
+(instancetype)enterCustomCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
