//
//  TFSingleTextCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSingleTextCell.h"
#import "HQAdviceTextView.h"

@interface TFSingleTextCell ()

@end


@implementation TFSingleTextCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        
        UIView *borderView = [[UIView alloc] init];
        [self.contentView addSubview:borderView];
        borderView.layer.borderColor = CellClickColor.CGColor;
        borderView.layer.borderWidth = 0.5;
        self.borderView = borderView;
        borderView.hidden = YES;
        [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(95);
            make.top.equalTo(self.contentView).with.offset(15);
            make.bottom.equalTo(self.contentView).with.offset(-15);
            make.right.equalTo(self.contentView).with.offset(-15);
        }];
        
        
        UILabel *lable = [[UILabel alloc] init];
        lable.textColor = ExtraLightBlackTextColor;
        lable.font = FONT(14);
        lable.backgroundColor = ClearColor;
        [self.contentView addSubview:lable];
        lable.textAlignment = NSTextAlignmentLeft;
        self.titleLabel = lable;
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.contentView).with.offset(15);
            make.top.equalTo(self.contentView).with.offset(22);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(85);
            
        }];
        lable.text = @"";
        
        
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
        
        HQAdviceTextView *textView = [[HQAdviceTextView alloc] init];
        textView.backgroundColor = ClearColor;
        [self.contentView addSubview:textView];
        textView.contentInset = UIEdgeInsetsMake(2, 0, 0, 0);
        textView.font = FONT(14);
        self.textView = textView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(101);
            make.top.equalTo(self.contentView).with.offset(13);
            make.right.equalTo(self.contentView).with.offset(-44);
            make.bottom.equalTo(self.contentView).with.offset(-13);
            
        }];
        textView.font = FONT(16);
        textView.placeholderColor = PlacehoderColor;
        textView.placeholder = @"";
        
        UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:enterBtn];
        self.enterBtn = enterBtn;
        
        [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView).with.offset(-8);
            make.centerY.equalTo(textView.mas_centerY);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            
        }];
        
        [enterBtn setImage:nil forState:UIControlStateNormal];
        [enterBtn addTarget:self action:@selector(enterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)enterBtnClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(singleTextCell:didClilckedEnterBtn:)]) {
        [self.delegate singleTextCell:self didClilckedEnterBtn:button];
    }
}

-(void)setIsHideBtn:(BOOL)isHideBtn{
    _isHideBtn = isHideBtn;
    
    if (isHideBtn) {
        self.enterBtn.hidden = YES;
        [self.enterBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(0);
            
        }];
        
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView).with.offset(-15);
            
        }];
        
        [self.borderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-15);
        }];
        
    }else{
        
        self.enterBtn.hidden = NO;
        [self.enterBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(30);
            
        }];
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView).with.offset(-44);
            
        }];
        
        [self.borderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-44);
        }];
    }
    
}

-(void)setStructure:(NSString *)structure{
    
    _structure = structure;
    
    if ([structure isEqualToString:@"0"]) {
        
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView).with.offset(10);
            
            make.width.mas_equalTo(SCREEN_WIDTH-30);
            
        }];
        
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(10);
            make.top.equalTo(self.contentView).with.offset(32);
            make.bottom.equalTo(self.contentView).with.offset(-3);
            
        }];
        
        
        [self.borderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(10);
            make.top.equalTo(self.contentView).with.offset(32);
            make.bottom.equalTo(self.contentView).with.offset(-15);
        }];
        
    }else{
        
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView).with.offset(22);
            
            make.width.mas_equalTo(95);
        }];
        
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(105);
            make.top.equalTo(self.contentView).with.offset(12);
            make.bottom.equalTo(self.contentView).with.offset(-10);
            
        }];
        
        [self.borderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(95);
            make.top.equalTo(self.contentView).with.offset(15);
            make.bottom.equalTo(self.contentView).with.offset(-15);
        }];

        
    }
    
}

-(void)setFieldControl:(NSString *)fieldControl{
    _fieldControl = fieldControl;
    
    if ([fieldControl isEqualToString:@"2"]) {
        self.requireLabel.hidden = NO;
    }else{
        self.requireLabel.hidden = YES;
        
    }
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
}


+ (instancetype)singleTextCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFSingleTextCell";
    TFSingleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TFSingleTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.layer.masksToBounds = YES;
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
