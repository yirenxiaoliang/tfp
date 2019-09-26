//
//  HQTFTaskTableViewCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTaskTableViewCell.h"
#define TotalMargin 135
@interface HQTFTaskTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textRightW;

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleH;
@property (weak, nonatomic) IBOutlet UIView *priorityView;

/** 第一排图标 */
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *btn7;

/** 第二排图标 */
@property (weak, nonatomic) IBOutlet UIButton *btn8;
@property (weak, nonatomic) IBOutlet UIButton *btn9;
@property (weak, nonatomic) IBOutlet UIButton *btn10;
@property (weak, nonatomic) IBOutlet UIButton *btn11;

/** 第三排左图标 */
@property (weak, nonatomic) IBOutlet UIButton *btn12;
@property (weak, nonatomic) IBOutlet UIButton *btn13;
@property (weak, nonatomic) IBOutlet UIButton *btn14;
@property (weak, nonatomic) IBOutlet UIButton *btn150;


/** 第三排右图标 */
@property (weak, nonatomic) IBOutlet UIButton *btn15;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn1T;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn2T;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn3T;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn4T;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn5T;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn6T;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBottom;

@property (weak, nonatomic) IBOutlet UIButton *downBtn;

/**  model */
@property (nonatomic, strong) TFProjTaskModel *model;


@end

@implementation HQTFTaskTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.font = FONT(18);
    self.titleLabel.textColor = BlackTextColor;
    self.titleLabel.numberOfLines = 0;
    
    [self.finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.downBtn addTarget:self action:@selector(downBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn1.backgroundColor = [UIColor clearColor];
    self.btn2.backgroundColor = [UIColor clearColor];
    self.btn3.backgroundColor = [UIColor clearColor];
    self.btn4.backgroundColor = [UIColor clearColor];
    self.btn5.backgroundColor = [UIColor clearColor];
    self.btn6.backgroundColor = [UIColor clearColor];
    self.btn7 .backgroundColor = [UIColor clearColor];
    self.btn8.backgroundColor = [UIColor clearColor];
    self.btn9.backgroundColor = [UIColor clearColor];
    self.btn10.backgroundColor = [UIColor clearColor];
    self.btn11.backgroundColor = [UIColor clearColor];
    self.btn12.backgroundColor = [UIColor clearColor];
    self.btn13.backgroundColor = [UIColor clearColor];
    self.btn14.backgroundColor = [UIColor clearColor];
    self.btn150.backgroundColor = [UIColor clearColor];
    
    self.btn1.userInteractionEnabled = NO;
    self.btn2.userInteractionEnabled = NO;
    self.btn3.userInteractionEnabled = NO;
    self.btn4.userInteractionEnabled = NO;
    self.btn5.userInteractionEnabled = NO;
    self.btn6.userInteractionEnabled = NO;
    self.btn7.userInteractionEnabled = NO;
    self.btn8.userInteractionEnabled = NO;
    self.btn9.userInteractionEnabled = NO;
    self.btn10.userInteractionEnabled = NO;
    self.btn11.userInteractionEnabled = NO;
    self.btn12.userInteractionEnabled = NO;
    self.btn13.userInteractionEnabled = NO;
    self.btn14.userInteractionEnabled = NO;
    self.btn150.userInteractionEnabled = NO;
    
    
    [self.btn1 setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.btn2 setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.btn3 setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.btn4 setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.btn5 setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.btn6 setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.btn7 setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.btn8 setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.btn9 setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.btn10 setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.btn11 setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.btn12 setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.btn13 setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.btn14 setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.btn150 setTitleColor:WhiteColor forState:UIControlStateNormal];
    
    self.btn1.layer.cornerRadius = 1;
    self.btn1.layer.masksToBounds = YES;
    
    self.btn8.layer.cornerRadius = 10;
    self.btn8.layer.masksToBounds = YES;
    self.btn9.layer.cornerRadius = 10;
    self.btn9.layer.masksToBounds = YES;
    self.btn10.layer.cornerRadius = 10;
    self.btn10.layer.masksToBounds = YES;
    self.btn11.layer.cornerRadius = 10;
    self.btn11.layer.masksToBounds = YES;
    self.btn12.layer.cornerRadius = 10;
    self.btn12.layer.masksToBounds = YES;
    self.btn13.layer.cornerRadius = 10;
    self.btn13.layer.masksToBounds = YES;
    self.btn14.layer.cornerRadius = 10;
    self.btn14.layer.masksToBounds = YES;
    self.btn150.layer.cornerRadius = 10;
    self.btn150.layer.masksToBounds = YES;
    
    self.btn15.layer.cornerRadius = 2;
    self.btn15.layer.masksToBounds = YES;
    
    self.btn15.titleLabel.font = FONT(12);
    [self.btn15 setBackgroundImage:[HQHelper createImageWithColor:GrayGroundColor] forState:UIControlStateNormal];
    [self.btn15 setBackgroundImage:[HQHelper createImageWithColor:GrayGroundColor] forState:UIControlStateHighlighted];
    
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    self.bgView.layer.cornerRadius = 2;
    self.bgView.backgroundColor = WhiteColor;
    self.bgView.layer.shadowColor = GrayTextColor.CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(1, 1);
    self.bgView.layer.shadowOpacity = 0.2;
    self.bgView.layer.shadowRadius = 1;
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.tag = 0x1000;
    [self.priorityView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.priorityView);
        make.left.equalTo(self.priorityView);
        make.bottom.equalTo(self.priorityView);
        make.right.equalTo(self.priorityView);
    }];
    
