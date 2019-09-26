//
//  HQTFModelView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQRootModel.h"
#import "TFModuleModel.h"

@class HQTFModelView;
@protocol HQTFModelViewDelegate <NSObject>

- (void)modelView:(HQTFModelView *)modelView didSelectItem:(HQRootModel *)model;

- (void)modelView:(HQTFModelView *)modelView didSelectModule:(TFModuleModel *)model;

- (void)modelView:(HQTFModelView *)modelView didSelectModule:(TFModuleModel *)mode contentView:(id)view;

@end

@interface HQTFModelView : UIView

/** 是否可以拖拽 */
@property (nonatomic, assign , getter=isPan) BOOL pan;

/** 用于不同的操作 0：删除（最后一个不能移动），1：添加（最后一个不能移动），2：没有删除和添加（最后一个能移动） 3:有边框及拖拽手势 */
@property (nonatomic, assign) NSInteger cellType;

/** 操控modelType  0:我的应用  1:第三方应用 2：常用审批 3：全部审批 4：销售应用 5：商品应用 */
@property (nonatomic, assign) NSInteger modelType;

/** delegate */
@property (nonatomic, weak) id <HQTFModelViewDelegate>delegate;


/** 刷新 */
- (void)refreshModelViewWithModules:(NSArray *)modules;


@end
