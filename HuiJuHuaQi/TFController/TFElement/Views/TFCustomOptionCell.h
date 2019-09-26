//
//  TFCustomOptionCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFTagListView.h"

@protocol TFCustomOptionCellDelegate <NSObject>

@optional
- (void)arrowClicked:(NSInteger)index section:(NSInteger)section;

@end

@interface TFCustomOptionCell : HQBaseCell

@property (nonatomic ,weak) TFTagListView *tagListView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *requireLabel;
/** UIImageView *arrow */
@property (nonatomic, strong) UIImageView *arrow;

/** borderView */
@property (nonatomic, weak) UIView *borderView;

/** structure */
@property (nonatomic, copy) NSString *structure;
/** fieldControl */
@property (nonatomic, copy) NSString *fieldControl;

/** delegate */
@property (nonatomic, weak) id <TFCustomOptionCellDelegate>delegate;
/** 箭头显示状态  */
@property (assign, nonatomic) BOOL arrowType;

+ (instancetype)creatCustomOptionCellWithTableView:(UITableView *)tableView;

- (void)refreshCustomOptionCellWithOptions:(NSArray *)options;
+ (CGFloat)refreshCustomOptionCellHeightWithOptions:(NSArray *)options withStructure:(NSString *)structure;

@end
