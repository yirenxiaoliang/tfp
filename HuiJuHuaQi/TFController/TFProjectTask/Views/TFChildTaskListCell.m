//
//  TFChildTaskListCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChildTaskListCell.h"
#import "TFChildTaskCell.h"
#import "TFChildTaskProgressView.h"
#import "TFProjectRowModel.h"

@interface TFChildTaskListCell ()<UITableViewDelegate,UITableViewDataSource,TFChildTaskCellDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** progressView */
@property (nonatomic, weak) TFChildTaskProgressView *progressView ;

/** tasks */
@property (nonatomic, strong) NSMutableArray *tasks;

/** footer */
@property (nonatomic, strong) UILabel *footer;

@end

@implementation TFChildTaskListCell

-(NSMutableArray *)tasks{
    if (!_tasks) {
        _tasks = [NSMutableArray array];
        [_tasks addObject:@""];
        [_tasks addObject:@""];
        [_tasks addObject:@""];
        [_tasks addObject:@""];
    }
    return _tasks;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupTableView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.masksToBounds = YES;
    }
    return self;
}


+ (TFChildTaskListCell *)childTaskListCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFChildTaskListCell";
    TFChildTaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TFChildTaskListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.topLine.hidden = NO;
    cell.bottomLine.hidden = YES;
    return cell;
}

-(void)refreshChildTaskListCellWithModels:(id)model add:(BOOL)add{
    
    self.tasks = model;
    
    if (add) {
        self.tableView.tableFooterView = self.footer;
        self.tableView.frame = CGRectMake(30, 1, SCREEN_WIDTH-30, 90+self.tasks.count * 50);
    }else{
        self.tableView.tableFooterView = nil;
        self.tableView.frame = CGRectMake(30, 1, SCREEN_WIDTH-30, 40+self.tasks.count * 50);
    }
    
    self.progressView.height = 40;
    
    NSInteger finish = 0;
    for (TFProjectRowModel *mo in self.tasks) {
        
        if ([[mo.finishType description] isEqualToString:@"1"]) {
            finish ++;
        }
    }
    
    if (finish == 0) {
        self.progressView.rate = 0;
    }else{
        self.progressView.rate = (finish*1.0)/self.tasks.count;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld/%ld",finish,self.tasks.count] attributes:@{NSForegroundColorAttributeName:GrayTextColor,NSFontAttributeName:FONT(14)}];
    
    [str addAttribute:NSForegroundColorAttributeName value:GreenColor range:[[NSString stringWithFormat:@"%ld/%ld",finish,self.tasks.count] rangeOfString:[NSString stringWithFormat:@"%ld",finish]]];
    self.progressView.progressLabel.attributedText = str;

    [self.tableView reloadData];
    
}


+(CGFloat)refreshChildTaskListCellHeightWithModels:(id)model add:(BOOL)add{
    
    NSArray *arr = model;
    if (add) {
        return 92 + arr.count * 50;
    }else{
        return 42 + arr.count * 50;
    }
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(30, 1, SCREEN_WIDTH-30, 0) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = WhiteColor;
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    tableView.scrollEnabled = NO;
    
    TFChildTaskProgressView *progressView = [TFChildTaskProgressView childTaskProgressView];
    progressView.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 40);
    tableView.tableHeaderView = progressView;
    self.progressView = progressView;
    
    UILabel *footer = [[UILabel alloc] initWithFrame:(CGRect){25,0,tableView.width,50}];
    footer.font = FONT(14);
    footer.textColor = ExtraLightBlackTextColor;
    footer.text = @"添加子任务";
    tableView.tableFooterView = footer;
    footer.userInteractionEnabled = YES;
    self.footer = footer;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerClicked)];
    [footer addGestureRecognizer:tap];
    
}

- (void)footerClicked{
    
    if ([self.delegate respondsToSelector:@selector(addChildTask)]) {
        [self.delegate addChildTask];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tasks.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFChildTaskCell *cell = [TFChildTaskCell childTaskCellWithTableView:tableView];
    cell.delegate = self;
    cell.tag = indexPath.row;
    cell.selectBtn.tag = indexPath.row;
    [cell refreshChildTaskCellWithModel:self.tasks[indexPath.row]];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if ([self.delegate respondsToSelector:@selector(childTaskDidSelectedWithModel:)]) {
        [self.delegate childTaskDidSelectedWithModel:self.tasks[indexPath.row]];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [TFChildTaskCell refreshChildTaskCellHeightWithModel:nil];
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

#pragma mark - TFChildTaskCellDelegate
-(void)childTaskCellDidClickedSelectBtn:(UIButton *)selectBtn{
    
    if ([self.delegate respondsToSelector:@selector(childTaskDidFinishedWithModel:)]) {
        [self.delegate childTaskDidFinishedWithModel:self.tasks[selectBtn.tag]];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
