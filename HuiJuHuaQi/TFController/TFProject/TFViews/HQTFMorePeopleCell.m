//
//  HQTFMorePeopleCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFMorePeopleCell.h"
#import "HQTFPeopleView.h"
#import "HQEmployModel.h"
#import <SDWebImage/SDWebImage.h>
#import "TFEmployModel.h"
#import "TFChangeHelper.h"

#define LeftMargin 100
#define Padding 10


@interface HQTFMorePeopleCell ()

/** UIImageView *enterImage */
@property (nonatomic, weak) UIImageView *enterImage;

/** peopleViews */
@property (nonatomic, strong) NSMutableArray *views;

/** peopleViews */
@property (nonatomic, strong) NSArray *peoples;

@end

@implementation HQTFMorePeopleCell

-(NSMutableArray *)views{
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup11];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setup11];
}

+ (HQTFMorePeopleCell *)morePeopleCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFMorePeopleCell";
    HQTFMorePeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[HQTFMorePeopleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    //cell.topLine.hidden = YES;
    //cell.bottomLine.hidden = YES;
    cell.layer.masksToBounds = YES;
    return cell;
}

-(void)setImageHidden:(BOOL)imageHidden{
    _imageHidden = imageHidden;
    
    self.enterImage.hidden = imageHidden;
    
}



-(void)refreshMorePeopleCellWithPeoples:(NSArray *)peoples{
    
    self.peoples = peoples;
    for (UIView *view in self.views) {
        
        [view removeFromSuperview];
    }
    [self.views removeAllObjects];
    NSInteger index = peoples.count + 1;
    if (self.imageHidden) {
        index = peoples.count;
    }
    
    for (NSInteger i = 0; i < index; i++) {
        HQTFPeopleView *people = [HQTFPeopleView peopleView];
        people.headName.hidden = YES;
        [self.contentView addSubview:people];
        [self.views addObject:people];
        
        if (i==peoples.count) {
        
            [people.headImage setImage:[UIImage imageNamed:@"加人"] forState:UIControlStateNormal];
        }else{
            HQEmployModel *employ = peoples[i];
            // 根据employ设置头像
            
            
            [people.headImage setTitle:nil forState:UIControlStateNormal];
            [people.headImage sd_setImageWithURL:[HQHelper URLWithString:employ.photograph] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (image) {
                    
                }else{
                    
                    [people.headImage setImage:nil forState:UIControlStateNormal];
                    [people.headImage setTitle:[HQHelper nameWithTotalName:employ.employeeName?:employ.employee_name] forState:UIControlStateNormal];
                    
                }
                
            }];
            
//            [people.headImage sd_setImageWithURL:[HQHelper URLWithString:employ.photograph] placeholderImage:PlaceholderHeadImage];
        }
    }

}

