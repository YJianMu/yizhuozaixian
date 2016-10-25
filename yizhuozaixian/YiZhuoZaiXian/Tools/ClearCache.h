//
//  ClearCache.h
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/18.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClearCache : NSObject

///获取缓存文件路径
+(NSString *)getCachesPath;
///清除缓存
+ (void)clear:(NSString *)url;
///计算缓存文件的大小的M
+ (CGFloat)folderSizeAtPath:(NSString *)folderPath;

@end
