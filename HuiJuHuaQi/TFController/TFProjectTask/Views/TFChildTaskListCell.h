//
//  TFChildTaskListCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQBaseCell.h"

@protocol TFChildTaskListCellDelegate<NSObject>

@optional
-(void)childTaskDidFinishedWithModel:(id)model;
-(void)childTaskDidSelectedWithModel:(id)model;
-(void)addChildTask;

@end

@interface TFChildTaskListCell : HQBaseCell

/** delegate */
@property (nonatomic, weak) id <TFChildTaskListCellDelegate>delegate;

+ (TFChildTaskListCell *)childTaskListCellWithTableView:(UITableView *)tableView;

-(void)refreshChildTaskListCellWithModels:(id)model add:(BOOL)add;
+(CGFloat)refreshChildTaskListCellHeightWithModels:(id)model add:(BOOL)add;

@end
