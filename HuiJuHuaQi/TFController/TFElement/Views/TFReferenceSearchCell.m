//
//  TFReferenceSearchCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/10/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFReferenceSearchCell.h"
#import "TFReferenceListModel.h"

@interface TFReferenceSearchCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *row1LeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *row1RightLabel;
@property (weak, nonatomic) IBOutlet UILabel *row2LeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *row2RightLabel;
@property (weak, nonatomic) IBOutlet UILabel *row3LeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *row3RightLabel;

@end

@implementation TFReferenceSearchCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.nameLabel.font = FONT(16);
    self.nameLabel.textColor = LightBlackTextColor;
    
    self.row1LeftLabel.font = FONT(12);
    self.row1LeftLabel.textColor = FinishedTextColor;
    
    self.row1RightLabel.font = FONT(12);
    self.row1RightLabel.textColor = ExtraLightBlackTextColor;
    self.row1RightLabel.textAlignment = NSTextAlignmentLeft;
    
    self.row2LeftLabel.font = FONT(12);
    self.row2LeftLabel.textColor = FinishedTextColor;
    
    self.row2RightLabel.font = FONT(12);
    self.row2RightLabel.textColor = ExtraLightBlackTextColor;
    self.row2RightLabel.textAlignment = NSTextAlignmentLeft;
    
    self.row3LeftLabel.font = FONT(12);
    self.row3LeftLabel.textColor = FinishedTextColor;
    
    self.row3RightLabel.font = FONT(12);
    self.row3RightLabel.textColor = ExtraLightBlackTextColor;
    self.row3RightLabel.textAlignment = NSTextAlignmentLeft;
    
}


+ (instancetype)referenceSearchCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFReferenceSearchCell" owner:self options:nil] lastObject];
}


+ (instancetype)referenceSearchCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFReferenceSearchCell";
    TFReferenceSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self referenceSearchCell];
    }
    cell.layer.masksToBounds = YES;
    cell.bottomLine.hidden = YES;
    return cell;
}

/** 刷新 */
-(void)refreshCellWithRows:(NSArray *)rows{
    

    self.nameLabel.hidden = YES;
    self.row1LeftLabel.hidden = YES;
    self.row1RightLabel.hidden = YES;
    self.row2LeftLabel.hidden = YES;
    self.row2RightLabel.hidden = YES;
    self.row3LeftLabel.hidden = YES;
    self.row3RightLabel.hidden = YES;
    
    for (NSInteger i = 0 ; i < rows.count; i ++) {
        TFFieldNameModel *model = rows[i];
        if (i == 0) {
            self.nameLabel.hidden = NO;
            self.nameLabel.text = [HQHelper stringWithFieldNameModel:model];
        }else if (i == 1){
            self.row1LeftLabel.hidden = NO;
            self.row1RightLabel.hidden = NO;
            self.row1LeftLabel.text = model.label;
            self.row1RightLabel.text = [HQHelper stringWithFieldNameModel:model];
            
        }else if (i == 2){
            self.row2LeftLabel.hidden = NO;
            self.row2RightLabel.hidden = NO;
            self.row2LeftLabel.text = model.label;
            self.row2RightLabel.text = [HQHelper stringWithFieldNameModel:model];
            
        }else{
            self.row3LeftLabel.hidden = NO;
            self.row3RightLabel.hidden = NO;
            self.row3LeftLabel.text = model.label;
            self.row3RightLabel.text = [HQHelper stringWithFieldNameModel:model];
        }
        
    }
    
}

+(CGFloat)refreshCellHeightWithRows:(NSArray *)rows{
    
    CGFloat height = 0;
    
    if (rows.count >= 4) {
        height = 103;
    }else if (rows.count == 3) {
        height = 92;
    }else if (rows.count == 2){
        
        height = 64;
    }else if (rows.count == 1){
        
        height = 40;
    }
    
    return height;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
