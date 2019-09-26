//
//  TFSelectPeopleElementCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectPeopleElementCell.h"


@interface TFSelectPeopleElementCell ()

@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameH;


@end


@implementation TFSelectPeopleElementCell


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.headBtn.layer.cornerRadius = 22.5;
    self.headBtn.layer.masksToBounds = YES;
    self.headBtn.userInteractionEnabled = NO;
    self.headBtn.contentMode = UIViewContentModeCenter;
    
    self.nameLabel.textColor = BlackTextColor;
    self.nameLabel.font = FONT(16);
    
    self.positionLabel.textColor = ExtraLightBlackTextColor;
    self.positionLabel.font = FONT(13);
    
    self.numLabel.textColor = ExtraLightBlackTextColor;
    self.numLabel.font = FONT(14);
    
    self.arrowImage.image = IMG(@"下一级浅灰");
    self.arrowImage.contentMode = UIViewContentModeCenter;
    
    self.topLine.hidden = NO;
}

- (IBAction)selectBtnClicked:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(selectPeopleElementCellDidClickedSelectBtn:)]) {
        [self.delegate selectPeopleElementCellDidClickedSelectBtn:sender];
    }

}

+ (instancetype)TFSelectPeopleElementCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFSelectPeopleElementCell" owner:self options:nil] lastObject];
}


/** 不知道为什么子控制器里，SDWebImage加载图片很乱，所以不复用cell */
+ (instancetype)selectPeopleElementCellWithTableView:(UITableView *)tableView index:(NSInteger)index{
    
    NSString *ID = [NSString stringWithFormat:@"%@%ld",@"TFSelectPeopleElementCell",index];
    TFSelectPeopleElementCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFSelectPeopleElementCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


/** 部门 */
-(void)refreshCellWithDepartmentModel:(TFDepartmentModel *)model isSingle:(BOOL)isSingle{
    
    if (isSingle) {
        self.selectBtn.hidden = YES ;
        self.selectW.constant = 0;
    }else{
        self.selectBtn.hidden = NO ;
        self.selectW.constant = 30;
    }
    
    self.nameH.constant = 0;
    self.positionLabel.hidden = YES;
    if ([model.type isEqualToNumber:@(-1)]) {
        [self.headBtn setBackgroundImage:IMG(@"头像") forState:UIControlStateNormal];
    }else{
        [self.headBtn setBackgroundImage:IMG(@"组织架构") forState:UIControlStateNormal];
    }
    
    self.nameLabel.text = model.name;
    
    NSInteger count = [model.count integerValue];
    NSInteger total = [model.company_count integerValue];
    NSInteger num = 0;
    if (total > count) {
        num = total;
    }else{
        num = count;
    }
    
    self.numLabel.text = [NSString stringWithFormat:@"%ld",num];
    
    if (!model.select || [model.select isEqualToNumber:@0]) {
        
        [self.selectBtn setImage:IMG(@"没选中") forState:UIControlStateNormal];
        [self.selectBtn setImage:IMG(@"没选中") forState:UIControlStateHighlighted];
    }else if ([model.select isEqualToNumber:@1]){
        
        [self.selectBtn setImage:IMG(@"选中了") forState:UIControlStateNormal];
        [self.selectBtn setImage:IMG(@"选中了") forState:UIControlStateHighlighted];
    }else{
        
        [self.selectBtn setImage:IMG(@"selectNo") forState:UIControlStateNormal];
        [self.selectBtn setImage:IMG(@"selectNo") forState:UIControlStateHighlighted];
    }
    
    if (model.users.count != 0 || model.childList.count != 0) {
        self.arrowImage.hidden = NO;
    }else{
        self.arrowImage.hidden = YES;
    }
}
/** 人员 */
-(void)refreshCellWithEmployeeModel:(TFEmployModel *)model isSingle:(BOOL)isSingle{
    
    if (isSingle) {
        self.selectBtn.hidden = YES ;
        self.selectW.constant = 0;
    }else{
        self.selectBtn.hidden = NO ;
        self.selectW.constant = 30;
    }
    
        
//        [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[model.picture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
//        [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[model.picture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
    [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) {
            
            [self.headBtn setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
            [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.headBtn setBackgroundColor:HeadBackground];
        }else{
            
            [self.headBtn setTitle:@"" forState:UIControlStateNormal];
            [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.headBtn setBackgroundColor:WhiteColor];
        }
        
    }];
    
    
    self.nameLabel.text = model.employee_name;
    self.numLabel.hidden = YES;
    
    if (!model.select || [model.select isEqualToNumber:@0]) {
        
        [self.selectBtn setImage:IMG(@"没选中") forState:UIControlStateNormal];
        [self.selectBtn setImage:IMG(@"没选中") forState:UIControlStateHighlighted];
    }else if ([model.select isEqualToNumber:@1]){
        
        [self.selectBtn setImage:IMG(@"选中了") forState:UIControlStateNormal];
        [self.selectBtn setImage:IMG(@"选中了") forState:UIControlStateHighlighted];
    }else{
        
        [self.selectBtn setImage:IMG(@"selectNo") forState:UIControlStateNormal];
        [self.selectBtn setImage:IMG(@"selectNo") forState:UIControlStateHighlighted];
    }
    
    self.arrowImage.hidden = YES;
    
//    if (model.post_name && ![model.post_name isEqualToString:@""]) {
//        self.nameH.constant = -12;
//        self.positionLabel.hidden = NO;
//        self.positionLabel.text = model.post_name;
//    }else{
//        self.positionLabel.hidden = YES;
//
//        self.nameH.constant = 0;
//    }
    if (!model.post_name || [model.post_name isEqualToString:@""]) {
        model.post_name = @"--";
    }
    self.nameH.constant = -12;
    self.positionLabel.hidden = NO;
    self.positionLabel.text = model.post_name;
}

