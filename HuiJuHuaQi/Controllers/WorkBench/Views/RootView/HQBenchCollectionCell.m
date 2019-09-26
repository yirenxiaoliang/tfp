//
//  HQBenchCollectionCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/6/29.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBenchCollectionCell.h"


@interface HQBenchCollectionCell ()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *image;
/** 名字 */
@property (weak, nonatomic) IBOutlet UILabel *name;
/** 提示数字 */
@property (weak, nonatomic) IBOutlet UILabel *tipLable;
/** 提示数字宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipWidth;
/** Image宽 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
/** Image高 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet UIView *bgView;    

/** module */
@property (nonatomic, strong) TFModuleModel *module;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHeightW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;

@end


@implementation HQBenchCollectionCell


- (IBAction)minusClick:(UIButton *)sender {
    
    //删除功能
    NSMutableDictionary *clickDict = [NSMutableDictionary dictionary];
    
    [clickDict setObject:@(self.type) forKey:@"TYPE"];
    
    if (self.module) {
        [clickDict setObject:self.module forKey:@"MODULE"];
    }
    
    if (self.type == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:deleteCell object:self userInfo:clickDict];
    }else if (self.type == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:addCell object:self userInfo:clickDict];
    }
    
    
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.name.backgroundColor = [UIColor clearColor];
    self.image.backgroundColor = [UIColor clearColor];
    self.name.font = FONT(14);
    self.name.textColor = LightBlackTextColor;
    self.image.contentMode = UIViewContentModeCenter;
    self.name.textAlignment = NSTextAlignmentCenter;
    self.name.numberOfLines = 0;
    
    self.tipLable.textAlignment = NSTextAlignmentCenter;
    self.tipLable.font = FONT(16);
    self.tipLable.textColor = WhiteColor;
    self.tipLable.backgroundColor = RedColor;
    self.minusButton.hidden = YES;
    self.minusButton.contentMode = UIViewContentModeScaleAspectFit;
    [self.minusButton setTitle:@"" forState:UIControlStateNormal];
    [self.minusButton setTitle:@"" forState:UIControlStateHighlighted];
    

    self.imageWidth.constant = Long(50);
    self.imageWidth.constant = Long(50);
    self.bgView.backgroundColor = [UIColor clearColor];
}

- (void)setType:(NSInteger)type{
    _type = type;
    
    if (type == 0) {
        [self.minusButton setImage:[UIImage imageNamed:@"新增"] forState:UIControlStateNormal];
        [self.minusButton setImage:[UIImage imageNamed:@"新增"] forState:UIControlStateNormal];
        self.bgView.layer.borderColor = CellClickColor.CGColor;
        self.bgView.layer.borderWidth = 0.5;
        self.minusButton.hidden = NO;
    }else if (type == 1) {
        [self.minusButton setImage:[UIImage imageNamed:@"移除"] forState:UIControlStateNormal];
        [self.minusButton setImage:[UIImage imageNamed:@"移除"] forState:UIControlStateNormal];
        self.bgView.layer.borderColor = CellClickColor.CGColor;
        self.bgView.layer.borderWidth = 0.5;
        self.minusButton.hidden = NO;
    }else if (type == 3){
        [self.minusButton setImage:[UIImage imageNamed:@"移动"] forState:UIControlStateNormal];
        [self.minusButton setImage:[UIImage imageNamed:@"移动"] forState:UIControlStateNormal];
        self.bgView.layer.borderColor = CellClickColor.CGColor;
        self.bgView.layer.borderWidth = 0.5;
        
        self.minusButton.hidden = NO;
    }else if (type == 2){
        
        self.minusButton.hidden = YES;
        self.bgView.layer.borderColor = CellClickColor.CGColor;
        self.bgView.layer.borderWidth = 0.0;
    }
}

