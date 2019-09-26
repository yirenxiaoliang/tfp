//
//  TFAssistantListCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAssistantListCell.h"

@interface TFAssistantListCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *pictureImg;

@property (weak, nonatomic) IBOutlet UILabel *moduleNameLab;

@property (weak, nonatomic) IBOutlet UIView *detailView;

@property (weak, nonatomic) IBOutlet UILabel *unReadLab;
@property (weak, nonatomic) IBOutlet UILabel *pointLab;

@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *responsibleLab;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *threeLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeC;

@end

@implementation TFAssistantListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundColor = kUIColorFromRGB(0xF2F2F2);
    
    _timeLab.layer.cornerRadius = 5.0;
    _timeLab.layer.masksToBounds = YES;
    _timeLab.textAlignment = NSTextAlignmentCenter;
    
    _pictureImg.layer.cornerRadius = 20.0;
    _pictureImg.layer.masksToBounds = YES;
    _pictureImg.contentMode = UIViewContentModeCenter;

//    _detailView.layer.borderWidth = 1.0;
//    _detailView.layer.borderColor = [kUIColorFromRGB(0xACB8C5) CGColor];
    
    _detailView.layer.cornerRadius = 5.0;
//    _detailView.layer.masksToBounds = YES;
    
    _pointLab.layer.cornerRadius = 4.5;
    _pointLab.layer.masksToBounds = YES;

    [self.contentView insertSubview:_pointLab aboveSubview:_pictureImg];
//    [self.contentView insertSubview:_moduleNameLab aboveSubview:_detailView];
    [self.contentView addSubview:_moduleNameLab];
    
    self.moduleNameLab.textColor = ExtraLightBlackTextColor;
    self.descLab.textColor = BlackTextColor;
    self.responsibleLab.textColor = HexColor(0x8c96ab);
    self.endTimeLab.textColor = HexColor(0x8c96ab);
    self.threeLab.textColor = HexColor(0x8c96ab);
}

- (void)refreshAssistantListCellWithModel:(TFFMDBModel *)model type:(NSInteger)type name:(NSString *)name{

    if ([model.type isEqualToString:@"3"]) {
        
        if ([model.icon_type isEqualToString:@"0"]) {
            
            [self.pictureImg setBackgroundImage:IMG(model.icon_url) forState:UIControlStateNormal];
            [self.pictureImg sd_setImageWithURL:nil forState:UIControlStateNormal];
            [self.pictureImg setBackgroundColor:[HQHelper colorWithHexString:model.icon_color]];
        }
        else if ([model.icon_type isEqualToString:@"1"]) {
            
            [self.pictureImg setBackgroundImage:nil forState:UIControlStateNormal];
            [self.pictureImg sd_setImageWithURL:[HQHelper URLWithString:model.icon_url] forState:UIControlStateNormal];
            [self.pictureImg setBackgroundColor:[HQHelper colorWithHexString:model.icon_color]];
        }
    }
    else if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"10"]) {
        
        [_pictureImg setImage:IMG(@"企信-企信小助手") forState:UIControlStateNormal];
    }
    else if ([model.type isEqualToString:@"4"]) {
        
        [_pictureImg setImage:IMG(@"企信-审批小助手") forState:UIControlStateNormal];

    }
    else if ([model.type isEqualToString:@"5"]) {
    
        [_pictureImg setImage:IMG(@"企信-文件库小助手") forState:UIControlStateNormal];

    }
    else if ([model.type isEqualToString:@"7"]) {
        
        [_pictureImg setImage:IMG(@"企信-备忘录小助手") forState:UIControlStateNormal];

    }
    else if ([model.type isEqualToString:@"8"]) {
        
        [_pictureImg setImage:IMG(@"企信-邮件小助手") forState:UIControlStateNormal];

    }
    else if ([model.type isEqualToString:@"26"] || [model.type isEqualToString:@"25"]) {
        
        [_pictureImg setImage:IMG(@"企信-任务小助手") forState:UIControlStateNormal];
        
    }
    else if ([model.type isEqualToString:@"27"]) {
        
        [_pictureImg setImage:IMG(@"知识库") forState:UIControlStateNormal];
        
    }
    else if ([model.type isEqualToString:@"28"]) {// 考勤
        
        [_pictureImg setImage:IMG(@"考勤") forState:UIControlStateNormal];
        
    }
    else if ([model.type isEqualToString:@"2"]) {// @推送
        
        if ([model.beanName isEqualToString:@"approval"]) {
            [_pictureImg setImage:IMG(@"企信-审批小助手") forState:UIControlStateNormal];

        }else if ([model.beanName isEqualToString:@"file_library"]){
            [_pictureImg setImage:IMG(@"企信-文件库小助手") forState:UIControlStateNormal];

        }else if ([model.beanName isEqualToString:@"memo"]){
            [_pictureImg setImage:IMG(@"企信-备忘录小助手") forState:UIControlStateNormal];

        }else if ([model.beanName isEqualToString:@"email"]){
            [_pictureImg setImage:IMG(@"企信-邮件小助手") forState:UIControlStateNormal];
            
        }else if ([model.beanName isEqualToString:@"repository_libraries"]){
            [_pictureImg setImage:IMG(@"知识库") forState:UIControlStateNormal];
            
        }
        
    }
