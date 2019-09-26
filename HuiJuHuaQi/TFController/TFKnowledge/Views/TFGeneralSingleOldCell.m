//
//  TFGeneralSingleOldCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/4.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFGeneralSingleOldCell.h"
#import "HQAdviceTextView.h"

@interface TFGeneralSingleOldCell ()<UITextViewDelegate>

/** 标题 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 必填符号 */
@property (nonatomic, weak) UILabel *requireLabel;
/** 输入框前图片 */
@property (nonatomic, weak) UIButton *tipBtn;
/** 边框View */
@property (nonatomic, weak) UIView *borderView;

@end

@implementation TFGeneralSingleOldCell

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
    lable.textColor = BlackTextColor;
    lable.font = BFONT(12);
    self.titleLabel = lable;
    lable.numberOfLines = 0;
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(8);
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
        make.top.equalTo(self.contentView).with.offset(8);
    }];
    
    UIView *borderView = [[UIView alloc] init];
    [self.contentView addSubview:borderView];
    self.borderView = borderView;
    borderView.layer.cornerRadius = 4;
    borderView.layer.borderWidth = 1;
    borderView.layer.borderColor = HexColor(0xd5d5d5).CGColor;
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(lable.mas_bottom).with.offset(8);
        make.bottom.equalTo(self.contentView).with.offset(-8);
        make.right.equalTo(self.contentView).with.offset(-15);
        
    }];
    
    UIButton *tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:tipBtn];
    tipBtn.contentMode = UIViewContentModeCenter;
    self.tipBtn = tipBtn;
    tipBtn.backgroundColor = ClearColor;
    [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(borderView.mas_left).with.offset(0);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.centerY.equalTo(borderView.mas_centerY);
        
    }];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:rightBtn];
    rightBtn.contentMode = UIViewContentModeCenter;
    self.rightBtn = rightBtn;
    rightBtn.backgroundColor = ClearColor;
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(borderView.mas_right).with.offset(-2);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(30);
        make.centerY.equalTo(borderView.mas_centerY);
        
    }];
    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:leftBtn];
    leftBtn.contentMode = UIViewContentModeCenter;
    self.leftBtn = leftBtn;
    leftBtn.backgroundColor = ClearColor;
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(rightBtn.mas_left).with.offset(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(30);
        make.centerY.equalTo(borderView.mas_centerY);
        
    }];
    [leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    HQAdviceTextView *textView = [[HQAdviceTextView alloc] init];
    [self.contentView addSubview:textView];
    self.textView = textView;
    textView.delegate = self;
    textView.textAlignment = NSTextAlignmentJustified;
    textView.textColor = ExtraLightBlackTextColor;
    textView.font = FONT(14);
    textView.layer.cornerRadius = 4;
    textView.backgroundColor = ClearColor;
    [textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(tipBtn.mas_right).with.offset(2);
        make.top.equalTo(borderView.mas_top).with.offset(2);
        make.bottom.equalTo(borderView.mas_bottom).with.offset(0);
        make.right.equalTo(leftBtn.mas_left).with.offset(0);
    }];
    
    self.layer.masksToBounds = YES;
    self.tipImage = nil;
    self.rightImage = nil;
    self.leftImage = nil;
    
}

/** 点击右按钮 */
- (void)rightBtnClicked:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(generalSingleCellDidClickedRightBtn:)]) {
        [self.delegate generalSingleCellDidClickedRightBtn:button];
    }
}

/** 点击左按钮 */
- (void)leftBtnClicked:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(generalSingleCellDidClickedLeftBtn:)]) {
        [self.delegate generalSingleCellDidClickedLeftBtn:button];
    }
}

