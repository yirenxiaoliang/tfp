//
//  TFTaskRowNameCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "HQAdviceTextView.h"

@protocol TFTaskRowNameCellDelegate <NSObject>
@optional
-(void)textFieldTextChange:(HQAdviceTextView *)textField;
-(void)taskRowNameCellDidMinusBtn:(UIButton *)button;

@end

@interface TFTaskRowNameCell : HQBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *moveImage;
@property (weak, nonatomic) IBOutlet HQAdviceTextView *textField;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textHeadW;

+ (TFTaskRowNameCell *)taskRowNameCellWithTableView:(UITableView *)tableView;

/** delegate */
@property (nonatomic, weak) id <TFTaskRowNameCellDelegate>delegate;

@end
