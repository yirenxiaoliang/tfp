//
//  TFEmailTableView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFEmailReceiveListModel.h"

@class TFEmailTableView;
@protocol TFEmailTableViewDelegate <NSObject>

-(void)emailTableView:(TFEmailTableView *)emailTableView didChangeHeight:(CGFloat)height;
-(void)emailTableViewDidClickedEmailWithModel:(TFEmailReceiveListModel *)model;

@end

@interface TFEmailTableView : UIView

/** 刷新数据 */
-(void)refreshEmailTableViewWithDatas:(NSArray *)datas;

/** delegate */
@property (nonatomic, weak) id <TFEmailTableViewDelegate>delegate;

@end
