//
//  TFFileBL.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseBL.h"
#import "TFAddFileModel.h"

@interface TFFileBL : HQBaseBL

/** 菜单列表 */
-(void)requestQueryfileCatalogWithData;

/** 新建文件夹 */
-(void)requestSavaFileLibraryWithData:(TFAddFileModel *)model;

/** 根目录列表 */
-(void)requestQueryCompanyListWithData:(NSNumber *)style pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize sign:(NSNumber *)sign;

/** 子目录列表 */
-(void)requestQueryCompanyPartListWithData:(NSNumber *)style parentId:(NSNumber *)parentId pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize sign:(NSNumber *)sign;

/** 删除文件夹 */
-(void)requestDelFileLibraryWithData:(NSNumber *)fid;

/** 修改文件夹 */
-(void)requestEditFolderWithData:(NSNumber *)fid name:(NSString *)name color:(NSString *)color;

/** 移动文件夹 */
-(void)requestShiftFileLibraryWithData:(NSNumber *)folderId targetId:(NSNumber *)targetId style:(NSNumber *)style;

/** 获取根目录人员信息 */
-(void)requestQueryFolderInitDetailWithData:(NSNumber *)style folderId:(NSNumber *)folderId;

/** 上传文件 */
-(void)requestFileLibraryUploadWithData:(NSNumber *)folderId folderUrl:(NSString *)folderUrl type:(NSNumber *)type datas:(NSArray *)datas;

/** 上传新版本 */
-(void)requestFileVersionUploadWithData:(NSNumber *)folderId folderUrl:(NSString *)folderUrl type:(NSNumber *)type datas:(NSArray *)datas;

/** 获取管理员列表 */
-(void)requestQueryManageByIdWithData:(NSNumber *)folderId;

/** 添加管理员 */
-(void)requestSavaManageStaffWithData:(NSNumber *)folderId manage:(NSString *)manage fileLevel:(NSNumber *)fileLevel;

/** 文件下载 */
-(void)requestFileDownloadWithData:(NSNumber *)fid;

/** 文件详情 */
-(void)requestQueryFileLibarayDetailWithData:(NSNumber *)fid;

/** 下载记录 */
-(void)requestQueryDownLoadListWithData:(NSNumber *)fid;

/** 历史版本 */
-(void)requestQueryVersionListWithData:(NSNumber *)fid;

/** 共享 */
-(void)requestShareFileLibarayWithData:(NSNumber *)fid shareBy:(NSString *)shareBy;

/** 取消共享 */
-(void)requestCancelShareWithData:(NSNumber *)fid;

/** 退出共享 */
-(void)requestQuitShareWithData:(NSNumber *)fid;

/** 点赞 */
-(void)requestWhetherFabulousWithData:(NSNumber *)fid status:(NSNumber *)status;

/** 搜索记录 */
-(void)requestBlurSearchFileWithData:(NSNumber *)fid content:(NSString *)content fileId:(NSNumber *)fileId;

/** 搜索 */
-(void)requestGetBlurResultParentInfoWithData:(NSNumber *)fid;

/** 重命名 */
-(void)requestEditRenameWithData:(NSNumber *)fid fname:(NSString *)fname;

/** 删除管理员 */
-(void)requestDelManageStaffWithData:(NSNumber *)fid managerId:(NSNumber *)managerId fileLevel:(NSNumber *)fileLevel;

/** 添加成员 */
-(void)requestSavaMemberWithData:(NSNumber *)fid memberId:(NSString *)memberId;

/** 删除成员 */
-(void)requestDelMemberWithData:(NSNumber *)fid memberId:(NSNumber *)memberId;

/** 成员权限 */
-(void)requestUpdateSettingWithData:(NSArray *)authArr folderId:(NSNumber *)folderId;

/** 复制文件 */
-(void)requestCopyFileLibraryWithData:(NSNumber *)folderId targetId:(NSNumber *)targetId style:(NSNumber *)style;

/** 员工信息 */
-(void)requestQueryEmployeeInfoWithData:(NSNumber *)empId;

/** 员工点赞 */
-(void)requestEmpWhetherFabulousWithData:(NSNumber *)empId status:(NSNumber *)status;

/** 下载历史版本 */
-(void)requestDownloadHistoryFileWithData:(NSNumber *)fid;

/** 应用文件根目录列表 */
-(void)requestQueryAppFileListWithData:(NSNumber *)style pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize;

/** 应用文件根目录列表 */
-(void)requestQueryModuleFileListWithData:(NSNumber *)style pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize fid:(NSNumber *)fid;

/** 应用模块下文件 */
-(void)requestQueryModulePartFileListWithData:(NSNumber *)style pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize fid:(NSNumber *)fid;

/** 项目文件项目列表 */
-(void)requestProjectLibraryQueryProjectLibraryListWithData:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize;

/** 是否为文件库管理员 */
-(void)requestFileAdministrator;

@end
