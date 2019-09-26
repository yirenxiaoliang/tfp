//
//  TFNoteDetailRemindCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFNoteDetailRemindCellDelegate <NSObject>

@optional
-(void)noteDetailRemindCellDidDeleteBtn:(NSInteger)index;

@end

@interface TFNoteDetailRemindCell : UITableViewCell

+ (instancetype)noteDetailRemindCellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, weak) id <TFNoteDetailRemindCellDelegate>delegate;

- (void)refreshNoteDetailRemindCellWithData:(NSString *)data;

@end
