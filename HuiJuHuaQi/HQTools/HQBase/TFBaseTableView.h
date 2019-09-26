//
//  TFBaseTableView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/10/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFBaseTableView : UITableView

/** 下拉刷新 */
-(void)tableViewHeaderRefreshWithBlock:(void(^)(void))block;

/** 上拉刷新 */
-(void)tableViewFooterRefreshWithBlock:(void(^)(void))block;

@end
