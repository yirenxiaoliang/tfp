//
//  HQTFTimePointCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol HQTFTimePointCellDelegate <NSObject>

@optional
-(void)timePointCellWithDate:(NSDate *)date;
@end

@interface HQTFTimePointCell : HQBaseCell

+(instancetype)timePointCellWithTableView:(UITableView *)tableView;
/** delegate */
@property (nonatomic, weak) id <HQTFTimePointCellDelegate>delegate;

/** 时间 */
@property (nonatomic, strong) NSDate *startSelectDate;

@end
