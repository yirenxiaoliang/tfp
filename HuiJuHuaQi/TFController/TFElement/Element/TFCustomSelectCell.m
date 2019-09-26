//
//  TFCustomSelectCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomSelectCell.h"

@interface TFCustomSelectCell ()

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UILabel *contentLable;

@end

@implementation TFCustomSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView {
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.contentView addSubview:selectBtn];
    self.selectBtn = selectBtn;
    
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@11);
        make.width.height.equalTo(@18);
    }];
    
    UILabel *contentLable = [[UILabel alloc] init];
    contentLable.textColor = SixColor;
    contentLable.font = FONT(14);
    contentLable.layer.cornerRadius = 4.0;
    contentLable.layer.masksToBounds = YES;
    contentLable.numberOfLines = 0;
    [self.contentView addSubview:contentLable];
    self.contentLable = contentLable;
    
    [contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(selectBtn.mas_right).offset(10);
        make.top.equalTo(@10);
        make.right.equalTo(@-15);
        make.height.greaterThanOrEqualTo(@20);
        
    }];
}

//刷新弹框cell
- (void)refreshCustomSelectViewWithModel:(TFCustomerOptionModel *)model {
    
    if ([model.open isEqualToNumber:@1]) {
        
        [self.selectBtn setImage:IMG(@"勾选中22") forState:UIControlStateNormal];
    }
    else {
        
        [self.selectBtn setImage:IMG(@"未选中22") forState:UIControlStateNormal];
    }
    
    if (model.color && ![model.color isEqualToString:@""] && ![[model.color uppercaseString] isEqualToString:@"#FFFFFF"]) {
        
        NSString *str = [NSString stringWithFormat:@"  %@  ",model.label];
        
        self.contentLable.text = str;
        self.contentLable.textColor = WhiteColor;
        self.contentLable.backgroundColor = [HQHelper colorWithHexString:model.color];
        
        CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) titleStr:str];
        
        if (size.width > SCREEN_WIDTH-104) {
            
            [self.contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(-15));
            }];
        }else{
            
            [self.contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(-15+(size.width - (SCREEN_WIDTH-104))));
            }];
        }
        
    }else{
        
        self.contentLable.text = model.label;
        self.contentLable.textColor = ExtraLightBlackTextColor;
        self.contentLable.backgroundColor = WhiteColor;
        
        [self.contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-15);
        }];
    }
}

//刷新复选框cell
- (void)refreshCustomMultiCellWithModel:(TFCustomerOptionModel *)model {
    
    if ([model.open isEqualToNumber:@1]) {
        
        [self.selectBtn setImage:IMG(@"taskSelect") forState:UIControlStateNormal];
    }
    else {
        
        [self.selectBtn setImage:IMG(@"未选中") forState:UIControlStateNormal];
    }
    
    self.contentLable.text = model.label;
}

+ (CGFloat)refreshCustomSelectCellHeightWithModel:(TFCustomerOptionModel *)model{
    
    if (model.color && ![model.color isEqualToString:@""] && ![[model.color uppercaseString] isEqualToString:@"#FFFFFF"]) {
        
        NSString *str = [NSString stringWithFormat:@"  %@  ",model.label];
        
        CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(SCREEN_WIDTH-104, MAXFLOAT) titleStr:str];
        return size.height+20 < 40 ? 40 : size.height+20;
        
    }else{
        
        CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(SCREEN_WIDTH-104, MAXFLOAT) titleStr:model.label];
        return size.height+20 < 40 ? 40 : size.height+20;
    }
    
}

+ (CGFloat)refreshCustomMultiCellHeightWithModel:(TFCustomerOptionModel *)model {
    
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(SCREEN_WIDTH-54, MAXFLOAT) titleStr:model.label];
    return size.height+20 < 40 ? 40 : size.height+20;
}


