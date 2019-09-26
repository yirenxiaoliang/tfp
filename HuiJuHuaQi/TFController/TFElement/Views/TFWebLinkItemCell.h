//
//  TFWebLinkItemCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/9.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFWebLinkModel.h"
#import "HQBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@class TFWebLinkItemCell;

@protocol TFWebLinkItemCellDelegate <NSObject>

@optional
-(void)webLinkItemCell:(TFWebLinkItemCell *)cell didClickedBarcode:(NSString *)barcode;

@end

@interface TFWebLinkItemCell : HQBaseCell

+ (instancetype)webLinkItemCellWithTableView:(UITableView *)tableView;
-(void)refreshWebLinkItemCellWithModel:(TFLinkModel *)model;


@property (nonatomic, weak) id <TFWebLinkItemCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
