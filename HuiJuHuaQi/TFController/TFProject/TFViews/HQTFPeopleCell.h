//
//  HQTFPeopleCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface HQTFPeopleCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UILabel *requireLabel;
@property (weak, nonatomic) IBOutlet UIImageView *enterImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/** 人员 */
@property (nonatomic, strong) NSArray *peoples;
+ (HQTFPeopleCell *)peopleCellWithTableView:(UITableView *)tableView;

@end
