//
//  TFWorkEnterCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFWorkEnterCell.h"
#import "TFEnterItemView.h"
#import "TFBeanTypeModel.h"
#import "TFEnterCustomCell.h"

@interface TFWorkEnterCell ()<UITableViewDelegate,UITableViewDataSource,TFEnterItemViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showW;

/** 头部样式 */
@property (nonatomic, assign) NSInteger type;
/** 底部样式 */
@property (nonatomic, assign) NSInteger bottomType;
/** 底部按钮 */
@property (nonatomic, strong) NSMutableArray *items;
/** 子菜单s */
@property (nonatomic, strong) NSMutableArray *submenus;
/** 模块 */
@property (nonatomic, strong) TFModuleModel *module;

@property (nonatomic, strong) TFEnterItemView *footerView;

@end

@implementation TFWorkEnterCell

- (NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
- (NSMutableArray *)submenus{
    if (!_submenus) {
        _submenus = [NSMutableArray array];
    }
    return _submenus;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.addBtn.hidden = YES;
    self.line.hidden = YES;
    self.showBtn.hidden = YES;
    self.tableView.hidden = YES;
    self.nameLabel.textColor = LightBlackTextColor;
    self.nameLabel.font = FONT(14);
    self.backgroundColor = ClearColor;
    self.headerView.layer.cornerRadius = 4;
    self.line.backgroundColor = CellSeparatorColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewDidClicked)];
    [self.headerView addGestureRecognizer:tap];
    
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.shadowRadius = 4;
    self.bgView.layer.shadowColor = CellSeparatorColor.CGColor;
    self.bgView.layer.shadowOffset = CGSizeZero;
    self.bgView.layer.shadowOpacity = 0.5;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = HexColor(0xF6F7F8);
    self.tableView.layer.cornerRadius = 4;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.showBtn.transform = CGAffineTransformRotate(self.showBtn.transform, M_PI_2);
    self.contentView.backgroundColor = ClearColor;
    self.backgroundColor = ClearColor;
    self.bgView.backgroundColor = ClearColor;
    UIView *white = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH-16,5}];
    white.backgroundColor= WhiteColor;
    self.tableView.tableHeaderView = white;
    
    self.imageButton.layer.cornerRadius = 4;
    self.imageButton.layer.masksToBounds = YES;
    self.imageButton.userInteractionEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    TFEnterItemView *view = [[TFEnterItemView alloc] init];
    view.delegate = self;
    self.footerView = view;
    
}

-(void)headerViewDidClicked{
    if ([self.delegate respondsToSelector:@selector(workEnterCellEnterMainWithModule:)]) {
        [self.delegate workEnterCellEnterMainWithModule:self.module];
    }
}

- (IBAction)showClicked:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
//    [UIView animateWithDuration:0.25 animations:^{
        self.showBtn.transform = CGAffineTransformRotate(self.showBtn.transform,M_PI);
//    }];
    
    self.module.select = [self.module.select isEqualToNumber:@1]?@0:@1;
    
    if ([self.delegate respondsToSelector:@selector(workEnterCellDidClickedShow:module:)]) {
        [self.delegate workEnterCellDidClickedShow:sender.selected module:self.module];
    }
}
- (IBAction)addClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(workEnterCellDidClickedAddWithModule:)]) {
        [self.delegate workEnterCellDidClickedAddWithModule:self.module];
    }
    
}

