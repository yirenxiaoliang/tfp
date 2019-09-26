//
//  TFTaskDetailCheckPeopleCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/16.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFTaskDetailCheckPeopleCell : HQBaseCell
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *checkPeople;
+(instancetype)taskDetailCheckPeopleCellWithTableView:(UITableView *)tableView;

-(void)refreshCheckPeopleWithEmployee:(HQEmployModel *)model;

@end

NS_ASSUME_NONNULL_END
