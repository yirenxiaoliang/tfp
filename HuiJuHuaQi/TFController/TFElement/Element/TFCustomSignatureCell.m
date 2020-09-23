//
//  TFCustomSignatureCell.m
//  HuiJuHuaQi
//
//  Created by daidan on 2019/10/16.
//  Copyright © 2019 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomSignatureCell.h"

@interface TFCustomSignatureCell ()

/** 标题 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 必填符号 */
@property (nonatomic, weak) UILabel *requireLabel;
/** 提示 */
@property (nonatomic, weak) UILabel *tipLabel;
/** 签名图 */
@property (nonatomic, weak) UIImageView *signatureImage;
/** 删除按钮 */
@property (nonatomic, weak) UIButton *deleteBtn;


@end

@implementation TFCustomSignatureCell

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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
/** 创建cell */
+(instancetype)customSignatureCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFCustomSignatureCell";
    TFCustomSignatureCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFCustomSignatureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    return cell;
}
/** 初始化子控件 */
- (void)setupChildView{
    
    UILabel *lable = [[UILabel alloc] init];
    [self.contentView addSubview:lable];
    lable.textColor = ExtraLightBlackTextColor;
    lable.font = FONT(14);
    self.titleLabel = lable;
    lable.numberOfLines = 0;
    
    
    UILabel *requi = [[UILabel alloc] init];
    requi.text = @"*";
    self.requireLabel = requi;
    requi.textColor = RedColor;
    requi.font = BFONT(14);
    requi.backgroundColor = ClearColor;
    [self.contentView addSubview:requi];
    requi.textAlignment = NSTextAlignmentLeft;
    
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"点击签名";
    self.tipLabel = tipLabel;
    tipLabel.textColor = PlacehoderColor;
    tipLabel.font = BFONT(14);
    tipLabel.backgroundColor = ClearColor;
    [self.contentView addSubview:tipLabel];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    
    UIImageView *signatureImage = [[UIImageView alloc] init];
    [self.contentView addSubview:signatureImage];
    self.signatureImage = signatureImage;
    signatureImage.contentMode = UIViewContentModeScaleAspectFit;
    signatureImage.userInteractionEnabled = YES;
    [signatureImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signatureClicked:)]];
    
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:deleteBtn];
    self.deleteBtn = deleteBtn;
    [self.deleteBtn setImage:IMG(@"清除") forState:UIControlStateNormal];
    [self.deleteBtn setImage:IMG(@"清除") forState:UIControlStateHighlighted];
    [self.deleteBtn addTarget:self action:@selector(deleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.layer.masksToBounds = YES;
    
    CGFloat head = 15;
    CGFloat title = 80;
    // 标题
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).with.offset(head);
        make.top.equalTo(self.contentView.mas_top).with.offset(head);
        
        make.width.equalTo(@(title));
    }];
    // 必填
    [self.requireLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.mas_top);
        make.right.equalTo(self.titleLabel.mas_left);
        make.width.equalTo(@(8));
    }];

    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.titleLabel.mas_right).with.offset(head+5); make.right.equalTo(self.contentView).with.offset(-head); make.top.equalTo(self.titleLabel.mas_top);
        make.height.equalTo(@20);
    }];
    
    
    [self.signatureImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).with.offset(head);
        make.top.equalTo(self.titleLabel.mas_top);
        make.height.equalTo(@45);
        make.width.equalTo(@80);
    }];

    [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.signatureImage.mas_right);
        make.top.equalTo(self.signatureImage.mas_top);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
}
- (void)signatureClicked:(UITapGestureRecognizer *)tap{
    
    if ([self.delegate respondsToSelector:@selector(signatureClickedWithView:)]) {
        [self.delegate signatureClickedWithView:tap.view];
    }
}

- (void)deleteClicked:(UIButton *)button{
    
    self.deleteBtn.hidden = YES;
    self.signatureImage.hidden = YES;
    self.tipLabel.hidden = NO;
    [self.model.selects removeAllObjects];
    self.signatureImage.image = nil;
}
/** 展示详情 */
-(void)setShowEdit:(BOOL)showEdit{

    _showEdit = showEdit;
    
    if (!showEdit) {// 详情
        self.deleteBtn.hidden = YES;
        self.tipLabel.hidden = YES;
    }else{
        if (self.model.selects.count) {
            self.deleteBtn.hidden = NO;
            self.tipLabel.hidden = YES;
        }else{
            self.deleteBtn.hidden = YES;
            self.tipLabel.hidden = NO;
        }
    }
}

-(void)setModel:(TFCustomerRowsModel *)model{
    _model = model;
    
    CGFloat head = 15;
    CGFloat title = 80;
    if ([model.field.structure isEqualToString:@"1"]) {// 左右
        // 底部线
        self.headMargin = head;
        // 标题
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).with.offset(head);
            make.top.equalTo(self.contentView.mas_top).with.offset(head);
//            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-head);
            make.width.equalTo(@(title));
        }];
        // 必填
        [self.requireLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleLabel.mas_top);
            make.right.equalTo(self.titleLabel.mas_left);
//            make.bottom.equalTo(self.titleLabel.mas_bottom);
            make.width.equalTo(@(8));
        }];

        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).with.offset(head+5); make.right.equalTo(self.contentView).with.offset(-head); make.top.equalTo(self.titleLabel.mas_top);
            make.height.equalTo(@20);
        }];
        
        
        [self.signatureImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).with.offset(head);
            make.top.equalTo(self.titleLabel.mas_top);
            make.height.equalTo(@45);
            make.width.equalTo(@80);
        }];
  
        [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.signatureImage.mas_right);
            make.top.equalTo(self.signatureImage.mas_top);
            make.height.equalTo(@30);
            make.width.equalTo(@30);
        }];
  
        
    }else{// 上下
        
        // 底部线
        self.headMargin = head;
        // 标题
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(head);
            make.top.equalTo(self.contentView).with.offset(12);
            make.right.equalTo(self.contentView).with.offset(-head);
        }];
        // 必填
        [self.requireLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleLabel.mas_top);
            make.right.equalTo(self.titleLabel.mas_left);
//            make.bottom.equalTo(self.titleLabel.mas_bottom);
            make.width.equalTo(@(8));
        }];

         [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(self.contentView).with.offset(head);
             make.right.equalTo(self.contentView).with.offset(-head);
             make.top.equalTo(self.titleLabel.mas_bottom).with.offset(head);
             make.height.equalTo(@20);
         }];
         
         
         [self.signatureImage mas_remakeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(self.contentView).with.offset(head);
             make.top.equalTo(self.titleLabel.mas_bottom).with.offset(head);
             make.height.equalTo(@45);
             make.width.equalTo(@80);
         }];
   
         [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(self.signatureImage.mas_right);
             make.top.equalTo(self.signatureImage.mas_top);
             make.height.equalTo(@30);
             make.width.equalTo(@30);
         }];
    }
    
    if (model.selects.count) {
        self.tipLabel.hidden = YES;
        self.signatureImage.hidden = NO;
        self.deleteBtn.hidden = NO;
    }else{
        self.tipLabel.hidden = NO;
        self.signatureImage.hidden = YES;
        self.deleteBtn.hidden = YES;
    }
    self.titleLabel.text = model.label;
    if ([model.field.fieldControl isEqualToString:@"2"]) {
        self.requireLabel.hidden = NO;
    }else{
        self.requireLabel.hidden = YES;
    }
    
    if (model.selects.count) {
        TFFileModel *file = model.selects.firstObject;
        [self.signatureImage sd_setImageWithURL:[HQHelper URLWithString:file.file_url]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
