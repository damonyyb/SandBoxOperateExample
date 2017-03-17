//
//  SandBoxOperate.h
//  HeraldleasingWorkAssistant
//
//  Created by yyb on 16/5/18.
//  Copyright © 2016年 mesada. All rights reserved.
//
#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
/**
 *  缓存文件类型
 */
typedef NS_ENUM(NSInteger, CachesType) {
    /**
     *  图像
     */
    PhotoType = 0,
    /**
     *  音频
     */
    AudioType,
    /**
     *  视频
     */
    VideoType,
    /**
     *  其他
     */
    OtherType
};


@interface SandBoxOperate : NSObject
/**
 *  添加删除文件结果
 *
 *  @param success 是否成功
 *  @param error   错误信息
 */
typedef void(^resultBlock)(BOOL success,NSError *error);
/**
 *  清除缓存 block
 *
 *  @param success    是否成功
 *  @param error      错误信息
 *  @param cachesSize 缓存大小
 */
typedef void(^clearResultBlock)(BOOL success,NSError *error,long long  cachesSize);


@property (nonatomic, copy , readonly) NSString           *               localPath;
/**
 *  初始化
 *
 *  @param type       CachesType 缓存文件类型
 *  @param folderName 缓存文件夹名称
 *
 *  @return 返回SandBoxOperate对象
 */
+ (instancetype)createCachesPathWithType:(CachesType)type Folder:(NSString *)folderName;
/**
 *  添加文件
 *
 *  @param data         文件数据
 *  @param name         文件名
 *  @param block        resultBlock
 */
- (void)addFileToCachesPath:(NSData *)data andName:(NSString *)name andResultBlock:(resultBlock)block;
/**
 *  删除文件
 *
 *  @param name         文件名
 *  @param block       resultBlock
 */
- (void)deletedFileFromCachesPath:(NSString *)name andResultBlock:(resultBlock)block;
/**
 *  读取文件
 *
 *  @param name 文件名
 *
 *  @return     文件数据
 */
- (NSData *)readFileFromCachesPath:(NSString *)name;
/**
 *  缓存文件夹大小
 *
 *  @return     KB
 */
- (long long)cachesSize;
/**
 *  清除缓存
 *
 *  @param block
 */
- (void)clearCaches:(clearResultBlock)block;

@end
