//
//  TFProjectRowFrameModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFProjectRowModel.h"

@interface TFProjectRowFrameModel : NSObject
/** 无空白 */
-(instancetype)initBorder;

/** TFProjectRowModel */
@property (nonatomic, strong) TFProjectRowModel *projectRow;

/** bgView */
@property (nonatomic, assign) CGRect bgViewFrame;

/** urgeView */
@property (nonatomic, assign) CGRect urgeViewFrame;

/** selectBtn */
@property (nonatomic, assign) CGRect selectBtnFrame;

/** titleLabel */
@property (nonatomic, assign) CGRect titleLabelFrame;

/** activeBtn */
@property (nonatomic, assign) CGRect activeBtnFrame;
/** activeBtnHidden */
@property (nonatomic, assign) BOOL activeBtnHidden;

/** endTimeBtn */
@property (nonatomic, assign) CGRect endTimeBtnFrame;
/** endTimeBtnHidden */
@property (nonatomic, assign) BOOL endTimeBtnHidden;
/** time */
@property (nonatomic, copy) NSString *time;

/** overBtn */
@property (nonatomic, assign) CGRect overBtnFrame;
/** overBtnHidden */
@property (nonatomic, assign) BOOL overBtnHidden;
/** overtime */
@property (nonatomic, copy) NSString *overtime;

/** childTaskBtn */
@property (nonatomic, assign) CGRect childTaskBtnFrame;
/** childTaskBtnHidden */
@property (nonatomic, assign) BOOL childTaskBtnHidden;
/** childTask */
@property (nonatomic, copy) NSString *childTask;

/** headBtn */
@property (nonatomic, assign) CGRect headBtnFrame;
/** headBtnHidden */
@property (nonatomic, assign) BOOL headBtnHidden;

/** tagListView */
@property (nonatomic, assign) CGRect tagListViewFrame;
/** tagListViewHidden */
@property (nonatomic, assign) BOOL tagListViewHidden;

/** checkView */
@property (nonatomic, assign) CGRect checkViewFrame;
/** checkViewHidden */
@property (nonatomic, assign) BOOL checkViewHidden;

/** cellHeight */
@property (nonatomic, assign) CGFloat cellHeight;


@property (nonatomic, strong) NSNumber *select;

/** labels */
@property (nonatomic, strong) NSArray *labels;



@end
