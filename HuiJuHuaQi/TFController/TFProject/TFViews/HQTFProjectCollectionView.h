//
//  HQTFProjectCollectionView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HQTFProjectCollectionViewDelegate <UICollectionViewDelegate>

@optional
- (BOOL)collectionView:(UICollectionView *)collectionView shouldScrollToPageIndex:(NSInteger)targetIndex;

@end

@interface HQTFProjectCollectionView : UICollectionView

@property (nonatomic,weak)id<HQTFProjectCollectionViewDelegate>delegate;

@end
