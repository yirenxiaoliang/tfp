//
//  JCHATChatTableViewCell.m
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATConversationListCell.h"
#import "JCHATStringUtils.h"
#import "JCHATSendMsgManager.h"
#import <CoreText/CoreText.h>
#import "Masonry.h"

@interface JCHATConversationListCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numW;
@property (weak, nonatomic) IBOutlet UIButton *bothorBtn;

@end

@implementation JCHATConversationListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.bothorBtn.hidden = YES;
    self.bothorBtn.userInteractionEnabled = NO;
    [self.bothorBtn setImage:IMG(@"noBother") forState:UIControlStateNormal];
    [self.bothorBtn setImage:IMG(@"noBother") forState:UIControlStateNormal];
    self.time.textColor = LightGrayTextColor;
    self.headView.contentMode = UIViewContentModeScaleAspectFill;
    self.headView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headView.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.headView.layer.cornerRadius = 25.0;
    self.headView.backgroundColor = [UIColor clearColor];

    [self.messageNumberLabel.layer setMasksToBounds:YES];
    self.messageNumberLabel.layer.cornerRadius = 18.0/2;
//    self.messageNumberLabel.layer.borderWidth = 1;
//    self.messageNumberLabel.layer.borderColor = GreenColor.CGColor;
    self.messageNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self.messageNumberLabel setBackgroundColor:HexAColor(0xfa3e32,1)];
    self.messageNumberLabel.textColor = [UIColor whiteColor];
    self.messageNumberLabel.font = FONT(13);
    self.topImage.hidden = YES;

    self.cellLine.backgroundColor = CellSeparatorColor;
    
    self.nickName.font = FONT(16);
    self.message.font = FONT(13);
    self.nickName.textColor = BlackTextColor;
    self.message.textColor = GrayTextColor;
    self.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  if (selected){
    self.messageNumberLabel.backgroundColor = HexAColor(0xfa3e32,1);
  }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
  
  [super setHighlighted:highlighted animated:animated];
  
  if (highlighted){
    self.messageNumberLabel.backgroundColor = HexAColor(0xfa3e32,1);
  }
}


- (NSString *)stringWithConversation:(JMSGConversation *)conversation{
    
    if (!conversation || conversation.title.length == 0) {
        return @"无名";
    }else if (conversation.title.length < 3){
        return conversation.title;
    }else if (conversation.title.length == 3){
        return [conversation.title substringFromIndex:1];
    }else if (conversation.title.length == 4){
        return [conversation.title substringFromIndex:2];
    }else{
        return [conversation.title substringToIndex:2];
    }
    
}


