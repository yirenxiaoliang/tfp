//
//  HQTFTimeTableView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/2.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTimeTableView.h"
#import "NSDate+Calendar.h"
#import "HQBaseCell.h"

@interface HQTFTimeTableView ()<UITableViewDelegate,UITableViewDataSource>


/** tableView */
@property (nonatomic, weak) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *daySps;
@property (assign, nonatomic) CGFloat timeCellWidth;
@end

@implementation HQTFTimeTableView

-(NSMutableArray *)daySps{
    
    if (!_daySps) {
        _daySps = [NSMutableArray array];
    }
    return _daySps;
}

- (void)refreshTimeTableViewWithSelectTimeSp:(long long)selectTimeSp
{
    
    [self.daySps removeAllObjects];
    long long oneDaySp = 24 * 60 * 60 * 1000;
    for (int i=0; i<21; i++) {
        
        long long daySp = selectTimeSp - 8*oneDaySp + i*oneDaySp;
        [self.daySps addObject:@(daySp)];
    }
    
    [self.tableView reloadData];
    self.tableView.contentOffset = CGPointMake(0, 7 * _timeCellWidth);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChild];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupChild];
    }
    return self;
}

- (void)setupChild{
    
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(12, 0, self.width-24, self.height)
                                                          style:UITableViewStylePlain];
    tableView.transform  = CGAffineTransformMakeRotation(-M_PI/2);
    tableView.frame = CGRectMake(12, 0, self.width-24, self.height);
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator   = NO;
    tableView.pagingEnabled = YES;
    tableView.layer.masksToBounds = YES;
    [self addSubview:tableView];
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    
    self.timeCellWidth = self.tableView.width / 7;
}

#pragma mark - tableView 数据源及代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.daySps.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"timeCell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"timeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI/2);
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [cell.contentView addSubview:button];
        button.frame = CGRectMake((_timeCellWidth-Long(35)) / 2.0, (self.tableView.height - Long(35))/2.0, Long(35.0), Long(35.0));
        
        
        button.layer.cornerRadius = Long(35.5)/2.0;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 0.8;
        button.layer.borderColor = WhiteColor.CGColor;
        button.tag = 0x1001;
        button.titleLabel.font = FONT(18);
        
//        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:(CGSize){100,100}];
//        CAShapeLayer *layer = [CAShapeLayer layer];
//        [layer setPath:path.CGPath];
//        button.layer.mask = layer;
        UIImageView *image = [[UIImageView alloc] initWithFrame:(CGRect){0,0,8,6}];
        image.image = [UIImage imageNamed:@"下啦灰色"];
        image.centerX = button.centerX;
        image.tag = 0x1002;
        [cell.contentView addSubview:image];
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIButton *button = (UIButton *)[cell.contentView viewWithTag:0x1001];
    button.userInteractionEnabled = NO;
    long long daySp = [self.daySps[indexPath.row] longLongValue];
    [button setTitle:[HQHelper nsdateToTime:daySp formatStr:@"dd"] forState:UIControlStateNormal];
    UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:0x1002];

    if (indexPath.row == 8) {
        image.hidden = NO;
        button.layer.borderWidth = 0.8;
//        [HQHelper createImageWithColor:GreenColor] [UIImage imageNamed:@"Oval"]
        [button setTitleColor:WhiteColor forState:UIControlStateNormal];
        [button setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xff6260, 1)] forState:UIControlStateNormal];
    }else {
        image.hidden = YES;
        button.layer.borderWidth = 0;
        [button setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [button setTitleColor:BlackTextColor forState:UIControlStateNormal];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return _timeCellWidth;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self scrollViewWithPage:indexPath.row-1];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (decelerate == NO) {
        
        [self scrollViewPageAnimation:scrollView];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [self scrollViewPageAnimation:scrollView];
}


- (void)scrollViewPageAnimation:(UIScrollView *)scrollView
{
    
    
    NSLog(@"%f", scrollView.contentOffset.y);
    NSInteger contentOffSetY = scrollView.contentOffset.y;
    NSInteger rowNum = contentOffSetY / _timeCellWidth;
    if (contentOffSetY % (NSInteger)_timeCellWidth > _timeCellWidth / 2) {
        
        rowNum++;
    }
    
    [self scrollViewWithPage:rowNum];
}



- (void)scrollViewWithPage:(NSInteger)page
{
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        
        self.tableView.contentOffset = CGPointMake(0, page * _timeCellWidth);
    } completion:^(BOOL finished) {
        
        
        long long timeSp = [_daySps[page+1] longLongValue];
        if ([self.delegate respondsToSelector:@selector(timeTableViewSelectTimeSp:)]) {
            
            [self.delegate timeTableViewSelectTimeSp:timeSp];
        }
        
        [self refreshTimeTableViewWithSelectTimeSp:timeSp];
    }];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
