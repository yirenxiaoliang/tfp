//
//  HQTFTaskTableViewCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFProjTaskModel.h"
@class HQTFTaskTableViewCell;
@protocol HQTFTaskTableViewCellDelegate <NSObject>

@optional
-(void)taskTableViewCell:(HQTFTaskTableViewCell *)taskCell didDownBtnWithModel:(TFProjTaskModel *)model;
-(void)taskTableViewCell:(HQTFTaskTableViewCell *)taskCell didFinishBtn:(UIButton *)button withModel:(TFProjTaskModel *)model;

@end


@interface HQTFTaskTableViewCell : UITableViewCell

+ (HQTFTaskTableViewCell *)taskTableViewCellWithTableView:(UITableView *)tableView;

-(void)refreshTaskTableViewCellWithModel:(TFProjTaskModel *)model type:(NSInteger)type;

+(CGFloat)refreshTaskTableViewCellHeightWithModel:(TFProjTaskModel *)model type:(NSInteger)type;

/** Delegate */
@property (nonatomic, weak) id<HQTFTaskTableViewCellDelegate>delegate;

@end
