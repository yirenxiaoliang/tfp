//
//  HQAddContactsCell.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/14.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "HQContactsModel.h"


@protocol HQAddContactsCellDelegate <NSObject>

@optional
-(void)addContactsCellDidClickedAddBtnWithModel:(HQContactsModel *)model;

@end


@interface HQAddContactsCell : HQBaseCell

- (void)refreshCellWithModel:(id)model;
/** delegate */
@property (nonatomic, weak) id <HQAddContactsCellDelegate>delegate;
@end
