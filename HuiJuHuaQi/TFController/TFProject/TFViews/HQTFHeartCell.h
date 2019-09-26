//
//  HQTFHeartCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol HQTFHeartCellDelegate <NSObject>

@optional
-(void)heartCellDidClickedHeart:(UIButton *)heartBtn;

@end

@interface HQTFHeartCell : HQBaseCell

+ (HQTFHeartCell *)heartCellWithTableView:(UITableView *)tableView;

-(void)refreshHeartCellWithPeoples:(NSArray *)peoples;

+(CGFloat)refreshHeartCellHeightWithPeoples:(NSArray *)peoples;

+(CGFloat)refreshHeartCellHeightWithPeoples:(NSArray *)peoples withType:(NSInteger)type;

/** delegate */
@property (nonatomic, weak) id <HQTFHeartCellDelegate>delegate;

/** isShow  默认为NO，不显示 YES为显示 显示监听事件请实现代理 */
@property (nonatomic, assign) BOOL isShow;


@end
