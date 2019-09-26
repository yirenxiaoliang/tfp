//
//  TFCompanyCircleDetailStarCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "HQEmployModel.h"
@protocol TFCompanyCircleDetailStarCellDelegate <NSObject>

@optional
- (void)companyCircleDetailStarCellDidPeople:(HQEmployModel *)employ;

@end

@interface TFCompanyCircleDetailStarCell : HQBaseCell

+(instancetype)companyCircleDetailStarCellWithTableView:(UITableView *)tableView;

-(void)refreshCompanyCircleDetailStarCellWithPeoples:(NSArray *)peoples;

+ (CGFloat)refreshCompanyCircleDetailStarCellHeightWithPeoples:(NSArray *)peoples;

/** delegate */
@property (nonatomic, weak) id<TFCompanyCircleDetailStarCellDelegate>delegate;


@end
