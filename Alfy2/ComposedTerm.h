//
//  ComposedTerm.h
//  Alfy2
//
//  Created by Ben Hambrecht on 25.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Term.h"


@class Variable;


@protocol VariableFetcher

- (Variable *)variableWithName:(NSString *)name;

@end


@interface ComposedTerm : NSObject <NSCoding, Term>

@property (nonatomic) NSMutableArray *parents;
@property (nonatomic) NSMutableString *operatorString;

@property (nonatomic) id <VariableFetcher> variableFetcher;


- (instancetype)initWithParents:(NSArray *)parents andOperator:(NSString *)operatorString;
- (instancetype)initWithFormulaString:(NSString *)formulaString andVariableFetcher:(id <VariableFetcher>)aFetcher;


@end