//    NSArray *images = @[@"描述",@"考勤2",@"投票2",@"文件",@"检测项",@"重复任务",@"数量",@"上锁",@"截止时间"];
}



-(void)refreshTaskTableViewCellWithModel:(TFProjTaskModel *)model type:(NSInteger)type{
    
    self.model = model;
    // type 0:项目中的任务 1：主界面的任务
    
    if (type == 0) {
        self.textRightW.constant = 15;
        self.downBtn.hidden = YES;
        
    }else{
        self.downBtn.hidden = NO;
        self.textRightW.constant = 15 + 40;
    }
    
    // 执行人
    
    if (model.executor && ![model.executor isEqualToNumber:@0]) {
        
        self.btn15.hidden = NO;
        if (model.executorPhotograph && model.executorPhotograph.length) {
            
            [self.btn15 setTitle:nil forState:UIControlStateNormal];
            [self.btn15 sd_setImageWithURL:[NSURL URLWithString:model.executorPhotograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
        }else {
            [self.btn15 setImage:nil forState:UIControlStateNormal];
            [self.btn15 setTitle:[HQHelper nameWithTotalName:model.executorName?model.executorName:model.executorlName] forState:UIControlStateNormal];
        }
    }else{
        
        self.btn15.hidden = YES;
    }
    
    
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.priorityView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:(CGSize){2,2}];
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    [layer setPath:path.CGPath];
//    self.priorityView.layer.mask = layer;
    
    // 任务内容
    self.titleLabel.text = model.title;
    CGSize contentSize = [HQHelper sizeWithFont:FONT(18) maxSize:(CGSize){SCREEN_WIDTH-TotalMargin,MAXFLOAT} titleStr:model.title];
    self.titleH.constant = contentSize.height;

    
    // 激活次数
    if (!model.activeCount || [model.activeCount integerValue] == 0) {
        
        self.btn1T.constant = 0;
        [self.btn1 setTitle:@"" forState:UIControlStateNormal];
        [self.btn1 setBackgroundImage:[HQHelper createImageWithColor:ClearColor size:CGSizeMake(0.5, 0.5)] forState:UIControlStateNormal];
    }else{
        
        self.btn1T.constant = 8;
        [self.btn1 setTitle:[NSString stringWithFormat:@" %ld ",[model.activeCount integerValue]] forState:UIControlStateNormal];
        [self.btn1 setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xF5A623, 1)] forState:UIControlStateNormal];
        [self.btn1 setTitleColor:WhiteColor forState:UIControlStateNormal];
    }
    // 截止时间
    if (!model.deadline || [model.deadline isEqualToNumber:@0]) {
        [self.btn2 setImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeMake(0.5, 0.5)] forState:UIControlStateNormal];
        [self.btn2 setTitle:@"" forState:UIControlStateNormal];
        self.btn2T.constant = 0;
    }else{
        [self.btn2 setImage:[UIImage imageNamed:@"截止时间"] forState:UIControlStateNormal];
        [self.btn2 setTitle:[HQHelper nsdateToTime:[model.deadline longLongValue] formatStr:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        self.btn2T.constant = 8;
    }

    
    // 描述
    if (!model.descript || [model.descript isEqualToString:@""]) {
        [self.btn3 setImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeMake(0.5, 0.5)] forState:UIControlStateNormal];
        self.btn3T.constant = 0;
    }else{
        [self.btn3 setImage:[UIImage imageNamed:@"描述"] forState:UIControlStateNormal];
        self.btn3T.constant = 8;
    }
  
    // 文件
    if (!model.fileCount || [model.fileCount isEqualToNumber:@0]) {
        [self.btn4 setImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeMake(0.5, 0.5)] forState:UIControlStateNormal];
        [self.btn4 setTitle:@"" forState:UIControlStateNormal];
        self.btn4T.constant = 0;
    }else{
        [self.btn4 setImage:[UIImage imageNamed:@"文件"] forState:UIControlStateNormal];
        [self.btn4 setTitle:[NSString stringWithFormat:@"%ld",[model.fileCount integerValue]] forState:UIControlStateNormal];
        self.btn4T.constant = 8;
    }
    
    // 检测项
    if (!model.subTaskCount || [model.subTaskCount isEqualToNumber:@0]) {
        [self.btn5 setImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeMake(0.5, 0.5)] forState:UIControlStateNormal];
        [self.btn5 setTitle:@"" forState:UIControlStateNormal];
        self.btn5T.constant = 0;
    }else{
        [self.btn5 setImage:[UIImage imageNamed:@"检测项"] forState:UIControlStateNormal];
        [self.btn5 setTitle:[NSString stringWithFormat:@"%ld/%ld",[model.subTaskFinishCount integerValue],[model.subTaskCount integerValue]] forState:UIControlStateNormal];
        self.btn5T.constant = 8;
    }
    // 上锁
    
    if (!model.isPublic || [model.isPublic isEqualToNumber:@0]) {
        [self.btn6 setImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeMake(0.5, 0.5)] forState:UIControlStateNormal];
        self.btn6T.constant = 0;
    }else{
        [self.btn6 setImage:[UIImage imageNamed:@"上锁"] forState:UIControlStateNormal];
        self.btn6T.constant = 8;
    }
    
    [self.btn7 setImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeMake(0.5, 0.5)] forState:UIControlStateNormal];
    [self.btn7 setTitle:@"" forState:UIControlStateNormal];
    
    // 优先级
    UIImageView *imageView = [self.priorityView viewWithTag:0x1000];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 6, 10, 0);
    // 指定为拉伸模式
    if ([model.priority integerValue] == 0) {
        
        imageView.image = [[UIImage imageNamed:@""] resizableImageWithCapInsets:insets];
        self.priorityView.backgroundColor = ClearColor;
        
    }else if ([model.priority integerValue] == 1){
        
        imageView.image = [[UIImage imageNamed:@"ugent"] resizableImageWithCapInsets:insets];
        //        self.priorityView.backgroundColor = PriorityUrgent;
        self.priorityView.backgroundColor = ClearColor;
    }else{
        
        imageView.image = [[UIImage imageNamed:@"veryUgent"] resizableImageWithCapInsets:insets];
        //        self.priorityView.backgroundColor = PriorityVeryUrgent;
        self.priorityView.backgroundColor = ClearColor;
    }
    
    
    // 延期
    if (!model.isHasApprove || [model.isHasApprove integerValue] == 0) {
        
        [self.finishBtn setImage:[UIImage imageNamed:@"未选择24"] forState:UIControlStateNormal];
        
    }else{
        
        [self.finishBtn setImage:[UIImage imageNamed:@"选择蓝24"] forState:UIControlStateNormal];
    }
    
    // 完成
    
    if (!model.taskStatus || [model.taskStatus integerValue] == 0) {
        
        self.titleLabel.textColor = BlackTextColor;
        self.finishBtn.selected = NO;
    }else{
        
        self.titleLabel.textColor = FinishedTextColor;
        self.finishBtn.selected = YES;
    }
    
    // 有小图标
    if ((model.activeCount && [model.activeCount integerValue] != 0)
        || (model.deadline && ![model.deadline isEqualToNumber:@0])
        || (model.descript && ![model.descript isEqualToString:@""])
        || (model.fileCount && ![model.fileCount isEqualToNumber:@0])
        || (model.subTaskCount && ![model.subTaskCount isEqualToNumber:@0])
        || (model.isPublic && ![model.isPublic isEqualToNumber:@0])) {
        
        self.titleBottom.constant = 15;
    }else{
        self.titleBottom.constant = 0;
    }

    /**
     
     // 重复性
     if (!model.isRepeat || [model.isRepeat isEqualToNumber:@0]) {
     [self.btn6 setImage:[HQHelper createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
     self.btn6T.constant = 0;
     }else{
     [self.btn6 setImage:[UIImage imageNamed:@"重复任务"] forState:UIControlStateNormal];
     self.btn6T.constant = 8;
     }
     
     // 投票
     if (!model.relatedVoteId) {
     [self.btn3 setImage:[HQHelper createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
     self.btn3T.constant = 0;
     }else{
     [self.btn3 setImage:[UIImage imageNamed:@"投票2"] forState:UIControlStateNormal];
     self.btn3T.constant = 8;
     }

     // 考勤
     if (!model.relatedAttendanceId) {
     [self.btn2 setImage:[HQHelper createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
     self.btn2T.constant = 0;
     }else{
     [self.btn2 setImage:[UIImage imageNamed:@"考勤2"] forState:UIControlStateNormal];
     self.btn2T.constant = 8;
     }
     
    // 数量
    if (!model.numberSum || [model.numberSum isEqualToString:@""]) {
        [self.btn7 setImage:[HQHelper createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [self.btn7 setTitle:@"" forState:UIControlStateNormal];
        self.btn7T.constant = 0;
    }else{
        [self.btn7 setImage:[UIImage imageNamed:@"数量"] forState:UIControlStateNormal];
        [self.btn7 setTitle:model.numberSum forState:UIControlStateNormal];
        self.btn7T.constant = 8;
    }
    
        // 截止时间
    if (!model.deadline || [model.deadline isEqualToNumber:@0]) {
        [self.btn18 setImage:[HQHelper createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [self.btn18 setTitle:@"" forState:UIControlStateNormal];
        self.btn18T.constant = 0;
    }else{
        [self.btn18 setImage:[UIImage imageNamed:@"截止时间"] forState:UIControlStateNormal];
        [self.btn18 setTitle:[HQHelper nsdateToTime:[model.deadline longLongValue] formatStr:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        self.btn18T.constant = 8;
    }
     
    
    
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 20, 10, 10);
    // 指定为拉伸模式
    UIImage *image = [[UIImage imageNamed:@"标签透明"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    */
    
    UIImage *image = [HQHelper createImageWithColor:ClearColor];
    
    // 摆放标签
    if (model.labels.count) {
        
        CGFloat sur = SCREEN_WIDTH - TotalMargin - 30 - 15;
        
        if (type == 1) {
            sur += 40;
        }
        
        CGFloat puls = 0;
        NSString *str = @"";
        NSInteger index = -1;
        
        for (NSInteger i = 0; i < model.labels.count; i ++) {
            
            TFProjLabelModel *label = model.labels[i];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"  %@  ",label.labelName]];
            CGSize size = [HQHelper sizeWithFont:FONT(10) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:str];
            puls = (size.width + 8);
            
            if (sur <= puls) {
                break;
            }
            index ++;
        }
        
        if (model.labels.count == 1) {
            TFProjLabelModel *lab = model.labels[0];
            if (index == 0) {
                
                [self.btn8 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn8 setBackgroundColor:[UIColor clearColor]];
                [self.btn8 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn9 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn9 setBackgroundColor:[UIColor clearColor]];
                [self.btn9 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn10 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn10 setBackgroundColor:[UIColor clearColor]];
                [self.btn10 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn11 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn11 setBackgroundColor:[UIColor clearColor]];
                [self.btn11 setTitle:@"" forState:UIControlStateNormal];
                
                
                [self.btn12 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn12 setBackgroundColor:[HQHelper colorWithHexString:lab.labelColor]];
                [self.btn12 setTitle:[NSString stringWithFormat:@"  %@  ",lab.labelName] forState:UIControlStateNormal];
                
                [self.btn13 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn13 setBackgroundColor:[UIColor clearColor]];
                [self.btn13 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn14 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn14 setBackgroundColor:[UIColor clearColor]];
                [self.btn14 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn150 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn150 setBackgroundColor:[UIColor clearColor]];
                [self.btn150 setTitle:@"" forState:UIControlStateNormal];
                
            }else{
                
                [self.btn8 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn8 setBackgroundColor:[UIColor clearColor]];
                [self.btn8 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn9 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn9 setBackgroundColor:[UIColor clearColor]];
                [self.btn9 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn10 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn10 setBackgroundColor:[UIColor clearColor]];
                [self.btn10 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn11 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn11 setBackgroundColor:[UIColor clearColor]];
                [self.btn11 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn12 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn12 setBackgroundColor:[HQHelper colorWithHexString:lab.labelColor]];
                [self.btn12 setTitle:[NSString stringWithFormat:@"  %@  ",lab.labelName] forState:UIControlStateNormal];
                
                [self.btn13 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn13 setBackgroundColor:[UIColor clearColor]];
                [self.btn13 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn14 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn14 setBackgroundColor:[UIColor clearColor]];
                [self.btn14 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn150 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn150 setBackgroundColor:[UIColor clearColor]];
                [self.btn150 setTitle:@"" forState:UIControlStateNormal];

            }
            
        }else if (model.labels.count == 2){
            
            TFProjLabelModel *lab1 = model.labels[0];
            TFProjLabelModel *lab2 = model.labels[1];
            if (index == 0) {
                [self.btn8 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn8 setBackgroundColor:[HQHelper colorWithHexString:lab1.labelColor]];
                [self.btn8 setTitle:[NSString stringWithFormat:@"  %@  ",lab1.labelName] forState:UIControlStateNormal];
                
                [self.btn9 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn9 setBackgroundColor:[UIColor clearColor]];
                [self.btn9 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn10 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn10 setBackgroundColor:[UIColor clearColor]];
                [self.btn10 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn11 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn11 setBackgroundColor:[UIColor clearColor]];
                [self.btn11 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn12 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn12 setBackgroundColor:[HQHelper colorWithHexString:lab2.labelColor]];
                [self.btn12 setTitle:[NSString stringWithFormat:@"  %@  ",lab2.labelName] forState:UIControlStateNormal];
                
                [self.btn13 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn13 setBackgroundColor:[UIColor clearColor]];
                [self.btn13 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn14 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn14 setBackgroundColor:[UIColor clearColor]];
                [self.btn14 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn150 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn150 setBackgroundColor:[UIColor clearColor]];
                [self.btn150 setTitle:@"" forState:UIControlStateNormal];

                
            }else if (index == 1){
                
                
                [self.btn8 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn8 setBackgroundColor:[UIColor clearColor]];
                [self.btn8 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn9 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn9 setBackgroundColor:[UIColor clearColor]];
                [self.btn9 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn10 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn10 setBackgroundColor:[UIColor clearColor]];
                [self.btn10 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn11 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn11 setBackgroundColor:[UIColor clearColor]];
                [self.btn11 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn12 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn12 setBackgroundColor:[HQHelper colorWithHexString:lab1.labelColor]];
                [self.btn12 setTitle:[NSString stringWithFormat:@"  %@  ",lab1.labelName] forState:UIControlStateNormal];
                
                [self.btn13 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn13 setBackgroundColor:[HQHelper colorWithHexString:lab2.labelColor]];
                [self.btn13 setTitle:[NSString stringWithFormat:@"  %@  ",lab2.labelName] forState:UIControlStateNormal];
                

                
                [self.btn14 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn14 setBackgroundColor:[UIColor clearColor]];
                [self.btn14 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn150 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn150 setBackgroundColor:[UIColor clearColor]];
                [self.btn150 setTitle:@"" forState:UIControlStateNormal];
                
            }else{
                [self.btn8 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn8 setBackgroundColor:[UIColor clearColor]];
                [self.btn8 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn9 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn9 setBackgroundColor:[UIColor clearColor]];
                [self.btn9 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn10 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn10 setBackgroundColor:[UIColor clearColor]];
                [self.btn10 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn11 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn11 setBackgroundColor:[UIColor clearColor]];
                [self.btn11 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn12 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn12 setBackgroundColor:[HQHelper colorWithHexString:lab1.labelColor]];
                [self.btn12 setTitle:[NSString stringWithFormat:@"  %@  ",lab1.labelName] forState:UIControlStateNormal];
                
                [self.btn13 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn13 setBackgroundColor:[HQHelper colorWithHexString:lab2.labelColor]];
                [self.btn13 setTitle:[NSString stringWithFormat:@"  %@  ",lab2.labelName] forState:UIControlStateNormal];
                
                [self.btn14 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn14 setBackgroundColor:[UIColor clearColor]];
                [self.btn14 setTitle:@"" forState:UIControlStateNormal];

                
                [self.btn150 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn150 setBackgroundColor:[UIColor clearColor]];
                [self.btn150 setTitle:@"" forState:UIControlStateNormal];
            }
            
        }else if (model.labels.count == 3){
            TFProjLabelModel *lab1 = model.labels[0];
            TFProjLabelModel *lab2 = model.labels[1];
            TFProjLabelModel *lab3 = model.labels[2];
            if (index == 0) {
                [self.btn8 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn8 setBackgroundColor:[HQHelper colorWithHexString:lab1.labelColor]];
                [self.btn8 setTitle:[NSString stringWithFormat:@"  %@  ",lab1.labelName] forState:UIControlStateNormal];
                
                [self.btn9 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn9 setBackgroundColor:[UIColor clearColor]];
                [self.btn9 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn10 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn10 setBackgroundColor:[UIColor clearColor]];
                [self.btn10 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn11 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn11 setBackgroundColor:[UIColor clearColor]];
                [self.btn11 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn12 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn12 setBackgroundColor:[HQHelper colorWithHexString:lab2.labelColor]];
                [self.btn12 setTitle:[NSString stringWithFormat:@"  %@  ",lab2.labelName] forState:UIControlStateNormal];
                
                [self.btn13 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn13 setBackgroundColor:[HQHelper colorWithHexString:lab3.labelColor]];
                [self.btn13 setTitle:[NSString stringWithFormat:@"  %@  ",lab3.labelName] forState:UIControlStateNormal];
                
                [self.btn14 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn14 setBackgroundColor:[UIColor clearColor]];
                [self.btn14 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn150 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn150 setBackgroundColor:[UIColor clearColor]];
                [self.btn150 setTitle:@"" forState:UIControlStateNormal];
            }else if (index == 1){
                
                [self.btn8 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn8 setBackgroundColor:[HQHelper colorWithHexString:lab1.labelColor]];
                [self.btn8 setTitle:[NSString stringWithFormat:@"  %@  ",lab1.labelName] forState:UIControlStateNormal];
                
                [self.btn9 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn9 setBackgroundColor:[HQHelper colorWithHexString:lab2.labelColor]];
                [self.btn9 setTitle:[NSString stringWithFormat:@"  %@  ",lab2.labelName] forState:UIControlStateNormal];
                
                
                [self.btn10 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn10 setBackgroundColor:[UIColor clearColor]];
                [self.btn10 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn11 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn11 setBackgroundColor:[UIColor clearColor]];
                [self.btn11 setTitle:@"" forState:UIControlStateNormal];
                
                
                
                [self.btn12 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn12 setBackgroundColor:[HQHelper colorWithHexString:lab3.labelColor]];
                [self.btn12 setTitle:[NSString stringWithFormat:@"  %@  ",lab3.labelName] forState:UIControlStateNormal];
                
                [self.btn13 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn13 setBackgroundColor:[UIColor clearColor]];
                [self.btn13 setTitle:@"" forState:UIControlStateNormal];

                [self.btn14 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn14 setBackgroundColor:[UIColor clearColor]];
                [self.btn14 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn150 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn150 setBackgroundColor:[UIColor clearColor]];
                [self.btn150 setTitle:@"" forState:UIControlStateNormal];
            }else if (index == 2){
                
                [self.btn8 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn8 setBackgroundColor:[UIColor clearColor]];
                [self.btn8 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn9 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn9 setBackgroundColor:[UIColor clearColor]];
                [self.btn9 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn10 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn10 setBackgroundColor:[UIColor clearColor]];
                [self.btn10 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn11 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn11 setBackgroundColor:[UIColor clearColor]];
                [self.btn11 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn12 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn12 setBackgroundColor:[HQHelper colorWithHexString:lab1.labelColor]];
                [self.btn12 setTitle:[NSString stringWithFormat:@"  %@  ",lab1.labelName] forState:UIControlStateNormal];
                
                [self.btn13 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn13 setBackgroundColor:[HQHelper colorWithHexString:lab2.labelColor]];
                [self.btn13 setTitle:[NSString stringWithFormat:@"  %@  ",lab2.labelName] forState:UIControlStateNormal];
                
                [self.btn14 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn14 setBackgroundColor:[HQHelper colorWithHexString:lab3.labelColor]];
                [self.btn14 setTitle:[NSString stringWithFormat:@"  %@  ",lab3.labelName] forState:UIControlStateNormal];
                
                [self.btn150 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn150 setBackgroundColor:[UIColor clearColor]];
                [self.btn150 setTitle:@"" forState:UIControlStateNormal];

                
            }else{
                
                [self.btn8 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn8 setBackgroundColor:[UIColor clearColor]];
                [self.btn8 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn9 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn9 setBackgroundColor:[UIColor clearColor]];
                [self.btn9 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn10 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn10 setBackgroundColor:[UIColor clearColor]];
                [self.btn10 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn11 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn11 setBackgroundColor:[UIColor clearColor]];
                [self.btn11 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn12 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn12 setBackgroundColor:[HQHelper colorWithHexString:lab1.labelColor]];
                [self.btn12 setTitle:[NSString stringWithFormat:@"  %@  ",lab1.labelName] forState:UIControlStateNormal];
                
                [self.btn13 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn13 setBackgroundColor:[HQHelper colorWithHexString:lab2.labelColor]];
                [self.btn13 setTitle:[NSString stringWithFormat:@"  %@  ",lab2.labelName] forState:UIControlStateNormal];
                
                [self.btn14 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn14 setBackgroundColor:[HQHelper colorWithHexString:lab3.labelColor]];
                [self.btn14 setTitle:[NSString stringWithFormat:@"  %@  ",lab3.labelName] forState:UIControlStateNormal];
                
                [self.btn150 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn150 setBackgroundColor:[UIColor clearColor]];
                [self.btn150 setTitle:@"" forState:UIControlStateNormal];
            }
            
        }else{
            TFProjLabelModel *lab1 = model.labels[0];
            TFProjLabelModel *lab2 = model.labels[1];
            TFProjLabelModel *lab3 = model.labels[2];
            TFProjLabelModel *lab4 = model.labels[3];
            if (index == 0) {
                [self.btn8 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn8 setBackgroundColor:[HQHelper colorWithHexString:lab1.labelColor]];
                [self.btn8 setTitle:[NSString stringWithFormat:@"  %@  ",lab1.labelName] forState:UIControlStateNormal];
                
                [self.btn9 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn9 setBackgroundColor:[UIColor clearColor]];
                [self.btn9 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn10 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn10 setBackgroundColor:[UIColor clearColor]];
                [self.btn10 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn11 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn11 setBackgroundColor:[UIColor clearColor]];
                [self.btn11 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn12 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn12 setBackgroundColor:[HQHelper colorWithHexString:lab2.labelColor]];
                [self.btn12 setTitle:[NSString stringWithFormat:@"  %@  ",lab2.labelName] forState:UIControlStateNormal];
                
                [self.btn13 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn13 setBackgroundColor:[HQHelper colorWithHexString:lab3.labelColor]];
                [self.btn13 setTitle:[NSString stringWithFormat:@"  %@  ",lab3.labelName] forState:UIControlStateNormal];
                
                [self.btn14 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn14 setBackgroundColor:[HQHelper colorWithHexString:lab4.labelColor]];
                [self.btn14 setTitle:[NSString stringWithFormat:@"  %@  ",lab4.labelName] forState:UIControlStateNormal];
                
                [self.btn150 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn150 setBackgroundColor:[UIColor clearColor]];
                [self.btn150 setTitle:@"" forState:UIControlStateNormal];
            }else if (index == 1){
                
                [self.btn8 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn8 setBackgroundColor:[HQHelper colorWithHexString:lab1.labelColor]];
                [self.btn8 setTitle:[NSString stringWithFormat:@"  %@  ",lab1.labelName] forState:UIControlStateNormal];
                
                [self.btn9 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn9 setBackgroundColor:[HQHelper colorWithHexString:lab2.labelColor]];
                [self.btn9 setTitle:[NSString stringWithFormat:@"  %@  ",lab2.labelName] forState:UIControlStateNormal];
                
                [self.btn10 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn10 setBackgroundColor:[UIColor clearColor]];
                [self.btn10 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn11 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn11 setBackgroundColor:[UIColor clearColor]];
                [self.btn11 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn12 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn12 setBackgroundColor:[HQHelper colorWithHexString:lab3.labelColor]];
                [self.btn12 setTitle:[NSString stringWithFormat:@"  %@  ",lab3.labelName] forState:UIControlStateNormal];
                
                [self.btn13 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn13 setBackgroundColor:[HQHelper colorWithHexString:lab4.labelColor]];
                [self.btn13 setTitle:[NSString stringWithFormat:@"  %@  ",lab4.labelName] forState:UIControlStateNormal];
                
                [self.btn14 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn14 setBackgroundColor:[UIColor clearColor]];
                [self.btn14 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn150 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn150 setBackgroundColor:[UIColor clearColor]];
                [self.btn150 setTitle:@"" forState:UIControlStateNormal];
            }else if (index == 2){
                
                [self.btn8 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn8 setBackgroundColor:[HQHelper colorWithHexString:lab1.labelColor]];
                [self.btn8 setTitle:[NSString stringWithFormat:@"  %@  ",lab1.labelName] forState:UIControlStateNormal];
                
                [self.btn9 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn9 setBackgroundColor:[HQHelper colorWithHexString:lab2.labelColor]];
                [self.btn9 setTitle:[NSString stringWithFormat:@"  %@  ",lab2.labelName] forState:UIControlStateNormal];
                
                [self.btn10 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn10 setBackgroundColor:[HQHelper colorWithHexString:lab3.labelColor]];
                [self.btn10 setTitle:[NSString stringWithFormat:@"  %@  ",lab3.labelName] forState:UIControlStateNormal];
                
                [self.btn11 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn11 setBackgroundColor:[UIColor clearColor]];
                [self.btn11 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn12 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn12 setBackgroundColor:[HQHelper colorWithHexString:lab4.labelColor]];
                [self.btn12 setTitle:[NSString stringWithFormat:@"  %@  ",lab4.labelName] forState:UIControlStateNormal];
                
                [self.btn13 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn13 setBackgroundColor:[UIColor clearColor]];
                [self.btn13 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn14 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn14 setBackgroundColor:[UIColor clearColor]];
                [self.btn14 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn150 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn150 setBackgroundColor:[UIColor clearColor]];
                [self.btn150 setTitle:@"" forState:UIControlStateNormal];
                
            }else if (index == 3){
                
                [self.btn12 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn12 setBackgroundColor:[HQHelper colorWithHexString:lab1.labelColor]];
                [self.btn12 setTitle:[NSString stringWithFormat:@"  %@  ",lab1.labelName] forState:UIControlStateNormal];
                
                [self.btn13 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn13 setBackgroundColor:[HQHelper colorWithHexString:lab2.labelColor]];
                [self.btn13 setTitle:[NSString stringWithFormat:@"  %@  ",lab2.labelName] forState:UIControlStateNormal];
                
                [self.btn14 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn14 setBackgroundColor:[HQHelper colorWithHexString:lab3.labelColor]];
                [self.btn14 setTitle:[NSString stringWithFormat:@"  %@  ",lab3.labelName] forState:UIControlStateNormal];
                
                [self.btn150 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn150 setBackgroundColor:[HQHelper colorWithHexString:lab4.labelColor]];
                [self.btn150 setTitle:[NSString stringWithFormat:@"  %@  ",lab4.labelName] forState:UIControlStateNormal];
                
                [self.btn8 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn8 setBackgroundColor:[UIColor clearColor]];
                [self.btn8 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn9 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn9 setBackgroundColor:[UIColor clearColor]];
                [self.btn9 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn10 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn10 setBackgroundColor:[UIColor clearColor]];
                [self.btn10 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn11 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn11 setBackgroundColor:[UIColor clearColor]];
                [self.btn11 setTitle:@"" forState:UIControlStateNormal];
                
            }else{
                
                [self.btn8 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn8 setBackgroundColor:[UIColor clearColor]];
                [self.btn8 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn9 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn9 setBackgroundColor:[UIColor clearColor]];
                [self.btn9 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn10 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn10 setBackgroundColor:[UIColor clearColor]];
                [self.btn10 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn11 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
                [self.btn11 setBackgroundColor:[UIColor clearColor]];
                [self.btn11 setTitle:@"" forState:UIControlStateNormal];
                
                [self.btn12 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn12 setBackgroundColor:[HQHelper colorWithHexString:lab1.labelColor]];
                [self.btn12 setTitle:[NSString stringWithFormat:@"  %@  ",lab1.labelName] forState:UIControlStateNormal];
                
                [self.btn13 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn13 setBackgroundColor:[HQHelper colorWithHexString:lab2.labelColor]];
                [self.btn13 setTitle:[NSString stringWithFormat:@"  %@  ",lab2.labelName] forState:UIControlStateNormal];
                
                [self.btn14 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn14 setBackgroundColor:[HQHelper colorWithHexString:lab3.labelColor]];
                [self.btn14 setTitle:[NSString stringWithFormat:@"  %@  ",lab3.labelName] forState:UIControlStateNormal];
                
                [self.btn150 setBackgroundImage:image forState:UIControlStateNormal];
                [self.btn150 setBackgroundColor:[HQHelper colorWithHexString:lab4.labelColor]];
                [self.btn150 setTitle:[NSString stringWithFormat:@"  %@  ",lab4.labelName] forState:UIControlStateNormal];
            }
            
        }
        
    }else{
        
        [self.btn8 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
        [self.btn8 setBackgroundColor:[UIColor clearColor]];
        [self.btn8 setTitle:@"" forState:UIControlStateNormal];
        
        [self.btn9 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
        [self.btn9 setBackgroundColor:[UIColor clearColor]];
        [self.btn9 setTitle:@"" forState:UIControlStateNormal];
        
        [self.btn10 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
        [self.btn10 setBackgroundColor:[UIColor clearColor]];
        [self.btn10 setTitle:@"" forState:UIControlStateNormal];
        
        [self.btn11 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
        [self.btn11 setBackgroundColor:[UIColor clearColor]];
        [self.btn11 setTitle:@"" forState:UIControlStateNormal];
        
        [self.btn12 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
        [self.btn12 setBackgroundColor:[UIColor clearColor]];
        [self.btn12 setTitle:@"" forState:UIControlStateNormal];
        
        [self.btn13 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
        [self.btn13 setBackgroundColor:[UIColor clearColor]];
        [self.btn13 setTitle:@"" forState:UIControlStateNormal];
        
        [self.btn14 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
        [self.btn14 setBackgroundColor:[UIColor clearColor]];
        [self.btn14 setTitle:@"" forState:UIControlStateNormal];
        
        [self.btn150 setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:CGSizeZero] forState:UIControlStateNormal];
        [self.btn150 setBackgroundColor:[UIColor clearColor]];
        [self.btn150 setTitle:@"" forState:UIControlStateNormal];
    }
    
    
}



+(CGFloat)refreshTaskTableViewCellHeightWithModel:(TFProjTaskModel *)model type:(NSInteger)type{
    
    CGFloat height = 15;// 上边距
    
    // 标题
    CGSize contentSize = [HQHelper sizeWithFont:FONT(18) maxSize:(CGSize){SCREEN_WIDTH-TotalMargin,MAXFLOAT} titleStr:model.title];
    height += contentSize.height;
    
    // 有小图标
    if ((model.activeCount && [model.activeCount integerValue] != 0)
        || (model.deadline && ![model.deadline isEqualToNumber:@0])
        || (model.descript && ![model.descript isEqualToString:@""])
        || (model.fileCount && ![model.fileCount isEqualToNumber:@0])
        || (model.subTaskCount && ![model.subTaskCount isEqualToNumber:@0])
        || (model.isPublic && ![model.isPublic isEqualToNumber:@0])) {
        
        height += 15;// 距离文字间距
        height += 13;// 本身高度
    }
    
    // 摆放标签
    if (model.labels.count) {
        
        
        CGFloat sur = SCREEN_WIDTH - TotalMargin - 30 - 15;
        
        if (type == 1) {
            sur += 40;
        }
        
        CGFloat puls = 0;
        NSString *str = @"";
        NSInteger index = -1;
        
        for (NSInteger i = 0; i < model.labels.count; i ++) {
            
            TFProjLabelModel *label = model.labels[i];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"  %@  ",label.labelName]];
            CGSize size = [HQHelper sizeWithFont:FONT(10) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:str];
            puls = (size.width + 8);
            
            if (sur <= puls) {
                break;
            }
            index ++;
        }
        
        if (model.labels.count == 1) {
        
            // 与头像同行
            
        }else if (model.labels.count == 2){
            
            if (index == 0) {
                
                height += 15;// 标签上边距
                height += 20;// 标签本身高度
                
            }else if (index == 1) {
                
                // 与头像同行
                
            }else{
                
                // 与头像同行
            }
            
        }else if (model.labels.count == 3){
            
            if (index == 0) {
                
                height += 15;// 标签上边距
                height += 20;// 标签本身高度
                
            }else if (index == 1) {
                
                height += 15;// 标签上边距
                height += 20;// 标签本身高度
                
            }else if (index == 2) {
                
                // 与头像同行
                
            }else{
                
                // 与头像同行
            }
            
        }else{
            if (index == 0) {
                
                height += 15;// 标签上边距
                height += 20;// 标签本身高度
                
            }else if (index == 1) {
                
                height += 15;// 标签上边距
                height += 20;// 标签本身高度
                
            }else if (index == 2) {
                
                height += 15;// 标签上边距
                height += 20;// 标签本身高度
                
            }else if (index == 3) {
                
                // 与头像同行
                
            }else{
                
                // 与头像同行
            }
        }
        
        height += 14;// 头像上边距
        height += 30;// 头像本身高度
       
    }else{
        
       // 此处无标签
#warning 此处没有没有考虑小图标与头像同一行重合情况
        height += 14;// 头像上边距
    }
    
    
    
    height += 25;// 底部间距
    
    return height;
}


- (void)finishBtnClick:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(taskTableViewCell:didFinishBtn:withModel:)]) {
        [self.delegate taskTableViewCell:self didFinishBtn:button withModel:self.model];
    }
    
}
- (void)downBtnClick:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(taskTableViewCell:didDownBtnWithModel:)]) {
        [self.delegate taskTableViewCell:self didDownBtnWithModel:self.model];
    }
}

+ (instancetype)taskTableViewCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFTaskTableViewCell" owner:self options:nil] lastObject];
}

+ (HQTFTaskTableViewCell *)taskTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFTaskTableViewCell";
    HQTFTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self taskTableViewCell];
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
