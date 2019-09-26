//
//  TFAssistantListCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFAssistListModel.h"

@interface TFAssistantListCell : HQBaseCell

- (void)refreshAssistantListCellWithModel:(TFFMDBModel *)model type:(NSInteger) type name:(NSString *)name;

+ (instancetype)AssistantListCellWithTableView:(UITableView *)tableView;

+ (CGFloat)refreshAssistantCellHeightWithModel:(TFFMDBModel *)model;

@end
