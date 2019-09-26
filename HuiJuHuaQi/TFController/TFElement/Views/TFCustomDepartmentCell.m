//
//  TFCustomDepartmentCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/2/28.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomDepartmentCell.h"
#import "HuiJuHuaQi-Swift.h"
#import "TFDepartmentModel.h"

@interface TFCustomDepartmentCell ()<TFDepartmentViewDelegate>

/** 标题 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 必填符号 */
@property (nonatomic, weak) UILabel *requireLabel;

@property (nonatomic, weak) TFDepartmentView *departmentView;

@property (nonatomic, weak) UIView *borderView;

@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation TFCustomDepartmentCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupChildView];
    }
    return self;
}

-(void)setupChildView{
    
    UILabel *lable = [[UILabel alloc] init];
    lable.textColor = ExtraLightBlackTextColor;
    lable.font = FONT(14);
    lable.backgroundColor = ClearColor;
    [self addSubview:lable];
    lable.textAlignment = NSTextAlignmentLeft;
    self.titleLabel = lable;
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(101);
        
    }];
    
    UILabel *requi = [[UILabel alloc] init];
    requi.text = @"*";
    self.requireLabel = requi;
    requi.textColor = RedColor;
    requi.font = FONT(14);
    requi.backgroundColor = ClearColor;
    [self.contentView addSubview:requi];
    requi.textAlignment = NSTextAlignmentLeft;
    [requi mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(6);
        make.centerY.equalTo(lable.mas_centerY);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(15);
        
    }];
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    [self.contentView addSubview:placeholderLabel];
    placeholderLabel.textColor = GrayTextColor;
    placeholderLabel.font = FONT(14);
    self.placeholderLabel = placeholderLabel;
    placeholderLabel.hidden = YES;
    
    UIView *borderView = [[UIView alloc] init];
    [self.contentView addSubview:borderView];
    self.borderView = borderView;
    borderView.backgroundColor = ClearColor;
    
    TFDepartmentView *departmentView = [[TFDepartmentView alloc] init];
    [self.borderView addSubview:departmentView];
    departmentView.backgroundColor = ClearColor;
    self.departmentView = departmentView;
    departmentView.delegate = self;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.borderView addSubview:rightBtn];
    rightBtn.contentMode = UIViewContentModeCenter;
    self.rightBtn = rightBtn;
    rightBtn.backgroundColor = ClearColor;
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.borderView.mas_right).with.offset(-2);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(30);
        make.centerY.equalTo(self.borderView.mas_centerY);
        
    }];
    
    [departmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(rightBtn.mas_left);
        make.left.equalTo(borderView.mas_left);
        make.top.equalTo(borderView.mas_top);
        make.bottom.equalTo(borderView.mas_bottom);
        
    }];
    
//    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.userInteractionEnabled = NO;
    self.bottomLine.hidden = NO;
    self.layer.masksToBounds = YES;
}

/** 点击右按钮 */
- (void)rightBtnClicked:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(customDepartmentCellDidRightBtnWithModel:)]) {
        [self.delegate customDepartmentCellDidRightBtnWithModel:self.model];
    }
}

-(void)refreshCustomDepartmentCellWithModel:(TFCustomerRowsModel *)model edit:(BOOL)edit{
    
    [self.departmentView refreshDepartmentWithDepartments:model.selects edit:edit];
    if (edit) {
        if (model.selects.count) {
            self.placeholderLabel.hidden = YES;
            self.placeholderLabel.text = @"";
        }else{
            self.placeholderLabel.hidden = NO;
            self.placeholderLabel.text = @"请选择";
        }
    }else{
        if (model.selects.count) {
            self.placeholderLabel.hidden = YES;
            self.placeholderLabel.text = @"";
        }else{
            self.placeholderLabel.hidden = NO;
            self.placeholderLabel.text = @"未填写";
        }
    }
}

+(CGFloat)refreshCustomDepartmentCellHeightWithModel:(TFCustomerRowsModel *)model edit:(BOOL)edit{
    
    return 0;
}

-(void)setEdit:(BOOL)edit{
    _edit = edit;
}

-(void)setModel:(TFCustomerRowsModel *)model{
    _model = model;
    
    CGFloat head = 15;
    CGFloat title = 80;
    CGFloat empty = 20;
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
        // borderView
        [self.borderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.titleLabel.mas_right).with.offset(empty);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.top.equalTo(self.contentView).with.offset(15);
            make.bottom.equalTo(self.contentView).with.offset(-15);
        }];
        // placeholderLabel
        [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.borderView.mas_left);
            make.right.equalTo(self.borderView.mas_right);
            make.top.equalTo(self.borderView.mas_top);
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
        // borderView
        [self.borderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
            make.bottom.equalTo(self.contentView).with.offset(-15);
            make.right.equalTo(self.contentView).with.offset(-10);
        }];
        
        // placeholderLabel
        [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.borderView.mas_left);
            make.right.equalTo(self.borderView.mas_right);
            make.top.equalTo(self.borderView.mas_top);
        }];
    }
    
}

/** 提示文字 */
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
//    self.placeholderLabel.text = placeholder;
}
/** 标题 */
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

/** 右图片 */
-(void)setRightImage:(NSString *)rightImage{
    _rightImage = rightImage;
    if (!IsStrEmpty(rightImage)) {
        [self.rightBtn setImage:IMG(rightImage) forState:UIControlStateNormal];
        [self.rightBtn setImage:IMG(rightImage) forState:UIControlStateHighlighted];
        // 跟新宽度
        [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
        }];
        self.rightBtn.hidden = NO;
    }else{
        // 跟新宽度
        [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        self.rightBtn.hidden = YES;
    }
}

/** 必填控制 */
-(void)setFieldControl:(NSString *)fieldControl{
    _fieldControl = fieldControl;
    if ([fieldControl isEqualToString:@"2"]) {
        self.requireLabel.hidden = NO;
    }else{
        self.requireLabel.hidden = YES;
    }
}
/** delegate */
-(void)departmentViewHeightWithHeight:(CGFloat)height{
    
    if ([self.model.field.structure isEqualToString:@"1"]) {// 左右
        
        CGFloat total = 30;// 上下边距
        // 标题
        CGSize titleSize = [HQHelper sizeWithFont:BFONT(14) maxSize:(CGSize){80,MAXFLOAT} titleStr:self.model.label];
        if (titleSize.height > height) {
            self.model.height = @((total + titleSize.height) < 44 ? 44 :(total + titleSize.height) );
        }else{
            self.model.height = @((total + height) < 44 ? 44 : (total + height));
        }
        
    }else{
        CGFloat total = 30;// 上下边距
        // 标题
        CGSize titleSize = [HQHelper sizeWithFont:BFONT(14) maxSize:(CGSize){80,MAXFLOAT} titleStr:self.model.label];
       
        total += titleSize.height;
        
        total += 10;// 标题与department的间距
        
        total += height;
        
        self.model.height = @(total);
    }
    if ([self.delegate respondsToSelector:@selector(customDepartmentCellChangeHeightWithModel:)]) {
        [self.delegate customDepartmentCellChangeHeightWithModel:self.model];
    }
}

+(instancetype)customDepartmentCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFCustomDepartmentCell";
    TFCustomDepartmentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TFCustomDepartmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    return cell;
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
