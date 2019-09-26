//
//  TFNoteModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/21.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFNoteTextView.h"
#import "TFNoteImageView.h"

@interface TFNoteModel : JSONModel
/** 
 
 "type": 1,// 0:文字 1：图片
 "num": 1,// 0:无编号  ，1，2.... 编号的序号
 "check":1,// 0：无待办  1：有待办 2：待办完成
 "content": "neirong",
 "fileUrl": "文件url"
 
 */

/** type 0:文字 1：图片 */
@property (nonatomic, assign) NSInteger type;
/** num 0:无编号  1，2.... 编号的序号 */
@property (nonatomic, assign) NSInteger num;
/** check 0：无待办  1：有待办 2：待办完成 */
@property (nonatomic, assign) NSInteger check;
/** content */
@property (nonatomic, copy) NSString *content;
/** fileUrl */
@property (nonatomic, copy) NSString *fileUrl;
/** image */
@property (nonatomic, strong) UIImage *image;
/** noteTextView */
@property (nonatomic, strong) TFNoteTextView *noteTextView;
/** noteImageView */
@property (nonatomic, strong) TFNoteImageView *noteImageView;



@end
