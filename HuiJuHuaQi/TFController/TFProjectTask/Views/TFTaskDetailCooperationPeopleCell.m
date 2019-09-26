//
//  TFTaskDetailCooperationPeopleCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/16.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskDetailCooperationPeopleCell.h"
#import "TFAllPeopleView.h"

@interface TFTaskDetailCooperationPeopleCell ()
@property (weak, nonatomic) IBOutlet TFAllPeopleView *peopleView;

@end

@implementation TFTaskDetailCooperationPeopleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.peopleView refreshAllPeopleViewWithPeoples:@[]];
}

-(void)refreshTaskDetailCooperationPeopleCellWithPeoples:(NSArray *)peoples{
    [self.peopleView refreshAllPeopleViewWithPeoples:peoples];
    
}

+(CGFloat)refreshTaskDetailCooperationPeopleCellHeightWithPeoples:(NSArray *)peoples{
    NSInteger column =  (NSInteger)((SCREEN_WIDTH-64) / (30 + 10));
    NSInteger row = ((peoples.count + 1 + (column -1)) / column);// 行，包含加号
    return 10 + row * (30 + 10);
}

+(instancetype)taskDetailCooperationPeopleCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFTaskDetailCooperationPeopleCell" owner:self options:nil] lastObject];
}
+(instancetype)taskDetailCooperationPeopleCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFTaskDetailCooperationPeopleCell";
    TFTaskDetailCooperationPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFTaskDetailCooperationPeopleCell taskDetailCooperationPeopleCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
