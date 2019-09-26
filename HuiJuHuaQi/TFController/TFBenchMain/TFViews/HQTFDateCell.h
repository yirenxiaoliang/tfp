//
//  HQTFDateCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQTFDateCell : UITableViewCell

+ (HQTFDateCell *)dateCellWithTableView:(UITableView *)tableView;

/** date */
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, assign, getter=isRedSelected) BOOL redSelected;

@end
