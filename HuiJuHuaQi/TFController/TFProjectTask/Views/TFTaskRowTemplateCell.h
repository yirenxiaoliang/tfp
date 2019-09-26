//
//  TFTaskRowTemplateCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFTaskRowTemplateCellDelegate <NSObject>

@optional
-(void)taskRowTemplateCellDidClickedEnterButton:(UIButton *)button;

@end

@interface TFTaskRowTemplateCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@property (weak, nonatomic) IBOutlet UILabel *templateLabel;

/** delegate */
@property (nonatomic, weak) id <TFTaskRowTemplateCellDelegate>delegate;

+ (TFTaskRowTemplateCell *)taskRowTemplateCellWithTableView:(UITableView *)tableView;
@end
