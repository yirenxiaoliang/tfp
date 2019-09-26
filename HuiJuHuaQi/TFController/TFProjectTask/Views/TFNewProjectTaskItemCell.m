//
//  TFNewProjectTaskItemCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/28.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNewProjectTaskItemCell.h"
#import "TFTagListView.h"

#define MarginClearNo (4 * 16)
#define MarginClearYes (4 * 16 + 30)

@interface TFNewProjectTaskItemCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UIView *priorityBgView;
@property (weak, nonatomic) IBOutlet UIView *priorityView;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *taskNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;
@property (weak, nonatomic) IBOutlet TFTagListView *tagListView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clearBtnW;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taskNumBtnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taskNumBtnT;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTopM;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endTimeH;

@property (nonatomic, strong) TFProjectRowModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taskNumH;

@end

@implementation TFNewProjectTaskItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.shadowColor = LightGrayTextColor.CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView.layer.shadowRadius = 4;
    self.bgView.layer.shadowOpacity = 0.5;
    
    self.colorView.layer.cornerRadius = 4;
    self.colorView.layer.masksToBounds = YES;
    self.priorityBgView.layer.cornerRadius = 4;
    self.priorityBgView.layer.masksToBounds = YES;
    self.priorityView.layer.masksToBounds = YES;
    
    self.statusBtn.titleLabel.font = FONT(12);
//    self.statusBtn.userInteractionEnabled = NO;
    self.statusBtn.layer.cornerRadius = 4;
    self.statusBtn.layer.masksToBounds = YES;
    [self.statusBtn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
    [self.statusBtn addTarget:self action:@selector(statusClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headBtn.layer.cornerRadius = 15;
    self.headBtn.layer.masksToBounds = YES;
    self.headBtn.titleLabel.font = FONT(12);
    [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.headBtn setTitleColor:WhiteColor forState:UIControlStateHighlighted];
    self.headBtn.userInteractionEnabled = NO;
    
    self.taskNumBtn.titleLabel.font = FONT(12);
    [self.taskNumBtn setTitleColor:GrayTextColor forState:UIControlStateNormal];
    self.taskNumBtn.userInteractionEnabled = NO;
    
    self.endTimeBtn.titleLabel.font = FONT(12);
    [self.endTimeBtn setTitleColor:GrayTextColor forState:UIControlStateNormal];
    self.endTimeBtn.userInteractionEnabled = NO;
    self.endTimeBtn.layer.cornerRadius = 4;
    self.endTimeBtn.layer.masksToBounds = YES;
    
    self.titleLabel.textColor = BlackTextColor;
    self.titleLabel.font = FONT(14);
    self.titleLabel.numberOfLines = 0;
    
    self.tagListView.layer.masksToBounds = YES;
    
    self.bgView.backgroundColor = WhiteColor;
    self.contentView.backgroundColor = ClearColor;
    self.backgroundColor = ClearColor;
    [self.clearBtn addTarget:self action:@selector(clearClicked) forControlEvents:UIControlEventTouchUpInside];
}

-(void)statusClicked:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(projectTaskItemCell:didClickedFinishBtnWithModel:)]) {
        [self.delegate projectTaskItemCell:self didClickedFinishBtnWithModel:self.model];
    }
    
}

-(void)clearClicked{
    if ([self.delegate respondsToSelector:@selector(projectTaskItemCellDidClickedClearBtn:)]) {
        [self.delegate projectTaskItemCellDidClickedClearBtn:self];
    }
}

