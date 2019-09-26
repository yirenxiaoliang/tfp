//
//  TFHistoryVersionCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFHistoryVersionCell.h"

@implementation TFHistoryVersionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //图片
        self.typeImg = [[UIImageView alloc] init];
        self.typeImg.backgroundColor = ClearColor;
        
        self.typeImg.layer.cornerRadius = 2.0;
        
        
        [self addSubview:_typeImg];
        
        
        [self.typeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.width.height.mas_equalTo(40);
            make.centerY.mas_equalTo(self);
        }];
        
        //文件名称
        self.titlelab = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0x4A4A4A) titleFont:16 bgColor:kUIColorFromRGB(0xffffff)];
        self.titlelab.layer.masksToBounds=YES;
        self.titlelab.textAlignment=NSTextAlignmentLeft;
        self.titlelab.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:self.titlelab];
        
        [self.titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.typeImg.mas_right).offset(10);
            make.top.equalTo(self).offset(13);
            make.right.equalTo(self.mas_right).offset(-81);
            make.height.equalTo(@22);
            make.width.equalTo(@(SCREEN_WIDTH-80));
        }];
        
        //名字
        self.nameLab = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0xBBBBC3) titleFont:14 bgColor:ClearColor];
        
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.nameLab];
        
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.typeImg.mas_right).offset(10);
            make.top.equalTo(self.titlelab.mas_bottom).offset(2);
            make.height.equalTo(@20);
            
        }];
        
        //日期
        self.timeLab = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0xBBBBC3) titleFont:14 bgColor:ClearColor];
        
        [self addSubview:self.timeLab];
        
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.nameLab.mas_right).offset(10);
            make.centerY.equalTo(self.nameLab.mas_centerY);
            make.height.equalTo(@20);
            
            
        }];
        
        //大小
        self.sizeLab = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0xBBBBC3) titleFont:14 bgColor:ClearColor];
        
        [self addSubview:self.sizeLab];
        
        [self.sizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.timeLab.mas_right).offset(10);
            make.centerY.equalTo(self.timeLab.mas_centerY);
            make.height.equalTo(@20);
            
        }];
        
        //版本
        self.versionLab = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0xFF8E53) titleFont:10 bgColor:ClearColor];
        self.versionLab.layer.cornerRadius = 2.0;
        self.versionLab.layer.masksToBounds=YES;
        self.versionLab.layer.borderColor = [kUIColorFromRGB(0xFF8E53) CGColor];
        self.versionLab.layer.borderWidth = 0.5;
        self.versionLab.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.versionLab];
        
        [self.versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.sizeLab.mas_centerY);
            make.height.equalTo(@18);
            make.width.equalTo(@50);
        }];

        self.moreImgV = [[UIImageView alloc] initWithImage:IMG(@"下啦") highlightedImage:IMG(@"下啦")];
        self.moreImgV.contentMode = UIViewContentModeCenter;
        self.moreImgV.userInteractionEnabled = YES;
        [self addSubview:self.moreImgV];
        
        UITapGestureRecognizer *moreTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreAction)];
        
        [self.moreImgV addGestureRecognizer:moreTap];
        
        [self.moreImgV mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.equalTo(@(-16));
            make.centerY.mas_equalTo(self);
            make.width.height.equalTo(@44);
            
        }];
        
    }
    
    return self;
    
}

