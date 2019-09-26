//
//  TFSubformHeadCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/4.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSubformHeadCell.h"

@interface TFSubformHeadCell ()

@property (nonatomic, strong) UILabel *requireLabel;

@end

@implementation TFSubformHeadCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        UILabel *lable = [[UILabel alloc] init];
        lable.textColor = BlackTextColor;
        lable.font = FONT(14);
        lable.backgroundColor = ClearColor;
        [self addSubview:lable];
        lable.textAlignment = NSTextAlignmentLeft;
        self.titleLab = lable;
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
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
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addButton = btn;
        [btn addTarget:self action:@selector(addClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"+ 增加栏目" forState:UIControlStateNormal];
        [btn setTitle:@"+ 增加栏目" forState:UIControlStateHighlighted];
        [btn setTitleColor:GreenColor forState:UIControlStateNormal];
        [btn setTitleColor:GreenColor forState:UIControlStateHighlighted];
        btn.titleLabel.font = FONT(14);
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView).with.offset(-15);
            make.centerY.equalTo(lable.mas_centerY);
            make.height.mas_equalTo(40);
            
        }];
        
        self.layer.masksToBounds = YES;
        
    }
    return self;
}


- (void)addClicked:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(subformHeadCell:didClickedAddButton:)]) {
        [self.delegate subformHeadCell:self didClickedAddButton:btn];
    }
}


+ (instancetype)subformHeadCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFSubformHeadCell";
    TFSubformHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFSubformHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.layer.masksToBounds = YES;
    return cell;
}

-(void)setFieldControl:(NSString *)fieldControl{
    _fieldControl = fieldControl;
    
    if ([fieldControl isEqualToString:@"2"]) {
        self.requireLabel.hidden = NO;
    }else{
        self.requireLabel.hidden = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
