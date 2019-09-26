//
//  PhotoBrower.h
//  ChatTest
//
//  Created by 肖胜 on 17/5/16.
//  Copyright © 2017年 Season. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrower : UIView<UICollectionViewDataSource,UICollectionViewDelegate>


/**
 初始化

 @param images 图片数组
 @param index 当前显示索引
 @return self
 */
- (instancetype)initWithImages:(NSArray *)images CurrentIndex:(NSInteger)index;

@end
