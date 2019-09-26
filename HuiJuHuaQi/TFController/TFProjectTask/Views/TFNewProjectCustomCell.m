//
//  TFNewProjectCustomCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/28.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNewProjectCustomCell.h"
#import "TFCustomListItemModel.h"
#import "TFCustomListCell.h"


@interface TFNewProjectCustomCell ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, weak) UIView *bgView;

@property (nonatomic, weak) UITableView *tableView;


@property (nonatomic, weak) UIButton *clearBtn;
@property (nonatomic, strong) TFProjectRowModel *row;


@property (nonatomic, weak) UIImageView *selectBtn;


@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation TFNewProjectCustomCell


+(instancetype)newProjectCustomCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFNewProjectCustomCell";
    TFNewProjectCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TFNewProjectCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupTableView];
    }
    return self;
}


-(void)setFrameModel:(TFProjectRowFrameModel *)frameModel{
    
    _frameModel = frameModel;
    self.row = frameModel.projectRow;
    
    [self.tableView reloadData];
    
//    self.bgView.frame = frameModel.bgViewFrame;
//
//    self.selectBtn.frame = frameModel.selectBtnFrame;
//
    if ([[frameModel.projectRow.icon_type description] isEqualToString:@"1"]) {// 网络图片
        [self.selectBtn sd_setImageWithURL:[HQHelper URLWithString:frameModel.projectRow.icon_url]];
        self.selectBtn.contentMode = UIViewContentModeScaleToFill;
    }else{// 本地图片
        if (frameModel.projectRow.icon_url && ![frameModel.projectRow.icon_url isEqualToString:@""] && ![frameModel.projectRow.icon_url isEqualToString:@"null"]) {
            [self.selectBtn setImage:IMG(frameModel.projectRow.icon_url)];
            self.selectBtn.backgroundColor = [HQHelper colorWithHexString:frameModel.projectRow.icon_color]?[HQHelper colorWithHexString:frameModel.projectRow.icon_color]:GreenColor;
        }
        self.selectBtn.contentMode = UIViewContentModeScaleToFill;
    }


    self.titleLabel.text = frameModel.projectRow.module_name;
//    if (row.row.count) {
//        self.titleLabel.text = [HQHelper stringWithFieldNameModel:row.row[0]];
//    }
//
//    self.headBtn.frame = frameModel.headBtnFrame;
//    TFEmployModel *em = nil;
//    for (TFFieldNameModel *model in row.row) {
//        if ([model.name containsString:@"principal"]) {
//            NSArray *arr = [HQHelper dictionaryWithJsonString:model.value];
//            if (arr.count) {
//                em = [[TFEmployModel alloc] initWithDictionary:arr[0] error:nil];
//            }
//        }
//    }
//    if (em) {
//        self.headBtn.hidden = NO;
//        [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:em.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (image) {
//                [self.headBtn setTitle:@"" forState:UIControlStateNormal];
//            }else{
//                [self.headBtn setTitle:[HQHelper nameWithTotalName:em.employee_name?:em.name] forState:UIControlStateNormal];
//                [self.headBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
//                self.headBtn.titleLabel.font = FONT(12);
//                [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
//            }
//        }];
//    }else{
//        self.headBtn.hidden = YES;
//    }
//
//    NSMutableArray *values = [NSMutableArray array];
//
//    for (NSInteger i = 1; i < row.row.count; i++) {
//        TFFieldNameModel *fe = row.row[i];
//        if ([fe.name containsString:@"principal"]) {
//            continue;
//        }
//        [values addObject:fe];
//    }
//    for (UILabel *la in self.labels) {
//        la.hidden = YES;
//    }
//    for (NSInteger i = 0; i < (values.count>6?6:values.count); i++) {
//
//        TFFieldNameModel *fe = values[i];
//        UILabel *label = self.labels[i];
//        label.text = [HQHelper stringWithFieldNameModel:fe];
//        label.hidden = NO;
//    }
//
//    for (NSInteger i = 0; i < (frameModel.labels.count>6?6:frameModel.labels.count); i ++) {
//        UILabel *la = self.labels[i];
//        NSValue *va = frameModel.labels[i];
//        la.frame = [va CGRectValue];
//    }
}

