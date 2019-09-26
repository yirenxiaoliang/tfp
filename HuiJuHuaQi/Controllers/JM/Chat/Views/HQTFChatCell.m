//
//  HQTFChatCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/16.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFChatCell.h"

@interface HQTFChatCell ()

@end

@implementation HQTFChatCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.titleName.textColor = BlackTextColor;
    self.titleNum.textColor = LightGrayTextColor;
    self.redImage.layer.cornerRadius = 5;
    self.redImage.layer.masksToBounds = YES;
    self.redImage.backgroundColor = RedColor;
    self.titleNum.font = FONT(14);
    self.titleName.font = FONT(18);
    
    [self.jumpBtn setImage:[UIImage imageNamed:@"相机"] forState:UIControlStateNormal];
    [self.jumpBtn setImage:[UIImage imageNamed:@"相机"] forState:UIControlStateHighlighted];
    self.topLine.hidden = YES;
    self.headMargin = 15;
    [self.jumpBtn addTarget:self action:@selector(cameraClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


/** 110:任务助手，111:日程助手，112:随手记助手，113:文件库助手，114:审批助手，115:公告助手，116:投诉建议助手，117:工作汇报助手 */
- (void)refreshChatCellWithModel:(TFAssistantTypeModel *)model{
    
    self.assistant = model;
    if ([model.assistId isEqualToNumber:@110]) {
        [self.titleImage setImage:[UIImage imageNamed:@"任务50"]];
        self.titleName.text = @"任务助手";
    }else if ([model.assistId isEqualToNumber:@111]) {
        [self.titleImage setImage:[UIImage imageNamed:@"日程50"]];
        self.titleName.text = @"日程助手";
        
    }else if ([model.assistId isEqualToNumber:@112]) {
        [self.titleImage setImage:[UIImage imageNamed:@"随手记50"]];
        self.titleName.text = @"随手记助手";
        
    }else if ([model.assistId isEqualToNumber:@113]) {
        [self.titleImage setImage:[UIImage imageNamed:@"文件库50"]];
        self.titleName.text = @"文件库助手";
        
    }else if ([model.assistId isEqualToNumber:@114]) {
        [self.titleImage setImage:[UIImage imageNamed:@"审批50"]];
        self.titleName.text = @"审批助手";
        
    }else if ([model.assistId isEqualToNumber:@115]) {
        [self.titleImage setImage:[UIImage imageNamed:@"公告50"]];
        self.titleName.text = @"公告助手";
        
    }else if ([model.assistId isEqualToNumber:@116]) {
        [self.titleImage setImage:[UIImage imageNamed:@"投诉建议50"]];
        self.titleName.text = @"投诉建议助手";
        
    }else if ([model.assistId isEqualToNumber:@117]) {
        [self.titleImage setImage:[UIImage imageNamed:@"工作汇报50"]];
        self.titleName.text = @"工作汇报助手";
    }
    
    if (model.unreadCount && ![model.unreadCount isEqualToNumber:@0]) {
        
        self.redImage.hidden = NO;
    }else{
        
        self.redImage.hidden = YES;
    }
    
    self.titleNum.hidden = YES;
    self.jumpBtn.hidden = YES;
    
    
}

- (void)setImgHW:(CGFloat)imgHW {

    _imgHW = imgHW;
    
    self.imgHeight.constant = imgHW;
}

- (void)cameraClicked{
    
    if ([self.delegate respondsToSelector:@selector(chatCellDidClickedCameraWithType:)]) {
        [self.delegate chatCellDidClickedCameraWithType:self.chatCellType];
    }
}

+ (instancetype)chatCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFChatCell" owner:self options:nil] lastObject];
}



+ (HQTFChatCell *)chatCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFChatCell";
    HQTFChatCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self chatCell];
    }
    return cell;
}

-(void)setChatCellType:(ChatCellType)chatCellType{
    _chatCellType = chatCellType;
    
    switch (chatCellType) {
        case ChatCellTypeCricle:
        {
            self.titleImage.image = [UIImage imageNamed:@"企业圈底色"];
            self.jumpBtn.hidden = NO;
            self.titleNum.hidden = YES;
            self.redImage.hidden = YES;
            self.titleName.text = @"同事圈";
        }
            break;
            
        case ChatCellTypeContacts:
        {
            self.titleImage.image = [UIImage imageNamed:@"通讯录chat"];
            self.jumpBtn.hidden = YES;
            self.titleNum.hidden = YES;
            self.redImage.hidden = YES;
            self.titleName.text = @"通讯录";
        }
            break;
        default:
            break;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
