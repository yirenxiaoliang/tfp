//
//  TFNoteBL.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteBL.h"
#import "TFNoteMainListModel.h"
#import "TFFieldNameModel.h"

@implementation TFNoteBL

/** note列表 */
- (void)requestGetNoteListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize type:(NSInteger)type keyword:(NSString *)keyword{

    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@(pageNum) forKey:@"pageNum"];
    [dict setObject:@(pageSize) forKey:@"pageSize"];
    [dict setObject:@(type) forKey:@"type"];
    if (keyword) {
        [dict setObject:keyword forKey:@"keyword"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_getNoteList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getNoteList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 创建note */
- (void)requestCreateNoteWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_createNote];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_createNote
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 编辑note */
- (void)requestUpdateNoteWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_updateNote];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_updateNote
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** note详情 */
- (void)requestGetNoteWithNoteId:(NSNumber *)noteId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (noteId) {
        [dict setObject:noteId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getNoteDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getNoteDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 删除note */
- (void)requestDeleteNoteWithDict:(NSString *)ids type:(NSInteger)type {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (ids) {
        
        [dict setObject:ids forKey:@"ids"];
    }
    if (type) {
        
        [dict setObject:@(type) forKey:@"type"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_memoDel];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"POST"
                                     requestParam:dict
                                            cmdId:HQCMD_memoDel
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 搜索关联 */
- (void)requestGetFirstFieldFromModuleWithDict:(NSString *)fieldValue bean:(NSString *)bean {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fieldValue) {
        
        [dict setObject:fieldValue forKey:@"fieldValue"];
    }
    if (bean) {
        
        [dict setObject:bean forKey:@"bean"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getFirstFieldFromModule];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getFirstFieldFromModule
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** note关联 */
- (void)requestFindRelationListWithNoteId:(NSNumber *)noteId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (noteId) {
        [dict setObject:noteId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_findRelationList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_findRelationList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 更新note关联 */
- (void)requestUpdateRelationByIdWithJsonStr:(NSNumber *)id status:(NSString *)status beanArr:(NSMutableArray *)beanArr {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (id) {
        
        [dict setObject:id forKey:@"id"];
    }
    if (status) {
        
        [dict setObject:status forKey:@"status"];
    }
    if (beanArr) {
        
        [dict setObject:beanArr forKey:@"beanArr"];
    }
    

    NSString *url = [super urlFromCmd:HQCMD_updateRelationById];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_updateRelationById
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

#pragma mark - Responses
- (void)requestManager:(HQRequestManager *)manager sequenceID:(NSInteger)sid didCompleteWithData:(id)data cmdId:(HQCMD)cmdId{
    BOOL result = [super requestManager:manager commonData:data sequenceID:sid cmdId:cmdId];
    HQResponseEntity *resp = nil;
    
    if (result) {
        
        switch (cmdId) {
                
            case HQCMD_getNoteList:  // 备忘录列表
            {
                NSDictionary *dict = data[kData];
                
                TFNoteMainListModel *model = [[TFNoteMainListModel alloc] initWithDictionary:dict error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_createNote:  // 创建备忘录
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_updateNote:  // 编辑备忘录
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_getNoteDetail:  // 备忘录详情
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_memoDel:  // 备忘录删除
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
            case HQCMD_ChatFile:
            {
                
                NSArray *files = data[kData];
                
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in files) {
                    
                    TFFileModel *model = [[TFFileModel alloc] initWithDictionary:dict error:nil];
                    
                    [array addObject:model];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
                
                
            case HQCMD_getFirstFieldFromModule:  // 备忘录删除
            {
                
                NSArray *arr = data[kData];
//                NSMutableArray *array = [NSMutableArray array];
//                for (NSDictionary *dic in arr) {
//
//                    TFFieldNameModel *model = [[TFFieldNameModel alloc] initWithDictionary:dic error:nil];
//
//                    [array addObject:model];
//                }
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
                
            case HQCMD_findRelationList:  // 备忘录关联
            {
                
                NSDictionary *dic = data[kData];
                
                NSArray *arr = [dic valueForKey:@"dataList"];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
                
            case HQCMD_updateRelationById:  //
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            default:
                break;
        }
        [super succeedCallbackWithResponse:resp];
    }
}




@end
