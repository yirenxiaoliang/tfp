//
//  TFWebLinkCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/29.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFWebLinkCell.h"
#import "TFWebLinkItemCell.h"
#import "TFExpandShowView.h"

@interface TFWebLinkCell ()<UITableViewDelegate,UITableViewDataSource,TFExpandShowViewDelegate,TFWebLinkItemCellDelegate>

@property (nonatomic, strong) TFWebLinkModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UIButton *barcodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet UIButton *copyerBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TFWebLinkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.font = FONT(17);
    self.titleLabel.textColor = BlackTextColor;
    
    self.linkLabel.font = FONT(15);
    self.linkLabel.textColor = LightBlackTextColor;
    
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
    self.bottomLine.hidden = NO;
    self.headMargin = 15;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    
    TFExpandShowView *view = [TFExpandShowView expandShowView];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    view.delegate = self;
    self.tableView.tableHeaderView = view;
    
}


#pragma mark - TFExpandShowViewDelegate
-(void)expandShowViewDidClicked{
    
    if (self.model.select == nil) {
        self.model.select = @1;
    }else{
        self.model.select = nil;
    }
    if ([self.delegate respondsToSelector:@selector(webLinkCellChangeHeight)]) {
        [self.delegate webLinkCellChangeHeight];
    }
}


- (IBAction)barcodeClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(webLinkCell:didClickedBarcode:signInBarcode:)]) {
        [self.delegate webLinkCell:self didClickedBarcode:self.linkLabel.text signInBarcode:self.model.signInLink];
    }
}
- (IBAction)openClicked:(id)sender {
//    NSString *url = [HQHelper URLWithString:self.linkLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkLabel.text]];
}

- (IBAction)copyerClicked:(id)sender {
    
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    
    board.string = self.linkLabel.text;
    
    [MBProgressHUD showSuccess:@"复制成功" toView:KeyWindow];
}


-(void)refreshWebLinkCellWithModel:(TFWebLinkModel *)model{
    self.model = model;
    self.titleLabel.text = model.title;
    self.linkLabel.text = model.externalLink;
    [self.tableView reloadData];
}
+(CGFloat)refreshWebLinkCellHeightWithModel:(TFWebLinkModel *)model{
    
    CGFloat height = 78;
    
    if (model.expandLink.count) {
        if (model.select) {
            return height +(model.expandLink.count + 1) * 40;
        }else{
            return height + 40;
        }
        
    }else{
        return height;
    }
    
}


+ (instancetype)webLinkCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFWebLinkCell" owner:self options:nil] lastObject];
}

+ (instancetype)webLinkCelllWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFWebLinkCell";
    
    TFWebLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (cell == nil) {
        cell = [self webLinkCell];
    }

    
    return cell;
}

#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.expandLink.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFWebLinkItemCell *cell = [TFWebLinkItemCell webLinkItemCellWithTableView:tableView];
    [cell refreshWebLinkItemCellWithModel:self.model.expandLink[indexPath.row]];
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = YES;
    cell.delegate = self;
//    if (self.model.expandLink.count-1 == indexPath.row) {
//        cell.bottomLine.hidden = YES;
//    }else{
//        cell.bottomLine.hidden = NO;
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}

#pragma mark - TFWebLinkItemCellDelegate
-(void)webLinkItemCell:(TFWebLinkItemCell *)cell didClickedBarcode:(NSString *)barcode{
    
    if ([self.delegate respondsToSelector:@selector(webLinkCell:didClickedBarcode:signInBarcode:)]) {
        [self.delegate webLinkCell:self didClickedBarcode:barcode signInBarcode:@""];
    }
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
