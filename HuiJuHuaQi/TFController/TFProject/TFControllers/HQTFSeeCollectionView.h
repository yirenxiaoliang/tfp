//
//  HQTFSeeCollectionView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HQTFSeeCollectionViewDelegate <UICollectionViewDelegate>

@optional


@end

@interface HQTFSeeCollectionView : UICollectionView

@property (nonatomic,weak)id<HQTFSeeCollectionViewDelegate>delegate;

@end


