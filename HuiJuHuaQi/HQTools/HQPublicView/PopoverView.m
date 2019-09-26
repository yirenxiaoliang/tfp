//
//  PopoverView.m
//  ArrowView
//
//  Created by guojiang on 4/9/14.
//  Copyright (c) 2014年 LINAICAI. All rights reserved.
//



#import "PopoverView.h"
#import "UIView+Extension.h"

#define kArrowHeight 0.f
#define kArrowCurvature 10.f
#define SPACE 0.f
#define ROW_HEIGHT 48.f
#define TITLE_FONT [UIFont systemFontOfSize:16]
#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

@interface PopoverView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic) CGPoint showPoint;

@property (nonatomic, strong) UIButton *handerView;

@end

@implementation PopoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.borderColor = HexAColor(0x000000, 0.75);
        self.backgroundColor = ClearColor;
//        self.layer.cornerRadius = 4;
//        self.layer.masksToBounds = YES;
        
    }
    return self;
}

-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images
{
    self = [super init];
    if (self) {
        self.showPoint = point;
        self.titleArray = titles;
        self.imageArray = images;
        
        self.frame = [self getViewFrame];
        
        [self addSubview:self.tableView];
    }
    return self;
}

-(CGRect)getViewFrame
{
    CGRect frame = CGRectZero;
    
    frame.size.height = [self.titleArray count] * ROW_HEIGHT + SPACE + kArrowHeight + 10;
    
    for (NSString *title in self.titleArray) {
        
        
        CGFloat width = [HQHelper sizeWithFont:TITLE_FONT maxSize:CGSizeMake(300, 100) titleStr:title].width;
//        
//        
//        [title sizeWithFont:TITLE_FONT constrainedToSize:CGSizeMake(300, 100) lineBreakMode:NSLineBreakByCharWrapping].width;
        frame.size.width = MAX(width, frame.size.width);
    }
    
    if ([self.titleArray count] == [self.imageArray count]) {
        frame.size.width = 10 + 25 + 10 + frame.size.width + 30;
    }else{
        frame.size.width = 10 + frame.size.width + 30;
    }
    
    frame.origin.x = self.showPoint.x - frame.size.width;
    frame.origin.y = self.showPoint.y;
    
//    //左间隔最小5x
//    if (frame.origin.x < 5) {
//        frame.origin.x = 5;
//    }
//    //右间隔最小5x
//    if ((frame.origin.x + frame.size.width) > 315) {
//        frame.origin.x = 315 - frame.size.width;
//    }
    
    return frame;
}


-(void)show
{
    self.handerView = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_handerView setFrame:[UIScreen mainScreen].bounds];
    
    
    [_handerView setFrame:CGRectMake(0, self.showPoint.y == 0 ? 64 : 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_handerView setBackgroundColor:[UIColor clearColor]];
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_handerView addSubview:self];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_handerView];
    
    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / self.frame.size.width, arrowPoint.y / self.frame.size.height);
    self.frame = [self getViewFrame];
    
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 0.9f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

-(void)dismiss
{
    [self dismiss:YES];
   
}

-(void)dismiss:(BOOL)animate
{
    if (!animate) {
        [_handerView removeFromSuperview];
        _handerView = nil;
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
        _handerView = nil;
    }];
    
}


#pragma mark - UITableView

-(UITableView *)tableView
{
    if (_tableView != nil) {
        return _tableView;
    }
    
    CGRect rect = self.frame;
    
    rect.origin.x =  SPACE ;
    rect.origin.y = 10;
    rect.size.width -= SPACE * 2;

    rect.size.height -= (SPACE - kArrowHeight);
    rect.size.height = self.titleArray.count * ROW_HEIGHT;
    
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alwaysBounceHorizontal = NO;
    _tableView.alwaysBounceVertical = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = self.borderColor;
    _tableView.backgroundView.alpha = 0;
//    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.layer.cornerRadius = 4;
    _tableView.layer.masksToBounds = YES;
    
    return _tableView;
}

#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundView = [[UIView alloc] init];
    cell.backgroundView.backgroundColor = self.borderColor;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row < self.titleArray.count - 1) {
        UIView *sepa = [[UIView alloc] initWithFrame:(CGRect){0,ROW_HEIGHT - 0.5, cell.frame.size.width, 0.5}];
        [cell.contentView addSubview:sepa];
        sepa.backgroundColor = CellSeparatorColor;
    }
    
    if ([_imageArray count] == [_titleArray count]) {
        cell.imageView.image = [UIImage imageNamed:[_imageArray objectAtIndex:indexPath.row]];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if (self.type == 1) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.selectRowAtIndex) {
        self.selectRowAtIndex(indexPath.row);
    }
    [self dismiss:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self.borderColor set]; //设置线条颜色
    
    CGRect frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - kArrowHeight);
    
//    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame)+10;
    
    float xMax = CGRectGetMaxX(frame);
//    float yMax = CGRectGetMaxY(frame);
    
//    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];
    
    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
//    [popoverPath moveToPoint:CGPointMake(xMin, yMin)];//左上角
    
    /********************向上的箭头**********************/
//    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMin)];//left side
//    [popoverPath addCurveToPoint:arrowPoint
//                   controlPoint1:CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMin)
//                   controlPoint2:arrowPoint];//actual arrow point
//    
//    [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMin)
//                   controlPoint1:arrowPoint
//                   controlPoint2:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin)];//right side
    
    
    [popoverPath moveToPoint:CGPointMake(xMax-30, yMin)];//左上角
    
//    [popoverPath addLineToPoint:CGPointMake(xMax-30, yMin)];//右上角
    
    [popoverPath addLineToPoint:CGPointMake(xMax-20, yMin-10)];//右下角
    
    [popoverPath addLineToPoint:CGPointMake(xMax-10, yMin)];//左下角
    
    
    
    /********************向上的箭头**********************/
    
    
//    [popoverPath addLineToPoint:CGPointMake(xMax, yMin)];//右上角
//
//    [popoverPath addLineToPoint:CGPointMake(xMax, yMax)];//右下角
//
//    [popoverPath addLineToPoint:CGPointMake(xMin, yMax)];//左下角
    
    //填充颜色
    [[UIColor blackColor] setFill];
    [popoverPath fill];
    
    [popoverPath closePath];
    [popoverPath stroke];
}


@end
