//
//  TFAlbumCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "HQCategoryItemModel.h"

@interface TFAlbumCell : HQBaseCell

-(void)refreshAlbumCellWithModel:(HQCategoryItemModel *)model;

+(instancetype)albumCellWithTableView:(UITableView *)tableView;

+ (CGFloat)refreshAlbumCellHeightWithModel:(HQCategoryItemModel *)model;
@end
