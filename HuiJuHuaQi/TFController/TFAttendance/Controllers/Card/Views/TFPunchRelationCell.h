//
//  TFPunchRelationCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/11.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFRelationModuleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFPunchRelationCell : HQBaseCell

-(void)refreshPunchRelationCellWithModel:(TFRelationModuleModel *)model;

+(instancetype)punchRelationCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
