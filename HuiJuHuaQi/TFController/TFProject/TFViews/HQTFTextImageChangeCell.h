//
//  HQTFTextImageChangeCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface HQTFTextImageChangeCell : HQBaseCell


@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *middleBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

/** title */
@property (nonatomic, copy) NSString *title;
/** titleImg */
@property (nonatomic, copy) NSString *titleImg;
/** titleColor */
@property (nonatomic, strong) UIColor *titleColor;
/** content */
@property (nonatomic, copy) NSString *content;
/** titleColor */
@property (nonatomic, strong) UIColor *contentColor;
/** desc */
@property (nonatomic, copy) NSString *desc;
/** titleColor */
@property (nonatomic, strong) UIColor *descColor;
/** descImg */
@property (nonatomic, copy) NSString *descImg;

+ (HQTFTextImageChangeCell *)textImageChangeCellWithTableView:(UITableView *)tableView;

@end
