//
//  TFTProjectCustomCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/21.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTProjectCustomCell.h"
#import "TFFieldNameModel.h"

@interface TFTProjectCustomCell ()

/** labels */
@property (nonatomic, strong) NSMutableArray *labels;


/** UIView *bgView */
@property (nonatomic, weak) UIView *bgView;

/** UIButton *selectBtn */
@property (nonatomic, weak) UIImageView *selectBtn;

/** UILabel *titleLabel */
@property (nonatomic, weak) UILabel *titleLabel;

/** UIButton *headBtn */
@property (nonatomic, weak) UIButton *headBtn;


@end


@implementation TFTProjectCustomCell

-(NSMutableArray *)labels{
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

+(instancetype)projectCustomCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFTProjectCustomCell";
    TFTProjectCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TFTProjectCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    bgView.layer.shadowColor = LightGrayTextColor.CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0, 0);
    bgView.layer.shadowRadius = 4;
    bgView.layer.shadowOpacity = 0.5;
    self.bgView = bgView;
    
    UIImageView *selectBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"项目-自定义"]];
    [bgView addSubview:selectBtn];
    selectBtn.layer.masksToBounds = YES;
    selectBtn.layer.cornerRadius = 2;
    self.selectBtn = selectBtn;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [bgView addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    titleLabel.font = FONT(14);
    titleLabel.textColor = BlackTextColor;
    self.titleLabel = titleLabel;
    
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:headBtn];
    headBtn.userInteractionEnabled = NO;
    headBtn.layer.masksToBounds = YES;
    headBtn.layer.cornerRadius = 14;
    headBtn.titleLabel.font = FONT(12);
    [headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.headBtn = headBtn;
    
    for (NSInteger i = 0; i < 6; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        [bgView addSubview:label];
        label.font = FONT(12);
        label.textColor = LightGrayTextColor;
        label.tag = 0x123 + i;
        [self.labels addObject:label];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    self.contentView.backgroundColor = ClearColor;
    self.backgroundColor = ClearColor;
    self.layer.masksToBounds = YES;
}

-(void)setKnowledge:(NSInteger)knowledge{
    _knowledge = knowledge;
    
    if (knowledge == 1) {
        
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
        }];
        self.contentView.backgroundColor = WhiteColor;
        self.backgroundColor = WhiteColor;
        self.bgView.backgroundColor = WhiteColor;
        self.bgView.layer.shadowColor = LightGrayTextColor.CGColor;
        self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
        self.bgView.layer.shadowRadius = 4;
        self.bgView.layer.shadowOpacity = 0.5;
        
    }else if (knowledge == 2){
        
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
        }];
        self.contentView.backgroundColor = WhiteColor;
        self.backgroundColor = WhiteColor;
        self.bgView.backgroundColor = BackGroudColor;
        //        self.bgView.layer.shadowColor = HexColor(0xd5d5d5).CGColor;
        //        self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
        //        self.bgView.layer.shadowRadius = 0;
        //        self.bgView.layer.shadowOpacity = 1;
        
    }
}

-(void)setFrameModel:(TFProjectRowFrameModel *)frameModel{
    
    _frameModel = frameModel;
    TFProjectRowModel *row = frameModel.projectRow;
    
    self.bgView.frame = frameModel.bgViewFrame;
    
    self.selectBtn.frame = frameModel.selectBtnFrame;
    
    if ([[frameModel.projectRow.icon_type description] isEqualToString:@"1"]) {// 网络图片
        [self.selectBtn sd_setImageWithURL:[HQHelper URLWithString:frameModel.projectRow.icon_url]];
        self.selectBtn.contentMode = UIViewContentModeScaleToFill;
    }else{// 本地图片
        if (frameModel.projectRow.icon_url && ![frameModel.projectRow.icon_url isEqualToString:@""] && ![frameModel.projectRow.icon_url isEqualToString:@"null"]) {
            [self.selectBtn setImage:IMG(frameModel.projectRow.icon_url)];
            self.selectBtn.backgroundColor = [HQHelper colorWithHexString:frameModel.projectRow.icon_color]?[HQHelper colorWithHexString:frameModel.projectRow.icon_color]:GreenColor;
        }
        self.selectBtn.contentMode = UIViewContentModeScaleToFill;
    }
    
    
    self.titleLabel.frame = frameModel.titleLabelFrame;
    if (row.row.count) {
        self.titleLabel.text = [HQHelper stringWithFieldNameModel:row.row[0]];
    }
    
    self.headBtn.frame = frameModel.headBtnFrame;
    TFEmployModel *em = nil;
    for (TFFieldNameModel *model in row.row) {
        if ([model.name containsString:@"principal"]) {
            NSArray *arr = [HQHelper dictionaryWithJsonString:model.value];
            if (arr.count) {
                em = [[TFEmployModel alloc] initWithDictionary:arr[0] error:nil];
            }
        }
    }
    if (em) {
        self.headBtn.hidden = NO;
        [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:em.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [self.headBtn setTitle:@"" forState:UIControlStateNormal];
            }else{
                [self.headBtn setTitle:[HQHelper nameWithTotalName:em.employee_name?:em.name] forState:UIControlStateNormal];
                [self.headBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                self.headBtn.titleLabel.font = FONT(12);
                [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            }
        }];
    }else{
        self.headBtn.hidden = YES;
    }
    
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSInteger i = 1; i < row.row.count; i++) {
        TFFieldNameModel *fe = row.row[i];
        if ([fe.name containsString:@"principal"]) {
            continue;
        }
        [values addObject:fe];
    }
    for (UILabel *la in self.labels) {
        la.hidden = YES;
    }
    for (NSInteger i = 0; i < (values.count>6?6:values.count); i++) {
        
        TFFieldNameModel *fe = values[i];
        UILabel *label = self.labels[i];
        label.text = [HQHelper stringWithFieldNameModel:fe];
        label.hidden = NO;
    }
    
    for (NSInteger i = 0; i < (frameModel.labels.count>6?6:frameModel.labels.count); i ++) {
        UILabel *la = self.labels[i];
        NSValue *va = frameModel.labels[i];
        la.frame = [va CGRectValue];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
