//
//  TFTaskDetailFileCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/18.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskDetailFileCell.h"
#import "TFSingleAttachmentCell.h"

@interface TFTaskDetailFileCell ()<UITableViewDelegate,UITableViewDataSource,TFSingleAttachmentCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addFileBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *files;

@end

@implementation TFTaskDetailFileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textColor = ExtraLightBlackTextColor;
    self.titleLabel.font = FONT(14);
    self.addFileBtn.titleLabel.font = FONT(14);
    [self.addFileBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [self.addFileBtn setTitleColor:LightGrayTextColor forState:UIControlStateHighlighted];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.addFileBtn addTarget:self action:@selector(addAttachmentsAction) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


-(void)refreshTaskDetailCellWithFiles:(NSMutableArray *)files{
    self.files = files;
    [self.tableView reloadData];
}
+(CGFloat)refreshTaskDetailCellHeightWithFiles:(NSMutableArray *)files{
    return 44 + files.count * 48;
}
+(instancetype)taskDetailFileCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFTaskDetailFileCell" owner:self options:nil] lastObject];
}
+(instancetype)taskDetailFileCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFTaskDetailFileCell";
    TFTaskDetailFileCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFTaskDetailFileCell taskDetailFileCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.files.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFFileModel *fileModel = self.files[indexPath.row];
    TFSingleAttachmentCell *cell = [TFSingleAttachmentCell SingleAttachmentCellWithTableView:tableView];
    cell.type = (NSInteger)self.type;
    cell.delegate = self;
    cell.btnIndex = indexPath.row;
    [cell refreshSingleAttachmentCellWithModel:fileModel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    if ([self.delegate respondsToSelector:@selector(lookWithCell:didClickedFile:index:)]) {
        [self.delegate lookWithCell:self didClickedFile:self.files[indexPath.row] index:indexPath.row];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
#pragma mark TFSingleAttachmentCellDelegate
- (void)deleteAttachmentAction:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(deletefileWithIndex:)]) {
        [self.delegate deletefileWithIndex:index];
    }
}

- (void)addAttachmentsAction {
    if ([self.delegate respondsToSelector:@selector(addfileClickedWithCell:)]) {
        [self.delegate addfileClickedWithCell:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
