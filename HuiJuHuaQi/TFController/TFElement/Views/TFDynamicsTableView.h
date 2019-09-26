//
//  TFDynamicsTableView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TFDynamicsTableView;
@protocol TFDynamicsTableViewDelegate <NSObject>

-(void)dynamicsTableView:(TFDynamicsTableView *)dynamicsTableView didChangeHeight:(CGFloat)height;

@end

@interface TFDynamicsTableView : UIView

/** 刷新数据 */
-(void)refreshDynamicsTableViewWithDatas:(NSArray *)datas;

/** delegate */
@property (nonatomic, weak) id <TFDynamicsTableViewDelegate>delegate;

@end
