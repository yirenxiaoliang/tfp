//
//  TFTaskListCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskListCell.h"
#import "TFTagListView.h"
#import "TFCustomerOptionModel.h"

@interface TFTaskListCell()<TFTagListViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *urgeImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *overTimeBtn;
@property (weak, nonatomic) IBOutlet TFTagListView *tagListView;

/** height */
@property (nonatomic, assign) CGFloat tagHeight;


@end

@implementation TFTaskListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.textColor = HexColor(0x323232);
    self.nameLabel.font = FONT(13);
    [self.overTimeBtn setTitleColor:HexColor(0x909090) forState:UIControlStateNormal];
    self.overTimeBtn.titleLabel.font = FONT(13);
    
    self.headImage.layer.cornerRadius = 8;
    self.headImage.layer.masksToBounds = YES;
    self.bgView.backgroundColor = WhiteColor;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bgView.layer.cornerRadius = 4;
//    self.bgView.layer.borderColor = CellSeparatorColor.CGColor;
//    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.shadowColor = CellSeparatorColor.CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(4, 4);
    self.bgView.layer.shadowRadius = 2;
    self.bgView.layer.shadowOpacity = 0.3;
    
    NSArray *dd = @[@"",@"一",@"二二",@"三三三",@"思思思思",@"呜呜呜呜呜"];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; i ++) {
        TFCustomerOptionModel *option = [[TFCustomerOptionModel alloc] init];
        option.label = [NSString stringWithFormat:@"%@%ld",dd[arc4random_uniform(6)],i];
        option.color = @"#3698e9";
        
        [arr addObject:option];
    }
    [self.selectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    self.backgroundColor = ClearColor;
    
    
    [self.tagListView refreshWithOptions:arr];
    self.tagListView.delegate = self;
    
    self.headImage.image = [UIImage imageNamed:@"头像"];
    self.urgeImage.image = [UIImage imageNamed:@"超期project"];
    self.nameLabel.text = @"这里是任务任务名称这里名称这里是任务名称…";
    [self.overTimeBtn setTitle:@"07/08(超期3天)" forState:UIControlStateNormal];
    [self.overTimeBtn setImage:[UIImage imageNamed:@"关联"] forState:UIControlStateNormal];
}

-(void)tagListViewHeight:(CGFloat)height{
    
    self.tagHeight = height;
}

+(CGFloat)taskListCellHeight{
    
    
    return 120;
}


+ (instancetype)taskListCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFTaskListCell" owner:self options:nil] lastObject];
}

+ (TFTaskListCell *)taskListCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFTaskListCell";
    TFTaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self taskListCell];
    }
    return cell;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
