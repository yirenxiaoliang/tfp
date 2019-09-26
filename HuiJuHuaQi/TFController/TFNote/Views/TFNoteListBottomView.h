//
//  TFNoteListBottomView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFNoteListBottomViewDelegate <NSObject>

@optional

- (void)oneButtonClicked;

- (void)twoButtonClicked;

@end

@interface TFNoteListBottomView : UIView

+ (instancetype)noteListBottomView;

/** type 1:我创建 2:共享给我 3:已删除
    count:选中数量
 */
- (void)refreshNoteListBottomViewWithType:(NSInteger)type count:(NSInteger)count;

@property (nonatomic, weak) id <TFNoteListBottomViewDelegate>delegate;

@end
