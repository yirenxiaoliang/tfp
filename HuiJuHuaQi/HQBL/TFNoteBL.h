//
//  TFNoteBL.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseBL.h"

@interface TFNoteBL : HQBaseBL
/** note列表 */
- (void)requestGetNoteListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize type:(NSInteger)type keyword:(NSString *)keyword;

/** 创建note */
- (void)requestCreateNoteWithDict:(NSDictionary *)dict;
/** 编辑note */
- (void)requestUpdateNoteWithDict:(NSDictionary *)dict;

/** note详情 */
- (void)requestGetNoteWithNoteId:(NSNumber *)noteId;

/** 删除note
 ids:1,2,3 备忘录记录ID,以逗号分隔
 type:1:删除  2：彻底删除 3：恢复备忘  4：退出共享
 */
- (void)requestDeleteNoteWithDict:(NSString *)ids type:(NSInteger)type;

/** 搜索关联 */
- (void)requestGetFirstFieldFromModuleWithDict:(NSString *)fieldValue bean:(NSString *)bean;

/** note关联 */
- (void)requestFindRelationListWithNoteId:(NSNumber *)noteId;

/** 更新note关联 */
- (void)requestUpdateRelationByIdWithJsonStr:(NSNumber *)id status:(NSString *)status beanArr:(NSMutableArray *)beanArr;

@end
