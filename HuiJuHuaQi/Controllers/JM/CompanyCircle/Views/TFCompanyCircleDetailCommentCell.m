//
//  TFCompanyCircleDetailCommentCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCompanyCircleDetailCommentCell.h"
#import "WPTappableLabel.h"
#import "WPAttributedStyleAction.h"
#import "NSString+WPAttributedMarkup.h"
#import <SDWebImage/SDWebImage.h>

@interface TFCompanyCircleDetailCommentCell ()

/** 评论图标 */
@property (nonatomic, weak) IBOutlet UIImageView *imageComment;
/** 头像 */
@property (nonatomic, weak)IBOutlet UIButton *headBtn;
/** 名字 */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
/** 内容 */
@property (weak, nonatomic)IBOutlet WPTappableLabel *contentLabel;
/** 时间 */
@property (nonatomic, weak) IBOutlet
UILabel *timeLabel;

@property (nonatomic,strong)HQCommentItemModel*commentItemPeopleModel;

@end


@implementation TFCompanyCircleDetailCommentCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupChild];
    }
    return self;
}

- (void)setupChild{
    
    self.contentView.backgroundColor = ClearColor;
    self.backgroundColor = ClearColor;
    
    // 评论框图标
    UIImageView *imageComment = [[UIImageView alloc] initWithFrame:(CGRect){0,0,35,35}];
    [self.contentView addSubview:imageComment];
    imageComment.image = [UIImage imageNamed:@"评论Detail"];
    self.imageComment = imageComment;
    imageComment.contentMode = UIViewContentModeCenter;
    
    // 头像
    UIButton *headBtn = [HQHelper buttonWithFrame:CGRectZero target:self action:@selector(headClicked:)];
    [self.contentView addSubview:headBtn];
    self.headBtn = headBtn;
    headBtn.layer.cornerRadius = 2;
    headBtn.layer.masksToBounds = YES;
    
    // 名字
    UILabel *nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    nameLabel.textColor = GreenColor;
    nameLabel.font = FONT(16);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameClicked)];
    nameLabel.userInteractionEnabled = YES;
    [nameLabel addGestureRecognizer:tap];
    
    // 内容
    WPTappableLabel *contentLabel = [[WPTappableLabel alloc] init];
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    contentLabel.textColor = BlackTextColor;
    contentLabel.numberOfLines = 0;
    //    contentLabel.backgroundColor = RedColor;
    contentLabel.font = FONT(14);
    contentLabel.onTap = ^(CGPoint point){
        
        [self tapWithPoint:point];
        
    };

    // 时间
    UILabel *timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    timeLabel.textColor = ExtraLightBlackTextColor;
    timeLabel.font = FONT(12);
    timeLabel.textAlignment = NSTextAlignmentRight;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.contentView addGestureRecognizer:longPress];
}

- (void)longPress:(UILongPressGestureRecognizer *)greture{
    
    if ([self.delegate respondsToSelector:@selector(didLongPressToDelete:index:)]) {
        [self.delegate didLongPressToDelete:_commentItemPeopleModel index:self.tag - 0x123];
    }
    
}

-(void)tapWithPoint:(CGPoint)point{
    
    
    TFEmployeeCModel *receiverModel = [HQHelper employeeWithEmployeeID:self.commentItemPeopleModel.receiverId];
    
    NSString *beforeStr =  @"回复";
    NSString *receiverName = receiverModel.employee_name;
    
    receiverName = receiverModel.employee_name==nil?@"无名":receiverModel.employee_name;
    
    CGSize backSize = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:beforeStr];
    
    CGSize receiveSize = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:[NSString stringWithFormat:@" %@ ",receiverName]];
    
    CGRect rect = CGRectMake(backSize.width, 0, receiveSize.width, receiveSize.height);
    
    if (CGRectContainsPoint(rect, point)) {
        [self commentNameAction:self.commentItemPeopleModel.receiverId];
    }else{
        [self commentContentAction:self.commentItemPeopleModel];
    }
}


