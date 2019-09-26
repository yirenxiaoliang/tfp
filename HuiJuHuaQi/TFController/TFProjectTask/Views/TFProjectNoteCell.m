//
//  TFProjectNoteCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectNoteCell.h"

@interface TFProjectNoteCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *remainBtn;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgT;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@end

@implementation TFProjectNoteCell

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
    
    self.headBtn.userInteractionEnabled = NO;
    self.headBtn.layer.masksToBounds = YES;
    self.headBtn.layer.cornerRadius = 14;
    self.headBtn.titleLabel.font = FONT(11);
    [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    
    self.shareBtn.userInteractionEnabled = NO;
    self.remainBtn.userInteractionEnabled = NO;
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
    if ([self.delegate respondsToSelector:@selector(projectNoteCellDidClickedClearBtn:)]) {
        [self.delegate projectNoteCellDidClickedClearBtn:self];
    }
}

-(void)setKnowledge:(NSInteger)knowledge{
    _knowledge = knowledge;
    
    if (knowledge == 1) {
        
//        self.bgT.constant = 15;
//        self.bgH.constant = 15;
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
    if (edit) {
        [self.clearBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@30);
        }];
    }else{
        [self.clearBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    }
    
}

+ (instancetype)projectNoteCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFProjectNoteCell" owner:self options:nil] lastObject];
}

+ (TFProjectNoteCell *)projectNoteCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFProjectNoteCell";
    TFProjectNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self projectNoteCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setFrameModel:(TFProjectRowFrameModel *)frameModel{
    
    _frameModel = frameModel;
    TFProjectRowModel *model = frameModel.projectRow;
    
    
    self.nameLabel.text = model.title;
    
    self.timeLabel.text = [HQHelper nsdateToTime:[model.create_time longLongValue] formatStr:@"MM-dd HH:mm"];
    
    
    //有共享人，或者创建人不为自己
    if ((![model.share_ids isEqualToString:@""] && model.share_ids != nil) || ![model.create_by isEqualToNumber:UM.userLoginInfo.employee.id]) {
        
        [self.shareBtn setImage:IMG(@"备忘录共享蓝") forState:UIControlStateNormal];
    }
    else {
        
        [self.shareBtn setImage:IMG(@"") forState:UIControlStateNormal];
    }
    
    if ([model.remind_time integerValue] > 0) {
        
        [self.remainBtn setImage:IMG(@"备忘录铃铛") forState:UIControlStateNormal];
    }
    else {
        
        [self.remainBtn setImage:IMG(@"") forState:UIControlStateNormal];
    }
    
    if (model.createObj) {
        [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.createObj.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image) {
                [self.headBtn setTitle:@"" forState:UIControlStateNormal];
            }else{
                
                [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
                [self.headBtn setTitle:[HQHelper nameWithTotalName:model.createObj.employee_name] forState:UIControlStateNormal];
                [self.headBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                self.headBtn.titleLabel.font = FONT(12);
                
            }
            
        }];
    }else{
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
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
