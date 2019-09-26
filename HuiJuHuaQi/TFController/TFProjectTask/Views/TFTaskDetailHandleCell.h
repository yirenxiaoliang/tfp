//
//  TFTaskDetailHandleCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/16.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFTaskDetailHandleCellDelegate <NSObject>

@optional
-(void)addStartTime;
-(void)addEndTime;

@end

@interface TFTaskDetailHandleCell : HQBaseCell

-(void)refreshTaskDetailHandleCellWithStartTime:(long long)startTime endTime:(long long)endTime;

@property (nonatomic, weak) id <TFTaskDetailHandleCellDelegate>delegate;

+(instancetype)taskDetailHandleCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
