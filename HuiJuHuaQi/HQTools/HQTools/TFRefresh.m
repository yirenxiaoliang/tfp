//
//  TFRefresh.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/10/30.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFRefresh.h"

@implementation TFRefresh

/** 下拉刷新 普通模式 */
+ (MJRefreshNormalHeader *)headerNormalRefreshWithBlock:(void(^)(void))block{
    
    
    
    MJRefreshNormalHeader *normal = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (block) {
            block();
        }
    }];
    normal.lastUpdatedTimeLabel.hidden = YES;
    return normal;
}

/** 下拉刷新 GIF模式 */
+ (MJRefreshNormalHeader *)headerGifRefreshWithBlock:(void(^)(void))block{
    
    
    
    MJRefreshNormalHeader *normal = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (block) {
            block();
        }
    }];
    normal.lastUpdatedTimeLabel.hidden = YES;
    return normal;
    
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//        
//        if (block) {
//            block();
//        }
//    }];
//    
//    NSMutableArray *arr = [NSMutableArray array];
//    for (NSInteger i = 1; i < 16; i ++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",i]];
//        
//        if (image) {
//            [arr addObject:image];
//        }
//        
//    }
//    
//    [header setImages:@[[UIImage imageNamed:@"1"]] duration:2 forState:MJRefreshStateIdle];
//    [header setImages:@[[UIImage imageNamed:@"1"]] duration:2 forState:MJRefreshStatePulling];
//    [header setImages:arr duration:2 forState:MJRefreshStateRefreshing];
//    
//    header.automaticallyChangeAlpha = YES;
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
//    
//    return header;
}

/** 上拉加载更多 back模式 */
+ (MJRefreshBackNormalFooter *)footerBackRefreshWithBlock:(void(^)(void))block{
    
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (block) {
            block();
        }
        
    }];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开立即加载" forState:MJRefreshStatePulling];
    [footer setTitle:@"拼命加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"拼命加载中..." forState:MJRefreshStateWillRefresh];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    footer.ignoredScrollViewContentInsetBottom = 0;
    footer.automaticallyHidden = YES;
    
    return footer;
}


/** 上拉加载更多 自动模式 */
+ (MJRefreshAutoNormalFooter *)footerAutoRefreshWithBlock:(void(^)(void))block{
    
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (block) {
            block();
        }
        
    }];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开立即加载" forState:MJRefreshStatePulling];
    [footer setTitle:@"拼命加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"拼命加载中..." forState:MJRefreshStateWillRefresh];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    footer.ignoredScrollViewContentInsetBottom = 0;
    footer.automaticallyHidden = YES;
    
    return footer;
    
}

@end
