//
//  HQTFQuantifyController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFQuantifyController.h"
#import "HQSelectTimeCell.h"
#import "HQTFNumberMoneyCell.h"
#import "HQTFInputCell.h"
#import "FDActionSheet.h"


@interface HQTFQuantifyController ()<FDActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,HQTFInputCellDelegate,HQTFNumberMoneyCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** type 0:为数量 1：金额 */
@property (nonatomic, assign) NSInteger type;

/** 数量 */
@property (nonatomic, copy) NSString *numValue;

@end

@implementation HQTFQuantifyController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"关闭" text:@"关闭"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigation];
}

#pragma mark - navi
- (void)setupNavigation{
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    
    self.navigationItem.title = @"定量数值";
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure{
    
    
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        HQTFNumberMoneyCell *cell = [HQTFNumberMoneyCell numberMoneyCellWithTableView:tableView];
        cell.delegate = self;
        cell.headMargin = 0;
        return cell;
    }else if (indexPath.row == 1){
        
        HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
        cell.delegate = self;
        
        if (self.type == 0) {
            cell.titleLabel.text = @"输入数量";
        }else{
            cell.titleLabel.text = @"输入金额";
        }
        
        return cell;
    }else{
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"单位           ";
        cell.arrowShowState = YES;
        if (self.type == 0) {
            cell.time.text = @"个";
        }else{
            cell.time.text = @"元";
        }
        cell.bottomLine.hidden = YES;
        cell.time.textColor = LightBlackTextColor;
        return  cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.row == 2) {
        
        if (self.type == 0) {
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"吨",@"kg",@"pcs",@"箱",@"件",@"个",nil];
            
            sheet.tag = 111;
            [sheet setButtonTitleColor:BlackTextColor bgColor:nil fontSize:FONT(16) atIndex:0];
            [sheet setButtonTitleColor:BlackTextColor bgColor:nil fontSize:FONT(16) atIndex:1];
            [sheet setCancelButtonTitleColor:BlackTextColor bgColor:CellClickColor fontSize:FONT(16)];
            [sheet show];
        }else{
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"欧元",@"美元",@"人民币（元）",nil];
            
            sheet.tag = 222;
            [sheet setButtonTitleColor:BlackTextColor bgColor:nil fontSize:FONT(16) atIndex:0];
            [sheet setButtonTitleColor:BlackTextColor bgColor:nil fontSize:FONT(16) atIndex:1];
            [sheet setCancelButtonTitleColor:BlackTextColor bgColor:CellClickColor fontSize:FONT(16)];
            [sheet show];
        }
        
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    if (sheet.tag == 111) {
        switch (buttonIndex) {
            case 0:
            {
                
            }
                break;
            default:
                break;
        }

    }else{
        switch (buttonIndex) {
            case 0:
            {
                
            }
                break;
            default:
                break;
        }

    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return 60;
    }
    
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
#pragma mark - delegate
-(void)numberMoneyCellDidSelectedWithValue:(NSInteger)value{
    
    if (self.type == value) {
        return;
    }
    
    self.type = value;
    [self.tableView reloadData];
}
-(void)inputCellWithText:(NSString *)text{
    
    self.numValue = text;
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