-(void)setHiddenMark:(BOOL)hiddenMark{
    _hiddenMark = hiddenMark;
    
    self.imageComment.hidden = hiddenMark;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageComment.frame = (CGRect){0,12,35,35};
    self.headBtn.frame = CGRectMake(CGRectGetMaxX(self.imageComment.frame), 12, 35, 35);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headBtn.frame) + 10, 12, SCREEN_WIDTH - 150, 18);
    self.timeLabel.frame = CGRectMake(self.width - 15 - 150, 12, 150, 20);
    
    TFEmployeeCModel *senderModel = [HQHelper employeeWithEmployeeID:self.commentItemPeopleModel.senderId];
    
    TFEmployeeCModel *receiverModel = [HQHelper employeeWithEmployeeID:@([self.commentItemPeopleModel.receiverId longLongValue])];
    
    NSString *dynamicName  = senderModel.employee_name;
    NSString *receiverName = receiverModel.employee_name;
    
    dynamicName  = senderModel.employee_name==nil?@"无名":senderModel.employee_name;
    receiverName = receiverModel.employee_name==nil?@"无名":receiverModel.employee_name;
    
    CGFloat maxWidth = SCREEN_WIDTH - 30 - 95;
    
    CGFloat cellHeight = 0 ;
    if (self.commentItemPeopleModel.receiverId) {
        
        NSString *nameAndContentStr = [NSString stringWithFormat:@"%@ %@ %@",@"回复",receiverName,self.commentItemPeopleModel.contentinfo];
        
        CGFloat contentHeight = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(maxWidth, MAXFLOAT) titleStr:nameAndContentStr].height;
        
        cellHeight = cellHeight + contentHeight;
        
        
    }else{
        
        NSString *nameAndContentStr  = [NSString stringWithFormat:@"%@",self.commentItemPeopleModel.contentinfo];
        
        CGFloat contentHeight = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(maxWidth, MAXFLOAT) titleStr:nameAndContentStr].height;
        
        cellHeight = cellHeight + contentHeight;
        
        
    }

    self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.headBtn.frame) + 10, CGRectGetMaxY(self.nameLabel.frame)+3, self.width-95, cellHeight);
//    self.nameLabel.backgroundColor = RedColor;
//    self.contentLabel.backgroundColor = GreenColor;
}


- (void)headClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(companyCircleDetailCommentCellWithPeopleImfo:)]) {
        
        TFEmployeeCModel *senderModel = [HQHelper employeeWithEmployeeID:_commentItemPeopleModel.senderId];
        
        [self.delegate companyCircleDetailCommentCellWithPeopleImfo:senderModel];
    }
    
}
- (void)nameClicked{
    
    
    if ([self.delegate respondsToSelector:@selector(companyCircleDetailCommentCellWithPeopleImfo:)]) {
        
        TFEmployeeCModel *senderModel = [HQHelper employeeWithEmployeeID:_commentItemPeopleModel.senderId];
        
        [self.delegate companyCircleDetailCommentCellWithPeopleImfo:senderModel];
    }
}

-(void)refreshCompanyCircleDetailCommentCellForCommentItemModel:(HQCommentItemModel*)commentItem{
    
    _commentItemPeopleModel = commentItem;
    
//    HQEmployCModel *senderModel = [HQHelper employeeWithEmployeeID:commentItem.senderId];
//    
//    HQEmployCModel *receiverModel = [HQHelper employeeWithEmployeeID:commentItem.receiverId];
    
    
    NSString *beforeStr =  @"回复";
    NSString *dynamicName  = commentItem.senderName;
    NSString *receiverName = commentItem.receiverName;
    NSString *contentStr = commentItem.contentinfo;
    
//    dynamicName  = senderModel.employeeName==nil?@"无名":senderModel.employeeName;
//    receiverName = receiverModel.employeeName==nil?@"无名":receiverModel.employeeName;
    
    // 头像
    //[self.headBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:commentItem.senderPhotograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
    
    // 名字
    self.nameLabel.text = dynamicName;
    
    // 时间
    self.timeLabel.text = [HQHelper nsdateToTime:[commentItem.createDate longLongValue] formatStr:@"yyyy-MM-dd"];
    
    // 回复内容
    NSDictionary* style = @{@"body": @[[UIFont fontWithName:@"HelveticaNeue" size:14.0],
                                       BlackTextColor],
                            @"dynamic": [WPAttributedStyleAction styledActionWithAction:^{
                                
                                HQLog(@"执行");
                                
                                [self orginaNameAction:commentItem.senderId];
                                
                            }],
                            @"receiver": [WPAttributedStyleAction styledActionWithAction:^{
                                
                                HQLog(@"执行");
                                
                                [self commentNameAction:commentItem.receiverId];
                                
                                
                                
                            }],
                            // 点击内容
                            @"content": [WPAttributedStyleAction styledActionWithAction:^{
                                
                                HQLog(@"执行");
                                
                                [self commentContentAction:_commentItemPeopleModel];
                                
                                
                                
                            } color:BlackTextColor font:FONT(14)],
                            
                            
                            @"link": @[GreenColor,FONT(14)]
                            
                            };
    
    
    if (commentItem.receiverId == nil) {
        
        
        NSString *attrbutedStr = [NSString stringWithFormat:@"<dynamic>%@</dynamic><body>%@</body><content>%@</content>", @"",@"",contentStr];
        
        self.contentLabel.attributedText = [attrbutedStr attributedStringWithStyleBook:style];
        
        
    }else{
        
        
        NSString *attrbutedStr = [NSString stringWithFormat:@"<dynamic>%@</dynamic><body>%@ </body><receiver>%@</receiver><body>%@ </body><content>%@</content>", @"", beforeStr,TEXT(receiverName),@"",contentStr];
        
        self.contentLabel.attributedText = [attrbutedStr attributedStringWithStyleBook:style];
        
        
    }
    
}



