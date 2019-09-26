//
//  TFProjectTaskItemCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectTaskItemCell.h"
#import "TFTagListView.h"

@interface TFProjectTaskItemCell ()

/** UIView *bgView */
@property (nonatomic, weak) UIView *bgView;

/** UIImageView *urgeView */
@property (nonatomic, weak) UIImageView *urgeView;

/** UIButton *selectBtn */
@property (nonatomic, weak) UIButton *selectBtn;

/** UILabel *titleLabel */
@property (nonatomic, weak) UILabel *titleLabel;

/** UIButton *activeBtn */
@property (nonatomic, weak) UIButton *activeBtn;

/** UIButton *endTimeBtn */
@property (nonatomic, weak) UIButton *endTimeBtn;

/** UIButton *overBtn */
@property (nonatomic, weak) UIButton *overBtn;

/** UIButton *childTaskBtn */
@property (nonatomic, weak) UIButton *childTaskBtn;

/** UIButton *headBtn */
@property (nonatomic, weak) UIButton *headBtn;

/** TFTagListView *tagListView */
@property (nonatomic, weak) TFTagListView *tagListView;

/** UIImageView *checkView */
@property (nonatomic, weak) UIImageView *checkView;

@property (nonatomic, weak) UIButton *clearBtn;

@end

@implementation TFProjectTaskItemCell

+(instancetype)projectTaskItemCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFProjectTaskItemCell";
    TFProjectTaskItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TFProjectTaskItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupChildView];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *bgView = [[UIView alloc] init];
    [self.contentView addSubview:bgView];
    bgView.layer.cornerRadius = 4;
    bgView.backgroundColor = WhiteColor;
    bgView.layer.shadowColor = CellSeparatorColor.CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0, 0);
    bgView.layer.shadowRadius = 2;
    bgView.layer.shadowOpacity = 0.3;
    self.bgView = bgView;
    
    UIImageView *urgeView = [[UIImageView alloc] init];
    [bgView addSubview:urgeView];
    urgeView.contentMode = UIViewContentModeScaleToFill;
    self.urgeView = urgeView;
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:selectBtn];
    [selectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"taskSelect"] forState:UIControlStateSelected];
    [selectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateDisabled];
    [selectBtn setBackgroundImage:[HQHelper createImageWithColor:GrayTextColor] forState:UIControlStateDisabled];
    [selectBtn setBackgroundImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateSelected];
    self.selectBtn = selectBtn;
    [selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    UILabel *titleLabel = [[UILabel alloc] init];
    [bgView addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    titleLabel.font = FONT(14);
    titleLabel.textColor = BlackTextColor;
    self.titleLabel = titleLabel;
    self.titleLabel = titleLabel;
    
    
    UIButton *activeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:activeBtn];
    activeBtn.userInteractionEnabled = NO;
    [activeBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0xf5a623)] forState:UIControlStateNormal];
    [activeBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    activeBtn.titleLabel.font = FONT(10);
    self.activeBtn = activeBtn;
    
    
    UIButton *endTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:endTimeBtn];
    endTimeBtn.userInteractionEnabled = NO;
    endTimeBtn.titleLabel.font = FONT(12);
    self.endTimeBtn = endTimeBtn;
