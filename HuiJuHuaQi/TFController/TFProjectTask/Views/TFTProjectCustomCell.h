//
//  TFTProjectCustomCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/21.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFProjectRowFrameModel.h"

@interface TFTProjectCustomCell : UITableViewCell

+(instancetype)projectCustomCellWithTableView:(UITableView *)tableView;
@property (nonatomic, assign) NSInteger knowledge;
/** frameModel */
@property (nonatomic, strong) TFProjectRowFrameModel *frameModel;
@end