/** 投诉建议 */
-(void)refreshMorePeopleCellWithAdvisePeoples:(NSArray *)peoples{
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for (TFEmployModel *mdoel in peoples) {
        
        [arr addObject:[TFChangeHelper tfEmployeeToHqEmployee:mdoel]];
    }
    self.peoples = arr;
    peoples = arr;
    
    for (UIView *view in self.views) {
        
        [view removeFromSuperview];
    }
    [self.views removeAllObjects];
    NSInteger index = peoples.count + 1;
    if (self.imageHidden) {
        index = peoples.count;
    }
    
    for (NSInteger i = 0; i < index; i++) {
        HQTFPeopleView *people = [HQTFPeopleView peopleView];
        people.headName.hidden = YES;
        [self.contentView addSubview:people];
        [self.views addObject:people];
        
        if (i==peoples.count) {
            
            [people.headImage setImage:[UIImage imageNamed:@"加人"] forState:UIControlStateNormal];
        }else{
            HQEmployModel *employ = peoples[i];
            
            // 根据employ设置头像
            
            
            if (employ.picture && employ.picture.length) {
                
                [people.headImage setTitle:nil forState:UIControlStateNormal];
                [people.headImage sd_setImageWithURL:[HQHelper URLWithString:employ.picture] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
            }else{
                [people.headImage setImage:nil forState:UIControlStateNormal];
                [people.headImage setTitle:[HQHelper nameWithTotalName:employ.employeeName] forState:UIControlStateNormal];
            }
            
            //            [people.headImage sd_setImageWithURL:[HQHelper URLWithString:employ.photograph] placeholderImage:PlaceholderHeadImage];
        }
    }
    
}


- (void)setup11{
    
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.frame = CGRectMake(15, 0, 85, self.height);
    self.titleLabel.font = FONT(14);
    self.titleLabel.textColor = ExtraLightBlackTextColor;
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.frame = CGRectMake(LeftMargin + 30 + Padding, 0, SCREEN_WIDTH-LeftMargin-15-20 - 30 - Padding, self.height);
    self.contentLabel.font = FONT(16);
    self.contentLabel.textColor = LightBlackTextColor;
    [self.contentView addSubview:self.contentLabel];
    
    UIImageView *enterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下一级浅灰"]];
    enterImage.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:enterImage];
    enterImage.frame = CGRectMake(SCREEN_WIDTH-15-16, (self.height-16)/2, 16, 16);
    self.enterImage = enterImage;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.layer.masksToBounds = YES;
    self.contentView.layer.masksToBounds = YES;
    
    
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
        make.top.equalTo(self.contentView).with.offset(17);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(15);
        
    }];
    
    requi.hidden = YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    self.titleLabel.centerY = self.height/2;
    self.contentLabel.centerY = self.height/2;
    self.enterImage.centerY = self.height/2;
    
    
    CGFloat width = 35;
    
    for (NSInteger i = 0; i < self.views.count; i++) {
        
        HQTFPeopleView *view = self.views[i];
        
        view.frame = CGRectMake(LeftMargin+i*(width+Padding), (self.height-width)/2, width, width);
        view.headImage.layer.cornerRadius = width/2;
        view.headImage.layer.masksToBounds = YES;
        
        view.centerY = self.height/2;
        
        if (i > 4) {// 隐藏
            view.hidden = YES;
            
        }else{// 显示
            view.hidden = NO;
            
            
            if (self.views.count > 4) {
                
                if (self.imageHidden) {
                    
                    HQEmployModel *employ = self.peoples[i];
                    
                    [view.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                    [view.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
                    
                    if (employ.photograph && employ.photograph.length) {
                        
                        [view.headImage setTitle:nil forState:UIControlStateNormal];
                        [view.headImage sd_setImageWithURL:[HQHelper URLWithString:employ.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
                    }else{
                        [view.headImage setImage:nil forState:UIControlStateNormal];
                        [view.headImage setTitle:[HQHelper nameWithTotalName:employ.employeeName?:employ.employee_name] forState:UIControlStateNormal];
                    }
//                    [view.headImage sd_setImageWithURL:[HQHelper URLWithString:employ.photograph] placeholderImage:PlaceholderHeadImage];
                    
                }else{
                    
                    if (4 == i) {
                        
                        [view.headImage setImage:[UIImage imageNamed:@"加人"] forState:UIControlStateNormal];
                        
                        [view.headImage setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forState:UIControlStateNormal];
                        [view.headImage setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forState:UIControlStateHighlighted];
                    }else{
                        HQEmployModel *employ = self.peoples[i];
                        
                        [view.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                        [view.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
                        
                        if (employ.photograph && employ.photograph.length) {
                            
                            [view.headImage setTitle:nil forState:UIControlStateNormal];
                            [view.headImage sd_setImageWithURL:[HQHelper URLWithString:employ.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
                        }else{
                            [view.headImage setImage:nil forState:UIControlStateNormal];
                            [view.headImage setTitle:[HQHelper nameWithTotalName:employ.employeeName?:employ.employee_name] forState:UIControlStateNormal];
                        }
//                        [view.headImage sd_setImageWithURL:[HQHelper URLWithString:employ.photograph] placeholderImage:PlaceholderHeadImage];
                    }
                }
                
            }else{
                
                if (self.imageHidden) {
                    
                    HQEmployModel *employ = self.peoples[i];
                    
                    [view.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                    [view.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
                    if (employ.photograph && employ.photograph.length) {
                        
                        [view.headImage setTitle:nil forState:UIControlStateNormal];
                        [view.headImage sd_setImageWithURL:[HQHelper URLWithString:employ.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
                    }else{
                        [view.headImage setImage:nil forState:UIControlStateNormal];
                        [view.headImage setTitle:[HQHelper nameWithTotalName:employ.employeeName?:employ.employee_name] forState:UIControlStateNormal];
                    }
//                    [view.headImage sd_setImageWithURL:[HQHelper URLWithString:employ.photograph] placeholderImage:PlaceholderHeadImage];
                }else{
                    if (self.views.count-1 == i) {
                        
                        [view.headImage setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forState:UIControlStateNormal];
                        [view.headImage setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forState:UIControlStateHighlighted];
                        [view.headImage setImage:[UIImage imageNamed:@"加人"] forState:UIControlStateNormal];
                    }else{
                        
                        HQEmployModel *employ = self.peoples[i];
                        
                        [view.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                        [view.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
                        
                        if (employ.photograph && employ.photograph.length) {
                            
                            [view.headImage setTitle:nil forState:UIControlStateNormal];
                            [view.headImage sd_setImageWithURL:[HQHelper URLWithString:employ.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
                        }else{
                            [view.headImage setImage:nil forState:UIControlStateNormal];
                            [view.headImage setTitle:[HQHelper nameWithTotalName:employ.employeeName?:employ.employee_name] forState:UIControlStateNormal];
                        }
//                        [view.headImage sd_setImageWithURL:[HQHelper URLWithString:employ.photograph] placeholderImage:PlaceholderHeadImage];
                    }
                }
                
            }
            
        }
        
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