//    endTimeBtn.backgroundColor = RedColor;
    
    
    UIButton *overBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:overBtn];
    overBtn.userInteractionEnabled = NO;
    overBtn.layer.masksToBounds = YES;
    overBtn.layer.cornerRadius = 2;
    [overBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0xe8e8e8)] forState:UIControlStateNormal];
    [overBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
    overBtn.titleLabel.font = FONT(10);
    self.overBtn = overBtn;
    
    
    UIButton *childTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:childTaskBtn];
    childTaskBtn.userInteractionEnabled = NO;
    childTaskBtn.titleLabel.font = FONT(12);
    [childTaskBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    self.childTaskBtn = childTaskBtn;
//    childTaskBtn.backgroundColor = RedColor;
    
    
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:headBtn];
    headBtn.userInteractionEnabled = NO;
    headBtn.layer.masksToBounds = YES;
    headBtn.layer.cornerRadius = 14;
    headBtn.titleLabel.font = FONT(12);
    [headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.headBtn = headBtn;
    
    TFTagListView *tagListView = [[TFTagListView alloc] init];
    [bgView addSubview:tagListView];
    self.tagListView = tagListView;
    tagListView.layer.masksToBounds = YES;
    
    UIImageView *checkView = [[UIImageView alloc] init];
    [bgView addSubview:checkView];
    checkView.image = [UIImage imageNamed:@"待检验"];
    self.checkView = checkView;
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:clearBtn];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(5);
        make.right.equalTo(bgView).offset(-5);
        make.height.width.equalTo(@20);
    }];
    clearBtn.hidden = YES;
    self.clearBtn = clearBtn;
    clearBtn.contentMode = UIViewContentModeScaleToFill;
    clearBtn.imageView.contentMode = UIViewContentModeScaleToFill;
    [clearBtn setImage:IMG(@"关闭") forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentView.backgroundColor = ClearColor;
    self.backgroundColor = ClearColor;
    
    UIImageView *selectImage = [[UIImageView alloc] initWithImage:IMG(@"完成")];
    self.selectImage = selectImage;
    [bgView addSubview:selectImage];
    [selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView);
        make.top.equalTo(bgView);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    selectImage.hidden = YES;
}

-(void)clearClicked{
    if ([self.delegate respondsToSelector:@selector(projectTaskItemCellDidClickedClearBtn:)]) {
        [self.delegate projectTaskItemCellDidClickedClearBtn:self];
    }
}

- (void)selectBtnClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(projectTaskItemCell:didClickedFinishBtnWithModel:)]) {
        [self.delegate projectTaskItemCell:self didClickedFinishBtnWithModel:_frameModel.projectRow];
    }
}