-(void)refreshWorkEnterCellWithModule:(TFModuleModel *)module{
    self.module = module;
    self.imageButton.backgroundColor = WhiteColor;
    if ([module.english_name isEqualToString:@"data"]) {
        self.type = 0;
        self.bottomType = 0;
        [self.imageButton setBackgroundImage:IMG(@"数据") forState:UIControlStateNormal];
        self.nameLabel.text = @"数据分析";
        [self.footerView refreshNums:@[]];
    }else if ([module.english_name isEqualToString:@"attendance"]){
        self.type = 0;
        self.bottomType = 0;
        [self.imageButton setBackgroundImage:IMG(@"考勤") forState:UIControlStateNormal];
        self.nameLabel.text = @"考勤";
        [self.footerView refreshNums:@[]];
    }else if ([module.english_name isEqualToString:@"project"]){
        self.type = 0;
        self.bottomType = 0;
        [self.imageButton setBackgroundImage:IMG(@"协作") forState:UIControlStateNormal];
        self.nameLabel.text = @"协作";
        [self.footerView refreshNums:@[]];
    }else if ([module.english_name isEqualToString:@"memo"]){
        self.type = 1;
        self.bottomType = 0;
        [self.imageButton setBackgroundImage:IMG(@"备忘录") forState:UIControlStateNormal];
        self.nameLabel.text = @"备忘录";
        [self.footerView refreshNums:@[]];
    }else if ([module.english_name isEqualToString:@"repository_libraries"]){
        self.type = 0;
        self.bottomType = 0;
        [self.imageButton setBackgroundImage:IMG(@"知识库") forState:UIControlStateNormal];
        self.nameLabel.text = @"知识库";
        [self.footerView refreshNums:@[]];
    }else if ([module.english_name isEqualToString:@"library"]){
        self.type = 2;
        self.bottomType = 3;
        [self.imageButton setBackgroundImage:IMG(@"文件库") forState:UIControlStateNormal];
        self.nameLabel.text = @"文件库";
        [self.footerView refreshNums:@[]];
    }else if ([module.english_name isEqualToString:@"email"]){
        self.type = 3;
        self.bottomType = 1;
        [self.imageButton setBackgroundImage:IMG(@"邮件") forState:UIControlStateNormal];
        self.nameLabel.text = @"邮件";
        [self.footerView refreshNums:module.emailUnreads];
    }else if ([module.english_name isEqualToString:@"approval"]){
        self.type = 3;
        self.bottomType = 2;
        [self.imageButton setBackgroundImage:IMG(@"审批") forState:UIControlStateNormal];
        self.nameLabel.text = @"审批";
        [self.footerView refreshNums:module.approvalUnreads];
    }else if ([module.english_name containsString:@"bean"]){
        self.type = 3;
        self.bottomType = 4;
        [self.footerView refreshNums:@[]];
        self.nameLabel.text = module.chinese_name;
        if ([module.icon_type isEqualToString:@"1"]) {// 网络图片
            [self.imageButton sd_setBackgroundImageWithURL:[HQHelper URLWithString:module.icon_url] forState:UIControlStateNormal];
            self.imageButton.contentMode = UIViewContentModeScaleToFill;
        }else{// 本地图片
            if (module.icon && ![module.icon isEqualToString:@""] && ![module.icon isEqualToString:@"null"]) {
                [self.imageButton setImage:IMG(module.icon) forState:UIControlStateNormal];
                self.imageButton.backgroundColor = [HQHelper colorWithHexString:module.icon_color]?[HQHelper colorWithHexString:module.icon_color]:GreenColor;
            }else if (module.icon_url && ![module.icon_url isEqualToString:@""] && ![module.icon_url isEqualToString:@"null"]) {
                [self.imageButton setBackgroundImage:IMG(module.icon_url) forState:UIControlStateNormal];
                self.imageButton.backgroundColor = [HQHelper colorWithHexString:module.icon_color]?[HQHelper colorWithHexString:module.icon_color]:GreenColor;
            }else{
                [self.imageButton setBackgroundImage:IMG(module.chinese_name) forState:UIControlStateNormal];
                self.imageButton.backgroundColor = WhiteColor;
            }
            self.imageButton.contentMode = UIViewContentModeCenter;
        }
    }
    
    
    
}

-(void)setType:(NSInteger)type{
    _type = type;
    
    switch (type) {
        case 0:// 白板
        {
            self.addBtn.hidden = YES;
            self.line.hidden = YES;
            self.showBtn.hidden = YES;
            self.tableView.hidden = YES;
            self.showW.constant = 0;
        }
            break;
        case 1:// 加号
        {
            self.addBtn.hidden = NO;
            self.line.hidden = YES;
            self.showBtn.hidden = YES;
            self.showW.constant = 0;
            self.tableView.hidden = YES;
        }
            break;
        case 2:// 展示
        {
            self.addBtn.hidden = YES;
            self.line.hidden = YES;
            self.showBtn.hidden = NO;
            self.tableView.hidden = YES;
            self.showW.constant = 50;
        }
            break;
        case 3:// 加号和展示
        {
            self.addBtn.hidden = NO;
            self.line.hidden = NO;
            self.showBtn.hidden = NO;
            self.showW.constant = 50;
            self.tableView.hidden = YES;
        }
            break;
            
        default:
        {
            
            self.addBtn.hidden = YES;
            self.line.hidden = YES;
            self.showBtn.hidden = YES;
            self.tableView.hidden = YES;
            self.showW.constant = 0;
        }
            break;
    }
}

