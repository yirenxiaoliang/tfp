//
//  TFModelsCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFApplicationModel.h"
#import "TFModelView.h"

@class TFModelsCell;

@protocol TFModelsCellDelegate <NSObject>

@optional
-(void)modelsCell:(TFModelsCell *)modelsCell didClickedModelView:(TFModelView *)modelView application:(TFApplicationModel *)application module:(TFModuleModel *)module;

-(void)modelsCell:(TFModelsCell *)modelsCell didClickedAddModule:(TFModuleModel *)module;
-(void)modelsCell:(TFModelsCell *)modelsCell didClickedMinusModule:(TFModuleModel *)module;

@end

@interface TFModelsCell : HQBaseCell

+(instancetype)modelsCellWithTableView:(UITableView *)tableView;
/** nameLabel */
@property (nonatomic, weak) UILabel *nameLabel;
/** delegate */
@property (nonatomic, weak) id <TFModelsCellDelegate>delegate;

/** 常用模块 */
-(void)refreshModelsCellWithOftenApplication:(TFApplicationModel *)application;
/** 系统模块 */
-(void)refreshModelsCellWithApplication:(TFApplicationModel *)application type:(NSInteger)type oftenApplication:(TFApplicationModel *)oftenApplication;
/** 模块高度 */
+ (CGFloat)modelsCellWithApplication:(TFApplicationModel *)application showTitle:(BOOL)showTitle;

/** 应用 */
-(void)refreshModelsCellWithApplications:(NSArray *)applications type:(NSInteger)type;
/** 应用高度 */
+ (CGFloat)modelsCellWithApplications:(NSArray *)applications;



@end
