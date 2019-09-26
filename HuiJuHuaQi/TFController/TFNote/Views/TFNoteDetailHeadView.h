//
//  TFNoteDetailHeadView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFNoteDetailHeadView : UIView

/* 头像 */
@property (weak, nonatomic) IBOutlet UIButton *imageView;
/* 名字 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/* 职位 */
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
/* 时间 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


+(instancetype)noteDetailHeadView;

- (void)refreshNoteDetailHeadViewWithPeople:(TFEmployModel *)people createTime:(long long)createTime;


@end
