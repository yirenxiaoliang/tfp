//
//  TFEnterMoveCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/21.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEnterMoveCell.h"

@interface TFEnterMoveCell ()
@property (weak, nonatomic) IBOutlet UIButton *handleBtn;
@property (weak, nonatomic) IBOutlet UIButton *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipImage;


@property (nonatomic, strong) TFModuleModel *module;

@end

@implementation TFEnterMoveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImage.layer.cornerRadius = 4;
    self.headImage.layer.masksToBounds = YES;
    
    self.nameLabel.textColor = LightBlackTextColor;
    self.nameLabel.font = FONT(14);
    self.tipImage.image = IMG(@"邮件菜单");
    self.nameLabel.text = @"";
}
- (IBAction)handleClicked:(UIButton *)sender {
    
    NSInteger index = self.tag % 0x999;
    if (self.tag >= 0x999) {
        
        if ([self.delegate respondsToSelector:@selector(enterMoveCellDidClickedAddWithModule:index:)]) {
            [self.delegate enterMoveCellDidClickedAddWithModule:self.module index:index];
        }
    }else{
        
        if ([self.delegate respondsToSelector:@selector(enterMoveCellDidClickedMinusWithModule:index:)]) {
            [self.delegate enterMoveCellDidClickedMinusWithModule:self.module index:index];
        }
    }
    
}

-(void)setType:(NSInteger)type{
    _type = type;
    
    if (type == 0) {
        [self.handleBtn setImage:IMG(@"enterMinus") forState:UIControlStateNormal];
        self.tipImage.hidden = NO;
    }else{
        [self.handleBtn setImage:IMG(@"enterAdd") forState:UIControlStateNormal];
        self.tipImage.hidden = YES;
    }
}

-(void)refreshEnterMoveCellWithModel:(TFModuleModel *)module{
    self.module = module;
    self.headImage.backgroundColor = WhiteColor;
    self.nameLabel.text = module.chinese_name;
    if ([module.english_name isEqualToString:@"data"]) {
        [self.headImage setBackgroundImage:IMG(@"数据") forState:UIControlStateNormal];
    }else if ([module.english_name isEqualToString:@"project"]){
        [self.headImage setBackgroundImage:IMG(@"协作") forState:UIControlStateNormal];
    }else if ([module.english_name isEqualToString:@"memo"]){
        [self.headImage setBackgroundImage:IMG(@"备忘录") forState:UIControlStateNormal];
    }else if ([module.english_name isEqualToString:@"repository_libraries"]){
        [self.headImage setBackgroundImage:IMG(@"知识库") forState:UIControlStateNormal];
    }else if ([module.english_name isEqualToString:@"library"]){
        [self.headImage setBackgroundImage:IMG(@"文件库") forState:UIControlStateNormal];
    }else if ([module.english_name isEqualToString:@"email"]){
        [self.headImage setBackgroundImage:IMG(@"邮件") forState:UIControlStateNormal];
    }else if ([module.english_name isEqualToString:@"approval"]){
        [self.headImage setBackgroundImage:IMG(@"审批") forState:UIControlStateNormal];
    }else if ([module.english_name isEqualToString:@"attendance"]){
        [self.headImage setBackgroundImage:IMG(@"考勤") forState:UIControlStateNormal];
    }else if ([module.english_name isEqualToString:@"salary"]){
        [self.headImage setBackgroundImage:IMG(@"薪酬") forState:UIControlStateNormal];
    }else if ([module.english_name containsString:@"bean"]){
        if ([module.icon_type isEqualToString:@"1"]) {// 网络图片
            [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:module.icon_url] forState:UIControlStateNormal];
            self.headImage.contentMode = UIViewContentModeScaleToFill;
        }else{// 本地图片
            if (module.icon && ![module.icon isEqualToString:@""] && ![module.icon isEqualToString:@"null"]) {
                [self.headImage setImage:IMG(module.icon) forState:UIControlStateNormal];
                self.headImage.backgroundColor = [HQHelper colorWithHexString:module.icon_color]?[HQHelper colorWithHexString:module.icon_color]:GreenColor;
            }else if (module.icon_url && ![module.icon_url isEqualToString:@""] && ![module.icon_url isEqualToString:@"null"]) {
                [self.headImage setBackgroundImage:IMG(module.icon_url) forState:UIControlStateNormal];
                self.headImage.backgroundColor = [HQHelper colorWithHexString:module.icon_color]?[HQHelper colorWithHexString:module.icon_color]:GreenColor;
            }else{
                [self.headImage setBackgroundImage:IMG(module.chinese_name) forState:UIControlStateNormal];
                self.headImage.backgroundColor = WhiteColor;
            }
            self.headImage.contentMode = UIViewContentModeCenter;
        }
    }
    
}

+(instancetype)enterMoveCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFEnterMoveCell" owner:self options:nil] lastObject];
}

+(instancetype)enterMoveCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFEnterMoveCell";
    TFEnterMoveCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell){
        cell = [self enterMoveCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
