//
//  HQCommentTableViewCell.m
//  HuiJuHuaQi
//
//  Created by hq001 on 16/4/23.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQCommentTableViewCell.h"
#import "HQUserManager.h"
#import "WPHotspotLabel.h"
#import "WPAttributedStyleAction.h"
#import "NSString+WPAttributedMarkup.h"

@interface HQCommentTableViewCell()
//@property (weak, nonatomic) IBOutlet UIButton *orginaBtn;
//@property (weak, nonatomic) IBOutlet UILabel *recviewLabel;
//@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet WPTappableLabel *oneCommentLabel;
//@property (weak, nonatomic) IBOutlet UITextView *recviewTextView;
@property (nonatomic,strong)HQCommentItemModel*commentItemPeopleModel;
//@property (nonatomic, strong) WPHotspotLabel *contentLabel;


@end
@implementation HQCommentTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
//    self.oneCommentLabel.backgroundColor = RedColor;
//    _oneCommentLabel.hidden = YES;
//    _oneCommentLabel.numberOfLines = 0;
//    [_orginaBtn setTitleColor:HexColor(0x4d628f, 1) forState:0];
//    [_commentBtn setTitleColor:HexColor(0x4d628f, 1) forState:0];
//    self.recviewTextView.showsVerticalScrollIndicator = NO;
//    self.recviewTextView.scrollEnabled = NO;
//    self.recviewTextView.editable = NO;
//    
//    self.recviewTextView.contentSize = self.recviewTextView.size;
//    self.recviewTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.contentView addGestureRecognizer:longPress];
}

- (void)longPress:(UILongPressGestureRecognizer *)greture{
    
    if ([self.delegate respondsToSelector:@selector(didLongPressToDelete:index:)]) {
        [self.delegate didLongPressToDelete:_commentItemPeopleModel index:self.tag - 0x123];
    }
    
}


+ (instancetype)commentTableViewCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQCommentTableViewCell" owner:self options:nil] lastObject];
}



+ (HQCommentTableViewCell *)commentTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQCommentTableViewCell";
    HQCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self commentTableViewCell];
    }
    return cell;
}

-(void)refreshCellForCommentItemModel:(HQCommentItemModel*)commentItem{
    
    [self CellForCommentItemModel:commentItem];
}

+(CGFloat)refreshCellHeightwithCommentItemModel:(HQCommentItemModel *)commentItem{
    
    return [self commentTableView:nil heightForRowAtIndexPath:nil withTheObject:commentItem];
}


-(void)CellForCommentItemModel:(HQCommentItemModel*)commentItem{
    
    
//    HQLog(@"commentItem++++++%@",commentItem.contentinfo);
    
    _commentItemPeopleModel = commentItem;
    

//    HQEmployCModel *senderModel = [HQHelper employeeWithEmployeeID:commentItem.senderId];
//    
//    HQEmployCModel *receiverModel = [HQHelper employeeWithEmployeeID:commentItem.receiverId];
    
    
    NSString *beforeStr =  @"回复";
    NSString *dynamicName  = commentItem.senderName;
    NSString *receiverName = commentItem.receiverName;
    NSString *contentStr = commentItem.contentinfo;
    
    
    dynamicName  = commentItem.senderName==nil?@"":commentItem.senderName;
    receiverName = commentItem.receiverName==nil?@"":commentItem.receiverName;
    
    NSDictionary* style = @{@"body": @[[UIFont fontWithName:@"HelveticaNeue" size:14.0],
                                       BlackTextColor],
                            @"dynamic": [WPAttributedStyleAction styledActionWithAction:^{
                                
                                HQLog(@"执行");
                                
                                [self orginaNameAction:commentItem];
                                
                            }],
                            @"receiver": [WPAttributedStyleAction styledActionWithAction:^{
                                
                                HQLog(@"执行");
                                
                                [self commentNameAction:commentItem];
                                
                                
                                
                            }],
                            // 点击内容
                            @"content": [WPAttributedStyleAction styledActionWithAction:^{
                                
                                HQLog(@"执行");
                                
                                [self commentContentAction:_commentItemPeopleModel];
                                
                                
                                
                            } color:BlackTextColor font:FONT(14)],
                            
                            
                            @"link": @[GreenColor,BFONT(14)]
                            
                            };
    
    
    if (commentItem.receiverId == nil || [commentItem.receiverId isEqualToString:@""]) {
        
        
    NSString *attrbutedStr = [NSString stringWithFormat:@"<dynamic>%@</dynamic><body>%@</body><content>%@</content>", TEXT(dynamicName),@"：",TEXT(contentStr)];
        
        self.oneCommentLabel.attributedText = [attrbutedStr attributedStringWithStyleBook:style];
        
        
    }else{
        
        
        NSString *attrbutedStr = [NSString stringWithFormat:@"<dynamic>%@ </dynamic><body>%@ </body><receiver>%@</receiver><body>%@</body><content>%@</content>", TEXT(dynamicName), beforeStr,TEXT(receiverName),@"：",TEXT(contentStr)];
        
        self.oneCommentLabel.attributedText = [attrbutedStr attributedStringWithStyleBook:style];
        
    
    }
    
//    NSString *nameAndContentStr = nil;
//    
//    
//    if (commentItem.receiverId) {
//        
////        nameAndContentStr = [NSString stringWithFormat:@"%@%@%@:%@",[HQHelper employeeWithEmployeeID:commentItem.senderId].employeeName,@"回复",[HQHelper employeeWithEmployeeID:commentItem.receiverId].employeeName,commentItem.contentinfo];
//        
//        nameAndContentStr = [NSString stringWithFormat:@"%@ %@ %@：%@",dynamicName,@"回复",receiverName,commentItem.contentinfo];
//        
//    }else{
//        
////        nameAndContentStr = [NSString stringWithFormat:@"%@:%@",commentItem.senderId,commentItem.contentinfo];
//        
//        nameAndContentStr = [NSString stringWithFormat:@"%@：%@",dynamicName,commentItem.contentinfo];
//        
//    }
//    
}