/** 邮件通讯录 */
-(void)refreshEmailsAddressBookWithModel:(TFEmailAddessBookItemModel *)model {
    
    self.selectBtn.hidden = NO ;
    self.selectW.constant = 30;
    
//    if (![model.avatarUrl isEqualToString:@""]) {
//        
//        [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:@""] forState:UIControlStateNormal];
//        [self.headBtn setTitle:@"" forState:UIControlStateNormal];
//    }
//    else {
    
    self.headBtn.layer.borderWidth = 1.0;
    self.headBtn.layer.borderColor = [kUIColorFromRGB(0x20BF9A) CGColor];
    
        [self.headBtn sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
        [self.headBtn setTitle:[HQHelper nameWithTotalName2:model.name] forState:UIControlStateNormal];
        [self.headBtn setTitleColor:kUIColorFromRGB(0x20BF9A) forState:UIControlStateNormal];
        [self.headBtn setBackgroundColor:kUIColorFromRGB(0xFFFFFF)];
//    }
//    [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:@""] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
//    [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:@""] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
    
    self.nameLabel.text = model.name;
    self.numLabel.hidden = YES;
    
    if (!model.select || [model.select isEqualToNumber:@0]) {
        
        [self.selectBtn setImage:IMG(@"没选中") forState:UIControlStateNormal];
        [self.selectBtn setImage:IMG(@"没选中") forState:UIControlStateHighlighted];
    }else if ([model.select isEqualToNumber:@1]){
        
        [self.selectBtn setImage:IMG(@"选中了") forState:UIControlStateNormal];
        [self.selectBtn setImage:IMG(@"选中了") forState:UIControlStateHighlighted];
    }else{
        
        [self.selectBtn setImage:IMG(@"selectNo") forState:UIControlStateNormal];
        [self.selectBtn setImage:IMG(@"selectNo") forState:UIControlStateHighlighted];
    }
    
    self.arrowImage.hidden = YES;
    
    if (model.mail_address && ![model.mail_address isEqualToString:@""]) {
        self.nameH.constant = -12;
        self.positionLabel.hidden = NO;
        self.positionLabel.text = model.mail_address;
    }else{
        self.positionLabel.hidden = YES;
        
        self.nameH.constant = 0;
    }
}

/** 角色 */
-(void)refreshCellWithRoleModel:(TFRoleModel *)model isSingle:(BOOL)isSingle{
    if (isSingle) {
        self.selectBtn.hidden = YES ;
        self.selectW.constant = 0;
        self.headLeft.constant = 0;
    }else{
        self.selectBtn.hidden = NO ;
        self.selectW.constant = 30;
        self.headLeft.constant = 8;
    }
    self.headW.constant = 0;
    self.headLeft.constant = 0;
    self.headBtn.hidden = YES;
    
    self.nameLabel.text = model.name;
    self.numLabel.hidden = YES;
    
    if (!model.select || [model.select isEqualToNumber:@0]) {
        
        [self.selectBtn setImage:IMG(@"没选中") forState:UIControlStateNormal];
        [self.selectBtn setImage:IMG(@"没选中") forState:UIControlStateHighlighted];
    }else if ([model.select isEqualToNumber:@1]){
        
        [self.selectBtn setImage:IMG(@"选中了") forState:UIControlStateNormal];
        [self.selectBtn setImage:IMG(@"选中了") forState:UIControlStateHighlighted];
    }else{
        
        [self.selectBtn setImage:IMG(@"signSelect") forState:UIControlStateNormal];
        [self.selectBtn setImage:IMG(@"signSelect") forState:UIControlStateHighlighted];
    }
    
    if (model.roles.count) {
        self.arrowImage.hidden = NO;
    }else{
        self.arrowImage.hidden = YES;
    }
    
    self.positionLabel.hidden = YES;
    self.nameH.constant = 0;
    
}

/** 动态参数 */
-(void)refreshCellWithParameterModel:(TFDynamicParameterModel *)model isSingle:(BOOL)isSingle{
    if (isSingle) {
        self.selectBtn.hidden = YES ;
        self.selectW.constant = 0;
        self.headLeft.constant = 0;
    }else{
        self.selectBtn.hidden = NO ;
        self.selectW.constant = 30;
        self.headLeft.constant = 8;
    }
    self.headW.constant = 0;
    self.headLeft.constant = 0;
    self.headBtn.hidden = YES;
    
    self.nameLabel.text = model.name;
    self.numLabel.hidden = YES;
    
    if (!model.select || [model.select isEqualToNumber:@0]) {
        
        [self.selectBtn setImage:IMG(@"没选中") forState:UIControlStateNormal];
        [self.selectBtn setImage:IMG(@"没选中") forState:UIControlStateHighlighted];
    }else if ([model.select isEqualToNumber:@1]){
        
        [self.selectBtn setImage:IMG(@"选中了") forState:UIControlStateNormal];
        [self.selectBtn setImage:IMG(@"选中了") forState:UIControlStateHighlighted];
    }else{
        
        [self.selectBtn setImage:IMG(@"signSelect") forState:UIControlStateNormal];
        [self.selectBtn setImage:IMG(@"signSelect") forState:UIControlStateHighlighted];
    }
    
    if (model.roles.count) {
        self.arrowImage.hidden = NO;
    }else{
        self.arrowImage.hidden = YES;
    }
    
    self.positionLabel.hidden = YES;
    self.nameH.constant = 0;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
