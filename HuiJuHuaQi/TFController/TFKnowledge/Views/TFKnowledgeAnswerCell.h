//
//  TFKnowledgeAnswerCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/12/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFKnowledgeItemModel.h"
@interface TFKnowledgeAnswerCell : UITableViewCell

+(instancetype)knowledgeAnswerCellWithTableView:(UITableView *)tableView;

-(void)refreshKnowledgeAnswerCellWithModel:(TFKnowledgeItemModel *)model;

/** 高度 */
+(CGFloat)refreshAnswerHeightWithModel:(TFKnowledgeItemModel *)model;
@end