+(CGFloat)commentTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withTheObject:(HQCommentItemModel *)model{
    
    
    
    CGFloat cellHeight = 0 ;
    
//    if (model.contentinfo.length != 0) {
    
        TFEmployeeCModel *senderModel = [HQHelper employeeWithEmployeeID:model.senderId];
        
        TFEmployeeCModel *receiverModel = [HQHelper employeeWithEmployeeID:@([model.receiverId longLongValue])];
        
        
        NSString *dynamicName  = senderModel.employee_name;
        NSString *receiverName = receiverModel.employee_name;
        
        dynamicName  = senderModel.employee_name==nil?@"":senderModel.employee_name;
        receiverName = receiverModel.employee_name==nil?@"":receiverModel.employee_name;
        
        if (model.receiverId) {
            
            NSString *nameAndContentStr = [NSString stringWithFormat:@"%@ %@ %@：%@",dynamicName,@"回复",receiverName,TEXT(model.contentinfo)];
            
             CGFloat contentHeight = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(SCREEN_WIDTH-CompanyCircleGoodWidth, MAXFLOAT) titleStr:nameAndContentStr].height;
            
            cellHeight = cellHeight + contentHeight;
            
//            HQLog(@"%@",model.contentinfo);
            
            
        }else{
            
//            HQLog(@"%@",model.contentinfo);
            NSString *nameAndContentStr  = [NSString stringWithFormat:@"%@：%@",dynamicName,TEXT(model.contentinfo)];
            
             CGFloat contentHeight = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(SCREEN_WIDTH-CompanyCircleGoodWidth, MAXFLOAT) titleStr:nameAndContentStr].height;
            
            cellHeight = cellHeight + contentHeight;
            
//            HQLog(@"----------%f",contentHeight);
            
        }
        
//    }
    
//    HQLog(@"%@",model.contentinfo);

    return cellHeight + 6;
    
}


#pragma mark - 点击了原始名字
- (void)orginaNameAction:(HQCommentItemModel *)sender {
    
    HQLog(@"点击了发送人名字");
    
    if ([self.delegate respondsToSelector:@selector(pushPeopleImfo:)]) {
        HQEmployModel *model  = [[HQEmployModel alloc] init];
        model.id = sender.senderId;
        model.employeeId = sender.senderId;
        
        [self.delegate pushPeopleImfo:model];
    }
   
    
}


#pragma mark - 点击了新名字
- (void)commentNameAction:(HQCommentItemModel *)sender {
    
    HQLog(@"点击了新名字");
    
    if ([self.delegate respondsToSelector:@selector(pushPeopleImfo:)]) {
        
        HQEmployModel *model  = [[HQEmployModel alloc] init];
        model.id = @([sender.receiverId longLongValue]);
        model.employeeId = @([sender.receiverId longLongValue]);
        
        [self.delegate pushPeopleImfo:model];
        
        
    }
    
}

#pragma mark - 点击了评论内容
- (void)commentContentAction:(HQCommentItemModel *)HQCommentItemModel{
    
    HQLog(@"点击了评论内容");
    
    if ([self.delegate respondsToSelector:@selector(didClickContent:index:)]) {
        
        [self.delegate didClickContent:HQCommentItemModel index:self.tag - 0x123];
        
        
    }
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
