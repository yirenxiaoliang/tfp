//
//  HQAdvertisementView.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/8/1.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HQAdvertisementViewDelegate <NSObject>



@end


@interface HQAdvertisementView : UIView

@property (nonatomic, strong) UITableView *tableView;
/** currentColor */
@property (nonatomic, strong) UIColor *pageCurrentColor;
/** color */
@property (nonatomic, strong) UIColor *pageColor;

/** 图片数组 */
@property (strong, nonatomic) NSMutableArray *datas;
/** pageControl距离底部位置 */
@property (assign, nonatomic) CGFloat pageBottom;

@property (assign, nonatomic) CGFloat rowHeight;
//开启定时器
- (void)activeTime;

//关闭定时器
- (void)pauseTime;

@end
