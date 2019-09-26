//
//  TFFileBL.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFileBL.h"
#import "TFFolderListModel.h"
#import "TFManagePersonsModel.h"
#import "TFManageItemModel.h"
#import "TFFileDetailModel.h"
#import "TFDownloadRecordModel.h"
#import "TFMainListModel.h"
#import "TFEmpInfoModel.h"
#import "TFFolderMenuModel.h"
#import "TFProjectFileMainModel.h"

@implementation TFFileBL

/** 菜单列表 */
-(void)requestQueryfileCatalogWithData {
    
    NSString *url = [super urlFromCmd:HQCMD_queryfileCatalog];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_queryfileCatalog
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 新建文件夹 */
-(void)requestSavaFileLibraryWithData:(TFAddFileModel *)model {
    
    NSDictionary *dict = [model toDictionary];

    
    NSString *url = [super urlFromCmd:HQCMD_savaFileLibrary];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_savaFileLibrary
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 根目录列表 */
-(void)requestQueryCompanyListWithData:(NSNumber *)style pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize sign:(NSNumber *)sign {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (style) {
        
        [dict setObject:style forKey:@"style"];
    }
    if (pageNum) {
        
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    if (sign) {
        
        [dict setObject:sign forKey:@"sign"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_queryCompanyList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_queryCompanyList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 子目录列表 */
-(void)requestQueryCompanyPartListWithData:(NSNumber *)style parentId:(NSNumber *)parentId pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize sign:(NSNumber *)sign{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (style) {
        
        [dict setObject:style forKey:@"style"];
    }
    if (parentId) {
        
        [dict setObject:parentId forKey:@"id"];
    }
    if (pageNum) {
        
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    if (sign) {
        
        [dict setObject:sign forKey:@"sign"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_queryCompanyPartList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_queryCompanyPartList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 删除文件夹 */
-(void)requestDelFileLibraryWithData:(NSNumber *)fid {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_delFileLibrary];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_delFileLibrary
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 修改文件夹 */
-(void)requestEditFolderWithData:(NSNumber *)fid name:(NSString *)name color:(NSString *)color {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    if (name) {
        
        [dict setObject:name forKey:@"name"];
    }
    if (color) {
        
        [dict setObject:color forKey:@"color"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_editFolder];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_editFolder
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 移动文件夹 */
-(void)requestShiftFileLibraryWithData:(NSNumber *)folderId targetId:(NSNumber *)targetId style:(NSNumber *)style {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (folderId) {
        
        [dict setObject:folderId forKey:@"worn_id"];
    }
    if (targetId) {
        
        [dict setObject:targetId forKey:@"current_id"];
    }
    if (style) {
        
        [dict setObject:style forKey:@"style"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_shiftFileLibrary];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_shiftFileLibrary
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取根目录人员信息 */
-(void)requestQueryFolderInitDetailWithData:(NSNumber *)style folderId:(NSNumber *)folderId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (style) {
        
        [dict setObject:style forKey:@"style"];
    }
    if (folderId) {
        
        [dict setObject:folderId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_queryFolderInitDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_queryFolderInitDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 上传文件 */
-(void)requestFileLibraryUploadWithData:(NSNumber *)folderId folderUrl:(NSString *)folderUrl type:(NSNumber *)type datas:(NSArray *)datas {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (folderId) {
        
        [dict setObject:folderId forKey:@"id"];
    }
    else {
    
        [dict setObject:@"" forKey:@"id"];
    }
    
    if (folderUrl) {
        
        [dict setObject:folderUrl forKey:@"url"];
    }
    else {
    
        [dict setObject:@"" forKey:@"url"];
    }
    
    if (type) {
        
        [dict setObject:type forKey:@"style"];
    }

    
    NSString *url = [self urlFromCmd:HQCMD_fileLibraryUpload];
    
    
    HQRequestItem *requestItem = [RM uploadPicToURL:url requestParam:dict imgDatas:datas audioDatas:nil videoDatas:nil cmdId:HQCMD_fileLibraryUpload delegate:self startBlock:^(HQCMD cmd, NSInteger sid) {
        
    }];
    
    [self.tasks addObject:requestItem];

}

/** 上传新版本 */
-(void)requestFileVersionUploadWithData:(NSNumber *)folderId folderUrl:(NSString *)folderUrl type:(NSNumber *)type datas:(NSArray *)datas {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (folderId) {
        
        [dict setObject:folderId forKey:@"id"];
    }
    if (folderUrl) {
        
        [dict setObject:folderUrl forKey:@"url"];
    }
    if (type) {
        
        [dict setObject:type forKey:@"style"];
    }
    
    
    NSString *url = [self urlFromCmd:HQCMD_FileVersionUpload];
    
    
    HQRequestItem *requestItem = [RM uploadPicToURL:url requestParam:dict imgDatas:datas audioDatas:nil videoDatas:nil cmdId:HQCMD_FileVersionUpload delegate:self startBlock:^(HQCMD cmd, NSInteger sid) {
        
    }];
    
    [self.tasks addObject:requestItem];
    
}

/** 获取管理员列表 */
-(void)requestQueryManageByIdWithData:(NSNumber *)folderId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (folderId) {
        
        [dict setObject:folderId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_queryManageById];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_queryManageById
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 添加管理员 */
-(void)requestSavaManageStaffWithData:(NSNumber *)folderId manage:(NSString *)manage fileLevel:(NSNumber *)fileLevel {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (folderId) {
        
        [dict setObject:folderId forKey:@"id"];
    }
    if (manage) {
        
        [dict setObject:manage forKey:@"manage_id"];
    }
    if (fileLevel) {
        
        [dict setObject:fileLevel forKey:@"file_leve"];
    }
    NSString *url = [super urlFromCmd:HQCMD_savaManageStaff];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_savaManageStaff
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 下载文件 */
-(void)requestFileDownloadWithData:(NSNumber *)fid {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_fileDownload];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_fileDownload
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 文件详情 */
-(void)requestQueryFileLibarayDetailWithData:(NSNumber *)fid {
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_queryFileLibarayDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_queryFileLibarayDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 下载记录 */
-(void)requestQueryDownLoadListWithData:(NSNumber *)fid {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_queryDownLoadList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_queryDownLoadList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 历史版本 */
-(void)requestQueryVersionListWithData:(NSNumber *)fid {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_queryVersionList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_queryVersionList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 共享 */
-(void)requestShareFileLibarayWithData:(NSNumber *)fid shareBy:(NSString *)shareBy {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    if (shareBy) {
        
        [dict setObject:shareBy forKey:@"share_by"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_shareFileLibaray];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_shareFileLibaray
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 取消共享 */
-(void)requestCancelShareWithData:(NSNumber *)fid {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_cancelShare];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_cancelShare
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 退出共享 */
-(void)requestQuitShareWithData:(NSNumber *)fid {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_quitShare];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_quitShare
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 点赞 */
-(void)requestWhetherFabulousWithData:(NSNumber *)fid status:(NSNumber *)status {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    if (status) {
        
        [dict setObject:status forKey:@"status"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_whetherFabulous];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_whetherFabulous
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 搜索记录 */
-(void)requestBlurSearchFileWithData:(NSNumber *)fid content:(NSString *)content fileId:(NSNumber *)fileId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fid) {
        
        [dict setObject:fid forKey:@"style"];
    }
    if (content) {
        
        [dict setObject:content forKey:@"content"];
    }
    if (fileId) {
        
        [dict setObject:content forKey:@"fileId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_blurSearchFile];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_blurSearchFile
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 搜索 */
-(void)requestGetBlurResultParentInfoWithData:(NSNumber *)fid {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getBlurResultParentInfo];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getBlurResultParentInfo
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 重命名 */
-(void)requestEditRenameWithData:(NSNumber *)fid fname:(NSString *)fname {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    if (fname) {
        
        [dict setObject:fname forKey:@"name"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_editRename];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_editRename
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 删除管理员 */
-(void)requestDelManageStaffWithData:(NSNumber *)fid managerId:(NSNumber *)managerId fileLevel:(NSNumber *)fileLevel {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    if (managerId) {
        
        [dict setObject:managerId forKey:@"manage_id"];
    }
    if (fileLevel) {
        
        [dict setObject:fileLevel forKey:@"file_leve"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_delManageStaff];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_delManageStaff
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 添加成员 */
-(void)requestSavaMemberWithData:(NSNumber *)fid memberId:(NSString *)memberId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    if (memberId) {
        
        [dict setObject:memberId forKey:@"member_id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_savaMember];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_savaMember
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 删除成员 */
-(void)requestDelMemberWithData:(NSNumber *)fid memberId:(NSNumber *)memberId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    if (memberId) {
        
        [dict setObject:memberId forKey:@"member_id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_delMember];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_delMember
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 成员权限 */
-(void)requestUpdateSettingWithData:(NSArray *)authArr folderId:(NSNumber *)folderId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (authArr) {
        
        [dict setObject:authArr forKey:@"data"];
    }
    if (folderId) {
        
        [dict setObject:folderId forKey:@"id"];
    }
    NSString *url = [super urlFromCmd:HQCMD_updateSetting];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_updateSetting
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 复制文件 */
-(void)requestCopyFileLibraryWithData:(NSNumber *)folderId targetId:(NSNumber *)targetId style:(NSNumber *)style {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (folderId) {
        
        [dict setObject:folderId forKey:@"worn_id"];
    }
    if (targetId) {
        
        [dict setObject:targetId forKey:@"current_id"];
    }
    if (style) {
        
        [dict setObject:style forKey:@"style"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_copyFileLibrary];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_copyFileLibrary
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 员工信息 */
-(void)requestQueryEmployeeInfoWithData:(NSNumber *)empId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (empId) {
        
        [dict setObject:empId forKey:@"sign_id"];
    }

    
    NSString *url = [super urlFromCmd:HQCMD_queryEmployeeInfo];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_queryEmployeeInfo
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 员工点赞 */
-(void)requestEmpWhetherFabulousWithData:(NSNumber *)empId status:(NSNumber *)status {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (empId) {
        
        [dict setObject:empId forKey:@"id"];
    }
    if (status) {
        
        [dict setObject:status forKey:@"status"];
    }
//    {
//        "id":25,
//        "status":0,  0取消  1点赞
//    }
    NSString *url = [super urlFromCmd:HQCMD_empWhetherFabulous];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_empWhetherFabulous
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 下载历史版本 */
-(void)requestDownloadHistoryFileWithData:(NSNumber *)fid {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_downloadHistoryFile];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_downloadHistoryFile
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 应用文件根目录列表 */
-(void)requestQueryAppFileListWithData:(NSNumber *)style pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (style) {
        
        [dict setObject:style forKey:@"style"];
    }
    if (pageNum) {
        
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_queryAppFileList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_queryAppFileList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 应用文件根目录列表 */
-(void)requestQueryModuleFileListWithData:(NSNumber *)style pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize fid:(NSNumber *)fid {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (style) {
        
        [dict setObject:style forKey:@"style"];
    }
    if (pageNum) {
        
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_queryModuleFileList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_queryModuleFileList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 应用模块下文件 */
-(void)requestQueryModulePartFileListWithData:(NSNumber *)style pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize fid:(NSNumber *)fid {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (style) {
        
        [dict setObject:style forKey:@"style"];
    }
    if (pageNum) {
        
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    if (fid) {
        
        [dict setObject:fid forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_queryModulePartFileList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_queryModulePartFileList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 项目文件项目列表 */
-(void)requestProjectLibraryQueryProjectLibraryListWithData:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if (pageNum) {
        
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        
        [dict setObject:pageSize forKey:@"pageSize"];
    }

    
    NSString *url = [super urlFromCmd:HQCMD_projectLibraryQueryProjectLibraryList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_projectLibraryQueryProjectLibraryList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 是否为文件库管理员 */
-(void)requestFileAdministrator{
    
    NSString *url = [super urlFromCmd:HQCMD_fileAdministrator];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_fileAdministrator
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

#pragma mark - Response
- (void)requestManager:(HQRequestManager *)manager sequenceID:(NSInteger)sid didCompleteWithData:(id)data cmdId:(HQCMD)cmdId{
    BOOL result = [super requestManager:manager commonData:data sequenceID:sid cmdId:cmdId];
    HQResponseEntity *resp = nil;
    
    if (result) {
        switch (cmdId) {
                
            case HQCMD_queryfileCatalog:// 菜单列表
            {
                
                NSArray *arr = data[kData];

                NSMutableArray *array = [NSMutableArray array];

                for (NSDictionary *dic in arr) {

                    TFFolderMenuModel *model = [[TFFolderMenuModel alloc] initWithDictionary:dic error:nil];

                    [array addObject:model];
                }
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;

            case HQCMD_savaFileLibrary:// 新增文件夹
            {

                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_queryCompanyList:// 根目录列表
            {
                
                NSDictionary *dic = data[kData];
                
                TFMainListModel *model = [[TFMainListModel alloc] initWithDictionary:dic error:nil];
//                NSArray *arr = [dic valueForKey:@"dataList"];
//                
//                NSMutableArray *array = [NSMutableArray array];
//                
//                for (NSDictionary *dic in arr) {
//                    
//                    TFFolderListModel *model = [[TFFolderListModel alloc] initWithDictionary:dic error:nil];
//                    
//                    [array addObject:model];
//                }
//                
//                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;

            case HQCMD_queryCompanyPartList:// 子级列表
            {
                
                NSDictionary *dic = data[kData];
                
                TFMainListModel *model = [[TFMainListModel alloc] initWithDictionary:dic error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
                
            }
                break;
                
            case HQCMD_delFileLibrary:// 删除文件夹
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_editFolder:// 管理文件夹
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_shiftFileLibrary:// 移动文件夹
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_queryFolderInitDetail:// 成员信息
            {
                NSDictionary *dic = data[kData];
                
                TFManagePersonsModel *model = [[TFManagePersonsModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_queryManageById:// 获取管理员列表
            {
                NSArray *arr = data[kData];
                
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFManageItemModel *model = [[TFManageItemModel alloc] initWithDictionary:dict error:nil];
                    
                    [array addObject:model];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
                
            }
                break;
                
            case HQCMD_savaManageStaff:// 添加管理员
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_queryDownLoadList:// 下载记录
            {
                
                NSArray *arr = data[kData];
                
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFDownloadRecordModel *model = [[TFDownloadRecordModel alloc] initWithDictionary:dict error:nil];
                    
                    [array addObject:model];
                }
                
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
                
            case HQCMD_queryVersionList:// 历史版本
            {
                NSArray *arr = data[kData];
                
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFFolderListModel *model = [[TFFolderListModel alloc] initWithDictionary:dict error:nil];
                    
                    [array addObject:model];
                }

                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
                
            case HQCMD_shareFileLibaray:// 共享
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_cancelShare:// 取消共享
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_quitShare:// 退出共享
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_whetherFabulous:// 点赞
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_fileLibraryUpload://上传文件
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_FileVersionUpload://上传新版本
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_blurSearchFile://搜索记录
            {
                NSArray *arr = data[kData];
                
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFFolderListModel *model = [[TFFolderListModel alloc] initWithDictionary:dict error:nil];
                    
                    [array addObject:model];
                }
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
                
            case HQCMD_getBlurResultParentInfo://
            {
                
                NSArray *arr = data[kData];
                
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFFolderListModel *model = [[TFFolderListModel alloc] initWithDictionary:dict error:nil];
                    
                    [array addObject:model];
                }
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
                
            case HQCMD_queryFileLibarayDetail://文件详情
            {
                NSDictionary *dic = data[kData];
                
                TFFileDetailModel *model = [[TFFileDetailModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_editRename://重命名
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_delManageStaff://删除管理员
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_savaMember://添加成员
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_delMember://删除成员
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_updateSetting://成员权限
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_copyFileLibrary:// 复制文件
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_downloadHistoryFile:// 下载历史文件
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_queryEmployeeInfo:// 员工信息
            {
                NSDictionary *dic = data[kData];
                
                TFEmpInfoModel *model = [[TFEmpInfoModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_empWhetherFabulous:// 员工点赞
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_queryAppFileList:// 应用文件根目录列表
            {
                
                NSDictionary *dic = data[kData];
                
                TFMainListModel *model = [[TFMainListModel alloc] initWithDictionary:dic error:nil];
              
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_queryModuleFileList:// 应用模块文件夹
            {
                
                NSDictionary *dic = data[kData];
                
                TFMainListModel *model = [[TFMainListModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_queryModulePartFileList:// 应用模块下文件
            {
                
                NSDictionary *dic = data[kData];
                
                TFMainListModel *model = [[TFMainListModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_projectLibraryQueryProjectLibraryList:  // 文件库项目列表
            {
                NSDictionary *dic = data[kData];
                
                TFProjectFileMainModel *model = [[TFProjectFileMainModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                case HQCMD_fileAdministrator:
            {
                NSDictionary *dic = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dic];
            }
                break;
            default:
                break;
        }
        
        [super succeedCallbackWithResponse:resp];
    }
}


@end
