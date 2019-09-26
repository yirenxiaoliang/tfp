//
//  TFProjectListCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFProjectModel.h"

@protocol TFProjectListCellDelegate<NSObject>
@optional
-(void)projectListCellDidClickedStarBtn:(UIButton *)starBtn;

@end

@interface TFProjectListCell : UITableViewCell

/** delegate */
@property (nonatomic, weak) id <TFProjectListCellDelegate>delegate;

+ (TFProjectListCell *)projectListCellWithTableView:(UITableView *)tableView;

- (void)refreshProjectListCellWithProjectModel:(TFProjectModel *)model;

@end
