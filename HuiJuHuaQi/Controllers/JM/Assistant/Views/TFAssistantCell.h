//
//  TFAssistantCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/26.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFAssistantFrameModel.h"
@class TFAssistantCell;
@protocol TFAssistantCellDelegate <NSObject>

@optional
- (void)assistantCell:(TFAssistantCell *)assistantCell didClikedFlagWithModel:(TFAssistantModel *)model;

@end

@interface TFAssistantCell : HQBaseCell

+(instancetype)assistantCellWithTableView:(UITableView *)tableView;

-(void)refreshAssistantCellWithAssistantFrameModel:(TFAssistantFrameModel *)model;

/** delegate */
@property (nonatomic, weak) id <TFAssistantCellDelegate>delegate;
@end
