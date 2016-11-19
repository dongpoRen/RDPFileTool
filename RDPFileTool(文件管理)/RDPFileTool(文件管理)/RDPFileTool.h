//
//  RDPFileTool.h
//  RDPBuDeJie
//
//  Created by DongpoRen on 15/7/18.
//  Copyright © 2015年 DongpoRen. All rights reserved.
//
// 该工具类主要包括,获得缓存和清除缓存两大块,都是通过子线程计算,然后在主线程通过block实现回调传值的操作,大大优化了界面的性能等.


#import <Foundation/Foundation.h>

@interface RDPFileTool : NSObject

/**
 *  获取给定路径下的所有文件的大小
 *
 *  @param filePath  传入的文件地址
 *  @param completed 完成之后的回调
 */

+ (void)getFileSizeAtPath:(NSString *)filePath completed:(void(^)(NSString * cacheStr))completed;


/**
 *  清除缓存
 *
 *  @param filePath  清除该文件下的所有内容
 *  @param completed 完成之后的回调
 */
+ (void)cleanCacheWithFilePath:(NSString *)filePath completed:(void(^)(BOOL isSuccess))completed;

@end
