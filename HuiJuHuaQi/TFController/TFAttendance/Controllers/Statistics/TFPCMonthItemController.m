//
//  TFPCMonthItemController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPCMonthItemController.h"
#import "TFPCPeoplesCell.h"
#import "TFTwoLableCell.h"
#import "HQTFNoContentView.h"
#import "TFStatisticsTypeCell.h"
#import "TFReferanceTimeCell.h"

@interface TFPCMonthItemController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFPCMonthItemController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavi];
    [self setupTableView];
    if (self.peoples.count) {
        self.tableView.backgroundView = nil;
    }else{
        self.tableView.backgroundView = self.noContentView;
    }
    if (self.index == 1 && self.type == 5) {// 月、外勤
        for (TFEmployModel *em in self.peoples) {
            NSString *sp = @"";
            for (TFDimensionModel *di in em.attendanceList) {
                if (![[HQHelper nsdateToTime:[di.attendanceDate longLongValue] formatStr:@"yyyyMMdd"] isEqualToString:sp]) {
                    sp = [HQHelper nsdateToTime:[di.attendanceDate longLongValue] formatStr:@"yyyyMMdd"];
                    di.mark = @"1";
                }
            }
        }
    }
}

- (void)setNavi {
    
    self.navigationItem.title = self.naviTitle;
    NSString *format = @"yyyy-MM-dd";
    if (self.index == 1 || self.index == 2) {
        format = @"yyyy-MM";
    }
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:nil text:[HQHelper nsdateToTime:self.date formatStr:format] textColor:kUIColorFromRGB(0x666666)];
    
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
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.peoples.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TFEmployModel *model = self.peoples[section];
    if (self.index == 0) {// 日
        return 1 + model.attendanceList.count;
    }else if (self.index == 1){// 月
        if ([model.select isEqualToNumber:@1]) {
            return 1 + model.attendanceList.count;
        }else{
            return 1;
        }
    }else{// 我
        return 1 + model.attendanceList.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFEmployModel *model = self.peoples[indexPath.section];
    if (indexPath.row == 0) {
        
        TFPCPeoplesCell *cell = [TFPCPeoplesCell PCPeoplesCellWithTableView:tableView];
        [cell configPCPeoplesCellWithModel:model];
        
        if (self.index == 0) {// 日统计
            if (self.type == 4) {// 旷工
                [cell.statusBtn setTitle:@"旷工" forState:UIControlStateNormal];
                [cell.statusBtn setTitleColor:HexColor(0x4B4948) forState:UIControlStateNormal];
                cell.statusBtn.layer.borderColor = HexColor(0x4B4948).CGColor;
                cell.statusBtn.hidden = NO;
                if (self.peoples.count-1 == indexPath.section) {
                    cell.bottomLine.hidden = YES;
                }else{
                    cell.bottomLine.hidden = NO;
                }
            }
        }
        else if (self.index == 1){// 月统计
            
            cell.memberLab.hidden = NO;
            cell.statusBtn.hidden = NO;
            cell.statusBtn.layer.borderWidth = 0;
            cell.headMargin = 0;
            if (self.peoples.count-1 == indexPath.section) {
                cell.bottomLine.hidden = YES;
            }else{
                cell.bottomLine.hidden = NO;
            }
            [cell.statusBtn setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
            if ([model.select isEqualToNumber:@1]) {
                cell.statusBtn.transform = CGAffineTransformRotate(cell.statusBtn.transform, -M_PI_2);
            }else{
                cell.statusBtn.transform = CGAffineTransformRotate(cell.statusBtn.transform, M_PI_2);
            }
            
            /** 统计维度类型,0：打卡人数，1：迟到，2：早退，3：缺卡,4:旷工，5：外勤打卡，6：关联审批 */
            if (self.type == 1) {
                NSInteger total = 0;
                for (TFDimensionModel *ei in model.attendanceList) {
                    total += [ei.duration integerValue];
                }
                cell.memberLab.text = [NSString stringWithFormat:@"%ld次  共%ld分钟",model.attendanceList.count,total];
                cell.memberLab.textColor = HexColor(0xF9A244);
            }else if (self.type == 2) {
                    NSInteger total = 0;
                for (TFDimensionModel *ei in model.attendanceList) {
                    total += [ei.duration integerValue];
                }
                cell.memberLab.text = [NSString stringWithFormat:@"%ld次  共%ld分钟",model.attendanceList.count,total];
                cell.memberLab.textColor = HexColor(0xF9A244);
            }else if (self.type == 3) {
                cell.memberLab.text = [NSString stringWithFormat:@"%ld次",model.attendanceList.count];
                cell.memberLab.textColor = RedColor;
            }else if (self.type == 4) {
                cell.memberLab.text = [NSString stringWithFormat:@"%ld次",model.attendanceList.count];
                cell.memberLab.textColor = LightBlackTextColor;
            }else if (self.type == 5) {
                cell.memberLab.text = [NSString stringWithFormat:@"%ld次",model.attendanceList.count];
                cell.memberLab.textColor = HexColor(0x08CF7B);
            }
            
        }
        else{// 我的统计
            
            
        }
        return cell;
    }
    else {
        
        if (self.index == 0) {// 日统计
            TFStatisticsTypeCell *cell = [TFStatisticsTypeCell statisticsTypeCellWithTableView:tableView];
            TFDimensionModel *dimen = model.attendanceList[indexPath.row-1];
            [cell refreshStatisticsTypeCellWithModel:dimen index:self.index type:self.type row:indexPath.row-1];
            
            if (self.type == 3) {// 缺卡
                if (indexPath.row == model.attendanceList.count) {
                    cell.headMargin = 0;
                }else{
                    cell.headMargin = 70;
                }
                cell.bottomLine.hidden = NO;
            }else if (self.type == 5){
                if (indexPath.row == model.attendanceList.count) {
                    cell.headMargin = 0;
                    cell.bottomLine.hidden = NO;
                }else{
                    cell.bottomLine.hidden = YES;
                }
            }
            
            return cell;
            
        }
        else if (self.index == 1){// 月统计
            
            if (self.type == 6) {
                TFReferanceTimeCell *cell = [TFReferanceTimeCell referanceTimeCellWithTableView:tableView];
                TFDimensionModel *de = model.attendanceList[indexPath.row-1];
                [cell refreshReferanceTimeCellWithModel:de];
                cell.backgroundColor = BackGroudColor;
                return cell;
            }else{
                
                TFTwoLableCell *cell = [TFTwoLableCell TwoLableCellWithTableView:tableView];
                [cell refreshCellWithIndex:self.index type:self.type model:model.attendanceList[indexPath.row-1]];
                cell.headMargin = 15;
                cell.bottomLine.hidden = YES;
                if (indexPath.row == model.attendanceList.count) {
                    cell.headMargin = 0;
                }
                TFDimensionModel *de = model.attendanceList[indexPath.row-1];
                if ([de.mark isEqualToString:@"1"]) {
                    cell.topLine.hidden = NO;
                }else{
                    cell.topLine.hidden = YES;
                }
                cell.backgroundColor = BackGroudColor;
                return cell;
            }
        }
        else{
            
            if (self.type == 6) {
                TFReferanceTimeCell *cell = [TFReferanceTimeCell referanceTimeCellWithTableView:tableView];
                TFDimensionModel *de = model.attendanceList[indexPath.row-1];
                [cell refreshReferanceTimeCellWithModel:de];
                cell.bottomLine.hidden = NO;
                return cell;
            }else{
                TFTwoLableCell *cell = [TFTwoLableCell TwoLableCellWithTableView:tableView];
                [cell refreshCellWithIndex:self.index type:self.type model:model.attendanceList[indexPath.row-1]];
                return cell;
            }
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.index == 1) {// 月统计
        
        TFEmployModel *model = self.peoples[indexPath.section];
        model.select = [model.select isEqualToNumber:@1] ? @0 : @1;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        if (self.index == 2) {
            return 0;
        }
        if (self.index == 0) {
            return 60;
        }
        return 80;
    }else{
        
        if (self.index == 0) {
            
            if (self.type == 1) {
                return 56;
            }
            if (self.type == 2) {
                if (indexPath.row == 1) {
                    return 56;
                }
                return 30;
            }
            if (self.type == 3) {
                return 56;
            }
            if (self.type == 6) {
                return 56;
            }
            if (indexPath.row == 1) {
                return 68;
            }
            return 46;
        }
        if (self.index == 1 || self.index == 2) {// 月统计
            if (self.type == 3 || self.type == 4 || self.type == 7) {// 缺卡，旷工，正常
                return 36;
            }
            if (self.index == 1 && self.type == 5) {// 月、外勤
                TFEmployModel *model = self.peoples[indexPath.section];
                TFDimensionModel *de = model.attendanceList[indexPath.row - 1];
                if ([de.mark isEqualToString:@"1"]) {
                    return 50;
                }else{
                    return 35;
                }
            }
        }
        return 56;
    }
    
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


@end
