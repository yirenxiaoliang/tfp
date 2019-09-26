//
//  TFConversationListCell.m
//  HuiJuHuaQi
//
//  Created by Mac mimi on 2019/7/31.
//  Copyright © 2019 com.huijuhuaqi.com. All rights reserved.
//

#import "TFConversationListCell.h"

@interface TFConversationListCell ()

//@property (weak, nonatomic)  NSLayoutConstraint *numH;
//@property (weak, nonatomic)  NSLayoutConstraint *numW;
@property (weak, nonatomic)  UIButton *bothorBtn;

@end

@implementation TFConversationListCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.bgView.backgroundColor = WhiteColor;
        self.backgroundColor = WhiteColor;
        
        UIButton *headView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:headView];
        self.headView = headView;
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(50);
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
        }];
        
        UILabel *time = [[UILabel alloc] init];
        [self.bgView addSubview:time];
        self.time = time;
        [time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(headView.mas_top).offset(5);
            make.width.mas_equalTo(125);
        }];
        
        UILabel *nickName = [[UILabel alloc] init];
        [self.bgView addSubview:nickName];
        self.nickName = nickName;
        [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headView.mas_right).offset(15);
            make.top.mas_equalTo(time.mas_top);
            make.right.mas_equalTo(time.mas_left).offset(15);
        }];
        
        UILabel *message= [[UILabel alloc] init];
        [self.bgView addSubview:message];
        self.message = message;
        [message mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headView.mas_right).offset(15);
            make.top.mas_equalTo(nickName.mas_bottom).offset(5);
            make.right.mas_equalTo(self.bgView.mas_right).offset(-60);
        }];
        
        
        UILabel *messageNumberLabel = [[UILabel alloc] init];
        [self.bgView addSubview:messageNumberLabel];
        self.messageNumberLabel = messageNumberLabel;
        [messageNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bgView.mas_right).offset(-15);
            make.width.height.mas_equalTo(18);
            make.centerY.mas_equalTo(message.mas_centerY);
        }];
        
        UIView *cellLine = [[UIView alloc] init];
        [self.bgView addSubview:cellLine];
        self.cellLine = cellLine;
        [cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bgView.mas_right);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(self.bgView.mas_bottom);
            make.left.mas_equalTo(nickName.mas_left);
        }];
        
        UIImageView *topImage = [[UIImageView alloc] initWithImage:IMG(@"置顶")];
        topImage.contentMode = UIViewContentModeScaleToFill;
        [self.bgView addSubview:topImage];
        self.topImage = topImage;
        [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bgView.mas_right).offset(-5);
            make.width.height.mas_equalTo(7);
            make.top.mas_equalTo(self.bgView.mas_top).offset(5);
        }];
        
        
        UIButton *bothorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:bothorBtn];
        self.bothorBtn = bothorBtn;
        [bothorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(messageNumberLabel.mas_left);
            make.width.height.mas_equalTo(15);
            make.centerY.mas_equalTo(message.mas_centerY);
        }];
        
        [self settingProperty];
    }
    return self;
}


+ (instancetype)conversationListCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFConversationListCell";
    TFConversationListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/** 设置属性 */
- (void)settingProperty{
    
    self.bothorBtn.hidden = YES;
    self.bothorBtn.userInteractionEnabled = NO;
    [self.bothorBtn setImage:IMG(@"noBother") forState:UIControlStateNormal];
    [self.bothorBtn setImage:IMG(@"noBother") forState:UIControlStateNormal];
    self.time.textColor = LightGrayTextColor;
    self.time.font = FONT(12);
    self.time.textAlignment = NSTextAlignmentRight;
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

//刷新数据
- (void)refreshChatCellWithModel:(TFFMDBModel *)model {
    
    if ([model.unreadMsgCount integerValue] > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i < 2; i ++) {
            TFSliderItem *item = [[TFSliderItem alloc] init];
            if (1 == i) {
                
                item.bgColor = kUIColorFromRGB(0xFE3B31);
                item.name = @"删除";
                item.confirm = 1;
            }else {
                
                item.bgColor = kUIColorFromRGB(0xC7C7CB);
                item.name = @"标为已读";
                item.confirm = 0;
            }
            [arr addObject:item];
        }
        
        [self refreshSliderCellItemsWithItems:arr];
        
    }else{
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i < 1; i ++) {
            TFSliderItem *item = [[TFSliderItem alloc] init];
            item.bgColor = kUIColorFromRGB(0xFE3B31);
            item.name = @"删除";
            item.confirm = 1;
            
            [arr addObject:item];
        }
        
        [self refreshSliderCellItemsWithItems:arr];
        
    }
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
//            self.numW.constant = 8;
            self.messageNumberLabel.hidden = NO;
            [self.messageNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(8);
            }];
            
        }else{
//            self.numW.constant = 0;
            self.messageNumberLabel.hidden = YES;
            [self.messageNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
        }
        self.messageNumberLabel.text = @"";
//        self.numH.constant = 8;
        self.messageNumberLabel.layer.cornerRadius = 4;
        [self.messageNumberLabel setBackgroundColor:HexAColor(0xfa3e32,1)];
        [self.messageNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(8);
        }];
    }else{
        
        [self.messageNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(18);
        }];
//        self.numH.constant = 18;
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
//                self.numW.constant = 18;
                
                [self.messageNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(18);
                }];
            }else if (self.messageNumberLabel.text.length == 2){
//                self.numW.constant = 24;
                
                [self.messageNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(24);
                }];
            }else{
//                self.numW.constant = 30;
                
                [self.messageNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(30);
                }];
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
            
        }
        
        
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
