//
//  TFApprovalFlowCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFApprovalFlowCell.h"

@interface TFApprovalFlowCell ()
@property (weak, nonatomic) IBOutlet UIButton *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIButton *statuesBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *circleImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineW;

@end

@implementation TFApprovalFlowCell


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.headImage.layer.cornerRadius = 15;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.userInteractionEnabled = NO;
    
    self.nameLabel.textColor = BlackTextColor;
    self.nameLabel.font = FONT(16);
    
    self.positionLabel.textColor = LightGrayTextColor;
    self.positionLabel.font = FONT(14);
    
    [self.statuesBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    self.statuesBtn.userInteractionEnabled = NO;
    self.statuesBtn.titleLabel.font = FONT(12);
    
    self.contentLabel.textColor = ExtraLightBlackTextColor;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = FONT(14);
    
    self.timeLabel.textColor = LightGrayTextColor;
    self.timeLabel.font = FONT(12);
    
    self.topLineImage.backgroundColor = GreenColor;
    self.bottomLineImage.backgroundColor = GrayTextColor;
    
    self.circleImage.layer.cornerRadius = 7;
    self.circleImage.layer.masksToBounds = YES;
    self.circleImage.layer.borderWidth = 1;
    self.circleImage.layer.borderColor = GrayTextColor.CGColor;
    self.circleImage.image = [HQHelper createImageWithColor:WhiteColor size:(CGSize){100,100}];
    self.circleImage.contentMode = UIViewContentModeScaleToFill;
    
    self.headMargin = 64;
    self.line.backgroundColor = CellSeparatorColor;
    
//    self.headImage.image = PlaceholderHeadImage;
//    self.nameLabel.text = @"亮亮同学";
//    self.positionLabel.text = @"(iOS工程师)";
//    self.contentLabel.text = @"哈大家开始对方将空的手";
//    self.timeLabel.text = [HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd HH:mm"];
//    [self.statuesBtn setTitle:@"审批通过" forState:UIControlStateNormal];
    
}

+ (instancetype)approvalFlowCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFApprovalFlowCell" owner:self options:nil] lastObject];
}



+ (instancetype)approvalFlowCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFApprovalFlowCell";
    TFApprovalFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self approvalFlowCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    return cell;
}

