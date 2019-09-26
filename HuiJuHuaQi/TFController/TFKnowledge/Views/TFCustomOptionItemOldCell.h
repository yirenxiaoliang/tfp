//
//  TFCustomOptionItemOldCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/4.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol TFCustomOptionItemOldCellDelegate <NSObject>

@optional

-(void)customOptionItemCellDidClickedRightBtn:(UIButton *)rightBtn;

@end

@interface TFCustomOptionItemOldCell : UITableViewCell

/** edit */
@property (nonatomic, assign) BOOL edit;

/** 右边图片 */
@property (nonatomic, weak) UIButton *rightBtn;

/** 展示样式 YES：编辑样式  NO: 详情样式 */
@property (nonatomic, assign) BOOL showEdit;
/** delegate */
@property (nonatomic, weak) id <TFCustomOptionItemOldCellDelegate>delegate;

/** 创建cell */
+(instancetype)customOptionItemCellWithTableView:(UITableView *)tableView;

/** 刷新 */
-(void)refreshCustomOptionItemCellWithOptions:(NSArray *)options;

/** 高度 */
+(CGFloat)refreshCustomOptionItemCellHeightWithOptions:(NSArray *)options;

@end

NS_ASSUME_NONNULL_END
