//
//  TFNoteDetailRelatedCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteDetailRelatedCell.h"

@interface TFNoteDetailRelatedCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UIButton *pictureBtn;


@end

@implementation TFNoteDetailRelatedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pictureBtn.layer.cornerRadius = self.pictureBtn.width/2.0;
    self.pictureBtn.layer.masksToBounds = YES;
    
    self.logoImg.layer.cornerRadius = 2.0;
    self.logoImg.layer.masksToBounds = YES;
    
    self.contentLable.textColor = kUIColorFromRGB(0x2A2A2A);
    
    [self.deleteBtn setImage:IMG(@"新备忘录删除") forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshNoteDetailRelatedCellWithData:(NSDictionary *)dic1 {

    NSString *moduleName = [dic1 valueForKey:@"title"];
    NSString *dataName = [dic1 valueForKey:@"content"];

    self.logoImg.image = IMG([dic1 valueForKey:@"icon_url"]);
    self.logoImg.backgroundColor = [HQHelper colorWithHexString:[dic1 valueForKey:@"icon_color"]];

    self.contentLable.text = [NSString stringWithFormat:@"%@: %@",moduleName,dataName];

    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:self.contentLable.text];

    NSRange range = [self.contentLable.text rangeOfString:moduleName];

    [mString addAttribute:NSForegroundColorAttributeName value:kUIColorFromRGB(0x17171A) range:range];

    self.contentLable.attributedText = mString;

    NSString *urlStr = [dic1 valueForKey:@"picture"];

    if (![urlStr isEqualToString:@""] && urlStr != nil) {

        [self.pictureBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:urlStr] forState:UIControlStateNormal];
        [self.pictureBtn setTitle:@"" forState:UIControlStateNormal];
    }
    else {

        [self.pictureBtn sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
        [self.pictureBtn setTitle:[HQHelper nameWithTotalName:[dic1 valueForKey:@"name"]] forState:UIControlStateNormal];
        [self.pictureBtn setTitleColor:kUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [self.pictureBtn setBackgroundColor:GreenColor];
    }

}

- (void)deleteAction {
    
    if ([self.delegate respondsToSelector:@selector(noteDetailRelatedCellDidDeleteBtn:)]) {
        
        [self.delegate noteDetailRelatedCellDidDeleteBtn:self.index];
    }
}

+ (instancetype)noteDetailRelatedCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFNoteDetailRelatedCell" owner:self options:nil] lastObject];
}

+ (instancetype)noteDetailRelatedCellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"TFNoteDetailRelatedCell";
    TFNoteDetailRelatedCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self noteDetailRelatedCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kUIColorFromRGB(0xF8F8F8);
    cell.layer.cornerRadius = 4.0;
    cell.layer.masksToBounds = YES;
    return cell;
}

@end
