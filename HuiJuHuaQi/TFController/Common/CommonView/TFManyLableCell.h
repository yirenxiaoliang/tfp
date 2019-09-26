//
//  TFManyLableCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/8/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "HQAdviceTextView.h"

@interface TFManyLableCell : HQBaseCell

@property (nonatomic ,weak) HQAdviceTextView *textVeiw;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *requireLabel;

/** structure */
@property (nonatomic, copy) NSString *structure;
/** fieldControl */
@property (nonatomic, copy) NSString *fieldControl;

/** borderView */
@property (nonatomic, weak) UIView *borderView;

/** titleBgView */
@property (nonatomic, weak) UIView *titleBgView;

+ (instancetype)creatManyLableCellWithTableView:(UITableView *)tableView;

+ (CGFloat)refreshManyLableCellHeightWithModel:(id)model type:(NSInteger)type;

@end
