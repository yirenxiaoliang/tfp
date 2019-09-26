
//
//  HQCreatScheduleTitleCell.m
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/24.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQCreatScheduleTitleCell.h"

@implementation HQCreatScheduleTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        HQAdviceTextView *textView = [[HQAdviceTextView alloc] init];
        textView.backgroundColor = ClearColor;
        [self.contentView addSubview:textView];
        
        textView.font = FONT(17);
        self.textVeiw = textView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textVeiw.frame = CGRectMake(10, 4, SCREEN_WIDTH-20, self.height - 5);
}


+ (instancetype)creatScheduleTitleCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"creatScheduleTitleCell";
    HQCreatScheduleTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HQCreatScheduleTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
