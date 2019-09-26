//
//  TFTaskRelationCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFProjectSectionModel;

@protocol TFTaskRelationCellDelegate <NSObject>
@optional
-(void)taskRelationCellDidShow:(id)model;
-(void)taskRelationCellLongPressItem:(TFProjectSectionModel *)model taskIndex:(NSInteger)taskIndex;
-(void)taskRelationCellDidClickedItem:(TFProjectRowModel *)model;


@end

@interface TFTaskRelationCell : UITableViewCell

/** delegate */
@property (nonatomic, weak) id <TFTaskRelationCellDelegate>delegate;

+ (TFTaskRelationCell *)taskRelationCellWithTableView:(UITableView *)tableView;

-(void)refreshTaskRelationCellWithModel:(TFProjectSectionModel *)model auth:(BOOL)auth;
+(CGFloat)refreshTaskRelationCellHeightWithModel:(id)model;

@end
