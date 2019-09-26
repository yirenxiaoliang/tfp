//
//  HQTFSelectColorController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFSelectColorController.h"
#import "HQTFLabelManageCell.h"
#import "TFProjLabelModel.h"

@interface HQTFSelectColorController ()<UITableViewDataSource,UITableViewDelegate,HQTFLabelManageCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** labels */
@property (nonatomic, strong) NSMutableArray *labels;

//@property (nonatomic, strong) TFFileLibray *fileLibrayBL;

@end

@implementation HQTFSelectColorController


-(NSMutableArray *)labels{
    if (!_labels) {
        _labels = [NSMutableArray array];
        
        NSArray *color = @[@"#FF1D32",@"#FF7777",@"#DD361A",
                           @"#DB6A20",@"#F57221",@"#FFEB57",
                           @"#F9B239",@"#B4E550",@"#73B32D",
                           @"#119E29",@"#00781B",@"#00CFC9",
                           @"#51D0B1",@"#5CC1FC",@"#0091FA",
                           @"#3057E5",@"#0051AF",@"#FF85BE",
                           @"#F52E94",@"#9856D9",@"#5821A7",
                           @"#C0C0C0",@"#8C8C8C",@"#000000"];
        
        for (NSInteger i = 0; i < color.count; i ++) {
            
            TFProjLabelModel *model = [[TFProjLabelModel alloc] init];
            model.labelColor = color[i];
            
            [_labels addObject:model];
        }
    }
    return _labels;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"关闭" highlightImage:@"关闭"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupTableView];
}
#pragma mark - navi
- (void)setupNavigation{
    
    //    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"完成" textColor:ExtraLightBlackTextColor];
    
    self.navigationItem.title = @"选择颜色";
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure{
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFLabelManageCell *cell = [HQTFLabelManageCell labelManageCellWithTableView:tableView withType:3];
    cell.selcteColor = self.color;
    [cell refreshCellItemColorWithItems:self.labels];
    cell.delegate = self;
    cell.headMargin = 0;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [HQTFLabelManageCell refreshCellHeightWithItems:self.labels];
    
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

#pragma mark - HQTFLabelManageCellDelegate
-(void)labelManageCellSelectColorWithColorModel:(TFProjLabelModel *)model{
    

    if (self.colorAction) {
        self.colorAction(model);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    });
        

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
