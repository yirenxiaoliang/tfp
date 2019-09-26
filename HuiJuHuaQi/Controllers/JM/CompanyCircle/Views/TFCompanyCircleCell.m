//
//  TFCompanyCircleCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/19.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCompanyCircleCell.h"
#import "TFCompanyCirclePictureView.h"
#import "TFCommentView.h"
#import "HQCommentTableViewCell.h"
#import "HQStarTableCell.h"
#import "TFCompanyCircleDetailCommentCell.h"
#import "TFCompanyCircleDetailStarCell.h"

@interface TFCompanyCircleCell ()<UITableViewDelegate,UITableViewDataSource,HQStarTableCellDelegate,HQCommentTableViewCellDeleagate,TFCommentViewDelegate,TFCompanyCirclePictureViewDelegate,TFCompanyCircleDetailStarCellDelegate,TFCompanyCircleDetailCommentCellDeleagate>

/** 头像 */
@property (nonatomic, weak) UIButton *headBtn;
/** 名字 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 内容 */
@property (nonatomic, weak) UILabel *contentLabel;
/** 显示全部文字按钮 */
@property (nonatomic, weak) UIButton *allWordBtn;
/** 图片 */
@property (nonatomic, weak) TFCompanyCirclePictureView *pictureView;
/** 地址 */
@property (nonatomic, weak) UILabel *addressLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 删除按钮 */
@property (nonatomic, weak) UIButton *deleteBtn;
/** 显示分享、点赞、评论的按钮 */
@property (nonatomic, weak) UIButton *showBtn;
/** tableViw */
@property (nonatomic, weak) UITableView *tableView;
/** tableView背景 */
@property (nonatomic, weak) UIImageView *tableBackground;

@end

@implementation TFCompanyCircleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupChild];
    }
    return self;
}



- (void)setupChild{
    
    // 头像
    UIButton *headBtn = [HQHelper buttonWithFrame:CGRectZero target:self action:@selector(headClicked:)];
    [self.contentView addSubview:headBtn];
    self.headBtn = headBtn;
    headBtn.layer.cornerRadius = 20;
    headBtn.layer.masksToBounds = YES;
    
    // 名字
    UILabel *nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    nameLabel.textColor = GreenColor;
    nameLabel.font = FONT(16);
    
    // 内容
    UILabel *contentLabel = [[UILabel alloc] init];
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    contentLabel.textColor = BlackTextColor;
    contentLabel.numberOfLines = 0;
//    contentLabel.backgroundColor = RedColor;
    contentLabel.font = FONT(14);
    
    // 显示全文
    UIButton *allWordBtn = [HQHelper buttonWithFrame:CGRectZero target:self action:@selector(allWordBtnClicked:)];
    [self.contentView addSubview:allWordBtn];
    self.allWordBtn = allWordBtn;
    [allWordBtn setTitle:@"全文" forState:UIControlStateNormal];
    [allWordBtn setTitle:@"收起" forState:UIControlStateSelected];
    [allWordBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [allWordBtn setTitleColor:GreenColor forState:UIControlStateSelected];
    allWordBtn.titleLabel.font = FONT(14);
    
    
    // 图片
    TFCompanyCirclePictureView *pictureView = [[TFCompanyCirclePictureView alloc] init];
    [self.contentView addSubview:pictureView];
    self.pictureView = pictureView;
//    pictureView.backgroundColor = GreenColor;
    pictureView.delegate = self;
    
    // 地址
    UILabel *addressLabel = [[UILabel alloc] init];
    [self.contentView addSubview:addressLabel];
    self.addressLabel = addressLabel;
    addressLabel.font = FONT(12);
    addressLabel.textColor = GreenColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressClicked)];
    addressLabel.userInteractionEnabled = YES;
    [addressLabel addGestureRecognizer:tap];
    
    // 时间
    UILabel *timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    timeLabel.textColor = ExtraLightBlackTextColor;
    timeLabel.font = FONT(12);
    
    // 删除
    UIButton *deleteBtn = [HQHelper buttonWithFrame:CGRectZero target:self action:@selector(deleteBtnClicked:)];
    [self.contentView addSubview:deleteBtn];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = FONT(12);
    [deleteBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    self.deleteBtn = deleteBtn;
    
    // 显示按钮
    UIButton *showBtn = [HQHelper buttonWithFrame:CGRectZero target:self action:@selector(showBtnClicked:)];
    [self.contentView addSubview:showBtn];
    self.showBtn = showBtn;
    [showBtn setImage:[UIImage imageNamed:@"评论companyCircle"] forState:UIControlStateNormal];
    [showBtn setImage:[UIImage imageNamed:@"评论companyCircle"] forState:UIControlStateHighlighted];
    
    // tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
//    tableView.backgroundColor = BackGroudColor;
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    tableView.scrollEnabled = NO;
    
    // commentView
    TFCommentView *commentView = [[TFCommentView alloc] init];
    [self.contentView addSubview:commentView];
    self.commentView = commentView;
    commentView.delegate = self;
    
}

