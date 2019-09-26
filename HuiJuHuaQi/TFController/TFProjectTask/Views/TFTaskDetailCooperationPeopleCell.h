//
//  TFTaskDetailCooperationPeopleCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/16.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFTaskDetailCooperationPeopleCell : HQBaseCell

-(void)refreshTaskDetailCooperationPeopleCellWithPeoples:(NSArray *)peoples;
+(instancetype)taskDetailCooperationPeopleCellWithTableView:(UITableView *)tableView;

+(CGFloat)refreshTaskDetailCooperationPeopleCellHeightWithPeoples:(NSArray *)peoples;
@end

NS_ASSUME_NONNULL_END
