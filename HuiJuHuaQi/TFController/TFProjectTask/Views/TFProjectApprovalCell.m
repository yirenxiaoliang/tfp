//
//  TFProjectApprovalCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectApprovalCell.h"

@interface TFProjectApprovalCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *statuesLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgT;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clearW;

@end

@implementation TFProjectApprovalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius = 4;
    self.bgView.backgroundColor = WhiteColor;
    self.bgView.layer.shadowColor = LightGrayTextColor.CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView.layer.shadowRadius = 4;
    self.bgView.layer.shadowOpacity = 0.5;
    
    
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.font = FONT(14);
    self.nameLabel.textColor = BlackTextColor;
    
    
    self.timeLabel.font = FONT(12);
    self.timeLabel.textColor = LightGrayTextColor;
    
    self.statuesLabel.textColor = WhiteColor;
    self.statuesLabel.font = FONT(12);
    self.statuesLabel.layer.cornerRadius = 9;
    self.statuesLabel.layer.masksToBounds = YES;
    
    
    self.headBtn.userInteractionEnabled = NO;
    self.headBtn.layer.masksToBounds = YES;
    self.headBtn.layer.cornerRadius = 14;
    self.headBtn.titleLabel.font = FONT(11);
    [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.clearBtn.hidden = YES;
    
    self.backgroundColor = ClearColor;
    
    UIImageView *selectImage = [[UIImageView alloc] initWithImage:IMG(@"完成")];
    self.selectImage = selectImage;
    [self.bgView addSubview:selectImage];
    [selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.top.equalTo(self.bgView);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    selectImage.hidden = YES;
}
- (IBAction)clearClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(projectApprovalCellDidClickedClearBtn:)]) {
        [self.delegate projectApprovalCellDidClickedClearBtn:self];
    }
}

-(void)setKnowledge:(NSInteger)knowledge{
    _knowledge = knowledge;
    
    if (knowledge == 1) {
        
//        self.bgH.constant = 15;
//        self.bgT.constant = 15;
        self.contentView.backgroundColor = WhiteColor;
        self.backgroundColor = WhiteColor;
        self.bgView.backgroundColor = WhiteColor;
        self.bgView.layer.shadowColor = LightGrayTextColor.CGColor;
        self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
        self.bgView.layer.shadowRadius = 4;
        self.bgView.layer.shadowOpacity = 0.5;
    }else if (knowledge == 2){
        
//        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView).offset(5);
//            make.bottom.equalTo(self.contentView).offset(-5);
//            make.left.equalTo(self.contentView).offset(15);
//            make.right.equalTo(self.contentView).offset(-15);
//        }];
        self.contentView.backgroundColor = WhiteColor;
        self.backgroundColor = WhiteColor;
        self.bgView.backgroundColor = BackGroudColor;
        //        self.bgView.layer.shadowColor = HexColor(0xd5d5d5).CGColor;
        //        self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
        //        self.bgView.layer.shadowRadius = 0;
        //        self.bgView.layer.shadowOpacity = 1;
        
    }
}
-(void)setEdit:(BOOL)edit{
    _edit = edit;
    self.clearBtn.hidden = !edit;
    self.clearW.constant = edit ? 30 : 0;
    
}

+ (instancetype)projectApprovalCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFProjectApprovalCell" owner:self options:nil] lastObject];
}

+ (TFProjectApprovalCell *)projectApprovalCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFProjectApprovalCell";
    TFProjectApprovalCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self projectApprovalCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setFrameModel:(TFProjectRowFrameModel *)frameModel{
    
    _frameModel = frameModel;
    TFProjectRowModel *model = frameModel.projectRow;
//    self.nameLabel.backgroundColor = RedColor;
    if ([model.dataType isEqualToNumber:@4]) {
        self.statusW.constant = 56;
        self.iconImage.image = IMG(@"项目-审批");
        self.statuesLabel.hidden = NO;
        
        self.nameLabel.text = [NSString stringWithFormat:@"%@-%@",model.begin_user_name,model.process_name];
        
        // 0待审批 1审批中 2审批通过 3审批驳回 4已撤销 5流程结束 6待提交
        if ([model.process_status isEqualToNumber:@0]) {
            
            self.statuesLabel.backgroundColor = HexColor(0xF7981C);
            self.statuesLabel.text = @"待审批";
            
        }else if ([model.process_status isEqualToNumber:@1]) {
            
            self.statuesLabel.backgroundColor = HexColor(0x549AFF);
            self.statuesLabel.text = @"审批中";
            
        }else if ([model.process_status isEqualToNumber:@2]) {
            
            self.statuesLabel.backgroundColor = HexColor(0x3CBB81);
            self.statuesLabel.text = @"审批通过";
            
            
        }else if ([model.process_status isEqualToNumber:@4]) {
            
            self.statuesLabel.backgroundColor = GrayTextColor;
            self.statuesLabel.text = @"审批撤销";
            
            
        }else if ([model.process_status isEqualToNumber:@3]) {
            
            self.statuesLabel.backgroundColor = RedColor;
            self.statuesLabel.text = @"审批驳回";
            
            
        }else if ([model.process_status isEqualToNumber:@6]) {
            
            self.statuesLabel.backgroundColor = GrayTextColor;
            self.statuesLabel.text = @"待提交";
            
        }
        
        [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image) {
                [self.headBtn setTitle:@"" forState:UIControlStateNormal];
            }else{
                
                [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
                [self.headBtn setTitle:[HQHelper nameWithTotalName:model.begin_user_name] forState:UIControlStateNormal];
                [self.headBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                self.headBtn.titleLabel.font = FONT(12);
                
            }
            
        }];
        
        self.timeLabel.text = [NSString stringWithFormat:@"申请时间：%@",[HQHelper nsdateToTime:[model.create_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"]];
    }
    
    if ([model.dataType isEqualToNumber:@5]) {
        
        self.statusW.constant = 0;
        self.iconImage.image = IMG(@"邮件");
        self.statuesLabel.hidden = YES;
        [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [self.headBtn setTitle:[HQHelper nameWithTotalName:model.from_recipient] forState:UIControlStateNormal];
        [self.headBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
        self.headBtn.titleLabel.font = FONT(12);
        
        self.nameLabel.text = model.subject;
        self.timeLabel.text = [HQHelper nsdateToTime:[model.create_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
