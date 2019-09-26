//
//  HQTFInputCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
@protocol HQTFInputCellDelegate <NSObject>

@optional

- (void)inputCellWithTextField:(UITextField *)textField;
- (void)inputCellDidClickedEnterBtn:(UIButton *)button;
@end


@interface HQTFInputCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UILabel *requireLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *enterBtnW;

+ (HQTFInputCell *)inputCellWithTableView:(UITableView *)tableView;
/** type 0:无进入按钮，1：进入按钮为图片(显示密码) 2：进入按钮为文字（获取验证码）3：进入按钮为图片(加号) */
- (void)refreshInputCellWithType:(NSInteger)type;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputLeftW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldTrailW;

/** dalegate */
@property (nonatomic, weak) id <HQTFInputCellDelegate>delegate;

/** structure */
@property (nonatomic, copy) NSString *structure;
/** fieldControl */
@property (nonatomic, copy) NSString *fieldControl;
/** 隐藏按钮 */
@property (nonatomic, assign) BOOL isHideBtn;

/** borderView */
@property (nonatomic, weak) UIView *borderView;

@end
