//
//  HQTFProjectProcessCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFProjectItem.h"

@interface HQTFProjectProcessCell : HQBaseCell

/** rate */
@property (nonatomic, assign) CGFloat rate;

@property (weak, nonatomic) IBOutlet UIImageView *groundImage;

+ (HQTFProjectProcessCell *)projectProcessCellWithTableView:(UITableView *)tableView;

- (void)refreshProjectProcessCellWithModel:(TFProjectItem *)model type:(NSInteger)type;

@end
