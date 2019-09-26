
//
//  TFEmailsListCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailsListCell.h"

@interface TFEmailsListCell ()

@property (weak, nonatomic) IBOutlet UIView *conView;
@property (weak, nonatomic) IBOutlet UIButton *photoImg;

@property (weak, nonatomic) IBOutlet UILabel *contactLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *unReadLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactLabCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unreadLabCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unreadW;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation TFEmailsListCell

- (void)awakeFromNib {

    [super awakeFromNib];
    self.line.backgroundColor = CellSeparatorColor;
    self.backgroundColor = kUIColorFromRGB(0xF2F2F2);
    self.conView.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    
    self.photoImg.layer.cornerRadius = 20.0;
    self.photoImg.layer.masksToBounds = YES;
    self.photoImg.layer.borderWidth = 1.0;
    self.photoImg.layer.borderColor = [GreenColor CGColor];
    
    self.unReadLab.layer.cornerRadius = 5.0;
    self.unReadLab.layer.masksToBounds  = YES;
    self.unReadLab.backgroundColor = kUIColorFromRGB(0x108EE9);
    
    self.unReadLab.hidden = YES;
    
    self.unreadLabCon.constant = 10;
    self.contactLabCons.constant = 0;
    self.unreadW.constant = 0;
    self.contactLab.textColor = BlackTextColor;
    self.titleLab.textColor = LightBlackTextColor;
    self.contentLab.textColor = FinishedTextColor;
    self.timeLab.textColor = FinishedTextColor;
    
    self.selectBtn.hidden = YES;
    self.selectBtn.userInteractionEnabled = NO;
}

-(void)setSelect:(BOOL)select{
    _select = select;
    self.selectBtn.hidden = !select;
    self.photoImg.hidden = select;
}

