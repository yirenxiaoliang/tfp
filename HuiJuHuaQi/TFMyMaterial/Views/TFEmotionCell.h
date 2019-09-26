//
//  TFEmotionCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/5/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFEmotionCellDelegate<NSObject>

@optional
-(void)emotionCellDidClearBtn;

@end

@interface TFEmotionCell : HQBaseCell

- (void)refreshEmotionCellWithData:(NSString *)emotion;
/** delegate */
@property (nonatomic, weak) id <TFEmotionCellDelegate>delegate;

+ (instancetype)EmotionCellWithTableView:(UITableView *)tableView;

@end
