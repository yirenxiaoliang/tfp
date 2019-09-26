//
//  TFTTTViewController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTTTViewController.h"
#import "TFMemoSliderCell.h"
#import "TFEmailNameView.h"

@interface TFTTTViewController ()<UITableViewDelegate,UITableViewDataSource,TFSliderCellDelegate>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation TFTTTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enablePanGesture = NO;
//    [self setupTableView];
    
    TFEmailNameView *view = [[TFEmailNameView alloc] initWithFrame:(CGRect){40,90,200,40}];
    [self.view addSubview:view];
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
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
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFMemoSliderCell *cell = [TFMemoSliderCell memoSliderCellWithTableView:tableView];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i ++) {
        TFSliderItem *item = [[TFSliderItem alloc] init];
        if (0 == i) {
            
            item.bgColor = GrayTextColor;
            item.name = @"取消共享";
            item.confirm = 0;
        }else if (1 == i){
            
            item.bgColor = GreenColor;
            item.name = @"取消关注";
            item.confirm = 0;
        }else{
            
            item.bgColor = RedColor;
            item.name = @"删除";
            item.confirm = 1;
        }
        [arr addObject:item];
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.bottomLine.hidden = NO;
    [cell refreshSliderCellItemsWithItems:arr];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    NSLog(@"'点击...");
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
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

#pragma mark - TFSliderCellDelegate
-(void)sliderCellDidClickedIndex:(NSInteger)index{
    
    HQLog(@"点击了%ldItem",index);
}

-(void)sliderCellSelectedIndexPath:(NSIndexPath *)indexPath{
    
    for (TFMemoSliderCell *cell in self.tableView.visibleCells) {
        
        [cell hiddenItem];
    }
    
    
    HQLog(@"点击了%@IndexPath",indexPath);
}

-(void)sliderCellWillScrollIndexPath:(NSIndexPath *)indexPath{
    
    for (TFMemoSliderCell *cell in self.tableView.visibleCells) {
        
        NSIndexPath *index = [self.tableView indexPathForCell:cell];
        
        if (!(indexPath.section == index.section && indexPath.row == index.row)) {
            
            [cell hiddenItem];
        }
    }
}


#pragma mark - tableViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    for (TFMemoSliderCell *cell in self.tableView.visibleCells) {
        
        [cell hiddenItem];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
