//
//  HQTFTaskDetailTitleCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTaskDetailTitleCell.h"
#import "HQRootModel.h"

@interface HQTFTaskDetailTitleCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descH;
/** model */
@property (nonatomic, strong) TFProjTaskModel *model;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageT;

@end

@implementation HQTFTaskDetailTitleCell


-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.finishBtn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.textColor = ExtraLightBlackTextColor;
    self.descLabel.textColor = LightGrayTextColor;
    self.titleLabel.font = FONT(16);
    self.descLabel.font = FONT(12);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(descLabelClicked)];
    self.descLabel.userInteractionEnabled = YES;
    [self.descLabel addGestureRecognizer:tap];
    self.titleLabel.numberOfLines = 0;
    self.descLabel.numberOfLines = 0;
    
    self.approveStateBtn.hidden = YES;
    self.titleLabel.numberOfLines = 0;
    
    self.checkBtn.layer.cornerRadius = 4;
    self.checkBtn.layer.borderColor = GrayTextColor.CGColor;
    self.checkBtn.layer.borderWidth = 0.5;
    [self.checkBtn setTitle:@"校验" forState:UIControlStateNormal];
    [self.checkBtn setBackgroundColor:WhiteColor];
    [self.checkBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.checkBtn addTarget:self action:@selector(checkClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.checkW.constant = 0;
    self.checkBtn.hidden = YES;
    self.imageT.constant = 5;
}
-(void)setIsCheck:(BOOL)isCheck{
    _isCheck = isCheck;
    if (isCheck) {
        self.checkW.constant = 46;
        self.checkBtn.hidden = NO;
        self.imageT.constant = 50;
    }else{
        self.checkW.constant = 0;
        self.checkBtn.hidden = YES;
        self.imageT.constant = 5;
    }
}

-(void)checkClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(taskDetailTitleCell:didCheckBtn:withModel:)]) {
        [self.delegate taskDetailTitleCell:self didCheckBtn:button withModel:self.model];
    }
}

- (void)descLabelClicked{
    
    if ([self.delegate respondsToSelector:@selector(taskDetailTitleCell:didDescriptionWithModel:)]) {
        [self.delegate taskDetailTitleCell:self didDescriptionWithModel:self.model];
    }
}

- (void)finishClick{
    
//    self.finishBtn.selected = !self.finishBtn.selected;
    
    if ([self.delegate respondsToSelector:@selector(taskDetailTitleCell:didFinishBtn:withModel:)]) {
        [self.delegate taskDetailTitleCell:self didFinishBtn:self.finishBtn withModel:self.model];
    }
    
}

-(void)setTitle:(NSString *)title{
    _title = title;
    
    self.titleLabel.text = title;
    self.titleLabel.textColor = LightBlackTextColor;
    CGSize sizeTitle = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:title];
    self.titleH.constant = sizeTitle.height;
    
}

-(void)refreshTaskDetailTitleCellWithModel:(TFProjTaskModel*)model type:(NSInteger)type{
    
    self.model = model;
    
    if (type == 0) {// 任务详情父
        
        self.titleLabel.text = model.title;
        self.descLabel.text = model.descript;
        if (!model.descript || [model.descript isEqualToString:@""]) {
            self.descLabel.text = @"添加描述";
        }
        self.titleLabel.font = FONT(20);
        self.titleLabel.textColor = BlackTextColor;
        self.descLabel.font = FONT(14);
        self.descLabel.textColor = FinishedTextColor;
//        self.descLabel.backgroundColor = RedColor;
//        self.titleLabel.backgroundColor = GreenColor;
        
        CGSize sizeTitle = [HQHelper sizeWithFont:FONT(20.5) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr: model.title];
        self.titleH.constant = sizeTitle.height;
        
        if (!model.descript || [model.descript isEqualToString:@""]) {
            self.descLabel.text = @"添加描述";
            CGSize sizeDesc = [HQHelper sizeWithFont:FONT(14.5) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:@"添加描述"];
            self.descH.constant = sizeDesc.height;
            
        }else{
            
            CGSize sizeDesc = [HQHelper sizeWithFont:FONT(14.5) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:model.descript];
            self.descH.constant = sizeDesc.height;
        }
        
        self.finishBtn.selected = (!model.taskStatus || [model.taskStatus isEqualToNumber:@0])?NO:YES;
        
        self.titleLabel.numberOfLines = 0;
        self.descLabel.numberOfLines = 0;
        
    }else{// 任务详情子
        
        self.titleLabel.text = model.title;
        if (model.executorId && ![model.executorId isEqualToNumber:@0]) {
            
            self.descLabel.text = [NSString stringWithFormat:@"执行人 %@ %@",model.executorName,[HQHelper nsdateToTime:[model.deadline longLongValue] formatStr:@"yyyy-MM-dd"]];
        }else{
            
            self.descLabel.text = [NSString stringWithFormat:@"%@",[HQHelper nsdateToTime:[model.deadline longLongValue] formatStr:@"yyyy-MM-dd"]];
        }
        self.titleLabel.textColor = ExtraLightBlackTextColor;
        self.descLabel.textColor = LightGrayTextColor;
        self.titleLabel.font = FONT(14);
        self.descLabel.font = FONT(12);
        
        CGSize sizeTitle = [HQHelper sizeWithFont:FONT(15) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:self.titleLabel.text];
        self.titleH.constant = sizeTitle.height;
        
        
        CGSize sizeDesc = [HQHelper sizeWithFont:FONT(12) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:self.descLabel.text];
        self.descH.constant = sizeDesc.height;
        
        self.titleLabel.numberOfLines = 0;
        self.descLabel.numberOfLines = 0;
        self.finishBtn.selected = (!model.taskStatus || [model.taskStatus isEqualToNumber:@0])?NO:YES;
    }
    
}


