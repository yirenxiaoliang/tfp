//
//  TFTCustomSubformHeaderCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/22.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTCustomSubformHeaderCell.h"

@interface TFTCustomSubformHeaderCell ()

/** 标题 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 必填符号 */
@property (nonatomic, weak) UILabel *requireLabel;
/** 增加按钮 */
@property (nonatomic, weak) UIButton *addBtn;
/** 扫一扫按钮 */
@property (nonatomic, weak) UIButton *scanBtn;

@end

@implementation TFTCustomSubformHeaderCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChildView];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupChildView];
    }
    return self;
}

/** 初始化子控件 */
- (void)setupChildView{
    
    UILabel *lable = [[UILabel alloc] init];
    [self.contentView addSubview:lable];
    lable.textColor = ExtraLightBlackTextColor;
    lable.font = FONT(14);
    self.titleLabel = lable;
    lable.numberOfLines = 0;
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
        
    }];
    
    
    UILabel *requi = [[UILabel alloc] init];
    requi.text = @"*";
    self.requireLabel = requi;
    requi.textColor = RedColor;
    requi.font = BFONT(14);
    requi.backgroundColor = ClearColor;
    [self.contentView addSubview:requi];
    requi.textAlignment = NSTextAlignmentLeft;
    [requi mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(6);
        make.top.equalTo(self.contentView).with.offset(15);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:button];
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    button.backgroundColor = GreenColor;
    button.titleLabel.font = FONT(14);
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@24);
    }];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([self.delegate respondsToSelector:@selector(customSubformHeaderCellClickedAddWithModel:)]) {
            [self.delegate customSubformHeaderCellClickedAddWithModel:self.model];
        }
    }];
    [button setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
    button.hidden = YES;
    self.addBtn = button;
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:button1];
    button1.layer.cornerRadius = 4;
    button1.layer.masksToBounds = YES;
    button1.backgroundColor = WhiteColor;
    button1.titleLabel.font = FONT(14);
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(button.mas_left);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    [[button1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([self.delegate respondsToSelector:@selector(customSubformHeaderCellClickedScanWithModel:)]) {
            [self.delegate customSubformHeaderCellClickedScanWithModel:self.model];
        }
    }];
    [button1 setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
    button1.hidden = YES;
    self.scanBtn = button1;
}

-(void)setModel:(TFCustomerRowsModel *)model{
    _model = model;
    if (model.subformRelation) {
        self.addBtn.hidden = NO;
        [self.addBtn setTitle:[NSString stringWithFormat:@"  %@  ",TEXT(model.subformRelation.title)] forState:UIControlStateNormal];
    }else{
        self.addBtn.hidden = YES;
    }
    
    TFCustomerRowsModel *refRow = nil;
    for (TFCustomerRowsModel *row in model.componentList) {
//        if ([row.type isEqualToString:@"reference"]) {
        if ([row.type isEqualToString:@"reference"] && [row.field.allowScan isEqualToString:@"1"]) {
            refRow  = row;
            break;
        }
    }
    
    if (refRow) {
        self.scanBtn.hidden = NO;
        [self.scanBtn setImage:IMG(@"referScan") forState:UIControlStateNormal];
        if (self.addBtn.hidden) {
            [self.scanBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-15);
            }];
        }else{
            [self.scanBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.addBtn.mas_left);
            }];
        }
    }else{
        self.scanBtn.hidden = YES;
    }
    
}
/** 展示详情 */
-(void)setShowEdit:(BOOL)showEdit{
    
    _showEdit = showEdit;
    
    if (!showEdit) {// 详情
        self.addBtn.hidden = YES;
        self.scanBtn.hidden = YES;
        self.titleLabel.textColor = ExtraLightBlackTextColor;
    }else{
        self.addBtn.hidden = self.model.subformRelation ? NO : YES;
        
        TFCustomerRowsModel *refRow = nil;
        for (TFCustomerRowsModel *row in self.model.componentList) {
            if ([row.type isEqualToString:@"reference"] && [row.field.allowScan isEqualToString:@"1"]) {
                refRow  = row;
                break;
            }
        }
        self.scanBtn.hidden = [refRow.field.allowScan isEqualToString:@"1"] ? NO : YES;
    }
}
/** 标题 */
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

/** 必填控制 */
-(void)setFieldControl:(NSString *)fieldControl{
    _fieldControl = fieldControl;
    if ([fieldControl isEqualToString:@"2"]) {
        self.requireLabel.hidden = NO;
    }else{
        self.requireLabel.hidden = YES;
    }
    
    if ([fieldControl isEqualToString:@"1"]) {
        self.titleLabel.textColor = HexColor(0xb1b5bb);
    }else{
        self.titleLabel.textColor = ExtraLightBlackTextColor;
    }
}

/** 创建cell */
+(instancetype)customSubformHeaderCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFTCustomSubformHeaderCell";
    TFTCustomSubformHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFTCustomSubformHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    return cell;
    
}

/** cell高度 */
+(CGFloat)refreshCustomSubformHeaderCellHeightWithModel:(TFCustomerRowsModel *)model{
    

    CGFloat height = 0;
    height += 8;// 顶部与标题的间距
    height += [HQHelper sizeWithFont:BFONT(12) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:model.label].height;// 标题高度
    
    height += 8;// 底部与标题的间距
    return height<44?44:height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
