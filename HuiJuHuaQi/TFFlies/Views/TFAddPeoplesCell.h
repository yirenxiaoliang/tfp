//
//  TFAddPeoplesCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFAddPeoplesCellDelegate <NSObject>

@optional
- (void)addPersonel:(NSInteger)index;

@end

@interface TFAddPeoplesCell : HQBaseCell

/** UILabel *lable */
@property (nonatomic, weak) UILabel *titleLabel;

/** requireLabel */
@property (nonatomic, weak) UILabel *requireLabel;

/** fieldControl */
@property (nonatomic, copy) NSString *fieldControl;
/** 高度 */
+(CGFloat)refreshAddPeoplesCellHeightWithStructure:(NSString *)structure;

/** 刷新人员 */
-(void)refreshAddPeoplesCellWithPeoples:(NSArray *)peoples structure:(NSString *)structure chooseType:(NSString *)chooseType showAdd:(BOOL)showAdd row:(NSInteger)row;
/** 创建cell */
+ (instancetype)AddPeoplesCellWithTableView:(UITableView *)tableView;

/** 刷新角色 */
-(void)refreshAddRolesCellWithPeoples:(NSArray *)peoples structure:(NSString *)structure chooseType:(NSString *)chooseType showAdd:(BOOL)showAdd row:(NSInteger)row;
@property (nonatomic, weak) id <TFAddPeoplesCellDelegate>delegate;

@end
