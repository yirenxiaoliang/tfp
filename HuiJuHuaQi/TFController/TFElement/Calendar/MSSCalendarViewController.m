//
//  MSSCalendarViewController.m
//  MSSCalendar
//
//  Created by 于威 on 16/4/3.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSCalendarViewController.h"
#import "MSSCalendarCollectionViewCell.h"
#import "MSSCalendarHeaderModel.h"
#import "MSSCalendarManager.h"
#import "MSSCalendarCollectionReusableView.h"
#import "MSSCalendarPopView.h"
#import "MSSCalendarDefine.h"

@interface MSSCalendarViewController ()
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)MSSCalendarPopView *popView;
@property (nonatomic,strong)NSDate *centerDate;// 15年中心
@property (nonatomic,strong)NSDate *topDate;// 15年中心
@property (nonatomic,strong)NSDate *bottomDate;// 15年中心
@property (nonatomic,assign)BOOL isOne;

@end

@implementation MSSCalendarViewController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _afterTodayCanTouch = YES;
        _beforeTodayCanTouch = YES;
        _dataArray = [[NSMutableArray alloc]init];
        _showChineseCalendar = NO;
        _showChineseHoliday = NO;
        _showHolidayDifferentColor = NO;
        _showAlertView = NO;
        if (_startDate <= 0) {
            _centerDate = [NSDate date];
            _topDate = _centerDate;
            _bottomDate = _centerDate;
        }else{
            _centerDate = [NSDate dateWithTimeIntervalSince1970:_startDate];
            _topDate = _centerDate;
            _bottomDate = _centerDate;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDataSource];
    [self createUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(_popView)
    {
        [_popView removeFromSuperview];
        _popView = nil;
    }
}

- (void)initDataSource
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MSSCalendarManager *manager = [[MSSCalendarManager alloc]initWithShowChineseHoliday:_showChineseHoliday showChineseCalendar:_showChineseCalendar startDate:_startDate centerDate:_startDate>0?[NSDate dateWithTimeIntervalSince1970:_startDate]:[NSDate date]];
        NSArray *tempDataArray = [manager getCalendarDataSoruceWithLimitMonth:_limitMonth type:_type];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isOne = YES;
            [_dataArray addObjectsFromArray:tempDataArray];
            [self showCollectionViewWithStartIndexPath:manager.startIndexPath];
        });
    });
}

/** 加载另外一个15年数据源 */
- (void)loadDataSourceWithYear:(NSInteger)year{
    
    
    if (year > 0) {
        NSDateComponents *components = [[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar] components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:_bottomDate];
        
        components.year += year;
        _bottomDate = [[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar] dateFromComponents:components];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            MSSCalendarManager *manager = [[MSSCalendarManager alloc]initWithShowChineseHoliday:_showChineseHoliday showChineseCalendar:_showChineseCalendar startDate:_startDate centerDate:_bottomDate];
            NSArray *tempDataArray = [manager getCalendarDataSoruceWithLimitMonth:_limitMonth type:_type];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.isOne = year;
                if (year > 0) {
                    [_dataArray addObjectsFromArray:tempDataArray];
                }else{
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:tempDataArray];
                    [arr addObjectsFromArray:_dataArray];
                    _dataArray = arr;
                }
                
                [_collectionView reloadData];
            });
        });

    }else{
        
        NSDateComponents *components = [[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar] components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:_topDate];
        
        components.year += year;
        _topDate = [[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar] dateFromComponents:components];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            MSSCalendarManager *manager = [[MSSCalendarManager alloc]initWithShowChineseHoliday:_showChineseHoliday showChineseCalendar:_showChineseCalendar startDate:_startDate centerDate:_topDate];
            NSArray *tempDataArray = [manager getCalendarDataSoruceWithLimitMonth:_limitMonth type:_type];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.isOne = year;
                if (year > 0) {
                    [_dataArray addObjectsFromArray:tempDataArray];
                }else{
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:tempDataArray];
                    [arr addObjectsFromArray:_dataArray];
                    _dataArray = arr;
                }
                [_collectionView reloadData];
                
                [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_limitMonth] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                _collectionView.contentOffset = CGPointMake(0, _collectionView.contentOffset.y - MSS_HeaderViewHeight);
            });
        });
        
    }
}