+(CGFloat)refreshCompanyCircleDetailCommentCellHeightWithModel:(HQCommentItemModel *)model{
    
    
    
    CGFloat cellHeight = 55 ;
    
    if (model.contentinfo.length != 0) {
        
        //    HQEmployCModel *senderModel = [HQHelper employeeWithEmployeeID:commentItem.senderId];
        //
        //    HQEmployCModel *receiverModel = [HQHelper employeeWithEmployeeID:commentItem.receiverId];
        
        
//        NSString *beforeStr =  @"回复";
//        NSString *dynamicName  = model.senderName;
        NSString *receiverName = model.receiverName;
//        NSString *contentStr = model.contentinfo;
        
        //    dynamicName  = senderModel.employeeName==nil?@"无名":senderModel.employeeName;
        //    receiverName = receiverModel.employeeName==nil?@"无名":receiverModel.employeeName;
        
        
        CGFloat maxWidth = SCREEN_WIDTH - 30 - 95;
        
        if (model.receiverId) {
            
            NSString *nameAndContentStr = [NSString stringWithFormat:@"%@ %@ %@",@"回复",receiverName,model.contentinfo];
            
            CGFloat contentHeight = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(maxWidth, MAXFLOAT) titleStr:nameAndContentStr].height;
            
            cellHeight = cellHeight + contentHeight;
            
//            HQLog(@"%@",model.contentinfo);
            
            
        }else{
            
//            HQLog(@"%@",model.contentinfo);
            NSString *nameAndContentStr  = [NSString stringWithFormat:@"%@",model.contentinfo];
            
            CGFloat contentHeight = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(maxWidth, MAXFLOAT) titleStr:nameAndContentStr].height;
            
            cellHeight = cellHeight + contentHeight;
            
//            HQLog(@"----------%f",contentHeight);
            
        }
        
    }
    
//    HQLog(@"%@",model.contentinfo);
    
    return cellHeight - 12;
    
}


#pragma mark - 点击了原始名字
- (void)orginaNameAction:(NSNumber *)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(companyCircleDetailCommentCellWithPeopleImfo:)]) {
        
        TFEmployeeCModel *senderModel = [HQHelper employeeWithEmployeeID:_commentItemPeopleModel.senderId];
        
        [self.delegate companyCircleDetailCommentCellWithPeopleImfo:senderModel];
    }
    
    
}


#pragma mark - 点击了新名字
- (void)commentNameAction:(NSNumber *)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(companyCircleDetailCommentCellWithPeopleImfo:)]) {
        
        TFEmployeeCModel *receiverModel = [HQHelper employeeWithEmployeeID:@([_commentItemPeopleModel.receiverId longLongValue])];
        [self.delegate companyCircleDetailCommentCellWithPeopleImfo:receiverModel];
        
        
    }
    
}

#pragma mark - 点击了评论内容
- (void)commentContentAction:(HQCommentItemModel *)commentItemModel{
    
    
    if ([self.delegate respondsToSelector:@selector(companyCircleDetailCommentCellDidClickContent:index:)]) {
        
        [self.delegate companyCircleDetailCommentCellDidClickContent:commentItemModel index:self.tag - 0x123];
        
        
    }
    
}



+(instancetype)companyCircleDetailCommentCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFCompanyCircleDetailCommentCell";
    TFCompanyCircleDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFCompanyCircleDetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = NO;
    cell.headMargin = 35;
    return cell;
}


//+ (instancetype)companyCircleDetailCommentCell
//{
//    return [[[NSBundle mainBundle] loadNibNamed:@"TFCompanyCircleDetailCommentCell" owner:self options:nil] lastObject];
//}
//
//
//
//+(instancetype)companyCircleDetailCommentCellWithTableView:(UITableView *)tableView
//{
//    static NSString *indentifier = @"TFCompanyCircleDetailCommentCell";
//    TFCompanyCircleDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
//    if (!cell) {
//        cell = [self companyCircleDetailCommentCell];
//    }
//    return cell;
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