-(void)dealloc{
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.borderView.layer.borderColor = GreenColor.CGColor;
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    // 辞去响应者
    if (!IsStrEmpty(self.model.fieldValue)) {// 为空时不进行
        if ([self.delegate respondsToSelector:@selector(generalSingleCellWithModel:)]) {
            [self.delegate generalSingleCellWithModel:self.model];
        }
    }
    
    self.borderView.layer.borderColor = HexColor(0xd5d5d5).CGColor;
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    TFCustomerRowsModel *model = self.model;
    
    if ([model.type isEqualToString:@"number"]) {
        
        if ([model.field.numberType isEqualToString:@"0"] || [model.field.numberType isEqualToString:@"2"]) {// 数字和百分比
            
            if ([textView.text containsString:@"."]) {
                
                if ([text containsString:@"."]) {
                    [MBProgressHUD showError:@"输入不合法" toView:KeyWindow];
                    return NO;
                }else{
                    
                    if (text.length) {
                        if (![text haveNumber]) {
                            
                            [MBProgressHUD showError:@"请输入数字" toView:KeyWindow];
                            return NO;
                        }
                    }
                }
                
            }else{
                
                if ([text isEqualToString:@""] || [text isEqualToString:@"."] || [text haveNumber]) {
                    return YES;
                }else{
                    [MBProgressHUD showError:@"请输入数字" toView:KeyWindow];
                    return NO;
                }
            }
            
        }else{
            
            if (text.length) {
                if (![text haveNumber]) {
                    
                    [MBProgressHUD showError:@"请输入数字" toView:KeyWindow];
                    return NO;
                }
            }
        }
    }
    
    if ([model.type isEqualToString:@"phone"]) {
        if ([model.field.phoneType isEqualToString:@"1"]) {
            if (text.length) {
                if (![text haveNumber]) {
                    
                    [MBProgressHUD showError:@"请输入数字" toView:KeyWindow];
                    return NO;
                }
            }
        }
        else{
            if (text.length) {
                if (!([text haveNumber] || [text isEqualToString:@"-"])) {
                    
                    [MBProgressHUD showError:@"请输入数字或者“-”" toView:KeyWindow];
                    return NO;
                }
            }
        }
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    TFCustomerRowsModel *model = self.model;
    
    if ([model.type isEqualToString:@"phone"]) {
        
        if ([model.field.phoneType isEqualToString:@"1"]) {// 手机号
            if ([model.field.phoneLenth isEqualToString:@"1"]) {// 11位
                
                UITextRange *range = [textView markedTextRange];
                //获取高亮部分
                UITextPosition *position = [textView positionFromPosition:range.start offset:0];
                
                if (!position) {
                    
                    if (textView.text.length > 11) {
                        
                        textView.text = [textView.text substringToIndex:11];
                        [MBProgressHUD showError:@"最长11位数字" toView:KeyWindow];
                    }
                }
                
            }
        }
    }
    
    if ([model.type isEqualToString:@"number"]) {
        
        if ([model.field.numberType isEqualToString:@"0"] || [model.field.numberType isEqualToString:@"2"]) {// 数字和百分比
            NSArray *arr = [textView.text componentsSeparatedByString:@"."];
            
            if (arr.count > 2) {
                
                [MBProgressHUD showError:@"输入不合法" toView:KeyWindow];
                textView.text = [textView.text substringToIndex:textView.text.length-1];
            }else if (arr.count == 2){
                NSString *rrr = arr[0];
                NSString *sss = arr[1];
                NSInteger location = textView.selectedRange.location;
                
                if ([model.field.numberLenth isEqualToString:@"0"]) {
                    
                    [MBProgressHUD showError:@"不可输入小数" toView:KeyWindow];
                    textView.text = [textView.text substringToIndex:textView.text.length-1];
                }else if ([model.field.numberLenth isEqualToString:@"不限"]) {
                    
                    
                }else{
                    
                    NSString *temp = sss;
                    if (sss.length <= [model.field.numberLenth integerValue]) {// 用0补齐所有小数位
                        
                        for (NSInteger i = 0; i < ([model.field.numberLenth integerValue]-sss.length); i ++) {
                            temp = [temp stringByAppendingString:@"0"];
                        }
                        textView.text = [[NSString stringWithFormat:@"%@.",rrr] stringByAppendingString:temp];
                        textView.selectedRange = NSMakeRange(location, 0);
                    }else{
                        
                        
                        NSInteger location1 = textView.selectedRange.location;
                        
                        if (location1 == textView.text.length) {// 光标在最后
                            
                            if (sss.length > [model.field.numberLenth integerValue]) {
                                
                                [MBProgressHUD showError:[NSString stringWithFormat:@"最多输入%@位小数",model.field.numberLenth] toView:KeyWindow];
                                
                            }
                        }
                        
                        if (sss.length > [model.field.numberLenth integerValue]) {
                            
                            textView.text = [[NSString stringWithFormat:@"%@.",rrr] stringByAppendingString:[sss substringToIndex:[model.field.numberLenth integerValue]]];
                        }else{
                            textView.text = [textView.text substringToIndex:textView.text.length-1];
                        }
                        
                        textView.selectedRange = NSMakeRange(location1, 0);
                        
                        
                    }
                    
                }
            }
            
        }
        
        if (textView.text.length) {
            
            CGFloat min = 0.0;
            CGFloat max = 0.0;
            if (!model.field.betweenMin || [model.field.betweenMin isEqualToString:@""]) {
                min = -MAXFLOAT;
            }else{
                min = [model.field.betweenMin floatValue];
            }
            if (!model.field.betweenMax || [model.field.betweenMax isEqualToString:@""]) {
                max = MAXFLOAT;
            }else{
                max = [model.field.betweenMax floatValue];
            }
            
            if ([textView.text floatValue] > max) {
                
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@输入范围为%@~%@",model.label,model.field.betweenMin,model.field.betweenMax] toView:KeyWindow];
                textView.text = [textView.text substringToIndex:textView.text.length-1];
            }
        }
        
    }
    
    UITextRange *range = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:range.start offset:0];
    
    if ([model.type isEqualToString:@"location"]) {
        
        
        if (!position) {
            
            if (textView.text.length > 50) {
                
                textView.text = [textView.text substringToIndex:50];
                [MBProgressHUD showError:@"最长50个字符" toView:KeyWindow];
            }
        }
    }
    
    if ([model.type isEqualToString:@"textarea"]) {
        
        if (!position) {
            
            if (textView.text.length > 1000) {
                
                textView.text = [textView.text substringToIndex:1000];
                [MBProgressHUD showError:@"最长1000个字符" toView:KeyWindow];
            }
        }
    }
    
    if ([model.type isEqualToString:@"text"]) {
        
        if (!position) {
            
            if (textView.text.length > 50) {
                
                textView.text = [textView.text substringToIndex:50];
                [MBProgressHUD showError:@"最长50个字符" toView:KeyWindow];
            }
            
            model.fieldValue = textView.text;
        }
    }
    
    model.fieldValue = textView.text;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    //    HQLog(@"text == size == %@",NSStringFromCGSize(self.textView.contentSize));
    //    HQLog(@"model == size == %@",NSStringFromCGSize([self.model.contentSize CGSizeValue]));
    
    if (self.textView.contentSize.height != [self.model.contentSize CGSizeValue].height) {
        
        self.model.contentSize = [NSValue valueWithCGSize:self.textView.contentSize];
        if ([self.delegate respondsToSelector:@selector(generalSingleCell:changedHeight:)]) {
            [self.delegate generalSingleCell:self changedHeight:[self.model.height floatValue]];
        }
    }
    
}

