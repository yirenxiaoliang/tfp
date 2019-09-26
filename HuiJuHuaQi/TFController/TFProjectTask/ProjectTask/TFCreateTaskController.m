//
//  TFCreateTaskController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCreateTaskController.h"
#import "HQCreatScheduleTitleCell.h"
#import "TFManyLableCell.h"
#import "HQSelectTimeCell.h"
#import "TFProjectResponsibleCell.h"
#import "HQSwitchCell.h"
#import "TFCustomOptionCell.h"
#import "TFCreateTaskModel.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFSelectDateView.h"


@interface TFCreateTaskController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,HQSwitchCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** createTaskModel */
@property (nonatomic, strong) TFCreateTaskModel *createTaskModel;

@end

@implementation TFCreateTaskController

-(TFCreateTaskModel *)createTaskModel{
    if (!_createTaskModel) {
        _createTaskModel = [[TFCreateTaskModel alloc] init];
    }
    return _createTaskModel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(cancel) text:@"取消" textColor:GrayTextColor];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigation];
}

#pragma mark - 导航
- (void)setupNavigation{
    
    self.navigationItem.title = @"新建任务";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GrayTextColor];
    
}

- (void)sure{

    
}

- (void)cancel{
   
    [self.navigationController popViewControllerAnimated:YES];
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
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 2;
    }else{
        return 1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
        cell.textVeiw.delegate = self;
        cell.textVeiw.placeholder = @"项目名称20个字以内";
        cell.textVeiw.text = self.createTaskModel.title;
        return cell;
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.title.text = @"仅协作人可见";
            cell.switchBtn.on = self.createTaskModel.visible == 0 ? NO : YES;
            cell.delegate = self;
            return cell;
        }else {
            
            TFProjectResponsibleCell *cell = [TFProjectResponsibleCell projectResponsibleCellWithTableView:tableView];
            cell.titleLabel.text = @"负责人";
//            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:self.createTaskModel.execute.picture] placeholderImage:PlaceholderHeadImage];
            
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:self.createTaskModel.execute.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image == nil) {
                    [cell.headImage setTitle:[HQHelper nameWithTotalName:self.createTaskModel.execute.employee_name] forState:UIControlStateNormal];
                    cell.headImage.backgroundColor = HeadBackground;
                }else{
                    [cell.headImage setTitle:@"" forState:UIControlStateNormal];
                    cell.headImage.backgroundColor = WhiteColor;
                    
                }
            }];
            return cell;
        }
    }
    
    if (indexPath.section == 2){
        
        if (indexPath.row == 0){
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"截止时间";
            cell.time.textAlignment = NSTextAlignmentRight;
            cell.arrowShowState = YES;
            cell.time.text = [HQHelper nsdateToTime:self.createTaskModel.endTime formatStr:@"yyyy-MM-dd HH:mm"];
            return cell;
        }else{
            
            TFCustomOptionCell *cell = [TFCustomOptionCell creatCustomOptionCellWithTableView:tableView];
            cell.requireLabel.hidden = YES;
            cell.titleLab.text = @"标签";
            cell.structure = @"1";
            [cell refreshCustomOptionCellWithOptions:nil];
            cell.arrow.hidden = NO;
            
            return cell;
        }
    }
    
    if (indexPath.section == 3) {
        TFManyLableCell *cell = [TFManyLableCell creatManyLableCellWithTableView:tableView];
        cell.titleBgView.backgroundColor = BackGroudColor;
        cell.structure = @"0";
        cell.requireLabel.hidden = YES;
        cell.titleLab.text = @"项目描述";
        cell.textVeiw.placeholder = @"请输入描述文字";
        cell.textVeiw.text = self.createTaskModel.descript;
        cell.textVeiw.tag = 0x123;
        cell.textVeiw.delegate = self;
        return cell;
    }
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = @"";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            
            
            TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
            scheduleVC.selectType = 1;
            scheduleVC.isSingleSelect = YES;
            //            scheduleVC.defaultPoeples = model.selects;
            //            scheduleVC.noSelectPoeples = model.selects;
            scheduleVC.actionParameter = ^(NSArray *parameter) {
                
                if (parameter.count) {
                    self.createTaskModel.execute = parameter[0];
                }
                [self.tableView reloadData];
                
            };
            [self.navigationController pushViewController:scheduleVC animated:YES];
            
        }
    }
    
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            
            [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDayHourMinute timeSp:self.createTaskModel.endTime<=0?[HQHelper getNowTimeSp]:self.createTaskModel.endTime onRightTouched:^(NSString *time) {
                
                self.createTaskModel.endTime = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"];
                
                [self.tableView reloadData];
            }];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 80;
    }else if (indexPath.section == 3){
        return 200;
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 1) {
            return [TFCustomOptionCell refreshCustomOptionCellHeightWithOptions:nil withStructure:@"1"];
        }
    }
    
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 10;
    }
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
#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.tag == 0x123) {
        
        self.createTaskModel.descript = textView.text;
    }else{
        self.createTaskModel.title = textView.text;
    }
}
#pragma mark - HQSwitchCellDelegate
-(void)switchCellDidSwitchButton:(UISwitch *)switchButton{
    self.createTaskModel.visible = switchButton.on ? 1 : 0;
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
