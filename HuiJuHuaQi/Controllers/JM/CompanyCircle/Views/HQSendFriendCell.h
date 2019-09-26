//
//  HQSendFriendCell.h
//  HuiJuHuaQi
//
//  Created by HQ-14 on 16/6/2.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseTableViewCell.h"
#import "HQAdviceTextView.h"
#import "HQSelectPhotoView.h"

@protocol HQSendFriendCellDelegate <NSObject>
@optional
- (void)didAddPhotoAction;

- (void)didDeletePhotoActionWithIndex:(NSInteger)index;

- (void)didLookAtPhotoActionWithIndex:(NSInteger)index;
- (void)didLookAtPhotoActionWithIndex:(NSInteger)index imageViews:(NSArray *)imageViews;

- (void)textChangeWithStr:(NSString *)textStr;

@end

@interface HQSendFriendCell : HQBaseTableViewCell

@property (nonatomic, strong) NSString *placeholderStr;
@property (nonatomic, weak) id <HQSendFriendCellDelegate> delegate;
@property (nonatomic, assign) NSInteger maxNum;
@property (nonatomic, assign)  BOOL isTaskTypes;
@property (nonatomic, strong) HQAdviceTextView *contentTextView;
@property (nonatomic, strong) HQSelectPhotoView *selectPhotoView;
@property (nonatomic, assign) NSInteger contentTextViewHeight;
@property (nonatomic, assign) HQAttendanceDescriptionType attendanceDescriptionType;




- (void)freshPhotoWithArr:(NSArray *)imgArr
                   urlArr:(NSArray *)urlArr;

- (void)freshPhotoWithArr:(NSArray *)imgArr
                   urlArr:(NSArray *)urlArr
        editeOrLookAtSate:(BOOL)editeOrLookAtSate;

//-(void)freshType:(HQFileModel *)fileInfoModel;

+ (instancetype)sendFriendCellWithTableView:(UITableView *)tableView Type:(BOOL)isTaskType;

@end
