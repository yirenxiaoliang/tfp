//
//  TFCommentTableView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TFCommentTableView;
@protocol TFCommentTableViewDelegate <NSObject>

@optional
-(void)commentTableView:(TFCommentTableView *)commentTableView didChangeHeight:(CGFloat)height;
-(void)commentTableViewDidClickVioce:(TFFileModel *)model;
-(void)commentTableViewDidClickImage:(UIImageView *)imageView;
-(void)commentTableViewDidClickFile:(TFFileModel *)file;

@end

@interface TFCommentTableView : UIView

/** 刷新数据 */
-(void)refreshHybirdTableViewWithDatas:(NSArray *)datas;
/** 刷新数据 */
-(void)refreshCommentTableViewWithDatas:(NSArray *)datas;

/** delegate */
@property (nonatomic, weak) id <TFCommentTableViewDelegate>delegate;


@property (nonatomic, assign) BOOL isHeader;

@end
