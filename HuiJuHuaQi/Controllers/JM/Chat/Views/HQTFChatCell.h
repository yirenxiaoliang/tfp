//
//  HQTFChatCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/16.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFAssistantTypeModel.h"

typedef enum {
    ChatCellTypeCricle,
    ChatCellTypeContacts
}ChatCellType;


@protocol HQTFChatCellDelegate <NSObject>

@optional
- (void)chatCellDidClickedCameraWithType:(ChatCellType)type;

@end

@interface HQTFChatCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *titleNum;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;
@property (weak, nonatomic) IBOutlet UIImageView *redImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;

@property (nonatomic, assign) CGFloat imgHW;

+ (HQTFChatCell *)chatCellWithTableView:(UITableView *)tableView;

- (void)refreshChatCellWithModel:(TFAssistantTypeModel *)model;

/** model */
@property (nonatomic, strong) TFAssistantTypeModel *assistant;

/** 类型 */
@property (nonatomic, assign) ChatCellType chatCellType;
/** delegate */
@property (nonatomic, weak) id<HQTFChatCellDelegate> delegate;
@end
