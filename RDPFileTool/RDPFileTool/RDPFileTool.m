//
//  RDPFileTool.m
//
//  Created by DongpoRen on 15/7/18.
//  Copyright © 2015年 DongpoRen. All rights reserved.
//

#import "RDPFileTool.h"


@implementation RDPFileTool

+ (void)getFileSizeAtPath:(NSString *)filePath completed:(void (^)(NSString *))completed {

    NSFileManager *manager = [NSFileManager defaultManager];
    
    /*********** 将耗时操作放在子线程中执行 **********/
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 获得所有文件,子文件的子文件
        NSArray *filePaths = [manager subpathsAtPath:filePath];
        
        // 计算所有文件的总大小
        CGFloat totalSize = 0;
        for (NSString *subfilePath in filePaths) {
            
            NSString *fullPath = [filePath stringByAppendingPathComponent:subfilePath];
            
            BOOL isDirectory = NO;
            BOOL isExist = [manager fileExistsAtPath:fullPath isDirectory:&isDirectory];
            
            // 清除文件夹及缓存文件
            if (!isExist || isDirectory || [fullPath containsString:@".DS"]) {
                continue;
            }
            
            // 获得文件的大小
            NSDictionary *dict = [manager attributesOfItemAtPath:fullPath error:nil];
            
            totalSize += [dict fileSize];
        }
        
        // 将数据的处理放置于工具类中
        NSString *cacheStr = [self handleDataWithSize:totalSize];
        
        /*********** 将展示(传递)信息放在主线程中 **********/
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completed) {
                completed(cacheStr);
            }
        });
    });
}

#pragma mark - 内部处理数据
+ (NSString *)handleDataWithSize:(CGFloat)totalSize {
    
    CGFloat unit = 1000.0;
    NSString *cacheStr = @"";
    if (totalSize >= unit * unit) {
        cacheStr = [NSString stringWithFormat:@"%.1f MB",totalSize / (unit * unit)];
    } else if(totalSize >= unit) {
        cacheStr = [NSString stringWithFormat:@"%.1f KB",totalSize / unit];
    } else {
        cacheStr = [NSString stringWithFormat:@"%.1f B",totalSize];
    }
    
    return cacheStr;
}

#pragma mark - 清理缓存
+ (void)clearCacheWithFilePath:(NSString *)filePath completed:(void (^)(BOOL))completed {
    
    // 在子线程中执行耗时操作
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        
        NSFileManager *manager = [NSFileManager defaultManager];
        NSError *contentError = nil;
        NSArray *array = [manager contentsOfDirectoryAtPath:filePath error:&contentError];
        if (contentError) {
            [self clearSuccess:NO completed:completed];
            return;
        }
        
        // 默认为yes,考虑到array可能为nil.
        BOOL isSuccess = YES;
        for (NSString *subFile in array) {
            
            NSString *fullPath = [filePath stringByAppendingPathComponent:subFile];
            isSuccess = [manager removeItemAtPath:fullPath error:nil];
            if (!isSuccess) {
                [self clearSuccess:NO completed:completed]
                break;
            }
        }
        [self clearSuccess:isSuccess completed:completed];
    }];
}

- (void)clearSuccess:(BOOL)isSuccess completed:(void (^)(BOOL))completed
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (completed) {
            completed(isSuccess);
        }
    }];
}

@end