- (void)setDataWithConversation:(JMSGConversation *)conversation{
    
    [conversation avatarData:^(NSData *data, NSString *objectId, NSError *error) {
        if (![objectId isEqualToString:_conversationId]) {
            HQLog(@"out-of-order avatar");
            return ;
        }
        
        //    if (error == nil) {
        if (data != nil) {
            [self.headView setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
            [self.headView setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateHighlighted];
            [self.headView setTitle:@"" forState:UIControlStateHighlighted];
            [self.headView setTitle:@"" forState:UIControlStateNormal];
        } else {
            if (conversation.conversationType == kJMSGConversationTypeSingle) {
                [self.headView setBackgroundImage:[HQHelper createImageWithColor:GrayGroundColor] forState:UIControlStateNormal];
                [self.headView setBackgroundImage:[HQHelper createImageWithColor:GrayGroundColor] forState:UIControlStateHighlighted];
                [self.headView setTitle:[self stringWithConversation:conversation] forState:UIControlStateHighlighted];
                [self.headView setTitle:[self stringWithConversation:conversation] forState:UIControlStateNormal];
            } else {
                
                if (self.type == 1) {// 小秘书
                    
                    [self.headView setBackgroundImage:[UIImage imageNamed:@"小秘书50"] forState:UIControlStateNormal];
                    [self.headView setBackgroundImage:[UIImage imageNamed:@"小秘书50"] forState:UIControlStateHighlighted];
                }else if (self.type == 2) {// 公司总群
                    [self.headView setBackgroundImage:[UIImage imageNamed:@"群组45"] forState:UIControlStateNormal];
                    [self.headView setBackgroundImage:[UIImage imageNamed:@"群组45"] forState:UIControlStateHighlighted];
                }else{// 普通群或没群列表时
                    
                    if ([conversation.title isEqualToString:@"小秘书"]) {
                        
                        [self.headView setBackgroundImage:[UIImage imageNamed:@"小秘书50"] forState:UIControlStateNormal];
                        [self.headView setBackgroundImage:[UIImage imageNamed:@"小秘书50"] forState:UIControlStateHighlighted];
                    }else{
                        
                        [self.headView setBackgroundImage:[UIImage imageNamed:@"群组45"] forState:UIControlStateNormal];
                        [self.headView setBackgroundImage:[UIImage imageNamed:@"群组45"] forState:UIControlStateHighlighted];
                    }
                    
                }
                
                [self.headView setTitle:@"" forState:UIControlStateHighlighted];
                [self.headView setTitle:@"" forState:UIControlStateNormal];
            }
        }
        
    }];

    
}

//刷新助手
- (void)refreshChatCellWithDatas:(NSArray *)datas {
    
    [self.headView sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal placeholderImage:IMG(@"notice")];
    [self.headView setTitle:@"" forState:UIControlStateNormal];
    [self.headView setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
    [self.headView setBackgroundColor:ClearColor];
    
    self.headView.layer.cornerRadius = 25.0;
    self.headView.layer.masksToBounds = YES;
    self.nickName.text = @"消息通知";
    
    self.numH.constant = 18;
    self.bothorBtn.hidden = YES;
    self.messageNumberLabel.layer.cornerRadius = 9;
    
    NSInteger unreadMsgCount = 0;
    TFFMDBModel *model = nil;// 最新的一条数据
    
    for (TFFMDBModel *mm in datas) {
        unreadMsgCount += [mm.unreadMsgCount integerValue];
        // 此处拿到的是未读最新的一条
//        if (model == nil) {
//            if (mm.unreadMsgCount && [mm.unreadMsgCount integerValue] != 0) {
//                model = mm;
//            }
//        }
        // 此处拿到的为全体中的最新
        if ([mm.clientTimes longLongValue] > [model.clientTimes longLongValue]) {
            model = mm;
        }
    }
    if (model == nil) {
        model = datas.firstObject;
    }
    
    if (unreadMsgCount != 0) {
        
        self.messageNumberLabel.hidden = NO;
        if (unreadMsgCount > 99) {
            
            self.messageNumberLabel.text = @"99+";
        }
        else {
            self.messageNumberLabel.text = [NSString stringWithFormat:@"%ld",unreadMsgCount];
        }
        
        if (self.messageNumberLabel.text.length == 1){
            self.numW.constant = 18;
        }else if (self.messageNumberLabel.text.length == 2){
            self.numW.constant = 24;
        }else{
            self.numW.constant = 30;
        }
        
        [self.messageNumberLabel setBackgroundColor:HexAColor(0xfa3e32,1)];
    }
    else {
        
        self.messageNumberLabel.hidden = YES;
        self.messageNumberLabel.text = @"";
        [self.messageNumberLabel setBackgroundColor:HexAColor(0xffffff,1)];
    }
    
    
    if ([model.clientTimes isEqualToNumber:@0]) {
        
        model.clientTimes = @([HQHelper getNowTimeSp]);
    }
    self.time.text = [JCHATStringUtils getFriendlyDateString:[model.clientTimes longLongValue] forConversation:NO];
    
    NSString *text = [NSString stringWithFormat:@"%@",TEXT(model.content)];
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:text];
    
    self.message.attributedText = mString;
    
    self.backgroundColor= HexAColor(0xFFFFFF, 1);
    self.topImage.hidden = YES;
}

//刷新数据
- (void)refreshChatCellWithModel:(TFFMDBModel *)model {
    //chatType聊天类型 1群聊:2:单聊
    if ([model.chatType isEqualToNumber:@1]) {
        
        [self.headView sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.avatarUrl] forState:UIControlStateNormal placeholderImage:IMG(@"群组45")];
        [self.headView setTitle:@"" forState:UIControlStateNormal];
        [self.headView setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
    }
    else if ([model.chatType isEqualToNumber:@10]) {
    
        [self.headView sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.avatarUrl] forState:UIControlStateNormal placeholderImage:IMG(@"公司总群")];
        [self.headView setTitle:@"" forState:UIControlStateNormal];
        [self.headView setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
    }
    else if ([model.chatType isEqualToNumber:@2]) {
    
        if (![model.avatarUrl isEqualToString:@""]) {
            
            [self.headView sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.avatarUrl] forState:UIControlStateNormal placeholderImage:[HQHelper createImageWithColor:ClearColor] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!image) {
                    [self.headView setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                    [self.headView setTitle:[HQHelper nameWithTotalName:model.receiverName] forState:UIControlStateNormal];
                    [self.headView setTitleColor:WhiteColor forState:UIControlStateNormal];
                    [self.headView setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
                }else{
                    [self.headView setTitle:@"" forState:UIControlStateNormal];
                    [self.headView setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
                }
            }];
        }
        else {
            
            [self.headView setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            [self.headView setTitle:[HQHelper nameWithTotalName:model.receiverName] forState:UIControlStateNormal];
            [self.headView setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.headView setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
        }

    }
    else {
    
        if ([model.type isEqualToString:@"1"]) { //应用小助手

            if ([model.icon_type isEqualToString:@"0"]) {
                
                [self.headView setImage:IMG(model.icon_url) forState:UIControlStateNormal];
                [self.headView setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model.icon_color]?:GreenColor] forState:UIControlStateNormal];
                [self.headView setBackgroundColor:[HQHelper colorWithHexString:model.icon_color]?:GreenColor];
                [self.headView setTitle:@"" forState:UIControlStateNormal];
            }
            else if ([model.icon_type isEqualToString:@"1"]) {
                
                [self.headView sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.icon_url] forState:UIControlStateNormal placeholderImage:IMG(@"任务50")];
                [self.headView setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
                [self.headView setTitle:@"" forState:UIControlStateNormal];
                [self.headView setBackgroundColor:GreenColor];
            }
        }
        else if ([model.type isEqualToString:@"2"]) { //企信小助手
        
            [self.headView sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.avatarUrl] forState:UIControlStateNormal placeholderImage:IMG(@"企信-企信小助手")];
            [self.headView setTitle:@"" forState:UIControlStateNormal];
            [self.headView setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
            [self.headView setBackgroundColor:ClearColor];
        }
        else if ([model.type isEqualToString:@"3"]) { //审批小助手
            
            [self.headView sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.avatarUrl] forState:UIControlStateNormal placeholderImage:IMG(@"企信-审批小助手")];
            [self.headView setTitle:@"" forState:UIControlStateNormal];
            [self.headView setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
            [self.headView setBackgroundColor:ClearColor];
        }
        else if ([model.type isEqualToString:@"4"]) { //文件库小助手
            
            [self.headView sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.avatarUrl] forState:UIControlStateNormal placeholderImage:IMG(@"企信-文件库小助手")];
            [self.headView setTitle:@"" forState:UIControlStateNormal];
            [self.headView setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
            [self.headView setBackgroundColor:ClearColor];
        }
        else if ([model.type isEqualToString:@"5"]) { //备忘录小助手
            
            [self.headView sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.avatarUrl] forState:UIControlStateNormal placeholderImage:IMG(@"企信-备忘录小助手")];
            [self.headView setTitle:@"" forState:UIControlStateNormal];
            [self.headView setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
            [self.headView setBackgroundColor:ClearColor];
        }
        else if ([model.type isEqualToString:@"6"]) { //邮件小助手
            
            [self.headView sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.avatarUrl] forState:UIControlStateNormal placeholderImage:IMG(@"企信-邮件小助手")];
            [self.headView setTitle:@"" forState:UIControlStateNormal];
            [self.headView setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
            [self.headView setBackgroundColor:ClearColor];
        }
        else if ([model.type isEqualToString:@"7"]) {
            
            [self.headView sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.avatarUrl] forState:UIControlStateNormal placeholderImage:IMG(@"企信-任务小助手")];
            [self.headView setTitle:@"" forState:UIControlStateNormal];
            [self.headView setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
            [self.headView setBackgroundColor:ClearColor];
            
        }
        else if ([model.type isEqualToString:@"8"]) {// 知识库小助手
            
            [self.headView sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.avatarUrl] forState:UIControlStateNormal placeholderImage:IMG(@"知识库")];
            [self.headView setTitle:@"" forState:UIControlStateNormal];
            [self.headView setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
            [self.headView setBackgroundColor:ClearColor];
            
        }
        else if ([model.type isEqualToString:@"9"]) {// 考勤小助手
            
            [self.headView sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.avatarUrl] forState:UIControlStateNormal placeholderImage:IMG(@"考勤")];
            [self.headView setTitle:@"" forState:UIControlStateNormal];
            [self.headView setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
            [self.headView setBackgroundColor:ClearColor];
            
        }
        else{
            [self.headView setBackgroundImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
            [self.headView setTitle:@"" forState:UIControlStateNormal];
            [self.headView setImage:[HQHelper createImageWithColor:ClearColor]     forState:UIControlStateNormal];
            [self.headView setBackgroundColor:ClearColor];
        }
        
    }
    
    self.headView.layer.cornerRadius = 25.0;
    self.headView.layer.masksToBounds = YES;
    
    self.nickName.text = model.receiverName;
    
    if ([model.noBother isEqualToNumber:@1]) {// 免打扰
        self.bothorBtn.hidden = NO;
        
        if (![model.unreadMsgCount isEqualToNumber:@0]) {
            self.numW.constant = 8;
            self.messageNumberLabel.hidden = NO;
        }else{
            self.numW.constant = 0;
            self.messageNumberLabel.hidden = YES;
        }
        self.messageNumberLabel.text = @"";
        self.numH.constant = 8;
        self.messageNumberLabel.layer.cornerRadius = 4;
        [self.messageNumberLabel setBackgroundColor:HexAColor(0xfa3e32,1)];
    }else{
        
        self.numH.constant = 18;
        self.bothorBtn.hidden = YES;
        self.messageNumberLabel.layer.cornerRadius = 9;
        if (![model.unreadMsgCount isEqualToNumber:@0]) {
            
            
            self.messageNumberLabel.hidden = NO;
            if ([model.unreadMsgCount integerValue] > 99) {
                
                self.messageNumberLabel.text = @"99+";
            }
            else {
                self.messageNumberLabel.text = [NSString stringWithFormat:@"%@",model.unreadMsgCount];
            }
            
            if (self.messageNumberLabel.text.length == 1){
                self.numW.constant = 18;
            }else if (self.messageNumberLabel.text.length == 2){
                self.numW.constant = 24;
            }else{
                self.numW.constant = 30;
            }
            
            [self.messageNumberLabel setBackgroundColor:HexAColor(0xfa3e32,1)];
        }
        else {
            
            self.messageNumberLabel.hidden = YES;
            self.messageNumberLabel.text = @"";
            [self.messageNumberLabel setBackgroundColor:HexAColor(0xffffff,1)];
        }
    }
    
    
    if ([model.clientTimes isEqualToNumber:@0]) {
        
        model.clientTimes = @([HQHelper getNowTimeSp]);
    }
    self.time.text = [JCHATStringUtils getFriendlyDateString:[model.clientTimes longLongValue] forConversation:NO];
    
    if ([model.chatFileType isEqualToNumber:@2]) {
        
        NSString *text = @"[图片]";
        NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:text];
        
        self.message.attributedText = mString;
    }
    else if ([model.chatFileType isEqualToNumber:@3]) {
        
        NSString *text = @"[语音]";
        NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:text];
        
        self.message.attributedText = mString;
    }
    else if ([model.chatFileType isEqualToNumber:@4]) {
        
        NSString *text = @"[文件]";
        NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:text];
        
        self.message.attributedText = mString;
    }
    else if ([model.chatFileType isEqualToNumber:@5]) {
        
        NSString *text = @"[视频]";
        NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:text];
        
        self.message.attributedText = mString;
    }
    else {
        
        if (![model.draft isEqualToString:@""] && model.draft != nil ) {
            
            
           NSString *text = [NSString stringWithFormat:@"[草稿]%@",TEXT(model.draft)];
            
            NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:text];
            
            NSRange range = [text rangeOfString:@"[草稿]"];
            
            [mString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
            
            self.message.attributedText = mString;
            
        }
        else {
            
            NSString *text = [NSString stringWithFormat:@"%@",TEXT(model.content)];
            NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:text];
            
            self.message.attributedText = mString;
        }
        
    }
    
    /** 有人@我、@所有人 */
    NSMutableArray *chatRecords = [DataBaseHandle queryRecodeWithChatId:model.chatId];
    
    for (TFFMDBModel *fm in chatRecords) {
        
        if ([fm.chatType isEqualToNumber:@1] || [fm.chatType isEqualToNumber:@10]) {
            
            NSArray *arr = [NSArray array];
            arr = [fm.atIds componentsSeparatedByString:@","];
            if (arr.count > 0) { //有@
                
                if (![fm.isRead isEqualToNumber:@1]) {
                    
//                    NSString *string = arr[0];
                    for (NSString *string in arr) {
                        
                        if ([UM.userLoginInfo.employee.sign_id isEqualToNumber:@([string integerValue])]) {
                            
                            NSString *text = [NSString stringWithFormat:@"[有人@我]%@",TEXT(model.content)];
                            NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:text];
                            
                            NSRange range = [text rangeOfString:@"[有人@我]"];
                            
                            [mString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
                            
                            self.message.attributedText = mString;
                        }
                        else if ([string isEqualToString:@"0"]) {
                            
                            NSString *text = [NSString stringWithFormat:@"[@所有人]%@",TEXT(model.content)];
                            NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:text];
                            
                            NSRange range = [text rangeOfString:@"[@所有人]"];
                            
                            [mString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
                            
                            self.message.attributedText = mString;
                        }else{
                            
                            NSString *text = [NSString stringWithFormat:@"%@",TEXT(model.content)];
                            NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:text];
                            
                            self.message.attributedText = mString;
                        }
                    }
                    
                    
                }
            }
//            else{
//
//                NSString *text = [NSString stringWithFormat:@"%@",TEXT(model.content)];
//                NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:text];
//
//                self.message.attributedText = mString;
//            }
            
        }