-(void)setFrameModel:(TFCompanyCircleFrameModel *)frameModel{
    
    _frameModel = frameModel;
    
    HQCategoryItemModel *model = frameModel.circleItem;
    
    [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            [self.headBtn setTitle:@"" forState:UIControlStateNormal];
            [self.headBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        }else{
            [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.headBtn setTitleColor:WhiteColor forState:UIControlStateHighlighted];
            [self.headBtn setTitle:[HQHelper nameWithTotalName:model.employeeName] forState:UIControlStateNormal];
            [self.headBtn setTitle:[HQHelper nameWithTotalName:model.employeeName] forState:UIControlStateHighlighted];
            [self.headBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            [self.headBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
            self.headBtn.titleLabel.font = FONT(16);
             
        }
    }];
//    [self.headBtn sd_setImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
    self.nameLabel.text = model.employeeName;
    self.contentLabel.text = model.info;
    [self.pictureView refreshCompanyCirclePictureViewWithImages:model.images];
    self.addressLabel.text = model.address;
    self.timeLabel.text = [HQHelper companyCircleTimeWithTimeSp:[model.datetimeCreateDate longLongValue]];
    
    self.headBtn.frame = frameModel.headBtnFrame;
    self.nameLabel.frame = frameModel.nameLabelFrame;
    self.contentLabel.frame = frameModel.contentLabelFrame;
    self.contentLabel.hidden = frameModel.contentLabelHidden;
    self.allWordBtn.frame = frameModel.allWordBtnFrame;
    self.allWordBtn.hidden = frameModel.allWordBtnHidden;
    self.pictureView.frame = frameModel.pictureViewFrame;
    self.pictureView.hidden = frameModel.pictureViewHidden;
    self.addressLabel.frame = frameModel.addressLabelFrame;
    self.addressLabel.hidden = frameModel.addressLabelHidden;
    self.timeLabel.frame = frameModel.timeLabelFrame;
    self.deleteBtn.frame = frameModel.deleteBtnFrame;
    self.showBtn.frame = frameModel.showBtnFrame;
    self.commentView.frame = frameModel.commentViewFrame;
    
    if ([model.commentShow isEqualToNumber:@0]) {
        [self.commentView dismiss];
    }else{
        [self.commentView show];
    }
    
    if ([model.allWordShow isEqualToNumber:@0]) {
        self.allWordBtn.selected = NO;
    }else{
        self.allWordBtn.selected = YES;
    }
    if ([model.employeeId isEqualToString:[UM.userLoginInfo.employee.id description]]) {
        self.deleteBtn.hidden = NO;
    }else{
        self.deleteBtn.hidden = YES;
    }
    
    
    if ([model.isPraise isEqualToNumber:@0]) {
        self.commentView.good = NO;
    }else{
        self.commentView.good = YES;
    }
    
    self.tableView.frame = frameModel.tableViewFrame;
    self.tableView.hidden = frameModel.tableViewHidden;
    
    // tableView背景
    if (!self.tableView.backgroundView) {
        
        UIImageView *tableBackground=[[UIImageView alloc]initWithFrame:self.tableView.bounds];
        [self.tableView setBackgroundView:tableBackground];
        NSInteger leftCapWidth = 30 * 0.9f;
        NSInteger topCapHeight = 35 * 0.9f;
        tableBackground.image=[[UIImage imageNamed:@"企业圈评论paopao"] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        self.tableBackground = tableBackground;
    }
    [self.tableView reloadData];
}


/** 点击头像 */
- (void)headClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(companyCircleCell:didClickedHeadBtn:)]) {
        [self.delegate companyCircleCell:self didClickedHeadBtn:button];
    }
    
}
/** 点击地址 */
- (void)addressClicked{
    
    if ([self.delegate respondsToSelector:@selector(companyCircleCell:didClickedAddressWithLongitude:withLatitude:)]) {
        [self.delegate companyCircleCell:self didClickedAddressWithLongitude:@([self.frameModel.circleItem.longitude doubleValue]) withLatitude:@([self.frameModel.circleItem.latitude doubleValue])];
    }
}