+(CGFloat)refreshTaskDetailTitleCellHeightWithModel:(TFProjTaskModel*)model type:(NSInteger)type{
    
    if (type == 0) {
        
        CGFloat height = 15 + 15 + 8;
        
        CGSize sizeTitle = [HQHelper sizeWithFont:FONT(20) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:model.title];
        height += sizeTitle.height;
        
        NSString *taskDesc = model.descript;
        
        if (!model.descript || [model.descript isEqualToString:@""]) {
            taskDesc = @"添加描述";
        }

        CGSize sizeDesc = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:taskDesc];
        height += sizeDesc.height;
        
        return height;
        
    }else{
        
        return 70;
    }
    
}


-(void)refreshTaskDetailTitleCellWithTitle:(NSString *)title finishi:(NSString *)finish check:(NSString *)check pass:(NSString *)pass {
    
    self.titleLabel.text = title;
    self.titleLabel.numberOfLines = 0;
    CGSize sizeTitle = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){SCREEN_WIDTH-70,MAXFLOAT} titleStr:title];
    self.titleH.constant = sizeTitle.height + 10;
//    self.titleLabel.backgroundColor = RedColor;
    self.titleLabel.font = FONT(16);
    if ([[finish description] isEqualToString:@"1"]) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:TEXT(title)];
        [str addAttribute:NSForegroundColorAttributeName value:ExtraLightBlackTextColor range:(NSRange){0,title.length}];
        [str addAttribute:NSFontAttributeName value:FONT(16) range:(NSRange){0,title.length}];
        [str addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid) range:(NSRange){0,title.length}];
        [str addAttribute:NSStrikethroughColorAttributeName value:ExtraLightBlackTextColor range:(NSRange){0,title.length}];
        self.titleLabel.attributedText = str;
    }else{
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:TEXT(title)];
        [str addAttribute:NSForegroundColorAttributeName value:ExtraLightBlackTextColor range:(NSRange){0,title.length}];
        [str addAttribute:NSFontAttributeName value:FONT(16) range:(NSRange){0,title.length}];
        self.titleLabel.attributedText = str;
    }
    
    self.finishBtn.selected = (!finish || [[finish description] isEqualToString:@"0"])?NO:YES;
    
    if ([[finish description] isEqualToString:@"1"] && [[check description] isEqualToString:@"1"]){
        
        if (!pass || [[pass description] isEqualToString:@"0"]) {
            self.approveStateBtn.image = IMG(@"待检验");
        }else if ([[pass description] isEqualToString:@"1"]){
            self.approveStateBtn.image = IMG(@"taskPass");
        }
        self.approveStateBtn.hidden = NO;
        
//        if ([frameModel.projectRow.passed_status isEqualToString:@"0"]) {
//            self.checkView.image = [UIImage imageNamed:@"待检验"];
//        }else if ([frameModel.projectRow.passed_status isEqualToString:@"1"]){
//            self.checkView.image = [UIImage imageNamed:@"taskPass"];
//        }else{
//            self.checkView.image = [UIImage imageNamed:@"taskReject"];
//        }
        
    }else{
        
        if ([[pass description] isEqualToString:@"2"]) {
            self.approveStateBtn.hidden = NO;
            self.approveStateBtn.image = IMG(@"taskReject");
        }else{
            self.approveStateBtn.hidden = YES;
        }
    }
        
    
}

+(CGFloat)refreshTaskDetailTitleCellHeightWithTitle:(NSString *)title{
    
    
    if (!title || [title isEqualToString:@""]) {
        return 50;
    }
    CGFloat height = 15 + 15;
    
    CGSize sizeTitle = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){SCREEN_WIDTH-70,MAXFLOAT} titleStr:title];
    height += sizeTitle.height;
    
    return height + 10;
        

}

+ (instancetype)taskDetailTitleCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFTaskDetailTitleCell" owner:self options:nil] lastObject];
}

+ (HQTFTaskDetailTitleCell *)taskDetailTitleCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFTaskDetailTitleCell";
    HQTFTaskDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self taskDetailTitleCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topLine.hidden = YES;
    return cell;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
