//
//  TFKnowledgeFilterItemCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/24.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TFKnowledgeFilterItemCell;
@protocol TFKnowledgeFilterItemCellDelegate <NSObject>

@optional
-(void)filterItemCellDidSelectBtn:(TFKnowledgeFilterItemCell *)cell;

@end

@interface TFKnowledgeFilterItemCell : HQBaseCell

+(instancetype)knowledgeFilterItemCellWithTableView:(UITableView *)tableView;
-(void)refreshKnowledgeFilterItemCellWithCategory:(TFCategoryModel *)model;
-(void)refreshKnowledgeFilterItemCellWithLabel:(TFCategoryModel *)model;

-(void)refreshKnowledgeFilterItemCellWithName:(TFCategoryModel *)model;
@property (nonatomic, weak) id <TFKnowledgeFilterItemCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