/** 点击显示分享、点赞、评论 */
- (void)showBtnClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(companyCircleCell:didClickedShowBtn:)]) {
        [self.delegate companyCircleCell:self didClickedShowBtn:button];
    }
    
    button.selected = !button.selected;
    self.frameModel.circleItem.commentShow = button.selected?@1:@0;
    if (!button.selected) {
        [self.commentView dismiss];
    }else{
        [self.commentView show];
    }
}
/** 显示全文 */
- (void)allWordBtnClicked:(UIButton *)button{
    
    button.selected = !button.selected;
    self.frameModel.circleItem.allWordShow = button.selected?@1:@0;
    
    if ([self.delegate respondsToSelector:@selector(companyCircleCell:didClickedAllWordBtn:)]) {
        [self.delegate companyCircleCell:self didClickedAllWordBtn:button];
    }
    
}

/** 删除 */
- (void)deleteBtnClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(companyCircleCell:didClickedDeleteBtn:)]) {
        [self.delegate companyCircleCell:self didClickedDeleteBtn:button];
    }
    
}

/** 评论框消失 */
-(void)commentDismiss{
    
    [self showBtnClicked:self.showBtn];
    
}

#pragma mark - TFCompanyCirclePictureViewDelegate

-(void)companyCirclePictureViewWithImageViews:(NSArray *)imageViews didImageViewWithIndex:(NSInteger)index{
    
    if ([self.delegate respondsToSelector:@selector(companyCircleCell:pictureViewWithImageViews:didImageViewWithIndex:)]) {
        [self.delegate companyCircleCell:self pictureViewWithImageViews:imageViews didImageViewWithIndex:index];
    }
    
}

/** 刷新内部tableView */
-(void)refreshInfinorTable{
    
    [self.tableView reloadData];
}


#pragma mark - TFCommentViewDelegate
-(void)commentViewDidClickedShareBtn:(UIButton *)button{
    
    self.showBtn.selected = NO;
    self.frameModel.circleItem.commentShow = @0;
    
    if ([self.delegate respondsToSelector:@selector(companyCircleCell:didClickedShareBtn:)]) {
        [self.delegate companyCircleCell:self didClickedShareBtn:button];
    }
}

-(void)commentViewDidClickedGoodBtn:(UIButton *)button{
    
    button.selected = !button.selected;
    self.commentView.good = button.selected;
    self.showBtn.selected = NO;
    self.frameModel.circleItem.isPraise = button.selected?@1:@0;
    self.frameModel.circleItem.commentShow = @0;
    
    if ([self.delegate respondsToSelector:@selector(companyCircleCell:didClickedGoodBtn:)]) {
        [self.delegate companyCircleCell:self didClickedGoodBtn:button];
    }
}

-(void)commentViewDidClickedCommentBtn:(UIButton *)button{
    
    self.showBtn.selected = NO;
    self.frameModel.circleItem.commentShow = @0;
    
    if ([self.delegate respondsToSelector:@selector(companyCircleCell:withCommentItem:didClickedCommentBtn:)]) {
        [self.delegate companyCircleCell:self withCommentItem:self.frameModel.circleItem didClickedCommentBtn:button];
    }
}

#pragma mark - HQStarTableCellDelegate
-(void)senderEmployIdToCtr:(HQEmployModel *)employ{
    
    if ([self.delegate respondsToSelector:@selector(companyCircleCell:didClickedGoodPeople:)]) {
        
        [self.delegate companyCircleCell:self didClickedGoodPeople:employ];
    }
}

#pragma mark - HQCommentTableViewCellDelegate
-(void)pushPeopleImfo:(HQEmployModel *)people{
    
    if ([self.delegate respondsToSelector:@selector(companyCircleCell:didClickedGoodPeople:)]) {
        
        [self.delegate companyCircleCell:self didClickedGoodPeople:people];
    }
}

-(void)didClickContent:(HQCommentItemModel *)commentItem index:(NSInteger)index{
    
    if ([self.delegate respondsToSelector:@selector(companyCircleCell:withCommentItem:index:)]) {
        [self.delegate companyCircleCell:self withCommentItem:commentItem index:index];
    }
}

#pragma mark - TFCompanyCircleDetailStarCellDelegate
-(void)companyCircleDetailStarCellDidPeople:(HQEmployModel *)employ{
    if ([self.delegate respondsToSelector:@selector(companyCircleCell:didClickedGoodPeople:)]) {
        
        [self.delegate companyCircleCell:self didClickedGoodPeople:employ];
    }
}

