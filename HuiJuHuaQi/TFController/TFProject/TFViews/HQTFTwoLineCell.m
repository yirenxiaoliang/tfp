//
//  HQTFTwoLineCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTwoLineCell.h"
#import "UIButton+YYWebImage.h"

@interface HQTFTwoLineCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabelHead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressW;
@property (weak, nonatomic) IBOutlet UIView *progressView;

//@property (strong, nonatomic) UIImageView *imgV;

@end

@implementation HQTFTwoLineCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.titleImage.layer.cornerRadius = 2;
    self.titleImage.layer.masksToBounds = YES;
    self.titleImage.titleLabel.font = FONT(16);
    
    self.titleDescImg.hidden = YES;
    
    self.topLabel.textColor = BlackTextColor;
    self.topLabel.font = FONT(16);
    
    self.bottomLabel.textColor = LightGrayTextColor;
    self.bottomLabel.font = FONT(14);
    
    self.topLine.hidden = YES;
    self.headMargin = 15;
    
    self.type = TwoLineCellTypeTwo;
    
    [self.enterImage addTarget:self action:@selector(enterImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.enterImage.titleLabel.font = FONT(14);
    self.titleImage.userInteractionEnabled = NO;
    
    [self.titleImage addTarget:self action:@selector(titleImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    _imgV = [[UIImageView alloc] init];
//    _imgV.frame = CGRectMake(SCREEN_WIDTH-60-10, 3, 60, 60);
//    _imgV.hidden = YES;
//    [self addSubview:_imgV];
    self.layer.masksToBounds = YES;
    self.bgView.hidden = YES;
    
    self.titleImage.contentMode = UIViewContentModeScaleAspectFill;
    self.progressW.constant = 0;
    self.progressView.hidden = YES;
    self.progressView.backgroundColor = GreenColor;
    self.layer.masksToBounds = YES;
    
    self.titleDescImg.userInteractionEnabled = NO;
    self.enterImage.userInteractionEnabled = NO;
}

-(void)setTitleImageWidth:(CGFloat)titleImageWidth{
    _titleImageWidth = titleImageWidth;
    
    self.imageH.constant = titleImageWidth;
    self.imageW.constant = titleImageWidth;
    
    if (titleImageWidth == 0) {
        self.topLabelHead.constant = 0;
    }else{
        self.topLabelHead.constant = 15;
    }
}

- (void)enterImageClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(twoLineCell:didEnterImage:)]) {
        [self.delegate twoLineCell:self didEnterImage:button];
    }
}

- (void)titleImageClicked:(UIButton *)button {

    if ([self.delegate respondsToSelector:@selector(twoLineCell:titleImage:)]) {
        
        [self.delegate twoLineCell:self titleImage:button];
    }
}

