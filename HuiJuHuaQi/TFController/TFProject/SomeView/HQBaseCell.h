//
//  HQBaseCell.h
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/23.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQBaseCell : UITableViewCell
/** 顶部线 */
@property (nonatomic , weak) UIView *topLine;
/** 底部线 */
@property (nonatomic , weak) UIView *bottomLine;
/** 底部线距离左边距离 */
@property (nonatomic , assign) NSInteger headMargin;
@end
