//
//  TFNoteDetailRemindCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteDetailRemindCell.h"

@interface TFNoteDetailRemindCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLable;


@end

@implementation TFNoteDetailRemindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.deleteBtn setImage:IMG(@"新备忘录删除") forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshNoteDetailRemindCellWithData:(NSString *)data {
    
    self.timeLable.text = data;
}

- (void)deleteAction {
    
    if ([self.delegate respondsToSelector:@selector(noteDetailRemindCellDidDeleteBtn:)]) {
        
        [self.delegate noteDetailRemindCellDidDeleteBtn:self.index];
    }
}

+ (instancetype)noteDetailRemindCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFNoteDetailRemindCell" owner:self options:nil] lastObject];
}

+ (instancetype)noteDetailRemindCellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"TFNoteDetailRemindCell";
    TFNoteDetailRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self noteDetailRemindCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kUIColorFromRGB(0xF8F8F8);
    cell.layer.cornerRadius = 4.0;
    cell.layer.masksToBounds = YES;
    return cell;
}

@end
