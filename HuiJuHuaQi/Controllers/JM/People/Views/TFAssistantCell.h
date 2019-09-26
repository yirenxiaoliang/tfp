//
//  TFAssistantCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/26.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFAssistantFrameModel.h"

@interface TFAssistantCell : HQBaseCell

+(instancetype)assistantCellWithTableView:(UITableView *)tableView;

-(void)refreshAssistantCellWithAssistantFrameModel:(TFAssistantFrameModel *)model;


@end
