
//
//  TFSelectMemoCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/1.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectMemoCell.h"

@interface TFSelectMemoCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *remaindBtn;


@end

@implementation TFSelectMemoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectBtn.userInteractionEnabled = NO;
    self.shareBtn.userInteractionEnabled = NO;
    self.remaindBtn.userInteractionEnabled = NO;
    self.titleLabel.textColor = LightBlackTextColor;
    self.timeLabel.textColor = ExtraLightBlackTextColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headMargin = 54;
}

- (void)refreshselectMemoCellWithModel:(TFNoteDataListModel *)model {
    
    self.titleLabel.text = model.title;
    
    self.timeLabel.text = [HQHelper nsdateToTime:[model.create_time longLongValue] formatStr:@"MM-dd HH:mm"];
    
    
    if ([model.pic_url isEqualToString:@""]) {
        
        self.firstImage.hidden = YES;
    }
    else {
        
        self.firstImage.hidden = NO;
        [self.firstImage sd_setImageWithURL:[NSURL URLWithString:[model.pic_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    
    //有共享人，或者创建人不为自己
    if ((![model.share_ids isEqualToString:@""] && model.share_ids != nil) || ![model.create_by isEqualToNumber:UM.userLoginInfo.employee.id]) {
        
        [self.shareBtn setImage:IMG(@"备忘录共享蓝") forState:UIControlStateNormal];
    }
    else {
        
        [self.shareBtn setImage:IMG(@"") forState:UIControlStateNormal];
    }
    
    if ([model.remind_time integerValue] > 0) {
        
        [self.remaindBtn setImage:IMG(@"备忘录铃铛") forState:UIControlStateNormal];
    }
    else {
        
        [self.remaindBtn setImage:IMG(@"") forState:UIControlStateNormal];
    }
    
    if ([model.isSelect isEqualToNumber:@1]) {
        self.selectBtn.selected = YES;
    }else{
        self.selectBtn.selected = NO;
    }
    
}

+ (instancetype)TFSelectMemoCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFSelectMemoCell" owner:self options:nil] lastObject];
}

+ (TFSelectMemoCell *)selectMemoCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFSelectMemoCell";
    TFSelectMemoCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self TFSelectMemoCell];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
