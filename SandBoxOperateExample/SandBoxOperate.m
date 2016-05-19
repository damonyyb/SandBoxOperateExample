//
//  SandBoxOperate.m
//  HeraldleasingWorkAssistant
//
//  Created by yyb on 16/5/18.
//  Copyright © 2016年 mesada. All rights reserved.
//

#import "SandBoxOperate.h"

@interface SandBoxOperate()

@property (nonatomic , copy) NSString           *               localPath;
#define PHOTOTYPE  @"PhotoType"
#define AUDIOTYPE  @"AudioType"
#define VIDEOTYPE  @"VideoType"
#define OTHERTYPE  @"OtherType"
#define CACHES     @"Caches"
@end

@implementation SandBoxOperate


+ (instancetype)createCachesPathWithType:(CachesType)type Folder:(NSString *)folderName{
    SandBoxOperate * operate = [[SandBoxOperate alloc] initWithType:type Folder:folderName];
    NSString *cachesPath = [operate filesPathDir];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:cachesPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return operate;
}

-(instancetype)initWithType:(CachesType)type Folder:(NSString *)folderName{
    self = [self init];
    if (self) {
        NSString *floderType = @"";
        switch (type) {
            case PhotoType:
                floderType =PHOTOTYPE;
                break;
            case AudioType:
                floderType =AUDIOTYPE;
                break;
            case VideoType:
                floderType =OTHERTYPE;
                break;
            case OtherType:
                floderType =OTHERTYPE;
            default:
                break;
        }
        if (folderName) {
           _localPath = [NSString stringWithFormat:@"/%@/%@/%@/",CACHES,floderType,folderName];
        }else{
           _localPath = [NSString stringWithFormat:@"/%@/%@/",CACHES,floderType];
        }
        
        
    }
    
    return self;
}
- (void)addFileToCachesPath:(NSData *)data andName:(NSString *)name andResultBlock:(resultBlock)block{
    NSString *fileCachePath =[self fileCachesPath:name];
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        BOOL success=[data writeToFile:fileCachePath options:NSDataWritingAtomic error:&error];
        if (block) {
            block(success,error);
        }
    });
}
- (void)deletedFileFromCachesPath:(NSString *)name andResultBlock:(resultBlock)block{
    NSString *fileCachePath =[self fileCachesPath:name];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:fileCachePath];
    if (!blHave) {
        if (block) {
            block(NO,[[NSError alloc]initWithDomain:@"文件不存在路径中" code:0 userInfo:nil]);
            
        }
        return ;
    }else {
        NSError *error = nil;
        BOOL blDele= [fileManager removeItemAtPath:fileCachePath error:&error];
        if (block) {
            block(blDele,error);
        }
    }
    
}
- (NSData *)readFileFromCachesPath:(NSString *)name{
    NSString *fileCachePath =[self fileCachesPath:name];
   if ([[NSFileManager defaultManager] fileExistsAtPath:fileCachePath]) {
        NSData *data = [NSData dataWithContentsOfFile:fileCachePath];
       return data;
    }
    return nil;
}
- (NSString *)fileCachesPath:(NSString *)name{
    NSString *filePathDir = [self filesPathDir];
    NSString *fileCachePath =[filePathDir stringByAppendingString:name];
    return fileCachePath;
    
}
- (NSString *)filesPathDir{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,  NSUserDomainMask, YES);
    NSString *filePathDir = [[paths objectAtIndex:0] stringByAppendingString:self.localPath];
    return filePathDir;
    
}
- (long long)cachesSize{
    NSString *filePathDir = [self filesPathDir];
    long long KB = [self folderSizeAtPath:filePathDir];
    
    return KB;
}
- (void)clearCaches:(clearResultBlock)block{
    NSString *filePathDir = [self filesPathDir];
    NSFileManager *manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:filePathDir])
    {
        if (block) {
            block(NO,[[NSError alloc]initWithDomain:@"文件夹不存在" code:0 userInfo:nil],0);
            return;
        }
    }
    unsigned long long folderSize = 0;
    
    NSArray *arr = [manager contentsOfDirectoryAtPath:filePathDir error:nil];
    
    for(NSString *fileName in arr){
        
        NSString *path = [filePathDir stringByAppendingPathComponent:fileName];
        
        BOOL isDir = NO;
        
        BOOL bRet = [manager fileExistsAtPath:path isDirectory:&isDir];
        
        if(bRet){
            
            if (isDir) {
                folderSize += [self folderSizeAtPath:path];
                
            }else{
                folderSize += [self fileSizeAtPath:path];
            }
            [manager removeItemAtPath:path error:nil];
        }
        
    }
    if (block) {
        block(YES,nil,folderSize);
        return;
    }
    
    
}

- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    unsigned long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize;
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        NSLog(@"%llu",[[manager attributesOfItemAtPath:filePath error:nil] fileSize]);
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    return 0;
}



@end
