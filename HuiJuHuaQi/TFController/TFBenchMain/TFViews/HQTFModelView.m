//
//  HQTFModelView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFModelView.h"
#import "XWDragCellCollectionView.h"
#import "HQBenchMainfaceModel.h"
#import "HQBenchCollectionCell.h"
#import "TFModuleModel.h"

@interface HQTFModelView ()<UICollectionViewDelegate,UICollectionViewDataSource,XWDragCellCollectionViewDelegate,XWDragCellCollectionViewDataSource>

/** collectionView */
@property(nonatomic , strong) XWDragCellCollectionView *collectionView;
/** 数据源 */
@property (nonatomic, strong) NSArray *dataAll;

/** isCustom */
@property (nonatomic, assign) BOOL isCustom;


@end

@implementation HQTFModelView

- (NSArray *)dataAll{
    
    if (!_dataAll) {
        
        if (self.modelType == 0) {
            
            HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel modelManageUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
            if (benchNew) {
                _dataAll = @[benchNew.nowItems];
            }
        }else if (self.modelType == 1) {
            
            HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel thirdAppUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
            if (benchNew) {
                _dataAll = @[benchNew.nowItems];
            }
        }else if (self.modelType == 2) {
            
            HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel nowApprovalTypeUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
            if (benchNew) {
                _dataAll = @[benchNew.nowItems];
            }
        }else if (self.modelType == 3) {
            
            HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel approvalTypeUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
            if (benchNew) {
                _dataAll = @[benchNew.nowItems];
            }
        }else if (self.modelType == 4) {
            
            HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel sellUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
            if (benchNew) {
                _dataAll = @[benchNew.nowItems];
            }
        }else if (self.modelType == 5) {
            
            HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel goodsUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
            if (benchNew) {
                _dataAll = @[benchNew.nowItems];
            }
        }
    }
    return _dataAll;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        [self setupWorkDeskChildView];
    }
    
    return self;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupWorkDeskChildView];
}

- (void)setupWorkDeskChildView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 50) / 4.0 , (SCREEN_WIDTH - 50) / 4.0);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 0;
    
    self.cellType = 2;
    self.collectionView = [[XWDragCellCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout withType:self.cellType];
    self.collectionView.backgroundColor = BackGroudColor;
    self.collectionView.tag = 100;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setMinimumPressDuration:1.0];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.edgeScrollEable = NO;
    self.collectionView.shakeWhenMoveing = NO;
    [self.collectionView xw_enterEditingModel];
    [self addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HQBenchCollectionCell" bundle: [NSBundle mainBundle]]forCellWithReuseIdentifier:@"HQBenchCollectionCell"];
    self.collectionView.scrollEnabled = NO;
    
    self.collectionView.backgroundColor = WhiteColor;
    self.backgroundColor = WhiteColor;
    
    self.layer.masksToBounds = YES;
    
    // 默认不开启
    self.pan = NO;
}
#pragma mark - 设置手势开启
- (void)setPan:(BOOL)pan{
    _pan = pan;
    
    self.collectionView.gestureOpen = pan;
    
    [self.collectionView reloadData];
}

- (void)setCellType:(NSInteger)cellType{
    _cellType = cellType;
    self.collectionView.type = cellType;
    [self.collectionView reloadData];
}

-(void)setModelType:(NSInteger)modelType{
    _modelType = modelType;
    [self.collectionView reloadData];
}


/** 刷新 */
- (void)refreshModelViewWithModules:(NSArray *)modules{
    
    self.isCustom = YES;
    
    self.dataAll = [NSMutableArray arrayWithObject:modules];
    
    [self.collectionView reloadData];
    
}


#pragma mark - collectionView 代理及数据源方法

/**
 *  cell移动完毕，并成功移动到新位置的时候调用
 */
- (void)dragCellCollectionViewCellEndMoving:(XWDragCellCollectionView *)collectionView{
   
    
}

/**
 *  某个cell将要开始移动的时候调用
 *  @param indexPath      该cell当前的indexPath
 */
- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView cellWillBeginMoveAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


