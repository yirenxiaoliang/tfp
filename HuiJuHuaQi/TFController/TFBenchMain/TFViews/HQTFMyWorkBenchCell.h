//
//  HQTFMyWorkBenchCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/1.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFWorkBenchModel.h"
#import "TFApprovalItemModel.h"

@class TFProjTaskModel;

@protocol HQTFMyWorkBenchCellDelegate <NSObject>

@optional
-(void)myWorkBenchCellWithScrollView:(UIScrollView *)scrollView;
-(void)myWorkBenchCellWithSelectIndex:(NSInteger)selectIndex;


-(void)myWorkBenchCellDidDownBtnWithSelectIndex:(NSInteger)selectIndex withModel:(id)model;

-(void)myWorkBenchCellDidFinishBtn:(UIButton *)button withModel:(TFProjTaskModel *)model;

-(void)myWorkBenchCellDidClickedTask:(TFProjTaskModel *)model;

-(void)myWorkBenchCellDidClickedApproval:(TFApprovalItemModel *)model;




@end

@interface HQTFMyWorkBenchCell : HQBaseCell

+ (HQTFMyWorkBenchCell *)myWorkBenchCellWithTableView:(UITableView *)tableView;

-(void)refreshMyWorkBenchCellWithModel:(TFWorkBenchModel *)model;

/** delegate */
@property (nonatomic, weak) id<HQTFMyWorkBenchCellDelegate>delegate;

/** selectIndex */
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic,assign) BOOL open;


/** 二维数组，任务列表 */
@property (nonatomic, strong) NSMutableArray *taskList;

@end
