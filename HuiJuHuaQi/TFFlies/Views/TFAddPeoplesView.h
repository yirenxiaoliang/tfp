//
//  TFAddPeoplesView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQEmployModel.h"
#import "TFManageItemModel.h"
#import "TFRoleModel.h"

@protocol TFAddPeoplesViewDelegate <NSObject>

@optional

- (void)addFolderPeoples;

@end

@interface TFAddPeoplesView : UIView

/** 刷新人 */
-(void)refreshPeopleViewWithEmployee:(HQEmployModel *)employee;

/** 刷新角色*/
-(void)refreshRoleViewWithEmployee:(TFRoleModel *)employee;

-(void)refreshPeopleViewWithManagers:(TFManageItemModel *)employee;

/** +样式 */
-(void)refreshAddType;

@property (nonatomic, weak) id <TFAddPeoplesViewDelegate>delegate;

@end
