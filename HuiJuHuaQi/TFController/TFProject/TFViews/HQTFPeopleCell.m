//
//  HQTFPeopleCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFPeopleCell.h"
#import "HQTFPeopleView.h"
#import "HQEmployModel.h"

#define LeftMargin 101

@interface HQTFPeopleCell ()

/** 存放Views */
@property (nonatomic, strong) NSMutableArray *views;

@property (weak, nonatomic) HQTFPeopleView *people1;
@property (weak, nonatomic) HQTFPeopleView *people2;
@property (weak, nonatomic) HQTFPeopleView *people3;


@end

@implementation HQTFPeopleCell

-(NSMutableArray *)views{
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabel.font = FONT(14);
    self.titleLabel.textColor = CellTitleNameColor;
    
    self.contentLabel.font = FONT(16);
    self.contentLabel.textColor = PlacehoderColor;
    
    
    self.people1 = [HQTFPeopleView peopleView];
    [self.contentView addSubview:self.people1];
    
    self.people2 = [HQTFPeopleView peopleView];
    [self.contentView addSubview:self.people2];
    
    self.people3 = [HQTFPeopleView peopleView];
    [self.contentView addSubview:self.people3];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.requireLabel.hidden = YES;
}

+ (instancetype)peopleCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFPeopleCell" owner:self options:nil] lastObject];
}

+ (HQTFPeopleCell *)peopleCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFPeopleCell";
    HQTFPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = YES;
    if (!cell) {
        cell = [self peopleCell];
    }
    cell.layer.masksToBounds = YES;
    return cell;
}


- (void)setPeoples:(NSArray *)peoples{
    
    _peoples = peoples;
    
    switch (peoples.count) {
        case 0:
        {
            self.contentLabel.hidden = NO;
            self.contentLabel.textAlignment = NSTextAlignmentLeft;
            self.people1.hidden= YES;
            self.people2.hidden= YES;
            self.people3.hidden= YES;
            self.people1.headName.hidden = YES;
            self.people2.headName.hidden = YES;
            self.people3.headName.hidden = YES;
            self.people1.headName.text = @"";
            self.people2.headName.text = @"";
            self.people3.headName.text = @"";
            
        }
            break;
        case 1:
        {
            HQEmployModel *model1 = peoples[0];
            self.contentLabel.hidden = YES;
            self.contentLabel.textAlignment = NSTextAlignmentLeft;
            self.people1.hidden = NO;
            self.people2.hidden= YES;
            self.people3.hidden= YES;
            self.people1.headName.hidden = NO;
            self.people2.headName.hidden = YES;
            self.people3.headName.hidden = YES;
            self.people1.headName.text = model1.employeeName;
            self.people2.headName.text = @"";
            self.people3.headName.text = @"";
//            [self.people1.headImage sd_setImageWithURL:[HQHelper URLWithString:model1.photograph] placeholderImage:PlaceholderHeadImage];
            [self.people1.headImage sd_setImageWithURL:[HQHelper URLWithString:model1.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
            
        }
            break;
        case 2:
        {
            HQEmployModel *model1 = peoples[0];
            HQEmployModel *model2 = peoples[1];
            self.contentLabel.hidden = YES;
            self.contentLabel.textAlignment = NSTextAlignmentLeft;
            self.people1.hidden = NO;
            self.people2.hidden= NO;
            self.people3.hidden= YES;
            self.people1.headName.hidden = NO;
            self.people2.headName.hidden = NO;
            self.people3.headName.hidden = YES;
            self.people1.headName.text = model1.employeeName;
            self.people2.headName.text = model2.employeeName;
            self.people3.headName.text = @"";
            [self.people1.headImage sd_setImageWithURL:[HQHelper URLWithString:model1.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
            [self.people2.headImage sd_setImageWithURL:[HQHelper URLWithString:model2.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
            
        }
            break;
            
        default:
        {
            HQEmployModel *model1 = peoples[0];
            HQEmployModel *model2 = peoples[1];
            HQEmployModel *model3 = peoples[2];
            self.people1.hidden = NO;
            self.people2.hidden= NO;
            self.people3.hidden= NO;
            self.people1.headName.hidden = YES;
            self.people2.headName.hidden = YES;
            self.people3.headName.hidden = YES;
            self.people1.headName.text = model1.employeeName;
            self.people2.headName.text = model2.employeeName;
            self.people3.headName.text = model3.employeeName;
            
            self.contentLabel.hidden = NO;
            self.contentLabel.textAlignment = NSTextAlignmentRight;
            self.contentLabel.textColor = LightBlackTextColor;
            self.contentLabel.text = [NSString stringWithFormat:@"%ld人",peoples.count];
            [self.people1.headImage sd_setImageWithURL:[HQHelper URLWithString:model1.photograph] forState:UIControlStateNormal  placeholderImage:PlaceholderHeadImage];
            [self.people2.headImage sd_setImageWithURL:[HQHelper URLWithString:model2.photograph] forState:UIControlStateNormal  placeholderImage:PlaceholderHeadImage];
            [self.people3.headImage sd_setImageWithURL:[HQHelper URLWithString:model3.photograph] forState:UIControlStateNormal  placeholderImage:PlaceholderHeadImage];
        }
            break;
    }
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    CGFloat width = 0;
    if (self.peoples.count > 2) {
        width = 35;
    }else{
        width = 100;
    }
    self.people1.frame = CGRectMake(LeftMargin, (self.height-35)/2, width, 35);
    self.people2.frame = CGRectMake(LeftMargin + width + 10, (self.height-35)/2, width, 35);
    self.people3.frame = CGRectMake(LeftMargin + 2 * (width + 10), (self.height-35)/2, width, 35);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
