//
//  PhotoBrower.m
//  ChatTest
//
//  Created by 肖胜 on 17/5/16.
//  Copyright © 2017年 Season. All rights reserved.
//

#import "PhotoBrower.h"

@implementation PhotoBrower

{
    NSArray *dataArray;
    NSInteger currentIndex;
   
}
- (instancetype)initWithImages:(NSArray *)images CurrentIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
       
        dataArray = images;
        currentIndex = index;
        if (index > 9999) {
            
            currentIndex = 0;
        }
  
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor blackColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //水平布局
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
   
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.center = self.center;
    self.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
      
        // 此处宽度+20 保证item间的20间隙能在分页情况下正常显示
        collectionView.frame = CGRectMake(0, 0, self.width+20, self.height);
        self.alpha = 1;
    }];
    
    //打开分页效果
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    //设置行列间距
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    collectionView.delegate=self;
    collectionView.dataSource=self;
    collectionView.backgroundColor = self.backgroundColor;
    [self addSubview:collectionView];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"photo"];
    
    [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return dataArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    for (NSUInteger i=cell.contentView.subviews.count; i>0; i--) {
        [cell.contentView.subviews[i-1] removeFromSuperview];
    }
    UIImageView * photo = [[UIImageView alloc]init];
    photo.image = dataArray[indexPath.item];
    
    // 根据屏幕宽度计算图片高度
    CGFloat height = photo.image.size.height/photo.image.size.width * SCREEN_WIDTH;
    photo.frame = CGRectMake(0, (self.height - height)/2.0, self.bounds.size.width, height);
    [cell.contentView addSubview:photo];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // +20为图片间的间隙
    return CGSizeMake(self.bounds.size.width+20, self.bounds.size.height);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self removeFromSuperview];
}

@end