#pragma mark - companyCircleDetailCommentCellDidClickContent

- (void)companyCircleDetailCommentCellWithPeopleImfo:(HQEmployModel *)people{
    
    if ([self.delegate respondsToSelector:@selector(companyCircleCell:didClickedGoodPeople:)]) {
        
        [self.delegate companyCircleCell:self didClickedGoodPeople:people];
    }
}
- (void)companyCircleDetailCommentCellDidClickContent:(HQCommentItemModel *)commentItem index:(NSInteger)index{
    
    if ([self.delegate respondsToSelector:@selector(companyCircleCell:withCommentItem:index:)]) {
        [self.delegate companyCircleCell:self withCommentItem:commentItem index:index];
    }
}
-(void)didLongPressToDelete:(HQCommentItemModel *)commentItem index:(NSInteger)index{
    
    if (![commentItem.senderId isEqualToNumber:UM.userLoginInfo.employee.id]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(companyCircleCell:didLongPressWithCommentItem:index:)]) {
        [self.delegate companyCircleCell:self didLongPressWithCommentItem:commentItem index:index];
    }
}

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.frameModel.circleItem.commentList.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.frameModel.type == 0) {
        
        if (indexPath.section == 0) {
            
            HQStarTableCell *cell = [HQStarTableCell starTableCellWithTableView:tableView];
            cell.headMargin = 0;
            cell.delegate  = self;
            [cell refreshCellWithPeoples:self.frameModel.circleItem.praiseList];
            if (self.frameModel.circleItem.praiseList.count && self.frameModel.circleItem.commentList.count == 0) {
                
                cell.bottomLine.hidden = YES;
            }else{
                cell.bottomLine.hidden = NO;
            }
            return cell;
        }else{
            
            HQCommentTableViewCell *cell = [HQCommentTableViewCell commentTableViewCellWithTableView:tableView];
            [cell refreshCellForCommentItemModel:self.frameModel.circleItem.commentList[indexPath.row]];
            cell.delegate = self;
            cell.tag = 0x123 + indexPath.row;
            return cell;
        }

    }else{
        
        if (indexPath.section == 0) {
            
            TFCompanyCircleDetailStarCell *cell = [TFCompanyCircleDetailStarCell companyCircleDetailStarCellWithTableView:tableView];
            cell.headMargin = 0;
            cell.delegate  = self;
            [cell refreshCompanyCircleDetailStarCellWithPeoples:self.frameModel.circleItem.praiseList];
            
            if (self.frameModel.circleItem.praiseList.count && self.frameModel.circleItem.commentList.count == 0) {
                
                cell.bottomLine.hidden = YES;
            }else{
                cell.bottomLine.hidden = NO;
            }
            return cell;
        }else{
            
            TFCompanyCircleDetailCommentCell *cell = [TFCompanyCircleDetailCommentCell companyCircleDetailCommentCellWithTableView:tableView];
            [cell refreshCompanyCircleDetailCommentCellForCommentItemModel:self.frameModel.circleItem.commentList[indexPath.row]];
            cell.delegate = self;
            cell.tag = 0x123 + indexPath.row;
            
            if (indexPath.row == 0) {
                cell.hiddenMark = NO;
            }else{
                cell.hiddenMark = YES;
            }
            
            if (indexPath.row == self.frameModel.circleItem.commentList.count - 1) {
                cell.bottomLine.hidden = YES;
            }else{
                cell.bottomLine.hidden = NO;
            }
            
            return cell;
        }

    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.frameModel.type == 0) {
        
        if (indexPath.section == 0) {
            return [HQStarTableCell refreshCellHeightWithPeoples:self.frameModel.circleItem.praiseList];
        }else{
            return [HQCommentTableViewCell refreshCellHeightwithCommentItemModel:self.frameModel.circleItem.commentList[indexPath.row]];
        }
    }else{
        
        if (indexPath.section == 0) {
            return [TFCompanyCircleDetailStarCell refreshCompanyCircleDetailStarCellHeightWithPeoples:self.frameModel.circleItem.praiseList];
        }else{
            return [TFCompanyCircleDetailCommentCell refreshCompanyCircleDetailCommentCellHeightWithModel:self.frameModel.circleItem.commentList[indexPath.row]];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 4;
    }
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


+(instancetype)companyCircleCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFCompanyCircleCell";
    TFCompanyCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFCompanyCircleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = NO;
    cell.headMargin = 0;
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
