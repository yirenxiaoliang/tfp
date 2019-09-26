//
//  HQBenchCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/6/29.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBenchCell.h"
#import "XWDragCellCollectionView.h"
#import "HQRootModel.h"
#import "HQBenchCollectionCell.h"
#import "HQBenchMainfaceModel.h"

@interface HQBenchCell ()<UICollectionViewDelegate,UICollectionViewDataSource,XWDragCellCollectionViewDelegate,XWDragCellCollectionViewDataSource>


@property (nonatomic, strong) XWDragCellCollectionView *benchCollection;

@property (nonatomic, strong) NSArray *dataAll;

@property (nonatomic, strong) NSMutableArray *saveDataAll;
@property (nonatomic, strong) NSIndexPath *indexPathMoving;

@property (nonatomic , assign) NSInteger type;
@end

@implementation HQBenchCell


- (NSMutableArray *)saveDataAll{
    
    if (!_saveDataAll) {
        _saveDataAll = [NSMutableArray array];
    }
    return _saveDataAll;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(NSInteger)type {
    self.type = type;
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = BackGroudColor;
        [self setup];
    }
    return self;
}


- (void)setup{
    
    
    if (self.type == 0) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(BenchCellAddItem:)
                                                     name:@"BenchCellAddItem" object:nil];
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 40) / 3.0 , (SCREEN_WIDTH - 40) / 3.0);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 0;
    
    self.benchCollection = [[XWDragCellCollectionView alloc] initWithFrame:self.contentView.bounds
                                                      collectionViewLayout:flowLayout
                                                                  withType:self.type];
    self.benchCollection.backgroundColor = BackGroudColor;
    self.benchCollection.tag = 100;
    self.benchCollection.delegate = self;
    self.benchCollection.dataSource = self;
    self.benchCollection.shakeLevel = 3.0f;
    [self.benchCollection setMinimumPressDuration:1.0];
    self.benchCollection.showsVerticalScrollIndicator = NO;
    self.benchCollection.showsHorizontalScrollIndicator = NO;
    self.benchCollection.pagingEnabled = YES;
    self.benchCollection.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    self.benchCollection.edgeScrollEable = NO;
    self.benchCollection.shakeWhenMoveing = NO;
    [self.benchCollection xw_enterEditingModel];
    [self.contentView addSubview:self.benchCollection];
    
    [self.benchCollection registerNib:[UINib nibWithNibName:@"HQBenchCollectionCell" bundle: [NSBundle mainBundle]]forCellWithReuseIdentifier:@"HQBenchCollectionCell"];
   
    
    self.benchCollection.backgroundColor = BackGroudColor;
    self.backgroundColor = BackGroudColor;
    
}

- (void)setItems:(NSMutableArray *)items{
    
    _items = items;
    
    if (self.items) {// 用于删除首页items后添加
        
        self.dataAll = @[self.items.copy];
    }
}


#pragma mark - setter 方法
//- (void)setMainface:(HQMainfaceNoReadCountModel *)mainface{
//    
//    _mainface = mainface;
//    
//    HQLog(@"***********%@*************", self.dataAll);
//    
//    HQBenchMainfaceModel *benchMainface = [HQBenchMainfaceModel benchMainfaceUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
//    
//    
//    
//    for (HQRootModel *model in benchMainface.nowItems) {
//        
//        switch (model.functionModelType) {
//            case FunctionModelTypeSubscribe:
//            {
//                
//            }
//                break;
//            case FunctionModelTypeApproval:
//            {
//                model.OutDate = mainface.approvalOutDate;
//                model.markNum = mainface.approvalCount;
//            }
//                break;
//            case FunctionModelTypeTask:
//            {
//                model.OutDate = mainface.taskOutDate;
//                model.markNum = mainface.taskCount;
//            }
//                break;
//            case FunctionModelTypeSchedule:
//            {
//                model.markNum = mainface.schedule;
//            }
//                break;
//            case FunctionModelTypeReport:
//            {
//                model.markNum = mainface.report;
//            }
//                break;
//            case FunctionModelTypeAdvice:
//            {
//                model.markNum = mainface.suggestion;
//            }
//                break;
//            case FunctionModelTypeDocument:
//            {
//                model.markNum = 0;
//            }
//                break;
//            case FunctionModelTypeCrm:
//            {
//                model.markNum = 0;
//            }
//                break;
//            case FunctionModelTypeMore:
//            {
//                model.markNum = 0;
//            }
//                break;
//            case FunctionModelTypePrejectPartner:
//            {
//                model.markNum = 0;
//            }
//                break;
//            default:
//                break;
//        }
//    }
//    
//    // 赋值后存起来
//    [HQBenchMainfaceModel benchMainfaceArchiveWithModel:benchMainface];
//    
//    HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel benchMainfaceUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
//    self.dataAll = [NSMutableArray arrayWithArray:@[benchNew.nowItems]];
//    // 刷新
//    [self.benchCollection reloadData];
//}



