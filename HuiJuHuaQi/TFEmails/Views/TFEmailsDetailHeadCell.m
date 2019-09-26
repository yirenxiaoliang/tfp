//
//  TFEmailsDetailHeadCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailsDetailHeadCell.h"

@interface TFEmailsDetailHeadCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *senderLab;
@property (weak, nonatomic) IBOutlet UILabel *IPLab;
@property (weak, nonatomic) IBOutlet UILabel *receiverLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *hideBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *senderLabCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IPLabTopCons;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiverLabTopCons;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IPLabCons;
@property (weak, nonatomic) IBOutlet UIImageView *approveStatusImgV;
@property (weak, nonatomic) IBOutlet UILabel *coperLab;
@property (weak, nonatomic) IBOutlet UILabel *secretLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coperLabCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secretLabCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiverLabTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabTopCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coperHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secretHeight;


@end

@implementation TFEmailsDetailHeadCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    
    self.approveStatusImgV.hidden = YES;
//    self.userInteractionEnabled = NO;
//    self.hideBtn.userInteractionEnabled = YES;
    
    self.titleLab.numberOfLines = 0;
    [self.hideBtn addTarget:self action:@selector(hideAction) forControlEvents:UIControlEventTouchUpInside];
}


- (void)refreshEmailHeadViewWithModel:(TFEmailReceiveListModel *)model {

    if ([model.isHide isEqualToNumber:@1]) {
        
        self.IPLab.hidden = YES;
        self.receiverLab.hidden = YES;
        self.timeLab.hidden = YES;
        self.coperLab.hidden = YES;
        self.secretLab.hidden = YES;
        
        self.IPLabTopCons.constant = 0;
        self.receiverLabTopCons.constant = 0;
        self.timeLabTopCons.constant = 0;
        
        [self.hideBtn setTitle:@"详情" forState:UIControlStateNormal];
    }
    else {
    
        self.IPLab.hidden = NO;
        self.receiverLab.hidden = NO;
        self.timeLab.hidden = NO;
        self.coperLab.hidden = NO;
        self.secretLab.hidden = NO;
        
        self.IPLabTopCons.constant = 5;
        self.receiverLabTopCons.constant = 5;
        self.timeLabTopCons.constant = 5;
        [self.hideBtn setTitle:@"隐藏" forState:UIControlStateNormal];
    }
    
    //审批通过状态
    if ([model.approval_status isEqualToString:@"2"]) {
        
        self.approveStatusImgV.hidden = NO;
        
//        self.hideBtn.hidden = YES;
        
        self.approveStatusImgV.image = IMG(@"approvalPass");
    }else if ([model.approval_status isEqualToString:@"3"]){
        
        self.approveStatusImgV.hidden = NO;
        
        //        self.hideBtn.hidden = YES;
        
        self.approveStatusImgV.image = IMG(@"approvalReject");
    }
    
    self.titleLab.text = model.subject;
    
    self.senderLab.text = [NSString stringWithFormat:@"发件人:<%@>",model.from_recipient];
    
    if ([model.ip_address isEqualToString:@""] || model.ip_address == nil) {
        
        self.IPLab.hidden = YES;
        self.IPLabCons.constant = 0;
        
        [self.receiverLab mas_remakeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(@15);
            make.top.equalTo(self.senderLab.mas_bottom).offset(5);
//            make.height.lessThanOrEqualTo(@17);
        }];
    }
    else {
    
        self.IPLab.text = [NSString stringWithFormat:@"IP地址：%@",model.ip_address];
    }
    
    
