//
//  TFSingleAttachmentCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/17.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSingleAttachmentCell.h"
#import "HQTFTwoLineCell.h"

@interface TFSingleAttachmentCell ()

/** 附件图 */
@property (nonatomic, strong) UIButton *imgView;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLable;
/** 删除按钮 */
@property (nonatomic, strong) UIButton *deleteBtn;
/** 名字 */
@property (nonatomic, strong) UILabel *nameLable;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLable;
/** 附件大小 */
@property (nonatomic, strong) UILabel *sizeLable;


@end

@implementation TFSingleAttachmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView {
    
    //图片
    UIButton *imgView = [UIButton buttonWithType:UIButtonTypeCustom];
    imgView.layer.cornerRadius = 4.0;
    imgView.layer.masksToBounds = YES;
    self.imgView = imgView;
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@10);
        make.top.equalTo(@5);
        make.width.height.equalTo(@40);
    }];
    
    //删除按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:IMG(@"邮件已删除") forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAttachment) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn = deleteBtn;
    [self.contentView addSubview:deleteBtn];
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(@(-10));
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@22);
    }];
    
    //标题
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.textColor = LightBlackTextColor;
    titleLable.font = FONT(14);
    self.titleLable = titleLable;
    [self.contentView addSubview:titleLable];
    
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.top.equalTo(@5);
        make.right.equalTo(self.deleteBtn.mas_left).offset(-18);
        make.height.equalTo(@17);
        
    }];
    
    //名字
    UILabel *nameLable = [[UILabel alloc] init];
    nameLable.textColor = NineColor;
    nameLable.font = FONT(12);
    self.nameLable = nameLable;
    [self.contentView addSubview:nameLable];
    
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.top.equalTo(self.titleLable.mas_bottom).offset(2);
//        make.width.equalTo(@90);
        make.height.equalTo(@17);
    }];
    
    //时间
    UILabel *timeLable = [[UILabel alloc] init];
    timeLable.textColor = NineColor;
    timeLable.font = FONT(12);
    self.timeLable = timeLable;
    [self.contentView addSubview:timeLable];
    
    [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.nameLable.mas_right).offset(20);
        make.top.equalTo(self.titleLable.mas_bottom).offset(2);
//        make.width.equalTo(@78);
        make.height.equalTo(@17);
        
    }];
    
    //附件大小
    UILabel *sizeLable = [[UILabel alloc] init];
    sizeLable.textColor = NineColor;
    sizeLable.font = FONT(12);
    self.sizeLable = sizeLable;
    [self.contentView addSubview:sizeLable];
    
    [sizeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.timeLable.mas_right).offset(20);
        make.right.equalTo(self.deleteBtn.mas_left).offset(-18);
        make.top.equalTo(self.titleLable.mas_bottom).offset(2);
        make.height.equalTo(@17);
    }];
    
}

-(void)setType:(NSInteger)type{
    _type = type;
    if (type == 0) {
        self.deleteBtn.hidden = NO;
        [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@22);
        }];
    }else{
        [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@0);
        }];
        self.deleteBtn.hidden = YES;
    }
}

/** 刷新cell */
- (void)refreshSingleAttachmentCellWithModel:(TFFileModel *)model {
    
//    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.file_url] placeholderImage:nil];
    
    if (model.image) {
        [self.imgView setImage:model.image forState:UIControlStateNormal];
        [self.imgView setImage:model.image forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"jpg"] || [[model.file_type lowercaseString] isEqualToString:@"png"] || [[model.file_type lowercaseString] isEqualToString:@"gif"] || [[model.file_type lowercaseString] isEqualToString:@"jpeg"]) {// 图片
        
        [self.imgView sd_setImageWithURL:[HQHelper URLWithString:model.file_url] forState:UIControlStateNormal placeholderImage:nil];
        [self.imgView sd_setImageWithURL:[HQHelper URLWithString:model.file_url] forState:UIControlStateHighlighted placeholderImage:nil];
        
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"mp3"]){// 语音
        [self.imgView setImage:[UIImage imageNamed:@"mp3"] forState:UIControlStateNormal];
        [self.imgView setImage:[UIImage imageNamed:@"mp3"] forState:UIControlStateHighlighted];
        
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"doc"] || [[model.file_type lowercaseString] isEqualToString:@"docx"]){// doc
        [self.imgView setImage:[UIImage imageNamed:@"doc"] forState:UIControlStateNormal];
        [self.imgView setImage:[UIImage imageNamed:@"doc"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"xls"] || [[model.file_type lowercaseString] isEqualToString:@"xlsx"]){// xls
        [self.imgView setImage:[UIImage imageNamed:@"xls"] forState:UIControlStateNormal];
        [self.imgView setImage:[UIImage imageNamed:@"xls"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"ppt"] || [[model.file_type lowercaseString] isEqualToString:@"pptx"]){// ppt
        [self.imgView setImage:[UIImage imageNamed:@"ppt"] forState:UIControlStateNormal];
        [self.imgView setImage:[UIImage imageNamed:@"ppt"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"ai"]){// ai
        [self.imgView setImage:[UIImage imageNamed:@"ai"] forState:UIControlStateNormal];
        [self.imgView setImage:[UIImage imageNamed:@"ai"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"cdr"]){// cdr
        [self.imgView setImage:[UIImage imageNamed:@"cdr"] forState:UIControlStateNormal];
        [self.imgView setImage:[UIImage imageNamed:@"cdr"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"dwg"]){// dwg
        [self.imgView setImage:[UIImage imageNamed:@"dwg"] forState:UIControlStateNormal];
        [self.imgView setImage:[UIImage imageNamed:@"dwg"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"ps"]){// ps
        [self.imgView setImage:[UIImage imageNamed:@"ps"] forState:UIControlStateNormal];
        [self.imgView setImage:[UIImage imageNamed:@"ps"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"pdf"]){// pdf
        [self.imgView setImage:[UIImage imageNamed:@"pdf"] forState:UIControlStateNormal];
        [self.imgView setImage:[UIImage imageNamed:@"pdf"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"txt"]){// txt
        [self.imgView setImage:[UIImage imageNamed:@"txt"] forState:UIControlStateNormal];
        [self.imgView setImage:[UIImage imageNamed:@"txt"] forState:UIControlStateHighlighted];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"zip"] ||
              [[model.file_type lowercaseString] isEqualToString:@"rar"]){// zip
        [self.imgView setImage:[UIImage imageNamed:@"zip"] forState:UIControlStateNormal];
        [self.imgView setImage:[UIImage imageNamed:@"zip"] forState:UIControlStateHighlighted];
        
    }else{
        [self.imgView setImage:[UIImage imageNamed:@"未知文件"] forState:UIControlStateNormal];
        [self.imgView setImage:[UIImage imageNamed:@"未知文件"] forState:UIControlStateHighlighted];
    }
    self.titleLable.text = model.file_name;
    self.nameLable.text = model.upload_by;
    self.timeLable.text = [HQHelper nsdateToTime:[model.upload_time longLongValue] formatStr:@"yyyy-MM-dd"];
    self.sizeLable.text = [HQHelper fileSizeForKB:[model.file_size integerValue]];
}

/** 删除 */
- (void)deleteAttachment {
    
    if ([self.delegate respondsToSelector:@selector(deleteAttachmentAction:)]) {
        
        [self.delegate deleteAttachmentAction:self.btnIndex];
    }
}

+ (TFSingleAttachmentCell *)SingleAttachmentCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFSingleAttachmentCell";
    TFSingleAttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFSingleAttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
