//
//  TFAssistantFrameModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/26.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAssistantFrameModel.h"

@implementation TFAssistantFrameModel

-(void)setAssistantModel:(TFAssistantModel *)assistantModel{
    
    _assistantModel = assistantModel;
    
    // 时间
    CGSize timeSize = [HQHelper sizeWithFont:FONT(12) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:[HQHelper nsdateToTime:[assistantModel.createDate longLongValue] formatStr:@"yyyy-MM-dd HH:mm"]];
    
    self.timeLabelRect = CGRectMake((SCREEN_WIDTH-(timeSize.width + 30))/2, 15, timeSize.width + 30, timeSize.height + 10);
    
    // 头像
    self.headBtnRect = CGRectMake(15, CGRectGetMaxY(self.timeLabelRect)+17, 40, 40);
    
    // 名字
    switch ([assistantModel.itemId integerValue]) {
        case AssistantTypeFile:
        {
            assistantModel.name = @"文件库助手";
        }
            break;
        case AssistantTypeTask:
        {
            assistantModel.name = @"任务助手";
        }
            break;
        case AssistantTypeSchedule:
        {
            assistantModel.name = @"日程助手";
        }
            break;
        case AssistantTypeNote:
        {
            assistantModel.name = @"随手记助手";
        }
            break;
        case AssistantTypeApproval:
        {
            assistantModel.name = @"审批助手";
        }
            break;
        case AssistantTypeNotice:
        {
            assistantModel.name = @"公告助手";
        }
            break;
        case AssistantTypeReport:
        {
            assistantModel.name = @"工作汇报助手";
        }
            break;
            
        default:
            break;
    }

    CGSize nameSize = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:assistantModel.name];
    self.nameLabelRect = CGRectMake(CGRectGetMaxX(self.headBtnRect)+12, CGRectGetMinY(self.headBtnRect), nameSize.width, 20);
    
    // 已读
    self.readViewRect = CGRectMake(CGRectGetMaxX(self.nameLabelRect)+12, CGRectGetMinY(self.nameLabelRect)+(20-8)/2, 8, 8);
    if ([assistantModel.isRead isEqualToNumber:@0]) {
        self.readViewHidden = NO;
    }else{
        self.readViewHidden = YES;
    }
    
    // 镖旗
    self.flagBtnRect = CGRectMake(SCREEN_WIDTH-20-40, CGRectGetMaxY(self.timeLabelRect)+17, 40, 40);
    
    // desc
    self.descLabelRect = CGRectMake(CGRectGetMaxX(self.headBtnRect)+12, CGRectGetMaxY(self.headBtnRect)-20, SCREEN_WIDTH-(CGRectGetMaxX(self.headBtnRect)+12+12), 20);
    
    // 内容
    CGSize contentSize = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){SCREEN_WIDTH-(CGRectGetMaxX(self.headBtnRect)+12+17+20),MAXFLOAT} titleStr:assistantModel.msgBody];
    self.contentLabelRect = CGRectMake(17,10, SCREEN_WIDTH-(CGRectGetMaxX(self.headBtnRect)+12+17+20), contentSize.height);
    
    // people/time
    if (!assistantModel.comment || [assistantModel.comment isEqualToString:@""]) {
        
        // people
        self.peopleLabelRect = CGRectMake(CGRectGetMinX(self.contentLabelRect), CGRectGetMaxY(self.contentLabelRect)+10, self.contentLabelRect.size.width, 20);
        // time
        self.endTimeLabelRect = CGRectMake(CGRectGetMinX(self.contentLabelRect), CGRectGetMaxY(self.peopleLabelRect)+10, self.contentLabelRect.size.width, 20);
        
    }else{
        
        // people
        self.peopleLabelRect = CGRectMake(CGRectGetMinX(self.contentLabelRect), CGRectGetMaxY(self.contentLabelRect),0, 0);
        
        // time
        
        CGSize commentSize = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-(CGRectGetMaxX(self.headBtnRect)+12+17+20),MAXFLOAT} titleStr:assistantModel.comment];
        self.endTimeLabelRect = CGRectMake(CGRectGetMinX(self.contentLabelRect), CGRectGetMaxY(self.peopleLabelRect)+10, self.contentLabelRect.size.width, commentSize.height);
    }
    
    // paopao
    self.paopaoViewRect = CGRectMake(CGRectGetMaxX(self.headBtnRect)+12, CGRectGetMaxY(self.nameLabelRect)+12, SCREEN_WIDTH-(CGRectGetMaxX(self.headBtnRect)+12+20), CGRectGetMaxY(self.endTimeLabelRect)+12);
    
    // cellHeight
    self.cellHeight = CGRectGetMaxY(self.paopaoViewRect)+15;
    
}


@end
