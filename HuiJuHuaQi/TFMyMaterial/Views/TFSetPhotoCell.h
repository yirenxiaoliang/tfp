//
//  TFSetPhotoCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFSetPhotoCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@property (weak, nonatomic) IBOutlet UIImageView *photoImg;

+ (instancetype)SetPhotoCellWithTableView:(UITableView *)tableView;

@end
