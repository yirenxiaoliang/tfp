//
//  TFTaskRowNameCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskRowNameCell.h"

@interface TFTaskRowNameCell ()<UITextViewDelegate>


@end

@implementation TFTaskRowNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.font = FONT(17);
//    [self.textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.minusBtn addTarget:self action:@selector(minusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.moveImage.hidden = YES;
    self.textField.delegate = self;
}

- (void)minusBtnClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(taskRowNameCellDidMinusBtn:)]) {
        [self.delegate taskRowNameCellDidMinusBtn:button];
    }
}

-(void)textViewDidChange:(HQAdviceTextView *)textField{
    
    if ([self.delegate respondsToSelector:@selector(textFieldTextChange:)]) {
        [self.delegate textFieldTextChange:textField];
    }
}

+ (instancetype)TFTaskRowNameCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFTaskRowNameCell" owner:self options:nil] lastObject];
}

+ (TFTaskRowNameCell *)taskRowNameCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFTaskRowNameCell";
    TFTaskRowNameCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self TFTaskRowNameCell];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
