//
//  HQTFLabelCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFLabelCell.h"

@interface HQTFLabelCell ()
@property (weak, nonatomic) IBOutlet UIButton *labelBtn;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIButton *handleBtn1;
@property (weak, nonatomic) IBOutlet UIButton *handleBtn2;
@property (weak, nonatomic) IBOutlet UIButton *handleBtn3;

/** LabelCellType */
@property (nonatomic, assign) LabelCellType type;

/** labelModel */
@property (nonatomic, strong) TFProjLabelModel *labelModel;
/** noticeModel */
@property (nonatomic, strong) TFNoticeCategoryModel *noticeModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelH;

@end

@implementation HQTFLabelCell


-(void)awakeFromNib{
    
    [super awakeFromNib];
    [self.labelBtn setBackgroundImage:[UIImage imageNamed:@"标签切图"] forState:UIControlStateNormal];
    self.labelBtn.userInteractionEnabled = NO;
    
    self.labelName.textColor = ExtraLightBlackTextColor;
    self.labelName.font = FONT(16);
    
    self.handleBtn1.tag = 0x121;
    self.handleBtn2.tag = 0x122;
    self.handleBtn3.tag = 0x123;
    
    [self.handleBtn1 addTarget:self action:@selector(handleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.handleBtn2 addTarget:self action:@selector(handleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.handleBtn3 addTarget:self action:@selector(handleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.handleBtn1.backgroundColor = ClearColor;
    self.handleBtn2.backgroundColor = ClearColor;
    self.handleBtn3.backgroundColor = ClearColor;
}

- (void)handleBtnClicked:(UIButton *)button{
    
    switch (button.tag - 0x121) {
        case 0:
        {
            if (self.type == LabelCellTypeOnlyStar) {
//                button.selected = !button.selected;
                
                if ([self.delegate respondsToSelector:@selector(labelCell:didClickedStarBtnWithModel:)]) {
                    [self.delegate labelCell:self didClickedStarBtnWithModel:self.labelModel];
                }
            }
            
            if (self.type == LabelCellTypeThreeAll) {
                if ([self.delegate respondsToSelector:@selector(labelCell: didClickedDeleteBtnWithModel:)]) {
                    [self.delegate labelCell:self didClickedDeleteBtnWithModel:self.labelModel];
                }
            }
            
            if (self.type == LabelCellTypeEditAndDelete) {
                if ([self.delegate respondsToSelector:@selector(labelCell: didClickedDeleteBtnWithNoticeModel:)]) {
                    [self.delegate labelCell:self didClickedDeleteBtnWithNoticeModel:self.noticeModel];
                }
            }
        }
            break;
        case 1:
        {
            if (self.type == LabelCellTypeThreeAll) {
                if ([self.delegate respondsToSelector:@selector(labelCellDidClickedEditBtnWithModel:)]) {
                    [self.delegate labelCellDidClickedEditBtnWithModel:self.labelModel];
                }
            }
            if (self.type == LabelCellTypeEditAndDelete) {
                if ([self.delegate respondsToSelector:@selector(labelCellDidClickedEditBtnWithNoticeModel:)]) {
                    [self.delegate labelCellDidClickedEditBtnWithNoticeModel:self.noticeModel];
                }
            }
        }
            break;
        case 2:
        {
            if (self.type == LabelCellTypeThreeAll) {
//                button.selected = !button.selected;
                
                if ([self.delegate respondsToSelector:@selector(labelCell: didClickedStarBtnWithModel:)]) {
                    [self.delegate labelCell:self didClickedStarBtnWithModel:self.labelModel];
                }

            }
        }
            break;
            
        default:
            break;
    }
    
}

-(void)setType:(LabelCellType)type{
    
    _type = type;
    
    switch (type) {
        case LabelCellTypeNothing:
        {
            
            [self.handleBtn1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.handleBtn1 setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
            
            self.handleBtn1.hidden = NO;
            self.handleBtn2.hidden = YES;
            self.handleBtn3.hidden = YES;
            self.handleBtn1.userInteractionEnabled = NO;
            self.handleBtn2.userInteractionEnabled = NO;
            self.handleBtn3.userInteractionEnabled = NO;
        }
            break;
        case LabelCellTypeThreeAll:
        {
            
            self.handleBtn1.hidden = NO;
            self.handleBtn2.hidden = NO;
            self.handleBtn3.hidden = NO;
            [self.handleBtn1 setImage:[UIImage imageNamed:@"回收站20"] forState:UIControlStateNormal];
            [self.handleBtn1 setImage:[UIImage imageNamed:@"回收站20"] forState:UIControlStateHighlighted];
            
            
            [self.handleBtn2 setImage:[UIImage imageNamed:@"编辑20"] forState:UIControlStateNormal];
            [self.handleBtn2 setImage:[UIImage imageNamed:@"编辑20"] forState:UIControlStateHighlighted];
            
            [self.handleBtn3 setImage:[UIImage imageNamed:@"收藏20"] forState:UIControlStateNormal];
            [self.handleBtn3 setImage:[UIImage imageNamed:@"收藏20"] forState:UIControlStateHighlighted];
            [self.handleBtn3 setImage:[UIImage imageNamed:@"收藏有20"] forState:UIControlStateSelected];
        }
            break;
        case LabelCellTypeEditAndDelete:
        {
            
            self.handleBtn1.hidden = NO;
            self.handleBtn2.hidden = NO;
            self.handleBtn3.hidden = YES;
            [self.handleBtn1 setImage:[UIImage imageNamed:@"回收站20"] forState:UIControlStateNormal];
            [self.handleBtn1 setImage:[UIImage imageNamed:@"回收站20"] forState:UIControlStateHighlighted];
            
            
            [self.handleBtn2 setImage:[UIImage imageNamed:@"编辑20"] forState:UIControlStateNormal];
            [self.handleBtn2 setImage:[UIImage imageNamed:@"编辑20"] forState:UIControlStateHighlighted];
            
        }
            break;
        case LabelCellTypeOnlyStar:
        {
            
            
            self.handleBtn1.hidden = NO;
            self.handleBtn2.hidden = YES;
            self.handleBtn3.hidden = YES;
            
            [self.handleBtn1 setImage:[UIImage imageNamed:@"收藏20"] forState:UIControlStateNormal];
            [self.handleBtn1 setImage:[UIImage imageNamed:@"收藏20"] forState:UIControlStateHighlighted];
            [self.handleBtn1 setImage:[UIImage imageNamed:@"收藏有20"] forState:UIControlStateSelected];
        }
            break;
        case LabelCellTypeSelect:
        {
            
            [self.handleBtn1 setImage:[UIImage imageNamed:@"完成30"] forState:UIControlStateNormal];
            [self.handleBtn1 setImage:[UIImage imageNamed:@"完成30"] forState:UIControlStateHighlighted];
            
            self.handleBtn1.hidden = NO;
            self.handleBtn2.hidden = YES;
            self.handleBtn3.hidden = YES;
            
            self.handleBtn1.userInteractionEnabled = NO;
            self.handleBtn2.userInteractionEnabled = NO;
            self.handleBtn3.userInteractionEnabled = NO;
        }
            break;
        default:
            break;
    }
    
}

-(void)refreshLabelCellWithModel:(TFProjLabelModel *)model{
    self.labelModel = model;
    
    self.labelBtn.backgroundColor = [HQHelper colorWithHexString:model.labelColor];
    
    self.labelName.text = model.labelName;
    
    self.handleBtn3.selected = [model.labelStatus integerValue]==0?NO:YES;
}


/** 刷新通知分类 */
- (void)refreshNoticeCellWithModel:(TFNoticeCategoryModel *)model{
    self.noticeModel = model;
    if (model.color) {
        self.labelBtn.backgroundColor = [HQHelper colorWithHexString:model.color];
    }else{
        self.labelBtn.backgroundColor = GreenColor;
    }
    self.labelBtn.contentMode = UIViewContentModeCenter;
    self.labelBtn.imageView.contentMode = UIViewContentModeCenter;
    self.labelBtn.layer.cornerRadius = 2;
    self.labelBtn.layer.masksToBounds = YES;
    self.labelName.text = model.typeName;
    [self.labelBtn setBackgroundImage:[UIImage imageNamed:@"公告item"] forState:UIControlStateNormal];
    
//    if ([model.type isEqualToNumber:@1]) {
//        self.type = LabelCellTypeNothing;
//    }else{
//        self.type = LabelCellTypeEditAndDelete;
//    }
    
}


+ (instancetype)labelCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFLabelCell" owner:self options:nil] lastObject];
}

+ (HQTFLabelCell *)labelCellWithTableView:(UITableView *)tableView withType:(LabelCellType)type
{
    static NSString *indentifier = @"HQTFLabelCell";
    HQTFLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self labelCell];
    }
    
    cell.type = type;
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
