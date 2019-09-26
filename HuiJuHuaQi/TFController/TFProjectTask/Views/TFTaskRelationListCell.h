//
//  TFTaskRelationListCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQBaseCell.h"
#import "TFProjectSectionModel.h"

@protocol TFTaskRelationListCellDelegate <NSObject>
@optional
-(void)taskRelationListCellDidShow;
-(void)taskRelationListLongPressWithModel:(TFProjectSectionModel *)model taskIndex:(NSInteger)taskIndex;
-(void)taskRelationListDidClickedModel:(TFProjectRowModel *)model;
-(void)addTaskRelation;


@end

@interface TFTaskRelationListCell : HQBaseCell

/** delegate */
@property (nonatomic, weak) id <TFTaskRelationListCellDelegate>delegate;

+ (TFTaskRelationListCell *)taskRelationListCellWithTableView:(UITableView *)tableView;

-(void)refreshTaskRelationListCellWithModels:(id)model type:(NSInteger)type auth:(BOOL)auth;
+(CGFloat)refreshTaskRelationListCellHeightWithModels:(id)model type:(NSInteger)type;

@end
