//
//  TFReferenceSearchAllRowCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/9/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFReferenceSearchAllRowCell : UITableViewCell

@property (nonatomic, weak) UIImageView *selectImage;

- (void)refreshCellWithRows:(NSArray *)rows;

+(CGFloat)refreshCellHeightWithRows:(NSArray *)rows;

+ (TFReferenceSearchAllRowCell *)referenceSearchAllRowCellWithTableView:(UITableView *)tableView;


@end
