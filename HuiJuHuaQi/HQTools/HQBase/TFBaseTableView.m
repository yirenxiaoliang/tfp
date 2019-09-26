//
//  TFBaseTableView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/10/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFBaseTableView.h"

typedef void(^Block)();

typedef NS_ENUM(NSInteger, RefreshState) {
    RefreshStateNormal = 0,     /** 普通状态 */
    RefreshStatePulling,        /** 释放刷新状态 */
    RefreshStateRefreshing,     /** 正在刷新 */
};

@interface TFBaseTableView ()<UITableViewDelegate>

/** 下拉 */
@property (nonatomic, copy) Block headerBlock;
/** 上拉 */
@property (nonatomic, copy) Block footerBlock;

/** state */
@property (nonatomic, assign) RefreshState refreshState;


@end

@implementation TFBaseTableView


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        self.refreshState = RefreshStateNormal;
        self.delegate = self;
//        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}


/** 下拉刷新 */
-(void)tableViewHeaderRefreshWithBlock:(void(^)(void))block{
    
    self.headerBlock = block;
}

/** 上拉刷新 */
-(void)tableViewFooterRefreshWithBlock:(void(^)(void))block{
    
    self.footerBlock = block;
    
}


//- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
//    
//    HQLog(@"%@",change);
//    
//}
//
//-(void)dealloc{
//    [self removeObserver:self forKeyPath:@"contentOffset"];
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.refreshState = RefreshStateNormal;
    
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat offset1 = scrollView.height - scrollView.contentSize.height;
    
    HQLog(@"%f======%f",offset,offset1);
    
    if (scrollView.contentOffset.y < 0 && scrollView.contentOffset.y < (scrollView.height - scrollView.contentSize.height)) {
        
        
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