// 选择控制器
- (void)refreshCustomSelectVcWithModel:(TFCustomerOptionModel *)model{
    
    [self.selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.contentLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.height.greaterThanOrEqualTo(@20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        
    }];
    
    if ([model.open isEqualToNumber:@1]) {
        
        [self.selectBtn setImage:IMG(@"勾选中22") forState:UIControlStateNormal];
    }
    else {
        
        [self.selectBtn setImage:IMG(@"未选中22") forState:UIControlStateNormal];
    }
    
    if (model.color && ![model.color isEqualToString:@""] && ![[model.color uppercaseString] isEqualToString:@"#FFFFFF"]) {
        
        NSString *str = [NSString stringWithFormat:@"  %@  ",model.label];
        
        self.contentLable.text = str;
        self.contentLable.textColor = WhiteColor;
        self.contentLable.backgroundColor = [HQHelper colorWithHexString:model.color];
        
        CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) titleStr:str];
        
        if (size.width > SCREEN_WIDTH-60) {
            
            [self.contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(SCREEN_WIDTH-60));
            }];
        }else{
            
            [self.contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(size.width));
            }];
        }
        
    }else{
        
        self.contentLable.text = model.label;
        self.contentLable.textColor = ExtraLightBlackTextColor;
        self.contentLable.backgroundColor = WhiteColor;
        
        NSString *str = [NSString stringWithFormat:@" %@",model.label];
        CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) titleStr:str];
        if (size.width > SCREEN_WIDTH-60) {
            
            [self.contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(SCREEN_WIDTH-60));
            }];
        }else{
            
            [self.contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(size.width));
            }];
        }
    }
}

// 选择模块
- (void)refreshCustomSelectAttendenceWithModel:(TFModuleModel *)model{
    
    [self.selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.contentLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.height.greaterThanOrEqualTo(@20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        
    }];
    
    if ([model.select isEqualToNumber:@1]) {
        
        [self.selectBtn setImage:IMG(@"勾选中22") forState:UIControlStateNormal];
    }
    else {
        
        [self.selectBtn setImage:IMG(@"未选中22") forState:UIControlStateNormal];
    }
    
    self.contentLable.text = model.chinese_name;
    self.contentLable.textColor = ExtraLightBlackTextColor;
    self.contentLable.backgroundColor = WhiteColor;
    
    NSString *str = [NSString stringWithFormat:@" %@",model.chinese_name];
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) titleStr:str];
    if (size.width > SCREEN_WIDTH-60) {
        
        [self.contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(SCREEN_WIDTH-60));
        }];
    }else{
        
        [self.contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(size.width));
        }];
    }
}
/** 选字段 */
- (void)refreshCustomSelectFieldWithModel:(TFAttendenceFieldModel *)model{
    
    [self.selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.contentLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.height.greaterThanOrEqualTo(@20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        
    }];
    
    if ([model.select isEqualToNumber:@1]) {
        
        [self.selectBtn setImage:IMG(@"勾选中22") forState:UIControlStateNormal];
    }
    else {
        
        [self.selectBtn setImage:IMG(@"未选中22") forState:UIControlStateNormal];
    }
    
    self.contentLable.text = model.field_label;
    self.contentLable.textColor = ExtraLightBlackTextColor;
    self.contentLable.backgroundColor = WhiteColor;
    
    NSString *str = [NSString stringWithFormat:@" %@",model.field_label];
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) titleStr:str];
    if (size.width > SCREEN_WIDTH-60) {
        
        [self.contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(SCREEN_WIDTH-60));
        }];
    }else{
        
        [self.contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(size.width));
        }];
    }
}

// 选择控制器的高
+ (CGFloat)refreshCustomSelectVcHeightWithModel:(TFCustomerOptionModel *)model{
    
    if (model.color && ![model.color isEqualToString:@""] && ![[model.color uppercaseString] isEqualToString:@"#FFFFFF"]) {
        
        NSString *str = [NSString stringWithFormat:@"  %@  ",model.label];
        
        CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT) titleStr:str];
        return size.height+20 < 44 ? 44 : size.height+20;
        
    }else{
        
        CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT) titleStr:model.label];
        return size.height+20 < 44 ? 44 : size.height+20;
    }
    
}



+ (TFCustomSelectCell *)CustomSelectCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFCustomSelectCell";
    TFCustomSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFCustomSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