-(void)setKnowledge:(NSInteger)knowledge{
    _knowledge = knowledge;
    
    if (knowledge == 1) {
        
//        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView).offset(5);
//            make.bottom.equalTo(self.contentView).offset(-5);
//            make.left.equalTo(self.contentView).offset(15);
//            make.right.equalTo(self.contentView).offset(-15);
//        }];
        self.contentView.backgroundColor = WhiteColor;
        self.backgroundColor = WhiteColor;
        self.bgView.backgroundColor = WhiteColor;
        self.bgView.layer.shadowColor = LightGrayTextColor.CGColor;
        self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
        self.bgView.layer.shadowRadius = 4;
        self.bgView.layer.shadowOpacity = 0.5;
        
    }else if (knowledge == 2){
        
//        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView).offset(5);
//            make.bottom.equalTo(self.contentView).offset(-5);
//            make.left.equalTo(self.contentView).offset(15);
//            make.right.equalTo(self.contentView).offset(-15);
//        }];
        self.contentView.backgroundColor = WhiteColor;
        self.backgroundColor = WhiteColor;
        self.bgView.backgroundColor = BackGroudColor;
//        self.bgView.layer.shadowColor = HexColor(0xd5d5d5).CGColor;
//        self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
//        self.bgView.layer.shadowRadius = 0;
//        self.bgView.layer.shadowOpacity = 1;
        
    }
}
-(void)setEdit:(BOOL)edit{
    _edit = edit;
    self.clearBtn.hidden = !edit;
    if (edit) {
        [self.clearBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@30);
        }];
    }else{
        [self.clearBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    }
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:clearBtn];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-8);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.width.equalTo(@30);
    }];
    clearBtn.hidden = YES;
    self.clearBtn = clearBtn;
    clearBtn.contentMode = UIViewContentModeCenter;
    clearBtn.imageView.contentMode = UIViewContentModeCenter;
    [clearBtn setImage:IMG(@"清除") forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bgView = [[UIView alloc] init];
    self.bgView = bgView;
    [self.contentView insertSubview:bgView atIndex:0];
    bgView.layer.cornerRadius = 4;
    bgView.backgroundColor = WhiteColor;
    bgView.layer.shadowColor = LightGrayTextColor.CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0, 0);
    bgView.layer.shadowRadius = 4;
    bgView.layer.shadowOpacity = 0.5;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(clearBtn.mas_left).offset(-8);
    }];
    
    UIImageView *selectBtn = [[UIImageView alloc] init];
    [bgView addSubview:selectBtn];
    selectBtn.layer.masksToBounds = YES;
    selectBtn.layer.cornerRadius = 2;
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(15);
        make.top.equalTo(bgView).offset(12);
        make.width.equalTo(@(20));
        make.height.equalTo(@(20));
    }];
    self.selectBtn = selectBtn;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [bgView addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    titleLabel.font = FONT(14);
    titleLabel.textColor = BlackTextColor;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(selectBtn.mas_right).offset(8);
        make.right.equalTo(bgView).offset(-15);
        make.centerY.equalTo(selectBtn.mas_centerY);
    }];
    self.titleLabel = titleLabel;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = ClearColor;
    tableView.scrollEnabled = NO;
    [bgView addSubview:tableView];
    tableView.userInteractionEnabled = NO;
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(0);
        make.bottom.equalTo(bgView).offset(-4);
        make.left.equalTo(titleLabel).offset(-18);
        make.right.equalTo(bgView).offset(-15);
    }];
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = ClearColor;
    self.contentView.backgroundColor = ClearColor;
    
    UIImageView *selectImage = [[UIImageView alloc] initWithImage:IMG(@"完成")];
    self.selectImage = selectImage;
    [self.bgView addSubview:selectImage];
    [selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.top.equalTo(self.bgView);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    selectImage.hidden = YES;
}

-(void)clearClicked{
    if ([self.delegate respondsToSelector:@selector(newProjectCustomCellDidClickedClearBtn:)]) {
        [self.delegate newProjectCustomCellDidClickedClearBtn:self];
    }
}

#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TFCustomListItemModel *model = [[TFCustomListItemModel alloc] init];
    model.row = self.row.rows;
    
    TFCustomListCell *cell = [TFCustomListCell customListCellWithTableView:tableView];
    [cell refreshCustomListCellWithModel:model];
    cell.backgroundColor = ClearColor;
    cell.contentView.backgroundColor = ClearColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.frameModel.cellHeight;
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



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
