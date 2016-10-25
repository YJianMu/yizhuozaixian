//
//  ClearCache.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/18.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "ClearCache.h"

@implementation ClearCache


//获取缓存文件路径
+(NSString *)getCachesPath{
    
    // 获取Caches目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *cachesDir = [paths objectAtIndex:0];
    
    return cachesDir;
}
//清除缓存
+ (void)clear:(NSString *)url{
    
    NSFileManager *manager=[NSFileManager defaultManager];
    
    [manager removeItemAtPath:url error:nil];
    
    NSString *imageDir = [NSString stringWithFormat:@"%@/Library/Caches", NSHomeDirectory()];
    BOOL isDir = NO;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [manager fileExistsAtPath:imageDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [manager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }

    
    /*
     dispatch_async(
     dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
     , ^{
     NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
     
     NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
     NSLog(@"files :%lu",(unsigned long)[files count]);
     for (NSString *p in files) {
     NSError *error;
     NSString *path = [cachPath stringByAppendingPathComponent:p];
     if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
     [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
     }
     }
     [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
         -(void)clearCacheSuccess
         {
             NSLog(@"清除缓存");
         }

     
     });
    */
    
}


///便利文件夹下的所以子文件夹
+ (CGFloat)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];//从前向后枚举器
    
    NSString *fileName = nil;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

///计算缓存文件的大小 MB
+ (long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
    
}


@end