-(void)setKnowledge:(NSInteger)knowledge{
    _knowledge = knowledge;
    
    if (knowledge == 1) {
        
//        self.bgView.frame = CGRectMake(15, _frameModel.bgViewFrame.origin.y, SCREEN_WIDTH-30, _frameModel.bgViewFrame.size.height);
        self.contentView.backgroundColor = WhiteColor;
        self.backgroundColor = WhiteColor;
        self.bgView.backgroundColor = WhiteColor;
        self.bgView.layer.shadowColor = HexColor(0xd5d5d5).CGColor;
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
}

-(void)setFrameModel:(TFProjectRowFrameModel *)frameModel{
    
    _frameModel = frameModel;
    
    self.bgView.frame = frameModel.bgViewFrame;
    self.urgeView.frame = frameModel.urgeViewFrame;
    if (!frameModel.projectRow.urgeType || [[frameModel.projectRow.urgeType description] isEqualToString:@"0"]) {
        self.urgeView.hidden = YES;
    }else{
        self.urgeView.hidden = NO;
        if ([[frameModel.projectRow.urgeType description] isEqualToString:@"1"]) {
            self.urgeView.image = [UIImage imageNamed:@"绿色"];
        }else{
            self.urgeView.image = [UIImage imageNamed:@"黄色"];
        }
    }
    
    self.selectBtn.frame = frameModel.selectBtnFrame;
    if (!frameModel.projectRow.finishType || [[frameModel.projectRow.finishType description] isEqualToString:@"0"]) {
        self.selectBtn.selected = NO;
        self.selectBtn.enabled = YES;
    }else if ([[frameModel.projectRow.finishType description] isEqualToString:@"1"]){
        self.selectBtn.selected = YES;
        self.selectBtn.enabled = YES;
    }else{
        self.selectBtn.enabled = NO;
    }
    
    self.titleLabel.frame = frameModel.titleLabelFrame;
    self.titleLabel.text = frameModel.projectRow.taskName;
    
    self.activeBtn.frame = frameModel.activeBtnFrame;
    self.activeBtn.hidden = frameModel.activeBtnHidden;
    [self.activeBtn setTitle:[frameModel.projectRow.activeNum description] forState:UIControlStateNormal];
    
    self.endTimeBtn.frame = frameModel.endTimeBtnFrame;
    self.endTimeBtn.hidden = frameModel.endTimeBtnHidden;
    [self.endTimeBtn setTitle:frameModel.time forState:UIControlStateNormal];
    if ([frameModel.projectRow.endTime longLongValue] > [HQHelper getNowTimeSp]) {
        [self.endTimeBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
        [self.endTimeBtn setImage:[UIImage imageNamed:@"时间"] forState:UIControlStateNormal];
    }else{
        if (![[frameModel.projectRow.complete_status description] isEqualToString:@"1"]) {
            [self.endTimeBtn setTitleColor:RedColor forState:UIControlStateNormal];
            [self.endTimeBtn setImage:[UIImage imageNamed:@"截止时间"] forState:UIControlStateNormal];
        }else{
            [self.endTimeBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
            [self.endTimeBtn setImage:[UIImage imageNamed:@"时间"] forState:UIControlStateNormal];
        }
    }
    
    
    self.overBtn.frame = frameModel.overBtnFrame;
    self.overBtn.hidden = frameModel.overBtnHidden;
    [self.overBtn setTitle:frameModel.overtime forState:UIControlStateNormal];
    [self.overBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    self.childTaskBtn.frame = frameModel.childTaskBtnFrame;
    self.childTaskBtn.hidden = frameModel.childTaskBtnHidden;
    [self.childTaskBtn setTitle:frameModel.childTask forState:UIControlStateNormal];
    [self.childTaskBtn setImage:[UIImage imageNamed:@"子任务"] forState:UIControlStateNormal];
    
    self.headBtn.frame = frameModel.headBtnFrame;
    self.headBtn.hidden = frameModel.headBtnHidden;
    if (frameModel.projectRow.responsibler) {
        
        [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:frameModel.projectRow.responsibler.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [self.headBtn setTitle:@"" forState:UIControlStateNormal];
            }else{
                [self.headBtn setTitle:[HQHelper nameWithTotalName:frameModel.projectRow.responsibler.employee_name?:frameModel.projectRow.responsibler.name] forState:UIControlStateNormal];
                [self.headBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                self.headBtn.titleLabel.font = FONT(12);
                [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            }
        }];
    }
    
    self.tagListView.frame = frameModel.tagListViewFrame;
    self.tagListView.hidden = frameModel.tagListViewHidden;
    [self.tagListView refreshWithOptions:frameModel.projectRow.tagList];
    
    self.checkView.frame = frameModel.checkViewFrame;
    self.checkView.hidden = frameModel.checkViewHidden;
    
//    if ([frameModel.projectRow.passed_status isEqualToString:@"0"]) {
//        self.checkView.image = [UIImage imageNamed:@"待检验"];
//    }else if ([frameModel.projectRow.passed_status isEqualToString:@"1"]){
//        self.checkView.image = [UIImage imageNamed:@"taskPass"];
//    }else{
//        self.checkView.image = [UIImage imageNamed:@"taskReject"];
//    }
    
    if ([[frameModel.projectRow.finishType description] isEqualToString:@"1"] && [frameModel.projectRow.check_status isEqualToString:@"1"]){
        
        if ([frameModel.projectRow.passed_status isEqualToString:@"0"]) {
            self.checkView.image = [UIImage imageNamed:@"待检验"];
        }else if ([frameModel.projectRow.passed_status isEqualToString:@"1"]){
            self.checkView.image = [UIImage imageNamed:@"taskPass"];
        }
        self.checkView.hidden = NO;
    }else{
        if (!IsNilOrNull(frameModel.projectRow.passed_status)) {
            
            if ([frameModel.projectRow.passed_status isEqualToString:@"2"]) {
                self.checkView.image = [UIImage imageNamed:@"taskReject"];
                self.checkView.hidden = NO;
            }else{
                self.checkView.hidden = YES;
            }
        }
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