//    _pictureImg.image = IMG(@"小秘书50");
    
    if (type == 2) {// 企信小助手
        
        [_pictureImg setImage:IMG(@"企信-企信小助手") forState:UIControlStateNormal];
    }
    
    _timeLab.text = [NSString stringWithFormat:@"  %@   ",[JCHATStringUtils getFriendlyDateString:[model.create_time longLongValue] forConversation:YES]];
    
    _descLab.text = model.pushContent;
    
    _responsibleLab.hidden = YES;
    _endTimeLab.hidden = YES;
    _threeLab.hidden = YES;
    
    _oneH.constant = 0;
    _twoH.constant = 0;
    _threeH.constant = 0;
    
    _oneC.constant = 0;
    _twoC.constant = 0;
    _threeC.constant = 0;
    
//    if (model.oneRowValue != nil && ![model.oneRowValue isEqualToString:@""]) {
    if (model.oneRowValue != nil) {
    
        _responsibleLab.text = model.oneRowValue;
        _responsibleLab.hidden = NO;
        
        _oneH.constant = 20;
        _oneC.constant = 10;
        
    }
//    if (model.twoRowValue != nil  && ![model.twoRowValue isEqualToString:@""]) {
    if (model.twoRowValue != nil) {
    
        _endTimeLab.text = model.twoRowValue;
        
        _endTimeLab.hidden = NO;
        
        _twoH.constant = 20;
        _twoC.constant = 10;

    }

//    if (model.threeRowValue != nil && ![model.threeRowValue isEqualToString:@""]) {
    if (model.threeRowValue != nil) {

        _threeLab.text = model.threeRowValue;
        _threeLab.hidden = NO;
        
        _threeH.constant = 20;
        _threeC.constant = 10;
        
    }

    
    //模块名字
    
    if (type == 2) {
        
        if ([model.type isEqualToString:@"6"]) {
            
            _moduleNameLab.text = @"同事圈";
        }
        else {
        
            _moduleNameLab.text = @"企信";
        }
        
    }else if (type == 9){
        _moduleNameLab.text = @"考勤";
    }
    else {
    
        _moduleNameLab.text = model.beanNameChinese;
    }
    
    //是否读过
    if (type == 2) {
        
        _pointLab.hidden = YES;
    }
    else {
    
        if ([model.readStatus isEqualToString:@"0"]) {
            
            _pointLab.hidden = NO;
        }
        else if ([model.readStatus isEqualToString:@"1"]) {
            
            _pointLab.hidden = YES;
        }
    }
    
}

+ (instancetype)TFAssistantListCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFAssistantListCell" owner:self options:nil] lastObject];
}

//刷新高度
+ (CGFloat)refreshAssistantCellHeightWithModel:(TFFMDBModel *)model {
    
    CGSize size = [HQHelper sizeWithFont:FONT(16) maxSize:CGSizeMake(SCREEN_WIDTH-120, MAXFLOAT) titleStr:model.pushContent];
    
//    if (model.oneRowValue == nil || [model.oneRowValue isEqualToString:@""]) {
//
//        return size.height+110;
//    }
//    else if (model.twoRowValue == nil || [model.twoRowValue isEqualToString:@""]) {
//
//        return 30+size.height+110;
//    }
//    else if (model.threeRowValue == nil || [model.threeRowValue isEqualToString:@""]) {
//
//        return 30+30+size.height+110;
//    }
//    else if (model.threeRowValue != nil && ![model.threeRowValue isEqualToString:@""]) {
//
//        return 30+30+30+size.height+110;
//    }
    
    CGFloat height = size.height+110;
    
    if (model.oneRowValue != nil) {
        height += 30;
    }
    if (model.twoRowValue != nil) {
        height += 30;
    }
    if (model.threeRowValue != nil) {
        height += 30;
    }
    
    
    return height;
}

+ (instancetype)AssistantListCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFAssistantListCell";
    TFAssistantListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFAssistantListCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
