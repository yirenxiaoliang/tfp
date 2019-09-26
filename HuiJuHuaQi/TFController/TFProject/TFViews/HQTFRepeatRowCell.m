//
//  HQTFRepeatRowCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFRepeatRowCell.h"
#define LeftMargin 100
#define Count (self.count)
#define BtnWidth 60

@interface HQTFRepeatRowCell ()
/** items */
@property (nonatomic, strong) NSArray *items;

/** buttons */
@property (nonatomic, strong) NSMutableArray *buttons;
/** lines */
@property (nonatomic, strong) NSMutableArray *lines;

@property (nonatomic , assign) NSInteger count;

/** buttons */
@property (nonatomic, strong) NSMutableArray *selectButtons;

@end

@implementation HQTFRepeatRowCell
-(NSMutableArray *)buttons{
    
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(NSMutableArray *)selectButtons{
    
    if (!_selectButtons) {
        _selectButtons = [NSMutableArray array];
    }
    return _selectButtons;
}

-(NSMutableArray *)lines{
    
    if (!_lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}

-(NSArray *)items{
    
    if (!_items) {
        _items = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    }
    return _items;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        if (SCREEN_WIDTH < 375) {
            self.count = 3;
        }else{
            self.count = 4;
        }
        
        [self setupChild];
    }
    return self;
}

- (void)setupChild{
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:(CGRect){15,15,100,20}];
    title.font = FONT(14);
    title.textColor = CellTitleNameColor;
    title.text = @"重复时间";
    [self.contentView addSubview:title];
    
    for (NSInteger i = 0; i < self.items.count; i ++) {
        
        UIButton *button = [HQHelper buttonWithFrame:CGRectZero target:self action:@selector(buttonClick:)];
        [button setImage:[UIImage imageNamed:@"未选择24"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"未选择24"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"选择24"] forState:UIControlStateSelected];
        [button setTitle:[NSString stringWithFormat:@" %@",self.items[i]] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@" %@",self.items[i]] forState:UIControlStateHighlighted];
        [button setTitle:[NSString stringWithFormat:@" %@",self.items[i]] forState:UIControlStateSelected];
        button.tag = 0x123 + i;
        [button setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
        [button setTitleColor:LightGrayTextColor forState:UIControlStateHighlighted];
        [button setTitleColor:LightGrayTextColor forState:UIControlStateSelected];
        [self.contentView addSubview:button];
        [self.buttons addObject:button];
    }
    
//    for (NSInteger i = 0; i < 2; i++) {
//        UIView *view = [[UIView alloc] init];
//        [self.contentView addSubview:view];
//        view.backgroundColor = CellSeparatorColor;
//        [self.lines addObject:view];
//    }
    
}

- (void)buttonClick:(UIButton *)button{
    
    
    button.selected = !button.selected;
    
    [self.selectButtons removeAllObjects];
    
    for (UIButton *btn in self.buttons) {
        
        if (btn.selected) {
            
            [self.selectButtons addObject:@(btn.tag - 0x123)];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(repeatRowCellWithIndexs:)]) {
        [self.delegate repeatRowCellWithIndexs:self.selectButtons];
    }
    
//    if (button.tag - 0x123 == 0) {// 每天
//        
//        for (UIButton *btn in self.buttons) {
//            btn.selected = NO;
//        }
//        button.selected = YES;
//    }else{
//        
//        UIButton *btn = self.buttons[0];
//        btn.selected = NO;
//        
//        button.selected = !button.selected;
//        
//    }
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat paddingWidth = (SCREEN_WIDTH - LeftMargin - BtnWidth*self.count)/self.count;
    CGFloat height = 55;
    for (NSInteger i = 0; i < self.buttons.count; i ++) {
        
        NSInteger row = i/self.count;
        NSInteger col = i%self.count;
        UIButton *btn = self.buttons[i];
        btn.frame = CGRectMake(LeftMargin + col * (BtnWidth + paddingWidth), row * height, BtnWidth, height);
        
    }
    
//    for (NSInteger i = 0; i < self.lines.count; i ++) {
//        
//        UIView *view = self.lines[i];
//        
//        view.frame = CGRectMake(15, 55 + i * height, SCREEN_WIDTH-15, 0.5);
//    }
    
}

+(instancetype)repeatRowCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"HQTFRepeatRowCell";
    HQTFRepeatRowCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[HQTFRepeatRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = YES;
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
