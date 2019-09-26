//
//  TFRuleLateCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/18.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFRuleLateCell : UITableViewCell

+(instancetype)ruleLateCellWithTableView:(UITableView *)tableView;

-(void)refreshRuleLateCellWithRows:(NSArray *)rows;
+(CGFloat)refreshRuleLateCellHeightWithRows:(NSArray *)rows;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, assign) NSInteger  type;

@end

NS_ASSUME_NONNULL_END
