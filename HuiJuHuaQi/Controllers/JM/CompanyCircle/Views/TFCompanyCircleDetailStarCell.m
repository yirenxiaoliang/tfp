//
//  TFCompanyCircleDetailStarCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCompanyCircleDetailStarCell.h"

#define buttonWidth 35

@interface TFCompanyCircleDetailStarCell ()

/** imageViews */
@property (nonatomic, strong) NSMutableArray *imageViews;

/** peoples */
@property (nonatomic, strong) NSMutableArray *peoples;


@end

@implementation TFCompanyCircleDetailStarCell

-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}

-(NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupChild];
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setupChild{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){0,10,buttonWidth,buttonWidth}];
    [self.contentView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"点赞people"];
    self.backgroundColor = ClearColor;
    imageView.backgroundColor = ClearColor;
    self.contentView.backgroundColor = ClearColor;
    imageView.contentMode = UIViewContentModeCenter;
}

-(void)refreshCompanyCircleDetailStarCellWithPeoples:(NSArray *)peoples{
    
    self.peoples = [NSMutableArray arrayWithArray:peoples];
    
    for (UIImageView *imageView in self.imageViews) {
        
        [imageView removeFromSuperview];
    }
    
    [self.imageViews removeAllObjects];
    
    for (NSInteger i = 0; i < peoples.count; i ++) {
        HQEmployModel *model = peoples[i];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = i;
        [self addSubview:imageView];
        [self.imageViews addObject:imageView];
        [imageView sd_setImageWithURL:[HQHelper URLWithString:model.photograph] placeholderImage:PlaceholderHeadImage];;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
        [imageView addGestureRecognizer:tap];
        imageView.backgroundColor = ClearColor;
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.tag = 0x123 + i;
    }
    
}
- (void)imageViewClicked:(UITapGestureRecognizer *)tap{
    
    HQEmployModel * employModel =  self.peoples[tap.view.tag-0x123];
    if ([self.delegate respondsToSelector:@selector(companyCircleDetailStarCellDidPeople:)]) {
        [self.delegate companyCircleDetailStarCellDidPeople:employModel];
    }
}


+ (CGFloat)refreshCompanyCircleDetailStarCellHeightWithPeoples:(NSArray *)peoples{
    
    if (peoples.count == 0) {
        return 0;
    }
    CGFloat maxWidth = SCREEN_WIDTH - 30 - buttonWidth;
    NSInteger count = maxWidth / (buttonWidth + 8) ;
    NSInteger row = (peoples.count + (count - 1))/count;
    CGFloat height = row * buttonWidth + (row - 1) * 8 + 20;
    
    return height;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat maxWidth = SCREEN_WIDTH - 30 - buttonWidth;
    NSInteger count = maxWidth / (buttonWidth + 8) ;
    CGFloat margin = buttonWidth;
    
    for (NSInteger i = 0; i < self.imageViews.count; i ++) {
        UIImageView *imageView = self.imageViews[i];
        
        NSInteger row = i/count;
        NSInteger col = i % count;
        
        imageView.frame = CGRectMake(margin + col *( buttonWidth + 8), 10 + row *( buttonWidth + 8), buttonWidth, buttonWidth);
    }
}



+(instancetype)companyCircleDetailStarCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFCompanyCircleDetailStarCell";
    TFCompanyCircleDetailStarCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFCompanyCircleDetailStarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = NO;
    cell.headMargin = 0;
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
