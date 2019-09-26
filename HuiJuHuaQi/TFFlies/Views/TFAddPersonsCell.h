//
//  TFAddPersonsCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFAddPersonsCellDelegate <NSObject>

@optional
- (void)addManagers:(NSInteger)tag;

@end

@interface TFAddPersonsCell : HQBaseCell

+ (instancetype)AddPersonsCellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id <TFAddPersonsCellDelegate>delegate;

@end
