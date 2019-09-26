//
//  TFCustomImageCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/22.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomImageCell.h"

@interface TFCustomImageCell ()

/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 必填符号 */
@property (nonatomic, strong) UILabel *requireLabel;
/** borderView */
@property (nonatomic, strong) UIView *borderView;

@property (nonatomic, strong) UIImageView *imgView;

/** 图片 */
@property (nonatomic, strong) NSMutableArray *images;
/** 一行有几个 */
@property (nonatomic, assign) NSInteger column;
/** 按钮宽 */
@property (nonatomic, assign) CGFloat buttonWidth;
/** 按钮之间间距 */
@property (nonatomic, assign) CGFloat paddingWidth;

@property (nonatomic, strong) NSMutableArray *imageArr;

/** model */
@property (nonatomic, strong) TFCustomerRowsModel *model;


@end

@implementation TFCustomImageCell

- (NSMutableArray *)imageArr {
    
    if (!_imageArr) {
        
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (NSMutableArray *)images {
    
    if (!_images) {
        
        _images = [NSMutableArray array];
    }
    return _images;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.paddingWidth = 8.0;
        [self setupChildView];
        
    }
    return self;
}

- (void)setupChildView {
    
    UILabel *lable = [[UILabel alloc] init];
    [self.contentView addSubview:lable];
    lable.textColor = ExtraLightBlackTextColor;
    lable.font = FONT(14);
    self.titleLabel = lable;
    lable.numberOfLines = 0;
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(8);
        make.right.equalTo(self.contentView).with.offset(-15);
        
    }];
    
    
    UILabel *requi = [[UILabel alloc] init];
    requi.text = @"*";
    self.requireLabel = requi;
    requi.textColor = RedColor;
    requi.font = BFONT(14);
    requi.backgroundColor = ClearColor;
    [self.contentView addSubview:requi];
    requi.textAlignment = NSTextAlignmentLeft;
    [requi mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(6);
        make.top.equalTo(self.contentView).with.offset(8);
    }];
    
    UIView *borderView = [[UIView alloc] init];
    [self.contentView addSubview:borderView];
    self.borderView = borderView;
//    borderView.layer.cornerRadius = 4;
//    borderView.layer.borderWidth = 1;
//    borderView.layer.borderColor = HexColor(0xd5d5d5).CGColor;
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(5);
        make.top.equalTo(lable.mas_bottom).with.offset(8);
        make.bottom.equalTo(self.contentView).with.offset(-8);
        make.right.equalTo(self.contentView).with.offset(-5);
        
    }];
    self.bottomLine.hidden = NO;
    
}

/** 展示详情 */
//-(void)setShowEdit:(BOOL)showEdit{
//
//    _showEdit = showEdit;
//
//    if (showEdit) {// 框
//
//        self.borderView.layer.cornerRadius = 4;
//        self.borderView.layer.borderWidth = 1;
//        self.borderView.layer.borderColor = HexColor(0xd5d5d5).CGColor;
//        self.borderView.layer.shadowColor = ClearColor.CGColor;
//        self.borderView.layer.shadowOffset = CGSizeMake(0, 0);
//        self.borderView.layer.shadowRadius = 0;
//        self.borderView.layer.shadowOpacity = 0.5;
//        self.borderView.backgroundColor = ClearColor;
//
//    }else{// 阴影
//
//        self.borderView.layer.cornerRadius = 4;
//        self.borderView.layer.borderWidth = 0;
//        self.borderView.layer.borderColor = HexColor(0xd5d5d5).CGColor;
//        self.borderView.layer.shadowColor = HexColor(0xd5d5d5).CGColor;
//        self.borderView.layer.shadowOffset = CGSizeMake(0, 0);
//        self.borderView.layer.shadowRadius = 4;
//        self.borderView.layer.shadowOpacity = 0.5;
//        self.borderView.backgroundColor = WhiteColor;
//    }
//
//}


