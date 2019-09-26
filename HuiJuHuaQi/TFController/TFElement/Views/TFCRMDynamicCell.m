//
//  TFCRMDynamicCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/9/6.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCRMDynamicCell.h"

@interface TFCRMDynamicCell ()

@property (weak, nonatomic) IBOutlet UILabel *line;

@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@end

@implementation TFCRMDynamicCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.line.backgroundColor = GreenColor;
    
    self.personName.font = FONT(12);
    self.personName.textColor = HexColor(0xA0A0AE);
    
    self.timeLab.font = FONT(12);
    self.timeLab.textColor = HexColor(0xA0A0AE);
    
    self.contentLab.font = FONT(14);
    self.contentLab.textColor = HexColor(0x69696C);
    self.contentLab.numberOfLines = 0;

}


- (instancetype)initWithFrame:(CGRect)frame {
    
    return self;
}

//配置数据
- (void)configCRMDynamicCellWithTableView:(NSArray *)model {
    
    self.personName.text = @"陈羽亮";
    self.timeLab.text = @"12:20";
    self.contentLab.text = @"将销售阶段“初步沟通”修改为“意向合作”这是一条字数比较多的样式如果字比较多就参考这一条三分";
}

+ (CGFloat)refreshDynamicHeightWithModel:(NSString*)content {

    CGSize size = [HQHelper calculateStringWithAndHeight:content cgsize:CGSizeMake(SCREEN_WIDTH-20-53, MAXFLOAT) wordFont:FONT(14)];
    
    return 32+20+size.height;
}


/** 刷新cell */
-(void)refreshCellWithModel:(TFCustomerCommentModel *)model{
    
    self.personName.text = model.employee_name;
    self.timeLab.text = [HQHelper nsdateToTime:[model.datetime_time longLongValue] formatStr:@"HH:mm"];
    self.contentLab.text = model.content;
    
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(SCREEN_WIDTH-20-53, MAXFLOAT) titleStr:model.content];
    
    self.lineH.constant = size.height + 20;
}




+ (instancetype)TFCRMDynamicCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFCRMDynamicCell" owner:self options:nil] lastObject];
}



+ (instancetype)CRMDynamicCellWithTableView:(UITableView *)tableView{

    static NSString *ID = @"TFCRMDynamicCell";
    TFCRMDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFCRMDynamicCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
