//
//  TFShareRelatedCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/16.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFShareRelatedCellDelegate <NSObject>


@optional

- (void)addRelatedContent;

@end

@interface TFShareRelatedCell : HQBaseCell

+ (instancetype)shareRelatedCellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIButton *relatedBtn;

@property (nonatomic, weak) id <TFShareRelatedCellDelegate>delegate;

@end
