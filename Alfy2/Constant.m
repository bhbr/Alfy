//
//  Constant.m
//  Alfy
//
//  Created by Ben Hambrecht on 06.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "Constant.h"

@implementation Constant

@synthesize frame;
@synthesize value;


- (instancetype)init {
    self = [super init];
    self.value = 0;
    self.frame = CGRectZero;
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    float originX = [aDecoder decodeFloatForKey:@"originX"];
    float originY = [aDecoder decodeFloatForKey:@"originY"];
    float width = [aDecoder decodeFloatForKey:@"width"];
    float height = [aDecoder decodeFloatForKey:@"height"];
    self.frame = CGRectMake(originX,originY,width,height);
    self.value = [aDecoder decodeFloatForKey:@"value"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeFloat:self.frame.origin.x forKey:@"originX"];
    [aCoder encodeFloat:self.frame.origin.y forKey:@"originY"];
    [aCoder encodeFloat:self.frame.size.width forKey:@"width"];
    [aCoder encodeFloat:self.frame.size.height forKey:@"height"];
    [aCoder encodeFloat:self.value forKey:@"value"];
}

- (BOOL)dependsOnTerm:(id<Term>)term {
    return (term == self);
}

- (BOOL)isAVariable {
    return NO;
}

- (BOOL)isAConstant {
    return YES;
}

- (BOOL)isComposed {
    return NO;
}


- (NSString *)formula {
    NSMutableString *returnString = [@"<mn>" mutableCopy];
    [returnString appendString:[NSString stringWithFormat:@"%g", self.value]];
    [returnString appendString:@"</mn>"];
    return returnString;
}

- (NSString *)outermostOperator {
    return nil;
}

@end