-(void)refreshEmailListCellWithModel:(TFEmailReceiveListModel *)model {

//    [self.photoImgV sd_setImageWithURL:[HQHelper URLWithString:@""] placeholderImage:PlaceholderHeadImage];
    [self.photoImg sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
    [self.photoImg setTitle:[HQHelper nameWithTotalName:model.from_recipient] forState:UIControlStateNormal];
    [self.photoImg setTitleColor:GreenColor forState:UIControlStateNormal];
    [self.photoImg setBackgroundColor:WhiteColor];
    
    self.contactLab.text = model.from_recipient;
    
    
    if ([model.mail_box_id isEqualToNumber:@1]) { //收件箱
        
        if ([model.is_emergent isEqualToString:@"1"]) {
            [self.rightStatusBtn setImage:IMG(@"邮件紧急") forState:UIControlStateNormal];
        }
        if ([model.read_status isEqualToString:@"1"]) { //已读
            
            self.unReadLab.hidden = YES;
            
            self.unreadW.constant = 0;
            self.contactLabCons.constant = 0;
            
        }
        else {
            
            self.unreadW.constant = 10;
            self.contactLabCons.constant = 4;
            self.unReadLab.hidden = NO;
        }

    }
    
    else if ([model.mail_box_id isEqualToNumber:@2]) { //已发送
        
        self.leftStatusBtn.hidden = NO;
        

        
        if ([model.read_status isEqualToString:@"1"]) { //已读
            
            self.unReadLab.hidden = YES;
            
            self.unreadW.constant = 0;
            self.contactLabCons.constant = 0;
            
        }
        else {
            
            self.unreadW.constant = 10;
            self.contactLabCons.constant = 4;
            self.unReadLab.hidden = NO;
        }
        if ([model.send_status isEqualToNumber:@0]) { //发送失败
            
            if ([model.is_emergent isEqualToString:@"1"]) {
                
                [self.leftStatusBtn setImage:IMG(@"邮件紧急") forState:UIControlStateNormal];
            }
            
            [self.rightStatusBtn setImage:IMG(@"邮件发送失败") forState:UIControlStateNormal];
        }
        else if ([model.send_status isEqualToNumber:@1]) { //已发送
        
            if ([model.is_emergent isEqualToString:@"1"]) {
                
                [self.rightStatusBtn setImage:IMG(@"邮件紧急") forState:UIControlStateNormal];
            }
            else {
            
                [self.rightStatusBtn setImage:IMG(@"") forState:UIControlStateNormal];
                
            }
            
        }
        else if ([model.send_status isEqualToNumber:@2]) { //部分发送
        
            if ([model.is_emergent isEqualToString:@"1"]) {
                
                [self.leftStatusBtn setImage:IMG(@"邮件紧急") forState:UIControlStateNormal];
            }
            
            [self.rightStatusBtn setImage:IMG(@"邮件部分发送") forState:UIControlStateNormal];
        }
        
    }
    
    else if ([model.mail_box_id isEqualToNumber:@3] || [model.mail_box_id isEqualToNumber:@4]) { //草稿和已删除
        
//        if ([model.is_emergent isEqualToString:@"1"]){
//            self.contactLab.text = [NSString stringWithFormat:@"[紧急]%@",model.from_recipient];
//        
//            NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:self.contactLab.text];
//            
//            NSRange range = [self.contactLab.text rangeOfString:@"[紧急]"];
//            
//            [mString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
//            
//            self.contactLab.attributedText = mString;
//        }
    
        /** 草稿状态 */
        if ([model.draft_status isEqualToNumber:@1] && [model.approval_status isEqualToString:@"10"]) { //草稿状态并且没有审批
            
            self.contactLab.text = [NSString stringWithFormat:@"[草稿]%@",model.from_recipient];
            
            NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:self.contactLab.text];
            
            NSRange range = [self.contactLab.text rangeOfString:@"[草稿]"];
            
            [mString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
            
            self.contactLab.attributedText = mString;
            
        }
        else { //不是草稿
            
            
        }
        
        if ([model.is_emergent isEqualToString:@"1"]) {
            
            [self.rightStatusBtn setImage:IMG(@"邮件紧急") forState:UIControlStateNormal];
            
            /** 定时发送 */
            if ([model.timer_status isEqualToString:@"1"]) { //定时发送
                
                [self.leftStatusBtn setImage:IMG(@"邮件定时红") forState:UIControlStateNormal];
                
                /** 审批状态  2 审批通过 3 审批驳回 4 已撤销 10 没有审批 */
                if ([model.approval_status isEqualToString:@"2"]) { //审批通过
                    
                    [self.threeStatusBtn setImage:IMG(@"邮件流程通过") forState:UIControlStateNormal];
                    
                }
                else if ([model.approval_status isEqualToString:@"3"]){ //审批驳回
                    
                    [self.threeStatusBtn setImage:IMG(@"邮件流程驳回") forState:UIControlStateNormal];
                    
                }
                else if ([model.approval_status isEqualToString:@"4"]){ //已撤销
                    
                    [self.threeStatusBtn setImage:IMG(@"邮件流程驳回") forState:UIControlStateNormal];
                    
                }
                
            }
            else { //不是定时发送
                
                /** 审批状态  2 审批通过 3 审批驳回 4 已撤销 10 没有审批 */
                if ([model.approval_status isEqualToString:@"2"]) { //审批通过
                    
                    [self.leftStatusBtn setImage:IMG(@"邮件流程通过") forState:UIControlStateNormal];
                }
                else if ([model.approval_status isEqualToString:@"3"]){ //审批驳回
                    
                    [self.leftStatusBtn setImage:IMG(@"邮件流程驳回") forState:UIControlStateNormal];
                }
                else if ([model.approval_status isEqualToString:@"4"]){ //已撤销
                    
                    [self.leftStatusBtn setImage:IMG(@"邮件流程驳回") forState:UIControlStateNormal];
                }
                
            }

        }
        else {
        
            /** 定时发送 */
            if ([model.timer_status isEqualToString:@"1"]) { //定时发送
                
                [self.rightStatusBtn setImage:IMG(@"邮件定时红") forState:UIControlStateNormal];
                
                /** 审批状态  2 审批通过 3 审批驳回 4 已撤销 10 没有审批 */
                if ([model.approval_status isEqualToString:@"2"]) { //审批通过
                    
                    [self.leftStatusBtn setImage:IMG(@"邮件流程通过") forState:UIControlStateNormal];
                    
                }
                else if ([model.approval_status isEqualToString:@"3"]){ //审批驳回
                    
                    [self.leftStatusBtn setImage:IMG(@"邮件流程驳回") forState:UIControlStateNormal];
                    
                }
                else if ([model.approval_status isEqualToString:@"4"]){ //已撤销
                    
                    [self.leftStatusBtn setImage:IMG(@"邮件流程驳回") forState:UIControlStateNormal];
                    
                }
                
            }
            else { //不是定时发送
                
                /** 审批状态  2 审批通过 3 审批驳回 4 已撤销 10 没有审批 */
                if ([model.approval_status isEqualToString:@"2"]) { //审批通过
                    
                    [self.rightStatusBtn setImage:IMG(@"邮件流程通过") forState:UIControlStateNormal];
                    
                }
                else if ([model.approval_status isEqualToString:@"3"]){ //审批驳回
                    
                    [self.rightStatusBtn setImage:IMG(@"邮件流程驳回") forState:UIControlStateNormal];
                    
                }
                else if ([model.approval_status isEqualToString:@"4"]){ //已撤销
                    
                    [self.rightStatusBtn setImage:IMG(@"邮件流程驳回") forState:UIControlStateNormal];
                    
                }
                
            }
            
            [self.threeStatusBtn setImage:IMG(@"") forState:UIControlStateNormal];

        }
        
        
        
    }
//    else if ([model.mail_box_id isEqualToNumber:@4]) { //已删除
//        
//        if ([model.is_emergent isEqualToString:@"1"]) {
//            [self.rightStatusBtn setImage:IMG(@"邮件紧急") forState:UIControlStateNormal];
//        }
//        
//    }
    else if ([model.mail_box_id isEqualToNumber:@5]) { //垃圾箱
        
        if ([model.is_emergent isEqualToString:@"1"]) {
            [self.rightStatusBtn setImage:IMG(@"邮件紧急") forState:UIControlStateNormal];
        }
        
        if ([model.read_status isEqualToString:@"1"]) { //已读
            
            self.unReadLab.hidden = YES;
            
            self.unreadW.constant = 0;
            self.contactLabCons.constant = 0;
            
        }
        else {
            
            self.unreadW.constant = 10;
            self.contactLabCons.constant = 4;
            self.unReadLab.hidden = NO;
        }
    }
    else if ([model.mail_box_id isEqualToNumber:@6]) { //未读
        
        
        if ([model.read_status isEqualToString:@"1"]) { //已读
            
            self.unReadLab.hidden = YES;
            
            self.unreadW.constant = 0;
            self.contactLabCons.constant = 0;
            
        }
        else {
            
            self.unreadW.constant = 10;
            self.contactLabCons.constant = 4;
            self.unReadLab.hidden = NO;
        }

    }
    

    
    
    self.titleLab.text = model.subject;
    
    self.contentLab.text = model.contentSimple;
    
    self.timeLab.text = [HQHelper nsdateToTimeNowYear:[model.create_time longLongValue]];
    
    if ([model.select isEqualToNumber:@1]) {
        self.selectBtn.selected = YES;
    }else{
        self.selectBtn.selected = NO;
    }
    
}

+ (instancetype)TFEmailsListCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFEmailsListCell" owner:self options:nil] lastObject];
}



+ (instancetype)EmailsListCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFEmailsListCell";
    TFEmailsListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFEmailsListCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
