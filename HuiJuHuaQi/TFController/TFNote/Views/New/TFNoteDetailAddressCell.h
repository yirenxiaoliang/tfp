//
//  TFNoteDetailAddressCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFLocationModel.h"

@protocol TFNoteDetailAddressCellDelegate <NSObject>

@optional
-(void)noteDetailAddressCellDidDeleteBtnWithIndex:(NSInteger)index;

@end

@interface TFNoteDetailAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic, assign) NSInteger index;

- (void)refreshNoteDetailAddressCellWithData:(TFLocationModel *)model;

+ (instancetype)noteDetailAddressCellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id <TFNoteDetailAddressCellDelegate>delegate;

@end
