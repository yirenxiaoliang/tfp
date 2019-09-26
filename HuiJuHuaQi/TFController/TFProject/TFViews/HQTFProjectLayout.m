//
//  HQTFProjectLayout.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProjectLayout.h"


@interface HQTFProjectLayout()

/**
 *  布局属性
 */
@property (nonatomic, strong) NSMutableArray *attrs;

@end

@implementation HQTFProjectLayout



- (NSMutableArray *)attrs {
    
    if(!_attrs) {
        
        _attrs = [NSMutableArray array];
        
    }
    
    return _attrs;
}
// 初始化布局属性
- (void)prepareLayout {
    [super prepareLayout];
    
    // 先删除之前的布局属性
    [self.attrs removeAllObjects];
    
    self.sectionInset = UIEdgeInsetsMake(-50, CellSee, 0, CellSee);
    self.minimumLineSpacing = 2 * CellSee;
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 获取item的个数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrs addObject:attr];
    }
}


/**
 * UICollectionViewLayoutAttributes *attrs;
 * 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 * 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    
    return self.attrs;
}

/**
 * 这个方法需要返回indexPath位置对应cell的布局属性, 如果是继承自UICollectionViewLayout则必须实现这个方法, 继承UICollectionViewFlowLayout可以不用实现
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = SCREEN_WIDTH - 2 * CellSee;
    CGFloat height = (SCREEN_HEIGHT - 64-35);
    
    // 创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    
    attrs.size = CGSizeMake(width, height);
    
    attrs.frame = CGRectMake(indexPath.row * (width +self.minimumLineSpacing) + self.sectionInset.left, self.sectionInset.top + self.sectionInset.bottom, width, height);
    
    
    return attrs;
}






/**
 * 在collectionView滑动停止之后collectionView的偏移量
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    // 计算出最终显示的矩形框 遍历该矩形框中的cell相对中心线的间距选择最合适的cell进行调整
    CGRect currentRect;
    currentRect.origin.x = proposedContentOffset.x;
    currentRect.origin.y = 0;
    currentRect.size = CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    
    // 获得对应rect中super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:currentRect];
    
    // 计算collectionView最中心点的x值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 存放最小的间距值
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attr in array) {
        
        if(ABS(minDelta) > ABS(attr.center.x - centerX)) {
            
            minDelta = attr.center.x - centerX;
        }
    }
    
    // 修改原有的偏移量
    proposedContentOffset.x += minDelta;
    
    return proposedContentOffset;
}



@end
