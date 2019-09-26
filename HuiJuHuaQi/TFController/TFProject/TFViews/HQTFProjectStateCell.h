//
//  HQTFProjectStateCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

/** 项目状态：0进行中（创建一开始就是进入进行中）、1已完成、2暂停3回收站 */
typedef enum{
    ProjectStateCellGoOn,
    ProjectStateCellFinish,
    ProjectStateCellPause,
    ProjectStateCellDelete,
    ProjectStateCellOutDate
}ProjectStateCellType;

@interface HQTFProjectStateCell : HQBaseCell

+ (HQTFProjectStateCell *)projectStateCellWithTableView:(UITableView *)tableView;

/** ProjectStateCellType */
@property (nonatomic, assign ) ProjectStateCellType type;

@end