//配置数据
- (void)refreshFileListDataWithModel:(TFFolderListModel *)model {


//    [self.typeImg sd_setImageWithURL:[HQHelper URLWithString:model.picture] placeholderImage:PlaceholderBackgroundImage];
    model.siffix = [model.siffix stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ([[model.siffix lowercaseString] isEqualToString:@"jpg"] ||[[model.siffix lowercaseString] isEqualToString:@"jpeg"] ||[[model.siffix lowercaseString] isEqualToString:@"png"] ||[[model.siffix lowercaseString] isEqualToString:@"gif"]) {
        
//        NSInteger fid;
//        if ([model.style isEqualToNumber:@4] || [model.style isEqualToNumber:@5]) {
        
            NSInteger fid = [model.id integerValue];
//        }
//        else {
//        
//            fid = [model.id integerValue];
//        }
//        NSURL *url = [HQHelper URLWithString:[NSString stringWithFormat:@"%@%@%@?id=%ld&type=1&url=%@&width=64&height=64",kServerAddress,ServerAdress,@"/library/file/downloadCompressedPicture",fid,model.url]];
        NSURL *url = [HQHelper URLWithString:[NSString stringWithFormat:@"%@%@?id=%ld&type=1&url=%@&width=64&height=64",kServerAddress,@"/library/file/downloadCompressedPicture",fid,model.url]];
        
        [self.typeImg sd_setImageWithURL:url placeholderImage:IMG(@"未知文件")];
    }
    else if ([[model.siffix lowercaseString] isEqualToString:@"mp3"]){// 语音
        
//        [self.typeImg setImage:[UIImage imageNamed:@"mp3"]];
        self.typeImg.image = IMG(@"mp3");
        
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"mp4"] ||
              [[model.siffix lowercaseString] isEqualToString:@"mov"]){// 视频
        
        //        [self.typeImg setImage:[UIImage imageNamed:@"mp3"]];
        self.typeImg.image = IMG(@"mp4");
        
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"doc"] || [[model.siffix lowercaseString] isEqualToString:@"docx"]){// doc

        self.typeImg.image = IMG(@"doc");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"xls"] || [[model.siffix lowercaseString] isEqualToString:@"xlsx"]){// xls

        self.typeImg.image = IMG(@"xls");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"ppt"] || [[model.siffix lowercaseString] isEqualToString:@"pptx"]){// ppt

        self.typeImg.image = IMG(@"ppt");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"ai"]){// ai

        self.typeImg.image = IMG(@"ai");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"cdr"]){// cdr

        self.typeImg.image = IMG(@"cdr");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"dwg"]){// dwg

        self.typeImg.image = IMG(@"dwg");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"ps"]){// ps
        
        self.typeImg.image = IMG(@"ps");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"pdf"]){// pdf

        self.typeImg.image = IMG(@"pdf");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"txt"]){// txt

        self.typeImg.image = IMG(@"txt");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"zip"] ||
              [[model.siffix lowercaseString] isEqualToString:@"rar"]){// zip

        self.typeImg.image = IMG(@"zip");
        
    }else{
        
        self.typeImg.image = IMG(@"未知文件");
        
    }
    
    
    self.titlelab.text = model.name;
    
    self.nameLab.text = model.employee_name;
    
    self.timeLab.text = [HQHelper nsdateToTime:[model.create_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    
    self.sizeLab.text = [HQHelper fileSizeForKB:[model.size integerValue]];
    
//    [self.sizeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.timeLab.mas_right).offset(30);
//        make.centerY.equalTo(self.timeLab.mas_centerY);
//        make.height.equalTo(@20);
//
//    }];
    
    self.moreImgV.hidden = YES;
    
    self.versionLab.text = @"第一版本";
}

//聊天文件
- (void)refreshChatFileDataWithModel:(TFFolderListModel *)model {
    
    
    //    [self.typeImg sd_setImageWithURL:[HQHelper URLWithString:model.picture] placeholderImage:PlaceholderBackgroundImage];
    model.siffix = [model.siffix stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ([[model.siffix lowercaseString] isEqualToString:@"jpg"] ||[[model.siffix lowercaseString] isEqualToString:@"jpeg"] ||[[model.siffix lowercaseString] isEqualToString:@"png"] ||[[model.siffix lowercaseString] isEqualToString:@"gif"]) {
        
        //        NSInteger fid;
        //        if ([model.style isEqualToNumber:@4] || [model.style isEqualToNumber:@5]) {
        
        //            NSInteger fid = [model.id integerValue];
        //        }
        //        else {
        //
        //            fid = [model.id integerValue];
        //        }
        //        NSURL *url = [HQHelper URLWithString:[NSString stringWithFormat:@"%@%@%@?id=%ld&type=1&url=%@&width=64&height=64",kServerAddress,ServerAdress,@"/library/file/downloadCompressedPicture",fid,model.url]];
        
        [self.typeImg sd_setImageWithURL:[HQHelper URLWithString:model.url] placeholderImage:IMG(@"未知文件")];
    }
    else if ([[model.siffix lowercaseString] isEqualToString:@"mp3"]){// 语音
        
        //        [self.typeImg setImage:[UIImage imageNamed:@"mp3"]];
        self.typeImg.image = IMG(@"mp3");
        
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"doc"] || [[model.siffix lowercaseString] isEqualToString:@"docx"]){// doc
        
        self.typeImg.image = IMG(@"doc");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"xls"] || [[model.siffix lowercaseString] isEqualToString:@"xlsx"]){// xls
        
        self.typeImg.image = IMG(@"xls");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"ppt"] || [[model.siffix lowercaseString] isEqualToString:@"pptx"]){// ppt
        
        self.typeImg.image = IMG(@"ppt");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"ai"]){// ai
        
        self.typeImg.image = IMG(@"ai");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"cdr"]){// cdr
        
        self.typeImg.image = IMG(@"cdr");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"dwg"]){// dwg
        
        self.typeImg.image = IMG(@"dwg");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"ps"]){// ps
        
        self.typeImg.image = IMG(@"ps");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"pdf"]){// pdf
        
        self.typeImg.image = IMG(@"pdf");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"txt"]){// txt
        
        self.typeImg.image = IMG(@"txt");
        
    }else if ([[model.siffix lowercaseString] isEqualToString:@"zip"]){// zip
        
        self.typeImg.image = IMG(@"zip");
        
    }else{
        
        self.typeImg.image = IMG(@"未知文件");
        
    }
    
    
    self.titlelab.text = model.name;
    
    self.nameLab.text = model.employee_name;
    
    self.timeLab.text = [HQHelper nsdateToTime:[model.create_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    
    self.sizeLab.text = [HQHelper fileSizeForKB:[model.size integerValue]];
    
//    [self.sizeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(self.mas_right).offset(-61);
//        make.centerY.equalTo(self.timeLab.mas_centerY);
//        make.height.equalTo(@20);
//
//    }];
    
    self.moreImgV.hidden = YES;
    
    self.versionLab.text = @"第一版本";
}

//配置数据
- (void)refreshHistoryVersionDataWithModel:(TFFolderListModel *)model {
    
    if ([[model.suffix lowercaseString] isEqualToString:@".jpg"] ||[[model.suffix lowercaseString] isEqualToString:@".jpeg"] ||[[model.suffix lowercaseString] isEqualToString:@".png"] ||[[model.suffix lowercaseString] isEqualToString:@".gif"]) {
        
//        NSURL *url = [HQHelper URLWithString:[NSString stringWithFormat:@"%@%@%@?id=%@&type=2&width=64&height=64",kServerAddress,ServerAdress,@"/library/file/downloadCompressedPicture",model.id]];
        NSURL *url = [HQHelper URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&type=2&width=64&height=64",kServerAddress,@"/library/file/downloadCompressedPicture",model.id]];
        
        [self.typeImg sd_setImageWithURL:url placeholderImage:IMG(@"未知文件")];
    }
    else if ([[model.suffix lowercaseString] isEqualToString:@".mp3"]){// 语音
        
        //        [self.typeImg setImage:[UIImage imageNamed:@"mp3"]];
        self.typeImg.image = IMG(@"mp3");
        
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@".doc"] || [[model.suffix lowercaseString] isEqualToString:@".docx"]){// doc
        
        self.typeImg.image = IMG(@"doc");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@".xls"] || [[model.suffix lowercaseString] isEqualToString:@".xlsx"]){// xls
        
        self.typeImg.image = IMG(@"xls");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@".ppt"] || [[model.suffix lowercaseString] isEqualToString:@".pptx"]){// ppt
        
        self.typeImg.image = IMG(@"ppt");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@".ai"]){// ai
        
        self.typeImg.image = IMG(@"ai");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@".cdr"]){// cdr
        
        self.typeImg.image = IMG(@"cdr");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@".dwg"]){// dwg
        
        self.typeImg.image = IMG(@"dwg");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@".ps"]){// ps
        
        self.typeImg.image = IMG(@"ps");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@".pdf"]){// pdf
        
        self.typeImg.image = IMG(@"pdf");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@".txt"]){// txt
        
        self.typeImg.image = IMG(@"txt");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@".zip"]){// zip
        
        self.typeImg.image = IMG(@"zip");
        
    }else{
        
        self.typeImg.image = IMG(@"未知文件");
        
    }