-(void)refreshNewProjectTaskItemCellWithModel:(TFProjectRowModel *)model haveClear:(BOOL)haveClear{
    
    self.model = model;
    // 清除按钮
    if (haveClear) {// 有
        self.clearBtn.hidden = NO;
        self.clearBtnW.constant = 30;
    }else{
        self.clearBtn.hidden = YES;
        self.clearBtnW.constant = 0;
    }
    
    // 优先级
    if (model.picklist_priority.count) {
        TFCustomerOptionModel *option = model.picklist_priority.firstObject;
        self.colorView.backgroundColor = [HQHelper colorWithHexString:option.color];
    }else{
        self.colorView.backgroundColor = WhiteColor;
    }
    // 状态
    if (model.picklist_status.count) {
        TFCustomerOptionModel *option = model.picklist_status.firstObject;
        [self.statusBtn setTitle:[NSString stringWithFormat:@"  %@",option.label] forState:UIControlStateNormal];
        self.statusBtn.hidden = NO;
//        [self.statusBtn setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:option.color]] forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
        if ([option.value integerValue] == 0) {// 未进行
            [self.statusBtn setImage:IMG(@"task未开始") forState:UIControlStateNormal];
            [self.statusBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0xE5E5E5)] forState:UIControlStateNormal];
            
            if (model.startTime && !IsStrEmpty([model.startTime description])  && ![[model.startTime description] isEqualToString:@"0"]) {
                if ([model.startTime longLongValue] < [HQHelper getNowTimeSp]) {
                    [self.statusBtn setImage:IMG(@"task超期未开始") forState:UIControlStateNormal];
                    [self.statusBtn setTitleColor:RedColor forState:UIControlStateNormal];
                    [self.statusBtn setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xfFFE3E2, 1)] forState:UIControlStateNormal];
                }
            }
            if (model.endTime && !IsStrEmpty([model.endTime description])  && ![[model.endTime description] isEqualToString:@"0"]) {
                if ([model.endTime longLongValue] < [HQHelper getNowTimeSp]) {
                    [self.statusBtn setImage:IMG(@"task超期未开始") forState:UIControlStateNormal];
                    [self.statusBtn setTitleColor:RedColor forState:UIControlStateNormal];
                    [self.statusBtn setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xFFE3E2, 1)] forState:UIControlStateNormal];
                }
            }
        }else if ([option.value integerValue] == 1){// 进行中
            [self.statusBtn setImage:IMG(@"task进行中") forState:UIControlStateNormal];
            [self.statusBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0xDAEDFF)] forState:UIControlStateNormal];
        }else if ([option.value integerValue] == 2){// 暂停
            [self.statusBtn setImage:IMG(@"task暂停") forState:UIControlStateNormal];
            [self.statusBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0xE5E5E5)] forState:UIControlStateNormal];
        }else if ([option.value integerValue] == 3){// 完成
            [self.statusBtn setImage:IMG(@"task已完成") forState:UIControlStateNormal];
            [self.statusBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0xEFF8E8)] forState:UIControlStateNormal];
        }
        
    }else{
        self.statusBtn.hidden = YES;
    }
    if (!model.from && !model.task_id) {// 非个人任务，非子任务
        if ([[model.complete_status description] isEqualToString:@"1"] && [[model.check_status description] isEqualToString:@"1"]){
            if (!model.passed_status || [[model.passed_status description] isEqualToString:@"0"]) {// 当需要校验的时候
                [self.statusBtn setTitle:[NSString stringWithFormat:@" %@",@"待检验"] forState:UIControlStateNormal];
                [self.statusBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0xFFEDD0)] forState:UIControlStateNormal];
                [self.statusBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
                self.statusBtn.layer.borderColor = ClearColor.CGColor;
                [self.statusBtn setImage:IMG(@"task待校验") forState:UIControlStateNormal];
            }
        }
    }
    
    // 标题
    self.titleLabel.text = model.taskName;
    // 头像
    if (model.responsibler || model.personnel_principal.firstObject) {
        TFEmployModel *employee = model.responsibler ? : model.personnel_principal.firstObject;
        if ((employee.id && ![[employee.id description] isEqualToString:@""]) || (employee.employee_id && ![[employee.employee_id description] isEqualToString:@""]) ) {
            
            self.headBtn.hidden = NO;
            [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:employee.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    [self.headBtn setTitle:@"" forState:UIControlStateNormal];
                }else{
                    [self.headBtn setTitle:[HQHelper nameWithTotalName:employee.employee_name?:employee.name] forState:UIControlStateNormal];
                    [self.headBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                    self.headBtn.titleLabel.font = FONT(12);
                    [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
                }
            }];
        }else{
            self.headBtn.hidden = YES;
        }
    }else{
        self.headBtn.hidden = YES;
    }
    // 标签
    [self.tagListView refreshWithOptions:model.tagList];
    if (model.tagList.count) {
        self.tagListView.hidden = NO;
    }else{
        self.tagListView.hidden = YES;
    }
    BOOL nothing = YES;
    // 子任务
    if (!IsNilOrNull(model.finishChildTaskNum) && !IsNilOrNull(model.childTaskNum) && model.childTaskNum && !IsStrEmpty([model.childTaskNum description]) && ![[model.childTaskNum description] isEqualToString:@"0"]) {
        
        nothing = NO;
        self.taskNumBtn.hidden = NO;
        NSString  *childTask = [NSString stringWithFormat:@" %ld/%ld",[model.finishChildTaskNum integerValue],[model.childTaskNum integerValue]];
        [self.taskNumBtn setTitle:childTask forState:UIControlStateNormal];
        [self.taskNumBtn setImage:[UIImage imageNamed:@"子任务"] forState:UIControlStateNormal];
        self.taskNumBtnW.constant = 40;
        self.taskNumBtnT.constant = 8;
    }else{
        self.taskNumBtn.hidden = YES;
        NSString  *childTask = @"";
        [self.taskNumBtn setTitle:childTask forState:UIControlStateNormal];
        [self.taskNumBtn setImage:nil forState:UIControlStateNormal];
        self.taskNumBtnW.constant = 0;
        self.taskNumBtnT.constant = 0;
    }
    // 截止时间
    if (model.endTime && !IsStrEmpty([model.endTime description]) && ![[model.endTime description] isEqualToString:@"0"]) {
        
        nothing = NO;
        self.endTimeBtn.hidden = NO;
        self.endTimeH.constant = 18;
        NSString *time = [NSString stringWithFormat:@"  %@%@  ",@"截止时间：",[HQHelper nsdateToTimeNowYear:[model.endTime longLongValue]]];
        [self.endTimeBtn setTitle:time forState:UIControlStateNormal];
        if ([model.endTime longLongValue] < [HQHelper getNowTimeSp]) {
            
            TFCustomerOptionModel *option = model.picklist_status.firstObject;
            if ([option.value integerValue] != 3) {
                [self.endTimeBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
                [self.endTimeBtn setBackgroundImage:[HQHelper createImageWithColor:RedColor] forState:UIControlStateNormal];
            }else{
                [self.endTimeBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
                [self.endTimeBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0xEBEDF0)] forState:UIControlStateNormal];
            }
        }else{
            [self.endTimeBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
            [self.endTimeBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0xEBEDF0)] forState:UIControlStateNormal];
        }
    }else{
        self.endTimeBtn.hidden = YES;
        self.endTimeH.constant = 0;
        [self.endTimeBtn setTitle:@"" forState:UIControlStateNormal];
    }
    if (nothing) {
        self.buttonTopM.constant = 0;
        self.taskNumH.constant = 0;
    }else{
        self.buttonTopM.constant = 8;
        self.taskNumH.constant = 18;
    }
}
+(CGFloat)refreshNewProjectTaskItemCellHeightWithModel:(TFProjectRowModel *)model haveClear:(BOOL)haveClear
{
    CGFloat height = 0;
    // 卡片留白
    height += 16;
    // 状态上间隙
    height += 12;
    // 状态高度
    height += 22;
    // 标题上间隙
    height += 10;
    // 标题高度
    CGFloat width = haveClear ? (SCREEN_WIDTH - MarginClearYes) : (SCREEN_WIDTH - MarginClearNo);
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){width,MAXFLOAT} titleStr:model.taskName];
    height += size.height;
    // 子任务
    BOOL childTask = NO;
    if (model.childTaskNum && !IsStrEmpty([model.childTaskNum description]) && ![[model.childTaskNum description] isEqualToString:@"0"]) {
        childTask = YES;
    }else{
        childTask = NO;
    }
    // 截止时间
    BOOL time = NO;
    if (model.endTime && !IsStrEmpty([model.endTime description]) && ![[model.endTime description] isEqualToString:@"0"]) {
        time = YES;
    }else{
        time = NO;
    }
    if (childTask|| time) {
        // 子任务上间隙
        height += 8;
        // 子任务高度
        height += 18;
    }
    // 标签
    if (model.tagList.count) {
        // 标签上间隙
        height += 8;
        // 标签高度
        height += 20;
    }
    // 标签下间隙
    height += 12;
    
    return height;
}

+(instancetype)newProjectTaskItemCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFNewProjectTaskItemCell" owner:self options:nil] lastObject];
}

+(instancetype)newProjectTaskItemCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFNewProjectTaskItemCell";
    TFNewProjectTaskItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFNewProjectTaskItemCell newProjectTaskItemCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
