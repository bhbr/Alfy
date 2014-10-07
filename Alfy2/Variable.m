//
//  Variable.m
//  Alfy2
//
//  Created by Ben Hambrecht on 20.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "Variable.h"

@implementation Variable

@synthesize minValue;
@synthesize maxValue;
@synthesize value;
@synthesize name;

@synthesize frame;


- (instancetype)init {
    self = [super init];
    self.minValue = -1;
    self.maxValue = 1;
    self.value = 0;
    self.frame = CGRectZero;
    self.name = [@"x" mutableCopy];
    return self;
}



- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    float originX = [aDecoder decodeFloatForKey:@"originX"];
    float originY = [aDecoder decodeFloatForKey:@"originY"];
    float width = [aDecoder decodeFloatForKey:@"width"];
    float height = [aDecoder decodeFloatForKey:@"height"];
    self.frame = CGRectMake(originX,originY,width,height);
    self.minValue = [aDecoder decodeFloatForKey:@"minValue"];
    self.maxValue = [aDecoder decodeFloatForKey:@"maxValue"];
    self.value = [aDecoder decodeFloatForKey:@"value"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeFloat:self.frame.origin.x forKey:@"originX"];
    [aCoder encodeFloat:self.frame.origin.y forKey:@"originY"];
    [aCoder encodeFloat:self.frame.size.width forKey:@"width"];
    [aCoder encodeFloat:self.frame.size.height forKey:@"height"];
    [aCoder encodeFloat:self.minValue forKey:@"minValue"];
    [aCoder encodeFloat:self.maxValue forKey:@"maxValue"];
    [aCoder encodeFloat:self.value forKey:@"value"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

- (BOOL)dependsOnTerm:(id<Term>)term {
    return (term == self);
}

- (BOOL)isAVariable {
    return YES;
}

- (BOOL)isAConstant {
    return NO;
}

- (BOOL)isComposed {
    return NO;
}

- (NSString *)formula {
    NSMutableString *returnString = [@"<mi>" mutableCopy];
    [returnString appendString:self.name];
    [returnString appendString:@"</mi>"];
    return returnString;
}

- (NSString *)outermostOperator {
    return nil;
}


@end
