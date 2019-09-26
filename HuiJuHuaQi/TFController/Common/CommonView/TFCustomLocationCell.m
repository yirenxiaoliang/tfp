//
//  TFCustomLocationCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomLocationCell.h"
#import "HQSelectTimeCell.h"
#import "TFSingleTextCell.h"

@interface TFCustomLocationCell ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,TFSingleTextCellDelegate>

/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** TFCustomerRowsModel */
@property (nonatomic, strong) TFCustomerRowsModel *model;


@end

@implementation TFCustomLocationCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupTableView];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupTableView];
    }
    return self;
}

+ (TFCustomLocationCell *)customLocationCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFCustomLocationCell";
    TFCustomLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFCustomLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = NO;
    cell.layer.masksToBounds = YES;
    return cell;
}


- (void)customLocationCellWithModel:(TFCustomerRowsModel *)model{
    self.model = model;
    [self.tableView reloadData];
}

-(void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    
    [self.tableView reloadData];
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.scrollEnabled = NO;
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        
    }];
    
    
    UILabel *requi = [[UILabel alloc] init];
    requi.text = @"*";
    self.requireLabel = requi;
    requi.textColor = RedColor;
    requi.font = FONT(14);
    requi.backgroundColor = ClearColor;
    [self.contentView addSubview:requi];
    requi.textAlignment = NSTextAlignmentLeft;
    [requi mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(6);
        make.top.equalTo(self.contentView).with.offset(17);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(15);
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = self.model.label;
        if (self.model.otherDict) {
            cell.time.text = self.model.otherDict[@"address"];
            cell.time.textColor = BlackTextColor;
        }else{
            cell.time.text = @"请选择";
            cell.time.textColor = PlacehoderColor;
        }
        if ([self.model.field.fieldControl isEqualToString:@"2"]) {
            cell.requireLabel.hidden = NO;
        }else{
            cell.requireLabel.hidden = YES;
        }
        return cell;
        
    }else{
        
        TFSingleTextCell *cell = [TFSingleTextCell singleTextCellWithTableView:tableView];
        cell.titleLabel.text = @"详细地址";
        cell.textView.placeholder = @"请输入";
        cell.textView.delegate = self;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.textView.text = TEXT(self.model.fieldValue);
        cell.enterBtn.hidden = NO;
        [cell.enterBtn setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
        [cell.enterBtn setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateHighlighted];
        cell.enterBtn.tag = 0x777 *indexPath.section + indexPath.row;
        if ([self.model.field.fieldControl isEqualToString:@"2"]) {
            cell.requireLabel.hidden = NO;
        }else{
            cell.requireLabel.hidden = YES;
        }
        cell.delegate = self;
        if (self.isEdit) {
            cell.textView.userInteractionEnabled = YES;
        }else{
            cell.textView.userInteractionEnabled = NO;
        }
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (!self.isEdit) {
        return;
    }
    
    if (indexPath.row == 0) {
        if ([self.delegate respondsToSelector:@selector(customLocationCellWithSelectCity:)]) {
            [self.delegate customLocationCellWithSelectCity:self];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
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

#pragma mark - TFSingleTextCellDelegate
-(void)singleTextCell:(TFSingleTextCell *)singleTextCell didClilckedEnterBtn:(UIButton *)enterBtn{
    
    if ([self.delegate respondsToSelector:@selector(customLocationCell:didClilckedLocationBtn:)]) {
        [self.delegate customLocationCell:self didClilckedLocationBtn:enterBtn];
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if ([self.delegate respondsToSelector:@selector(customLocationCell:textViewDidChange:)]) {
        [self.delegate customLocationCell:self textViewDidChange:textView];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
