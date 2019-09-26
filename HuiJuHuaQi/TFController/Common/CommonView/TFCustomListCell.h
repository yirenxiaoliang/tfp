//
//  TFCustomListCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/8.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFCustomListItemModel.h"

@interface TFCustomListCell : HQBaseCell

+ (instancetype)customListCellWithTableView:(UITableView *)tableView;

-(void)refreshCustomListCellWithModel:(TFCustomListItemModel *)model;
+(CGFloat)refreshCustomListCellHeightWithModel:(TFCustomListItemModel *)model;

/** select */
@property (nonatomic, assign) BOOL select;



@end
