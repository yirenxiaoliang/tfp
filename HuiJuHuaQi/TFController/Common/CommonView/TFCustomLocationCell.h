//
//  TFCustomLocationCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

#import "TFCustomerRowsModel.h"

@class TFCustomLocationCell,TFSingleTextCell;

@protocol TFCustomLocationCellDelegate <NSObject>

@optional
-(void)customLocationCell:(TFCustomLocationCell *)customLocationCell didClilckedLocationBtn:(UIButton *)enterBtn;

-(void)customLocationCell:(TFCustomLocationCell *)customLocationCell textViewDidChange:(UITextView *)textView;

-(void)customLocationCellWithSelectCity:(TFCustomLocationCell *)customLocationCell;

@end

@interface TFCustomLocationCell : HQBaseCell

/** requireLabel */
@property (nonatomic, weak) UILabel *requireLabel;

/** delegate */
@property (nonatomic, weak) id <TFCustomLocationCellDelegate>delegate;

+ (TFCustomLocationCell *)customLocationCellWithTableView:(UITableView *)tableView;

- (void)customLocationCellWithModel:(TFCustomerRowsModel *)model;

/** 是否可编辑 */
@property (nonatomic, assign) BOOL isEdit;


@end
