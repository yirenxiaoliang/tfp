//
//  TFAddPersonsCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddPersonsCell.h"

@interface TFAddPersonsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *addImg;

@property (weak, nonatomic) IBOutlet UILabel *addLab;

@end

@implementation TFAddPersonsCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    _addImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPersons)];

    [_addImg addGestureRecognizer:tap];
}

- (void)addPersons {

    if ([self.delegate respondsToSelector:@selector(addManagers:)]) {
        
        [self.delegate addManagers:self.tag];
    }
}

+ (instancetype)TFAddPersonsCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFAddPersonsCell" owner:self options:nil] lastObject];
}



+ (instancetype)AddPersonsCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFAddPersonsCell";
    TFAddPersonsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFAddPersonsCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