#pragma mark - XWDragCellCollectionView 必须实现的两个代理
- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray{
    
    if (self.isCustom) {
        
        self.dataAll = newDataArray;
        
    }else{
        if (self.modelType == 0) {
            
            HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel modelManageUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
            NSArray *data = newDataArray[0];
            
            benchNew.nowItems = [NSMutableArray arrayWithArray:data];
            
            [HQBenchMainfaceModel modelManageArchiveWithModel:benchNew];
        }else if (self.modelType == 1){
            
            HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel thirdAppUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
            NSArray *data = newDataArray[0];
            
            benchNew.nowItems = [NSMutableArray arrayWithArray:data];
            
            [HQBenchMainfaceModel thirdAppArchiveWithModel:benchNew];
            
        }else if (self.modelType == 2){
            
            HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel nowApprovalTypeUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
            NSArray *data = newDataArray[0];
            
            benchNew.nowItems = [NSMutableArray arrayWithArray:data];
            
            [HQBenchMainfaceModel nowApprovalTypeArchiveWithModel:benchNew];
        }else if (self.modelType == 3){
            
            HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel approvalTypeUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
            NSArray *data = newDataArray[0];
            
            benchNew.nowItems = [NSMutableArray arrayWithArray:data];
            
            [HQBenchMainfaceModel approvalTypeArchiveWithModel:benchNew];
        }else if (self.modelType == 4){
            
            HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel sellUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
            NSArray *data = newDataArray[0];
            
            benchNew.nowItems = [NSMutableArray arrayWithArray:data];
            
            [HQBenchMainfaceModel sellArchiveWithModel:benchNew];
        }else if (self.modelType == 5){
            
            HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel goodsUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
            NSArray *data = newDataArray[0];
            
            benchNew.nowItems = [NSMutableArray arrayWithArray:data];
            
            [HQBenchMainfaceModel goodsArchiveWithModel:benchNew];
        }
        
        
        self.dataAll = newDataArray;

    }
    
}



- (NSArray *)dataSourceArrayOfCollectionView:(XWDragCellCollectionView *)collectionView{
    
    return self.dataAll;
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
    
    if (self.isCustom) {
        
        HQBenchCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HQBenchCollectionCell" forIndexPath:indexPath];
        cell.type = self.cellType;
        cell.backgroundColor = [UIColor clearColor];
        NSArray *array =  self.dataAll[indexPath.section];
        TFModuleModel *model = [array objectAtIndex:indexPath.item];
        [cell refreshCellWithModel:model];
        
        return cell;
        
    }else{
        
        HQBenchCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HQBenchCollectionCell" forIndexPath:indexPath];
        cell.type = self.cellType;
        cell.backgroundColor = [UIColor clearColor];
        NSArray *array =  self.dataAll[indexPath.section];
        HQRootModel *model = [array objectAtIndex:indexPath.item];
        cell.rootModel = model;
        
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // 有需要操作的（显示灰色和删除按钮）cell时不进行跳转，让cell回复无色并隐藏删除按钮
//    NSArray *visiCells = [collectionView visibleCells];
//    for (HQBenchCollectionCell *cell in visiCells) {
//        
//        if (cell.rootModel.backColor) {
//            cell.rootModel.backColor = NO;
//            cell.backgroundColor = WhiteColor;
//            return;
//        }
//    }
//
    if (self.isCustom) {
        if ([self.delegate respondsToSelector:@selector(modelView:didSelectModule:)]) {
            [self.delegate modelView:self didSelectModule:self.dataAll[indexPath.section][indexPath.item]];
        }
        
        if ([self.delegate respondsToSelector:@selector(modelView:didSelectModule:contentView:)]) {
            
            [self.delegate modelView:self didSelectModule:self.dataAll[indexPath.section][indexPath.item] contentView:[collectionView cellForItemAtIndexPath:indexPath]];
            
        }
    }else{
        
        if ([self.delegate respondsToSelector:@selector(modelView:didSelectItem:)]) {
            [self.delegate modelView:self didSelectItem:self.dataAll[indexPath.section][indexPath.item]];
        }
    }
    
}


@end
