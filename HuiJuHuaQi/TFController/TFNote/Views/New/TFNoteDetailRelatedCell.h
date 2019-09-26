//
//  TFNoteDetailRelatedCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFNoteDetailRelatedCellDelegate <NSObject>

@optional
-(void)noteDetailRelatedCellDidDeleteBtn:(NSInteger)index;

@end

@interface TFNoteDetailRelatedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, weak) id <TFNoteDetailRelatedCellDelegate>delegate;

- (void)refreshNoteDetailRelatedCellWithData:(NSDictionary *)dic1;

+ (instancetype)noteDetailRelatedCellWithTableView:(UITableView *)tableView;

@end
