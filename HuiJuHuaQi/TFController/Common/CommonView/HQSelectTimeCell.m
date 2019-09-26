//
//  HQSelectTimeCell.m
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/15.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQSelectTimeCell.h"
#import "NSDate+Calendar.h"

@interface HQSelectTimeCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelCenter;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelCenter;


@end

@implementation HQSelectTimeCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.timeTitle.text = @"时间";
    self.timeTitle.textColor = CellTitleNameColor;
    self.timeTitle.font = FONT(14);
    self.time.textColor = BlackTextColor;
    self.time.font = FONT(16);
    
    self.time.textAlignment = NSTextAlignmentLeft;
    self.time.text = @"";
    
    self.requireLabel.hidden = YES;
    self.layer.masksToBounds = YES;
    
    
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
    
    
//    self.arrow.userInteractionEnabled = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];

    [self.arrow addGestureRecognizer:tap];
    
}


- (void)tapAction {

    if ([self.delegate respondsToSelector:@selector(arrowClicked:section:)]) {
        
        [self.delegate arrowClicked:self.arrow.tag section:self.index];
    }
}

+ (instancetype)selectTimeCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQSelectTimeCell" owner:self options:nil] lastObject];
}


+ (instancetype)selectTimeCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"selectTimeCell";
    HQSelectTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self selectTimeCell];
    }
    cell.layer.masksToBounds = YES;
    cell.topLine.hidden = NO;
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setStructure:(NSString *)structure{
    _structure = structure;
    
    if ([structure isEqualToString:@"0"]) {
        self.titltW.constant = SCREEN_WIDTH-30;
        self.titleLabelCenter.constant = -12;
        self.contentLabelCenter.constant = 12;
        self.timeTitleWidthLayout.constant = 5;
        
    }else{
        
        self.titltW.constant = 90;
        self.titleLabelCenter.constant = 0;
        self.contentLabelCenter.constant = 0;
        self.timeTitleWidthLayout.constant = 95;
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

-(void)setFieldControl:(NSString *)fieldControl{
    _fieldControl = fieldControl;
    
    if ([fieldControl isEqualToString:@"2"]) {
        self.requireLabel.hidden = NO;
    }else{
        self.requireLabel.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}



- (void)setArrowShowState:(BOOL)arrowShowState
{
    _arrowShowState = arrowShowState;
    
    if (_arrowShowState) {
        
        self.arrow.hidden = NO;
        self.arrowWidth.constant = 30;
    }else {
        
        self.arrow.hidden = YES;
        self.arrowWidth.constant = 4;
    }
}


- (void)arrowHidden{
    
    self.arrow.hidden = YES;
    self.arrowWidth.constant = 4;
}



+ (CGFloat)getSelectTimeCellHeight:(NSString *)title
                           content:(NSString *)content
                    arrowShowState:(BOOL)arrowShowState
{

    CGFloat cellHeight = 22;
    
    CGFloat titleWidth = [HQHelper sizeWithFont:FONT(17)
                                        maxSize:CGSizeMake(1000, 20)
                                       titleStr:title].width + 17;
    CGFloat arrowWidth;
    if (arrowShowState) {
        arrowWidth = 18;
    }else {
        arrowWidth = 4;
    }
    
    CGFloat textWidth = SCREEN_WIDTH - titleWidth - arrowWidth - 20;
    
    NSInteger contentLineNum = [HQHelper returnLineNumberOfString:content font:FONT(17) textWidth:textWidth];
    
    cellHeight += contentLineNum * 20;
    
    return cellHeight;
}



@end
