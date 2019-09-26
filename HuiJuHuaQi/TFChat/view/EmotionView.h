//
//  EmotionView.h
//  ChatTest
//
//  Created by Season on 2017/5/15.
//  Copyright © 2017年 Season. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmotionView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,copy)void(^emotionBlock)(NSString *emotionName);

@end
