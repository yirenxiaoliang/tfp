//
//  TFWebLinkCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/29.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQBaseCell.h"
#import "TFWebLinkModel.h"
NS_ASSUME_NONNULL_BEGIN

@class TFWebLinkCell;

@protocol TFWebLinkCellDelegate <NSObject>

@optional
-(void)webLinkCell:(TFWebLinkCell *)cell didClickedBarcode:(NSString *)barcode signInBarcode:(NSString *)signInBarcode;
-(void)webLinkCellChangeHeight;

@end


@interface TFWebLinkCell : HQBaseCell

+ (instancetype)webLinkCelllWithTableView:(UITableView *)tableView;

-(void)refreshWebLinkCellWithModel:(TFWebLinkModel *)model;

+(CGFloat)refreshWebLinkCellHeightWithModel:(TFWebLinkModel *)model;

@property (nonatomic, weak) id<TFWebLinkCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
