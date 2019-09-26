
//
//  TFWebLinkItemCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/9.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFWebLinkItemCell.h"

@interface TFWebLinkItemCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UIButton *barcodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet UIButton *copyerBtn;

@end

@implementation TFWebLinkItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = FONT(15);
    self.titleLabel.textColor = ExtraLightBlackTextColor;
    
    self.linkLabel.font = FONT(15);
    self.linkLabel.textColor = ExtraLightBlackTextColor;
    
    self.barcodeBtn.backgroundColor = WhiteColor;
    self.openBtn.backgroundColor = WhiteColor;
    self.copyerBtn.backgroundColor = WhiteColor;
    [self.barcodeBtn setBackgroundImage:IMG(@"barcode") forState:UIControlStateNormal];
    [self.barcodeBtn setBackgroundImage:IMG(@"barcode") forState:UIControlStateHighlighted];
    self.barcodeBtn.contentMode = UIViewContentModeScaleToFill;
    
    [self.openBtn setTitle:@"打开" forState:UIControlStateNormal];
    [self.openBtn setTitle:@"打开" forState:UIControlStateNormal];
    [self.copyerBtn setTitle:@"复制" forState:UIControlStateNormal];
    [self.copyerBtn setTitle:@"复制" forState:UIControlStateNormal];
    self.openBtn.titleLabel.font = FONT(14);
    self.copyerBtn.titleLabel.font = FONT(14);
    
    [self.openBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [self.openBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
    [self.copyerBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [self.copyerBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headMargin = 15;
}

-(void)refreshWebLinkItemCellWithModel:(TFLinkModel *)model{
    
    self.titleLabel.text = model.name;
    self.linkLabel.text = model.url;
}

- (IBAction)barcodeClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(webLinkItemCell:didClickedBarcode:)]) {
        [self.delegate webLinkItemCell:self didClickedBarcode:self.linkLabel.text];
    }
}
- (IBAction)openClicked:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkLabel.text]];
}

- (IBAction)copyerClicked:(id)sender {
    
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    
    board.string = self.linkLabel.text;
    
    [MBProgressHUD showSuccess:@"复制成功" toView:KeyWindow];
}

+ (instancetype)webLinkItemCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFWebLinkItemCell" owner:self options:nil] lastObject];
}

+ (instancetype)webLinkItemCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFWebLinkItemCell";
    
    TFWebLinkItemCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (cell == nil) {
        cell = [self webLinkItemCell];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