- (void)refreshApprovalCellWithModel:(TFApprovalFlowModel *)model{
    
    
    if ([model.task_key isEqualToString:@"endEvent"]) {
        
        // -1已提交 0待审批 1审批中 2审批通过 3审批驳回 4已撤销 5已转交 6待提交
        
        if ([model.task_status_id isEqualToString:@"0"]||[model.task_status_id isEqualToString:@"1"]||[model.task_status_id isEqualToString:@"-2"]) {
            
            [self approvalLastNoEndWithModel:model];
        }else if ([model.task_status_id isEqualToString:@"2"]) {
            
            [self approvalLastEndWithModel:model];
        }else if ([model.task_status_id isEqualToString:@"3"]) {
            
            [self approvalLastRejectWithModel:model];
        }else if ([model.task_status_id isEqualToString:@"4"]) {
            
            [self approvalLastCancelWithModel:model];
        }
        
        self.nameLabel.text = model.approval_message;
    
    }else{
        
        //-2 结束 -3 异常 -1已提交 0待审批 1审批中 2审批通过 3审批驳回 4已撤销 5已转交
        if ([model.task_status_id isEqualToString:@"-3"]) {// 异常
            
            [self approvalAbnormalWithModel:model];
            
        }else if ([model.task_status_id isEqualToString:@"-1"]) {// 已提交
            
            [self approvalStartWithModel:model];
            
        }else if ([model.task_status_id isEqualToString:@"0"]) {// 待审批
            
            [self approvalNextWithModel:model];
            
        }else if ([model.task_status_id isEqualToString:@"1"]) {// 进行中
            
            [self approvalingWithModel:model];
            
        }else if ([model.task_status_id isEqualToString:@"2"]) {// 通过
            
            [self approvalPassWithModel:model];
            
        }else if ([model.task_status_id isEqualToString:@"4"]) {// 撤销
            
            [self approvalCancelWithModel:model];
            
        }else if ([model.task_status_id isEqualToString:@"3"]) {// 驳回
            
            [self approvalRejectWithModel:model];
            
        }else if ([model.task_status_id isEqualToString:@"5"]) {// 已转交
            
            [self approvalTransferWithModel:model];
            
        }else if ([model.task_status_id isEqualToString:@"6"]) {// 待提交
            
            [self approvalWaitWithModel:model];
        }

    }
    
    // 上线
    if (model.previousColor) {
        self.topLineImage.layer.masksToBounds = YES;
        
        if ([model.previousColor isEqualToNumber:@0]) {
            self.topLineImage.backgroundColor = GrayTextColor;
            [HQHelper drawVerDashLine:self.topLineImage lineLength:6 lineSpacing:4 lineColor:ClearColor];
        }else if ([model.previousColor isEqualToNumber:@1]){
            self.topLineImage.backgroundColor = GreenColor;
            [HQHelper drawVerDashLine:self.topLineImage lineLength:6 lineSpacing:4 lineColor:ClearColor];
        }else if ([model.previousColor isEqualToNumber:@2]){
            self.topLineImage.backgroundColor = RedColor;
            [HQHelper drawVerDashLine:self.topLineImage lineLength:6 lineSpacing:4 lineColor:ClearColor];
        }else if ([model.previousColor isEqualToNumber:@4]){
            self.topLineImage.backgroundColor = HexColor(0xf6a623);
            [HQHelper drawVerDashLine:self.topLineImage lineLength:6 lineSpacing:4 lineColor:ClearColor];
        }else{
            
            self.topLineImage.backgroundColor = WhiteColor;
            [HQHelper drawVerDashLine:self.topLineImage lineLength:6 lineSpacing:4 lineColor:GrayTextColor];
        }
    }
    
    // 下线和圈
    if (model.selfColor) {
        
        self.bottomLineImage.layer.masksToBounds = YES;
        
        if ([model.selfColor isEqualToNumber:@0]) {
            
            self.circleImage.layer.borderColor = GrayTextColor.CGColor;
            self.bottomLineImage.backgroundColor = GrayTextColor;
            [HQHelper drawVerDashLine:self.bottomLineImage lineLength:6 lineSpacing:4 lineColor:ClearColor];
            self.bottomLineW.constant = 1;
        }else if ([model.selfColor isEqualToNumber:@1]) {
            
            self.circleImage.layer.borderColor = GreenColor.CGColor;
            self.bottomLineImage.backgroundColor = GreenColor;
            [HQHelper drawVerDashLine:self.bottomLineImage lineLength:6 lineSpacing:4 lineColor:ClearColor];
            
            self.bottomLineW.constant = 1;
        }else if ([model.selfColor isEqualToNumber:@2]) {
            
            self.circleImage.layer.borderColor = RedColor.CGColor;
            self.bottomLineImage.backgroundColor = RedColor;
            [HQHelper drawVerDashLine:self.bottomLineImage lineLength:6 lineSpacing:4 lineColor:ClearColor];
            self.bottomLineW.constant = 1;
        }else if ([model.selfColor isEqualToNumber:@4]) {
            
            self.circleImage.layer.borderColor = HexColor(0xf6a623).CGColor;
            self.bottomLineImage.backgroundColor = HexColor(0xf6a623);
            [HQHelper drawVerDashLine:self.bottomLineImage lineLength:6 lineSpacing:4 lineColor:ClearColor];
            self.bottomLineW.constant = 1;
        }else{
            
            [HQHelper drawVerDashLine:self.bottomLineImage lineLength:6 lineSpacing:4 lineColor:GrayTextColor];
            self.bottomLineImage.backgroundColor = WhiteColor;
            self.bottomLineW.constant = 1;
        }
    }
    /** 流程中添加属性：normal
     normal：0 异常流程节点（前端只需要处理不显示头像）
     normal：1 正常流程节点（前端无需做任何修改）
     */
    if ([model.normal isEqualToNumber:@0]) {
        self.headImage.hidden = YES;
    }else{
        self.headImage.hidden = NO;
    }
    
}
+ (CGFloat)refreshApprovalCellHeightWithModel:(TFApprovalFlowModel *)model{
   
    
    if ([model.task_key isEqualToString:@"endEvent"]) {
        
        return 64;
    }
    
    if ([model.task_status_id isEqualToString:@"-3"]) {// 异常
        
        return 64;
        
    }else if ([model.task_status_id isEqualToString:@"-1"]) {// 开始
        
        return 110;
        
    }else if ([model.task_status_id isEqualToString:@"1"]) {// 进行中
        
        return 88;
        
    }else if ([model.task_status_id isEqualToString:@"0"]) {// 待审批
        
        return 64;
        
    }else if ([model.task_status_id isEqualToString:@"2"]) {// 通过
        
        if (model.approval_message && ![model.approval_message isEqualToString:@""]) {
            
            CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-110,MAXFLOAT} titleStr:model.approval_message];
        
            return 92 + size.height;
            
        }else{
            return 88;
        }
        
        
    }else if ([model.task_status_id isEqualToString:@"4"]) {// 撤销
        if (model.approval_message && ![model.approval_message isEqualToString:@""]) {
            
            CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-110,MAXFLOAT} titleStr:model.approval_message];
            
            return 92 + size.height;
            
        }else{
            return 88;
        }
        
    }else if ([model.task_status_id isEqualToString:@"3"]) {// 驳回
        
        if (model.approval_message && ![model.approval_message isEqualToString:@""]) {
            
            CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-110,MAXFLOAT} titleStr:model.approval_message];
            
            return 92 + size.height;
            
        }else{
            return 88;
        }
        
    }else if ([model.task_status_id isEqualToString:@"5"]) {// 已转交
       
        if (model.approval_message && ![model.approval_message isEqualToString:@""]) {
            
            CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-110,MAXFLOAT} titleStr:model.approval_message];
            
            return 92 + size.height;
            
        }else{
            return 88;
        }
    }

    return 110;
}

