//
//  TFProjectFileListCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/18.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectFileListCell.h"

@interface TFProjectFileListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;



@end

@implementation TFProjectFileListCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.enterBtn.layer.cornerRadius = 4.0;
    self.enterBtn.layer.masksToBounds = YES;
    
    self.enterBtn.layer.borderWidth = 0.5;
    self.enterBtn.layer.borderColor = [kUIColorFromRGB(0x666666) CGColor];
    
    self.enterBtn.hidden = YES;
}

- (void)refreshProjectFileListCellWithModel:(TFProjectFileModel *)model projectId:(NSNumber *)projectId {

    model.suffix = [model.suffix stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ([[model.suffix lowercaseString] isEqualToString:@"jpg"] ||[[model.suffix lowercaseString] isEqualToString:@"jpeg"] ||[[model.suffix lowercaseString] isEqualToString:@"png"] ||[[model.suffix lowercaseString] isEqualToString:@"gif"]) {
        
//        NSURL *url = [HQHelper URLWithString:[NSString stringWithFormat:@"%@%@%@?id=%@&project_id=%@&width=64",kServerAddress,ServerAdress,@"/common/file/projectDownload",model.id,projectId]];
        NSURL *url = [HQHelper URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&project_id=%@&width=64",kServerAddress,@"/common/file/projectDownload",model.id,projectId]];
        
        [self.iconImg sd_setImageWithURL:url placeholderImage:IMG(@"未知文件")];
    }
    else if ([[model.suffix lowercaseString] isEqualToString:@"mp3"]){// 语音
        
        //        [self.iconImg setImage:[UIImage imageNamed:@"mp3"]];
        self.iconImg.image = IMG(@"mp3");
        
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@"mp4"] ||
              [[model.suffix lowercaseString] isEqualToString:@"mov"]){// 语音
        
        //        [self.iconImg setImage:[UIImage imageNamed:@"mp3"]];
        self.iconImg.image = IMG(@"mp4");
        
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@"doc"] || [[model.suffix lowercaseString] isEqualToString:@"docx"]){// doc
        
        self.iconImg.image = IMG(@"doc");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@"xls"] || [[model.suffix lowercaseString] isEqualToString:@"xlsx"]){// xls
        
        self.iconImg.image = IMG(@"xls");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@"ppt"] || [[model.suffix lowercaseString] isEqualToString:@"pptx"]){// ppt
        
        self.iconImg.image = IMG(@"ppt");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@"ai"]){// ai
        
        self.iconImg.image = IMG(@"ai");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@"cdr"]){// cdr
        
        self.iconImg.image = IMG(@"cdr");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@"dwg"]){// dwg
        
        self.iconImg.image = IMG(@"dwg");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@"ps"]){// ps
        
        self.iconImg.image = IMG(@"ps");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@"pdf"]){// pdf
        
        self.iconImg.image = IMG(@"pdf");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@"txt"]){// txt
        
        self.iconImg.image = IMG(@"txt");
        
    }else if ([[model.suffix lowercaseString] isEqualToString:@"zip"] ||
              [[model.suffix lowercaseString] isEqualToString:@"rar"]){// zip
        
        self.iconImg.image = IMG(@"zip");
        
    }else{
        
        self.iconImg.image = IMG(@"未知文件");
        
    }
    

    self.sizeLab.text = [HQHelper fileSizeForKB:[model.size integerValue]];
    
    self.fileNameLab.text = model.file_name;
    
    self.nameLab.text = model.employee_name;
    
    self.timeLab.text = [HQHelper nsdateToTime:[model.create_time longLongValue] formatStr:@"MM-dd"];
}

+ (instancetype)TFProjectFileListCell {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"TFProjectFileListCell" owner:self options:nil] lastObject];
}

+ (instancetype)projectFileListCellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"TFProjectFileListCell";
    TFProjectFileListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFProjectFileListCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    cell.topLine.hidden = YES;
    return cell;
}

@end
