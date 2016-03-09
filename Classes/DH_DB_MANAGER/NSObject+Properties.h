//
//  NSObject+Properties.h
//  http
//
//  Created by xy2 on 16/3/2.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface NSObject (Properties)


@property (nonatomic, strong) NSDictionary *mapDictionary;

- (void)setDataDictionary:(NSDictionary*)dataDictionary;
- (NSDictionary *)dataDictionary;

@end
