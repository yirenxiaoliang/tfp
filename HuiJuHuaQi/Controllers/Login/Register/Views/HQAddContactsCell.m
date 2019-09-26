//
//  HQAddContactsCell.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/14.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQAddContactsCell.h"

@interface HQAddContactsCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

/** contactsModel */
@property (nonatomic, strong) HQContactsModel *contactsModel;

@end

@implementation HQAddContactsCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.nameLabel.textColor = BlackTextColor;
    self.nameLabel.font = FONT(16);
    
    self.phoneLabel.textColor = LightGrayTextColor;
    self.phoneLabel.font = FONT(14);
    
    self.selectBtn.titleLabel.font = FONT(14);
    self.selectBtn.layer.borderColor = GreenColor.CGColor;
    self.selectBtn.layer.cornerRadius = 2;
    self.selectBtn.layer.masksToBounds = YES;
    
    self.topLine.hidden = YES;
    self.headMargin = 15;
    
    self.selectBtn.userInteractionEnabled = YES;
    [self.selectBtn addTarget:self action:@selector(selectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)selectBtnClicked{
    if ([self.delegate respondsToSelector:@selector(addContactsCellDidClickedAddBtnWithModel:)]) {
        [self.delegate addContactsCellDidClickedAddBtnWithModel:self.contactsModel];
    }
}


- (void)refreshCellWithModel:(id)model
{
    HQContactsModel *contactsModel = (HQContactsModel *)model;
    self.contactsModel = contactsModel;
    
    NSString *nameStr;
    if (contactsModel.firstName.length > 0) {
        nameStr = contactsModel.firstName;
    }
    
    if (contactsModel.lastName.length > 0) {
        nameStr = [NSString stringWithFormat:@"%@%@", TEXT(contactsModel.lastName) , TEXT(nameStr)];
    }
    
    _nameLabel.text  = nameStr;
    
    _phoneLabel.text = [[contactsModel.phones firstObject] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
//    if (contactsModel.selected == YES) {
//        
//        
//        [self.selectBtn setTitle:@"已添加" forState:UIControlStateNormal];
//        [self.selectBtn setTitle:@"已添加" forState:UIControlStateHighlighted];
//        [self.selectBtn setTitleColor:LightGrayTextColor forState:UIControlStateHighlighted];
//        [self.selectBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
//        self.selectBtn.layer.borderWidth = 0;
//    }else {
        [self.selectBtn setTitle:@"添加" forState:UIControlStateNormal];
        [self.selectBtn setTitle:@"添加" forState:UIControlStateHighlighted];
        [self.selectBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
        [self.selectBtn setTitleColor:GreenColor forState:UIControlStateNormal];
        self.selectBtn.layer.borderWidth = 1;
//    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
