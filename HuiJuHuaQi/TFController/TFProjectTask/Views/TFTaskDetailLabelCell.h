//
//  TFTaskDetailLabelCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/17.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFTaskDetailLabelCell : HQBaseCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
/** 刷新 */
-(void)refreshTaskDetailLabelCellWithOptions:(NSArray *)options;
/** 高度 */
+(CGFloat)refreshTaskDetailLabelCellHeightWithOptions:(NSArray *)options;

+(instancetype)taskDetailLabelCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
