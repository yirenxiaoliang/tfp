//
//  TFCompanyCircleFrameModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/19.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HQCategoryItemModel.h"

@interface TFCompanyCircleFrameModel : NSObject

/** type 0:用于企业圈 1：企业圈详情 */
@property (nonatomic, assign) NSInteger type;

/** 企业圈一条数据 */
@property (nonatomic, strong) HQCategoryItemModel *circleItem;
/** 头像 */
@property (nonatomic, assign) CGRect headBtnFrame;
/** 名字 */
@property (nonatomic, assign) CGRect nameLabelFrame;

/** 内容 */
@property (nonatomic, assign) CGRect contentLabelFrame;
@property (nonatomic, assign) BOOL contentLabelHidden;

/** 显示全部文字按钮 */
@property (nonatomic, assign) CGRect allWordBtnFrame;
@property (nonatomic, assign) BOOL allWordBtnHidden;

/** 图片 */
@property (nonatomic, assign) CGRect pictureViewFrame;
@property (nonatomic, assign) BOOL pictureViewHidden;

/** 地址 */
@property (nonatomic, assign) CGRect addressLabelFrame;
@property (nonatomic, assign) BOOL addressLabelHidden;

/** 时间 */
@property (nonatomic, assign) CGRect timeLabelFrame;
/** 删除 */
@property (nonatomic, assign) CGRect deleteBtnFrame;
/** 显示分享、点赞、评论的按钮 */
@property (nonatomic, assign) CGRect showBtnFrame;

/** tableViw */
@property (nonatomic, assign) CGRect tableViewFrame;
@property (nonatomic, assign) BOOL tableViewHidden;


/** 共享、点赞、评论框 */
@property (nonatomic, assign) CGRect commentViewFrame;
/** cellHeight */
@property (nonatomic, assign) CGFloat cellHeight;


@end
