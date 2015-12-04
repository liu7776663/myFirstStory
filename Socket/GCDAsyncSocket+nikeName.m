//
//  GCDAsyncSocket+nikeName.m
//  Socket
//
//  Created by MS on 15-12-2.
//  Copyright (c) 2015年 刘贺明. All rights reserved.
//

#import "GCDAsyncSocket+nikeName.h"
#import <objc/runtime.h>
static void *nikeNameKey=@"NIKENAME";
@implementation GCDAsyncSocket (nikeName)

-(void)setNikeName:(NSString *)nikeName
{
    objc_setAssociatedObject(self, nikeNameKey, nikeName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)nikeName
{
    return objc_getAssociatedObject(self, nikeNameKey);
}
@end
