//
//  NSData+Compression.h
//  TaskListRAV
//
//  Created by Marco S. Graciano on 3/14/13.
//  Copyright (c) 2013 MSG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Compression)

- (NSData *)gzipInflate:(NSData*)data;
- (NSData *)gzipDeflate:(NSData*)data;
- (NSData *)zlibInflate:(NSData*)data;
- (NSData *)zlibDeflate:(NSData*)data;

@end
