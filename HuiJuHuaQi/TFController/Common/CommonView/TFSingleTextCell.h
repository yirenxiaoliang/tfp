//
//  TFSingleTextCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "HQAdviceTextView.h"

@class TFSingleTextCell;
@protocol TFSingleTextCellDelegate <NSObject>

@optional
-(void)singleTextCell:(TFSingleTextCell *)singleTextCell didClilckedEnterBtn:(UIButton *)enterBtn;

@end

@interface TFSingleTextCell : HQBaseCell

/** HQAdviceTextView *textView */
@property (nonatomic, weak) HQAdviceTextView *textView;

/** UILabel *lable */
@property (nonatomic, weak) UILabel *titleLabel;

/** UIButton *enterBtn */
@property (nonatomic, weak) UIButton *enterBtn;

/** requireLabel */
@property (nonatomic, weak) UILabel *requireLabel;

/** delegate */
@property (nonatomic, weak) id <TFSingleTextCellDelegate>delegate;

+ (instancetype)singleTextCellWithTableView:(UITableView *)tableView;

/** structure */
@property (nonatomic, copy) NSString *structure;
/** fieldControl */
@property (nonatomic, copy) NSString *fieldControl;
/** 隐藏按钮 */
@property (nonatomic, assign) BOOL isHideBtn;

/** borderView */
@property (nonatomic, weak) UIView *borderView;

@end
