//
//  TFProjectRowFrameModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectRowFrameModel.h"
#import "TFCustomListCell.h"

#define TextWidth (72 + self.borderMargin)
#define Margin 12
#define Padding 10
#define Height 17

@interface TFProjectRowFrameModel ()

/** borderMargin */
@property (nonatomic, assign) CGFloat borderMargin;


@end

@implementation TFProjectRowFrameModel

-(instancetype)init{
    if (self = [super init]) {
        self.borderMargin = 4 * Padding;
    }
    return self;
}

-(instancetype)initBorder{
    if (self = [super init]) {
        self.borderMargin = 0;
    }
    return self;
}

-(void)setProjectRow:(TFProjectRowModel *)projectRow{
    
    _projectRow = projectRow;
    
    if ([projectRow.dataType isEqualToNumber:@2]) {// 任务
        // 选择按钮
        self.selectBtnFrame = CGRectMake(15, Margin, 20, 20);
        
        // 名称
        CGSize titleSize = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH - TextWidth,MAXFLOAT} titleStr:projectRow.taskName];
        self.titleLabelFrame = CGRectMake(41, Margin+2, SCREEN_WIDTH - TextWidth, titleSize.height);
        
        
        // 激活次数
        if (!projectRow.activeNum || [projectRow.activeNum isEqualToNumber:@0]) {
            self.activeBtnFrame = CGRectMake(CGRectGetMinX(self.titleLabelFrame), CGRectGetMaxY(self.titleLabelFrame) + Margin, 0, 14);
            self.activeBtnHidden = YES;
        }else{
            self.activeBtnFrame = CGRectMake(CGRectGetMinX(self.titleLabelFrame), CGRectGetMaxY(self.titleLabelFrame) + Margin, 20, 14);
            self.activeBtnHidden = NO;
        }
        
        // 截止时间
        self.time = @"";
        if (self.activeBtnHidden) {
            
            self.endTimeBtnFrame = CGRectMake(CGRectGetMaxX(self.activeBtnFrame), CGRectGetMinY(self.activeBtnFrame), 0, 14);
        }else{
            
            self.endTimeBtnFrame = CGRectMake(CGRectGetMaxX(self.activeBtnFrame) + Margin, CGRectGetMinY(self.activeBtnFrame), 0, 14);
        }
        
        if ([projectRow.startTime isKindOfClass:[NSString class]]) {
            projectRow.startTime = @([projectRow.startTime longLongValue]);
        }
        if ([projectRow.endTime isKindOfClass:[NSString class]]) {
            projectRow.endTime = @([projectRow.endTime longLongValue]);
        }
        
        if ((projectRow.startTime && ![projectRow.startTime isEqualToNumber:@0]) && (projectRow.endTime && ![projectRow.endTime isEqualToNumber:@0])) {
            
            self.time = [NSString stringWithFormat:@" %@~%@",[HQHelper nsdateToTimeNowYear:[projectRow.startTime longLongValue]],[HQHelper nsdateToTimeNowYear:[projectRow.endTime longLongValue]]];
            
            self.endTimeBtnHidden = NO;
            
        }else if ((projectRow.startTime && ![projectRow.startTime isEqualToNumber:@0]) || (projectRow.endTime && ![projectRow.endTime isEqualToNumber:@0])) {
            
            self.time = [NSString stringWithFormat:@" %@%@",[HQHelper nsdateToTimeNowYear:[projectRow.startTime longLongValue]],[HQHelper nsdateToTimeNowYear:[projectRow.endTime longLongValue]]];
            
            self.endTimeBtnHidden = NO;
        }else{
            self.endTimeBtnHidden = YES;
        }
        
        CGSize timeSize = [HQHelper sizeWithFont:FONT(12) maxSize:(CGSize){SCREEN_WIDTH - TextWidth - 38,MAXFLOAT} titleStr:self.time];
        
        if (self.endTimeBtnHidden == NO) {
            
            if (self.activeBtnHidden) {
                
                self.endTimeBtnFrame = CGRectMake(CGRectGetMaxX(self.activeBtnFrame), CGRectGetMinY(self.activeBtnFrame), timeSize.width + 16, 14);// 20为图标
            }else{
                
                self.endTimeBtnFrame = CGRectMake(CGRectGetMaxX(self.activeBtnFrame) + Margin, CGRectGetMinY(self.activeBtnFrame), timeSize.width + 16, 14);// 20为图标
            }
        }
        
        // 超期
        self.overBtnHidden = YES;
        self.overtime = @"";
        if (self.endTimeBtnHidden) {
            self.overBtnFrame = CGRectMake(CGRectGetMaxX(self.endTimeBtnFrame), CGRectGetMinY(self.activeBtnFrame), 0, 14);
        }else{
            self.overBtnFrame = CGRectMake(CGRectGetMaxX(self.endTimeBtnFrame) + Margin, CGRectGetMinY(self.activeBtnFrame), 0, 14);
        }
        
        if (![[projectRow.complete_status description] isEqualToString:@"1"]) {// 未完成的任务
            
            if (projectRow.endTime && ![projectRow.endTime isEqualToNumber:@0]) {
                
                if ([projectRow.endTime longLongValue] < [HQHelper getNowTimeSp]) {
                    
                    long long timeMinus = [HQHelper getNowTimeSp] - [projectRow.endTime longLongValue];
                    
                    NSInteger day = timeMinus / 1000 / 24 / 60 / 60;
                    
                    if (day > 0) {
                        
                        self.overBtnHidden = NO;
                        self.overtime = [NSString stringWithFormat:@"超期%ld天",day];
                        
                        CGSize overSize = [HQHelper sizeWithFont:FONT(10) maxSize:(CGSize){SCREEN_WIDTH - TextWidth - 38,MAXFLOAT} titleStr:self.overtime];
                        CGFloat re = overSize.width + 2 * Margin + CGRectGetMaxX(self.endTimeBtnFrame) + Margin;
                        //                CGFloat max = SCREEN_WIDTH - TextWidth - 38;
                        CGFloat max = SCREEN_WIDTH - TextWidth ;
                        
                        if (re > max) {// 换行
                            
                            self.overBtnFrame = CGRectMake(CGRectGetMinX(self.activeBtnFrame), CGRectGetMaxY(self.activeBtnFrame) + Margin, overSize.width + 2 * Margin, 14);
                            
                        }else{
                            
                            self.overBtnFrame = CGRectMake(CGRectGetMaxX(self.endTimeBtnFrame) + Margin, CGRectGetMinY(self.activeBtnFrame), overSize.width + 2 * Margin, 14);
                        }
                        
                    }
                    
                }
            }
            
        }
        // 子任务
        if (self.overBtnHidden) {
            self.childTaskBtnFrame = CGRectMake(CGRectGetMaxX(self.overBtnFrame), CGRectGetMinY(self.overBtnFrame), 0, 14);
        }else{
            self.childTaskBtnFrame = CGRectMake(CGRectGetMaxX(self.overBtnFrame) + Margin, CGRectGetMinY(self.overBtnFrame), 0, 14);
        }
        if (projectRow.childTaskNum && !isNull(projectRow.childTaskNum) && ![projectRow.childTaskNum isEqualToNumber:@0]) {
            
            self.childTaskBtnHidden = NO;
            self.childTask = [NSString stringWithFormat:@" %ld/%ld",[projectRow.finishChildTaskNum integerValue],[projectRow.childTaskNum integerValue]];
        }else{
            self.childTaskBtnHidden = YES;
            self.childTask = @"";
            
        }
        
        if (self.childTaskBtnHidden == NO) {
            
            CGSize childSize = [HQHelper sizeWithFont:FONT(12) maxSize:(CGSize){SCREEN_WIDTH - TextWidth - 38,MAXFLOAT} titleStr:self.childTask];
            
            CGFloat re = 0;
            if (self.overBtnHidden) {
                re = childSize.width + 16 + CGRectGetMaxX(self.overBtnFrame) ;
            }else{
                re = childSize.width + 16 + CGRectGetMaxX(self.overBtnFrame) + Margin;
            }
            //                CGFloat max = SCREEN_WIDTH - TextWidth - 38;
            CGFloat max = SCREEN_WIDTH - TextWidth ;
            
            if (re > max) {// 换行
                
                self.childTaskBtnFrame = CGRectMake(CGRectGetMinX(self.activeBtnFrame), CGRectGetMaxY(self.overBtnFrame) + Margin, childSize.width + 16, 14);
                
            }else{
                
                if (self.overBtnHidden) {
                    self.childTaskBtnFrame = CGRectMake(CGRectGetMaxX(self.overBtnFrame) , CGRectGetMinY(self.overBtnFrame), childSize.width + 16, 14);
                }else{
                    self.childTaskBtnFrame = CGRectMake(CGRectGetMaxX(self.overBtnFrame) + Margin, CGRectGetMinY(self.overBtnFrame), childSize.width + 16, 14);
                }
            }
        }
        
        // 标签
        if (projectRow.tagList.count) {
            
            self.tagListViewFrame = CGRectMake(CGRectGetMinX(self.activeBtnFrame), CGRectGetMaxY(self.childTaskBtnFrame) + Margin, SCREEN_WIDTH - TextWidth - 2 * Padding - Margin, 20);
        }else{
            
            self.tagListViewFrame = CGRectMake(CGRectGetMinX(self.activeBtnFrame), CGRectGetMaxY(self.childTaskBtnFrame) + Margin, SCREEN_WIDTH - TextWidth - 2 * Padding - Margin, 0);
        }
        
        // 头像
        if (self.projectRow.responsibler) {
            self.headBtnHidden = NO;
        }else{
            self.headBtnHidden = YES;
        }
        self.headBtnFrame = CGRectMake(SCREEN_WIDTH - 10 - 2 * Padding - self.borderMargin - 40, CGRectGetMaxY(self.titleLabelFrame) + 5, 28, 28);
        
        // bgView
        self.bgViewFrame = CGRectMake(Padding, 5, SCREEN_WIDTH - 2 * Padding - self.borderMargin, MAX(CGRectGetMaxY(self.tagListViewFrame), CGRectGetMaxY(self.headBtnFrame)) + Margin);
        
        // 紧急
        self.urgeViewFrame = CGRectMake(0, 0, 5, self.bgViewFrame.size.height);
        
        // 检验
        self.checkViewFrame = CGRectMake(self.bgViewFrame.size.width - 76, 0, 76, 50);
        if ([[projectRow.check_status description] isEqualToString:@"0"]) {
            self.checkViewHidden = YES;
        }else{
            if (!projectRow.finishType || [[projectRow.finishType description] isEqualToString:@"0"]) {
                self.checkViewHidden = YES;
            }else{
                self.checkViewHidden = NO;
            }
            
        }
        // cellHeight
        self.cellHeight = CGRectGetMaxY(self.bgViewFrame) + 5;
        
    }
    else if ([projectRow.dataType isEqualToNumber:@1]){// 备忘录
        
        // 名称
        CGSize titleSize = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH - TextWidth,MAXFLOAT} titleStr:projectRow.title];
        
        // cellHeight
        self.cellHeight = 90 + titleSize.height;
        
    }
    else if ([projectRow.dataType isEqualToNumber:@3]){// 自定义
        
        if (projectRow.rows) {
            
            TFCustomListItemModel *moo = [[TFCustomListItemModel alloc] init];
            moo.row = projectRow.rows;
            
            self.cellHeight = 16 + 30 + [TFCustomListCell refreshCustomListCellHeightWithModel:moo];
            
            return;
        }
        
        // 选择按钮
        self.selectBtnFrame = CGRectMake(15, Margin, 20, 20);
        
        // 名称
        NSString *tt = @"";
        if (projectRow.row.count) {
            tt = [HQHelper stringWithFieldNameModel:projectRow.row[0]];
        }
        if ([tt isEqualToString:@""] || !tt) {
            tt = @"我是透明字";
        }
        CGSize titleSize = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH - TextWidth,MAXFLOAT} titleStr:tt];
        self.titleLabelFrame = CGRectMake(41, Margin, SCREEN_WIDTH - TextWidth, titleSize.height);
        
        NSMutableArray *arr = [NSMutableArray array];
       
        for (NSInteger i = 1; i < (projectRow.row.count>6?6:projectRow.row.count); i++) {
            TFFieldNameModel *fe = projectRow.row[i];
            if ([fe.name containsString:@"principal"] || [fe.value isEqualToString:@""]) {
                continue;
            }
            
            CGSize size = [HQHelper sizeWithFont:FONT(12) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:[HQHelper stringWithFieldNameModel:projectRow.row[i]]];
            
            if (size.width > SCREEN_WIDTH - TextWidth) {
                
                [arr addObject:[NSNumber numberWithFloat:SCREEN_WIDTH - TextWidth]];
            }else{
                [arr addObject:[NSNumber numberWithFloat:size.width]];
            }
            
        }
        
        CGFloat X = CGRectGetMinX(self.titleLabelFrame);
        CGFloat Y = CGRectGetMaxY(self.titleLabelFrame) + Margin;
        NSMutableArray *labelValues = [NSMutableArray array];
        for (NSNumber *label in arr) {
            
            if (X + [label floatValue] + Margin <= SCREEN_WIDTH - TextWidth) {// 同行
                
                [labelValues addObject:[NSValue valueWithCGRect:CGRectMake(X, Y, [label floatValue], Height)]];
                X += ([label floatValue] + Margin);
                
            }else{// 换行
                
                Y += (Height + Margin/2);
                X = CGRectGetMinX(self.titleLabelFrame);
                [labelValues addObject:[NSValue valueWithCGRect:CGRectMake(X, Y, [label floatValue], Height)]];
                X += ([label floatValue] + Margin);
            }
            
        }
        self.labels = labelValues;
        
        // 头像
        self.headBtnFrame = CGRectMake(SCREEN_WIDTH - 2 * Padding - self.borderMargin - 40, CGRectGetMaxY(self.titleLabelFrame) + 5, 28, 28);
        
        // bgView
        NSValue *last = labelValues.lastObject;
        self.bgViewFrame = CGRectMake(Padding, 5, SCREEN_WIDTH- 2 * Padding - self.borderMargin, MAX(MAX(CGRectGetMaxY(self.tagListViewFrame), CGRectGetMaxY([last CGRectValue])), CGRectGetMaxY(self.headBtnFrame)) + Margin);
        
        // cellHeight
        self.cellHeight = CGRectGetMaxY(self.bgViewFrame) + 5;
        
    }
    else if ([projectRow.dataType isEqualToNumber:@4]){// 审批
        CGSize titleSize = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH - TextWidth,MAXFLOAT} titleStr:[NSString stringWithFormat:@"%@-%@",projectRow.begin_user_name,projectRow.process_name]];
        
        // cellHeight
        self.cellHeight = 76 + titleSize.height;
    }
    else if ([projectRow.dataType isEqualToNumber:@5]){// 邮件
        CGSize titleSize = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH - TextWidth - 30,MAXFLOAT} titleStr:projectRow.subject];
        
        // cellHeight
        self.cellHeight = 76 + titleSize.height;
    }
    
    
    
}

@end
