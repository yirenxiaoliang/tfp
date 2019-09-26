//
//  TFBusinessCardCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFBusinessCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

+ (TFBusinessCardCell *)businessCardCellWithTableView:(UITableView *)tableView;

- (void)refreshBusinessCardCellWithType:(NSInteger)type;

@end
