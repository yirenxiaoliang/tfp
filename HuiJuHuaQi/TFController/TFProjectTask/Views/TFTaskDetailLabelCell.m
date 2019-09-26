//
//  TFTaskDetailLabelCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/17.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskDetailLabelCell.h"
#import "TFOptionListView.h"

@interface TFTaskDetailLabelCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet TFOptionListView *optionView;


@end

@implementation TFTaskDetailLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImage.image = IMG(@"公司文件库");
    self.titleLabel.text = @"加标签";
    self.titleLabel.textColor = ExtraLightBlackTextColor;
    self.titleLabel.font = FONT(14);
    self.descLabel.text = @"添加标签";
    self.descLabel.textColor = LightGrayTextColor;
    self.descLabel.font = FONT(14);
    self.headImage.image = IMG(@"labelPro");
}

/** 刷新 */
-(void)refreshTaskDetailLabelCellWithOptions:(NSArray *)options{
    
    if (options.count) {
        self.descLabel.hidden = YES;
    }else{
        self.descLabel.hidden = NO;
    }
    [self.optionView refreshWithOptions:options];
}


/** 高度 */
+(CGFloat)refreshTaskDetailLabelCellHeightWithOptions:(NSArray *)options{
    
    CGFloat height = 0;
    
    height += 24;// optionView 与 borderView的上下间距
    
    height += [TFOptionListView refreshOptionListViewHeightWithOptions:options maxWidth:SCREEN_WIDTH - 130 - 30];// optionView 的高度
    
    return height < 50 ? 50 : height;
}

+(instancetype)taskDetailLabelCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFTaskDetailLabelCell" owner:self options:nil] lastObject];
}

+(instancetype)taskDetailLabelCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFTaskDetailLabelCell";
    TFTaskDetailLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFTaskDetailLabelCell taskDetailLabelCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