-(void)setBottomType:(NSInteger)bottomType{
    _bottomType = bottomType;
    switch (bottomType) {
        case 0:
            {
                self.tableView.hidden = YES;
                self.footerView.items = self.items;
                self.tableView.tableFooterView = nil;
            }
            break;
        case 1:// 邮件
            {
                NSArray *images = @[@"receiveEnter",@"sendEnter",@"draftEnter"];
                NSArray *names = @[@"收件箱",@"发件箱",@"草稿箱"];
                [self.items removeAllObjects];
                for (NSInteger i = 0; i < images.count; i ++) {
                    ButtonInfo *info = [[ButtonInfo alloc] init];
                    info.image = images[i];
                    info.name = names[i];
//                    info.number = 4;
                    [self.items addObject:info];
                }
                self.tableView.hidden = NO;
                self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH-16, [TFEnterItemView enterItemViewHeightWithItems:self.items]);
                self.footerView.items = self.items;
                self.tableView.tableFooterView = self.footerView;
            }
            break;
        case 2:// 审批
        {
            NSArray *images = @[@"待我审批-o",@"抄送到我-o",@"我发起的-o"];
            NSArray *names =  @[@"待我审批",@"抄送到我",@"我发起的"];
            [self.items removeAllObjects];
            for (NSInteger i = 0; i < images.count; i ++) {
                ButtonInfo *info = [[ButtonInfo alloc] init];
                info.image = images[i];
                info.name = names[i];
//                info.number = 4;
                [self.items addObject:info];
            }
            self.tableView.hidden = NO;
            self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH-16, [TFEnterItemView enterItemViewHeightWithItems:self.items]);
            self.footerView.items = self.items;
            self.tableView.tableFooterView = self.footerView;
        }
            break;
        case 3:// 文件库
        {
            NSArray *images = @[@"公司文件库",@"颜值文库",@"项目文件",@"个人文件库",@"我共享的文件库",@"与我共享"];
            NSArray *names = @[@"公司文库",@"应用文库",@"项目文件",@"个人文库",@"我共享的",@"与我共享"];
            [self.items removeAllObjects];
            for (NSInteger i = 0; i < images.count; i ++) {
                ButtonInfo *info = [[ButtonInfo alloc] init];
                info.image = images[i];
                info.name = names[i];
//                info.number = 4;
                [self.items addObject:info];
            }
            self.tableView.hidden = NO;
            self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH-16, [TFEnterItemView enterItemViewHeightWithItems:self.items]);
            self.footerView.items = self.items;
            self.tableView.tableFooterView = self.footerView;
        }
            break;
        case 4:// 自定义
        {
            self.tableView.hidden = NO;
            self.footerView.items = self.items;
            self.tableView.tableFooterView = nil;
        }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}
#pragma mark - TFEnterItemViewDelegate
-(void)enterItemViewDidClickedIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(workEnterCellDidClickedItemWithModule:index:)]) {
        [self.delegate workEnterCellDidClickedItemWithModule:self.module index:index];
    }
}

#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.module.submenus.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFEnterCustomCell *cell = [TFEnterCustomCell enterCustomCellWithTableView:tableView];
    TFBeanTypeModel *model = self.module.submenus[indexPath.row];
    cell.nameLabel.text = model.name;
//    cell.headMargin = 55;
//    cell.bottomLine.hidden = NO;
//    cell.bottomLine.backgroundColor = HexColor(0xdae0e7);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(workEnterCellDidClickedSubmenuWithModule:beanType:index:)]) {
        [self.delegate workEnterCellDidClickedSubmenuWithModule:self.module beanType:self.module.submenus[indexPath.row] index:indexPath.row];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 38;
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

/** 高度 */
+(CGFloat)workEnterCellHeightWithModule:(TFModuleModel *)module{
    CGFloat height = 60 + 10;
    
    if (module.select && ![module.select isEqualToNumber:@0]) {
        
        if ([module.english_name isEqualToString:@"approval"] || [module.english_name isEqualToString:@"email"]) {
            
            height += [TFEnterItemView enterItemViewHeightWithItems:@[@"",@"",@""]];
            
        }else if ([module.english_name isEqualToString:@"library"]) {
            
            height += [TFEnterItemView enterItemViewHeightWithItems:@[@"",@"",@"",@"",@"",@""]];
            
        }else if ([module.english_name containsString:@"bean"]){
            
            height += 38 * module.submenus.count;
            if (module.submenus.count) {
                height += 10;
            }
        }
        
    }
    return height;
}

+ (instancetype)workEnterCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFWorkEnterCell" owner:self options:nil] lastObject];
}

+ (TFWorkEnterCell *)workEnterCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFWorkEnterCell";
    TFWorkEnterCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self workEnterCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
