//
//  HQAdvertisementView.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/8/1.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQAdvertisementView.h"


#define timeDistance 5.0

@interface HQAdvertisementView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSDate *pauseDate;// 暂停时的Date

@property (nonatomic, assign) CGFloat timeSp;// 现在与暂停的时间差

@end


@implementation HQAdvertisementView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _datas = [NSMutableArray array];
        
        [self creatTableViewWithAdvertisement];
        
        [self creatPageControlWithAdvertisement];
        
        
//        _timer = [NSTimer scheduledTimerWithTimeInterval:timeDistance
//                                                  target:self
//                                                selector:@selector(scrollViewAutoScroll)
//                                                userInfo:nil
//                                                 repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//        
//        self.pauseDate = [NSDate date];
        [self activeTime];
    }
    return self;
}

#pragma mark - 初始化tableView
- (void)creatTableViewWithAdvertisement
{

    self.tableView = [[UITableView alloc] initWithFrame:self.bounds
                                                  style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.pagingEnabled = YES;
    //从新设置frame
    self.tableView.frame = self.bounds;
    self.tableView.rowHeight = self.width;
    [self addSubview:self.tableView];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}



- (void)creatPageControlWithAdvertisement
{
    _pageBottom = 10;
    //分页控件
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height - self.pageBottom, self.width, 0)];
    _pageControl.pageIndicatorTintColor = RGBAColor(0x20, 0xbf, 0x9a, 0.4);
    
    _pageControl.currentPageIndicatorTintColor = GreenColor;
    [self addSubview:_pageControl];
}

-(void)setPageColor:(UIColor *)pageColor{
    
    _pageColor = pageColor;
    
    _pageControl.pageIndicatorTintColor = pageColor;
    
}

-(void)setPageCurrentColor:(UIColor *)pageCurrentColor{
    _pageCurrentColor = pageCurrentColor;
    
    
    _pageControl.currentPageIndicatorTintColor = pageCurrentColor;
}

-(void)setPageBottom:(CGFloat)pageBottom{
    _pageBottom = pageBottom;
    _pageControl.y = self.height - pageBottom;
}


- (void)setDatas:(NSArray *)datas
{
    
    [_datas removeAllObjects];
    
    if (datas.count < 2) {
        
        _pageControl.hidden = YES;
        [_datas addObjectsFromArray:datas];
    }else {
    
        _pageControl.hidden = NO;
        [_datas addObject:datas.lastObject];
        [_datas addObjectsFromArray:datas];
        [_datas addObject:datas.firstObject];
    }
    
    _pageControl.numberOfPages  = datas.count;
    
    [self.tableView reloadData];
    
    [self scrollViewAutoScroll];
}


- (void)scrollViewAutoScroll
{
//    NSTimeInterval nowSp = [[NSDate date] timeIntervalSince1970];
//    NSTimeInterval pastSp = [self.pauseDate timeIntervalSince1970];
//    CGFloat deta = nowSp - pastSp;
//    if (deta < timeDistance) {
//        if (self.timeSp == 5) {
//            [self performSelector:@selector(setOffsetAnimation) withObject:nil afterDelay:timeDistance - deta];
//            self.timeSp = deta;
//        }
//    }else{
        [self setOffsetAnimation];
//    }
    
}

- (void)setOffsetAnimation{
    self.timeSp = 5;
    
    CGFloat offsetY = _tableView.contentOffset.y;
    
    NSInteger index = (NSInteger)(offsetY / self.width + 0.4);
    
    [self.tableView setContentOffset:CGPointMake(0, (index + 1) * self.width) animated:YES];
}

#pragma mark - UITableViewDelegate AND  DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"horizontalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //图片
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imgView.frame = CGRectMake(0, 0, self.tableView.rowHeight,self.rowHeight==0?self.height:self.rowHeight);
        imgView.tag = 500001;
        [cell.contentView addSubview:imgView];
    }
    //图片
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:500001];
    
    id imgModel = _datas[indexPath.row];
    if ([imgModel isKindOfClass:[UIImage class]]) {
        imgView.image = imgModel;
    }else{
//        ESAdvertModel *adVertModel = _datas[indexPath.row];
//        [imgView sd_setImageWithURL:[NSURL URLWithString:adVertModel.img_url] placeholderImage:placeholder_Image];
    }
    
    return cell;
}


-(void)setRowHeight:(CGFloat)rowHeight{
    _rowHeight = rowHeight;
    [self.tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_WIDTH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id imgModel = _datas[indexPath.row];
    
    if ([imgModel isKindOfClass:[UIImage class]]) {
        
        
    }else{
        
//        ESAdvertModel *adVertModel = _data[indexPath.row];
//        NSString *url = [adVertModel.url NSNullProcess];
//        if ([url hasPrefix:@"http"]) {
//            ESServiceWebViewController *webView = [[ESServiceWebViewController alloc] init];
//            webView.url = [NSURL URLWithString:adVertModel.url];
//            [self.viewController.navigationController pushViewController:webView animated:YES];
//        }
//        
    }
    
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    NSInteger index = (NSInteger)(offsetY / self.width + 0.4);
    
    if (index != offsetY/self.width) {
        return;
    }
    
    if (index == 0) {
        
        scrollView.contentOffset = CGPointMake(0, self.width * (_datas.count - 2));
        _pageControl.currentPage = _datas.count - 2;
        
    }else if (index == _datas.count - 1) {
    
        scrollView.contentOffset = CGPointMake(0, self.width);
        _pageControl.currentPage = 0;
        
        
    }else {
        
        _pageControl.currentPage = index - 1;
    }
    
    
}




- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self pauseTime];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self activeTime];
}

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    
//    if (self.timeSp < 5) {
//        [self performSelector:@selector(activeTime) withObject:nil afterDelay:timeDistance];
//        self.timeSp = 6;
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if (self.timeSp <= 5) {
//        [self performSelector:@selector(activeTime) withObject:nil afterDelay:timeDistance];
//    }
//}


- (void)activeTime
{
    if (self.timer) {
        return;
    }
    
    // 定时调用方法
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeDistance target:self selector:@selector(scrollViewAutoScroll) userInfo:nil repeats:YES];
    // 主线程分流处理定时器事件
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)pauseTime
{
    //关闭定时器
    // 设置定时器不可用
    [self.timer invalidate];
    self.timer = nil;
}


- (void)dealloc
{
    
    [_timer invalidate];
    self.timer = nil;
}




@end
