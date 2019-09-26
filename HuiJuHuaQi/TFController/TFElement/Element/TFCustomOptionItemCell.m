//
//  TFCustomOptionItemCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomOptionItemCell.h"
#import "TFOptionListView.h"

@interface TFCustomOptionItemCell ()

/** 边框View */
@property (nonatomic, weak) UIView *borderView;

/** 选项View */
@property (nonatomic, weak) TFOptionListView *optionView;

@end

@implementation TFCustomOptionItemCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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

- (void)setupChildView{
    
    UIView *borderView = [[UIView alloc] init];
    [self.contentView addSubview:borderView];
    self.borderView = borderView;
//    borderView.layer.cornerRadius = 4;
//    borderView.layer.borderWidth = 1;
//    borderView.layer.borderColor = HexColor(0xd5d5d5).CGColor;
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(5);
        make.bottom.equalTo(self.contentView).with.offset(-5);
        make.right.equalTo(self.contentView).with.offset(-10);
        
    }];
    borderView.backgroundColor = ClearColor;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [borderView addSubview:rightBtn];
    self.rightBtn = rightBtn;
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(borderView).with.offset(-2);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(30);
        make.centerY.equalTo(borderView.mas_centerY);
        
    }];
    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    TFOptionListView *optionView = [[TFOptionListView alloc] init];
    [borderView addSubview:optionView];
    self.optionView = optionView;
    optionView.backgroundColor = ClearColor;
    [optionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(borderView).with.offset(6);
        make.top.equalTo(borderView).with.offset(5);
        make.bottom.equalTo(borderView).with.offset(-5);
        make.right.equalTo(rightBtn.mas_left).with.offset(0);
    }];
    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor = ClearColor;
    self.contentView.backgroundColor = ClearColor;
}

//-(void)setShowEdit:(BOOL)showEdit{
//    _showEdit = showEdit;
////    if (showEdit) {
////        self.borderView.layer.borderWidth = 1;
////    }else{
////        self.borderView.layer.borderWidth = 0;
////    }
//
//
//    if (showEdit) {// 框
//
//        self.borderView.layer.cornerRadius = 4;
//        self.borderView.layer.borderWidth = 1;
//        self.borderView.layer.borderColor = HexColor(0xd5d5d5).CGColor;
//        self.borderView.layer.shadowColor = ClearColor.CGColor;
//        self.borderView.layer.shadowOffset = CGSizeMake(0, 0);
//        self.borderView.layer.shadowRadius = 0;
//        self.borderView.layer.shadowOpacity = 0.5;
//        self.borderView.backgroundColor = ClearColor;
//
//    }else{// 阴影
//
//        self.borderView.layer.cornerRadius = 4;
//        self.borderView.layer.borderWidth = 0;
//        self.borderView.layer.borderColor = HexColor(0xd5d5d5).CGColor;
//        self.borderView.layer.shadowColor = HexColor(0xd5d5d5).CGColor;
//        self.borderView.layer.shadowOffset = CGSizeMake(0, 0);
//        self.borderView.layer.shadowRadius = 4;
//        self.borderView.layer.shadowOpacity = 0.5;
//        self.borderView.backgroundColor = WhiteColor;
//    }
//
//}

/** 右边按钮 */
- (void)rightBtnClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(customOptionItemCellDidClickedRightBtn:)]) {
        [self.delegate customOptionItemCellDidClickedRightBtn:button];
    }
}

/** 刷新 */
-(void)refreshCustomOptionItemCellWithOptions:(NSArray *)options{
    
    if (options.count) {
        [self.rightBtn setImage:IMG(@"清除") forState:UIControlStateNormal];
        [self.rightBtn setImage:IMG(@"清除") forState:UIControlStateHighlighted];
        self.rightBtn.userInteractionEnabled = YES;
    }else{
        [self.rightBtn setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
        [self.rightBtn setImage:IMG(@"下一级浅灰") forState:UIControlStateHighlighted];
        self.rightBtn.userInteractionEnabled = NO;
    }
    
    [self.optionView refreshWithOptions:options];
}
/** 刷新 */
-(void)refreshCustomOptionItemCellWithModel:(TFCustomerRowsModel *)model
 edit:(BOOL)edit{
    
    if (model.selects.count) {
        [self.rightBtn setImage:IMG(@"清除") forState:UIControlStateNormal];
        [self.rightBtn setImage:IMG(@"清除") forState:UIControlStateHighlighted];
        self.rightBtn.userInteractionEnabled = YES;
    }else{
        [self.rightBtn setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
        [self.rightBtn setImage:IMG(@"下一级浅灰") forState:UIControlStateHighlighted];
        self.rightBtn.userInteractionEnabled = NO;
    }
    
    [self.optionView refreshWithModel:model edit:edit];
}


-(void)setEdit:(BOOL)edit{
    _edit = edit;
    
    if (edit) {
        [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(30);
            
        }];
        self.rightBtn.hidden = NO;
    }else{
        [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(0);
            
        }];
        self.rightBtn.hidden = YES;
    }
}


/** 高度 */
+(CGFloat)refreshCustomOptionItemCellHeightWithOptions:(NSArray *)options{
    
    CGFloat height = 0;
    
    height += 10;// optionView 与 borderView的上下间距
    
    height += [TFOptionListView refreshOptionListViewHeightWithOptions:options];// optionView 的高度
    
    return height < 45 ? 45 : height;
}
/** 高度 */
+(CGFloat)refreshCustomOptionItemCellHeightWithModel:(TFCustomerRowsModel *)model edit:(BOOL)edit{
    
    CGFloat height = 0;
    
    height += [TFOptionListView refreshOptionListViewHeightWithModel:model edit:edit];// optionView 的高度
    height += 20;// 边距
    return height;
}

/** 创建cell */
+(instancetype)customOptionItemCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFCustomOptionItemCell";
    TFCustomOptionItemCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFCustomOptionItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = NO;
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