//    [self.typeImg sd_setImageWithURL:[HQHelper URLWithString:model.picture] placeholderImage:PlaceholderBackgroundImage];
    
    self.titlelab.text = model.name;
    
    self.nameLab.text = model.employee_name;
    
    self.timeLab.text = [HQHelper nsdateToTime:[model.midf_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    
    self.sizeLab.text = [HQHelper fileSizeForKB:[model.size integerValue]];
    
//    [self.timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.mas_left).equalTo(@119);
//        make.centerY.equalTo(self.nameLab.mas_centerY);
//        make.height.equalTo(@20);
//    }];
//
//    [self.sizeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(self.mas_right).offset(-81);
//        make.centerY.equalTo(self.timeLab.mas_centerY);
//        make.height.equalTo(@20);
//
//    }];
    
    self.moreImgV.hidden = YES;
    
    if ([model.versionNum isEqualToNumber:@0]) {

        self.versionLab.text = @"当前版本";
        self.versionLab.textColor = kUIColorFromRGB(0xFFFFFF);
        self.versionLab.backgroundColor = kUIColorFromRGB(0xFF8E53);
    }
    else {
    
        self.versionLab.text = [NSString stringWithFormat:@"第%ld版本",[model.versionCount integerValue]-[model.versionNum integerValue]];
        self.versionLab.textColor = kUIColorFromRGB(0xFF8E53);
        self.versionLab.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    }
}

- (void)moreAction {

    if ([self.delegate respondsToSelector:@selector(moreOperationClick:)]) {
        
        [self.delegate moreOperationClick:self.index];
    }
}

+ (TFHistoryVersionCell *)HistoryVersionCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFHistoryVersionCell";
    TFHistoryVersionCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFHistoryVersionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
