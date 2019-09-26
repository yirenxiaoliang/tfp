//
//  TFStatusTableView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFStatusTableView;
@protocol TFStatusTableViewDelegate <NSObject>

-(void)statusTableView:(TFStatusTableView *)statusTableView didChangeHeight:(CGFloat)height;

@end
@interface TFStatusTableView : UIView

/** 刷新数据 */
-(void)refreshStatusTableViewWithDatas:(NSArray *)datas;

/** delegate */
@property (nonatomic, weak) id <TFStatusTableViewDelegate>delegate;

@end