//        else{
//
//            NSString *text = [NSString stringWithFormat:@"%@",TEXT(model.content)];
//            NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:text];
//
//            self.message.attributedText = mString;
//        }

    }
    
    if ([model.isTop isEqualToNumber:@1]) {
        
//        self.backgroundColor = HexAColor(0x20779A, 0.1);
        self.backgroundColor= HexAColor(0xFFFFFF, 1);
        self.topImage.hidden = NO;
    }
    else {
    
        self.backgroundColor= HexAColor(0xFFFFFF, 1);
        self.topImage.hidden = YES;
    }

}

- (void)setCellDataWithConversation:(JMSGConversation *)conversation {
  
  self.nickName.text = conversation.title;
  self.conversationId = [self conversationIdWithConversation:conversation];
    
//    NSMutableArray *images = [NSMutableArray array];
    
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        
        JMSGUser *user = conversation.target;
        
        if ([user.avatar containsString:@"qiniu/image/"]) {
            
            [self setDataWithConversation:conversation];
            
        }else{
            
            [self.headView setBackgroundImage:[HQHelper createImageWithColor:GrayGroundColor] forState:UIControlStateNormal];
            [self.headView setBackgroundImage:[HQHelper createImageWithColor:GrayGroundColor] forState:UIControlStateHighlighted];
            [self.headView setTitle:[self stringWithConversation:conversation] forState:UIControlStateHighlighted];
            [self.headView setTitle:[self stringWithConversation:conversation] forState:UIControlStateNormal];
        }
        
    }else{
        [self setDataWithConversation:conversation];
    }
    
    
  if ([conversation.unreadCount integerValue] > 0) {
    [self.messageNumberLabel setHidden:NO];
    self.messageNumberLabel.text = [NSString stringWithFormat:@"%@", conversation.unreadCount];
  } else {
    [self.messageNumberLabel setHidden:YES];
  }
  
  if (conversation.latestMessage.timestamp != nil ) {
    double time = [conversation.latestMessage.timestamp doubleValue];
    self.time.text = [JCHATStringUtils getFriendlyDateString:time forConversation:YES];
  } else {
    self.time.text = @"";
  }
  
  if ([[[JCHATSendMsgManager ins] draftStringWithConversation:conversation] isEqualToString:@""]) {
    self.message.text = conversation.latestMessageContentText;
  } else {

    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[草稿] %@",[[JCHATSendMsgManager ins] draftStringWithConversation:conversation]]];
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor redColor]
                        range:NSMakeRange(0, 4)];

    self.message.attributedText = attriString;
  }
}

- (NSString *)conversationIdWithConversation:(JMSGConversation *)conversation {
  NSString *conversationId = nil;
  if (conversation.conversationType == kJMSGConversationTypeSingle) {
    JMSGUser *user = conversation.target;
    conversationId = [NSString stringWithFormat:@"%@_%ld_%@",user.username, kJMSGConversationTypeSingle, conversation.targetAppKey];
  } else {
    JMSGGroup *group = conversation.target;
    conversationId = [NSString stringWithFormat:@"%@_%ld",group.gid,kJMSGConversationTypeGroup];
  }
  return conversationId;
}


@end
