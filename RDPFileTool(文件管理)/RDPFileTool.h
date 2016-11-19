//
//  RDPFileTool.h
//  RDPBuDeJie
//
//  Created by DongpoRen on 16/11/18.
//  Copyright © 2016年 DongpoRen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDPFileTool : NSObject

+ (void)getFileSizeAtPath:(NSString *)filePath completed:(void(^)(NSString * cacheStr))completed;


+ (void)cleanCacheWithFilePath:(NSString *)filePath completed:(void(^)(BOOL isSuccess))completed;

@end