//    NSString *receiver = @"";
    
    if (model.to_recipients.count>0) {
        
        for (TFEmailPersonModel *peroson in model.to_recipients) {
            
            if (!peroson.employee_name) {
                
                peroson.employee_name = @"";
            }
            
    
            
            self.receiverLab.text = [self.receiverLab.text stringByAppendingString:[NSString stringWithFormat:@"、%@<%@>",peroson.employee_name,peroson.mail_account]];
            
            NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:self.receiverLab.text];
            
            NSRange range = [self.receiverLab.text rangeOfString:peroson.employee_name];
            
            [mString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
            
            self.receiverLab.attributedText = mString;
            
            
            
//            self.receiverLab.text = [NSString stringWithFormat:@"收件人:%@",receiver];
            
        }
        
        self.receiverLab.text = [self.receiverLab.text substringFromIndex:1]; //截取掉下标1之前的
        
        self.receiverLab.text = [NSString stringWithFormat:@"收件人:%@",self.receiverLab.text ];
    }
    
    
    NSString *coper = @"";
    if (model.cc_recipients.count>0) {
        
        for (TFEmailPersonModel *peroson in model.cc_recipients) {
            
            if (!peroson.employee_name) {
                
                peroson.employee_name = @"";
            }
            coper = [coper stringByAppendingString:[NSString stringWithFormat:@"、%@<%@>",peroson.employee_name,peroson.mail_account]];
        }
        
        coper = [coper substringFromIndex:1]; //截取掉下标1之前的
        
        self.coperLab.text = [NSString stringWithFormat:@"抄送人:%@",coper];
    }
    else {
        
        self.coperLab.hidden = YES;
        self.coperLabCons.constant = 0;
        
        self.coperHeight.constant = 0;
        
    }
    
    NSString *secreter = @"";
    if (model.bcc_recipients.count>0) {
        
        
        for (TFEmailPersonModel *peroson in model.bcc_recipients) {
            
            if (!peroson.employee_name) {
                
                peroson.employee_name = @"";
            }
            
            secreter = [secreter stringByAppendingString:[NSString stringWithFormat:@"、%@<%@>",peroson.employee_name,peroson.mail_account]];
        }
        
        secreter = [secreter substringFromIndex:1]; //截取掉下标1之前的
        
        self.secretLab.text = [NSString stringWithFormat:@"密送人:%@",secreter];
    }
    else {
        
        self.secretLab.hidden = YES;
        self.secretLabCons.constant = 0;
        self.secretHeight.constant = 0;
        
    }


    NSString *timeStr = [HQHelper nsdateToTime:[model.create_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
     NSDateFormatter *format = [[NSDateFormatter alloc] init];
     
     // 设置日期格式 为了转换成功
     
     format.dateFormat = @"yyyy-MM-dd HH:mm";
    
     // NSString * -> NSDate *
     
     NSDate *data = [format dateFromString:timeStr];
                         
    self.timeLab.text = [NSString stringWithFormat:@"时   间:%@(%@)",[HQHelper nsdateToTime:[model.create_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"],[HQHelper getWeekday2WithDate:data]];
}


+ (instancetype)TFEmailsDetailHeadCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFEmailsDetailHeadCell" owner:self options:nil] lastObject];
}

- (void)hideAction {
    
    if ([self.delegate respondsToSelector:@selector(hideEmailDetailHeadInfo)]) {
        
        [self.delegate hideEmailDetailHeadInfo];
    }
}

+ (CGFloat)refreshEmailsDetailHeadHeightWithModel:(TFEmailReceiveListModel *)model {

    //主题
    CGSize size = [HQHelper sizeWithFont:FONT(16) maxSize:CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT) titleStr:model.subject];
    
    //收件人
    NSString *receivStr = @"";
    if (model.to_recipients.count>0) {
        
        for (TFEmailPersonModel *peroson in model.to_recipients) {
            
            if (!peroson.employee_name) {
                
                peroson.employee_name = @"";
            }
            receivStr = [receivStr stringByAppendingString:[NSString stringWithFormat:@"、%@<%@>",peroson.employee_name,peroson.mail_account]];
        }
        
        receivStr = [receivStr substringFromIndex:1]; //截取掉下标1之前的
        
        receivStr = [NSString stringWithFormat:@"收件人:%@",receivStr];
    }
    
    CGSize receiverSize = [HQHelper sizeWithFont:FONT(12) maxSize:CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT) titleStr:receivStr];
    
    
    
    NSString *coper = @"";
    if (model.cc_recipients.count>0) {
        
        for (TFEmailPersonModel *peroson in model.cc_recipients) {
            
            if (!peroson.employee_name) {
                
                peroson.employee_name = @"";
            }
            coper = [coper stringByAppendingString:[NSString stringWithFormat:@"、%@<%@>",peroson.employee_name,peroson.mail_account]];
        }
        
        coper = [coper substringFromIndex:1]; //截取掉下标1之前的
        
        coper = [NSString stringWithFormat:@"抄送人:%@",coper];
    }
    
    CGSize coperSize = [HQHelper sizeWithFont:FONT(12) maxSize:CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT) titleStr:coper];
    
    
    NSString *secreter = @"";
    if (model.bcc_recipients.count>0) {
        
        
        for (TFEmailPersonModel *peroson in model.bcc_recipients) {
            
            if (!peroson.employee_name) {
                
                peroson.employee_name = @"";
            }
            
            secreter = [secreter stringByAppendingString:[NSString stringWithFormat:@"、%@<%@>",peroson.employee_name,peroson.mail_account]];
        }
        
        secreter = [secreter substringFromIndex:1]; //截取掉下标1之前的
        
        secreter = [NSString stringWithFormat:@"密送人:%@",secreter];
    }

    CGSize secreterSize = [HQHelper sizeWithFont:FONT(12) maxSize:CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT) titleStr:secreter];
    
    
    if ([model.isHide isEqualToNumber:@1]) { //隐藏
        
        return size.height+54;
    }
    else {
        
//        CGFloat headH = size.height+164;
        CGFloat headH = size.height + receiverSize.height + 90;
        
        if (![model.ip_address isEqualToString:@""] && model.ip_address != nil) {
            
            headH = headH + 22;
        }
        
        if (model.cc_recipients.count != 0) {
            
            headH = headH + coperSize.height;
        }
        
        if (model.bcc_recipients.count != 0) {
            
            headH = headH +secreterSize.height;
        }
        
        return headH;
    }
    
}

+ (instancetype)emailsDetailHeadCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFEmailsDetailHeadCell";
    TFEmailsDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFEmailsDetailHeadCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