- (void)addWeakView
{
    UIView *weekView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, MSS_SCREEN_WIDTH, MSS_WeekViewHeight)];
    weekView.backgroundColor = MSS_SelectTextColor;
    [self.view addSubview:weekView];
    
    NSArray *weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    int i = 0;
    NSInteger width = MSS_Iphone6Scale(54);
    for(i = 0; i < 7;i++)
    {
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * width, 0, width, MSS_WeekViewHeight)];
        weekLabel.backgroundColor = [UIColor clearColor];
        weekLabel.text = weekArray[i];
        weekLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        if(i == 0 || i == 6)
        {
            weekLabel.textColor = MSS_WeekEndTextColor;
        }
        else
        {
            weekLabel.textColor = MSS_TextColor;
        }
        [weekView addSubview:weekLabel];
    }
}

- (void)showCollectionViewWithStartIndexPath:(NSIndexPath *)startIndexPath
{
    [self addWeakView];
    [_collectionView reloadData];
    // 滚动到上次选中的位置
    if(startIndexPath)
    {
        [_collectionView scrollToItemAtIndexPath:startIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        _collectionView.contentOffset = CGPointMake(0, _collectionView.contentOffset.y - MSS_HeaderViewHeight);
    }
    else
    {
        if(_type == MSSCalendarViewControllerLastType)
        {
            if([_dataArray count] > 0)
            {
                [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_dataArray.count - 1] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            }
        }
        else if(_type == MSSCalendarViewControllerMiddleType)
        {
            if([_dataArray count] > 0)
            {
                [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(_dataArray.count - 1) / 2] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                _collectionView.contentOffset = CGPointMake(0, _collectionView.contentOffset.y - MSS_HeaderViewHeight);
            }
        }
    }
}

- (void)createUI
{
    NSInteger width = MSS_Iphone6Scale(54);
    NSInteger height = MSS_Iphone6Scale(60);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(width, height);
    flowLayout.headerReferenceSize = CGSizeMake(MSS_SCREEN_WIDTH, MSS_HeaderViewHeight);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64 + MSS_WeekViewHeight, width * 7, MSS_SCREEN_HEIGHT - 64 - MSS_WeekViewHeight) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[MSSCalendarCollectionViewCell class] forCellWithReuseIdentifier:@"MSSCalendarCollectionViewCell"];
    [_collectionView registerClass:[MSSCalendarCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MSSCalendarCollectionReusableView"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_dataArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    MSSCalendarHeaderModel *headerItem = _dataArray[section];
    return headerItem.calendarItemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSSCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSSCalendarCollectionViewCell" forIndexPath:indexPath];
    if(cell)
    {
        MSSCalendarHeaderModel *headerItem = _dataArray[indexPath.section];
        MSSCalendarModel *calendarItem = headerItem.calendarItemArray[indexPath.row];
        cell.dateLabel.text = @"";
        cell.dateLabel.textColor = MSS_TextColor;
        cell.subLabel.text = @"";
        cell.subLabel.textColor = MSS_TextColor;
        cell.isSelected = NO;
        cell.userInteractionEnabled = NO;
        if(calendarItem.day > 0)
        {
            cell.dateLabel.text = [NSString stringWithFormat:@"%ld",(long)calendarItem.day];
            cell.userInteractionEnabled = YES;
        }
        if(_showChineseCalendar)
        {
            cell.subLabel.text = calendarItem.chineseCalendar;
        }
        
        // 开始日期
        if(calendarItem.dateInterval == _startDate)
        {
            cell.isSelected = YES;
            cell.dateLabel.textColor = MSS_SelectTextColor;
//            cell.subLabel.text = MSS_SelectBeginText;
            
        }
        // 结束日期
        else if (calendarItem.dateInterval == _endDate)
        {
            cell.isSelected = YES;
            cell.dateLabel.textColor = MSS_SelectTextColor;
//            cell.subLabel.text = MSS_SelectEndText;
        }
        // 开始和结束之间的日期
        else if(calendarItem.dateInterval > _startDate && calendarItem.dateInterval < _endDate)
        {
            cell.isSelected = YES;
            cell.dateLabel.textColor = MSS_SelectTextColor;
        }
        else
        {
            if(calendarItem.week == 0 || calendarItem.week == 6)
            {
                cell.dateLabel.textColor = MSS_WeekEndTextColor;
                cell.subLabel.textColor = MSS_WeekEndTextColor;
            }
            if(calendarItem.holiday.length > 0)
            {
                cell.dateLabel.text = calendarItem.holiday;
                if(_showHolidayDifferentColor)
                {
                    cell.dateLabel.textColor = MSS_HolidayTextColor;
                    cell.subLabel.textColor = MSS_HolidayTextColor;
                }
            }
        }
        
        if(!_afterTodayCanTouch)
        {
            if(calendarItem.type == MSSCalendarNextType)
            {
                cell.dateLabel.textColor = MSS_TouchUnableTextColor;
                cell.subLabel.textColor = MSS_TouchUnableTextColor;
                cell.userInteractionEnabled = NO;
            }
        }
        if(!_beforeTodayCanTouch)
        {
            if(calendarItem.type == MSSCalendarLastType)
            {
                cell.dateLabel.textColor = MSS_TouchUnableTextColor;
                cell.subLabel.textColor = MSS_TouchUnableTextColor;
                cell.userInteractionEnabled = NO;
            }
        }
    }
    return cell;
}

// 添加header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MSSCalendarCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MSSCalendarCollectionReusableView" forIndexPath:indexPath];
        MSSCalendarHeaderModel *headerItem = _dataArray[indexPath.section];
        headerView.headerLabel.text = headerItem.headerText;
        return headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSSCalendarHeaderModel *headerItem = _dataArray[indexPath.section];
    MSSCalendarModel *calendaItem = headerItem.calendarItemArray[indexPath.row];
    // 当开始日期为空时
//    if(_startDate == 0)
//    {
//        _startDate = calendaItem.dateInterval;
//        [self showPopViewWithIndexPath:indexPath];
//    }
//    // 当开始日期和结束日期同时存在时(点击为重新选时间段)
//    else if(_startDate > 0 && _endDate > 0)
//    {
//        _startDate = calendaItem.dateInterval;
//        _endDate = 0;
//        [self showPopViewWithIndexPath:indexPath];
//    }
//    else
//    {
//        // 判断第二个选择日期是否比现在开始日期大
//        if(_startDate < calendaItem.dateInterval)
//        {
//            _endDate = calendaItem.dateInterval;
//            if([_delegate respondsToSelector:@selector(calendarViewConfirmClickWithStartDate:endDate:)])
//            {
//                [_delegate calendarViewConfirmClickWithStartDate:_startDate endDate:_endDate];
//            }
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
//        else
//        {
//            _startDate = calendaItem.dateInterval;
//            [self showPopViewWithIndexPath:indexPath];
//        }
//    }
    
    _startDate = calendaItem.dateInterval;
    [self showPopViewWithIndexPath:indexPath];
    if([_delegate respondsToSelector:@selector(calendarViewConfirmClickWithStartDate:endDate:)])
    {
        [_delegate calendarViewConfirmClickWithStartDate:_startDate endDate:_endDate];
    }
    [_collectionView reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (fabs(scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y) < 50 && self.isOne){
        //滑到底部加载更多
        self.isOne = NO;
        NSLog(@"+++++++++++++++++++++++++++%ld",self.dataArray.count);
        [self loadDataSourceWithYear:_limitMonth/12];
    }
    if (scrollView.contentOffset.y <= 50 && self.isOne) {
        //滑到顶部更新
        self.isOne = NO;
        
        NSLog(@"---------------------------%ld",self.dataArray.count);
        [self loadDataSourceWithYear:-_limitMonth/12];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(_popView)
    {
        [_popView removeFromSuperview];
        _popView = nil;
    }
}

- (void)showPopViewWithIndexPath:(NSIndexPath *)indexPath;
{
    if(_showAlertView)
    {
        [_popView removeFromSuperview];
        _popView = nil;
        
        MSSCalendarPopViewArrowPosition arrowPostion = MSSCalendarPopViewArrowPositionMiddle;
        NSInteger position = indexPath.row % 7;
        if(position == 0)
        {
            arrowPostion = MSSCalendarPopViewArrowPositionLeft;
        }
        else if(position == 6)
        {
            arrowPostion = MSSCalendarPopViewArrowPositionRight;
        }
        
        MSSCalendarCollectionViewCell *cell = (MSSCalendarCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        _popView = [[MSSCalendarPopView alloc]initWithSideView:cell.dateLabel arrowPosition:arrowPostion];
        _popView.topLabelText = [NSString stringWithFormat:@"请选择%@日期",MSS_SelectEndText];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM月dd日"MSS_SelectBeginText];
        NSString *startDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_startDate]];
        _popView.bottomLabelText = startDateString;
        [_popView showWithAnimation];
    }
}

@end
