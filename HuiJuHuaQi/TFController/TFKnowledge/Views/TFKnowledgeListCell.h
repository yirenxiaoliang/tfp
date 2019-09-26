//
//  TFKnowledgeListCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFKnowledgeItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFKnowledgeListCell : UITableViewCell

+(instancetype)knowledgeListCellWithTableView:(UITableView *)tableView;

-(void)refreshKnowledgeListCellWithModel:(TFKnowledgeItemModel *)model;

@end

NS_ASSUME_NONNULL_END
