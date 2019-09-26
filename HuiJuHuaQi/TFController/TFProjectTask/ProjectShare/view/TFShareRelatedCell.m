//
//  TFShareRelatedCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/16.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFShareRelatedCell.h"

@interface TFShareRelatedCell ()

@property (weak, nonatomic) IBOutlet UILabel *lable;


@end

@implementation TFShareRelatedCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.relatedBtn.layer.cornerRadius = 4.0;
    self.relatedBtn.layer.masksToBounds = YES;
    self.relatedBtn.layer.borderColor = [kUIColorFromRGB(0x3689E9) CGColor];
    self.relatedBtn.layer.borderWidth = 0.5;
    
    [self.relatedBtn addTarget:self action:@selector(relatedAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)relatedAction {

    if ([self.delegate respondsToSelector:@selector(addRelatedContent)]) {
        
        [self.delegate addRelatedContent];
    }
}

+ (instancetype)TFShareRelatedCell {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"TFShareRelatedCell" owner:self options:nil] lastObject];
}

+ (instancetype)shareRelatedCellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"TFShareRelatedCell";
    TFShareRelatedCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFShareRelatedCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    cell.topLine.hidden = YES;
    return cell;
}

@end
