//
//  Term.h
//  Alfy
//
//  Created by Ben Hambrecht on 27.03.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Term

@property (nonatomic) CGRect frame;

- (float)value;
- (BOOL)dependsOnTerm:(id <Term>)term;
- (BOOL)isAVariable;
- (BOOL)isAConstant;
- (BOOL)isComposed;
- (NSString *)formula;
- (NSString *)outermostOperator;

@end
