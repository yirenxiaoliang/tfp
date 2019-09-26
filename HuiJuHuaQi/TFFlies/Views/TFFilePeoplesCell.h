//
//  TFFilePeoplesCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/5/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFFilePeoplesCellDelegate <NSObject>

@optional
- (void)addFilePeoples;

@end

@interface TFFilePeoplesCell : HQBaseCell

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *requireLab;

@property (nonatomic, weak) id <TFFilePeoplesCellDelegate>delegate;

+(instancetype)filePeopleCellWithTableView:(UITableView *)tableView;
/** 刷新cell
 *  @param items 人员数组
 *  @param type  类型 0：无加减号  1：有加号  2：有加减号
 *  @param column  一行几个
 */
-(void)refreshCellWithItems:(NSArray *)items withType:(NSInteger)type withColumn:(NSInteger)column;
+(CGFloat)refreshFileCellHeightWithItems:(NSArray *)items withType:(NSInteger)type withColumn:(NSInteger)column;


@end
