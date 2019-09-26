//
//  TFNoteDetailAddressCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteDetailAddressCell.h"

@interface TFNoteDetailAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *detailLable;



@end

@implementation TFNoteDetailAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.deleteBtn setImage:IMG(@"新备忘录删除") forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshNoteDetailAddressCellWithData:(TFLocationModel *)model {
    
    self.titleLable.text = model.name;
    self.detailLable.text = model.totalAddress;
    
    
    if (model.totalAddress.length) {
        
        self.detailLable.text = [NSString stringWithFormat:@"%@",model.totalAddress];
    }else{
        
        self.detailLable.text = [NSString stringWithFormat:@"%@",model.detailAddress];
    }
}

- (void)deleteAction {
    
    if ([self.delegate respondsToSelector:@selector(noteDetailAddressCellDidDeleteBtnWithIndex:)]) {
        
        [self.delegate noteDetailAddressCellDidDeleteBtnWithIndex:self.index];
    }
}

+ (instancetype)noteDetailAddressCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFNoteDetailAddressCell" owner:self options:nil] lastObject];
}

+ (instancetype)noteDetailAddressCellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"TFNoteDetailAddressCell";
    TFNoteDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self noteDetailAddressCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kUIColorFromRGB(0xF8F8F8);
    cell.layer.cornerRadius = 4.0;
    cell.layer.masksToBounds = YES;
    return cell;
}

@end
