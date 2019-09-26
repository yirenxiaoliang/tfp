//
//  TFNoteLocationCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteLocationCell.h"

@interface TFNoteLocationCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation TFNoteLocationCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.bgView.backgroundColor = HexColor(0xf8f8f8);
    self.bgView.layer.cornerRadius = 3;
    self.bgView.layer.masksToBounds = YES;
    self.titleLabel.textColor = ExtraLightBlackTextColor;
    self.detailLabel.textColor = LightGrayTextColor;
    self.titleLabel.font = FONT(14);
    self.detailLabel.font = FONT(11);
}
- (IBAction)deleteBtnClicked:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(noteLocationCellDidDeleteBtn:)]) {
        [self.delegate noteLocationCellDidDeleteBtn:sender];
    }
}

+ (instancetype)noteLocationCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFNoteLocationCell" owner:self options:nil] lastObject];
}



+ (instancetype)noteLocationCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFNoteLocationCell";
    TFNoteLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self noteLocationCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    cell.topLine.hidden = YES;
    return cell;
}

-(void)refreshNoteLocationCellWithModel:(TFLocationModel *)parameter{
    
    
    self.titleLabel.text = parameter.name;
    self.detailLabel.text = parameter.totalAddress;
    
    if (parameter.totalAddress.length) {
        
        self.detailLabel.text = [NSString stringWithFormat:@"%@",parameter.totalAddress];
    }else{
        
        self.detailLabel.text = [NSString stringWithFormat:@"%@",parameter.detailAddress];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
