//
//  TFMaxMinValueCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@class TFMaxMinValueCell;

@protocol TFMaxMinValueCellDelegate <NSObject>

@optional

- (void)maxMinValueCell:(TFMaxMinValueCell *)maxMinValueCell withTextField:(UITextField *)textField;

@end


@interface TFMaxMinValueCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
+ (instancetype)maxMinValueCellWithTableView:(UITableView *)tableView;

/** dalegate */
@property (nonatomic, weak) id <TFMaxMinValueCellDelegate>delegate;
@end
