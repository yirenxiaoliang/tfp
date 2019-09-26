//
//  HQTFMorePeopleCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface HQTFMorePeopleCell : HQBaseCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
/** show */
@property (nonatomic, assign) BOOL imageHidden;

@property (nonatomic, strong) UILabel *requireLabel;

+ (HQTFMorePeopleCell *)morePeopleCellWithTableView:(UITableView *)tableView;

-(void)refreshMorePeopleCellWithPeoples:(NSArray *)peoples;

/** 投诉建议 */
-(void)refreshMorePeopleCellWithAdvisePeoples:(NSArray *)peoples;
@end
