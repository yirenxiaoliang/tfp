//
//  TFTaskDetailRelationCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/20.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFTaskDetailRelationCell : HQBaseCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

+(instancetype)taskDetailRelationCellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
