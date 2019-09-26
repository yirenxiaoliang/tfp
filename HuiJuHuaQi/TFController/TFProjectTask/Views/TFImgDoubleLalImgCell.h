//
//  TFImgDoubleLalImgCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/7.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFImgDoubleLalImgCellDelegate<NSObject>
@optional
-(void)cellDidClickedFirstBtn;

@end

@interface TFImgDoubleLalImgCell : HQBaseCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

+ (TFImgDoubleLalImgCell *)imgDoubleLalImgCellWithTableView:(UITableView *)tableView;

/** 刷新点赞 */
- (void)refreshCellWithPeoples:(NSArray *)peoples;

/** delegate */
@property (nonatomic, weak) id <TFImgDoubleLalImgCellDelegate>delegate;

@end
