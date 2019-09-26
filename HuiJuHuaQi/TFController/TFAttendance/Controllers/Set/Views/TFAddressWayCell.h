//
//  TFAddressWayCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFAtdWatDataListModel.h"
#import "TFAtdClassModel.h"
#import "TFReferenceApprovalModel.h"

@protocol TFAddressWayCellDelegate <NSObject>

@optional
- (void)deleteClicked:(NSInteger)index;

@end


@interface TFAddressWayCell : HQBaseCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameBottomCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTopCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLabCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressTopCons;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@property (nonatomic, assign) NSInteger index;

@property (nonatomic,assign) NSInteger cellType;
@property (nonatomic, weak) id <TFAddressWayCellDelegate>delegate;
//配置数据
- (void)configAddressWayCellWithTableView:(TFAtdWatDataListModel *)model;

+ (instancetype)addressWayCellWithTableView:(UITableView *)tableView;

//配置WiFi考勤数据
- (void)configWiFiWayCellWithTableView:(TFAtdWatDataListModel *)model;

//配置班次管理考勤数据
- (void)configClassesManagerCellWithTableView:(TFAtdClassModel *)model;

//配置关联审批单数据
- (void)configRelatedApprovalCellWithModel:(TFReferenceApprovalModel *)model;

//配置新增WiFi考勤数据
- (void)configAddWiFiPCCellWithTableView:(NSInteger)select;

@end