- (void)layoutSubviews{
    [super layoutSubviews];
    self.benchCollection.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
    
}



#pragma mark - collectionView 代理及数据源方法
/**
 *  某个cell将要开始移动的时候调用
 *  @param indexPath      该cell当前的indexPath
 */
- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView cellWillBeginMoveAtIndexPath:(NSIndexPath *)indexPath{
    
    // 有需要操作的（显示灰色和删除按钮）cell时不进行跳转，让cell回复无色并隐藏删除按钮
    NSArray *visiCells = [collectionView visibleCells];
    for (HQBenchCollectionCell *cell in visiCells) {
        if (!cell.minusButton.hidden) {
            cell.backgroundColor = BackGroudColor;
            cell.minusButton.hidden = YES;
        }
    }
    
}
/** 用于删除时刷新 */
- (void)deleteCollectionViewCellToFreshTableView{
    if ([self.delegate respondsToSelector:@selector(deleteCollectionCellFresh)]) {
        [self.delegate deleteCollectionCellFresh];
    }
}

/** 添加一个item */
- (void)BenchCellAddItem:(NSNotification *)noto{
    
    NSMutableArray *array = self.dataAll[0];
    
    [array insertObject:noto.object atIndex:array.count-1];
    
    HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel benchMainfaceUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
    benchNew.nowItems = array;
    [HQBenchMainfaceModel benchMainfaceArchiveWithModel:benchNew];
    
    [self.benchCollection reloadData];

}

- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray{
    
    if (self.type == 0) {
        
        HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel benchMainfaceUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
        benchNew.nowItems = [NSMutableArray arrayWithArray:newDataArray[0]];
        [HQBenchMainfaceModel benchMainfaceArchiveWithModel:benchNew];
    }
    
    self.dataAll = newDataArray;
    
    HQLog(@"%@", self.dataAll);
}



- (NSArray *)dataSourceArrayOfCollectionView:(XWDragCellCollectionView *)collectionView{
    
    if ([self.delegate respondsToSelector:@selector(benchCell:withAllData:)]) {
        [self.delegate benchCell:self withAllData:self.dataAll];
    }
    
    return  self.dataAll;
    
    HQLog(@"%@", self.dataAll);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  
    return self.dataAll.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.dataAll[section];
    return array.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HQBenchCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HQBenchCollectionCell" forIndexPath:indexPath];
    NSArray *array =  self.dataAll[indexPath.section];
    HQRootModel *model = [array objectAtIndex:indexPath.item];
    cell.rootModel = model;
    cell.type = self.type;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // 有需要操作的（显示灰色和删除按钮）cell时不进行跳转，让cell回复无色并隐藏删除按钮
    NSArray *visiCells = [collectionView visibleCells];
    for (HQBenchCollectionCell *cell in visiCells) {
        if (!cell.minusButton.hidden) {
            cell.backgroundColor = BackGroudColor;
            cell.minusButton.hidden = YES;
            return;
        }
    }
    
    
    if ([self.delegate respondsToSelector:@selector(benchCell:didSelectItem:withAllData:)]) {
        [self.delegate benchCell:self didSelectItem:self.dataAll[indexPath.section][indexPath.item] withAllData:self.dataAll[indexPath.section]];
    }
    
}



+ (HQBenchCell *)benchCellWithTableView:(UITableView *)tableView withType:(NSInteger)type{
    
    static NSString *ID = @"benchCell";
    HQBenchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HQBenchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID withType:type];
    }
    cell.type = type;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
