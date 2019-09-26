//
//  TFProjectResponsibleCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFProjectResponsibleCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *enterImage;
@property (weak, nonatomic) IBOutlet UIButton *headImage;

+ (instancetype)projectResponsibleCellWithTableView:(UITableView *)tableView;
@end
