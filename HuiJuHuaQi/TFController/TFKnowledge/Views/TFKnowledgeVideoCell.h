//
//  TFKnowledgeVideoCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/25.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFKnowledgeVideoCell : UITableViewCell

+(instancetype)knowledgeVideoCellWithTableView:(UITableView *)tableView;

-(void)refreshVideoCellWithModel:(TFVideoModel *)model;

@end

NS_ASSUME_NONNULL_END
