//
//  TFCustomOptionCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomOptionCell.h"
#define Margin 8
#define Height 18
#define PlacehoderStringLeft @"%"
#define PlacehoderStringRight @"$"

@implementation TFCustomOptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        UIView *borderView = [[UIView alloc] init];
        [self.contentView insertSubview:borderView atIndex:0];
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
        
        TFTagListView *tagListView = [[TFTagListView alloc] init];
        tagListView.backgroundColor = ClearColor;
        [self.contentView addSubview:tagListView];
        self.tagListView = tagListView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [tagListView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).with.offset(101);
            make.top.equalTo(self).with.offset(5);
            make.bottom.equalTo(self.contentView).with.offset(-5);
            make.right.equalTo(self.contentView).with.offset(-15);
            
        }];
        
        UILabel *lable = [[UILabel alloc] init];
        lable.textColor = ExtraLightBlackTextColor;
        lable.font = FONT(14);
        lable.backgroundColor = ClearColor;
        [self addSubview:lable];
        lable.textAlignment = NSTextAlignmentLeft;
        self.titleLab = lable;
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
        
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下一级浅灰"]];
        arrow.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:arrow];
        self.arrow = arrow;
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView).with.offset(-2);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(44);
            
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        
        [self.arrow addGestureRecognizer:tap];
        
        self.layer.masksToBounds = YES;
    }
    return self;
}
- (void)tapAction{
    
    NSInteger section = self.arrow.tag / 0x777;
    NSInteger row = self.arrow.tag % 0x777;
    
    if ([self.delegate respondsToSelector:@selector(arrowClicked:section:)]) {
        [self.delegate arrowClicked:row section:section];
    }
}

-(void)setStructure:(NSString *)structure{
    
    _structure = structure;
    
    if ([structure isEqualToString:@"0"]) {
        
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView).with.offset(10);
            
            make.width.mas_equalTo(SCREEN_WIDTH-30);
        }];
        
        [self.tagListView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).with.offset(15);
            make.top.equalTo(self).with.offset(35);
            
        }];
        
        
        [self.arrow mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView.mas_bottom).offset(-22);
            
        }];
    }else{
        
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView).with.offset(22);
            
            make.width.mas_equalTo(101);
        }];
        [self.tagListView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).with.offset(101);
            make.top.equalTo(self).with.offset(22);
            
        }];
        
        
        [self.arrow mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView.mas_centerY);
            
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


-(void)setArrowType:(BOOL)arrowType{
    _arrowType = arrowType;
    
    if (arrowType) {// 删除
        
        self.arrow.image = [UIImage imageNamed:@"清除"];
        self.arrow.userInteractionEnabled = YES;
    }else{// 箭头
        
        self.arrow.image = [UIImage imageNamed:@"下一级浅灰"];
        self.arrow.userInteractionEnabled = NO;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}


+ (instancetype)creatCustomOptionCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFCustomOptionCell";
    TFCustomOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TFCustomOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.layer.masksToBounds = YES;
    return cell;
}


- (void)refreshCustomOptionCellWithOptions:(NSArray *)options{
    
//    [self.tagListView refreshWithOptions:options];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tagListView refreshWithOptions:options];
    });
    
}

+ (CGFloat)refreshCustomOptionCellHeightWithOptions:(NSArray *)options withStructure:(NSString *)structure{
    
    CGFloat cellHeight = 0;
    CGFloat listWidth = 0;
    if ([structure isEqualToString:@"0"]) {// 上下
        
        listWidth = SCREEN_WIDTH - 30;
        
    }else{// 左右
        
        listWidth = SCREEN_WIDTH - 15 - 101;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < options.count; i++) {
        TFCustomerOptionModel *option = options[i];
        
        if (option.color && ![option.color isEqualToString:@""] && ![[option.color uppercaseString] isEqualToString:@"#FFFFFF"]) {
            
            NSString *text = [NSString stringWithFormat:@"%@%@%@",PlacehoderStringLeft,option.label,PlacehoderStringRight];
            CGSize size = [HQHelper sizeWithFont:FONT(10) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:text];
            
            CGFloat w = size.width > listWidth - 30 ? listWidth - 30 : size.width;
            [arr addObject:[NSNumber numberWithFloat:w]];
           
        }else{
            
            
            NSString *text = [NSString stringWithFormat:@"%@、",option.label];
            CGSize size = [HQHelper sizeWithFont:FONT(15) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:text];
            
            CGFloat w = size.width > listWidth - 30 ? listWidth - 30 : size.width;
            [arr addObject:[NSNumber numberWithFloat:w]];
            
        }
    }

    CGFloat X = 0;
    CGFloat Y = 0;
    NSInteger index = 0;
    
    for (NSNumber *label in arr) {
        
        if (X + [label floatValue] + Margin <= listWidth) {// 同行
            
            X += ([label floatValue] + Margin);
            
        }else{// 换行
            index += 1;
            X = 0;
            X += ([label floatValue] + Margin);
        }
    }
    
    Y = (index + 1) * (Height + Margin);
    
    
    if ([structure isEqualToString:@"0"]) {// 上下
        
        cellHeight = Y + 38;
        
    }else{// 左右
        
        
        cellHeight = Y + 38;
        
    }
    
    return cellHeight;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
