//
//  HQTFHeartCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFHeartCell.h"
#import "HQEmployModel.h"
#import "UIButton+WebCache.h"
#define Margin 15
#define Padding 10
#define Count 8


@interface HQTFHeartCell ()

/** 点赞 */
@property (nonatomic, weak) UIButton *heart;

/** 点赞 */
@property (nonatomic, weak) UIButton *heartBtn;

/** textLabel */
@property (nonatomic, weak) UILabel *peopleNumLabel;


/** peoples */
@property (nonatomic, strong) NSMutableArray *peopleBtns;


@end


@implementation HQTFHeartCell

-(NSMutableArray *)peopleBtns{
    if (!_peopleBtns) {
        _peopleBtns = [NSMutableArray array];
    }
    return _peopleBtns;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
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

-(void)setupChildView{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.heartBtn = button;
    button.userInteractionEnabled = NO;
    [button setImage:[UIImage imageNamed:@"点赞没"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"点赞呦"] forState:UIControlStateSelected];
    [self.contentView addSubview:button];
    
    UILabel *textLabel = [[UILabel alloc] init];
    [self.contentView addSubview:textLabel];
    textLabel.font = FONT(16);
    textLabel.textColor = ExtraLightBlackTextColor;
    self.peopleNumLabel = textLabel;
    
    self.layer.masksToBounds = YES;
    
    UIButton *heart = [UIButton buttonWithType:UIButtonTypeCustom];
//    [heart setImage:[UIImage imageNamed:@"点赞空白"] forState:UIControlStateNormal];
//    [heart setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateSelected];
    [heart setTitle:@"点赞" forState:UIControlStateNormal];
    [heart setTitle:@"取消点赞" forState:UIControlStateSelected];
    [self.contentView addSubview:heart];
    [heart setTitleColor:ExtraLightBlackTextColor forState:UIControlStateSelected];
    [heart setTitleColor:GreenColor forState:UIControlStateNormal];
    [heart addTarget:self action:@selector(heartClicked:) forControlEvents:UIControlEventTouchUpInside];
    heart.titleLabel.font = FONT(16);
    self.heart = heart;
    heart.hidden = YES;
    
}

-(void)setIsShow:(BOOL)isShow{
    _isShow = isShow;
    
    self.heart.hidden = !isShow;
}

- (void)heartClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(heartCellDidClickedHeart:)]) {
        [self.delegate heartCellDidClickedHeart:button];
    }
}

+ (HQTFHeartCell *)heartCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFHeartCell";
    HQTFHeartCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[HQTFHeartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = YES;
    return cell;
}


-(void)refreshHeartCellWithPeoples:(NSArray *)peoples{
    
    for (UIView *view  in self.peopleBtns) {
        
        [view removeFromSuperview];
    }
    
    [self.peopleBtns removeAllObjects];
    
    for (NSInteger i = 0; i < peoples.count; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btn];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 2;
        btn.titleLabel.font = FONT(12);
        [self.peopleBtns addObject:btn];
        
        HQEmployModel *employ = peoples[i];
        
        if (employ.photograph && ![employ.photograph isEqualToString:@""]) {
            
            [btn sd_setBackgroundImageWithURL:[HQHelper URLWithString:employ.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
            [btn sd_setBackgroundImageWithURL:[HQHelper URLWithString:employ.photograph] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
            [btn setTitle:@"" forState:UIControlStateNormal];
            [btn setTitle:@"" forState:UIControlStateHighlighted];
        }else{
            
            [btn setTitle:[HQHelper nameWithTotalName:employ.employeeName] forState:UIControlStateNormal];
            [btn setTitle:[HQHelper nameWithTotalName:employ.employeeName] forState:UIControlStateHighlighted];
            
            [btn setBackgroundImage:[HQHelper createImageWithColor:GrayGroundColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[HQHelper createImageWithColor:GrayGroundColor] forState:UIControlStateHighlighted];
            
        }
        
        
    }
    
    self.peopleNumLabel.text = [NSString stringWithFormat:@"%ld个人点赞",peoples.count];
    
    BOOL contain = NO;
    for (HQEmployModel *employ in peoples) {
        
        if ([employ.id isEqualToNumber:UM.userLoginInfo.employee.id] || [employ.employeeId isEqualToNumber:UM.userLoginInfo.employee.id]) {
            contain = YES;
            break;
        }
    }
    
    if (contain) {
        self.heartBtn.selected = YES;
        self.heart.selected = YES;
    }else{
        self.heartBtn.selected = NO;
        self.heart.selected = NO;
    }
    
}


+(CGFloat)refreshHeartCellHeightWithPeoples:(NSArray *)peoples{
    
    if (!peoples || peoples.count == 0) {
        return 0;
    }
    
    CGFloat width = (SCREEN_WIDTH - 2 * Margin - (Count - 1) * Padding)/Count;
    
    NSInteger row = (peoples.count + (Count - 1))/Count;
    
    return 48 + row * (width + Padding) + 5;
}

+(CGFloat)refreshHeartCellHeightWithPeoples:(NSArray *)peoples withType:(NSInteger)type{
    
    if (!peoples || peoples.count == 0) {
        if (type == 1) {
            return 55;
        }
        return 0;
    }
    
    CGFloat width = (SCREEN_WIDTH - 2 * Margin - (Count - 1) * Padding)/Count;
    
    NSInteger row = (peoples.count + (Count - 1))/Count;
    
    return 48 + row * (width + Padding) + 5;
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.heartBtn.frame = CGRectMake(17, 17, 18, 18);
    self.heart.frame = CGRectMake(SCREEN_WIDTH-85, 5, 70, 44);
    
    self.peopleNumLabel.frame = CGRectMake(CGRectGetMaxX(self.heartBtn.frame) + 8, 17, SCREEN_WIDTH-100, 20);
    self.peopleNumLabel.centerY = self.heartBtn.centerY;
    
    CGFloat width = (SCREEN_WIDTH - 2 * Margin - (Count - 1) * Padding)/Count;
    
    for (NSInteger i = 0; i < self.peopleBtns.count; i ++) {
        
        UIButton *btn = self.peopleBtns[i];
        
        NSInteger row = i / Count;
        NSInteger col = i % Count;
        
        btn.frame = CGRectMake(Margin + col * (width + Padding), CGRectGetMaxY(self.heartBtn.frame) + 15 + row * (width + Padding), width, width);
        
        btn.layer.cornerRadius = btn.width/2.0;
        btn.layer.masksToBounds = YES;
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