/** 必填控制 */
-(void)setFieldControl:(NSString *)fieldControl{
    _fieldControl = fieldControl;
    if ([fieldControl isEqualToString:@"2"]) {
        self.requireLabel.hidden = NO;
    }else{
        self.requireLabel.hidden = YES;
    }
    if ([fieldControl isEqualToString:@"1"]) {
        self.titleLabel.textColor = HexColor(0xb1b5bb);
    }else{
        self.titleLabel.textColor = ExtraLightBlackTextColor;
    }
}
/** 标题 */
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

/** 刷新cell
 *  @param model 模型
 *  @param type  类型 0：无加号  1：有加号
 *  @param column  一行几个
 */
- (void)refreshCustomImageCellWithModel:(TFCustomerRowsModel *)model withType:(NSInteger)type withColumn:(NSInteger)column{
    
    self.model = model;
    
    CGFloat head = 15;
    CGFloat title = 80;
    CGFloat empty = 20;
    self.headMargin = head;
    if ([model.field.structure isEqualToString:@"1"]) {// 左右
        // 标题
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).with.offset(head);
            make.top.equalTo(self.contentView.mas_top).with.offset(head);
            //            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-head);
            make.width.equalTo(@(title));
        }];
        // 必填
        [self.requireLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleLabel.mas_top);
            make.right.equalTo(self.titleLabel.mas_left);
            //            make.bottom.equalTo(self.titleLabel.mas_bottom);
            make.width.equalTo(@(8));
        }];
        // borderView
        [self.borderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.titleLabel.mas_right).with.offset(empty-5);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            make.top.equalTo(self.contentView.mas_top).with.offset(6);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-6);
        }];
        self.column = 5;
        self.buttonWidth = ((SCREEN_WIDTH - 100 - 20 - (self.column+1) * self.paddingWidth)/self.column);
        
    }else{
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(15);
            make.top.equalTo(self.contentView).with.offset(8);
            make.right.equalTo(self.contentView).with.offset(-15);
        }];
        
        [self.requireLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleLabel.mas_top);
            make.right.equalTo(self.titleLabel.mas_left);
            //            make.bottom.equalTo(self.titleLabel.mas_bottom);
            make.width.equalTo(@(8));
        }];
        
        [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(8);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(8);
            make.bottom.equalTo(self.contentView).with.offset(-8);
            make.right.equalTo(self.contentView).with.offset(-5);
            
        }];
        
        self.column = 7;
        self.buttonWidth = ((SCREEN_WIDTH - 20 - (self.column+1) * self.paddingWidth)/self.column);
    }
    
    
    self.images = model.selects;
    
    NSInteger num = self.images.count;
    if (type == 1) {
        
        num += 1;
    }
    
    
    for (UIImageView *imgView in self.imageArr) {
        
        [imgView removeFromSuperview];
    }

    [self.imageArr removeAllObjects];
    
    for (NSInteger i = 0; i < num; i ++) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, self.buttonWidth, self.buttonWidth)];
        imgView.layer.cornerRadius = 2.0;
        imgView.layer.masksToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.userInteractionEnabled = YES;
        imgView.tag = i;
        
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.tag = i;
        [delBtn addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:delBtn];
        
        if (i == self.images.count) {
            
            if (type == 1) { //有加号
        
                imgView.image = IMG(@"添加人");
                UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImages:)];
                addTap.numberOfTapsRequired = 1;
                [imgView addGestureRecognizer:addTap];
            }
            else {
                
                TFFileModel *fileModel = self.images[i];
                
                [imgView sd_setImageWithURL:[HQHelper URLWithString:fileModel.file_url] placeholderImage:nil];
                
                UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeImage:)];
                addTap.numberOfTapsRequired = 1;
                [imgView addGestureRecognizer:addTap];
            }
            
        }
        else {
            
            if (type == 1) { //有加号
                
                [delBtn setImage:IMG(@"删除Model") forState:UIControlStateNormal];
            }
            TFFileModel *fileModel = self.images[i];
            
            [imgView sd_setImageWithURL:[HQHelper URLWithString:fileModel.file_url] placeholderImage:nil];
            
            UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeImage:)];
            addTap.numberOfTapsRequired = 1;
            [imgView addGestureRecognizer:addTap];
        }
        
        
        
        [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {

            make.right.equalTo(@0);
            make.top.equalTo(@0);
            make.width.height.equalTo(@12);
        }];
        
        
        [self.borderView addSubview:imgView];
        
        [self.imageArr addObject:imgView];
    }
    
}

