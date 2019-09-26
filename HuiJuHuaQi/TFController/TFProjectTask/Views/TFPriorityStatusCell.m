//
//  TFPriorityStatusCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/18.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPriorityStatusCell.h"

@interface TFPriorityStatusCell ()
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@end

@implementation TFPriorityStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.statusBtn.userInteractionEnabled = NO;
    self.statusBtn.layer.cornerRadius = 4;
    self.statusBtn.layer.borderWidth = 1;
    self.statusBtn.titleLabel.font = FONT(14);
    self.selectBtn.userInteractionEnabled = NO;
}


-(void)refreshNewStatusCellWithModel:(TFCustomerOptionModel *)model{
    
    [self.statusBtn setTitle:[NSString stringWithFormat:@" %@",model.label] forState:UIControlStateNormal];
//    self.statusBtn.backgroundColor = [HQHelper colorWithHexString:model.color];
    self.statusBtn.backgroundColor = ClearColor;
    [self.statusBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
    self.statusBtn.layer.borderColor = ClearColor.CGColor;
    if ([model.value integerValue] == 0) {// 未进行
        [self.statusBtn setImage:IMG(@"task未开始") forState:UIControlStateNormal];
    }else if ([model.value integerValue] == 1){// 进行中
        [self.statusBtn setImage:IMG(@"task进行中") forState:UIControlStateNormal];
    }else if ([model.value integerValue] == 2){// 暂停
        [self.statusBtn setImage:IMG(@"task暂停") forState:UIControlStateNormal];
    }else if ([model.value integerValue] == 3){// 完成
        [self.statusBtn setImage:IMG(@"task已完成") forState:UIControlStateNormal];
    }
    [self.statusBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@72);
    }];
}
-(void)refreshStatusCellWithModel:(TFCustomerOptionModel *)model{
    
    [self.statusBtn setTitle:[NSString stringWithFormat:@"  %@  ",model.label] forState:UIControlStateNormal];
    self.statusBtn.backgroundColor = [HQHelper colorWithHexString:model.color];
    [self.statusBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.statusBtn.layer.borderColor = ClearColor.CGColor;
    
}
-(void)refreshPriorityStatusCellWithModel:(TFCustomerOptionModel *)model{

    [self.statusBtn setTitle:[NSString stringWithFormat:@"  %@  ",model.label] forState:UIControlStateNormal];
    self.statusBtn.backgroundColor = WhiteColor;
    [self.statusBtn setTitleColor:[HQHelper colorWithHexString:model.color] forState:UIControlStateNormal];
    self.statusBtn.layer.borderColor = [HQHelper colorWithHexString:model.color].CGColor;

}

/** type 0:状态 1：优先级
 *  status type == 0 时 0：未开始 1：进行中 2：暂停 3：已完成
 *  status type == 1 时 0：普通 1：紧急 2：非常紧急
 */
-(void)refreshPriorityStatusCellWithType:(NSInteger)type status:(NSInteger)status{
    
    if (type == 0) {
        if (status == 0) {
            [self.statusBtn setTitle:@"  未开始  " forState:UIControlStateNormal];
            self.statusBtn.backgroundColor = HexColor(0xE5E5E5);
            [self.statusBtn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
            self.statusBtn.layer.borderColor = ClearColor.CGColor;
        }else if (status == 1){
            [self.statusBtn setTitle:@"  进行中  " forState:UIControlStateNormal];
            self.statusBtn.backgroundColor = HexColor(0xDAEDFF);
            [self.statusBtn setTitleColor:GreenColor forState:UIControlStateNormal];
            self.statusBtn.layer.borderColor = ClearColor.CGColor;
        }else if (status == 2){
            [self.statusBtn setTitle:@"  已暂停  " forState:UIControlStateNormal];
            self.statusBtn.backgroundColor = HexColor(0xFFEAF0);
            [self.statusBtn setTitleColor:RedColor forState:UIControlStateNormal];
            self.statusBtn.layer.borderColor = ClearColor.CGColor;
        }else if (status == 3){
            [self.statusBtn setTitle:@"  已完成  " forState:UIControlStateNormal];
            self.statusBtn.backgroundColor = HexColor(0xEFF8E8);
            [self.statusBtn setTitleColor:HexColor(0x4D7D2D) forState:UIControlStateNormal];
            self.statusBtn.layer.borderColor = ClearColor.CGColor;
        }
        
    }else{
        
        if (status == 0) {
            [self.statusBtn setTitle:@"  普通  " forState:UIControlStateNormal];
            self.statusBtn.backgroundColor = WhiteColor;
            [self.statusBtn setTitleColor:HexColor(0x23D7BB) forState:UIControlStateNormal];
            self.statusBtn.layer.borderColor = HexColor(0x23D7BB).CGColor;
        }else if (status == 1){
            [self.statusBtn setTitle:@"  紧急  " forState:UIControlStateNormal];
            self.statusBtn.backgroundColor = WhiteColor;
            [self.statusBtn setTitleColor:HexColor(0xFFC442) forState:UIControlStateNormal];
            self.statusBtn.layer.borderColor = HexColor(0xFFC442).CGColor;
        }else if (status == 2){
            [self.statusBtn setTitle:@"  非常紧急  " forState:UIControlStateNormal];
            self.statusBtn.backgroundColor = WhiteColor;
            [self.statusBtn setTitleColor:RedColor forState:UIControlStateNormal];
            self.statusBtn.layer.borderColor = RedColor.CGColor;
        }
    }
    
}

+(instancetype)priorityStatusCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFPriorityStatusCell" owner:self options:nil] lastObject];
}

+(instancetype)priorityStatusCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFPriorityStatusCell";
    TFPriorityStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFPriorityStatusCell priorityStatusCell];
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
