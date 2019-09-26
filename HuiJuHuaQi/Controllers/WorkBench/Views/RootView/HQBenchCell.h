//
//  HQBenchCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/6/29.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQRootModel.h"

@class HQBenchCell;

@protocol HQBenchCellDelegate <NSObject>

@required
/** 点击某模块时传递出数据 */
- (void)benchCell:(HQBenchCell *)benchCell didSelectItem:(HQRootModel *)rootModel withAllData:(NSArray *)allData;
@optional
/** 数据变化时传递出所有数据 */
- (void)benchCell:(HQBenchCell *)benchCell withAllData:(NSArray *)allData;
/** 用于cell删除时刷新 */
- (void)deleteCollectionCellFresh;
@end

@interface HQBenchCell : UITableViewCell
+ (HQBenchCell *)benchCellWithTableView:(UITableView *)tableView withType:(NSInteger)type;
//@property (nonatomic , strong)HQMainfaceNoReadCountModel *mainface;
@property (nonatomic , weak) id <HQBenchCellDelegate> delegate;
@property (nonatomic , strong) NSMutableArray *items;
@end
