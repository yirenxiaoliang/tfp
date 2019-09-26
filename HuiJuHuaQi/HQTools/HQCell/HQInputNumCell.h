//
//  HQInputNumCell.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/4/11.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseTableViewCell.h"


//@protocol HQInputNumCellDelegate <NSObject>
//
//- (void)numTextFieldChange:(NSString *)string;
//
//@end

@interface HQInputNumCell : HQBaseTableViewCell


@property (strong, nonatomic) IBOutlet UILabel *titleNameLabel;


@property (strong, nonatomic) IBOutlet UITextField *numberField;


@property (strong, nonatomic) IBOutlet UILabel *unitLabel;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleWidthLayout;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *unitWidthLayout;


//@property (nonatomic, weak) id <HQInputNumCellDelegate> delegate;


+ (HQInputNumCell *)inputNumCelllWithTableView:(UITableView *)tableView;


- (void)setTitleNameStr:(NSString *)titleNameStr;

- (void)setUnitStr:(NSString *)unitStr;
@end