-(void)setType:(TwoLineCellType)type{
    _type = type;
    
    switch (type) {
        case TwoLineCellTypeTwo:
        {
            self.titleCenter.constant = -11.5;
            self.bottomLabel.hidden = NO;
        }
            break;
        case TwoLineCellTypeOne:
        {
            self.titleCenter.constant = 0;
            self.bottomLabel.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

-(void)setIsClear:(BOOL)isClear{
    _isClear = isClear;
    self.enterImage.hidden = !isClear;
    self.enterImage.userInteractionEnabled = isClear;
    self.enterImage.layer.cornerRadius = 4;
    self.enterImage.layer.borderColor = GrayTextColor.CGColor;
    self.enterImage.layer.borderWidth = 0.5;
    [self.enterImage setTitle:@"移除" forState:UIControlStateNormal];
    [self.enterImage setImage:nil forState:UIControlStateNormal];
    [self.enterImage setTitleColor:GrayTextColor forState:UIControlStateNormal];
    self.enterImage.titleLabel.font = FONT(15);
    self.enterH.constant = 26;
}

/** 地址 */
- (void)refreshCellWithLocation:(TFLocationModel *)model{
    
    self.topLabel.text = model.name;
    self.bottomLabel.text = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.district,model.address];
    self.enterImage.userInteractionEnabled = NO;
    self.titleImageWidth = 0;
    
}
/** 用于人员显示 */
-(void)refreshCellWithEmployeeModel:(HQEmployModel *)model{
    
    
    if (![model.photograph isEqualToString:@""]) {
        
        [self.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image) {
                [self.titleImage setTitle:@"" forState:UIControlStateNormal];
            }else{
                [self.titleImage setTitle:[HQHelper nameWithTotalName:model.employeeName?:model.employee_name] forState:UIControlStateNormal];
                [self.titleImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                [self.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            }
        }];
    }
    else {
        
        [self.titleImage setTitle:[HQHelper nameWithTotalName:model.employeeName?:model.employee_name] forState:UIControlStateNormal];
        [self.titleImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
        [self.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
        [self.titleImage setBackgroundColor:GreenColor];
    }
    
    
    //    [self.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
    //    [self.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
    
    self.topLabel.text = model.employeeName;
    self.bottomLabel.text = model.position;
    
    self.topLabel.textColor = BlackTextColor;
    self.bottomLabel.textColor = LightGrayTextColor;
    
    self.enterImage.hidden = YES;
    self.bottomLine.hidden = NO;
    self.headMargin = 15;
    
    if (!model.position || [model.position isEqualToString:@""]) {
        self.type = TwoLineCellTypeOne;
    }else{
        self.type = TwoLineCellTypeTwo;
    }
    
    self.titleImage.layer.masksToBounds = YES;
    self.titleImage.layer.cornerRadius = 22.5;
}

/** 用于TFEmployModel人员显示 */
-(void)refreshWithTFEmployModel:(TFEmployModel *)model{
    
    
    if (![model.picture isEqualToString:@""]) {
        
        [self.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image) {
                [self.titleImage setTitle:@"" forState:UIControlStateNormal];
            }else{
                [self.titleImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
                [self.titleImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                [self.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            }
        }];
    }
    else {
        
        [self.titleImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
        [self.titleImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
        [self.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
        [self.titleImage setBackgroundColor:GreenColor];
    }
    
    
    self.topLabel.text = model.employee_name;
    self.bottomLabel.text = model.post_name;
    
    self.topLabel.textColor = BlackTextColor;
    self.bottomLabel.textColor = LightGrayTextColor;
    
    self.enterImage.hidden = YES;
    self.bottomLine.hidden = NO;
    self.headMargin = 15;
    
    if (!model.post_name || [model.post_name isEqualToString:@""]) {
        self.type = TwoLineCellTypeOne;
    }else{
        self.type = TwoLineCellTypeTwo;
    }
    
    self.titleImage.layer.masksToBounds = YES;
    self.titleImage.layer.cornerRadius = 22.5;
}

/** 用于项目人员显示 */
-(void)refreshCellWithProjectPeopleModel:(HQEmployModel *)model{
    
    
    if (![model.picture isEqualToString:@""]) {
        
        [self.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image) {
                [self.titleImage setTitle:@"" forState:UIControlStateNormal];
            }else{
                [self.titleImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
                [self.titleImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            }
        }];
    }
    else {
        
        [self.titleImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
        [self.titleImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
        [self.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
        [self.titleImage setBackgroundColor:GreenColor];
    }

    
//    [self.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
//    [self.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
    
    self.topLabel.text = model.employee_name;
    self.bottomLabel.text = model.position;
    
    self.topLabel.textColor = BlackTextColor;
    self.bottomLabel.textColor = LightGrayTextColor;
    
    self.enterImage.hidden = YES;
    self.bottomLine.hidden = NO;
    self.headMargin = 15;
    
    if (!model.position || [model.position isEqualToString:@""]) {
        self.type = TwoLineCellTypeOne;
    }else{
        self.type = TwoLineCellTypeTwo;
    }
    
    self.titleImage.layer.masksToBounds = YES;
    self.titleImage.layer.cornerRadius = 22.5;
}

/** 用于群已读显示 */
-(void)refreshCellWithGroupInfoModel:(TFGroupEmployeeModel *)model{
    
    
    if (![model.picture isEqualToString:@""]&&model.picture != nil) {
        
        [self.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal];
        [self.titleImage setTitle:@"" forState:UIControlStateNormal];
    }
    else {
        
        [self.titleImage sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
        [self.titleImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
        [self.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
        [self.titleImage setBackgroundColor:GreenColor];
    }

    
//    [self.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
//    [self.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
    
    self.titleImage.layer.cornerRadius = 45.0/2;
    self.titleImage.layer.masksToBounds = YES;
    
    self.topLabel.text = model.employee_name;
    self.bottomLabel.text = model.phone;
    
    self.topLabel.textColor = BlackTextColor;
    self.bottomLabel.textColor = LightGrayTextColor;
    
    self.enterImage.hidden = YES;
    self.bottomLine.hidden = NO;
    self.headMargin = 15;
    
    if (!model.phone || [model.phone isEqualToString:@""]) {
        self.type = TwoLineCellTypeOne;
    }else{
        self.type = TwoLineCellTypeTwo;
    }
    
}

/** 用于存储文件显示 */
-(void)refreshCellWithFileCModel:(TFFileCModel *)model{
    
    
    
}


/** 用于文件显示 */
-(void)refreshCellWithFileModel:(TFFileModel *)model{
    
    
    if (model.image) {
        [self.titleImage setImage:model.image forState:UIControlStateNormal];
        [self.titleImage setImage:model.image forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"jpg"] || [[model.file_type lowercaseString] isEqualToString:@"png"] || [[model.file_type lowercaseString] isEqualToString:@"gif"] || [[model.file_type lowercaseString] isEqualToString:@"jpeg"]) {// 图片
        
        [self.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.file_url] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
        [self.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.file_url] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
        
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"mp3"]){// 语音
        [self.titleImage setImage:[UIImage imageNamed:@"mp3"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"mp3"] forState:UIControlStateHighlighted];
        
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"doc"] || [[model.file_type lowercaseString] isEqualToString:@"docx"]){// doc
        [self.titleImage setImage:[UIImage imageNamed:@"doc"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"doc"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"xls"] || [[model.file_type lowercaseString] isEqualToString:@"xlsx"]){// xls
        [self.titleImage setImage:[UIImage imageNamed:@"xls"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"xls"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"ppt"] || [[model.file_type lowercaseString] isEqualToString:@"pptx"]){// ppt
        [self.titleImage setImage:[UIImage imageNamed:@"ppt"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"ppt"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"ai"]){// ai
        [self.titleImage setImage:[UIImage imageNamed:@"ai"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"ai"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"cdr"]){// cdr
        [self.titleImage setImage:[UIImage imageNamed:@"cdr"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"cdr"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"dwg"]){// dwg
        [self.titleImage setImage:[UIImage imageNamed:@"dwg"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"dwg"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"ps"]){// ps
        [self.titleImage setImage:[UIImage imageNamed:@"ps"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"ps"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"pdf"]){// pdf
        [self.titleImage setImage:[UIImage imageNamed:@"pdf"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"pdf"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"txt"]){// txt
        [self.titleImage setImage:[UIImage imageNamed:@"txt"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"txt"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"zip"] ||
              [[model.file_type lowercaseString] isEqualToString:@"rar"]){// zip
        [self.titleImage setImage:[UIImage imageNamed:@"zip"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"zip"] forState:UIControlStateHighlighted];
        
    }else{
        
        [self.titleImage setImage:[UIImage imageNamed:@"未知文件"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"未知文件"] forState:UIControlStateHighlighted];
        
    }
    
    self.topLabel.text = model.file_name;
    self.topLabel.textColor = LightBlackTextColor;
    self.bottomLabel.textColor = LightGrayTextColor;
    
    if (model.updateTime && ![model.updateTime isEqualToNumber:@0]) {
        
        self.bottomLabel.text = [NSString stringWithFormat:@"%@  %@  %@",TEXT(model.upload_by),[HQHelper nsdateToTime:[model.updateTime longLongValue] formatStr:@"yyyy-MM-dd HH:mm"],[HQHelper fileSizeForKB:[model.file_size integerValue]]];
    }else if (model.upload_time && ![model.upload_time isEqualToNumber:@0]){
        
        self.bottomLabel.text = [NSString stringWithFormat:@"%@  %@  %@",TEXT(model.upload_by),[HQHelper nsdateToTime:[model.upload_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"],[HQHelper fileSizeForKB:[model.file_size integerValue]]];
    }else if (model.createTime && ![model.createTime isEqualToNumber:@0]){
        
        self.bottomLabel.text = [NSString stringWithFormat:@"%@  %@  %@",TEXT(model.upload_by),[HQHelper nsdateToTime:[model.createTime longLongValue] formatStr:@"yyyy-MM-dd HH:mm"],[HQHelper fileSizeForKB:[model.file_size integerValue]]];
    }else{
        
        self.bottomLabel.text = [NSString stringWithFormat:@"%@  %@  %@",TEXT(model.upload_by),[HQHelper nsdateToTime:[model.createDate longLongValue] formatStr:@"yyyy-MM-dd HH:mm"],[HQHelper fileSizeForKB:[model.file_size integerValue]]];
    }
    
    self.enterImage.hidden = YES;
    self.bottomLine.hidden = NO;
    self.headMargin = 15;
    self.topLine.hidden = YES;
    
    if (!model.progress || [model.progress floatValue] == 0.0) {
        self.progressView.hidden = YES;
        self.progressW.constant = 0;
    }else{
        self.progressView.hidden = NO;
        
        self.progressW.constant = (SCREEN_WIDTH-30.0)*[model.progress floatValue];
        
    }

    
}


/** 用于邮件新建附件显示 */
-(void)refreshCellWithAddNoteAttachFileModel:(TFFileModel *)model{
    
    model.file_type = [model.file_type stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if (model.image) {
        [self.titleImage setImage:model.image forState:UIControlStateNormal];
        [self.titleImage setImage:model.image forState:UIControlStateHighlighted];
        
    }
    else if ([[model.file_type lowercaseString] isEqualToString:@"jpg"] || [[model.file_type lowercaseString] isEqualToString:@"png"] || [[model.file_type lowercaseString] isEqualToString:@"gif"]|| [[model.file_type lowercaseString] isEqualToString:@"jpeg"]) {// 图片
        
        //        [self.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.fileUrl] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
        //        [self.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.fileUrl] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
        
        //        [self.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.fileUrl] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
        //        [self.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.fileUrl] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"微信"]];
        
        [self.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.file_url] forState:UIControlStateNormal placeholderImage:DefaultFileImage];
        [self.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.file_url] forState:UIControlStateHighlighted placeholderImage:DefaultFileImage];
        
        
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"mp3"]){// 语音
        [self.titleImage setImage:[UIImage imageNamed:@"mp3"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"mp3"] forState:UIControlStateHighlighted];
        
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"doc"] || [[model.file_type lowercaseString] isEqualToString:@"docx"]){// doc
        [self.titleImage setImage:[UIImage imageNamed:@"doc"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"doc"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"xls"] || [[model.file_type lowercaseString] isEqualToString:@"xlsx"]){// xls
        [self.titleImage setImage:[UIImage imageNamed:@"xls"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"xls"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"ppt"] || [[model.file_type lowercaseString] isEqualToString:@"pptx"]){// ppt
        [self.titleImage setImage:[UIImage imageNamed:@"ppt"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"ppt"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"ai"]){// ai
        [self.titleImage setImage:[UIImage imageNamed:@"ai"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"ai"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"cdr"]){// cdr
        [self.titleImage setImage:[UIImage imageNamed:@"cdr"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"cdr"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"dwg"]){// dwg
        [self.titleImage setImage:[UIImage imageNamed:@"dwg"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"dwg"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"ps"]){// ps
        [self.titleImage setImage:[UIImage imageNamed:@"ps"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"ps"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"pdf"]){// pdf
        [self.titleImage setImage:[UIImage imageNamed:@"pdf"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"pdf"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"txt"]){// txt
        [self.titleImage setImage:[UIImage imageNamed:@"txt"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"txt"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"zip"] ||
              [[model.file_type lowercaseString] isEqualToString:@"rar"]){// zip
        [self.titleImage setImage:[UIImage imageNamed:@"zip"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"zip"] forState:UIControlStateHighlighted];
        
    }else{
        
        [self.titleImage setImage:[UIImage imageNamed:@"未知文件"] forState:UIControlStateNormal];
        [self.titleImage setImage:[UIImage imageNamed:@"未知文件"] forState:UIControlStateHighlighted];
        
    }
    
    self.topLabel.text = model.file_name;
    self.topLabel.textColor = LightBlackTextColor;
    self.bottomLabel.textColor = LightGrayTextColor;
    self.bottomLabel.text = [NSString stringWithFormat:@"%@",[HQHelper fileSizeForKB:[model.file_size integerValue]]];
    self.enterImage.hidden = YES;
    self.bottomLine.hidden = NO;
    self.headMargin = 15;
    self.topLine.hidden = YES;
}


+ (instancetype)twoLineCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFTwoLineCell" owner:self options:nil] lastObject];
}

+ (HQTFTwoLineCell *)twoLineCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFTwoLineCell";
    HQTFTwoLineCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = NO;
    if (!cell) {
        cell = [self twoLineCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+ (HQTFTwoLineCell *)twoLineCellWithTableView2:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFTwoLineCell2";
    HQTFTwoLineCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = NO;
    if (!cell) {
        cell = [self twoLineCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
