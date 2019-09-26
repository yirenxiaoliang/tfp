//
//  TFCompanyCircleFrameModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/19.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCompanyCircleFrameModel.h"
#import "HQStarTableCell.h"
#import "HQCommentTableViewCell.h"
#import "TFCompanyCircleDetailStarCell.h"
#import "TFCompanyCircleDetailCommentCell.h"

#define marginLeft 10
#define margin 15

@implementation TFCompanyCircleFrameModel

-(void)setCircleItem:(HQCategoryItemModel *)circleItem{
    
    _circleItem = circleItem;
    
    // 头像
    self.headBtnFrame = CGRectMake(marginLeft, margin, 40, 40);
    // 名字
    self.nameLabelFrame = CGRectMake(CGRectGetMaxX(self.headBtnFrame) + marginLeft, margin, SCREEN_WIDTH-(CGRectGetMaxX(self.headBtnFrame) + marginLeft + margin), 22);
    
    // 内容
    CGFloat height = 0;
    
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-75, MAXFLOAT} titleStr:circleItem.info];
    
    if (size.height == 0) {
        self.contentLabelHidden = YES;
    }else{
        self.contentLabelHidden = NO;
    }
    
    if (size.height < 90) {
        height = size.height;
        self.allWordBtnHidden = YES;
    }else{
        if ([circleItem.allWordShow isEqualToNumber:@0]) {
            
            height = 90;
        }else{
            height = size.height;
        }
        self.allWordBtnHidden = NO;
    }
    self.contentLabelFrame = CGRectMake(self.nameLabelFrame.origin.x, CGRectGetMaxY(self.nameLabelFrame) + marginLeft, SCREEN_WIDTH-75, height);
    
    // 显示所有文字
    if (size.height < 90) {
        self.allWordBtnFrame = CGRectMake(self.contentLabelFrame.origin.x, CGRectGetMaxY(self.contentLabelFrame), 0, 0);
    }else{
        self.allWordBtnFrame = CGRectMake(self.contentLabelFrame.origin.x, CGRectGetMaxY(self.contentLabelFrame), 40, 30);
    }
    
    // 图片
    if (!circleItem.images || circleItem.images.count == 0) {
        
        self.pictureViewFrame = CGRectMake(self.contentLabelFrame.origin.x, CGRectGetMaxY(self.allWordBtnFrame), 0, 0);
        self.pictureViewHidden = YES;
    }else{
        
        if (circleItem.images.count == 1) {
            
            self.pictureViewFrame = CGRectMake(self.contentLabelFrame.origin.x, CGRectGetMaxY(self.allWordBtnFrame) + marginLeft, 150, 150);
            
        }else if (circleItem.images.count <= 2){
            
            self.pictureViewFrame = CGRectMake(self.contentLabelFrame.origin.x, CGRectGetMaxY(self.allWordBtnFrame) + marginLeft, 150, 74);
        }else if (circleItem.images.count <= 4){
            
            self.pictureViewFrame = CGRectMake(self.contentLabelFrame.origin.x, CGRectGetMaxY(self.allWordBtnFrame) + marginLeft, 150, 150);
        }else if (circleItem.images.count <= 6){
            
            self.pictureViewFrame = CGRectMake(self.contentLabelFrame.origin.x, CGRectGetMaxY(self.allWordBtnFrame) + marginLeft, 226, 150);
        }else{
            self.pictureViewFrame = CGRectMake(self.contentLabelFrame.origin.x, CGRectGetMaxY(self.allWordBtnFrame) + marginLeft, 226, 226);
        }
        
        self.pictureViewHidden = NO;
    }
    
    // 地址
    if (!circleItem.address || [circleItem.address isEqualToString:@""]) {
        
        self.addressLabelFrame = CGRectMake(self.pictureViewFrame.origin.x, CGRectGetMaxY(self.pictureViewFrame), 0, 0);
        self.addressLabelHidden = YES;
    }else{
        self.addressLabelFrame = CGRectMake(self.pictureViewFrame.origin.x, CGRectGetMaxY(self.pictureViewFrame) + marginLeft, SCREEN_WIDTH - 75, 20);
        self.addressLabelHidden = NO;
    }
    
    // 时间
    CGSize timeSize = [HQHelper sizeWithFont:FONT(12.5) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:[HQHelper companyCircleTimeWithTimeSp:[circleItem.datetimeCreateDate longLongValue]]];
    self.timeLabelFrame = CGRectMake(self.addressLabelFrame.origin.x, CGRectGetMaxY(self.addressLabelFrame) + marginLeft, timeSize.width, 20);
    
    // 删除
    self.deleteBtnFrame = CGRectMake(CGRectGetMaxX(self.timeLabelFrame) + margin, CGRectGetMaxY(self.addressLabelFrame) + marginLeft, 60, 20);
    
    // 显示评论
    self.showBtnFrame = CGRectMake(SCREEN_WIDTH - 30 - margin, CGRectGetMaxY(self.addressLabelFrame) + marginLeft, 30, 30);
    
    // 评论框
    self.commentViewFrame = CGRectMake(CGRectGetMidX(self.showBtnFrame)-10, CGRectGetMidY(self.showBtnFrame)-20, 0, 40);
    
    // tableView
    
    if (self.type == 0) {
        CGFloat starHeight = [HQStarTableCell refreshCellHeightWithPeoples:circleItem.praiseList];
        
        CGFloat commentHeight = 0;
        
        for (HQCommentItemModel *model  in circleItem.commentList) {
            
            commentHeight += [HQCommentTableViewCell refreshCellHeightwithCommentItemModel:model];
        }
        
        if (circleItem.praiseList.count || circleItem.commentList.count) {
            self.tableViewHidden = NO;
            
            self.tableViewFrame = CGRectMake(self.timeLabelFrame.origin.x, CGRectGetMaxY(self.timeLabelFrame) + marginLeft, SCREEN_WIDTH - 60 - margin, commentHeight + starHeight + 12);// 12为偏移量
            
            if (circleItem.commentList.count) {
                self.tableViewFrame = CGRectMake(self.timeLabelFrame.origin.x, CGRectGetMaxY(self.timeLabelFrame) + marginLeft, SCREEN_WIDTH - 60 - margin, commentHeight + starHeight + 20);// 12为偏移量 + 8为sectionView
            }
            
        }else{
            self.tableViewHidden = YES;
            self.tableViewFrame = CGRectMake(self.timeLabelFrame.origin.x, CGRectGetMaxY(self.timeLabelFrame), 0, 0);
        }
        
    }else{
        
        CGFloat starHeight = [TFCompanyCircleDetailStarCell refreshCompanyCircleDetailStarCellHeightWithPeoples:circleItem.praiseList];
        
        CGFloat commentHeight = 0;
        
        for (HQCommentItemModel *model  in circleItem.commentList) {
            
            commentHeight += [TFCompanyCircleDetailCommentCell refreshCompanyCircleDetailCommentCellHeightWithModel:model];
        }
        
        if (circleItem.praiseList.count || circleItem.commentList.count) {
            self.tableViewHidden = NO;
            
            self.tableViewFrame = CGRectMake(15, CGRectGetMaxY(self.timeLabelFrame) + marginLeft, SCREEN_WIDTH - 30, commentHeight + starHeight + 12);// 12为偏移量
            
            if (circleItem.commentList.count) {
                self.tableViewFrame = CGRectMake(15, CGRectGetMaxY(self.timeLabelFrame) + marginLeft, SCREEN_WIDTH - 30, commentHeight + starHeight + 20);// 12为偏移量 + 8为sectionView
            }
            
        }else{
            self.tableViewHidden = YES;
            self.tableViewFrame = CGRectMake(15, CGRectGetMaxY(self.timeLabelFrame), 0, 0);
        }
        
    }
    
    
    // cellHeight
    self.cellHeight = CGRectGetMaxY(self.tableViewFrame) + margin ;
    
}


@end
