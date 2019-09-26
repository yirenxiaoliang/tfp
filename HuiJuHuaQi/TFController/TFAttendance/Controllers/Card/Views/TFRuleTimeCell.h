//
//  TFRuleTimeCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/18.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TFRuleTimeCellDelegate <NSObject>

@optional
-(void)ruleTimeCellDidClickedDesc;

@end

@interface TFRuleTimeCell : UITableViewCell


@property (nonatomic, weak) id delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

+(instancetype)ruleTimeCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
