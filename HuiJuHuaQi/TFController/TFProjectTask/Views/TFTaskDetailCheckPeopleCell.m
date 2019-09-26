//
//  TFTaskDetailCheckPeopleCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/16.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskDetailCheckPeopleCell.h"
#import "TFAllPeopleView.h"

@interface TFTaskDetailCheckPeopleCell ()
@property (weak, nonatomic) IBOutlet UIButton *peopleBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation TFTaskDetailCheckPeopleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImage.image = IMG(@"excuPro");
    self.checkPeople.textColor = ExtraLightBlackTextColor;
    self.checkPeople.font = FONT(14);
    self.nameLabel.textColor = ExtraLightBlackTextColor;
    self.nameLabel.font = FONT(14);
    self.nameLabel.text = @"";
    self.peopleBtn.userInteractionEnabled = NO;
    self.peopleBtn.layer.cornerRadius = 15;
    self.peopleBtn.layer.masksToBounds = YES;
    self.peopleBtn.titleLabel.font = FONT(12);
}

-(void)refreshCheckPeopleWithEmployee:(HQEmployModel *)model{
    
    if (model) {
        [self.peopleBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image == nil) {
                
                [self.peopleBtn setTitle:[HQHelper nameWithTotalName:model.name?:model.employee_name] forState:UIControlStateNormal];
                [self.peopleBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
                [self.peopleBtn setBackgroundColor:HeadBackground];
            }else{
                
                [self.peopleBtn setTitle:@"" forState:UIControlStateNormal];
                [self.peopleBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
                [self.peopleBtn setBackgroundColor:WhiteColor];
            }
            
        }];
        
        self.nameLabel.text = model.name?:model.employee_name;
    }else{
        
        [self.peopleBtn setBackgroundImage:IMG(@"加人") forState:UIControlStateNormal];
        [self.peopleBtn setBackgroundColor:WhiteColor];
        [self.peopleBtn setTitle:@"" forState:UIControlStateNormal];
        self.nameLabel.text = @"";
    }
}

+(instancetype)taskDetailCheckPeopleCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFTaskDetailCheckPeopleCell" owner:self options:nil] lastObject];
}
+(instancetype)taskDetailCheckPeopleCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFTaskDetailCheckPeopleCell";
    TFTaskDetailCheckPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFTaskDetailCheckPeopleCell taskDetailCheckPeopleCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