/** 高度 */
+(CGFloat)refreshCustomImageHeightWithModel:(TFCustomerRowsModel *)model withType:(NSInteger)type withColumn:(NSInteger)column{
    
    NSInteger index = 0;
    CGFloat paddingWidth = 8;// 图片之间的间距
    CGFloat buttonWidth = 0 ;
    if ([model.field.structure isEqualToString:@"1"]) {
        column = 5;
        // 图片的宽度
        buttonWidth = ((SCREEN_WIDTH - 100 - 20 - (column+1) * paddingWidth)/column);
    }else{
        column = 7;
        // 图片的宽度
        buttonWidth = ((SCREEN_WIDTH - 20 - (column+1) * paddingWidth)/column);
    }
    
    if (type == 1) {
        index += 1;// 加号
    }
    
    // 多少行
    NSInteger col = (model.selects.count + index +column-1) / column;
    
    CGFloat height = 8;// borderView 的上边距
    if ([model.field.structure isEqualToString:@"1"]) {
        if (col == 0) {
            height += 36;// 默认无图片的borderView的高度
        }else{
            height += (paddingWidth + col * (paddingWidth + buttonWidth));// 图片高度与图片之间的间距之和 == borderView的高度
        }
    }else{
        height += [HQHelper sizeWithFont:BFONT(14) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:model.label].height;// 标题高度
        height += 8;// borderView 与 标题的间距
        if (col == 0) {
            height += 36;// 默认无图片的borderView的高度
        }else{
            height += (paddingWidth + col * (paddingWidth + buttonWidth));// 图片高度与图片之间的间距之和 == borderView的高度
        }
    }
    return height;
    
}

-(void)layoutSubviews{

    [super layoutSubviews];

    for (NSInteger i = 0; i < self.imageArr.count; i ++) {

        UIImageView *imgView = self.imageArr[i];

        NSInteger row = i / self.column;
        NSInteger col = i % self.column;

        imgView.frame = CGRectMake(self.paddingWidth + col * (self.paddingWidth + self.buttonWidth), self.paddingWidth + row * (self.paddingWidth + self.buttonWidth), self.buttonWidth, self.buttonWidth);
    }

}

- (void)seeImage:(UIGestureRecognizer *)recognize {
    
    if ([self.delegate respondsToSelector:@selector(customImageCellSeeImageClicked:withModel:index:)]) {
        [self.delegate customImageCellSeeImageClicked:self withModel:self.model index:recognize.view.tag];
    }
}

- (void)addImages:(UIGestureRecognizer *)recognize {
    
    if ([self.delegate respondsToSelector:@selector(customImageCellAddImageClicked:withModel:)]) {
        
        [self.delegate customImageCellAddImageClicked:self withModel:self.model];
    }
}

- (void)delAction:(UIButton *)button {
    
    NSInteger tag = button.tag;
    [self.model.selects removeObjectAtIndex:tag];
    
    if ([self.delegate respondsToSelector:@selector(customImageCellDeleteImageClicked:)]) {
        
        [self.delegate customImageCellDeleteImageClicked:tag];
    }
}

+ (TFCustomImageCell *)CustomImageCellWithTableView:(UITableView *)tableView {
    
    static NSString *indentifier = @"TFCustomImageCell";
    TFCustomImageCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFCustomImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
