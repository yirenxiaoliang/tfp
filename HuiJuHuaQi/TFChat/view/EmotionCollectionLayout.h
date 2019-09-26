//
//  EmotionCollectionLayout.h
//  ChatTest
//
//  Created by Season on 2017/5/22.
//  Copyright © 2017年 Season. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmotionCollectionLayout : UICollectionViewFlowLayout

//  一行中 cell 的个数
@property (nonatomic,assign) NSUInteger itemCountPerRow;

//    一页显示多少行
@property (nonatomic,assign) NSUInteger rowCount;

@end
