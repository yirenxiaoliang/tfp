//
//  TFKnowledgeSearchItem.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFKnowledgeSearchItem : UIView

@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UILabel *rightLine;
@property (weak, nonatomic) IBOutlet UILabel *leftLine;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHeadM;

+(instancetype)knowledgeSearchItem;

@end

NS_ASSUME_NONNULL_END
