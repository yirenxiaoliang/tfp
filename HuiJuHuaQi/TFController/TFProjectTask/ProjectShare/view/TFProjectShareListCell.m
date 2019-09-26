//
//  TFProjectShareListCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectShareListCell.h"

@interface TFProjectShareListCell ()


@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *shareImgV;

@end

@implementation TFProjectShareListCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.photoBtn.layer.cornerRadius = 45/2.0;
    self.photoBtn.layer.masksToBounds = YES;
    
}

- (void)refreshProjectShareListCellWithData:(TFProjectShareInfoModel *)model {

    self.titleLab.text = model.share_title;
    self.contentLab.text = [HQHelper filterHTML:model.share_content];
    
    self.timeLab.text = [HQHelper nsdateToTimeNowYear:[model.create_time longLongValue]];
    
    if (![model.employee_pic isEqualToString:@""]) {
        
        [self.photoBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.employee_pic] forState:UIControlStateNormal];
        [self.photoBtn setTitle:@"" forState:UIControlStateNormal];
    }
    else {
        
        [self.photoBtn sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
        [self.photoBtn setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
        [self.photoBtn setTitleColor:kUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [self.photoBtn setBackgroundColor:GreenColor];
    }

//    [self.photoBtn sd_setImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
    
    self.shareImgV.image = IMG(@"备忘录共享蓝");
//    NSArray *arr = [model.share_ids componentsSeparatedByString:@","];
//    BOOL have = NO;
//    for (NSString *st in arr) {
//        if ([st isEqualToString:[UM.userLoginInfo.employee.id description]]) {
//            have = YES;
//            break;
//        }
//    }
    if (model.share_ids.length) {
        
        self.shareImgV.hidden = NO;
    }
    else {
    
        self.shareImgV.hidden = YES;
    }
    
//    if ([model.top_status isEqualToString:@"1"]) {
//
//        self.backgroundColor = HexAColor(0x20779A, 0.1);
//    }
//    else {
//
//        self.backgroundColor = kUIColorFromRGB(0xFFFFFF);
//    }
}

+ (instancetype)TFProjectShareListCell {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"TFProjectShareListCell" owner:self options:nil] lastObject];
}

+ (instancetype)projectShareListCellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"TFProjectShareListCell";
    TFProjectShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFProjectShareListCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    cell.topLine.hidden = YES;
    return cell;
}

@end
