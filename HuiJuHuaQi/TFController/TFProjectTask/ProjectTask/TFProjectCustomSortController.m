//
//  TFProjectCustomSortController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/17.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectCustomSortController.h"
#import "HQSelectTimeCell.h"

@interface TFProjectCustomSortController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** time */
@property (nonatomic, assign) NSInteger time;
/** arrange */
@property (nonatomic, assign) NSInteger arrange;


@end

@implementation TFProjectCustomSortController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (self.refresh) {
        self.refresh();
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationItem.title = @"自定义排序";
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
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
    if (indexPath.row == 0) {
        cell.timeTitle.text = @"时间排列";
        cell.time.text = self.time == 0 ? @"修改时间" : @"创建时间";
    }else{
        cell.timeTitle.text = @"升降排列";
        cell.time.text = self.arrange == 0 ? @"时间升序" : @"时间降序";
    }
    cell.time.textAlignment = NSTextAlignmentRight;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.row == 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改时间",@"创建时间", nil];
        sheet.tag = 0x123;
        [sheet showInView:self.view];
        
    }else{
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"时间升序",@"时间降序", nil];
        sheet.tag = 0x456;
        [sheet showInView:self.view];
        
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 0x123) {
        self.time = buttonIndex;
        
    }else{
        self.arrange = buttonIndex;
        
    }
    [self.tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12;
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