/** 创建cell */
+(instancetype)generalSingleCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFGeneralSingleOldCell";
    TFGeneralSingleOldCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFGeneralSingleOldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    cell.textView.textColor = ExtraLightBlackTextColor;
    return cell;
}

/** 提示文字 */
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.textView.placeholder = placeholder;
}
/** 是否可编辑 */
-(void)setEdit:(BOOL)edit{
    _edit = edit;
    self.textView.editable = edit;
    self.textView.userInteractionEnabled = edit;
    
}
/** 展示详情 */
-(void)setShowEdit:(BOOL)showEdit{
    
    _showEdit = showEdit;
    
    if (showEdit) {// 框
        
        self.borderView.layer.cornerRadius = 4;
        self.borderView.layer.borderWidth = 1;
        self.borderView.layer.borderColor = HexColor(0xd5d5d5).CGColor;
        self.borderView.layer.shadowColor = ClearColor.CGColor;
        self.borderView.layer.shadowOffset = CGSizeMake(0, 0);
        self.borderView.layer.shadowRadius = 0;
        self.borderView.layer.shadowOpacity = 0.5;
        self.borderView.backgroundColor = ClearColor;
        
    }else{// 阴影
        
        self.borderView.layer.cornerRadius = 4;
        self.borderView.layer.borderWidth = 0;
        self.borderView.layer.borderColor = HexColor(0xd5d5d5).CGColor;
        self.borderView.layer.shadowColor = HexColor(0xd5d5d5).CGColor;
        self.borderView.layer.shadowOffset = CGSizeMake(0, 0);
        self.borderView.layer.shadowRadius = 4;
        self.borderView.layer.shadowOpacity = 0.5;
        self.borderView.backgroundColor = WhiteColor;
    }
    
}

/** 标题 */
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}
/** 内容 */
-(void)setContent:(NSString *)content{
    _content = content;
    self.textView.text = content;
}
/** 提示图片 */
-(void)setTipImage:(NSString *)tipImage{
    _tipImage = tipImage;
    if (!IsStrEmpty(tipImage)) {
        [self.tipBtn setImage:IMG(tipImage) forState:UIControlStateNormal];
        [self.tipBtn setImage:IMG(tipImage) forState:UIControlStateHighlighted];
        // 跟新宽度
        [self.tipBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
        }];
        self.tipBtn.hidden = NO;
    }else{
        // 跟新宽度
        [self.tipBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        self.tipBtn.hidden = YES;
    }
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
/** 左图片 */
-(void)setLeftImage:(NSString *)leftImage{
    _leftImage = leftImage;
    if (!IsStrEmpty(leftImage)) {
        [self.leftBtn setImage:IMG(leftImage) forState:UIControlStateNormal];
        [self.leftBtn setImage:IMG(leftImage) forState:UIControlStateHighlighted];
        // 跟新宽度
        [self.leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
        }];
        self.leftBtn.hidden = NO;
    }else{
        // 跟新宽度
        [self.leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        self.leftBtn.hidden = YES;
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

/** cell高度 */
+(CGFloat)refreshGeneralSingleCellHeightWithModel:(TFCustomerRowsModel *)model{
    
    CGFloat height = 0;
    height += 8;// 顶部与标题的间距
    height += [HQHelper sizeWithFont:BFONT(12) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:model.label].height;// 标题高度
    height += 9;// 边框View与标题的间距
    height += 9;// 边框View与底部的间距
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-35,MAXFLOAT} titleStr:model.fieldValue];
    
    if ([model.type isEqualToString:@"textarea"]) {
        height += size.height + 15;// textView的高度 + 与边框View的上下间距 == 边框View的高度
        height = height<150?150:height;
    }else{
        height += size.height + 15;// textView的高度 + 与边框View的上下间距 == 边框View的高度
        height = height<75?75:height;
    }
    
    model.height = @(height);
    
    return height;
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
