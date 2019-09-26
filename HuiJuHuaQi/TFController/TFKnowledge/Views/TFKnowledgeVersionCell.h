//
//  TFKnowledgeVersionCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/12/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFKnowledgeVersionModel.h"

@interface TFKnowledgeVersionCell : HQBaseCell

+(instancetype)knowledgeVersionCellWithTableView:(UITableView *)tableView;

/** select */
@property (nonatomic, assign) BOOL select;

-(void)refreshCellWithModel:(TFKnowledgeVersionModel *)model;

@end