/** 审批开始 */
- (void)approvalStartWithModel:(TFApprovalFlowModel *)model{
    
    self.topLineImage.hidden = NO;
    self.bottomLineImage.hidden = NO;
    
    self.topLineImage.backgroundColor = GreenColor;
    self.circleImage.layer.borderColor = GreenColor.CGColor;
    self.bottomLineImage.backgroundColor = GreenColor;
    
    self.statuesBtn.hidden = NO;
    self.contentLabel.hidden = NO;
    self.timeLabel.hidden = NO;
    
    self.positionLabel.hidden = NO;
    if (model.approval_employee_post) {
        self.positionLabel.hidden = NO;
        if (IsStrEmpty(model.approval_employee_post)) {
            self.positionLabel.hidden = YES;
        }else{
            self.positionLabel.text = [NSString stringWithFormat:@"(%@)",model.approval_employee_post];
        }
    }else{
        self.positionLabel.hidden = YES;
    }
    
    self.contentLabel.text = model.approval_message;
    self.contentLabel.textColor = GreenColor;
    
    [self.statuesBtn setTitle:model.task_status_name forState:UIControlStateNormal];
    [self.statuesBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.statuesBtn setImage:nil forState:UIControlStateNormal];
    
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.approval_employee_picture] forState:UIControlStateNormal  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            [self.headImage setTitle:@"" forState:UIControlStateNormal];
        }else{
            [self.headImage setTitle:[HQHelper nameWithTotalName:model.approval_employee_name] forState:UIControlStateNormal];
            [self.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            self.headImage.titleLabel.font = FONT(12);
            [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
    }];
    self.nameLabel.text = model.approval_employee_name;
    self.nameLabel.textColor = BlackTextColor;
    self.timeLabel.text = [HQHelper nsdateToTime:[model.approval_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    
    if ([model.dot isEqualToNumber:@1]) {
        self.circleImage.hidden = YES;
    }else{
        self.circleImage.hidden = NO;
    }
    
}

/** 当前审批人通过 */
- (void)approvalPassWithModel:(TFApprovalFlowModel *)model{
    
    self.topLineImage.hidden = NO;
    self.bottomLineImage.hidden = NO;
    
    self.topLineImage.backgroundColor = GreenColor;
    self.circleImage.layer.borderColor = GreenColor.CGColor;
    self.bottomLineImage.backgroundColor = GreenColor;
    
    self.positionLabel.hidden = YES;
    self.statuesBtn.hidden = NO;
    self.contentLabel.hidden = NO;
    self.timeLabel.hidden = NO;
    
    self.positionLabel.hidden = NO;
    if (model.approval_employee_post) {
        self.positionLabel.hidden = NO;
        if (IsStrEmpty(model.approval_employee_post)) {
            self.positionLabel.hidden = YES;
        }else{
            self.positionLabel.text = [NSString stringWithFormat:@"(%@)",model.approval_employee_post];
        }
    }else{
        self.positionLabel.hidden = YES;
    }
    self.contentLabel.text = model.approval_message;
    self.contentLabel.textColor = ExtraLightBlackTextColor;
    
    [self.statuesBtn setTitle:model.task_status_name forState:UIControlStateNormal];
    [self.statuesBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.statuesBtn setImage:nil forState:UIControlStateNormal];
    
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.approval_employee_picture] forState:UIControlStateNormal  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            [self.headImage setTitle:@"" forState:UIControlStateNormal];
        }else{
            [self.headImage setTitle:[HQHelper nameWithTotalName:model.approval_employee_name] forState:UIControlStateNormal];
            [self.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            self.headImage.titleLabel.font = FONT(12);
            [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
    }];
    self.nameLabel.text = model.approval_employee_name;
    self.nameLabel.textColor = BlackTextColor;
    self.timeLabel.text = [HQHelper nsdateToTime:[model.approval_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    
    if ([model.dot isEqualToNumber:@1]) {
        self.circleImage.hidden = YES;
    }else{
        self.circleImage.hidden = NO;
    }
}

/** 待审批 */
- (void)approvalNextWithModel:(TFApprovalFlowModel *)model{
    
    self.topLineImage.hidden = NO;
    self.bottomLineImage.hidden = NO;
    
    self.topLineImage.backgroundColor = GrayTextColor;
    self.circleImage.layer.borderColor = GrayTextColor.CGColor;
    self.bottomLineImage.backgroundColor = GrayTextColor;
    
    self.positionLabel.hidden = YES;
    self.statuesBtn.hidden = NO;
    self.contentLabel.hidden = YES;
    self.timeLabel.hidden = YES;
    
    [self.statuesBtn setTitle:model.task_status_name forState:UIControlStateNormal];
    [self.statuesBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.statuesBtn setImage:nil forState:UIControlStateNormal];
    
    if (model.approval_employee_picture && !model.task_approval_type) {
        
        [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.approval_employee_picture] forState:UIControlStateNormal  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image) {
                [self.headImage setTitle:@"" forState:UIControlStateNormal];
            }else{
                [self.headImage setTitle:[HQHelper nameWithTotalName:model.approval_employee_name] forState:UIControlStateNormal];
                [self.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                self.headImage.titleLabel.font = FONT(12);
                [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            }
        }];
        if (model.approval_employee_post) {
            self.positionLabel.hidden = NO;
            if (IsStrEmpty(model.approval_employee_post)) {
                self.positionLabel.hidden = YES;
            }else{
                self.positionLabel.text = [NSString stringWithFormat:@"(%@)",model.approval_employee_post];
            }
        }else{
            self.positionLabel.hidden = YES;
        }
    }else{
        
        [self.headImage setBackgroundImage:[UIImage imageNamed:@"未知流程"] forState:UIControlStateNormal];
        
    }
    
    self.nameLabel.text = model.approval_employee_name;
    self.nameLabel.textColor = BlackTextColor;
    self.timeLabel.text = [HQHelper nsdateToTime:[model.approval_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    
    if ([model.dot isEqualToNumber:@1]) {
        self.circleImage.hidden = YES;
    }else{
        self.circleImage.hidden = NO;
    }
}


/** 审批已转交 */
- (void)approvalTransferWithModel:(TFApprovalFlowModel *)model{
    
    self.topLineImage.hidden = NO;
    self.bottomLineImage.hidden = NO;
    
    self.topLineImage.backgroundColor = GrayTextColor;
    self.circleImage.layer.borderColor = GrayTextColor.CGColor;
    self.bottomLineImage.backgroundColor = GrayTextColor;
    
    self.positionLabel.hidden = YES;
    self.statuesBtn.hidden = NO;
    self.contentLabel.hidden = NO;
    self.timeLabel.hidden = NO;
    
    self.positionLabel.hidden = NO;
    if (model.approval_employee_post) {
        self.positionLabel.hidden = NO;
        if (IsStrEmpty(model.approval_employee_post)) {
            self.positionLabel.hidden = YES;
        }else{
            self.positionLabel.text = [NSString stringWithFormat:@"(%@)",model.approval_employee_post];
        }
    }else{
        self.positionLabel.hidden = YES;
    }
    [self.statuesBtn setTitle:model.task_status_name forState:UIControlStateNormal];
    [self.statuesBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.statuesBtn setImage:nil forState:UIControlStateNormal];
    
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.approval_employee_picture] forState:UIControlStateNormal  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            [self.headImage setTitle:@"" forState:UIControlStateNormal];
        }else{
            [self.headImage setTitle:[HQHelper nameWithTotalName:model.approval_employee_name] forState:UIControlStateNormal];
            [self.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            self.headImage.titleLabel.font = FONT(12);
            [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
    }];
    self.contentLabel.text = model.approval_message;
    self.contentLabel.textColor = ExtraLightBlackTextColor;
    self.nameLabel.text = model.approval_employee_name;
    self.nameLabel.textColor = BlackTextColor;
    self.timeLabel.text = [HQHelper nsdateToTime:[model.approval_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    
    if ([model.dot isEqualToNumber:@1]) {
        self.circleImage.hidden = YES;
    }else{
        self.circleImage.hidden = NO;
    }
}


/** 审批中 */
- (void)approvalingWithModel:(TFApprovalFlowModel *)model{
    
    self.topLineImage.hidden = NO;
    self.bottomLineImage.hidden = NO;
    
    self.topLineImage.backgroundColor = GreenColor;
    self.circleImage.layer.borderColor = GrayTextColor.CGColor;
    self.bottomLineImage.backgroundColor = GrayTextColor;
    
    self.positionLabel.hidden = YES;
    self.statuesBtn.hidden = NO;
    self.contentLabel.hidden = NO;
    self.timeLabel.hidden = YES;
    
    self.contentLabel.textColor = RedColor;
    self.contentLabel.text = model.approval_message;
    
    self.positionLabel.hidden = NO;
    if (model.approval_employee_post) {
        self.positionLabel.hidden = NO;
        if (IsStrEmpty(model.approval_employee_post)) {
            self.positionLabel.hidden = YES;
        }else{
            self.positionLabel.text = [NSString stringWithFormat:@"(%@)",model.approval_employee_post];
        }
    }else{
        self.positionLabel.hidden = YES;
    }
    
    if ([model.task_status_name isEqualToString:@"审批中"]) {
        
        [self.statuesBtn setTitle:model.task_status_name forState:UIControlStateNormal];
        [self.statuesBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
        [self.statuesBtn setImage:nil forState:UIControlStateNormal];
    }else{
        
        [self.statuesBtn setTitle:model.task_status_name forState:UIControlStateNormal];
        [self.statuesBtn setTitleColor:PriorityUrgent forState:UIControlStateNormal];
        [self.statuesBtn setImage:IMG(@"已超期") forState:UIControlStateNormal];
    }
    
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.approval_employee_picture] forState:UIControlStateNormal  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            [self.headImage setTitle:@"" forState:UIControlStateNormal];
        }else{
            [self.headImage setTitle:[HQHelper nameWithTotalName:model.approval_employee_name] forState:UIControlStateNormal];
            [self.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            self.headImage.titleLabel.font = FONT(12);
            [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
    }];
    self.nameLabel.text = model.approval_employee_name;
    self.nameLabel.textColor = BlackTextColor;
    self.timeLabel.text = [HQHelper nsdateToTime:[model.approval_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    
    if ([model.dot isEqualToNumber:@1]) {
        self.circleImage.hidden = YES;
    }else{
        self.circleImage.hidden = NO;
    }
}



/** 审批驳回 */
- (void)approvalRejectWithModel:(TFApprovalFlowModel *)model{
    
    self.topLineImage.hidden = NO;
    self.bottomLineImage.hidden = NO;
    
    self.topLineImage.backgroundColor = GreenColor;
    self.circleImage.layer.borderColor = RedColor.CGColor;
    self.bottomLineImage.backgroundColor = RedColor;
    
    self.positionLabel.hidden = YES;
    self.statuesBtn.hidden = NO;
    self.contentLabel.hidden = NO;
    self.timeLabel.hidden = NO;
    
    self.contentLabel.text = model.approval_message;
    self.contentLabel.textColor = ExtraLightBlackTextColor;
    
    self.positionLabel.hidden = NO;
    if (model.approval_employee_post) {
        self.positionLabel.hidden = NO;
        if (IsStrEmpty(model.approval_employee_post)) {
            self.positionLabel.hidden = YES;
        }else{
            self.positionLabel.text = [NSString stringWithFormat:@"(%@)",model.approval_employee_post];
        }
    }else{
        self.positionLabel.hidden = YES;
    }
    
    [self.statuesBtn setTitle:model.task_status_name forState:UIControlStateNormal];
    [self.statuesBtn setTitleColor:RedColor forState:UIControlStateNormal];
    [self.statuesBtn setImage:nil forState:UIControlStateNormal];
    
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.approval_employee_picture] forState:UIControlStateNormal  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            [self.headImage setTitle:@"" forState:UIControlStateNormal];
        }else{
            [self.headImage setTitle:[HQHelper nameWithTotalName:model.approval_employee_name] forState:UIControlStateNormal];
            [self.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            self.headImage.titleLabel.font = FONT(12);
            [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
    }];
    self.nameLabel.text = model.approval_employee_name;
    self.nameLabel.textColor = BlackTextColor;
    self.timeLabel.text = [HQHelper nsdateToTime:[model.approval_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    
    if ([model.dot isEqualToNumber:@1]) {
        self.circleImage.hidden = YES;
    }else{
        self.circleImage.hidden = NO;
    }

}


/** 审批待提交 */
- (void)approvalWaitWithModel:(TFApprovalFlowModel *)model{
    
    self.topLineImage.hidden = NO;
    self.bottomLineImage.hidden = NO;
    
    self.topLineImage.backgroundColor = GreenColor;
    self.circleImage.layer.borderColor = RedColor.CGColor;
    self.bottomLineImage.backgroundColor = RedColor;
    
    self.positionLabel.hidden = YES;
    self.statuesBtn.hidden = NO;
    self.contentLabel.hidden = NO;
    self.timeLabel.hidden = NO;
    
    self.contentLabel.text = model.approval_message;
    self.contentLabel.textColor = ExtraLightBlackTextColor;
    
    self.positionLabel.hidden = NO;
    if (model.approval_employee_post) {
        self.positionLabel.hidden = NO;
        if (IsStrEmpty(model.approval_employee_post)) {
            self.positionLabel.hidden = YES;
        }else{
            self.positionLabel.text = [NSString stringWithFormat:@"(%@)",model.approval_employee_post];
        }
    }else{
        self.positionLabel.hidden = YES;
        
    }
    
    [self.statuesBtn setTitle:model.task_status_name forState:UIControlStateNormal];
    [self.statuesBtn setTitleColor:RedColor forState:UIControlStateNormal];
    [self.statuesBtn setImage:nil forState:UIControlStateNormal];
    
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.approval_employee_picture] forState:UIControlStateNormal  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            [self.headImage setTitle:@"" forState:UIControlStateNormal];
        }else{
            [self.headImage setTitle:[HQHelper nameWithTotalName:model.approval_employee_name] forState:UIControlStateNormal];
            [self.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            self.headImage.titleLabel.font = FONT(12);
            [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
    }];
    self.nameLabel.text = model.approval_employee_name;
    self.nameLabel.textColor = BlackTextColor;
    self.timeLabel.text = [HQHelper nsdateToTime:[model.approval_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    
    if ([model.dot isEqualToNumber:@1]) {
        self.circleImage.hidden = YES;
    }else{
        self.circleImage.hidden = NO;
    }
    
}


/** 审批撤销 */
- (void)approvalCancelWithModel:(TFApprovalFlowModel *)model{
    
    self.topLineImage.hidden = NO;
    self.bottomLineImage.hidden = NO;
    
    self.topLineImage.backgroundColor = GreenColor;
    self.circleImage.layer.borderColor = HexColor(0xF5A623).CGColor;
    self.bottomLineImage.backgroundColor = HexColor(0xF5A623);
    
    self.positionLabel.hidden = YES;
    self.statuesBtn.hidden = NO;
    self.contentLabel.hidden = NO;
    self.timeLabel.hidden = NO;
    
    self.contentLabel.text = model.approval_message;
    self.contentLabel.textColor = RedColor;
    
    self.positionLabel.hidden = NO;
    if (model.approval_employee_post) {
        self.positionLabel.hidden = NO;
        if (IsStrEmpty(model.approval_employee_post)) {
            self.positionLabel.hidden = YES;
        }else{
            self.positionLabel.text = [NSString stringWithFormat:@"(%@)",model.approval_employee_post];
        }
    }else{
        self.positionLabel.hidden = YES;
    }
    
    [self.statuesBtn setTitle:model.task_status_name forState:UIControlStateNormal];
    [self.statuesBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.statuesBtn setImage:nil forState:UIControlStateNormal];
    
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.approval_employee_picture] forState:UIControlStateNormal  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            [self.headImage setTitle:@"" forState:UIControlStateNormal];
        }else{
            [self.headImage setTitle:[HQHelper nameWithTotalName:model.approval_employee_name] forState:UIControlStateNormal];
            [self.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            self.headImage.titleLabel.font = FONT(12);
            [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
    }];
    self.nameLabel.text = model.approval_employee_name;
    self.nameLabel.textColor = BlackTextColor;
    self.timeLabel.text = [HQHelper nsdateToTime:[model.approval_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    
    if ([model.dot isEqualToNumber:@1]) {
        self.circleImage.hidden = YES;
    }else{
        self.circleImage.hidden = NO;
    }
}



/** 审批未完成 */
- (void)approvalLastNoEndWithModel:(TFApprovalFlowModel *)model{
    
    self.topLineImage.hidden = NO;
    self.bottomLineImage.hidden = NO;
    
    self.topLineImage.backgroundColor = GrayTextColor;
    self.circleImage.layer.borderColor = GrayTextColor.CGColor;
    self.bottomLineImage.backgroundColor = GrayTextColor;
    
    self.positionLabel.hidden = YES;
    self.statuesBtn.hidden = YES;
    self.contentLabel.hidden = YES;
    self.timeLabel.hidden = YES;
    
    self.nameLabel.text = model.approval_message;
    self.nameLabel.textColor = BlackTextColor;
    [self.headImage setBackgroundImage:IMG(@"流程进行中") forState:UIControlStateNormal];
    [self.headImage setTitle:@"" forState:UIControlStateNormal];
    
}


/** 审批完成 */
- (void)approvalLastEndWithModel:(TFApprovalFlowModel *)model{
    
    self.topLineImage.hidden = NO;
    self.bottomLineImage.hidden = NO;
    
    self.topLineImage.backgroundColor = GreenColor;
    self.circleImage.layer.borderColor = GreenColor.CGColor;
    self.bottomLineImage.backgroundColor = GreenColor;
    
    self.positionLabel.hidden = YES;
    self.statuesBtn.hidden = YES;
    self.contentLabel.hidden = YES;
    self.timeLabel.hidden = YES;
    
    self.nameLabel.text = model.approval_message;
    self.nameLabel.textColor = HexColor(0x3CBB81);
    [self.headImage setBackgroundImage:IMG(@"流程完成") forState:UIControlStateNormal];
    [self.headImage setTitle:@"" forState:UIControlStateNormal];
}


/** 审批驳回终止 */
- (void)approvalLastRejectWithModel:(TFApprovalFlowModel *)model{
    
    self.topLineImage.hidden = NO;
    self.bottomLineImage.hidden = NO;
    
    self.topLineImage.backgroundColor = RedColor;
    self.circleImage.layer.borderColor = RedColor.CGColor;
    self.bottomLineImage.backgroundColor = RedColor;
    
    self.positionLabel.hidden = YES;
    self.statuesBtn.hidden = YES;
    self.contentLabel.hidden = YES;
    self.timeLabel.hidden = YES;
    
    self.nameLabel.text = model.approval_message;
    self.nameLabel.textColor = RedColor;
    [self.headImage setBackgroundImage:IMG(@"流程驳回并结束") forState:UIControlStateNormal];
    [self.headImage setTitle:@"" forState:UIControlStateNormal];
}

/** 审批撤销 */
- (void)approvalLastCancelWithModel:(TFApprovalFlowModel *)model{
    
    self.topLineImage.hidden = NO;
    self.bottomLineImage.hidden = NO;
    
    self.topLineImage.backgroundColor = RedColor;
    self.circleImage.layer.borderColor = HexColor(0xF5A623).CGColor;
    self.bottomLineImage.backgroundColor = HexColor(0xF5A623);
    
    self.positionLabel.hidden = YES;
    self.statuesBtn.hidden = YES;
    self.contentLabel.hidden = YES;
    self.timeLabel.hidden = YES;
    
    self.nameLabel.text = model.approval_message;
    self.nameLabel.textColor = HexColor(0xF5A623);
    [self.headImage setBackgroundImage:IMG(@"撤销APP") forState:UIControlStateNormal];
    [self.headImage setTitle:@"" forState:UIControlStateNormal];
}

/** 审批异常 */
- (void)approvalAbnormalWithModel:(TFApprovalFlowModel *)model{
    
    self.topLineImage.hidden = NO;
    self.bottomLineImage.hidden = NO;
    
    self.topLineImage.backgroundColor = GrayTextColor;
    self.circleImage.layer.borderColor = GrayTextColor.CGColor;
    self.bottomLineImage.backgroundColor = GrayTextColor;
    
    self.positionLabel.hidden = YES;
    self.statuesBtn.hidden = NO;
    self.contentLabel.hidden = YES;
    self.timeLabel.hidden = YES;
    
    [self.statuesBtn setTitle:model.task_status_name forState:UIControlStateNormal];
    [self.statuesBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.statuesBtn setImage:nil forState:UIControlStateNormal];
    
    if (model.approval_employee_picture && !model.task_approval_type) {
        
        [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.approval_employee_picture] forState:UIControlStateNormal  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image) {
                [self.headImage setTitle:@"" forState:UIControlStateNormal];
            }else{
                [self.headImage setTitle:[HQHelper nameWithTotalName:model.approval_employee_name] forState:UIControlStateNormal];
                [self.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                self.headImage.titleLabel.font = FONT(12);
                [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            }
        }];
        if (model.approval_employee_post) {
            self.positionLabel.hidden = NO;
            if (IsStrEmpty(model.approval_employee_post)) {
                self.positionLabel.hidden = YES;
            }else{
                self.positionLabel.text = [NSString stringWithFormat:@"(%@)",model.approval_employee_post];
            }
        }else{
            self.positionLabel.hidden = YES;
        }
    }else{
        
        [self.headImage setBackgroundImage:[UIImage imageNamed:@"未知流程"] forState:UIControlStateNormal];
        
    }
    
    self.nameLabel.text = model.approval_employee_name;
    self.nameLabel.textColor = BlackTextColor;
    self.timeLabel.text = [HQHelper nsdateToTime:[model.approval_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    
    if ([model.dot isEqualToNumber:@1]) {
        self.circleImage.hidden = YES;
    }else{
        self.circleImage.hidden = NO;
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
