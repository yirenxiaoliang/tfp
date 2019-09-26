//
//  TFEmailsSignCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/2/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFEmailsSignCellDelegate <NSObject>

@optional

- (void)deleteMineSign;

@end

@interface TFEmailsSignCell : HQBaseCell

+ (instancetype)EmailsSignCellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id <TFEmailsSignCellDelegate>delegate;

@end