- (void)setRootModel:(HQRootModel *)rootModel{
    
    _rootModel = rootModel;
//    self.minusButton.hidden = YES;
    
    [self.image setImage:[UIImage imageNamed:rootModel.image]];
    [self.name setText:rootModel.name];
    
    switch (rootModel.functionModelType) {
            
        case FunctionModelTypeTask:
        {
            /** 任务数量优先，然后逾期数量，两者全没有就隐藏 */
            // 任务中心
            if (rootModel.markNum) {
                self.tipLable.hidden = NO;
                
                if (rootModel.markNum >99) {
                    self.tipLable.text = [NSString stringWithFormat:@"%d+", 99];
                }else{
                    self.tipLable.text = [NSString stringWithFormat:@"%ld", rootModel.markNum];
                }
                
                self.tipLable.layer.cornerRadius = self.tipLable.height * 0.5;
                self.tipLable.layer.masksToBounds = YES;
                
                // 计算提醒数字宽度
                if (self.tipLable.text.length == 3) {
                    self.tipWidth.constant = 30;
                }else if (self.tipLable.text.length == 2 ) {
                    self.tipWidth.constant = 25;
                }else{
                    self.tipWidth.constant = 20;
                }
                
            }else{
                if (rootModel.OutDate) {// 逾期数量
                    self.tipLable.text = @"逾";
                    self.tipLable.hidden = NO;
                    
                    self.tipLable.layer.cornerRadius = self.tipLable.height * 0.5;
                    self.tipLable.layer.masksToBounds = YES;
                    // 计算提醒数字宽度
                    self.tipWidth.constant = 20;
                    
                }else{
                    self.tipLable.hidden = YES;
                }
            }
            
        }
            break;
            
        case FunctionModelTypeApproval:
        {
            // 审批中心
            if (rootModel.markNum) {
                
                self.tipLable.hidden = NO;
                
                if (rootModel.markNum >99) {
                    self.tipLable.text = [NSString stringWithFormat:@"%d+", 99];
                }else{
                    self.tipLable.text = [NSString stringWithFormat:@"%ld", rootModel.markNum];
                }
                
                self.tipLable.layer.cornerRadius = self.tipLable.height * 0.5;
                self.tipLable.layer.masksToBounds = YES;
                
                // 计算提醒数字
                if (self.tipLable.text.length == 3) {
                    self.tipWidth.constant = 30;
                }else if (self.tipLable.text.length == 2 ) {
                    self.tipWidth.constant = 25;
                }else{
                    self.tipWidth.constant = 20;
                }
                
                
            }else{
                self.tipLable.hidden = YES;
            }
            
            
        }
            break;
            
        case FunctionModelTypeSchedule:
        {
            // 日程中心
            if (rootModel.markNum) {
                self.tipLable.hidden = NO;
                if (rootModel.markNum >99) {
                    self.tipLable.text = [NSString stringWithFormat:@"%d+", 99];
                }else{
                    self.tipLable.text = [NSString stringWithFormat:@"%ld",rootModel.markNum];
                }
                self.tipLable.layer.cornerRadius = self.tipLable.height * 0.5;
                self.tipLable.layer.masksToBounds = YES;
                
                // 计算提醒数字
                if (self.tipLable.text.length == 3) {
                    self.tipWidth.constant = 30;
                }else if (self.tipLable.text.length == 2 ) {
                    self.tipWidth.constant = 25;
                }else{
                    self.tipWidth.constant = 20;
                }
                
                
            }else{
                self.tipLable.hidden = YES;
            }
            
            
        }
            break;
        case FunctionModelTypeReport:
        {
            // 工作报告
            if (rootModel.markNum) {
                self.tipLable.hidden = NO;
                if (rootModel.markNum >99) {
                    self.tipLable.text = [NSString stringWithFormat:@"%d+",99];
                }else{
                    self.tipLable.text = [NSString stringWithFormat:@"%ld", rootModel.markNum];
                }
                self.tipLable.layer.cornerRadius = self.tipLable.height * 0.5;
                self.tipLable.layer.masksToBounds = YES;
                
                // 计算提醒数字
                if (self.tipLable.text.length == 3) {
                    self.tipWidth.constant = 30;
                }else if (self.tipLable.text.length == 2 ) {
                    self.tipWidth.constant = 25;
                }else{
                    self.tipWidth.constant = 20;
                }
                
            }else{
                self.tipLable.hidden = YES;
            }
            
        }
            break;
            
        case FunctionModelTypeAdvice:
        {
            // 投诉建议
            if (rootModel.markNum) {
                self.tipLable.hidden = NO;
                if (rootModel.markNum >99) {
                    self.tipLable.text = [NSString stringWithFormat:@"%d+",99];
                }else{
                    self.tipLable.text = [NSString stringWithFormat:@"%ld", rootModel.markNum];
                }
                self.tipLable.layer.cornerRadius = self.tipLable.height * 0.5;
                self.tipLable.layer.masksToBounds = YES;
                
                // 计算提醒数字
                if (self.tipLable.text.length == 3) {
                    self.tipWidth.constant = 30;
                }else if (self.tipLable.text.length == 2 ) {
                    self.tipWidth.constant = 25;
                }else{
                    self.tipWidth.constant = 20;
                }
                
            }else{
                self.tipLable.hidden = YES;
            }
            
        }
            break;
            
        case FunctionModelTypeSubscribe:
        {
            // 考勤中心
            self.tipLable.hidden = YES;
        }
            break;
            
        case FunctionModelTypeDocument:
        {
            // 收藏夹
            self.tipLable.hidden = YES;
        }
            break;
        case FunctionModelTypeCrm:
        {
            // CRM
            self.tipLable.hidden = YES;
        }
            break;
        case FunctionModelTypeMore:
        {
            // 更多
            self.tipLable.hidden = YES;
        }
            break;
        case FunctionModelTypePrejectPartner:
        {
            // 项目
            self.tipLable.hidden = YES;
        }
            break;
        case FunctionModelTypeNotice:
        {
            // 公告
            self.tipLable.hidden = YES;
        }
            break;
        case FunctionModelTypeUrgent:
        {
            // 紧急事务
            self.tipLable.hidden = YES;
        }
            break;
            
        default:
            self.tipLable.hidden = YES;
            break;
    }
    
}

/** ************************自定义********************** */
/** 刷新 */
-(void)refreshCellWithModel:(TFModuleModel *)model{
    
    self.module = model;
    
    self.tipLable.hidden = YES;
    
    [self.image setImage:[UIImage imageNamed:model.icon]?:PlaceholderHeadImage];
    
    [self.name setText:model.chinese_name];
    
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:model.chinese_name];
    
    if (size.width > ((SCREEN_WIDTH - 50) / 4.0 -16)) {
        
        self.nameHeightW.constant = 36;
        self.name.font = FONT(12);
        self.topMargin.constant = -10;
        
    }else{
        self.nameHeightW.constant = 20;
        self.name.font = FONT(14);
        self.topMargin.constant = 0;
    }
    
}



@end
